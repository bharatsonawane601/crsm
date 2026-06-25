import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import 'models/report_template.dart';

/// Print/PDF text size. Because the report is captured as an image and fit to
/// the page width, a *larger* font is achieved by capturing on a *narrower*
/// canvas (so it scales up more on the page), and vice-versa.
enum ReportFontSize { small, normal, large }

/// Print/PDF page + sizing options chosen by the user before printing/saving.
class ReportPdfOptions {
  const ReportPdfOptions({
    this.fontSize = ReportFontSize.normal,
    this.pageSize, // 'A4' | 'Letter' | 'Legal'; null = template default
    this.landscape = false,
  });

  final ReportFontSize fontSize;
  final String? pageSize;
  final bool landscape;

  double get _captureScale => switch (fontSize) {
        ReportFontSize.small => 0.88,
        ReportFontSize.normal => 1.0,
        ReportFontSize.large => 1.18,
      };
}

PdfPageFormat _pageFormat(String size, bool landscape) {
  final base = switch (size.toLowerCase()) {
    'letter' => PdfPageFormat.letter,
    'legal' => PdfPageFormat.legal,
    _ => PdfPageFormat.a4,
  };
  return landscape ? base.landscape : base;
}

/// Renders a [RenderedReport] to PDF with **correct Marathi**.
///
/// The pure-Dart `pdf` package can't shape Devanagari (matras render in the
/// wrong order). So instead we render the report with Flutter's own text engine
/// — which shapes Devanagari correctly — capture it to a PNG, and embed that
/// image as the PDF page.
Future<Uint8List> renderReportPdf(
  RenderedReport report, {
  ReportPdfOptions options = const ReportPdfOptions(),
}) async {
  // Narrower canvas for a larger on-page font, wider for a smaller one.
  final width = 820.0 / options._captureScale;
  // Generous height so content never clips; extra space shows as white margin.
  final height = 240.0 + report.rows.length * 64.0;

  final png = await ScreenshotController().captureFromWidget(
    _ReportDocument(report: report),
    pixelRatio: 2.0,
    targetSize: Size(width, height),
    delay: const Duration(milliseconds: 60),
  );

  final pageFormat =
      _pageFormat(options.pageSize ?? report.pageSize, options.landscape);
  final doc = pw.Document();
  final image = pw.MemoryImage(png);
  doc.addPage(
    pw.Page(
      pageFormat: pageFormat,
      margin: const pw.EdgeInsets.all(24),
      build: (_) => pw.Align(
        alignment: pw.Alignment.topCenter,
        child: pw.Image(image, fit: pw.BoxFit.contain),
      ),
    ),
  );
  return doc.save();
}

/// The on-page report, rendered by Flutter (so Marathi shapes correctly).
class _ReportDocument extends StatelessWidget {
  const _ReportDocument({required this.report});
  final RenderedReport report;

  static const _border = BorderSide(color: Color(0xFF000000), width: 0.7);

  TableRow _row(String sr, String label, String value, {bool header = false}) {
    final style = TextStyle(
      fontFamily: 'NotoSansDevanagari',
      fontSize: 14,
      color: const Color(0xFF000000),
      fontWeight: header ? FontWeight.bold : FontWeight.normal,
    );
    Widget cell(String t, {TextAlign align = TextAlign.left}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(t, style: style, textAlign: align),
        );
    return TableRow(
      decoration: header
          ? const BoxDecoration(color: Color(0xFFE8EEF6))
          : null,
      children: [
        cell(sr, align: TextAlign.center),
        cell(label),
        cell(value),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                report.header,
                style: const TextStyle(
                  fontFamily: 'NotoSansDevanagari',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(height: 18),
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
                0: FixedColumnWidth(44),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(4),
              },
              children: [
                _row('अ.क्र.', 'विवरण', 'गुन्हयाची माहिती', header: true),
                for (final r in report.rows)
                  _row(r.sr?.toString() ?? '', r.label, r.value),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
