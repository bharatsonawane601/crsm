import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../../core/theme/spacing.dart';
import '../../shared/widgets/native_edit_button.dart';
import '../../data/db/database.dart';
import 'io_capture_service.dart';
import 'io_repository.dart';
import 'io_signature_pad.dart';

/// The घटनास्थळ (scene) tab: capture photos (with a GPS + time stamp), on-screen
/// signatures and voice-to-text notes — all stored against the case and later
/// embedded into the generated panchnamas.
class IoSceneTab extends ConsumerWidget {
  const IoSceneTab({super.key, required this.caseId});
  final int caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = ref.watch(ioMediaProvider(caseId));
    return Scaffold(
      body: media.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('portal.error'.tr())),
        data: (list) {
          final photos =
              list.where((m) => m.kind == 'photo' || m.kind == 'signature').toList();
          final notes = list.where((m) => m.kind == 'note').toList();
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.s3),
            children: [
              _CaptureBar(caseId: caseId),
              const SizedBox(height: AppSpacing.s3),
              if (list.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.s6),
                  child: Center(child: Text('io.scene.empty'.tr())),
                ),
              if (photos.isNotEmpty) ...[
                Text('io.scene.photos'.tr(),
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: AppSpacing.s2),
                GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6,
                  children: [
                    for (final m in photos) _MediaThumb(media: m, ref: ref),
                  ],
                ),
              ],
              if (notes.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.s3),
                Text('io.scene.notes'.tr(),
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: AppSpacing.s2),
                for (final m in notes)
                  Card(
                    child: ListTile(
                      leading: const Icon(PhosphorIconsRegular.microphone),
                      title: Text(m.caption ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            ref.read(ioRepositoryProvider).deleteMedia(m.id),
                      ),
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _CaptureBar extends ConsumerWidget {
  const _CaptureBar({required this.caseId});
  final int caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        FilledButton.icon(
          icon: const Icon(PhosphorIconsRegular.camera),
          label: Text(IoCaptureService.isMobile
              ? 'io.scene.takePhoto'.tr()
              : 'io.scene.addPhoto'.tr()),
          onPressed: () => _photo(context, ref, fromCamera: true),
        ),
        if (IoCaptureService.isMobile)
          OutlinedButton.icon(
            icon: const Icon(PhosphorIconsRegular.images),
            label: Text('io.scene.gallery'.tr()),
            onPressed: () => _photo(context, ref, fromCamera: false),
          ),
        OutlinedButton.icon(
          icon: const Icon(PhosphorIconsRegular.signature),
          label: Text('io.signature'.tr()),
          onPressed: () => _signature(context, ref),
        ),
        if (IoCaptureService.isMobile)
          OutlinedButton.icon(
            icon: const Icon(PhosphorIconsRegular.microphone),
            label: Text('io.scene.voiceNote'.tr()),
            onPressed: () => _voiceNote(context, ref),
          ),
      ],
    );
  }

  Future<void> _photo(BuildContext context, WidgetRef ref,
      {required bool fromCamera}) async {
    final messenger = ScaffoldMessenger.of(context);
    final path =
        await IoCaptureService.capturePhoto(caseId, fromCamera: fromCamera);
    if (path == null) return;
    final gps = await IoCaptureService.currentGps();
    await ref.read(ioRepositoryProvider).addMedia(caseId, 'photo', path,
        lat: gps?.lat, lng: gps?.lng);
    messenger.showSnackBar(SnackBar(
        content: Text(gps == null
            ? 'io.scene.savedNoGps'.tr()
            : 'io.scene.savedGps'.tr()),
        duration: const Duration(seconds: 2)));
  }

  Future<void> _signature(BuildContext context, WidgetRef ref) async {
    final bytes = await showSignaturePad(context);
    if (bytes == null) return;
    final path = await IoCaptureService.saveBytes(caseId, bytes,
        prefix: 'signature');
    await ref.read(ioRepositoryProvider).addMedia(caseId, 'signature', path);
  }

  Future<void> _voiceNote(BuildContext context, WidgetRef ref) async {
    final text = await showDialog<String>(
      context: context,
      builder: (_) => const _VoiceNoteDialog(),
    );
    if (text != null && text.trim().isNotEmpty) {
      await ref
          .read(ioRepositoryProvider)
          .addMedia(caseId, 'note', '', caption: text.trim());
    }
  }
}

class _MediaThumb extends StatelessWidget {
  const _MediaThumb({required this.media, required this.ref});
  final IoMediaData media;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => ref.read(ioRepositoryProvider).deleteMedia(media.id),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: File(media.filePath).existsSync()
                ? Image.file(File(media.filePath), fit: BoxFit.cover)
                : Container(color: Colors.black12, child: const Icon(Icons.image)),
          ),
          if (media.lat != null)
            Positioned(
              left: 2,
              bottom: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                color: Colors.black54,
                child: const Icon(Icons.location_on,
                    size: 12, color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}

/// Voice-to-text dialog (mobile). Listens and shows the live transcript; the IO
/// saves it as a scene note.
class _VoiceNoteDialog extends StatefulWidget {
  const _VoiceNoteDialog();

  @override
  State<_VoiceNoteDialog> createState() => _VoiceNoteDialogState();
}

class _VoiceNoteDialogState extends State<_VoiceNoteDialog> {
  final _speech = SpeechToText();
  final _controller = TextEditingController();
  bool _available = false;
  bool _listening = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final ok = await _speech.initialize();
    if (mounted) setState(() => _available = ok);
    if (ok) _toggle();
  }

  Future<void> _toggle() async {
    if (_listening) {
      await _speech.stop();
      if (mounted) setState(() => _listening = false);
      return;
    }
    setState(() => _listening = true);
    await _speech.listen(
      onResult: (r) {
        _controller.text = r.recognizedWords;
        _controller.selection =
            TextSelection.collapsed(offset: _controller.text.length);
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _speech.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('io.scene.voiceNote'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (!_available)
            Text('io.scene.micUnavailable'.tr())
          else
            IconButton(
              iconSize: 44,
              color: _listening ? Colors.red : null,
              icon: Icon(_listening ? Icons.mic : Icons.mic_none),
              onPressed: _toggle,
            ),
          const SizedBox(height: AppSpacing.s2),
          TextField(
            controller: _controller,
            maxLines: 3,
            decoration: InputDecoration(
                hintText: 'io.scene.transcript'.tr(),
                suffixIcon: NativeEditButton.maybe(_controller,
                    title: 'io.scene.transcript'.tr())),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr())),
        FilledButton(
            onPressed: () => Navigator.pop(context, _controller.text),
            child: Text('common.save'.tr())),
      ],
    );
  }
}
