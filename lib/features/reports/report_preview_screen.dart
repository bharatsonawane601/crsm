import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

/// In-app PDF preview with built-in print/share actions. Used instead of
/// jumping straight to the OS print dialog (which shows no preview on Windows).
class ReportPreviewScreen extends StatelessWidget {
  const ReportPreviewScreen({super.key, required this.bytes, required this.name});

  final Uint8List bytes;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: PdfPreview(
        build: (_) async => bytes,
        canChangePageFormat: true,
        canChangeOrientation: true,
        allowPrinting: true,
        allowSharing: true,
        pdfFileName: '$name.pdf',
      ),
    );
  }
}
