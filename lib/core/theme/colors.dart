import 'package:flutter/material.dart';

/// CRMS color system — built around the Maharashtra Police identity
/// (khaki, dark navy, gold). Warm-tinted neutrals, deeper-than-Material
/// semantic colors. Reference these tokens everywhere; never hard-code hex.
abstract final class AppColors {
  // --- Brand ---------------------------------------------------------------
  static const policeNavy = Color(0xFF0B2545); // primary: headers, buttons
  static const policeNavyDark = Color(0xFF06182F); // hover / pressed
  static const policeKhaki = Color(0xFFB8956A); // accent (the uniform)
  static const policeKhakiLight = Color(0xFFE8DCC4); // subtle bg, badges
  static const policeGold = Color(0xFFC9A227); // emblem / awards — sparingly

  // --- Semantic ------------------------------------------------------------
  static const successGreen = Color(0xFF0F7B3F); // solved / success
  static const warningAmber = Color(0xFFB4690E); // pending / attention
  static const dangerRed = Color(0xFFA01919); // critical / wanted / error
  static const infoBlue = Color(0xFF1B5A8C); // informational only

  // --- Neutrals (warm-tinted, not pure gray) -------------------------------
  static const ink900 = Color.fromARGB(255, 32, 37, 63); // primary text
  static const ink700 = Color(0xFF3D434E); // secondary text
  static const ink500 = Color(0xFF6B7280); // tertiary / captions
  static const ink300 = Color(0xFFCBD0D8); // borders
  static const ink100 = Color(0xFFF1F2F5); // subtle backgrounds
  static const surface = Color(0xFFFAFAF7); // app background (warm cream)
  static const cardSurface = Color(0xFFFFFFFF); // cards on top of surface

  // --- Dark mode -----------------------------------------------------------
  static const darkSurface = Color(0xFF0E1218);
  static const darkCard = Color(0xFF161B23);
  static const darkBorder = Color(0xFF252B36);
  static const darkInk = Color(0xFFE4E6EB); // primary text on dark
  static const darkInk700 = Color(0xFFAEB4BF); // secondary text on dark
  static const darkInk500 = Color(0xFF7C828D); // tertiary text on dark

  // --- Status helpers ------------------------------------------------------
  /// Tinted background for filled status pills (semantic color at low opacity).
  static Color tint(Color base, [double opacity = 0.12]) =>
      base.withValues(alpha: opacity);
}
