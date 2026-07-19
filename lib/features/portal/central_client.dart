import 'dart:async';
import 'dart:convert';
import 'dart:io' show gzip;

import 'package:http/http.dart' as http;

import '../../shared/platform/device_meta.dart';
import '../access/access_config.dart';

/// A FIR the server says was deleted centrally, with the identity of the record
/// that was deleted. [uid] alone can't be trusted: records created before the
/// stable-uid migration were uploaded under their local row id ("1", "2", …),
/// so the same uid means different FIRs on different devices. Matching
/// [firNo]/[year] as well makes a purge safe on a restored or reinstalled PC.
class SuppressedRecord {
  const SuppressedRecord({
    required this.uid,
    this.firNo,
    this.year,
    this.policeStation,
  });

  final String uid;
  final String? firNo;
  final int? year;
  final String? policeStation;

  /// True when the server told us which FIR this tombstone refers to, i.e. the
  /// local copy can be identity-checked before it is deleted.
  bool get hasIdentity => (firNo ?? '').trim().isNotEmpty;
}

/// HTTP client for the central officer-portal API on Hostinger: station uploads
/// plus the read-only portal search / dashboard. All calls are gated by the
/// shared app key and identify the caller by their approved email.
class CentralClient {
  CentralClient({http.Client? httpClient})
      : _http = httpClient ?? http.Client();

  final http.Client _http;

