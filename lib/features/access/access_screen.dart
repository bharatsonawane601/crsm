import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/branding.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/radii.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/platform/open_url.dart';
import '../../shared/widgets/crms.dart';
import '../auth/auth_service.dart';
import 'access_config.dart';
import 'access_service.dart';

/// Shown to a signed-in user who is not yet approved: a "waiting for approval"
/// state (auto-polls the server) or a "blocked" state (denied / wrong device).
class AccessScreen extends ConsumerStatefulWidget {
  const AccessScreen({super.key});

  @override
  ConsumerState<AccessScreen> createState() => _AccessScreenState();
}

class _AccessScreenState extends ConsumerState<AccessScreen> {
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    // While pending, re-check the server periodically so approval is picked up
    // without the user doing anything.
    _poll = Timer.periodic(AccessConfig.pollInterval, (_) {
      if (ref.read(accessControllerProvider).gate == AccessGate.pending) {
        ref.read(accessControllerProvider.notifier).recheck();
      }
    });
  }

  @override
  void dispose() {
    _poll?.cancel();
    super.dispose();
  }

  String _msg(String? m) {
    if (m == null || m.isEmpty) return 'access.error.server'.tr();
    return m.startsWith('access.') ? m.tr() : m;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(accessControllerProvider);
    final user = ref.watch(authControllerProvider).value;
    final pending = state.gate == AccessGate.pending;

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CrmsLogo(size: 88),
                const SizedBox(height: AppSpacing.s6),
                Icon(
                  pending
                      ? PhosphorIconsRegular.hourglassMedium
                      : PhosphorIconsRegular.lockKey,
                  size: 40,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: AppSpacing.s4),
                Text(
                  pending ? 'access.pendingTitle'.tr() : 'access.blockedTitle'.tr(),
                  textAlign: TextAlign.center,
                  style: AppType.h2,
                ),
                const SizedBox(height: AppSpacing.s2),
                Text(
                  pending ? 'access.pendingBody'.tr() : _msg(state.message),
                  textAlign: TextAlign.center,
                  style: AppType.bodySm.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                if (user != null) ...[
                  const SizedBox(height: AppSpacing.s4),
                  Text(user.email,
                      style: AppType.bodySm
                          .copyWith(fontWeight: FontWeight.w600)),
                ],
                const SizedBox(height: AppSpacing.s6),
                if (pending)
                  CrmsButton(
                    label: 'access.checkNow'.tr(),
                    icon: PhosphorIconsRegular.arrowsClockwise,
                    expand: true,
                    onPressed: () =>
                        ref.read(accessControllerProvider.notifier).recheck(),
                  )
                else
                  CrmsButton(
                    label: 'access.retry'.tr(),
                    icon: PhosphorIconsRegular.arrowsClockwise,
                    expand: true,
                    onPressed: () =>
                        ref.read(accessControllerProvider.notifier).recheck(),
                  ),
                const SizedBox(height: AppSpacing.s3),
                CrmsButton(
                  label: 'access.signOut'.tr(),
                  variant: CrmsButtonVariant.ghost,
                  icon: PhosphorIconsRegular.signOut,
                  expand: true,
                  onPressed: () =>
                      ref.read(authControllerProvider.notifier).signOut(),
                ),
                const SizedBox(height: AppSpacing.s8),
                const _VendorCard(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// DB Square Technology contact strip shown to a waiting user, with a button
/// that opens the company website in the default browser.
class _VendorCard extends StatelessWidget {
  const _VendorCard();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s4),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
        borderRadius: AppRadii.brLg,
        border: Border.all(color: scheme.outlineVariant),
      ),
      child: Column(
        children: [
          Text('access.poweredBy'.tr(),
              style: AppType.caption.copyWith(color: scheme.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.s2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CompanyLogo(size: 28, color: AppColors.policeNavy),
              const SizedBox(width: AppSpacing.s2),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(Branding.companyName,
                        style: AppType.h3, overflow: TextOverflow.ellipsis),
                    Text('company.tagline'.tr(),
                        style: AppType.caption
                            .copyWith(color: scheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s3),
          Text('company.needHelp'.tr(),
              textAlign: TextAlign.center,
              style: AppType.bodySm.copyWith(color: scheme.onSurfaceVariant)),
          if (Branding.supportEmail.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.s2),
            _ContactLine(
                icon: PhosphorIconsRegular.envelopeSimple,
                text: Branding.supportEmail),
          ],
          if (Branding.supportPhone.isNotEmpty)
            _ContactLine(
                icon: PhosphorIconsRegular.phone, text: Branding.supportPhone),
          const SizedBox(height: AppSpacing.s3),
          CrmsButton(
            label: 'company.visitWebsite'.tr(),
            icon: PhosphorIconsRegular.globe,
            variant: CrmsButtonVariant.secondary,
            expand: true,
            onPressed: () => openUrl(Branding.website),
          ),
          const SizedBox(height: AppSpacing.s1),
          Text(Branding.websiteLabel,
              style: AppType.caption.copyWith(color: scheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _ContactLine extends StatelessWidget {
  const _ContactLine({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 14, color: scheme.onSurfaceVariant),
        const SizedBox(width: AppSpacing.s2),
        Text(text, style: AppType.bodySm),
      ],
    );
  }
}
