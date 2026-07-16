import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A captured GPS fix (may be null when location is unavailable / denied).
class GpsFix {
  const GpsFix(this.lat, this.lng);
  final double lat;
  final double lng;
}

/// Scene-capture helpers for the IO portal: photos (camera/gallery), a GPS
/// stamp, and on-disk media storage. Kept platform-aware so the same code path
/// degrades gracefully on desktop (camera → file picker; no GPS → null).
class IoCaptureService {
  static final _picker = ImagePicker();

  /// True on the IO's phone (where camera + GPS + mic make sense). On desktop we
  /// fall back to a file picker and skip mic.
  static bool get isMobile =>
      !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// The per-case media folder under the app's documents dir. Created on demand.
  static Future<Directory> caseMediaDir(int caseId) async {
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory(p.join(base.path, 'io_media', '$caseId'));
    if (!await dir.exists()) await dir.create(recursive: true);
    return dir;
  }

  /// Picks a photo from the camera (mobile) or gallery/files, copies it into the
  /// case folder and returns the stored path. Null if the user cancels.
  static Future<String?> capturePhoto(int caseId,
      {bool fromCamera = true}) async {
    final source = (fromCamera && isMobile)
        ? ImageSource.camera
        : ImageSource.gallery;
    final XFile? shot = await _picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 2000,
    );
    if (shot == null) return null;
    final dir = await caseMediaDir(caseId);
    final ext = p.extension(shot.path).isEmpty ? '.jpg' : p.extension(shot.path);
    final dest =
        p.join(dir.path, 'photo_${DateTime.now().millisecondsSinceEpoch}$ext');
    await File(shot.path).copy(dest);
    return dest;
  }

  /// Writes raw bytes (e.g. a signature PNG) into the case folder and returns the
  /// path.
  static Future<String> saveBytes(int caseId, Uint8List bytes,
      {required String prefix, String ext = '.png'}) async {
    final dir = await caseMediaDir(caseId);
    final dest =
        p.join(dir.path, '${prefix}_${DateTime.now().millisecondsSinceEpoch}$ext');
    await File(dest).writeAsBytes(bytes);
    return dest;
  }

  /// Current GPS fix, requesting permission if needed. Returns null when the
  /// service is off, permission is denied, or the platform can't provide it.
  static Future<GpsFix?> currentGps() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;
      var perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) {
        return null;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
      return GpsFix(pos.latitude, pos.longitude);
    } catch (_) {
      return null;
    }
  }
}
