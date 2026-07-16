import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/colors.dart';
import '../../../shared/widgets/native_edit_button.dart';
import '../../reports/report_preview_screen.dart';
import '../../crime_entry/crime_repository.dart';
import '../../crime_entry/models/crime_draft.dart';
import '../io_capture_service.dart';
import '../io_repository.dart';
import 'seizure_form_export.dart';
import 'seizure_form_model.dart';

/// PROPERTY SEARCH & SEIZURE FORM — auto-filled from the linked FIR, editable by
/// group, exported to both PDF (pixel-exact) and Word (editable Marathi).
class SeizureFormScreen extends ConsumerStatefulWidget {
  const SeizureFormScreen({super.key, required this.caseId});
  final int caseId;

  @override
  ConsumerState<SeizureFormScreen> createState() => _SeizureFormScreenState();
}

class _SeizureFormScreenState extends ConsumerState<SeizureFormScreen> {
  final _controllers = <String, TextEditingController>{};
  List<SeizurePropertyRow> _rows = const [];
  bool _loading = true;
  bool _linkedFir = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(ioRepositoryProvider);
    final c = await repo.getCase(widget.caseId);
    final parties = await repo.partiesOnce(widget.caseId);
    final exhibits = await repo.exhibitsOnce(widget.caseId);

    CrimeDraft? fir;
    if ((c.firNo ?? '').isNotEmpty && c.year != null) {
      final crimeRepo = ref.read(crimeRepositoryProvider);
      final id = await crimeRepo.findCrimeIdByFir(c.firNo!, c.year!);
      if (id != null) fir = await crimeRepo.loadDraft(id);
    }

    final auto = buildSeizureValues(
        ioCase: c, fir: fir, parties: parties, exhibits: exhibits);

    final form = await repo.ensureForm(widget.caseId, kSeizureFormId);
    final stored = form.valuesJson == null
        ? <String, String>{}
        : (jsonDecode(form.valuesJson!) as Map)
            .map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));

    for (final f in kSeizureFields) {
      _controllers[f.id] =
          TextEditingController(text: stored[f.id] ?? auto[f.id] ?? '');
    }

    if (!mounted) return;
    setState(() {
      _rows = seizurePropertyRows(fir: fir, exhibits: exhibits);
      _linkedFir = fir != null;
      _loading = false;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Map<String, String> _collect() =>
      {for (final e in _controllers.entries) e.key: e.value.text};

  Future<void> _save() async {
    await ref
        .read(ioRepositoryProvider)
        .saveForm(widget.caseId, kSeizureFormId, _collect());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('io.saved'.tr()), duration: const Duration(seconds: 1)));
    }
  }

  Future<void> _exportPdf() async {
    await _save();
    final bytes = await renderSeizurePdf(_collect(), _rows);
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) =>
          ReportPreviewScreen(bytes: bytes, name: 'Property Search & Seizure'),
    ));
  }

  Future<void> _exportWord() async {
    await _save();
    final bytes = renderSeizureDocx(_collect(), _rows);
    final name =
        'SeizureForm_${_controllers['firNo']?.text.trim() ?? widget.caseId}'
            .replaceAll(RegExp(r'[^\w]+'), '_');
    if (IoCaptureService.isMobile) {
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/$name.docx';
      await File(path).writeAsBytes(bytes);
      await SharePlus.instance.share(ShareParams(
        files: [
          XFile(path,
              mimeType:
                  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
              name: '$name.docx')
        ],
        subject: 'Property Search & Seizure Form',
      ));
    } else {
      final chosen = await FilePicker.saveFile(
        dialogTitle: 'io.saveWord'.tr(),
        fileName: '$name.docx',
        type: FileType.custom,
        allowedExtensions: ['docx'],
      );
      if (chosen == null) return;
      final path =
          chosen.toLowerCase().endsWith('.docx') ? chosen : '$chosen.docx';
      await File(path).writeAsBytes(bytes);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('io.savedTo'.tr(namedArgs: {'path': path}))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Property Search & Seizure'),
        actions: [
          if (!_loading) ...[
            IconButton(
                tooltip: 'PDF',
                icon: const Icon(Icons.picture_as_pdf),
                onPressed: _exportPdf),
            IconButton(
                tooltip: 'Word',
                icon: const Icon(Icons.description),
                onPressed: _exportWord),
          ],
        ],
      ),
      floatingActionButton: _loading
          ? null
          : FloatingActionButton.extended(
              onPressed: _save,
              icon: const Icon(Icons.save),
              label: Text('common.save'.tr())),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
              children: [
                Container(
                  width: double.infinity,
                  color: _linkedFir
                      ? Colors.green.withValues(alpha: 0.10)
                      : Colors.orange.withValues(alpha: 0.12),
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    _linkedFir ? 'io.formE.linked'.tr() : 'io.formE.noFir'.tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                for (final g in kSeizureGroups) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 6),
                    child: Text('${g.titleMr} / ${g.titleEn}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: AppColors.policeNavy,
                            fontWeight: FontWeight.w700)),
                  ),
                  for (final f in g.fields)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: _controllers[f.id],
                        maxLines: f.multiline ? 3 : 1,
                        decoration: InputDecoration(
                          labelText: f.mr,
                          helperText: f.en,
                          border: const OutlineInputBorder(),
                          isDense: true,
                          suffixIcon: NativeEditButton.maybe(
                              _controllers[f.id]!,
                              title: f.mr),
                        ),
                      ),
                    ),
                ],
                const Divider(height: 24),
                Text('io.seizure.propertyNote'.tr(),
                    style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 6),
                for (var i = 0; i < _rows.length; i++)
                  ListTile(
                    dense: true,
                    leading: CircleAvatar(radius: 12, child: Text('${i + 1}')),
                    title: Text(_rows[i].description),
                  ),
                if (_rows.isEmpty)
                  Text('io.seizure.noProperty'.tr(),
                      style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
    );
  }
}
