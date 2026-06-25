import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'google_auth_config.dart';
import 'google_auth_service.dart';
import 'pin_service.dart';

/// The signed-in user (Google identity). Email is the login per the
/// "Sign in with Google" decision in PROJECT.md.
class AuthUser {
  const AuthUser({
    required this.email,
    this.displayName,
    this.photoUrl,
    this.idToken,
  });

  final String email;
  final String? displayName;
  final String? photoUrl;

  /// Google ID token (JWT) used by the access server to verify the identity.
  /// Null under the demo stub; populated once real Google OAuth is wired in.
  final String? idToken;
}

/// Abstraction over Google sign-in so the UI doesn't care whether we're
/// running the real OAuth flow or the demo stub.
abstract class AuthService {
  Future<AuthUser?> signIn();

  /// Silently restores a previous session on launch, or null if none / expired.
  Future<AuthUser?> restore();

  Future<void> signOut();
}

/// Stub used until real Google OAuth credentials (Desktop client ID +
/// Drive API) are configured. Lets the rest of the app run end-to-end.
///
/// To switch to the real flow: implement [AuthService] with `google_sign_in`
/// (mobile) / `googleapis_auth` loopback (desktop), then bind it in
/// [authServiceProvider]. See PROJECT.md "Auth & Sync Model".
class StubAuthService implements AuthService {
  @override
  Future<AuthUser?> signIn() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return const AuthUser(
      email: 'demo.officer@gmail.com',
      displayName: 'Demo Officer',
    );
  }

  @override
  Future<AuthUser?> restore() async => null;

  @override
  Future<void> signOut() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}

/// Uses real Google sign-in once [GoogleAuthConfig] is filled in; otherwise
/// falls back to the demo stub so the app still runs during development.
final authServiceProvider = Provider<AuthService>((ref) =>
    GoogleAuthConfig.isConfigured ? GoogleAuthService() : StubAuthService());

/// Whether the app is running with stubbed auth (used to show a banner).
final isStubAuthProvider = Provider<bool>(
  (ref) => ref.watch(authServiceProvider) is StubAuthService,
);

/// Holds the current session. Null = signed out.
class AuthController extends Notifier<AsyncValue<AuthUser?>> {
  late AuthService _service;

  @override
  AsyncValue<AuthUser?> build() {
    _service = ref.watch(authServiceProvider);
    // Try to restore a previous session silently; UI shows the splash until
    // this resolves.
    Future.microtask(_restore);
    return const AsyncLoading();
  }

  Future<void> _restore() async {
    try {
      state = AsyncData(await _service.restore());
    } catch (_) {
      state = const AsyncData(null);
    }
  }

  Future<void> signIn() async {
    state = const AsyncLoading();
    try {
      final user = await _service.signIn();
      state = AsyncData(user);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
    // Clear the local launch PIN so the next account starts fresh.
    await PinService().clear();
    state = const AsyncData(null);
  }
}

final authControllerProvider =
    NotifierProvider<AuthController, AsyncValue<AuthUser?>>(
  AuthController.new,
);
