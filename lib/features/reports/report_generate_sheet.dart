import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../settings/settings_repository.dart';
import 'pdf_renderer.dart';
import 'report_preview_screen.dart';
import 'report_service.dart';
import 'template_catalog.dart';

/// Opens the "Generate Report" bottom sheet for a saved crime.
Future<void> showReportSheet(BuildContext context, int crimeId) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _ReportSheet(crimeId: crimeId),
  );
}

class _ReportSheet extends ConsumerStatefulWidget {
  const _ReportSheet({required this.crimeId});
  final int crimeId;

  @override
  ConsumerState<_ReportSheet> createState() => _ReportSheetState();
}

class _ReportSheetState extends ConsumerState<_ReportSheet> {
  TemplateChoice? _choice;
  ReportFormat _format = ReportFormat.docx;
  bool _busy = false;

  // PDF / print layout options.
  ReportFontSize _fontSize = ReportFontSize.normal;
  String _pageSize = 'A4';
  bool _landscape = false;

  ReportPdfOptions get _pdfOptions => ReportPdfOptions(
        fontSize: _fontSize,
        pageSize: _pageSize,
        landscape: _landscape,
      );

  Future<void> _run(Future<void> Function(ReportService s) action) async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await action(ref.read(reportServiceProvider));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text('report.error'.tr())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _print() async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      final s = ref.read(reportServiceProvider);
      final report = await s.renderForCrime(widget.crimeId, _choice!);
      final bytes = await s.pdfBytes(report, options: _pdfOptions);
      navigator.pop(); // close the sheet
      navigator.push(MaterialPageRoute<void>(
        builder: (_) => ReportPreviewScreen(bytes: bytes, name: report.name),
      ));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text('report.error'.tr())));
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() => _run((s) async {
        final report = await s.renderForCrime(widget.crimeId, _choice!);
        final ext = ReportService.extensionFor(_format);
        // Ask the user WHERE to save (OS "Save As" dialog).
        final chosen = await FilePicker.saveFile(
          dialogTitle: 'report.save'.tr(),
          fileName: '${ReportService.safeFileName(report)}.$ext',
          type: FileType.custom,
          allowedExtensions: [ext],
        );
        if (chosen == null) return; // cancelled
        final path =
            await s.saveReportToPath(report, _format, chosen, options: _pdfOptions);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('report.saved'.tr(namedArgs: {'path': path}))),
        );
        Navigator.of(context).pop();
      });

  Future<void> _share() => _run((s) async {
        final report = await s.renderForCrime(widget.crimeId, _choice!);
        await s.shareReport(report, _format, options: _pdfOptions);
      });

  @override
  Widget build(BuildContext context) {
    final choices = ref.watch(templateChoicesProvider);
    final defaultKey = ref.watch(settingsProvider).value?.defaultTemplateKey;
    // Initial selection: the configured default template, else the first.
    if (_choice == null && choices.isNotEmpty) {
      _choice = choices.firstWhere(
        (c) => c.key == defaultKey,
        orElse: () => choices.first,
      );
    }
    if (_choice != null && !choices.any((c) => c.key == _choice!.key)) {
      _choice = choices.isNotEmpty ? choices.first : null;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        8,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('report.generate'.tr(),
              style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _choice?.key,
            decoration: InputDecoration(
              labelText: 'report.template'.tr(),
              border: const OutlineInputBorder(),
            ),
            items: [
              for (final c in choices)
                DropdownMenuItem(value: c.key, child: Text(c.displayName)),
            ],
            onChanged: _busy
                ? null
                : (key) => setState(() =>
                    _choice = choices.firstWhere((c) => c.key == key)),
          ),
          const SizedBox(height: 16),
          Text('report.format'.tr(),
              style: Theme.of(context).textTheme.labelLarge),
          const SizedBox(height: 8),
          SegmentedButton<ReportFormat>(
            segments: [
              ButtonSegment(
                value: ReportFormat.docx,
                label: Text('report.docx'.tr()),
                icon: const Icon(Icons.description_outlined),
              ),
              ButtonSegment(
                value: ReportFormat.xlsx,
                label: Text('report.xlsx'.tr()),
                icon: const Icon(Icons.table_view_outlined),
              ),
              ButtonSegment(
                value: ReportFormat.pdf,
                label: Text('report.pdf'.tr()),
                icon: const Icon(Icons.picture_as_pdf_outlined),
              ),
            ],
            selected: {_format},
            onSelectionChanged: _busy
                ? null
                : (s) => setState(() => _format = s.first),
          ),
          if (_format == ReportFormat.docx) ...[
            const SizedBox(height: 8),
            Text('report.docxHint'.tr(),
                style: Theme.of(context).textTheme.bodySmall),
          ],
          if (_format == ReportFormat.pdf) ...[
            const SizedBox(height: 16),
            Text('report.printLayout'.tr(),
                style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 8),
            SegmentedButton<ReportFontSize>(
              segments: [
                ButtonSegment(
                    value: ReportFontSize.small,
                    label: Text('report.fontSmall'.tr())),
                ButtonSegment(
                    value: ReportFontSize.normal,
                    label: Text('report.fontNormal'.tr())),
                ButtonSegment(
                    value: ReportFontSize.large,
                    label: Text('report.fontLarge'.tr())),
              ],
              selected: {_fontSize},
              onSelectionChanged: _busy
                  ? null
                  : (s) => setState(() => _fontSize = s.first),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _pageSize,
                    decoration: InputDecoration(
                      labelText: 'report.pageSize'.tr(),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'A4', child: Text('A4')),
                      DropdownMenuItem(value: 'Letter', child: Text('Letter')),
                      DropdownMenuItem(value: 'Legal', child: Text('Legal')),
                    ],
                    onChanged: _busy
                        ? null
                        : (v) => setState(() => _pageSize = v ?? 'A4'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SegmentedButton<bool>(
                    segments: [
                      ButtonSegment(
                          value: false,
                          label: Text('report.portrait'.tr())),
                      ButtonSegment(
                          value: true,
                          label: Text('report.landscape'.tr())),
                    ],
                    selected: {_landscape},
                    onSelectionChanged: _busy
                        ? null
                        : (s) => setState(() => _landscape = s.first),
                  ),
                ),
              ],
            ),
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed:
                      (_busy || _choice == null || _format != ReportFormat.pdf)
                          ? null
                          : _print,
                  icon: const Icon(Icons.print_outlined),
                  label: Text('report.print'.tr()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: (_busy || _choice == null) ? null : _share,
                  icon: const Icon(Icons.share_outlined),
                  label: Text('report.share'.tr()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: (_busy || _choice == null) ? null : _save,
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_alt),
                  label: Text('report.save'.tr()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('report.shareHint'.tr(),
              style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
