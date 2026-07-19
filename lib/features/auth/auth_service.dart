import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/demo_mode.dart';
import '../access/access_client.dart' show OfficerRole, OfficerScope, roleFromString;
import '../access/access_config.dart';
import '../access/hwid.dart';
import 'auth_client.dart';
import 'pin_service.dart';
import 'secure_store.dart';

// The signed-in user type lives with the client; re-export it so the many
// callers that import auth_service.dart keep compiling unchanged.
export 'auth_client.dart' show AuthUser, AuthResult, AuthOutcome;

/// Cached, non-secret profile of the last signed-in officer, so a station with
/// no internet at launch can still work offline. The secret (the token) stays
/// in the OS secure store; this is only the role/scope needed to render.
const _kProfilePref = 'crms_auth_profile';

/// Holds the current session. `AsyncData(null)` = signed out (show login).
/// Authentication is now admin-issued ID + password (DB Square auth), replacing
/// Google sign-in. The device-bound token is kept in the OS secure store so the
/// officer types their password once per device, not every launch.
class AuthController extends Notifier<AsyncValue<AuthUser?>> {
  final _store = SecureStore();

  @override
  AsyncValue<AuthUser?> build() {
    Future.microtask(_restore);
    return const AsyncLoading();
  }

  /// Re-validate the stored session against the server (manual refresh).
  Future<void> refresh() => _restore();

  Future<void> _restore() async {
    // Demo build (Linux .deb): no server, auto-enter as the demo officer.
    if (kCrmsDemoMode) {
      state = const AsyncData(AuthUser(
          email: kCrmsDemoEmail,
          loginId: 'demo',
          token: '',
          displayName: kCrmsDemoName,
          role: OfficerRole.hq));
      return;
    }
    // Server not configured (dev build): show the login screen; a tap signs in
    // as a local dev user (handled in [login]) so the app stays usable.
    if (!AccessConfig.isConfigured) {
      state = const AsyncData(null);
      return;
    }

    final token = await _store.readToken();
    if (token == null || token.isEmpty) {
      state = const AsyncData(null);
      return;
    }
    final hwid = await computeHwid();
    final client = AuthClient();
    try {
      final r = await client.restore(token: token, hwid: hwid);
      switch (r.outcome) {
        case AuthOutcome.ok:
          await _persistProfile(r.user!);
          state = AsyncData(r.user);
        case AuthOutcome.networkError:
          // Offline: fall back to the cached profile so work isn't blocked.
          // The server re-validates on the next online launch.
          final cached = await _cachedProfile(token);
          state = AsyncData(cached); // null if we've never cached one
        case AuthOutcome.mustChangePassword:
        case AuthOutcome.rejected:
          // Token no longer valid (revoked, expired, device reset) — sign out.
          await _clearSession();
          state = const AsyncData(null);
      }
    } finally {
      client.dispose();
    }
  }

  /// Interactive sign-in. On success the state flips to the signed-in user;
  /// the [AuthResult] is returned so the screen can react to must-change /
  /// rejection / network cases.
  Future<AuthResult> login(String loginId, String password) async {
    // Dev build with no server: let any credentials in as a local Tester so the
    // app is usable without the backend. Never reached in a real (configured)
    // build, where AccessConfig.isConfigured is always true.
    if (!AccessConfig.isConfigured && !kCrmsDemoMode) {
      const dev = AuthUser(
          email: 'dev@local', loginId: 'dev', token: '', role: OfficerRole.hq);
      state = const AsyncData(dev);
      return const AuthResult(AuthOutcome.ok, user: dev);
    }
    final hwid = await computeHwid();
    final client = AuthClient();
    try {
      final r = await client.login(
          loginId: loginId.trim(), password: password, hwid: hwid);
      if (r.outcome == AuthOutcome.ok) {
        await _saveSession(r.user!);
        state = AsyncData(r.user);
      }
      return r;
    } finally {
      client.dispose();
    }
  }

  /// Set the first real password after a forced change; signs in on success.
  Future<AuthResult> changePassword(
      String changeToken, String newPassword) async {
    final hwid = await computeHwid();
    final client = AuthClient();
    try {
      final r = await client.changePassword(
          changeToken: changeToken, newPassword: newPassword, hwid: hwid);
      if (r.outcome == AuthOutcome.ok) {
        await _saveSession(r.user!);
        state = AsyncData(r.user);
      }
      return r;
    } finally {
      client.dispose();
    }
  }

  /// Send a "Request ID & password" to the admin (no sign-in).
  Future<bool> requestAccess({
    required String name,
    required String phone,
    String designation = '',
    String gender = '',
    String station = '',
    String recoveryEmail = '',
    String note = '',
  }) async {
    final hwid = await computeHwid();
    final client = AuthClient();
    try {
      return await client.requestAccess(
        name: name,
        phone: phone,
        hwid: hwid,
        designation: designation,
        gender: gender,
        station: station,
        recoveryEmail: recoveryEmail,
        note: note,
      );
    } finally {
      client.dispose();
    }
  }

  Future<void> signOut() async {
    final token = await _store.readToken();
    if (token != null && token.isNotEmpty) {
      final client = AuthClient();
      await client.logout(token);
      client.dispose();
    }
    await _clearSession();
    // Clear the local launch PIN so the next account starts fresh.
    await PinService().clear();
    state = const AsyncData(null);
  }

  Future<void> _saveSession(AuthUser user) async {
    if (user.token.isNotEmpty) {
      await _store.writeToken(user.token);
    }
    await _persistProfile(user);
  }

  Future<void> _clearSession() async {
    await _store.clearToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kProfilePref);
  }

  Future<void> _persistProfile(AuthUser user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _kProfilePref,
        jsonEncode({
          'email': user.email,
          'login_id': user.loginId,
          'name': user.displayName,
          'role': user.role.name,
          'portal': user.portal,
          'zone': user.scope.zone,
          'division': user.scope.division,
          'station': user.scope.station,
        }));
  }

  /// The last signed-in profile, re-attached to [token], for offline launch.
  Future<AuthUser?> _cachedProfile(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kProfilePref);
    if (raw == null) return null;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      return AuthUser(
        email: (j['email'] as String?) ?? '',
        loginId: (j['login_id'] as String?) ?? '',
        token: token,
        displayName: j['name'] as String?,
        role: roleFromString(j['role'] as String?),
        portal: j['portal'] == true,
        scope: OfficerScope(
          zone: j['zone'] as String?,
          division: j['division'] as String?,
          station: j['station'] as String?,
        ),
      );
    } catch (_) {
      return null;
    }
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AsyncValue<AuthUser?>>(
  AuthController.new,
);
