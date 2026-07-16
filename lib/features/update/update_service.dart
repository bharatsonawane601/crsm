import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'update_config.dart';
import 'update_models.dart';

/// Talks to the server's version endpoint, decides whether a newer build is
/// available, and (on Windows) downloads + launches the installer.
class UpdateService {
  /// The running app's comparable build number, derived from its version
  /// string so releases only need a version (no separate build to keep in sync).
  Future<int> currentBuild() async => versionToBuild(await currentVersion());

  Future<String> currentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (_) {
      return '';
    }
  }

  /// Maps a version string ("1.2.3", or "1.2.3+5") to a single comparable
  /// integer: major*1_000_000 + minor*1_000 + patch. Must stay in lock-step
  /// with the PHP `versionToBuild()` in the server so both agree on ordering.
  int versionToBuild(String version) {
    final parts = version.split(RegExp(r'[.+\-]'));
    int at(int i) =>
        i < parts.length ? (int.tryParse(parts[i].trim()) ?? 0) : 0;
    final major = at(0).clamp(0, 2000);
    final minor = at(1).clamp(0, 999);
    final patch = at(2).clamp(0, 999);
    return major * 1000000 + minor * 1000 + patch;
  }

  /// Fetches the latest release from the server, or null if the lookup fails or
  /// the server reports no release.
  Future<AppRelease?> fetchLatest() async {
    final res = await http
        .get(
          Uri.parse(UpdateConfig.versionUrl),
          headers: {'X-App-Key': UpdateConfig.appKey},
        )
        .timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) return null;
    final body = res.body.trim();
    if (body.isEmpty) return null;
    final decoded = _tryDecode(body);
    if (decoded == null) return null;
    if (decoded['ok'] == false) return null;
    if ((decoded['version'] ?? '').toString().trim().isEmpty) return null;
    return AppRelease.fromJson(decoded);
  }

  /// True when [release] is newer than what's installed. If we can't determine
  /// our own build (PackageInfo failed → build 0), return false rather than
  /// treating every release as newer — otherwise a mandatory release would
  /// reinstall the same version in a loop.
  Future<bool> isNewer(AppRelease release) async {
    final current = await currentBuild();
    if (current <= 0) return false;
    return release.build > current;
  }

  /// Downloads the installer to a temp file (reporting 0..1 progress), verifies
  /// the optional checksum, then launches it detached and asks the caller to
  /// quit so the installer can replace the running files.
  ///
  /// Returns the installer path; on success the app should exit immediately.
  Future<File> downloadInstaller(
    AppRelease release, {
    void Function(double progress)? onProgress,
  }) async {
    // On Linux the new build is a self-contained AppImage we keep next to the
    // current one; on Windows it's the .exe installer (temp is fine).
    final dir = Platform.isLinux
        ? await getApplicationSupportDirectory()
        : await getTemporaryDirectory();
    final ext = Platform.isLinux ? 'AppImage' : 'exe';
    final safeName = 'crms-setup-${release.version}.$ext'
        .replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
    final file = File(p.join(dir.path, safeName));

    final client = http.Client();
    try {
      final req = http.Request('GET', Uri.parse(release.url));
      req.headers['X-App-Key'] = UpdateConfig.appKey;
      final resp = await client.send(req);
      if (resp.statusCode != 200) {
        throw HttpException('Download failed (${resp.statusCode})');
      }

      final total = resp.contentLength ?? 0;
      var received = 0;
      final sink = file.openWrite();
      try {
        await for (final chunk in resp.stream) {
          sink.add(chunk);
          received += chunk.length;
          if (total > 0) onProgress?.call(received / total);
        }
      } finally {
        await sink.close();
      }
    } finally {
      client.close();
    }

    // Optional integrity check.
    final expected = release.sha256;
    if (expected != null && expected.isNotEmpty) {
      final actual = sha256.convert(await file.readAsBytes()).toString();
      if (actual.toLowerCase() != expected.toLowerCase()) {
        await file.delete();
        throw const FileSystemException('Checksum mismatch on downloaded update');
      }
    }
    return file;
  }

  /// Launches the downloaded installer and returns. The caller should exit the
  /// app right after so the installer can overwrite the locked EXE.
  void launchInstaller(File installer) {
    if (Platform.isWindows) {
      Process.start(
        installer.path,
        // Silent-but-visible install; relaunch is handled by the installer's
        // [Run] postinstall step.
        ['/SILENT', '/NOCANCEL', '/RESTARTAPPLICATIONS'],
        mode: ProcessStartMode.detached,
      );
    } else if (Platform.isLinux) {
      // AppImages are self-contained: mark the new one executable, then launch
      // it detached. It replaces the running session once this process exits.
      try {
        Process.runSync('chmod', ['+x', installer.path]);
      } catch (_) {/* best effort */}
      Process.start(
        installer.path,
        const [],
        mode: ProcessStartMode.detached,
      );
    }
  }

  Map<String, dynamic>? _tryDecode(String body) {
    try {
      final v = jsonDecode(body);
      return v is Map<String, dynamic> ? v : null;
    } catch (_) {
      return null;
    }
  }
}
