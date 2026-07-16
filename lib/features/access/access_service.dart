import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/demo_mode.dart';
import '../auth/auth_service.dart';
import 'access_client.dart';
import 'access_config.dart';
import 'hwid.dart';

/// Where the access gate sits for the signed-in user.
enum AccessGate {
  /// Asking the server — show a loading splash.
  checking,

  /// Approved by the admin — allowed into the app.
  approved,

  /// Request recorded, awaiting admin approval — show the waiting screen.
  pending,

  /// Denied / wrong device / server error — show the blocked screen.
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

/// Checks the signed-in Google account against the Hostinger approval server.
/// Re-runs automatically when the user signs in/out.
class AccessController extends Notifier<AccessState> {
  @override
  AccessState build() {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) {
      return const AccessState(gate: AccessGate.checking);
    }
    // Demo build (Linux .deb): no server approval — open the gate immediately.
    if (kCrmsDemoMode) {
      return const AccessState(gate: AccessGate.approved);
    }
    // Until the server is configured, keep the gate open so the app stays
    // usable for development/demos.
    if (!AccessConfig.isConfigured) {
      return const AccessState(gate: AccessGate.approved);
    }
    Future.microtask(() => _check(user));
    return const AccessState(gate: AccessGate.checking);
  }

  Future<void> _check(AuthUser user) async {
    final hwid = await computeHwid();
    final client = AccessClient();
    try {
      final r = await client.check(
        email: user.email,
        hwid: hwid,
        idToken: user.idToken,
        displayName: user.displayName,
      );
      state = _map(r);
    } finally {
      client.dispose();
    }
  }

  AccessState _map(AccessResult r) {
    return switch (r.status) {
      AccessStatus.approved => AccessState(
          gate: AccessGate.approved,
          role: r.role,
          portal: r.portal,
          scope: r.scope),
      AccessStatus.pending => const AccessState(gate: AccessGate.pending),
      AccessStatus.denied =>
        const AccessState(gate: AccessGate.blocked, message: 'access.denied'),
      AccessStatus.deviceMismatch => const AccessState(
          gate: AccessGate.blocked, message: 'access.deviceMismatch'),
      AccessStatus.expired => const AccessState(
          gate: AccessGate.blocked, message: 'access.expired'),
      AccessStatus.error => AccessState(
          gate: AccessGate.blocked,
          message: r.message ?? 'access.error.server'),
    };
  }

  /// Re-asks the server (used by the waiting screen's poll + manual refresh).
  Future<void> recheck() async {
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;
    if (kCrmsDemoMode || !AccessConfig.isConfigured) {
      state = const AccessState(gate: AccessGate.approved);
      return;
    }
    await _check(user);
  }
}

final accessControllerProvider =
    NotifierProvider<AccessController, AccessState>(AccessController.new);
