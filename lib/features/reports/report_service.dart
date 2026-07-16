import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../crime_entry/crime_repository.dart';
import '../settings/settings_repository.dart';
import 'docx_renderer.dart';
import 'engine.dart';
import 'excel_renderer.dart';
import 'models/report_template.dart';
import 'pdf_renderer.dart';
import 'template_catalog.dart';
import 'template_repository.dart';

/// A pre-loaded template bundled with the app. Later phases also surface
/// user-created templates from the DB (report_templates table).
class BundledTemplate {
  const BundledTemplate({
    required this.id,
    required this.displayName,
    required this.assetPath,
  });

  final String id;
  final String displayName;
  final String assetPath;
}

const kBundledTemplates = <BundledTemplate>[
  BundledTemplate(
    id: 'b_patrak',
    displayName: 'ब पत्रक / B-Patrak',
    assetPath: 'assets/templates/b_patrak.json',
  ),
];

enum ReportFormat { pdf, docx, xlsx }

/// Orchestrates report generation: load template + font, build the context
/// from a saved crime, render, then print or save.
class ReportService {
  ReportService(this._ref);

  final Ref _ref;
  static const _engine = TemplateEngine();

  /// Render a report for a crime from a raw template JSON string.
  Future<RenderedReport> renderForCrimeJson(
      int crimeId, String templateJson) async {
    final draft = await _ref.read(crimeRepositoryProvider).loadDraft(crimeId);
    if (draft == null) {
      throw StateError('Crime $crimeId not found');
    }
    final template =
        ReportTemplate.fromJson(json.decode(templateJson) as Map<String, dynamic>);
    final settings = await _ref.read(settingsRepositoryProvider).load();
    final context = ReportContext.fromDraft(
      draft,
      station: settings.hasStation ? settings.stationMap : null,
    );
    return _engine.render(template, context);
  }

  /// Render a report for a crime using a picked [TemplateChoice] (bundled
  /// asset or DB template).
  Future<RenderedReport> renderForCrime(
      int crimeId, TemplateChoice choice) async {
    final templateJson = await _templateJson(choice);
    return renderForCrimeJson(crimeId, templateJson);
  }

  Future<String> _templateJson(TemplateChoice choice) async {
    if (choice.assetPath != null) {
      return rootBundle.loadString(choice.assetPath!);
    }
    final row =
        await _ref.read(templateRepositoryProvider).getById(choice.dbId!);
    if (row == null) throw StateError('Template ${choice.dbId} not found');
    return row.templateJson;
  }

  Future<Uint8List> pdfBytes(RenderedReport report,
          {ReportPdfOptions options = const ReportPdfOptions()}) =>
      renderReportPdf(report, options: options);

  Uint8List docxBytes(RenderedReport report) => renderReportDocx(report);

  Uint8List xlsxBytes(RenderedReport report) => renderReportExcel(report);

  /// Opens the OS print/preview dialog (direct print) for the PDF.
  Future<void> printReport(RenderedReport report,
      {ReportPdfOptions options = const ReportPdfOptions()}) async {
    final bytes = await pdfBytes(report, options: options);
    await Printing.layoutPdf(onLayout: (_) async => bytes, name: report.name);
  }

  /// Writes the report to the app documents folder and returns the file path.
  Future<String> saveReport(RenderedReport report, ReportFormat format,
      {ReportPdfOptions options = const ReportPdfOptions()}) async {
    final (bytes, ext, _) = await _payload(report, format, options);
    final dir = await getApplicationDocumentsDirectory();
    return _writeFile(dir, bytes, report.name, ext);
  }

  /// Writes the report to a user-chosen [path] (from the OS "Save As" dialog).
  /// The correct extension is appended if the path is missing it. Returns the
  /// final file path.
  Future<String> saveReportToPath(
      RenderedReport report, ReportFormat format, String path,
      {ReportPdfOptions options = const ReportPdfOptions()}) async {
    final (bytes, ext, _) = await _payload(report, format, options);
    final target =
        path.toLowerCase().endsWith('.$ext') ? path : '$path.$ext';
    final file = File(target);
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// File extension ("pdf" / "docx" / "xlsx") for a report [format].
  static String extensionFor(ReportFormat format) => switch (format) {
        ReportFormat.pdf => 'pdf',
        ReportFormat.docx => 'docx',
        ReportFormat.xlsx => 'xlsx',
      };

  /// A filesystem-safe default file name (no extension) for [report].
  static String safeFileName(RenderedReport report) =>
      report.name.replaceAll(RegExp(r'[^\wऀ-ॿ-]+'), '_');

  /// Opens the OS share sheet (WhatsApp, email, etc.) for the report in the
  /// chosen [format]. The file is written to a temp folder first.
  Future<void> shareReport(RenderedReport report, ReportFormat format,
      {ReportPdfOptions options = const ReportPdfOptions()}) async {
    final (bytes, ext, mime) = await _payload(report, format, options);
    final dir = await getTemporaryDirectory();
    final path = await _writeFile(dir, bytes, report.name, ext);
    await SharePlus.instance.share(
      ShareParams(
        files: [XFile(path, mimeType: mime, name: '${report.name}.$ext')],
        subject: report.name,
        text: report.name,
      ),
    );
  }

  /// Bytes + extension + MIME type for a report in a given format.
  Future<(Uint8List, String, String)> _payload(
      RenderedReport report, ReportFormat format,
      [ReportPdfOptions options = const ReportPdfOptions()]) async {
    return switch (format) {
      ReportFormat.pdf => (
          await pdfBytes(report, options: options),
          'pdf',
          'application/pdf'
        ),
      ReportFormat.docx => (
          docxBytes(report),
          'docx',
          'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        ),
      ReportFormat.xlsx => (
          xlsxBytes(report),
          'xlsx',
          'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ),
    };
  }

  Future<String> _writeFile(
      Directory dir, Uint8List bytes, String name, String ext) async {
    final safe = name.replaceAll(RegExp(r'[^\wऀ-ॿ-]+'), '_');
    final stamp = DateTime.now().millisecondsSinceEpoch;
    final file = File(p.join(dir.path, '${safe}_$stamp.$ext'));
    await file.writeAsBytes(bytes);
    return file.path;
  }
}

final reportServiceProvider =
    Provider<ReportService>((ref) => ReportService(ref));
