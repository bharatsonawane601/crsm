import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/reports/docx_renderer.dart';
import 'package:crms/features/reports/excel_renderer.dart';
import 'package:crms/features/reports/models/report_template.dart';

void main() {
  RenderedReport report() => RenderedReport(
        name: 'ब पत्रक',
        header: 'ब पत्रक',
        pageSize: 'A4',
        rows: [
          RenderedRow(sr: 1, label: 'गु.र.नं.', value: '123/2026'),
          RenderedRow(sr: 2, label: 'फिर्यादी', value: 'रमेश पाटील'),
        ],
      );

  test('DOCX renderer produces a valid OOXML zip with document.xml', () {
    final bytes = renderReportDocx(report());

    // Zip magic bytes "PK".
    expect(bytes.sublist(0, 2), [0x50, 0x4B]);

    final archive = ZipDecoder().decodeBytes(bytes);
    final names = archive.files.map((f) => f.name).toSet();
    expect(names, contains('[Content_Types].xml'));
    expect(names, contains('word/document.xml'));

    final doc = archive.files.firstWhere((f) => f.name == 'word/document.xml');
    final xml = utf8.decode(doc.content as List<int>);
    expect(xml, contains('रमेश पाटील'));
    expect(xml, contains('<w:tbl>'));
  });

  test('Excel report renderer produces a valid xlsx with the data', () {
    final bytes = renderReportExcel(report());
    expect(bytes.sublist(0, 2), [0x50, 0x4B]); // zip/xlsx magic

    final excel = Excel.decodeBytes(bytes);
    final sheet = excel.tables[excel.tables.keys.first]!;
    // Title + header + 2 data rows.
    expect(sheet.maxRows, greaterThanOrEqualTo(4));

    final flat = sheet.rows
        .expand((r) => r)
        .map((c) => c?.value)
        .whereType<TextCellValue>()
        .map((c) => c.value.text)
        .toList();
    expect(flat, contains('रमेश पाटील'));
  });

  // Note: the PDF renderer now rasterizes a Flutter widget (for correct
  // Devanagari shaping), which needs a live rendering engine — it's verified by
  // running the app, not in a unit test.
}
