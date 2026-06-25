import 'dart:io';

/// Opens [url] in the user's default browser. No url_launcher dependency is
/// needed on desktop — Windows opens it via the shell, other platforms fall
/// back to xdg-open / open.
void openUrl(String url) {
  try {
    if (Platform.isWindows) {
      // rundll32 is the most reliable way to hand a URL to the default browser
      // on Windows desktop (same approach used by the Google OAuth flow).
      Process.run('rundll32', ['url.dll,FileProtocolHandler', url]);
    } else if (Platform.isMacOS) {
      Process.run('open', [url]);
    } else {
      Process.run('xdg-open', [url]);
    }
  } catch (_) {
    // Best-effort: if the shell call fails there is nothing useful to show.
  }
}
