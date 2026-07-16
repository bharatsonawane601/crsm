import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import 'recovered_report_model.dart';
import 'recovered_report_view.dart';
import 'station_report_model.dart';

/// Renders the recovered-property return to a landscape A4 PDF (Marathi shapes
/// correctly because the Flutter table is captured to a PNG and embedded).
Future<Uint8List> renderRecoveredReportPdf({
  required RecoveredReportData data,
  required StationReportPeriod period,
}) async {
  final png = await ScreenshotController().captureFromWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.white,
        child: RecoveredReportView(
          data: data,
          period: period,
          forCapture: true,
        ),
      ),
    ),
    pixelRatio: 2.0,
    targetSize: const Size(760, 1400),
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
