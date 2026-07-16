import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../shared/widgets/native_edit_button.dart';
import '../../reports/report_preview_screen.dart';
import '../../crime_entry/crime_repository.dart';
import '../../crime_entry/models/crime_draft.dart';
import '../io_capture_service.dart';
import '../io_repository.dart';
import 'mo_form_e_export.dart';
import 'mo_form_e_model.dart';
import 'mo_form_e_view.dart';

/// FORM "E" — auto-filled from the linked FIR, editable per row, exported to
/// both PDF and Word (both shape Marathi correctly).
class MoFormEScreen extends ConsumerStatefulWidget {
  const MoFormEScreen({super.key, required this.caseId});
  final int caseId;

  @override
  ConsumerState<MoFormEScreen> createState() => _MoFormEScreenState();
}

class _MoFormEScreenState extends ConsumerState<MoFormEScreen> {
  Map<String, String> _auto = {};
  Map<String, String> _overrides = {};
  bool _loading = true;
  bool _linkedFir = false;

  /// The displayed value for each row: an IO override wins over the auto value.
  Map<String, String> get _merged => {..._auto, ..._overrides};

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

    // Pull the linked FIR from the local station DB when this case names one.
    CrimeDraft? fir;
    if ((c.firNo ?? '').isNotEmpty && c.year != null) {
      final crimeRepo = ref.read(crimeRepositoryProvider);
      final id = await crimeRepo.findCrimeIdByFir(c.firNo!, c.year!);
      if (id != null) fir = await crimeRepo.loadDraft(id);
    }

    // Persisted per-row overrides live in the IoForms row for this form.
    final form = await repo.ensureForm(widget.caseId, kMoFormEId);
    final stored = form.valuesJson == null
        ? <String, String>{}
        : (jsonDecode(form.valuesJson!) as Map)
            .map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));

    if (!mounted) return;
    setState(() {
      _auto = buildMoFormEValues(
          ioCase: c, fir: fir, parties: parties, exhibits: exhibits);
      _overrides = stored;
      _linkedFir = fir != null;
      _loading = false;
    });
  }

  Future<void> _editRow(MoRow row) async {
    final controller = TextEditingController(text: _merged[row.id] ?? '');
    final result = await showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${row.number}. ${row.mr}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          maxLines: null,
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: NativeEditButton.maybe(controller,
                  title: '${row.number}. ${row.mr}')),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _auto[row.id] ?? ''),
            child: Text('io.resetAuto'.tr()),
          ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('common.cancel'.tr())),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text('common.save'.tr())),
        ],
      ),
    );
    controller.dispose();
    if (result == null) return;
    setState(() => _overrides[row.id] = result);
    await ref
        .read(ioRepositoryProvider)
        .saveForm(widget.caseId, kMoFormEId, _overrides);
  }

  Future<void> _exportPdf() async {
    final bytes = await renderMoFormEPdf(_merged);
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => ReportPreviewScreen(bytes: bytes, name: 'FORM E'),
    ));
  }

  Future<void> _exportWord() async {
    final bytes = renderMoFormEDocx(_merged);
    final name = 'FormE_${_merged['firAndSection']?.split('/').first.trim() ?? widget.caseId}'
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
        subject: 'FORM E',
      ));
    } else {
      final chosen = await FilePicker.saveFile(
        dialogTitle: 'io.saveWord'.tr(),
        fileName: '$name.docx',
        type: FileType.custom,
        allowedExtensions: ['docx'],
      );
      if (chosen == null) return;
      final path = chosen.toLowerCase().endsWith('.docx') ? chosen : '$chosen.docx';
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
        title: const Text('FORM "E"'),
        actions: [
          if (!_loading)
            IconButton(
              tooltip: 'PDF',
              icon: const Icon(Icons.picture_as_pdf),
              onPressed: _exportPdf,
            ),
          if (!_loading)
            IconButton(
              tooltip: 'Word',
              icon: const Icon(Icons.description),
              onPressed: _exportWord,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
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
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: MoFormEView(
                        values: _merged,
                        onTapRow: _editRow,
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
