import 'package:flutter/material.dart';

import '../../core/text/native_text_editor.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import 'native_edit_button.dart';

/// CRMS text input: label sits above the field (13/500), 40px field with a
/// 2px navy focus outline (from the theme), helper/error below, red required
/// asterisk. Pass [controller] or [initialValue], not both.
///
/// On Windows a small "अ" button opens the native OS text box for reliable
/// Marathi typing with any keyboard/IME — including the mechanical typewriter
/// layout Flutter's own fields can't drive. Set [nativeEditor] false (or supply
/// your own [suffix], or use a number/obscured field) to hide it.
class CrmsTextField extends StatefulWidget {
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
    this.nativeEditor = true,
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
  final bool nativeEditor;

  @override
  State<CrmsTextField> createState() => _CrmsTextFieldState();
}

class _CrmsTextFieldState extends State<CrmsTextField> {
  // Own a controller only when the caller didn't supply one (so the native
  // editor always has something to read/write); dispose only what we created.
  TextEditingController? _internal;
  TextEditingController get _controller =>
      widget.controller ?? (_internal ??= TextEditingController(text: widget.initialValue));

  @override
  void dispose() {
    _internal?.dispose();
    super.dispose();
  }

  // Offer the native editor for free-text fields (not numbers/passwords) on
  // Windows, and never override a suffix the caller explicitly provided.
  bool get _showNative =>
      widget.nativeEditor &&
      widget.suffix == null &&
      !widget.obscureText &&
      NativeTextEditor.isSupported &&
      widget.keyboardType != TextInputType.number;

  @override
  Widget build(BuildContext context) {
    final label = widget.label;
    final suffix = widget.suffix ??
        (_showNative
            ? NativeEditButton.maybe(_controller,
                title: label ?? '', onEdited: widget.onChanged)
            : null);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text.rich(
            TextSpan(
              text: label,
              style: AppType.bodySm
                  .copyWith(color: AppColors.ink700, fontWeight: FontWeight.w500),
              children: widget.required
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
          controller: _controller,
          onChanged: widget.onChanged,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLines: widget.obscureText ? 1 : widget.maxLines,
          enabled: widget.enabled,
          autocorrect: false,
          enableSuggestions: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          decoration: InputDecoration(
            hintText: widget.hint,
            helperText: widget.helperText,
            prefixIcon:
                widget.prefixIcon == null ? null : Icon(widget.prefixIcon, size: 20),
            suffixIcon: suffix,
          ),
        ),
      ],
    );
  }
}
