import 'dart:convert';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import '../../shared/platform/open_url.dart';
import 'auth_service.dart';
import 'auth_session.dart';
import 'google_auth_config.dart';

/// Real Google sign-in for Windows desktop using the OAuth 2.0 loopback flow.
///
/// [clientViaUserConsent] spins up a temporary `http://localhost:<port>` server,
/// opens the Google consent page in the browser, and captures the redirect.
/// With the `openid email profile` scopes the returned credentials include an
/// `idToken` (a signed JWT) that the access server verifies.
class GoogleAuthService implements AuthService {
  AutoRefreshingAuthClient? _client;
  final _session = AuthSession();

  static const _scopes = ['openid', 'email', 'profile'];

  ClientId get _clientId => ClientId(
        GoogleAuthConfig.clientId,
        GoogleAuthConfig.clientSecret,
      );

  @override
  Future<AuthUser?> signIn() async {
    final client =
        await clientViaUserConsent(_clientId, _scopes, _launchBrowser);
    _client = client;

    final creds = client.credentials;
    final idToken = creds.idToken;
    var email = '';
    String? name;
    String? picture;

    // Prefer the claims inside the ID token (no extra network call).
    if (idToken != null) {
      final claims = _decodeJwtPayload(idToken);
      email = (claims['email'] as String?) ?? '';
      name = claims['name'] as String?;
      picture = claims['picture'] as String?;
    }

    // Fallback to the userinfo endpoint if the token lacked the email claim.
    if (email.isEmpty) {
      try {
        final res = await client
            .get(Uri.parse('https://openidconnect.googleapis.com/v1/userinfo'));
        final info = jsonDecode(res.body) as Map<String, dynamic>;
        email = (info['email'] as String?) ?? '';
        name ??= info['name'] as String?;
        picture ??= info['picture'] as String?;
      } catch (_) {/* leave email empty → caller treats as failed sign-in */}
    }

    if (email.isEmpty) return null;

    // Persist the refresh token so the session restores silently next launch.
    final refresh = creds.refreshToken;
    if (refresh != null) {
      await _session.save(
          refreshToken: refresh, email: email, name: name, photo: picture);
    }

    return AuthUser(
      email: email,
      displayName: name,
      photoUrl: picture,
      idToken: idToken,
    );
  }

  @override
  Future<AuthUser?> restore() async {
    final refresh = await _session.refreshToken();
    if (refresh == null || refresh.isEmpty) return null;

    final httpClient = http.Client();
    try {
      // Exchange the stored refresh token for fresh credentials (incl. a new
      // ID token) without showing the consent screen again.
      final stale = AccessCredentials(
        AccessToken('Bearer', '', DateTime.now().toUtc()),
        refresh,
        _scopes,
      );
      final fresh = await refreshCredentials(_clientId, stale, httpClient);
      final email = await _session.email() ?? _emailFromToken(fresh.idToken);
      if (email == null || email.isEmpty) return null;

      // Google may rotate the refresh token; keep the newest.
      if (fresh.refreshToken != null && fresh.refreshToken != refresh) {
        await _session.save(
          refreshToken: fresh.refreshToken!,
          email: email,
          name: await _session.name(),
          photo: await _session.photo(),
        );
      }
      return AuthUser(
        email: email,
        displayName: await _session.name(),
        photoUrl: await _session.photo(),
        idToken: fresh.idToken,
      );
    } catch (_) {
      // Refresh token revoked/expired → force a fresh sign-in.
      await _session.clear();
      return null;
    } finally {
      httpClient.close();
    }
  }

  @override
  Future<void> signOut() async {
    _client?.close();
    _client = null;
    await _session.clear();
  }

  String? _emailFromToken(String? idToken) {
    if (idToken == null) return null;
    return _decodeJwtPayload(idToken)['email'] as String?;
  }

  /// Opens [url] in the default browser. Delegates to the shared cross-platform
  /// helper (rundll32 on Windows, `open` on macOS) so the loopback OAuth flow
  /// works on every desktop OS.
  void _launchBrowser(String url) => openUrl(url);

  Map<String, dynamic> _decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) return {};
    try {
      final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
      return jsonDecode(payload) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }
}
