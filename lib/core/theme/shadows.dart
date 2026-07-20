import 'package:flutter/widgets.dart';

/// Shadow tokens. Used ONLY on floating elements (modals, dropdowns, toasts)
/// and dashboard KPI cards. Main-content separation uses 1px borders, not
/// shadows.
/// Every shadow is layered: a tight, near-opaque contact shadow that defines
/// the edge, plus a wide soft one that carries the lift. A single blurred
/// shadow reads as grey haze and is what makes a UI look flat and cheap.
/// All tinted with the brand navy rather than black, so shadows sit in the
/// warm palette instead of dirtying it.
abstract final class AppShadows {
  /// Subtle lift for KPI cards.
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x0D0B2545), // policeNavy @ 5% — contact edge
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x0F0B2545), // policeNavy @ 6% — the lift
      blurRadius: 14,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  /// Dropdowns, popovers, toasts.
  static const List<BoxShadow> popover = [
    BoxShadow(
      color: Color(0x140B2545),
      blurRadius: 3,
      offset: Offset(0, 1),
    ),
    BoxShadow(
      color: Color(0x1F0B2545),
      blurRadius: 24,
      spreadRadius: -4,
      offset: Offset(0, 8),
    ),
  ];

  /// Modals / dialogs.
  static const List<BoxShadow> modal = [
    BoxShadow(
      color: Color(0x1A0B2545),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Color(0x2E0B2545),
      blurRadius: 40,
      spreadRadius: -8,
      offset: Offset(0, 16),
    ),
  ];
}
