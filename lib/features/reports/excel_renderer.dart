import 'dart:typed_data';

import 'package:excel/excel.dart';

import 'models/report_template.dart';

/// Renders a [RenderedReport] (a label/value patrak) to an .xlsx file.
/// Excel/LibreOffice shape Devanagari correctly, so Marathi reads properly.
Uint8List renderReportExcel(RenderedReport report) {
  final excel = Excel.createExcel();
  final sheet = excel[excel.getDefaultSheet()!];

  // Title row.
  sheet.appendRow([TextCellValue(report.header)]);
  // Column header.
  sheet.appendRow([
    TextCellValue('क्र.'),
    TextCellValue('तपशील'),
    TextCellValue('माहिती'),
  ]);
  // Data rows.
  for (final r in report.rows) {
    sheet.appendRow([
      TextCellValue(r.sr?.toString() ?? ''),
      TextCellValue(r.label),
      TextCellValue(r.value),
    ]);
  }

  final bytes = excel.encode();
  return Uint8List.fromList(bytes ?? <int>[]);
}
