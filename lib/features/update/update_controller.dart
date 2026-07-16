import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/platform/open_url.dart';
import 'update_config.dart';
import 'update_models.dart';
import 'update_service.dart';

/// Drives the update flow: a silent check at launch, a manual check from
/// Settings, and the download+install action. Updates are only ever applied on
/// launch or when the user asks — never mid-session on their own.
class UpdateController extends Notifier<UpdateState> {
  final _service = UpdateService();

  @override
  UpdateState build() {
    // Silent check shortly after launch (desktop only, when the server is
    // configured). Does not block the UI.
    if ((Platform.isWindows || Platform.isMacOS) && UpdateConfig.isConfigured) {
      Future.microtask(() => check(silent: true));
    }
    return const UpdateState();
  }

  /// Asks the server for the latest release. [silent] check is the launch one;
  /// a manual check surfaces "you're up to date" / errors to the user.
  Future<void> check({bool silent = false}) async {
    if (state.isBusy) return;
    state = state.copyWith(phase: UpdatePhase.checking, error: null);
    try {
      final release = await _service.fetchLatest();
      if (release == null || !await _service.isNewer(release)) {
        state = const UpdateState(phase: UpdatePhase.upToDate);
        return;
      }
      state = UpdateState(
        phase: release.mandatory ? UpdatePhase.mandatory : UpdatePhase.available,
        release: release,
      );
    } catch (_) {
      // On a silent launch check, stay quiet (offline is normal). On a manual
      // check, show the error.
      state = silent
          ? const UpdateState(phase: UpdatePhase.idle)
          : const UpdateState(
              phase: UpdatePhase.failed, error: 'update.error.network');
    }
  }

  /// Applies the pending release. On Windows this downloads + launches the .exe
  /// installer and exits; on Linux it downloads the new .AppImage, marks it
  /// executable, launches it and exits. On macOS we can't silently install a
  /// .dmg, so we open its download URL in the browser and let the user drag it
  /// to Applications.
  Future<void> downloadAndInstall() async {
    final release = state.release;
    if (release == null) return;

    if (Platform.isMacOS) {
      openUrl(release.url);
      // Open the .dmg download in the browser for manual install. A MANDATORY
      // update must NOT drop to idle (that would let the user into the app
      // without updating) — keep the gate up; only an optional update dismisses.
      state = state.copyWith(
        phase: release.mandatory ? UpdatePhase.mandatory : UpdatePhase.idle,
        error: null,
      );
      return;
    }

    state = state.copyWith(phase: UpdatePhase.downloading, progress: 0, error: null);
    try {
      final file = await _service.downloadInstaller(
        release,
        onProgress: (p) =>
            state = state.copyWith(phase: UpdatePhase.downloading, progress: p),
      );
      state = state.copyWith(phase: UpdatePhase.installing);
      _service.launchInstaller(file);
      // Give the OS a beat to spawn the installer, then quit so it can update.
      await Future<void>.delayed(const Duration(milliseconds: 800));
      exit(0);
    } catch (_) {
      state = state.copyWith(
        phase: release.mandatory ? UpdatePhase.mandatory : UpdatePhase.available,
        error: 'update.error.download',
      );
    }
  }

  /// User chose "Later" on an optional update — hide the prompt this session.
  void dismiss() {
    if (state.phase == UpdatePhase.available) {
      state = const UpdateState(phase: UpdatePhase.idle);
    }
  }
}

final updateControllerProvider =
    NotifierProvider<UpdateController, UpdateState>(UpdateController.new);
