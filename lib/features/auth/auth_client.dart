import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../shared/platform/device_meta.dart';
import '../access/access_client.dart' show OfficerRole, OfficerScope, roleFromString;
import '../access/access_config.dart';

/// Outcome of a login / session-restore against the DB Square auth server.
enum AuthOutcome {
  ok,

  /// Correct password but the account must set a new one before entering.
  mustChangePassword,

  /// A definitive rejection (wrong credentials, locked, expired, wrong device,
  /// suspended, no password issued yet). [message] is an i18n key to show.
  rejected,

  /// The server couldn't be reached — keep any existing session, ask to retry.
  networkError,
}

/// The signed-in officer, as the server describes them.
class AuthUser {
  const AuthUser({
    required this.email,
    required this.loginId,
    required this.token,
    this.displayName,
    this.role = OfficerRole.station,
    this.portal = false,
    this.scope = const OfficerScope(),
  });

  final String email;
  final String loginId;

  /// The device-bound session token. Empty for a restore where the caller
  /// already holds the token.
  final String token;

  final String? displayName;
  final OfficerRole role;
  final bool portal;
  final OfficerScope scope;

  AuthUser withToken(String t) => AuthUser(
        email: email,
        loginId: loginId,
        token: t,
        displayName: displayName,
        role: role,
        portal: portal,
        scope: scope,
      );
}

class AuthResult {
  const AuthResult(this.outcome, {this.user, this.message, this.changeToken});
  final AuthOutcome outcome;
  final AuthUser? user;

  /// i18n key describing a rejection or a network error.
  final String? message;

  /// Short-lived ticket returned with [AuthOutcome.mustChangePassword]; passed
  /// back to [changePassword] to set the first real password.
  final String? changeToken;
}

/// HTTP client for the admin-issued login system (server auth.go). All calls
/// carry the shared app key and this device's hardware id.
class AuthClient {
  AuthClient({http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final http.Client _http;

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'X-App-Key': AccessConfig.appKey,
      };

  Uri _uri(String file) => Uri.parse('${AccessConfig.apiBaseUrl}/$file');

  /// Exchange an ID + password (+ this device) for a session token.
  Future<AuthResult> login({
    required String loginId,
    required String password,
    required String hwid,
  }) async {
    return _call('auth_login.php', {
      'login_id': loginId,
      'password': password,
      'hwid': hwid,
    });
  }

  /// Set the first real password after a forced change, using the change ticket.
  Future<AuthResult> changePassword({
    required String changeToken,
    required String newPassword,
    required String hwid,
  }) async {
    return _call('auth_change_password.php', {
      'token': changeToken,
      'new_password': newPassword,
      'hwid': hwid,
    });
  }

  /// Validate a stored token on launch and refresh role/scope. Returns a user
  /// carrying the same [token] on success.
  Future<AuthResult> restore({
    required String token,
    required String hwid,
  }) async {
    final r = await _call('auth_session.php', {'token': token, 'hwid': hwid});
    if (r.outcome == AuthOutcome.ok && r.user != null) {
      return AuthResult(AuthOutcome.ok, user: r.user!.withToken(token));
    }
    return r;
  }

  /// Best-effort server-side revoke of this device's session.
  Future<void> logout(String token) async {
    try {
      await _http
          .post(_uri('auth_logout.php'),
              headers: _headers, body: jsonEncode({'token': token}))
          .timeout(const Duration(seconds: 8));
    } catch (_) {}
  }

  /// Send a "Request ID & password" to the admin. Returns true if recorded.
  Future<bool> requestAccess({
    required String name,
    required String phone,
    required String hwid,
    String designation = '',
    String gender = '',
    String station = '',
    String recoveryEmail = '',
    String note = '',
  }) async {
    try {
      final meta = await clientDeviceMeta();
      final res = await _http
          .post(_uri('auth_request.php'),
              headers: _headers,
              body: jsonEncode({
                'name': name,
                'phone': phone,
                'hwid': hwid,
                'designation': designation,
                'gender': gender,
                'station': station,
                'recovery_email': recoveryEmail,
                'note': note,
                ...meta,
              }))
          .timeout(const Duration(seconds: 15));
      final json = jsonDecode(res.body) as Map<String, dynamic>;
      return json['ok'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<AuthResult> _call(String file, Map<String, dynamic> body) async {
    try {
      final meta = await clientDeviceMeta();
      final res = await _http
          .post(_uri(file),
              headers: _headers, body: jsonEncode({...body, ...meta}))
          .timeout(const Duration(seconds: 20));
      final json = jsonDecode(res.body) as Map<String, dynamic>;

      if (json['ok'] != true) {
        if (json['must_change_password'] == true) {
          return AuthResult(AuthOutcome.mustChangePassword,
              changeToken: json['change_token'] as String?);
        }
        return AuthResult(AuthOutcome.rejected,
            message: (json['message'] as String?) ?? 'access.error.credentials');
      }
      if (json['must_change_password'] == true) {
        return AuthResult(AuthOutcome.mustChangePassword,
            changeToken: json['change_token'] as String?);
      }

      final scope = json['scope'] as Map<String, dynamic>?;
      final user = AuthUser(
        email: (json['email'] as String?) ?? '',
        loginId: (json['login_id'] as String?) ?? '',
        token: (json['token'] as String?) ?? '',
        displayName: json['name'] as String?,
        role: roleFromString(json['role'] as String?),
        portal: json['portal'] == true,
        scope: OfficerScope.fromJson(scope),
      );
      return AuthResult(AuthOutcome.ok, user: user);
    } on SocketException {
      return const AuthResult(AuthOutcome.networkError,
          message: 'access.error.network');
    } on TimeoutException {
      return const AuthResult(AuthOutcome.networkError,
          message: 'access.error.network');
    } on http.ClientException {
      return const AuthResult(AuthOutcome.networkError,
          message: 'access.error.network');
    } catch (_) {
      return const AuthResult(AuthOutcome.rejected,
          message: 'access.error.server');
    }
  }

  void dispose() => _http.close();
}
