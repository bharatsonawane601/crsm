/// Configuration for the self-hosted access-approval backend.
class AccessConfig {
  /// Base URL of the CRMS API. No trailing slash. Overridable at build time
  /// with --dart-define=CRMS_API_BASE_URL=... (not secret).
  ///
  /// This defaults to the office's own server (the primary since the 2026-07
  /// cutover). It is deliberately NOT the old Hostinger URL: a build that
  /// forgets the dart-define must fail safe by talking to the real server,
  /// not silently check approvals against the retired one — that looks
  /// exactly like "the admin approved me but the app still says pending".
  static const String apiBaseUrl = String.fromEnvironment(
    'CRMS_API_BASE_URL',
    defaultValue: 'https://crms-server.tailcbd550.ts.net:8443/api',
  );

  /// Shared secret sent in the `X-App-Key` header so random callers can't hit
  /// your API. Must match `APP_KEY` in the server's config.php.
  ///
  /// Injected at build time so the real key never lives in source control:
  ///   `flutter build <platform> --release --dart-define=CRMS_APP_KEY=KEY`
  /// (In CI it comes from the CRMS_APP_KEY GitHub secret.) With no define the
  /// placeholder keeps the access gate open for local development.
  static const String appKey = String.fromEnvironment(
    'CRMS_APP_KEY',
    defaultValue: 'PASTE_A_LONG_RANDOM_APP_KEY',
  );

  /// How often the "waiting for approval" screen re-checks the server.
  static const Duration pollInterval = Duration(seconds: 20);

  /// True once the placeholders are replaced, so the gate stays open (app
  /// usable) during development until the server is configured.
  static bool get isConfigured =>
      !apiBaseUrl.contains('PASTE-YOUR-DOMAIN') &&
      appKey != 'PASTE_A_LONG_RANDOM_APP_KEY' &&
      apiBaseUrl.isNotEmpty &&
      appKey.isNotEmpty;
}
