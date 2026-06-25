import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

/// Renders an officer-portal crime/FIR detail to a one-page PDF. Marathi is
/// captured via Flutter's text engine (so matras shape correctly) and embedded
/// as an image — the same approach the main report engine uses.
Future<Uint8List> renderPortalCrimePdf({
  required String title,
  required List<(String, String)> rows,
}) async {
  final width = 820.0;
  final height = 220.0 + rows.length * 40.0;

  final png = await ScreenshotController().captureFromWidget(
    _PortalDocument(title: title, rows: rows),
    pixelRatio: 2.0,
    targetSize: Size(width, height),
    delay: const Duration(milliseconds: 60),
  );

  final doc = pw.Document();
  final image = pw.MemoryImage(png);
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(24),
      build: (_) => pw.Align(
        alignment: pw.Alignment.topCenter,
        child: pw.Image(image, fit: pw.BoxFit.contain),
      ),
    ),
  );
  return doc.save();
}

class _PortalDocument extends StatelessWidget {
  const _PortalDocument({required this.title, required this.rows});
  final String title;
  final List<(String, String)> rows;

  static const _border = BorderSide(color: Color(0xFF000000), width: 0.7);

  TableRow _row(String label, String value, {bool header = false}) {
    final style = TextStyle(
      fontFamily: 'NotoSansDevanagari',
      fontSize: 14,
      color: const Color(0xFF000000),
      fontWeight: header ? FontWeight.bold : FontWeight.normal,
    );
    Widget cell(String t) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(t, style: style),
        );
    return TableRow(
      decoration:
          header ? const BoxDecoration(color: Color(0xFFE8EEF6)) : null,
      children: [cell(label), cell(value)],
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
                title,
                style: const TextStyle(
                  fontFamily: 'NotoSansDevanagari',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(height: 16),
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
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(4),
              },
              children: [
                _row('Field', 'Details', header: true),
                for (final r in rows) _row(r.$1, r.$2),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
