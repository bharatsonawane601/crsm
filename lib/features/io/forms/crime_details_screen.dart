import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
import 'crime_details_export.dart';
import 'crime_details_model.dart';
import 'static_map.dart';

/// CRIME DETAILS FORM (2-A/B/C) — auto-filled from the linked FIR, editable by
/// group, exported to both PDF (pixel-exact, 4 pages) and Word.
class CrimeDetailsScreen extends ConsumerStatefulWidget {
  const CrimeDetailsScreen({super.key, required this.caseId});
  final int caseId;

  @override
  ConsumerState<CrimeDetailsScreen> createState() => _CrimeDetailsScreenState();
}

class _CrimeDetailsScreenState extends ConsumerState<CrimeDetailsScreen> {
  final _controllers = <String, TextEditingController>{};
  List<CdVictim> _victims = const [];
  bool _loading = true;
  bool _linkedFir = false;
  Uint8List? _mapImage;
  String? _gpsLabel;
  bool _mapLoading = false;

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

    final auto = buildCrimeDetailsValues(
        ioCase: c, fir: fir, parties: parties, exhibits: exhibits);

    final form = await repo.ensureForm(widget.caseId, kCrimeDetailsId);
    final stored = form.valuesJson == null
        ? <String, String>{}
        : (jsonDecode(form.valuesJson!) as Map)
            .map((k, v) => MapEntry(k.toString(), v?.toString() ?? ''));

    for (final f in kCrimeDetailsFields) {
      _controllers[f.id] =
          TextEditingController(text: stored[f.id] ?? auto[f.id] ?? '');
    }

    if (!mounted) return;
    setState(() {
      _victims = buildCrimeDetailsVictims(fir: fir);
      _linkedFir = fir != null;
      _loading = false;
    });

    // Auto-place a scene map from the GPS captured with the scene photos.
    _loadMap();
  }

  Future<void> _loadMap() async {
    final gps = await ref.read(ioRepositoryProvider).sceneLatLng(widget.caseId);
    if (gps == null || !mounted) return;
    final (lat, lng) = gps;
    setState(() {
      _gpsLabel = '${lat.toStringAsFixed(5)}, ${lng.toStringAsFixed(5)}';
      _mapLoading = true;
    });
    final png = await fetchStaticMap(lat: lat, lng: lng);
    if (!mounted) return;
    setState(() {
      _mapImage = png;
      _mapLoading = false;
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
        .saveForm(widget.caseId, kCrimeDetailsId, _collect());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('io.saved'.tr()), duration: const Duration(seconds: 1)));
    }
  }

  Future<void> _exportPdf() async {
    await _save();
    final bytes = await renderCrimeDetailsPdf(_collect(), _victims,
        mapImage: _mapImage, gpsLabel: _gpsLabel);
    if (!mounted) return;
    Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => ReportPreviewScreen(bytes: bytes, name: 'Crime Details'),
    ));
  }

  Future<void> _exportWord() async {
    await _save();
    final bytes = renderCrimeDetailsDocx(_collect(), _victims);
    final name =
        'CrimeDetails_${_controllers['firNo']?.text.trim() ?? widget.caseId}'
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
        subject: 'Crime Details Form',
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

  Widget _mapCard() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Icon(Icons.map_outlined),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('io.crimeDetails.mapTitle'.tr(),
                      style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    _mapImage != null
                        ? 'io.crimeDetails.mapReady'.tr(namedArgs: {'gps': _gpsLabel ?? ''})
                        : _mapLoading
                            ? 'io.crimeDetails.mapLoading'.tr()
                            : _gpsLabel != null
                                ? 'io.crimeDetails.mapFailed'.tr()
                                : 'io.crimeDetails.mapNoGps'.tr(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (_mapLoading)
              const SizedBox(
                  width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            if (_mapImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.memory(_mapImage!,
                    width: 64, height: 48, fit: BoxFit.cover),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crime Details (2-A/B/C)'),
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
                if (_victims.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                        'io.crimeDetails.victimNote'
                            .tr(namedArgs: {'name': _victims.first.fullName}),
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                const SizedBox(height: 8),
                _mapCard(),
                const SizedBox(height: 8),
                for (final g in kCrimeDetailsGroups) ...[
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
              ],
            ),
    );
  }
}
