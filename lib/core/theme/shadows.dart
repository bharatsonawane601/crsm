import 'package:flutter/widgets.dart';

/// Shadow tokens. Used ONLY on floating elements (modals, dropdowns, toasts)
/// and dashboard KPI cards. Main-content separation uses 1px borders, not
/// shadows.
abstract final class AppShadows {
  /// Subtle lift for KPI cards.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0F0B2545), // policeNavy @ ~6%
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  /// Dropdowns, popovers, toasts.
  static const List<BoxShadow> popover = [
    BoxShadow(
      color: Color(0x14000000), // 8%
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  /// Modals / dialogs.
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x14000000), // 8%
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];
}
