import 'package:flutter/material.dart';

import 'undetected_report_model.dart';

/// The "उघडकीस न आलेल्या भाग १ ते ५" review: crime-head rows × police-station
/// columns of undetected crimes, with सर्व चोरी's ** subset rows (excluded from
/// totals), row एकूण, column एकूण and a grand total. Rendered on screen (with row
/// edit/delete when [editable]) and captured to PNG for the PDF.
class UndetectedTableView extends StatelessWidget {
  const UndetectedTableView({
    super.key,
    required this.data,
    required this.range,
    this.editable = false,
    this.onEdit,
    this.onDelete,
    this.forCapture = false,
  });

  final UndetData data;
  final UndetRange range;
  final bool editable;
  final void Function(UndetRow row)? onEdit;
  final void Function(UndetRow row)? onDelete;
  final bool forCapture;

  static const _line = BorderSide(color: Color(0xFF444444), width: 0.6);
  static const _headBg = Color(0xFFEDE7D6);
  static const _totBg = Color(0xFFF3F0E6);

  String _d(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final n = data.stations.length;
    final widths = <int, TableColumnWidth>{
      0: const FixedColumnWidth(32),
      1: const FixedColumnWidth(112),
      for (var i = 0; i < n; i++) i + 2: const FixedColumnWidth(58),
      n + 2: const FixedColumnWidth(52), // एकूण
      if (editable) n + 3: const FixedColumnWidth(78),
    };

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('परिमंडळ मधील उघडकीस न आलेल्या भाग १ ते ५ गुन्ह्यांचा आढावा.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'NotoSansDevanagari',
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: Color(0xFF7A1F1F),
              )),
          const SizedBox(height: 2),
          Text('दिनांक ${_d(range.from)} ते ${_d(range.to)} पावेतो.',
              style: const TextStyle(
                fontFamily: 'NotoSansDevanagari',
                fontWeight: FontWeight.bold,
                fontSize: 12,
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
              ..._bodyRows(),
              _totalRow(),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _headerRow() {
    return TableRow(
      decoration: const BoxDecoration(color: _headBg),
      children: [
        _cell('अ.क्रं.', header: true),
        _cell('हेड', header: true, align: TextAlign.left),
        for (final s in data.stations) _cell(s, header: true),
        _cell('एकूण', header: true),
        if (editable) _cell('', header: true),
      ],
    );
  }

  List<TableRow> _bodyRows() {
    final rows = <TableRow>[];
    var serial = 0;
    for (final rr in data.rows) {
      final info = rr.row.informational;
      if (!info) serial++;
      rows.add(TableRow(children: [
        _cell(info ? '**' : '$serial', header: info),
        Padding(
          padding: EdgeInsets.only(left: info ? 14 : 0),
          child: _cell(rr.row.label, align: TextAlign.left, header: info),
        ),
        for (final s in data.stations) _cell('${rr.at(s)}'),
        _cell('${rr.total}', header: true),
        if (editable)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                tooltip: 'Edit',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.edit, size: 16),
                onPressed: onEdit == null ? null : () => onEdit!(rr.row),
              ),
              IconButton(
                tooltip: 'Delete',
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.delete_outline, size: 16),
                onPressed: (onDelete == null || rr.row.isRemainder)
                    ? null
                    : () => onDelete!(rr.row),
              ),
            ],
          ),
      ]));
    }
    return rows;
  }

  TableRow _totalRow() {
    return TableRow(
      decoration: const BoxDecoration(color: _totBg),
      children: [
        _cell('', header: true),
        _cell('एकूण:-', align: TextAlign.left, header: true),
        for (final s in data.stations) _cell('${data.colTotals[s] ?? 0}', header: true),
        _cell('${data.grandTotal}', header: true),
        if (editable) _cell('', header: true),
      ],
    );
  }

  Widget _cell(String t,
      {bool header = false, TextAlign align = TextAlign.center}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
      child: Text(t,
          textAlign: align,
          style: TextStyle(
            fontFamily: 'NotoSansDevanagari',
            fontSize: header ? 10 : 11,
            fontWeight: header ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFF111111),
          )),
    );
  }
}
