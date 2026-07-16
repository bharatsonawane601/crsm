import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import '../../core/theme/spacing.dart';
import '../../shared/widgets/native_edit_button.dart';
import '../../data/db/database.dart';
import '../reports/report_preview_screen.dart';
import 'io_forms_catalog.dart';
import 'io_repository.dart';
import 'io_print_view.dart';

/// Generic fill screen for one government form. Renders the [IoFormSpec] fields,
/// pre-filled from the case, and saves the values as JSON. The values (merged
/// with the case's parties + exhibits) drive the generated PDF.
///
/// NOTE: the PDF here is a clean, readable bilingual layout — the pixel-exact
/// per-form replicas are layered on top of this same data in a later step.
class IoFormScreen extends ConsumerStatefulWidget {
  const IoFormScreen({super.key, required this.caseId, required this.formId});
  final int caseId;
  final String formId;

  @override
  ConsumerState<IoFormScreen> createState() => _IoFormScreenState();
}

class _IoFormScreenState extends ConsumerState<IoFormScreen> {
  final _text = <String, TextEditingController>{};
  final _values = <String, dynamic>{};
  bool _loading = true;
  bool _complete = false;
  IoFormSpec get _spec => kIoFormById[widget.formId]!;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(ioRepositoryProvider);
    final form = await repo.ensureForm(widget.caseId, widget.formId);
    final stored = form.valuesJson == null
        ? <String, dynamic>{}
        : (jsonDecode(form.valuesJson!) as Map).cast<String, dynamic>();
    for (final f in _spec.fields) {
      final v = stored[f.id];
      _values[f.id] = v;
      if (_isText(f.type)) {
        _text[f.id] = TextEditingController(text: v?.toString() ?? '');
      }
    }
    if (mounted) {
      setState(() {
        _complete = form.status == 'complete';
        _loading = false;
      });
    }
  }

  bool _isText(IoFieldType t) => switch (t) {
        IoFieldType.text ||
        IoFieldType.multiline ||
        IoFieldType.number ||
        IoFieldType.money =>
          true,
        _ => false,
      };

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, dynamic> _collect() {
    final out = <String, dynamic>{};
    for (final f in _spec.fields) {
      if (_isText(f.type)) {
        final t = _text[f.id]!.text.trim();
        if (t.isNotEmpty) out[f.id] = t;
      } else if (_values[f.id] != null) {
        out[f.id] = _values[f.id];
      }
    }
    return out;
  }

  Future<void> _save({bool markComplete = false}) async {
    final repo = ref.read(ioRepositoryProvider);
    await repo.saveForm(widget.caseId, widget.formId, _collect(),
        status: markComplete ? 'complete' : (_complete ? 'complete' : 'draft'));
    if (markComplete) setState(() => _complete = true);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('io.saved'.tr()), duration: const Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_spec.mr),
        actions: [
          if (_complete)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.check_circle, color: Colors.green),
            ),
          IconButton(
            tooltip: 'io.generatePdf'.tr(),
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: _loading ? null : _generatePdf,
          ),
        ],
      ),
      floatingActionButton: _loading
          ? null
          : FloatingActionButton.extended(
              onPressed: () => _save(),
              icon: const Icon(Icons.save),
              label: Text('common.save'.tr()),
            ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.s4, AppSpacing.s4, AppSpacing.s4, 96),
              children: [
                Text(_spec.en,
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: AppSpacing.s3),
                for (final f in _spec.fields) ...[
                  _fieldWidget(f),
                  const SizedBox(height: AppSpacing.s3),
                ],
                const Divider(),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _complete,
                  title: Text('io.markComplete'.tr()),
                  onChanged: (v) => _save(markComplete: v ?? false),
                ),
              ],
            ),
    );
  }

  Widget _fieldWidget(IoField f) {
    switch (f.type) {
      case IoFieldType.multiline:
        return TextField(
          controller: _text[f.id],
          maxLines: 3,
          decoration: InputDecoration(
              labelText: f.mr,
              helperText: f.en,
              border: const OutlineInputBorder(),
              suffixIcon: NativeEditButton.maybe(_text[f.id]!, title: f.mr)),
        );
      case IoFieldType.number:
      case IoFieldType.money:
        return TextField(
          controller: _text[f.id],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              labelText: f.mr,
              helperText: f.en,
              prefixText: f.type == IoFieldType.money ? '₹ ' : null,
              border: const OutlineInputBorder()),
        );
      case IoFieldType.date:
        return _pickerTile(f, _values[f.id]?.toString(), () => _pickDate(f));
      case IoFieldType.time:
        return _pickerTile(f, _values[f.id]?.toString(), () => _pickTime(f));
      case IoFieldType.dropdown:
        return DropdownButtonFormField<String>(
          initialValue:
              f.options.contains(_values[f.id]) ? _values[f.id] as String : null,
          isExpanded: true,
          decoration:
              InputDecoration(labelText: f.mr, helperText: f.en),
          items: [
            for (final o in f.options)
              DropdownMenuItem(value: o, child: Text(o, overflow: TextOverflow.ellipsis)),
          ],
          onChanged: (v) => setState(() => _values[f.id] = v),
        );
      case IoFieldType.checkbox:
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _values[f.id] == true,
          title: Text(f.mr),
          subtitle: Text(f.en),
          onChanged: (v) => setState(() => _values[f.id] = v),
        );
      case IoFieldType.text:
        return TextField(
          controller: _text[f.id],
          decoration: InputDecoration(
              labelText: f.mr,
              helperText: f.en,
              border: const OutlineInputBorder(),
              suffixIcon: NativeEditButton.maybe(_text[f.id]!, title: f.mr)),
        );
    }
  }

  Widget _pickerTile(IoField f, String? value, VoidCallback onTap) {
    return InputDecorator(
      decoration: InputDecoration(
          labelText: f.mr, helperText: f.en, border: const OutlineInputBorder()),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(child: Text(value ?? '—')),
            const Icon(Icons.event, size: 18),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate(IoField f) async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
    );
    if (d != null) {
      setState(() => _values[f.id] = '${d.day}/${d.month}/${d.year}');
    }
  }

  Future<void> _pickTime(IoField f) async {
    final t = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (t != null && mounted) {
      setState(() => _values[f.id] = t.format(context));
    }
  }

  Future<void> _generatePdf() async {
    await _save();
    final parties = ref.read(ioPartiesProvider(widget.caseId)).value ?? const [];
    final exhibits =
        ref.read(ioExhibitsProvider(widget.caseId)).value ?? const [];
    final bytes = await _renderFormPdf(
      spec: _spec,
      values: _collect(),
      parties: parties,
      exhibits: exhibits,
    );
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => ReportPreviewScreen(bytes: bytes, name: _spec.mr),
    ));
  }
}

/// Captures the filled-form widget to a portrait-A4 PDF (Marathi shapes because
/// the widget is rasterised to PNG, then embedded).
Future<Uint8List> _renderFormPdf({
  required IoFormSpec spec,
  required Map<String, dynamic> values,
  required List<IoParty> parties,
  required List<IoExhibit> exhibits,
}) async {
  final png = await ScreenshotController().captureFromWidget(
    Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Material(
        color: Colors.white,
        child: IoFormPrintView(
            spec: spec, values: values, parties: parties, exhibits: exhibits),
      ),
    ),
    pixelRatio: 2.0,
    targetSize: const Size(794, 1123),
    delay: const Duration(milliseconds: 80),
  );

  final doc = pw.Document();
  final image = pw.MemoryImage(png);
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(18),
      build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
    ),
  );
  return doc.save();
}
