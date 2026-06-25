import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../shared/platform/device_meta.dart';
import '../access/access_config.dart';

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
      final res = await _http
          .post(_uri('upload.php'),
              headers: _headers,
              body: jsonEncode({
                'email': email,
                'records': records,
                'default_station': defaultStation,
                ...meta,
              }))
          .timeout(const Duration(seconds: 60));
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['ok'] == true) return (json['saved'] as num?)?.toInt() ?? 0;
      return null;
    } catch (_) {
      return null;
    }
  }

  /// The remote_uids of this user's FIRs that were deleted on the server (admin
  /// panel). The app deletes its matching local copies so a server-side deletion
  /// isn't re-created on sync. Returns an empty list on any failure.
  Future<List<String>> fetchSuppressed({required String email}) async {
    try {
      final res = await _http
          .post(_uri('suppressed.php'),
              headers: _headers, body: jsonEncode({'email': email}))
          .timeout(const Duration(seconds: 30));
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['ok'] != true) return const [];
      return [for (final u in (json['uids'] as List? ?? [])) u.toString()];
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

  /// The scope options the officer can drill into (All city / zone / division /
  /// station depending on rank), straight from the server.
  Future<List<PortalScopeOption>> scopeOptions({required String email}) async {
    final res = await _http
        .post(_uri('portal_scope.php'),
            headers: _headers, body: jsonEncode({'email': email}))
        .timeout(const Duration(seconds: 30));
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    if (json['ok'] != true) return const [];
    return [
      for (final o in (json['options'] as List? ?? []))
        PortalScopeOption.fromJson(o as Map<String, dynamic>),
    ];
  }

  /// Scope-filtered crime search for the officer portal.
  Future<PortalSearchResult> search({
    required String email,
    String query = '',
    int? year,
    String? status,
    String? crimeType,
    PortalScopeOption? scope,
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
    PortalScopeOption? scope,
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

/// One selectable scope in the portal drill-down (All city / a zone / a
/// division / a station). [type] is 'all'|'zone'|'division'|'station'.
class PortalScopeOption {
  const PortalScopeOption({required this.label, required this.type, this.id});
  final String label;
  final String type;
  final int? id;

  factory PortalScopeOption.fromJson(Map<String, dynamic> j) => PortalScopeOption(
        label: (j['label'] ?? '').toString(),
        type: (j['type'] ?? 'all').toString(),
        id: (j['id'] as num?)?.toInt(),
      );

  /// Adds this scope's filter key to a request body.
  void applyTo(Map<String, dynamic> body) {
    if (id == null) return;
    switch (type) {
      case 'zone':
        body['zone_id'] = id;
      case 'division':
        body['division_id'] = id;
      case 'station':
        body['station_id'] = id;
    }
  }

  // Identity by (type,id) so the dropdown can match the selected value.
  @override
  bool operator ==(Object other) =>
      other is PortalScopeOption && other.type == type && other.id == id;

  @override
  int get hashCode => Object.hash(type, id);
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
