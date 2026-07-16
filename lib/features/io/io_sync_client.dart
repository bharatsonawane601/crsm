import 'dart:convert';

import 'package:http/http.dart' as http;

import '../access/access_config.dart';

/// HTTP client for IO-case sync (phone <-> central store <-> PC). Mirrors the
/// central-portal client: shared app-key header, caller identified by email.
class IoSyncClient {
  IoSyncClient({http.Client? httpClient})
      : _http = httpClient ?? http.Client();
  final http.Client _http;

  Uri get _uri => Uri.parse('${AccessConfig.apiBaseUrl}/io_sync.php');
  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'X-App-Key': AccessConfig.appKey,
      };

  /// Uploads the caller's case bundles. Returns the number saved, or null on
  /// failure (so the caller can retry later without losing local data).
  Future<int?> push(
      String email, List<Map<String, dynamic>> cases) async {
    try {
      final res = await _http
          .post(_uri,
              headers: _headers,
              body: jsonEncode(
                  {'email': email, 'action': 'push', 'cases': cases}))
          .timeout(const Duration(seconds: 60));
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['ok'] == true) return (json['saved'] as num?)?.toInt() ?? 0;
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Downloads the caller's cases (all, or only those updated since [since]).
  /// Returns an empty list on any failure.
  Future<List<Map<String, dynamic>>> pull(String email,
      {String? since}) async {
    try {
      final res = await _http
          .post(_uri,
              headers: _headers,
              body: jsonEncode({
                'email': email,
                'action': 'pull',
                'since': ?since,
              }))
          .timeout(const Duration(seconds: 60));
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      if (json['ok'] != true) return const [];
      return [
        for (final c in (json['cases'] as List? ?? []))
          (c as Map).cast<String, dynamic>(),
      ];
    } catch (_) {
      return const [];
    }
  }

  void dispose() => _http.close();
}
