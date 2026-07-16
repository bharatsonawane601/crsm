import 'dart:io';
import 'dart:typed_data';

import 'package:crop_your_image/crop_your_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Full-screen cropper for a freshly scanned page. The user drags the corners
/// to crop, then taps "Use" — the cropped image is saved into the app's
/// attachments folder and the screen pops with the saved file path. Tapping
/// "Use full page" skips cropping. Returns `null` if the user backs out.
class ScanCropScreen extends StatefulWidget {
  const ScanCropScreen({super.key, required this.imagePath});

  final String imagePath;

  @override
  State<ScanCropScreen> createState() => _ScanCropScreenState();
}

class _ScanCropScreenState extends State<ScanCropScreen> {
  final _controller = CropController();
  Uint8List? _source;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final bytes = await File(widget.imagePath).readAsBytes();
    if (mounted) setState(() => _source = bytes);
  }

  /// Persists [bytes] as a PNG in the app documents attachments folder and pops
  /// with its path.
  Future<void> _save(Uint8List bytes) async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(docs.path, 'crms_attachments'));
    if (!dir.existsSync()) dir.createSync(recursive: true);
    final file = File(
        p.join(dir.path, 'scan_${DateTime.now().millisecondsSinceEpoch}.png'));
    await file.writeAsBytes(bytes);
    if (mounted) Navigator.of(context).pop(file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('crime.attachments.cropTitle'.tr()),
        actions: [
          TextButton(
            onPressed: _busy || _source == null
                ? null
                : () => _save(_source!), // use whole page, no crop
            child: Text('crime.attachments.useFull'.tr(),
                style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: _source == null
          ? const Center(child: CircularProgressIndicator())
          : Crop(
              controller: _controller,
              image: _source!,
              onCropped: (cropped) => _save(cropped),
              initialSize: 0.9,
              baseColor: Colors.black,
              maskColor: Colors.black.withValues(alpha: 0.6),
              cornerDotBuilder: (size, edgeAlignment) =>
                  const DotControl(color: Colors.white),
            ),
      bottomNavigationBar: _source == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: _busy
                      ? null
                      : () {
                          setState(() => _busy = true);
                          _controller.crop();
                        },
                  icon: _busy
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.crop),
                  label: Text('crime.attachments.cropUse'.tr()),
                ),
              ),
            ),
    );
  }
}
