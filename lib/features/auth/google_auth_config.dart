/// Google OAuth (Desktop) credentials for real Gmail sign-in on Windows.
///
/// Create these in Google Cloud Console → APIs & Services → Credentials →
/// "Create credentials" → "OAuth client ID" → application type **Desktop app**.
/// Then paste the values below. (For a Desktop client the secret isn't truly
/// secret — it ships in the app — but Google still requires it for the flow.)
class GoogleAuthConfig {
  /// OAuth client ID, ends with `.apps.googleusercontent.com`. Injected at
  /// build time via --dart-define=CRMS_GOOGLE_CLIENT_ID=... (CI: GitHub secret).
  static const String clientId = String.fromEnvironment(
    'CRMS_GOOGLE_CLIENT_ID',
    defaultValue: 'PASTE_CLIENT_ID.apps.googleusercontent.com',
  );

  /// OAuth client secret for the Desktop client. Injected at build time via
  /// --dart-define=CRMS_GOOGLE_CLIENT_SECRET=... (CI: GitHub secret). Kept out
  /// of source control even though a Desktop-client secret ships in the binary.
  static const String clientSecret = String.fromEnvironment(
    'CRMS_GOOGLE_CLIENT_SECRET',
    defaultValue: '',
  );

  /// While unset, the app keeps using the demo sign-in stub so it still runs.
  static bool get isConfigured =>
      !clientId.startsWith('PASTE_') && clientId.isNotEmpty;
}
