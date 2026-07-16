import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';

import 'package:crms/features/reports/docx_renderer.dart';
import 'package:crms/features/reports/excel_renderer.dart';
import 'package:crms/features/reports/models/report_template.dart';
import 'package:crms/features/reports/pdf_renderer.dart';

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

  // Note: the PDF renderer rasterizes a Flutter widget (for correct Devanagari
  // shaping), which needs a live rendering engine — that capture step is
  // verified by running the app. The pagination/slicing of the captured image
  // is pure logic, so it IS tested below.

  group('PDF page slicing', () {
    /// A synthetic captured-report image: [pages] A4-pages tall, white with a
    /// thin black "text" band on each band so rows aren't seen as blank.
    img.Image tallImage(int pageCount) {
      const w = 1600;
      final pageH = (w * (PdfPageFormat.a4.height - 48) /
              (PdfPageFormat.a4.width - 48))
          .floor();
      final im = img.Image(width: w, height: pageH * pageCount);
      img.fill(im, color: img.ColorRgb8(255, 255, 255));
      // Draw a few dark text-like bands per page, with white gaps between.
      for (var p = 0; p < pageCount; p++) {
        for (var line = 0; line < 6; line++) {
          final y = p * pageH + 40 + line * 120;
          img.fillRect(im,
              x1: 60, y1: y, x2: w - 60, y2: y + 24,
              color: img.ColorRgb8(0, 0, 0));
        }
      }
      return im;
    }

    test('a 3-page-tall image is split into multiple pages', () {
      final png = img.encodePng(tallImage(3));
      final strips = sliceReportImageForTest(png, PdfPageFormat.a4);
      expect(strips.length, greaterThan(1));
      // Every strip must decode as a valid PNG.
      for (final s in strips) {
        expect(img.decodePng(s), isNotNull);
      }
    });

    test('a short (sub-page) image stays a single page', () {
      const w = 1600;
      final im = img.Image(width: w, height: 400);
      img.fill(im, color: img.ColorRgb8(255, 255, 255));
      img.fillRect(im,
          x1: 60, y1: 40, x2: w - 60, y2: 64, color: img.ColorRgb8(0, 0, 0));
      final strips =
          sliceReportImageForTest(img.encodePng(im), PdfPageFormat.a4);
      expect(strips.length, 1);
    });
  });
}
