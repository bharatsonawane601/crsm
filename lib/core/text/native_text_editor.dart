import 'dart:io';

import 'package:flutter/services.dart';

/// Bridge to the native (Win32) modal text editor in the Windows runner.
///
/// The native editor is a real OS edit control, so every keyboard/IME —
/// InScript, ISM typewriter, Godrej, phonetic — types Marathi correctly there,
/// exactly like Notepad/Word. The edited text is returned to Flutter.
class NativeTextEditor {
  static const MethodChannel _channel = MethodChannel('crms/native_text');

  /// Only available on Windows (where the native runner implements it).
  static bool get isSupported => Platform.isWindows;

  /// Opens the native editor seeded with [initial]; returns the edited text,
  /// or null if the user cancelled (or the platform is unsupported).
  static Future<String?> edit({String initial = '', String title = ''}) async {
    if (!isSupported) return null;
    try {
      return await _channel.invokeMethod<String>('editMarathi', {
        'text': initial,
        'title': title,
      });
    } catch (_) {
      return null;
    }
  }
}
