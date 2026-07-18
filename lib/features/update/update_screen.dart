import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/crms.dart';
import 'update_controller.dart';
import 'update_models.dart';

/// Full-screen, non-skippable update prompt shown when a mandatory release is
/// available. The user cannot reach the app until they update.
class MandatoryUpdateScreen extends ConsumerWidget {
  const MandatoryUpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(updateControllerProvider);
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.s8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: UpdateBody(state: state, mandatory: true),
          ),
        ),
      ),
    );
  }
}

/// Full-screen page shown while an update downloads and installs itself.
/// No buttons — the app closes and reopens on its own when it's done.
class AutoUpdateScreen extends ConsumerWidget {
  const AutoUpdateScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(updateControllerProvider);
    final scheme = Theme.of(context).colorScheme;
    final installing = state.phase == UpdatePhase.installing;
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(PhosphorIconsRegular.downloadSimple,
                    size: 40, color: AppColors.policeNavy),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  'update.autoTitle'.tr(
                      namedArgs: {'v': state.release?.version ?? ''}),
                  textAlign: TextAlign.center,
                  style: AppType.h2,
                ),
                const SizedBox(height: AppSpacing.s5),
                LinearProgressIndicator(
                  value: installing || state.progress == 0
                      ? null
                      : state.progress,
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  installing
                      ? 'update.installing'.tr()
                      : 'update.downloading'.tr(namedArgs: {
                          'pct': (state.progress * 100).round().toString()
                        }),
                  textAlign: TextAlign.center,
                  style:
                      AppType.caption.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  'update.autoBody'.tr(),
                  textAlign: TextAlign.center,
                  style:
                      AppType.bodySm.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows the optional-update dialog (used at launch and from Settings). The
/// dialog content reacts to download progress live.
Future<void> showUpdateDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const _UpdateDialog(),
  );
}

class _UpdateDialog extends ConsumerWidget {
  const _UpdateDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(updateControllerProvider);

    // Close the dialog automatically if the update was dismissed elsewhere.
    if (state.phase == UpdatePhase.idle || state.phase == UpdatePhase.upToDate) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (Navigator.of(context).canPop()) Navigator.of(context).pop();
      });
    }

    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s6),
          child: UpdateBody(
            state: state,
            mandatory: false,
            onLater: () {
              ref.read(updateControllerProvider.notifier).dismiss();
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
  }
}

/// Shared body: title, version, notes, progress and action buttons. Used by the
/// mandatory screen and the optional dialog.
class UpdateBody extends ConsumerWidget {
  const UpdateBody({
    super.key,
    required this.state,
    required this.mandatory,
    this.onLater,
  });

  final UpdateState state;
  final bool mandatory;
  final VoidCallback? onLater;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final release = state.release;
    final downloading = state.phase == UpdatePhase.downloading;
    final installing = state.phase == UpdatePhase.installing;
    final busy = downloading || installing;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          mandatory
              ? PhosphorIconsRegular.warningCircle
              : PhosphorIconsRegular.downloadSimple,
          size: 40,
          color: mandatory ? AppColors.dangerRed : AppColors.policeNavy,
        ),
        const SizedBox(height: AppSpacing.s3),
        Text(
          (mandatory ? 'update.mandatoryTitle' : 'update.title').tr(),
          textAlign: TextAlign.center,
          style: AppType.h2,
        ),
        if (release != null) ...[
          const SizedBox(height: AppSpacing.s2),
          Text(
            'update.newVersion'.tr(namedArgs: {'v': release.version}),
            textAlign: TextAlign.center,
            style: AppType.bodyLg.copyWith(fontWeight: FontWeight.w600),
          ),
          if (release.notes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s4),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('update.whatsNew'.tr(),
                  style: AppType.caption
                      .copyWith(color: scheme.onSurfaceVariant)),
            ),
            const SizedBox(height: AppSpacing.s1),
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxHeight: 160),
              padding: const EdgeInsets.all(AppSpacing.s3),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text(release.notes, style: AppType.bodySm),
              ),
            ),
          ],
        ],
        if (mandatory) ...[
          const SizedBox(height: AppSpacing.s4),
          Text('update.mandatoryBody'.tr(),
              textAlign: TextAlign.center,
              style: AppType.bodySm.copyWith(color: scheme.onSurfaceVariant)),
        ],
        if (busy) ...[
          const SizedBox(height: AppSpacing.s5),
          LinearProgressIndicator(
            value: installing || state.progress == 0 ? null : state.progress,
          ),
          const SizedBox(height: AppSpacing.s2),
          Text(
            installing
                ? 'update.installing'.tr()
                : 'update.downloading'.tr(namedArgs: {
                    'pct': (state.progress * 100).round().toString()
                  }),
            textAlign: TextAlign.center,
            style: AppType.caption.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
        if (state.error != null && !busy) ...[
          const SizedBox(height: AppSpacing.s3),
          Text(state.error!.tr(),
              textAlign: TextAlign.center,
              style: AppType.bodySm.copyWith(color: AppColors.dangerRed)),
        ],
        const SizedBox(height: AppSpacing.s6),
        CrmsButton(
          label: 'update.updateNow'.tr(),
          icon: PhosphorIconsRegular.downloadSimple,
          expand: true,
          loading: busy,
          onPressed: busy
              ? null
              : () =>
                  ref.read(updateControllerProvider.notifier).downloadAndInstall(),
        ),
        if (!mandatory && !busy) ...[
          const SizedBox(height: AppSpacing.s2),
          CrmsButton(
            label: 'update.later'.tr(),
            variant: CrmsButtonVariant.ghost,
            expand: true,
            onPressed: onLater,
          ),
        ],
      ],
    );
  }
}
