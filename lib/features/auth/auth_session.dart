import 'package:shared_preferences/shared_preferences.dart';

/// Persists just enough to silently restore the Google session on next launch:
/// the long-lived refresh token (used to fetch a fresh ID token) plus the
/// cached profile fields. Cleared on sign-out.
class AuthSession {
  static const _kRefresh = 'auth_refresh_token';
  static const _kEmail = 'auth_email';
  static const _kName = 'auth_name';
  static const _kPhoto = 'auth_photo';

  Future<void> save({
    required String refreshToken,
    required String email,
    String? name,
    String? photo,
  }) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kRefresh, refreshToken);
    await p.setString(_kEmail, email);
    if (name != null) await p.setString(_kName, name);
    if (photo != null) await p.setString(_kPhoto, photo);
  }

  Future<String?> refreshToken() async =>
      (await SharedPreferences.getInstance()).getString(_kRefresh);
  Future<String?> email() async =>
      (await SharedPreferences.getInstance()).getString(_kEmail);
  Future<String?> name() async =>
      (await SharedPreferences.getInstance()).getString(_kName);
  Future<String?> photo() async =>
      (await SharedPreferences.getInstance()).getString(_kPhoto);

  Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kRefresh);
    await p.remove(_kEmail);
    await p.remove(_kName);
    await p.remove(_kPhoto);
  }
}
