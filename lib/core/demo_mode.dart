/// Whether this build is a no-login **demo** (the Linux .deb). In demo mode the
/// app auto-signs-in a demo officer and the access/approval gate stays open —
/// no Google sign-in and no email verification.
///
/// Compile-time constant (tree-shaken), enabled by the Linux build script with
/// `--dart-define=CRMS_DEMO_MODE=true`. Off for the Windows/macOS production
/// builds and for tests, so their behaviour is unchanged.
const bool kCrmsDemoMode =
    bool.fromEnvironment('CRMS_DEMO_MODE', defaultValue: false);

/// Identity used for the demo build's automatic session.
const String kCrmsDemoEmail = 'demo.officer@crms.local';
const String kCrmsDemoName = 'Demo Officer';
