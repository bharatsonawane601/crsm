import 'package:flutter/material.dart';

import 'bhag_model.dart';
import 'bhag_report_spec.dart';

/// A report comparison table (भाग १ ते ५, भाग ६, …), rendered like the police
/// sheet. The value columns come from a [BhagReportSpec], so different reports
/// reuse this one widget. Used on screen (with [editable] row actions) and
/// captured to PNG for the PDF.
class BhagTableView extends StatelessWidget {
  const BhagTableView({
    super.key,
    required this.data,
    required this.period,
    required this.columns,
    required this.titleKey,
    this.titleText,
    this.editable = false,
    this.onEdit,
    this.onDelete,
    this.forCapture = false,
  });

  final BhagTableData data;
  final BhagPeriod period;
  final List<BhagValueColumn> columns;
  final String titleKey;
  final String? titleText; // pre-translated title (for PDF capture)
  final bool editable;
  final void Function(BhagRow row)? onEdit;
  final void Function(BhagRow row)? onDelete;
  final bool forCapture;

  static const _line = BorderSide(color: Color(0xFF444444), width: 0.6);

  @override
  Widget build(BuildContext context) {
    final widths = <int, TableColumnWidth>{
      0: const FixedColumnWidth(34),
      1: const FixedColumnWidth(150),
      for (var i = 0; i < columns.length; i++)
        i + 2: FixedColumnWidth(columns[i].width),
      if (editable) columns.length + 2: const FixedColumnWidth(78),
    };

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(titleText ?? titleKey,
              style: const TextStyle(
                fontFamily: 'NotoSansDevanagari',
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFFB00020),
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

  TextStyle get _base => const TextStyle(
      fontFamily: 'NotoSansDevanagari', fontSize: 11, color: Color(0xFF111111));

  Widget _cell(String t,
      {bool header = false, TextAlign align = TextAlign.center, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
      child: Text(t,
          textAlign: align,
          style: _base.copyWith(
            fontWeight: header ? FontWeight.bold : FontWeight.normal,
            fontSize: header ? 10 : 11,
            color: color ?? const Color(0xFF111111),
          )),
    );
  }

  TableRow _headerRow() {
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFEDE7D6)),
      children: [
        _cell('अ.क्र.', header: true),
        _cell('विवरण', header: true),
        for (final c in columns) _cell(c.header, header: true),
        if (editable) _cell('', header: true),
      ],
    );
  }

  List<TableRow> _bodyRows() {
    final rows = <TableRow>[];
    var serial = 0;
    for (final g in data.groups) {
      serial++;
      rows.add(_row(
        left: '$serial',
        name: g.label,
        r: g.parent,
        editRow: g.parentEditableRow,
        bold: true,
      ));
      for (var i = 0; i < g.subs.length; i++) {
        final marker = i < kSubMarkers.length ? kSubMarkers[i] : '${i + 1}';
        rows.add(_row(
          left: '$marker)',
          name: rowLabel(g.subs[i].row),
          r: g.subs[i],
          editRow: g.subs[i].row,
          indent: true,
        ));
      }
    }
    return rows;
  }

  TableRow _row({
    required String left,
    required String name,
    required BhagRowResult r,
    BhagRow? editRow,
    bool bold = false,
    bool indent = false,
  }) {
    return TableRow(children: [
      _cell(left, header: bold),
      Padding(
        padding: EdgeInsets.only(left: indent ? 16 : 0),
        child: _cell(name, align: TextAlign.left, header: bold),
      ),
      for (final c in columns)
        _cell(c.value(r), header: bold, color: c.color?.call(r)),
      if (editable)
        (editRow == null)
            ? const SizedBox.shrink()
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Edit',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.edit, size: 16),
                    onPressed: onEdit == null ? null : () => onEdit!(editRow),
                  ),
                  IconButton(
                    tooltip: 'Delete',
                    visualDensity: VisualDensity.compact,
                    icon: const Icon(Icons.delete_outline, size: 16),
                    onPressed:
                        onDelete == null ? null : () => onDelete!(editRow),
                  ),
                ],
              ),
    ]);
  }

  TableRow _totalRow() {
    final t = data.total;
    return TableRow(
      decoration: const BoxDecoration(color: Color(0xFFF3F0E6)),
      children: [
        _cell('', header: true),
        _cell('एकूण', align: TextAlign.left, header: true),
        for (final c in columns)
          _cell(c.value(t), header: true, color: c.color?.call(t)),
        if (editable) _cell('', header: true),
      ],
    );
  }
}
