import 'package:flutter/widgets.dart';

/// Corner-radius tokens. Restrained — no pill-shaped or cartoonish rounding.
abstract final class AppRadii {
  static const double sm = 4; // badges, small chips
  static const double md = 6; // buttons, inputs
  static const double lg = 8; // cards
  static const double xl = 12; // modals

  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
}
