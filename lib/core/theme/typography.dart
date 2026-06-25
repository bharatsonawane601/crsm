import 'package:flutter/material.dart';

/// Type system. English uses Inter; Marathi (Devanagari) automatically falls
/// back to Noto Sans Devanagari via [fontFamilyFallback], so mixed-script lines
/// ("FIR क्र.") render cleanly. Codes/FIR numbers use JetBrains Mono with
/// tabular figures so columns align.
///
/// The scale styles below are intentionally color-agnostic — color is applied
/// by [AppType.textTheme] per brightness, so the same tokens serve light and
/// dark mode. Consume via `Theme.of(context).textTheme.*` or the named tokens.
abstract final class AppType {
  static const String sans = 'Inter';
  static const String devanagari = 'NotoSansDevanagari';
  static const String mono = 'JetBrainsMono';

  static const List<String> _fallback = [devanagari];

  /// Tabular figures so numbers line up in columns (KPIs, tables, reports).
  static const List<FontFeature> _tnum = [FontFeature.tabularFigures()];

  static const TextStyle display = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 32,
    height: 40 / 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.02 * 32,
    fontFeatures: _tnum,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 24,
    height: 32 / 24,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 20,
    height: 28 / 20,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle bodyLg = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 15,
    height: 24 / 15,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle body = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 14,
    height: 22 / 14,
    fontWeight: FontWeight.w400,
    fontFeatures: _tnum,
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 13,
    height: 20 / 13,
    fontWeight: FontWeight.w400,
    fontFeatures: _tnum,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: sans,
    fontFamilyFallback: _fallback,
    fontSize: 12,
    height: 16 / 12,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle monoStyle = TextStyle(
    fontFamily: mono,
    fontFamilyFallback: [sans],
    fontSize: 13,
    height: 20 / 13,
    fontWeight: FontWeight.w500,
    fontFeatures: [FontFeature.tabularFigures()],
  );

  /// Builds a Material [TextTheme] from the scale, applying [primary] for
  /// headings/body and [secondary] for muted text. Used for both modes.
  static TextTheme textTheme({
    required Color primary,
    required Color secondary,
  }) {
    return TextTheme(
      displaySmall: display.copyWith(color: primary),
      headlineMedium: h1.copyWith(color: primary),
      headlineSmall: h1.copyWith(color: primary),
      titleLarge: h2.copyWith(color: primary),
      titleMedium: h3.copyWith(color: primary),
      titleSmall: caption.copyWith(color: secondary),
      bodyLarge: bodyLg.copyWith(color: primary),
      bodyMedium: body.copyWith(color: primary),
      bodySmall: bodySm.copyWith(color: secondary),
      labelLarge: body.copyWith(color: primary, fontWeight: FontWeight.w500),
      labelMedium: caption.copyWith(color: secondary),
      labelSmall: caption.copyWith(color: secondary),
    );
  }
}
