import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/branding.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

/// Renders the vendor (DB Square Technology) logo from
/// [Branding.companyLogoAsset]. Falls back to a styled monogram until the real
/// PNG is added, so the build never breaks on a missing asset.
class CompanyLogo extends StatelessWidget {
  const CompanyLogo({super.key, this.size = 56, this.color});

  final double size;

  /// Tint for the fallback monogram (defaults to khaki for dark panels).
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      Branding.companyLogoAsset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _Fallback(size: size, color: color),
    );
  }
}

/// A compact "Software by DB Square Technology" strip with the company logo.
/// Reused on the splash, login, settings and sidebar so the vendor mark stays
/// consistent everywhere it appears. [onDark] tints text/logo for dark panels
/// (e.g. the navy sidebar / splash); leave false on light surfaces.
class PoweredByStrip extends StatelessWidget {
  const PoweredByStrip({
    super.key,
    this.onDark = false,
    this.logoSize = 20,
    this.center = true,
  });

  final bool onDark;
  final double logoSize;
  final bool center;

  @override
  Widget build(BuildContext context) {
    final labelColor =
        onDark ? AppColors.policeKhaki : Theme.of(context).hintColor;
    final nameColor = onDark
        ? Colors.white
        : Theme.of(context).colorScheme.onSurface;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'access.poweredBy'.tr(),
          style: AppType.caption.copyWith(color: labelColor),
        ),
        const SizedBox(height: AppSpacing.s2),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CompanyLogo(
                size: logoSize,
                color: onDark ? AppColors.policeKhaki : AppColors.policeNavy),
            const SizedBox(width: AppSpacing.s2),
            // Flexible so a larger logo can't push the name into an overflow in
            // the narrow sidebar footer.
            Flexible(
              child: Text(
                Branding.companyName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppType.bodySm.copyWith(
                  color: nameColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.size, this.color});
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? AppColors.policeKhaki;
    return SizedBox(
      width: size,
      height: size,
      child: Icon(Icons.business_rounded, size: size, color: tint),
    );
  }
}
