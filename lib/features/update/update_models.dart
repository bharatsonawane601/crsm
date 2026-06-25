/// A release published on the server (parsed from version.php).
class AppRelease {
  const AppRelease({
    required this.version,
    required this.build,
    required this.url,
    this.notes = '',
    this.mandatory = false,
    this.sha256,
  });

  /// Human version string, e.g. "1.1.0".
  final String version;

  /// Monotonic build number — the source of truth for "is this newer?".
  final int build;

  /// Absolute download URL of the installer EXE.
  final String url;

  final String notes;
  final bool mandatory;

  /// Optional hex SHA-256 of the installer for integrity verification.
  final String? sha256;

  factory AppRelease.fromJson(Map<String, dynamic> j) {
    int asInt(Object? v) =>
        v is int ? v : int.tryParse('${v ?? ''}'.trim()) ?? 0;
    bool asBool(Object? v) =>
        v == true || v == 1 || '$v' == '1' || '$v'.toLowerCase() == 'true';
    return AppRelease(
      version: '${j['version'] ?? ''}'.trim(),
      build: asInt(j['build']),
      url: '${j['url'] ?? ''}'.trim(),
      notes: '${j['notes'] ?? ''}'.trim(),
      mandatory: asBool(j['mandatory']),
      sha256: (j['sha256'] == null || '${j['sha256']}'.trim().isEmpty)
          ? null
          : '${j['sha256']}'.trim(),
    );
  }
}

/// Where the updater currently is.
enum UpdatePhase {
  idle,
  checking,
  upToDate,
  available, // optional update the user can take or skip
  mandatory, // update the user must take before using the app
  downloading,
  installing,
  failed,
}

class UpdateState {
  const UpdateState({
    this.phase = UpdatePhase.idle,
    this.release,
    this.progress = 0,
    this.error,
  });

  final UpdatePhase phase;
  final AppRelease? release;

  /// 0..1 while downloading.
  final double progress;

  /// i18n key or message shown on failure.
  final String? error;

  bool get isBusy =>
      phase == UpdatePhase.checking ||
      phase == UpdatePhase.downloading ||
      phase == UpdatePhase.installing;

  UpdateState copyWith({
    UpdatePhase? phase,
    AppRelease? release,
    double? progress,
    String? error,
  }) =>
      UpdateState(
        phase: phase ?? this.phase,
        release: release ?? this.release,
        progress: progress ?? this.progress,
        error: error,
      );
}
