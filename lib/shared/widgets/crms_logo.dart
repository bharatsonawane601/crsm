import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/radii.dart';

/// Renders the CRMS logo from assets/images/crms_logo.png. The logo is navy on
/// white, so it's wrapped in a white card to stay visible on the navy splash /
/// login panel. Falls back to a shield mark until the PNG is added.
class CrmsLogo extends StatelessWidget {
  const CrmsLogo({super.key, this.size = 160, this.onCard = true});

  /// Edge length of the logo box.
  final double size;

  /// Wrap in a white rounded card (for placement on dark backgrounds).
  final bool onCard;

  static const _asset = 'assets/images/crms_logo.png';

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      _asset,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _Fallback(size: size),
    );

    if (!onCard) return image;

    return Container(
      padding: EdgeInsets.all(size * 0.06),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadii.brXl,
      ),
      child: image,
    );
  }
}

class _Fallback extends StatelessWidget {
  const _Fallback({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(PhosphorIconsRegular.shieldCheck,
              size: size * 0.5, color: AppColors.policeNavy),
          SizedBox(height: size * 0.05),
          Text('CRMS',
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                fontSize: size * 0.18,
                color: AppColors.policeNavy,
              )),
        ],
      ),
    );
  }
}
