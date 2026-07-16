import 'package:flutter/material.dart';

import 'bhag_model.dart' show BhagPeriod, kMonthsMr;
import 'preventive_report_model.dart';

/// The प्रतिबंधक कार्यवाही table: provisions down the side, two [माहे-A | माहे-B |
/// घट/वाढ] blocks (month then cumulative पावेतो) plus a सन-A column. Rendered on
/// screen (with row edit/delete when [editable]) and captured to PNG for the PDF.
class PreventiveTableView extends StatelessWidget {
  const PreventiveTableView({
    super.key,
    required this.data,
    required this.period,
    this.editable = false,
    this.onEdit,
    this.onDelete,
    this.forCapture = false,
  });

  final PreventiveTableData data;
  final BhagPeriod period;
  final bool editable;
  final void Function(PreventiveRow row)? onEdit;
  final void Function(PreventiveRow row)? onDelete;
  final bool forCapture;

  static const _line = BorderSide(color: Color(0xFF444444), width: 0.6);
  static const _headBg = Color(0xFFEDE7D6);
  static const _totBg = Color(0xFFF3F0E6);

  String get _mon => kMonthsMr[period.month];

  @override
  Widget build(BuildContext context) {
    final widths = <int, TableColumnWidth>{
      0: const FixedColumnWidth(34),
      1: const FixedColumnWidth(150),
      for (var i = 2; i <= 8; i++) i: const FixedColumnWidth(66),
      if (editable) 9: const FixedColumnWidth(78),
    };

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('प्रतिबंधक कार्यवाही',
              style: TextStyle(
                fontFamily: 'NotoSansDevanagari',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF7A1F1F),
              )),
          const SizedBox(height: 8),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            border: const TableBorder(
              top: _line,
              bottom: _line,
              left: _line,
              right: _line,
              horizontalInside: _line,
              verticalInside: _line,
            ),
            columnWidths: widths,
            children: [
              _headerRow(),
              for (final (row, res) in data.rows) _bodyRow(row, res),
              _totalRow(),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _headerRow() {
    final a = period.yearA, b = period.yearB;
    final headers = [
      'अ.क्र.',
      'विवरण',
      '$_mon-$a पावेतो',
      '$_mon-$b पावेतो',
      'घट/वाढ',
      '$_mon-$a पावेतो',
      '$_mon-$b पावेतो',
      'घट/वाढ',
      'सन $a',
    ];
    return TableRow(
      decoration: const BoxDecoration(color: _headBg),
      children: [
        for (var i = 0; i < headers.length; i++)
          _cell(headers[i], header: true, align: i == 1 ? TextAlign.left : TextAlign.center),
        if (editable) _cell('', header: true),
      ],
    );
  }

  TableRow _bodyRow(PreventiveRow row, PreventiveRowResult res) {
    var serial = data.rows.indexWhere((e) => e.$1.id == row.id) + 1;
    return TableRow(children: [
      _cell('$serial'),
      _cell(row.label, align: TextAlign.left),
      _cell('${res.cell('mA')}'),
      _cell('${res.cell('mB')}'),
      _gv(res.gvMonth),
      _cell('${res.cell('yA')}'),
      _cell('${res.cell('yB')}'),
      _gv(res.gvYtd),
      _cell('${res.cell('sA')}'),
      if (editable)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Edit',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.edit, size: 16),
              onPressed: onEdit == null ? null : () => onEdit!(row),
            ),
            IconButton(
              tooltip: 'Delete',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.delete_outline, size: 16),
              onPressed: onDelete == null ? null : () => onDelete!(row),
            ),
          ],
        ),
    ]);
  }

  TableRow _totalRow() {
    final t = data.total;
    return TableRow(
      decoration: const BoxDecoration(color: _totBg),
      children: [
        _cell('', header: true),
        _cell('एकूण', align: TextAlign.left, header: true),
        _cell('${t.cell('mA')}', header: true),
        _cell('${t.cell('mB')}', header: true),
        _gv(t.gvMonth, header: true),
        _cell('${t.cell('yA')}', header: true),
        _cell('${t.cell('yB')}', header: true),
        _gv(t.gvYtd, header: true),
        _cell('${t.cell('sA')}', header: true),
        if (editable) _cell('', header: true),
      ],
    );
  }

  // घट/वाढ: positive = decrease (घट), negative = increase (वाढ, shown rose).
  Widget _gv(int v, {bool header = false}) =>
      _cell('$v', header: header, color: v < 0 ? const Color(0xFFB00020) : null);

  Widget _cell(String t,
      {bool header = false, TextAlign align = TextAlign.center, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      child: Text(t,
          textAlign: align,
          style: TextStyle(
            fontFamily: 'NotoSansDevanagari',
            fontSize: header ? 10 : 11,
            fontWeight: header ? FontWeight.bold : FontWeight.normal,
            color: color ?? const Color(0xFF111111),
          )),
    );
  }
}
