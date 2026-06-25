import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'colors.dart';
import 'radii.dart';
import 'spacing.dart';
import 'typography.dart';

/// Light + dark [ThemeData] for CRMS, assembled from the design tokens
/// (colors / typography / spacing / radii). Components read these defaults so
/// the look stays consistent without per-widget styling.
abstract final class CrmsTheme {
  static ThemeData light() => _build(Brightness.light);
  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final scaffoldBg = isDark ? AppColors.darkSurface : AppColors.surface;
    final cardBg = isDark ? AppColors.darkCard : AppColors.cardSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.ink300;
    final inkPrimary = isDark ? AppColors.darkInk : AppColors.ink900;
    final inkSecondary = isDark ? AppColors.darkInk700 : AppColors.ink700;
    final subtleBg = isDark ? AppColors.darkBorder : AppColors.ink100;
    final focusColor =
        isDark ? AppColors.policeKhaki : AppColors.policeNavy;

    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: AppColors.policeNavy,
      onPrimary: Colors.white,
      primaryContainer: AppColors.policeKhakiLight,
      onPrimaryContainer: AppColors.policeNavy,
      secondary: AppColors.policeKhaki,
      onSecondary: Colors.white,
      secondaryContainer: AppColors.policeKhakiLight,
      onSecondaryContainer: AppColors.policeNavyDark,
      tertiary: AppColors.infoBlue,
      onTertiary: Colors.white,
      error: AppColors.dangerRed,
      onError: Colors.white,
      surface: cardBg,
      onSurface: inkPrimary,
      onSurfaceVariant: inkSecondary,
      surfaceContainerHighest: subtleBg,
      outline: border,
      outlineVariant: border,
    );

    final textTheme =
        AppType.textTheme(primary: inkPrimary, secondary: inkSecondary);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBg,
      canvasColor: scaffoldBg,
      fontFamily: AppType.sans,
      fontFamilyFallback: const [AppType.devanagari],
      textTheme: textTheme,
      dividerColor: border,
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      iconTheme: IconThemeData(color: inkSecondary, size: 20),

      // Top bar is brand navy in both modes.
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.policeNavy,
        foregroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        toolbarHeight: 56,
        titleTextStyle: TextStyle(
          fontFamily: AppType.sans,
          fontFamilyFallback: [AppType.devanagari],
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white, size: 20),
      ),

      cardTheme: CardThemeData(
        color: cardBg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadii.brLg,
          side: BorderSide(color: border),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardBg,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
        border: const OutlineInputBorder(borderRadius: AppRadii.brMd),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.brMd,
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.brMd,
          borderSide: BorderSide(color: focusColor, width: 2),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppRadii.brMd,
          borderSide: BorderSide(color: AppColors.dangerRed),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: AppRadii.brMd,
          borderSide: BorderSide(color: AppColors.dangerRed, width: 2),
        ),
        labelStyle: AppType.bodySm.copyWith(color: inkSecondary),
        helperStyle: AppType.caption.copyWith(color: inkSecondary),
        hintStyle: AppType.body.copyWith(
            color: isDark ? AppColors.darkInk500 : AppColors.ink500),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.policeNavy,
          foregroundColor: Colors.white,
          elevation: 0,
          minimumSize: const Size(0, AppSpacing.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.brMd),
          textStyle: AppType.body.copyWith(fontWeight: FontWeight.w500),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: inkPrimary,
          minimumSize: const Size(0, AppSpacing.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          side: BorderSide(color: border),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.brMd),
          textStyle: AppType.body.copyWith(fontWeight: FontWeight.w500),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.policeNavy,
          minimumSize: const Size(0, AppSpacing.controlHeight),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.brMd),
          textStyle: AppType.body.copyWith(fontWeight: FontWeight.w500),
        ),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: subtleBg,
        side: BorderSide(color: border),
        labelStyle: AppType.caption.copyWith(color: inkPrimary),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.brSm),
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: cardBg,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.brXl),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isDark ? AppColors.darkCard : AppColors.ink900,
        contentTextStyle: AppType.body.copyWith(color: Colors.white),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.brMd),
      ),

      progressIndicatorTheme:
          const ProgressIndicatorThemeData(color: AppColors.policeNavy),
    );
  }
}

/// App theme mode (light/dark). Toggle from the top bar (wired in a later step).
class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.light;

  void toggle() =>
      state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

  void set(ThemeMode mode) => state = mode;
}

final themeModeProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);
