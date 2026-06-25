/// Configuration for the self-hosted access-approval backend (the PHP API you
/// upload to Hostinger).
class AccessConfig {
  /// Base URL of your API folder on Hostinger. No trailing slash. Overridable
  /// at build time with --dart-define=CRMS_API_BASE_URL=... (not secret).
  static const String apiBaseUrl = String.fromEnvironment(
    'CRMS_API_BASE_URL',
    defaultValue: 'https://lightskyblue-sandpiper-705674.hostingersite.com/api',
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
