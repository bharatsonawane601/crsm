import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

/// CRMS text input: label sits above the field (13/500), 40px field with a
/// 2px navy focus outline (from the theme), helper/error below, red required
/// asterisk. Pass [controller] or [initialValue], not both.
class CrmsTextField extends StatelessWidget {
  const CrmsTextField({
    super.key,
    this.label,
    this.hint,
    this.initialValue,
    this.controller,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.maxLines = 1,
    this.helperText,
    this.required = false,
    this.enabled = true,
    this.prefixIcon,
    this.suffix,
  });

  final String? label;
  final String? hint;
  final String? initialValue;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final int maxLines;
  final String? helperText;
  final bool required;
  final bool enabled;
  final IconData? prefixIcon;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final label = this.label;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text.rich(
            TextSpan(
              text: label,
              style: AppType.bodySm
                  .copyWith(color: AppColors.ink700, fontWeight: FontWeight.w500),
              children: required
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: AppColors.dangerRed),
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.s1 + 2), // 6px
        ],
        TextFormField(
          controller: controller,
          initialValue: initialValue,
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLines: obscureText ? 1 : maxLines,
          enabled: enabled,
          autocorrect: false,
          enableSuggestions: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          decoration: InputDecoration(
            hintText: hint,
            helperText: helperText,
            prefixIcon: prefixIcon == null ? null : Icon(prefixIcon, size: 20),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
