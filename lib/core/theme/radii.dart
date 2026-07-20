import 'package:flutter/widgets.dart';

/// Corner-radius tokens. Restrained — no pill-shaped or cartoonish rounding.
abstract final class AppRadii {
  static const double sm = 5; // badges, small chips
  static const double md = 8; // buttons, inputs
  static const double lg = 12; // cards
  static const double xl = 16; // modals

  static const BorderRadius brSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius brMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius brLg = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius brXl = BorderRadius.all(Radius.circular(xl));
}
