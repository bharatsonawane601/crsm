import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import 'undetected_report_model.dart';
import 'undetected_report_view.dart';

/// Renders the undetected भाग-1-5 matrix to a landscape A4 PDF (Marathi shapes
/// correctly because the Flutter table is captured to a PNG and embedded).
Future<Uint8List> renderUndetectedPdf({
  required UndetData data,
  required UndetRange range,
}) async {
  // Widen the capture with the number of station columns.
  final width = (200.0 + data.stations.length * 58 + 120).clamp(760.0, 1500.0);

  final png = await ScreenshotController().captureFromWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.white,
        child: UndetectedTableView(
          data: data,
          range: range,
          forCapture: true,
        ),
      ),
    ),
    pixelRatio: 2.0,
    targetSize: Size(width, 1000),
    delay: const Duration(milliseconds: 80),
  );

  final doc = pw.Document();
  final image = pw.MemoryImage(png);
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(18),
      build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
    ),
  );
  return doc.save();
}
