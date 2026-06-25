import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/crms.dart';
import 'auth_service.dart';

/// Bilingual sign-in. Split layout on desktop: navy brand panel (left, with a
/// faint emblem watermark) + form (right). All strings come from i18n.
class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider).isLoading;
    final isStub = ref.watch(isStubAuthProvider);

    ref.listen(authControllerProvider, (prev, next) {
      if (next.hasError) {
        CrmsToast.show(context,
            title: 'login.signInFailed'.tr(), type: CrmsToastType.danger);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('app.shortTitle'.tr()),
        actions: const [
          DarkModeToggle(),
          SizedBox(width: 8),
          Center(child: LanguageToggle()),
          SizedBox(width: 12),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final form = _LoginForm(isLoading: isLoading, isStub: isStub);
          if (constraints.maxWidth < 820) return form;
          return Row(
            children: [
              const Expanded(flex: 4, child: _BrandPanel()),
              Expanded(flex: 6, child: form),
            ],
          );
        },
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.policeNavy,
      child: Stack(
        children: [
          // Faint emblem watermark behind the content.
          Positioned.fill(
            child: Center(
              child: Icon(
                PhosphorIconsRegular.shieldChevron,
                size: 400,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const CrmsLogo(size: 168),
                const SizedBox(height: AppSpacing.s8),
                Text('app.title'.tr(),
                    style: AppType.h1.copyWith(color: Colors.white)),
                const SizedBox(height: AppSpacing.s6),
                Container(
                  padding: const EdgeInsets.only(left: AppSpacing.s4),
                  decoration: const BoxDecoration(
                    border: Border(
                        left: BorderSide(
                            color: AppColors.policeKhaki, width: 3)),
                  ),
                  child: Text(
                    'login.quote'.tr(),
                    style: AppType.h3.copyWith(
                      color: AppColors.policeKhakiLight,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Text('© Maharashtra Police',
                    style:
                        AppType.caption.copyWith(color: AppColors.policeKhaki)),
                const SizedBox(height: AppSpacing.s4),
                const PoweredByStrip(onDark: true, center: false),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginForm extends ConsumerWidget {
  const _LoginForm({required this.isLoading, required this.isStub});

  final bool isLoading;
  final bool isStub;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.s8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 380),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('login.heading'.tr(), style: theme.textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.s2),
              Text('login.subheading'.tr(),
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: AppSpacing.s8),
              CrmsButton(
                label: 'login.signInWithGoogle'.tr(),
                icon: PhosphorIconsRegular.googleLogo,
                loading: isLoading,
                expand: true,
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signIn(),
              ),
              if (isStub) ...[
                const SizedBox(height: AppSpacing.s5),
                Row(
                  children: [
                    Icon(PhosphorIconsRegular.info,
                        size: 14, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: AppSpacing.s2),
                    Expanded(
                      child: Text('login.stubNotice'.tr(),
                          style: AppType.caption
                              .copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