  Uri _uri(String file) => Uri.parse('${AccessConfig.apiBaseUrl}/$file');
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'X-App-Key': AccessConfig.appKey,
      };

  /// Pushes a batch of station records to the central store. [defaultStation]
  /// tags records whose own police-station field is blank, so they still scope
  /// to a station. Returns the number saved, or null on failure (retry later).
  Future<int?> upload({
    required String email,
    required List<Map<String, dynamic>> records,
    String defaultStation = '',
  }) async {
    try {
      final meta = await clientDeviceMeta();
      // Gzip the body: FIR JSON compresses ~10:1, so a big import syncs in a
      // tenth of the time on a slow station uplink. The Go server (jsonBody)
      // decompresses transparently.
      final body = gzip.encode(utf8.encode(jsonEncode({
        'email': email,
        'records': records,
        'default_station': defaultStation,
        ...meta,
      })));
      final res = await _http
          .post(_uri('upload.php'),
              headers: {..._headers, 'Content-Encoding': 'gzip'}, body: body)
          // Big first-time chunks over a slow office uplink need headroom.
          .timeout(const Duration(seconds: 180));
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['ok'] == true) return (json['saved'] as num?)?.toInt() ?? 0;
      return null;
    } catch (_) {
      return null;
    }
  }

  /// This user's FIRs that were deleted on the server (admin panel). The app
  /// deletes its matching local copies so a server-side deletion isn't
  /// re-created on sync. Pass [since] to fetch only tombstones created after it
  /// (the frequent background poll). Returns an empty list on failure.
  Future<List<SuppressedRecord>> fetchSuppressed({
    required String email,
    DateTime? since,
  }) async {
    try {
      final res = await _http
          .post(_uri('suppressed.php'),
              headers: _headers,
              body: jsonEncode({
                'email': email,
                'since': ?since?.toUtc().toIso8601String(),
              }))
          .timeout(const Duration(seconds: 30));
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['ok'] != true) return const [];
      // Newer servers send "items" (uid + the deleted FIR's identity); fall
      // back to the bare "uids" list when talking to an older one.
      final items = json['items'] as List?;
      if (items != null) {
        return [
          for (final raw in items)
            if (raw is Map)
              SuppressedRecord(
                uid: (raw['uid'] ?? '').toString(),
                firNo: raw['fir_no']?.toString(),
                year: (raw['year'] as num?)?.toInt(),
                policeStation: raw['police_station']?.toString(),
              ),
        ];
      }
      return [
        for (final u in (json['uids'] as List? ?? []))
          SuppressedRecord(uid: u.toString()),
      ];
    } catch (_) {
      return const [];
    }
  }

  /// Reports that a FIR was deleted on this station, so the central copy is
  /// removed and the deletion is logged (who / what / which device) for the
  /// admin. Best-effort: returns true on success, false on any failure.
  Future<bool> reportDeletion({
    required String email,
    required String uid,
    String? firNo,
    int? year,
    String? policeStation,
  }) async {
    try {
      final meta = await clientDeviceMeta();
      final res = await _http
          .post(_uri('deletions.php'),
              headers: _headers,
              body: jsonEncode({
                'email': email,
                'uid': uid,
                'fir_no': ?firNo,
                'year': ?year,
                'police_station': ?policeStation,
                ...meta,
              }))
          .timeout(const Duration(seconds: 30));
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return json['ok'] == true;
    } catch (_) {
      return false;
    }
  }

  /// The scoped org tree (zones / divisions / stations the officer may see) that
  /// feeds the three cascading dropdowns and the comparison picker.
  Future<PortalScopeTree> scopeTree({required String email}) async {
    final res = await _http
        .post(_uri('portal_scope.php'),
            headers: _headers, body: jsonEncode({'email': email}))
        .timeout(const Duration(seconds: 30));
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['ok'] != true) return PortalScopeTree.empty;
    return PortalScopeTree.fromJson(json);
  }

  /// Side-by-side comparison KPIs for a set of stations ([by]='station') or ACP
  /// divisions ([by]='division'). Scope-enforced on the server.
  Future<List<PortalCompareRow>> compare({
    required String email,
    required String by,
    required List<int> ids,
  }) async {
    if (ids.isEmpty) return const [];
    final res = await _http
        .post(_uri('portal_compare.php'),
            headers: _headers,
            body: jsonEncode({'email': email, 'by': by, 'ids': ids}))
        .timeout(const Duration(seconds: 45));
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['ok'] != true) {
      throw Exception(json['message'] ?? 'portal.error');
    }
    return [
      for (final r in (json['rows'] as List? ?? []))
        PortalCompareRow.fromJson(r as Map<String, dynamic>),
    ];
  }

  /// Scope-filtered crime search for the officer portal.
  Future<PortalSearchResult> search({
    required String email,
    String query = '',
    int? year,
    String? status,
    String? crimeType,
    PortalScope? scope,
    int page = 1,
    int pageSize = 50,
  }) async {
    final body = <String, dynamic>{
      'email': email,
      'q': query,
      'page': page,
      'page_size': pageSize,
    };
    if (year != null) body['year'] = year;
    if (status != null && status.isNotEmpty) body['status'] = status;
    if (crimeType != null && crimeType.isNotEmpty) body['crime_type'] = crimeType;
    scope?.applyTo(body);
    final res = await _http
        .post(_uri('portal_search.php'), headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 30));
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['ok'] != true) {
      throw Exception(json['message'] ?? 'portal.error');
    }
    return PortalSearchResult(
      total: (json['total'] as num?)?.toInt() ?? 0,
      page: (json['page'] as num?)?.toInt() ?? 1,
      rows: [
        for (final r in (json['rows'] as List? ?? []))
          PortalCrime.fromJson(r as Map<String, dynamic>),
      ],
    );
  }

  /// All scope-filtered crime rows for the officer-portal analytics dashboard.
  /// Returned as raw maps; the caller maps them into the shared analytics model.
  Future<List<Map<String, dynamic>>> rows({
    required String email,
    PortalScope? scope,
  }) async {
    final body = <String, dynamic>{'email': email};
    scope?.applyTo(body);
    final res = await _http
        .post(_uri('portal_rows.php'),
            headers: _headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 60));
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['ok'] != true) {
      throw Exception(json['message'] ?? 'portal.error');
    }
    return [
      for (final r in (json['rows'] as List? ?? []))
        (r as Map).cast<String, dynamic>(),
    ];
  }

  void dispose() => _http.close();
}

/// A zone in the scoped org tree.
class PortalZone {
  const PortalZone({required this.id, required this.name});
  final int id;
  final String name;
  factory PortalZone.fromJson(Map<String, dynamic> j) =>
      PortalZone(id: (j['id'] as num).toInt(), name: (j['name'] ?? '').toString());
}

/// An ACP division (belongs to a zone).
class PortalDivision {
  const PortalDivision({required this.id, required this.name, this.zoneId});
  final int id;
  final String name;
  final int? zoneId;
  factory PortalDivision.fromJson(Map<String, dynamic> j) => PortalDivision(
        id: (j['id'] as num).toInt(),
        name: (j['name'] ?? '').toString(),
        zoneId: (j['zone_id'] as num?)?.toInt(),
      );
}

