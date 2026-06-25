import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/branding.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/crms.dart';
import '../legal/legal_screen.dart';

/// First screen on launch: greets the user for Chh. Sambhaji Nagar Police and
/// leads into Google sign-in. Shown only when no session is active.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key, required this.onContinue});

  /// Called when the user taps "Get Started".
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.policeNavy,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.s8),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CrmsLogo(size: 160),
                  const SizedBox(height: AppSpacing.s8),
                  Text(
                    'welcome.title'.tr(),
                    textAlign: TextAlign.center,
                    style: AppType.h1.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.s3),
                  Text(
                    'welcome.subtitle'.tr(),
                    textAlign: TextAlign.center,
                    style: AppType.bodyLg
                        .copyWith(color: AppColors.policeKhakiLight),
                  ),
                  const SizedBox(height: AppSpacing.s10),
                  CrmsButton(
                    label: 'welcome.getStarted'.tr(),
                    expand: true,
                    onPressed: onContinue,
                  ),
                  const SizedBox(height: AppSpacing.s10),
                  // Vendor strip.
                  Column(
                    children: [
                      Text(
                        'access.poweredBy'.tr(),
                        style: AppType.caption
                            .copyWith(color: AppColors.policeKhaki),
                      ),
                      const SizedBox(height: AppSpacing.s2),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CompanyLogo(size: 22, color: AppColors.policeKhaki),
                          const SizedBox(width: AppSpacing.s2),
                          Text(
                            Branding.companyName,
                            style: AppType.bodySm.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.s3),
                      // Legal links.
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _LegalLink(
                              label: 'legal.privacy'.tr(),
                              doc: LegalDoc.privacy),
                          Text('  ·  ',
                              style: AppType.caption
                                  .copyWith(color: AppColors.policeKhaki)),
                          _LegalLink(
                              label: 'legal.terms'.tr(), doc: LegalDoc.terms),
                          Text('  ·  ',
                              style: AppType.caption
                                  .copyWith(color: AppColors.policeKhaki)),
                          _LegalLink(
                              label: 'legal.copyright'.tr(),
                              doc: LegalDoc.copyright),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Small khaki text link to a legal document, used in the welcome footer.
class _LegalLink extends StatelessWidget {
  const _LegalLink({required this.label, required this.doc});

  final String label;
  final LegalDoc doc;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => openLegal(context, doc),
      child: Text(
        label,
        style: AppType.caption.copyWith(
          color: AppColors.policeKhakiLight,
          decoration: TextDecoration.underline,
          decorationColor: AppColors.policeKhakiLight,
        ),
      ),
    );
  }
}
