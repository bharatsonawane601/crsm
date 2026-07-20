import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../shared/platform/device_meta.dart';
import 'access_config.dart';

/// Approval status the server can return for an email + device.
enum AccessStatus { approved, pending, denied, deviceMismatch, expired, error }

/// What experience an approved user gets. `io` opens the Investigating-Officer
/// portal (field-first case building + auto-generated forms), separate from the
/// read-only senior-officer portal (acp/dcp/cp) and the full station app.
/// [zone] is zone-office staff: the same working screens as a station user
/// (Crime Records is editable, Dashboard and Analytics are theirs), but their
/// data covers every station in the zone instead of one — Zone 1 office sees
/// all 8 of its stations. Distinct from [dcp], which is a senior officer on the
/// read-only portal.
enum OfficerRole { station, zone, acp, dcp, cp, io, hq }

/// Maps a server role string to [OfficerRole]. Shared with the auth client.
OfficerRole roleFromString(String? s) => switch (s) {
      'zone' => OfficerRole.zone,
      'acp' => OfficerRole.acp,
      'dcp' => OfficerRole.dcp,
      'cp' => OfficerRole.cp,
      'io' => OfficerRole.io,
      'hq' => OfficerRole.hq,
      _ => OfficerRole.station,
    };

/// The jurisdiction labels (zone / division / station names) for the portal
/// header. Any may be null depending on the officer's role.
class OfficerScope {
  const OfficerScope({
    this.zone,
    this.division,
    this.station,
    this.stationAliases = const [],
  });
  final String? zone;
  final String? division;
  final String? station;

  /// Every spelling the assigned station is known by on the server (English,
  /// Marathi, admin alias/code). Local records are matched against all of them,
  /// so a FIR filed as "एम.वाळूज" still counts as "MIDC Waluj".
  final List<String> stationAliases;

  /// A short label like "Zone 1" / "ACP City" / "All city" for the header.
  String labelOr(String allCity) =>
      division ?? zone ?? station ?? allCity;

  /// Builds a scope from a server "scope" object (same shape from /check.php,
  /// /auth_login.php and /auth_session.php). Falls back to the station name
  /// alone when an older server sends no aliases.
  factory OfficerScope.fromJson(Map<String, dynamic>? j) {
    if (j == null) return const OfficerScope();
    final station = j['station'] as String?;
    final raw = j['station_aliases'] as List?;
    final aliases = <String>[
      for (final a in raw ?? const []) a.toString(),
    ];
    return OfficerScope(
      zone: j['zone'] as String?,
      division: j['division'] as String?,
      station: station,
      stationAliases: aliases.isNotEmpty
          ? aliases
          : [if (station != null && station.isNotEmpty) station],
    );
  }

  /// The scope as JSON, for caching the profile for offline launch.
  Map<String, dynamic> toJson() => {
        'zone': zone,
        'division': division,
        'station': station,
        'station_aliases': stationAliases,
      };
}

class AccessResult {
  AccessResult({
    required this.status,
    this.message,
    this.networkError = false,
    this.role = OfficerRole.station,
    this.portal = false,
    this.scope = const OfficerScope(),
  });

  final AccessStatus status;

  /// i18n key (access.*) or a raw server message.
  final String? message;

  /// True when the server was unreachable (vs. a definitive answer).
  final bool networkError;

  /// The approved user's rank and whether they use the read-only portal.
  final OfficerRole role;
  final bool portal;
  final OfficerScope scope;
}

/// Talks to the Hostinger access-approval API. A single `check` call creates a
/// pending request on first contact and returns the current status thereafter;
/// the server also enforces the one-device (HWID) binding.
class AccessClient {
  AccessClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;

  Future<AccessResult> check({
    required String email,
    required String hwid,
    String? idToken,
    String? displayName,
  }) async {
    try {
      final info = await _clientInfo();
      final res = await _http
          .post(
            Uri.parse('${AccessConfig.apiBaseUrl}/check.php'),
            headers: {
              'Content-Type': 'application/json',
              'X-App-Key': AccessConfig.appKey,
            },
            body: jsonEncode({
              'email': email,
              'hwid': hwid,
              'id_token': idToken ?? '',
              'name': displayName ?? '',
              ...info,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['ok'] != true) {
        return AccessResult(
            status: AccessStatus.error,
            message: (json['message'] as String?) ?? 'access.error.server');
      }
      final status = switch (json['status'] as String?) {
        'approved' => AccessStatus.approved,
        'pending' => AccessStatus.pending,
        'denied' => AccessStatus.denied,
        'device_mismatch' => AccessStatus.deviceMismatch,
        'expired' => AccessStatus.expired,
        _ => AccessStatus.error,
      };
      final scope = json['scope'] as Map<String, dynamic>?;
      return AccessResult(
        status: status,
        message: json['message'] as String?,
        role: roleFromString(json['role'] as String?),
        portal: json['portal'] == true,
        scope: OfficerScope.fromJson(scope),
      );
    } on SocketException {
      return _network();
    } on TimeoutException {
      return _network();
    } on http.ClientException {
      return _network();
    } catch (_) {
      // Reached the server but couldn't parse the reply — treat as a hard
      // error (deny access) rather than a network blip.
      return AccessResult(
          status: AccessStatus.error, message: 'access.error.server');
    }
  }

  AccessResult _network() => AccessResult(
      status: AccessStatus.error,
      message: 'access.error.network',
      networkError: true);

  /// This device's platform / OS / name / app version for security auditing.
  Future<Map<String, String>> _clientInfo() => clientDeviceMeta();

  void dispose() => _http.close();
}
