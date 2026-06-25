import 'dart:io';

import '../access/access_config.dart';

/// Configuration for the in-app updater. Reuses the same Hostinger API base and
/// shared app key as the access server.
class UpdateConfig {
  /// Endpoint that returns the latest released version as JSON, tagged with this
  /// device's platform so the server returns the matching build
  /// (.exe / .dmg / .AppImage).
  static String get versionUrl =>
      '${AccessConfig.apiBaseUrl}/version.php?platform=$platform';

  /// The platform token the server understands ('windows' | 'macos' | 'linux').
  static String get platform => Platform.isMacOS
      ? 'macos'
      : Platform.isLinux
          ? 'linux'
          : 'windows';

  /// Shared secret sent in the `X-App-Key` header (same as the access API).
  static String get appKey => AccessConfig.appKey;

  /// Whether the updater is wired up to a real server.
  static bool get isConfigured => AccessConfig.isConfigured;
}
