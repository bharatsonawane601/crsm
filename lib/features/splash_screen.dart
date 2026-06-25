import 'package:flutter/material.dart';

import '../core/theme/colors.dart';
import '../core/theme/typography.dart';
import '../shared/widgets/crms.dart';

/// Launch splash — navy field with the CRMS logo.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.policeNavy,
      child: Center(child: _SplashContent()),
    );
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CrmsLogo(size: 240),
        const SizedBox(height: 40),
        SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation(
                AppColors.policeKhaki.withValues(alpha: 0.8)),
          ),
        ),
        const SizedBox(height: 48),
        Text(
          '© Maharashtra Police',
          style: AppType.caption.copyWith(color: AppColors.policeKhaki),
        ),
        const SizedBox(height: 16),
        const PoweredByStrip(onDark: true),
      ],
    );
  }
}
