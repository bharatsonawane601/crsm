/// 8-point spacing grid. Every value is a multiple of 4. Reference these
/// tokens for padding, gaps and margins — never magic numbers.
abstract final class AppSpacing {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 20;
  static const double s6 = 24;
  static const double s8 = 32;
  static const double s10 = 40;
  static const double s12 = 48;
  static const double s16 = 64;

  // Semantic aliases (density rules from the design system).
  static const double pageMargin = s8; // 32 — desktop page margin
  static const double cardPadding = s6; // 24 — card interior
  static const double sectionGap = s8; // 32 — between major sections
  static const double itemGap = s4; // 16 — between related items
  static const double fieldGap = s3; // 12 — between sibling fields
  static const double controlHeight = s10; // 40 — buttons / inputs
}
