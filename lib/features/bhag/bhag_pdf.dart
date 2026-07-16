import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import 'bhag_model.dart';
import 'bhag_report_spec.dart';
import 'bhag_view.dart';

/// Renders a report table to a landscape A4 PDF. Marathi shapes correctly
/// because we capture the Flutter-rendered table to a PNG and embed that.
Future<Uint8List> renderBhagPdf({
  required BhagTableData data,
  required BhagPeriod period,
  required List<BhagValueColumn> columns,
  required String title,
}) async {
  // Wide enough for all columns (34 + 150 + Σ column widths + padding).
  final tableWidth =
      34.0 + 150.0 + columns.fold<double>(0, (w, c) => w + c.width) + 40.0;
  final width = tableWidth.clamp(900.0, 1600.0);

  final png = await ScreenshotController().captureFromWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Material(
        color: Colors.white,
        child: BhagTableView(
          data: data,
          period: period,
          columns: columns,
          titleKey: title,
          titleText: title,
          forCapture: true,
        ),
      ),
    ),
    pixelRatio: 2.0,
    targetSize: Size(width, 1600),
    delay: const Duration(milliseconds: 80),
  );

  final doc = pw.Document();
  final image = pw.MemoryImage(png);
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(18),
      build: (_) =>
          pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
    ),
  );
  return doc.save();
}
