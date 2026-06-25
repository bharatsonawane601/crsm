import 'dart:typed_data';

import 'package:excel/excel.dart';

import 'stats_report.dart';

/// Builds an .xlsx of the statistics matrix: crime-type rows × (12 months +
/// year + previous-year) each split into solved/unsolved. Labels are passed in
/// so they stay localized.
Uint8List buildStatsExcel(
  StatsReport report, {
  required String typeHeader,
  required String totalLabel,
  required List<String> monthLabels, // length 12
  required String solvedShort,
  required String unsolvedShort,
}) {
  final excel = Excel.createExcel();
  final sheet = excel[excel.getDefaultSheet()!];

  // Header row.
  final header = <CellValue>[TextCellValue(typeHeader)];
  for (final m in monthLabels) {
    header.add(TextCellValue('$m $solvedShort'));
    header.add(TextCellValue('$m $unsolvedShort'));
  }
  header.add(TextCellValue('${report.year} $solvedShort'));
  header.add(TextCellValue('${report.year} $unsolvedShort'));
  header.add(TextCellValue('${report.year - 1} $solvedShort'));
  header.add(TextCellValue('${report.year - 1} $unsolvedShort'));
  sheet.appendRow(header);

  List<CellValue> dataRow(CrimeTypeStat s, String label) {
    final row = <CellValue>[TextCellValue(label)];
    for (final c in s.months) {
      row.add(IntCellValue(c.solved));
      row.add(IntCellValue(c.unsolved));
    }
    row.add(IntCellValue(s.yearTotal.solved));
    row.add(IntCellValue(s.yearTotal.unsolved));
    row.add(IntCellValue(s.prevYearTotal.solved));
    row.add(IntCellValue(s.prevYearTotal.unsolved));
    return row;
  }

  for (final s in report.rows) {
    sheet.appendRow(dataRow(s, s.type));
  }
  sheet.appendRow(dataRow(report.totalRow, totalLabel));

  final bytes = excel.encode();
  return Uint8List.fromList(bytes ?? <int>[]);
}
