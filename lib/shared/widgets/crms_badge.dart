import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/radii.dart';
import '../../core/theme/typography.dart';

/// A filled status pill: tinted background + solid colored text, 24px tall.
class CrmsBadge extends StatelessWidget {
  const CrmsBadge({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  /// Maps a crime `status` code to its semantic color and localized label.
  factory CrmsBadge.status(String statusCode) {
    final color = switch (statusCode) {
      'solved' => AppColors.successGreen,
      'chargesheeted' => AppColors.policeKhaki,
      'pending' => AppColors.warningAmber,
      'wanted' => AppColors.dangerRed,
      'investigating' => AppColors.infoBlue,
      _ => AppColors.infoBlue, // open / default
    };
    return CrmsBadge(label: 'crime.status.$statusCode'.tr(), color: color);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.tint(color, color == AppColors.policeKhaki ? 0.2 : 0.12),
        borderRadius: AppRadii.brSm,
      ),
      child: Text(
        label,
        style: AppType.caption.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
