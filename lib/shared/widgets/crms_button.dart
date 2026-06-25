import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';

/// The only four button variants in CRMS. No gradients, no shadows, no 3D.
enum CrmsButtonVariant { primary, secondary, ghost, danger }

/// Standard CRMS button. 40px tall, 6px radius, Inter 500. Supports a leading
/// [icon] and a [loading] state (label stays, action disabled).
class CrmsButton extends StatelessWidget {
  const CrmsButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = CrmsButtonVariant.primary,
    this.icon,
    this.loading = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final CrmsButtonVariant variant;
  final IconData? icon;
  final bool loading;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;

    final spinnerColor = switch (variant) {
      CrmsButtonVariant.primary || CrmsButtonVariant.danger => Colors.white,
      _ => AppColors.policeNavy,
    };

    final content = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (loading)
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: spinnerColor),
          )
        else if (icon != null)
          Icon(icon, size: 18),
        if (loading || icon != null) const SizedBox(width: 8),
        Text(label),
      ],
    );

    final Widget button = switch (variant) {
      CrmsButtonVariant.primary =>
        FilledButton(onPressed: enabled ? onPressed : null, child: content),
      CrmsButtonVariant.danger => FilledButton(
          onPressed: enabled ? onPressed : null,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.dangerRed,
            foregroundColor: Colors.white,
          ),
          child: content,
        ),
      CrmsButtonVariant.secondary =>
        OutlinedButton(onPressed: enabled ? onPressed : null, child: content),
      CrmsButtonVariant.ghost =>
        TextButton(onPressed: enabled ? onPressed : null, child: content),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
