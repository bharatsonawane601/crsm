import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/crms_theme.dart';
import 'core/theme/text_scale.dart';
import 'features/access/access_client.dart';
import 'features/access/access_screen.dart';
import 'features/access/access_service.dart';
import 'features/app_shell.dart';
import 'features/auth/auth_service.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/pin_gate_screen.dart';
import 'features/io/io_portal_shell.dart';
import 'features/portal/portal_shell.dart';
import 'features/splash_screen.dart';
import 'features/update/update_controller.dart';
import 'features/update/update_models.dart';
import 'features/update/update_screen.dart';
import 'features/welcome/welcome_screen.dart';

/// Root widget. Shows a brief splash, then routes between login and home.
class CrmsApp extends ConsumerWidget {
  const CrmsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final textScale = ref.watch(textScaleProvider);

    return MaterialApp(
      title: 'CRMS',
      debugShowCheckedModeBanner: false,
      theme: CrmsTheme.light(),
      darkTheme: CrmsTheme.dark(),
      themeMode: themeMode,
      // easy_localization wires these up from the EasyLocalization wrapper.
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      // App-wide font size (Settings → Display). Clamp so OS-level scaling can't
      // stack on top to an unusable size.
      builder: (context, child) {
        final mq = MediaQuery.of(context);
        return MediaQuery(
          data: mq.copyWith(
            textScaler: TextScaler.linear(textScale.factor),
          ),
          child: child!,
        );
      },
      home: const _RootGate(),
    );
  }
}

/// Holds the splash briefly on launch, then routes:
/// not signed in → welcome → Google login; signed in → access-approval gate.
class _RootGate extends ConsumerStatefulWidget {
  const _RootGate();

  @override
  ConsumerState<_RootGate> createState() => _RootGateState();
}

class _RootGateState extends ConsumerState<_RootGate> {
  bool _ready = false;

  /// Becomes true once the initial silent session-restore has resolved, so we
  /// only show the splash for the launch restore — not for later sign-ins.
  bool _restoreDone = false;

  /// Welcome page is shown once before sign-in; dismissed by "Get Started".
  bool _welcomeSeen = false;

  /// The optional-update dialog is offered once per launch.
  bool _updateDialogShown = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) setState(() => _ready = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (prev, next) {
      if (!next.isLoading && !_restoreDone) {
        setState(() => _restoreDone = true);
      }
      // Returning to a signed-out state shows the welcome page again.
      if (prev?.value != null && next.value == null) {
        setState(() => _welcomeSeen = false);
      }
    });

    // macOS only: offer the optional update once, after the launch splash has
    // cleared (a .dmg can't self-install). Windows/Linux auto-install instead.
    ref.listen(updateControllerProvider, (prev, next) {
      if (Platform.isMacOS &&
          next.phase == UpdatePhase.available &&
          !_updateDialogShown &&
          _ready &&
          _restoreDone) {
        _updateDialogShown = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) showUpdateDialog(context);
        });
      }
    });

    final auth = ref.watch(authControllerProvider);
    final update = ref.watch(updateControllerProvider);
    // Any in-flight install (auto or mandatory) takes over the whole window so
    // the user can't start work in an app that's about to restart itself.
    final updating = update.phase == UpdatePhase.downloading ||
        update.phase == UpdatePhase.installing;
    final mandatoryActive = update.phase == UpdatePhase.mandatory;

    final Widget child;
    if (!_ready || !_restoreDone) {
      child = const SplashScreen();
    } else if (updating) {
      child = const AutoUpdateScreen();
    } else if (mandatoryActive) {
      // A forced update blocks everything, even before sign-in.
      child = const MandatoryUpdateScreen();
    } else if (auth.value != null) {
      child = const _AccessGate();
    } else if (!_welcomeSeen) {
      child = WelcomeScreen(
        onContinue: () => setState(() => _welcomeSeen = true),
      );
    } else {
      child = const LoginScreen();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: child,
    );
  }
}

/// Second gate (after Google sign-in): the account must be approved by the
/// admin on the access server before reaching the app.
class _AccessGate extends ConsumerWidget {
  const _AccessGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final access = ref.watch(accessControllerProvider);

    final Widget child = switch (access.gate) {
      AccessGate.checking => const SplashScreen(),
      AccessGate.approved =>
        _PinGate(role: access.role, portal: access.portal),
      AccessGate.pending || AccessGate.blocked => const AccessScreen(),
    };

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: child,
    );
  }
}

/// Third gate (after approval): a 6-digit PIN is created on first run and
/// required on every later launch. Stays mounted while approved so unlocking
/// survives the access screen's background re-checks.
class _PinGate extends StatefulWidget {
  const _PinGate({this.role = OfficerRole.station, this.portal = false});

  /// The approved user's rank. `io` opens the Investigating-Officer portal.
  final OfficerRole role;

  /// When true, the user is a senior officer (CP/DCP/ACP) → open the read-only
  /// Officer Portal instead of the full data-entry app.
  final bool portal;

  @override
  State<_PinGate> createState() => _PinGateState();
}

class _PinGateState extends State<_PinGate> {
  bool _unlocked = false;

  @override
  Widget build(BuildContext context) {
    if (_unlocked) {
      if (widget.role == OfficerRole.io) return const IoPortalShell();
      return widget.portal ? const PortalShell() : const AppShell();
    }
    return PinGateScreen(onUnlocked: () => setState(() => _unlocked = true));
  }
}
