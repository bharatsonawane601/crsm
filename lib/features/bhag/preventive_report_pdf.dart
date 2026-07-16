import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import 'bhag_model.dart' show BhagPeriod;
import 'preventive_report_model.dart';
import 'preventive_report_view.dart';

/// Renders the प्रतिबंधक कार्यवाही table to a landscape A4 PDF (Marathi shapes
/// correctly because the Flutter table is captured to a PNG and embedded).
Future<Uint8List> renderPreventivePdf({
  required PreventiveTableData data,
  required BhagPeriod period,
}) async {
  final png = await ScreenshotController().captureFromWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.white,
        child: PreventiveTableView(
          data: data,
          period: period,
          forCapture: true,
        ),
      ),
    ),
    pixelRatio: 2.0,
    targetSize: const Size(760, 1200),
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
