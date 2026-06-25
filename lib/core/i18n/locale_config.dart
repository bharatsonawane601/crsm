import 'package:flutter/material.dart';

/// Central definition of supported locales for the bilingual UI.
///
/// Marathi (mr) is the primary language; English (en) is the fallback.
/// All user-facing strings live in `assets/translations/{mr,en}.json` and are
/// accessed via easy_localization — never hard-code labels (PROJECT.md rule 3).
class LocaleConfig {
  static const Locale marathi = Locale('mr');
  static const Locale english = Locale('en');

  static const List<Locale> supported = [marathi, english];

  /// App opens in Marathi by default for the Maharashtra Police user base.
  static const Locale fallback = marathi;

  static const String path = 'assets/translations';
}
