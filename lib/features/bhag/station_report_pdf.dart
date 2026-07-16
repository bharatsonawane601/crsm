import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import 'station_report_model.dart';
import 'station_report_view.dart';

/// Renders the division station-wise report to a landscape A4 PDF. Marathi
/// shapes correctly because we capture the Flutter table to a PNG and embed it.
Future<Uint8List> renderStationReportPdf({
  required StationReportData data,
  required StationReportPeriod period,
  required String title,
}) async {
  final png = await ScreenshotController().captureFromWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.white,
        child: StationReportView(
          data: data,
          period: period,
          title: title,
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
