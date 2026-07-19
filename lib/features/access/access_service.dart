import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/auth_service.dart';
import 'access_client.dart';

/// Where the access gate sits for the signed-in user.
enum AccessGate {
  /// Still resolving the session — show a loading splash.
  checking,

  /// Signed in and approved — allowed into the app.
  approved,

  /// Awaiting admin approval (kept for compatibility; the ID/password flow
  /// surfaces this on the login screen instead of a separate screen).
  pending,

  /// Blocked — shown only if something denies access after sign-in.
  blocked,
}

class AccessState {
  const AccessState({
    required this.gate,
    this.message,
    this.role = OfficerRole.station,
    this.portal = false,
    this.scope = const OfficerScope(),
  });

  final AccessGate gate;

  /// i18n key (access.*) or a raw server message, shown on the blocked screen.
  final String? message;

  /// Set when [gate] is approved: the user's rank, whether they use the
  /// read-only officer portal, and their jurisdiction labels.
  final OfficerRole role;
  final bool portal;
  final OfficerScope scope;
}

/// Derives the access state directly from the signed-in session.
///
/// With admin-issued logins the server decides role / scope / approval as part
/// of authentication (auth.go), so there is no second approval round-trip: a
/// non-null [AuthUser] is, by definition, an approved user carrying their role
/// and jurisdiction. This keeps every existing reader of [role] / [scope] /
/// [portal] working unchanged.
class AccessController extends Notifier<AccessState> {
  @override
  AccessState build() {
    final auth = ref.watch(authControllerProvider);
    final user = auth.value;
    if (auth.isLoading) {
      return const AccessState(gate: AccessGate.checking);
    }
    if (user == null) {
      // Not signed in — the root gate shows the login screen; this value is
      // only read by in-app widgets, which aren't mounted while signed out.
      return const AccessState(gate: AccessGate.checking);
    }
    return AccessState(
      gate: AccessGate.approved,
      role: user.role,
      portal: user.portal,
      scope: user.scope,
    );
  }

  /// Re-validate the session against the server (used by manual refresh).
  Future<void> recheck() async {
    await ref.read(authControllerProvider.notifier).refresh();
  }
}

final accessControllerProvider =
    NotifierProvider<AccessController, AccessState>(AccessController.new);
