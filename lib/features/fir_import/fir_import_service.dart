import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import '../crime_entry/models/crime_draft.dart';
import 'fir_pdf_parser.dart';

/// Result of importing a FIR PDF: the pre-filled draft plus the count of fields
/// that were auto-filled (for a "review N imported fields" hint).
class FirImportResult {
  FirImportResult(this.draft, this.filledCount);
  final CrimeDraft draft;
  final int filledCount;
}

class FirImportException implements Exception {
  FirImportException(this.messageKey);
  final String messageKey; // i18n key
  @override
  String toString() => messageKey;
}

/// Picks an NCRB FIR PDF, extracts its text, parses it into a [CrimeDraft], and
/// attaches the original PDF to the draft so it stays with the case.
class FirImportService {
  /// Opens a file picker for a single PDF and returns its path, or null if the
  /// user cancelled.
  Future<String?> pickPdf() async {
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    return picked?.files.single.path;
  }

  /// Extracts text from [pdfPath], parses it, copies the PDF into the app's
  /// attachments folder and adds it as an attachment on the draft.
  Future<FirImportResult> importFromPath(String pdfPath) async {
    final file = File(pdfPath);
    if (!file.existsSync()) {
      throw FirImportException('firImport.error.notFound');
    }

    String text;
    try {
      final bytes = await file.readAsBytes();
      final doc = PdfDocument(inputBytes: bytes);
      text = PdfTextExtractor(doc).extractText();
      doc.dispose();
    } catch (_) {
      throw FirImportException('firImport.error.unreadable');
    }

    if (text.trim().isEmpty) {
      // A scanned/image-only PDF has no text layer to parse.
      throw FirImportException('firImport.error.noText');
    }

    final draft = parseFirText(text);

    // Copy the original PDF into the attachments folder and attach it.
    try {
      final docs = await getApplicationDocumentsDirectory();
      final dir = Directory(p.join(docs.path, 'crms_attachments'));
      if (!dir.existsSync()) dir.createSync(recursive: true);
      final dest = File(p.join(dir.path,
          'fir_${DateTime.now().millisecondsSinceEpoch}_${p.basename(pdfPath)}'));
      await file.copy(dest.path);
      draft.attachments.add(AttachmentDraft(
        filePath: dest.path,
        fileType: 'pdf',
        description: 'Original FIR PDF',
      ));
    } catch (_) {
      // Non-fatal: still return the parsed draft even if the copy failed.
    }

    return FirImportResult(draft, _countFilled(draft));
  }

  int _countFilled(CrimeDraft d) {
    var n = 0;
    void check(Object? v) {
      if (v is String && v.trim().isNotEmpty) n++;
      if (v is DateTime) n++;
      if (v is int) n++;
    }

    check(d.firNo);
    check(d.section);
    check(d.district);
    check(d.policeStation);
    check(d.firDate);
    check(d.firTime);
    check(d.dateOccurred);
    check(d.dateOccurredTo);
    check(d.timeOccurred);
    check(d.timeOccurredTo);
    check(d.infoReceivedDate);
    check(d.gdDate);
    check(d.gdEntryNo);
    check(d.beatNo);
    check(d.directionDistance);
    check(d.placeOccurred);
    check(d.complainant.name);
    check(d.complainant.fatherHusbandName);
    check(d.complainant.birthYear);
    check(d.complainant.nationality);
    check(d.complainant.mobile);
    check(d.detailedDescription);
    if (d.stolen.isNotEmpty) n++;
    return n;
  }
}

final firImportServiceProvider =
    Provider<FirImportService>((ref) => FirImportService());
