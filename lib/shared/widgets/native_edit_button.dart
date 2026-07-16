import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../core/text/native_text_editor.dart';

/// A compact "अ" button that opens the native OS text editor — a real Win32
/// edit control where every Marathi keyboard/IME types correctly, including the
/// mechanical **typewriter** layout that Flutter's own text fields cannot drive.
/// The edited text is written back into [controller] and reported via
/// [onEdited].
///
/// Use [NativeEditButton.maybe] to get `null` on platforms without the native
/// editor (non-Windows), so it can be dropped straight into a field's
/// `suffixIcon` without reserving empty space there.
class NativeEditButton extends StatelessWidget {
  const NativeEditButton({
    super.key,
    required this.controller,
    this.title = '',
    this.onEdited,
  });

  final TextEditingController controller;

  /// Title shown on the native editor window (usually the field label).
  final String title;

  /// Called with the edited text after the native editor closes (for callers
  /// that mirror the value into a draft instead of reading the controller).
  final ValueChanged<String>? onEdited;

  /// Returns a button, or `null` where the native editor is unavailable so the
  /// caller's `suffixIcon` stays empty (and unreserved) off Windows.
  static Widget? maybe(
    TextEditingController controller, {
    String title = '',
    ValueChanged<String>? onEdited,
  }) {
    if (!NativeTextEditor.isSupported) return null;
    return NativeEditButton(
      controller: controller,
      title: title,
      onEdited: onEdited,
    );
  }

  Future<void> _open() async {
    final edited =
        await NativeTextEditor.edit(initial: controller.text, title: title);
    if (edited == null) return; // cancelled
    controller.value = TextEditingValue(
      text: edited,
      selection: TextSelection.collapsed(offset: edited.length),
    );
    onEdited?.call(edited);
  }

  @override
  Widget build(BuildContext context) {
    if (!NativeTextEditor.isSupported) return const SizedBox.shrink();
    return IconButton(
      tooltip: 'common.typeMarathi'.tr(),
      icon: const Text('अ',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      onPressed: _open,
    );
  }
}
