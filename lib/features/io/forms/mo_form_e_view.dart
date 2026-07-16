import 'package:flutter/material.dart';

import 'mo_form_e_model.dart';

/// Pixel-exact rendering of FORM "E". Used both on screen (tap a row to edit)
/// and captured to PNG for the PDF. Marathi shapes correctly because the widget
/// is rasterised, then embedded.
class MoFormEView extends StatelessWidget {
  const MoFormEView({
    super.key,
    required this.values,
    this.width = 760,
    this.onTapRow,
  });

  final Map<String, String> values;
  final double width;

  /// Tapping a row (on screen) edits it; null when capturing for the PDF.
  final void Function(MoRow row)? onTapRow;

  static const _font = 'NotoSansDevanagari';
  static const _border = BorderSide(color: Colors.black, width: 0.8);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: DefaultTextStyle(
        style: const TextStyle(
            fontFamily: _font, color: Colors.black, fontSize: 13, height: 1.35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Center(
              child: Text('FORM "E"',
                  style: TextStyle(
                      fontFamily: 'Times New Roman',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            const SizedBox(height: 2),
            const Center(
              child: Text('मोडस ऑपरेंडी ब्युरोला पुरविण्यात यावयाची माहिती',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: _font,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)),
            ),
            const SizedBox(height: 10),
            Table(
              border: const TableBorder(
                top: _border,
                bottom: _border,
                left: _border,
                right: _border,
                horizontalInside: _border,
                verticalInside: _border,
              ),
              columnWidths: const {
                0: FixedColumnWidth(34),
                1: FlexColumnWidth(2.2),
                2: FlexColumnWidth(3.0),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.top,
              children: [
                for (final r in kMoFormERows) _row(r),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _row(MoRow r) {
    final value = values[r.id] ?? '';
    return TableRow(
      children: [
        _cell(Text('${r.number}.',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontFamily: _font, fontWeight: FontWeight.bold, fontSize: 13))),
        _cell(Text(r.mr, style: const TextStyle(fontFamily: _font, fontSize: 13))),
        _tappable(
            r,
            _cell(Text(value,
                style: const TextStyle(fontFamily: _font, fontSize: 13)))),
      ],
    );
  }

  Widget _cell(Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        child: child,
      );

  Widget _tappable(MoRow r, Widget child) {
    if (onTapRow == null) return child;
    return TableRowInkWell(
      onTap: () => onTapRow!(r),
      child: child,
    );
  }
}