/// A police station (belongs to a division / zone).
class PortalStation {
  const PortalStation(
      {required this.id, required this.name, this.divisionId, this.zoneId});
  final int id;
  final String name;
  final int? divisionId;
  final int? zoneId;
  factory PortalStation.fromJson(Map<String, dynamic> j) => PortalStation(
        id: (j['id'] as num).toInt(),
        name: (j['name'] ?? '').toString(),
        divisionId: (j['division_id'] as num?)?.toInt(),
        zoneId: (j['zone_id'] as num?)?.toInt(),
      );
}

/// The scoped org tree returned by portal_scope.php.
class PortalScopeTree {
  const PortalScopeTree({
    required this.role,
    required this.zones,
    required this.divisions,
    required this.stations,
  });

  final String role;
  final List<PortalZone> zones;
  final List<PortalDivision> divisions;
  final List<PortalStation> stations;

  static const empty =
      PortalScopeTree(role: 'station', zones: [], divisions: [], stations: []);

  factory PortalScopeTree.fromJson(Map<String, dynamic> j) => PortalScopeTree(
        role: (j['role'] ?? 'station').toString(),
        zones: [
          for (final z in (j['zones'] as List? ?? []))
            PortalZone.fromJson(z as Map<String, dynamic>)
        ],
        divisions: [
          for (final d in (j['divisions'] as List? ?? []))
            PortalDivision.fromJson(d as Map<String, dynamic>)
        ],
        stations: [
          for (final s in (j['stations'] as List? ?? []))
            PortalStation.fromJson(s as Map<String, dynamic>)
        ],
      );
}

/// The effective single-select scope built from the three dropdowns. Sends the
/// most specific filter chosen (station > division > zone) to the server.
class PortalScope {
  const PortalScope({this.zoneId, this.divisionId, this.stationId});
  final int? zoneId;
  final int? divisionId;
  final int? stationId;

  bool get isAll => zoneId == null && divisionId == null && stationId == null;

  void applyTo(Map<String, dynamic> body) {
    if (stationId != null) {
      body['station_id'] = stationId;
    } else if (divisionId != null) {
      body['division_id'] = divisionId;
    } else if (zoneId != null) {
      body['zone_id'] = zoneId;
    }
  }
}

/// One entity's KPI bundle in a side-by-side comparison.
class PortalCompareRow {
  const PortalCompareRow({required this.id, required this.label, required this.kpi});
  final int id;
  final String label;
  final Map<String, num> kpi;

  num get total => kpi['total'] ?? 0;
  num get detected => kpi['detected'] ?? 0;
  num get undetected => kpi['undetected'] ?? 0;
  num get arrested => kpi['arrested'] ?? 0;
  num get wanted => kpi['wanted'] ?? 0;
  num get recovered => kpi['recovered'] ?? 0;
  num get chargesheeted => kpi['chargesheeted'] ?? 0;
  double get detectedPct => total == 0 ? 0 : (detected / total * 100);

  factory PortalCompareRow.fromJson(Map<String, dynamic> j) => PortalCompareRow(
        id: (j['id'] as num?)?.toInt() ?? 0,
        label: (j['label'] ?? '').toString(),
        kpi: {
          for (final e in ((j['kpi'] as Map?) ?? const {}).entries)
            e.key.toString(): (e.value as num? ?? 0),
        },
      );
}

class PortalSearchResult {
  PortalSearchResult({required this.total, required this.page, required this.rows});
  final int total;
  final int page;
  final List<PortalCrime> rows;
}

/// A single crime row returned by the portal search. [data] holds the full
/// record blob for the detail view / PDF.
class PortalCrime {
  PortalCrime({
    required this.id,
    this.stationName,
    this.firNo,
    this.year,
    this.crimeType,
    this.section,
    this.status,
    this.dateRegistered,
    this.data = const {},
  });

  final int id;
  final String? stationName;
  final String? firNo;
  final int? year;
  final String? crimeType;
  final String? section;
  final String? status;
  final String? dateRegistered;
  final Map<String, dynamic> data;

  factory PortalCrime.fromJson(Map<String, dynamic> j) => PortalCrime(
        id: (j['id'] as num?)?.toInt() ?? 0,
        stationName: j['station_name'] as String?,
        firNo: j['fir_no'] as String?,
        year: (j['year'] as num?)?.toInt(),
        crimeType: j['crime_type'] as String?,
        section: j['section'] as String?,
        status: j['status'] as String?,
        dateRegistered: j['date_registered'] as String?,
        data: (j['data'] as Map?)?.cast<String, dynamic>() ?? const {},
      );
}
