# Building CRMS for macOS (Apple Silicon M1–M5, macOS 26/27)

> ⚠️ macOS apps **must be built, signed, and notarized on a Mac** with Xcode.
> This cannot be done on Windows. Everything below runs on the Mac.

## Why one build covers M1–M5 and macOS 26/27
- All Apple Silicon chips (M1, M2, M3, M4, M5) are **arm64**. A single
  `flutter build macos --release` produces an arm64 app that runs natively on
  every one of them. (It also runs on Intel Macs via Rosetta if needed; for a
  true Intel-native slice build a universal binary — see "Universal" below.)
- The minimum deployment target is **macOS 10.15** (`MACOSX_DEPLOYMENT_TARGET`
  in `macos/Runner.xcodeproj`). Newer macOS — including 26 and 27 — always runs
  apps built against an older minimum, so the app is forward-compatible with no
  extra work. Do **not** raise the minimum to 26/27 or older Macs stop working.

## One-time setup on the Mac
1. Install Xcode (from the App Store) + command line tools: `xcode-select --install`
2. Install CocoaPods: `sudo gem install cocoapods`
3. Install Flutter and run `flutter doctor` until macOS is checked.
4. Enable desktop: `flutter config --enable-macos-desktop`

## Build
```bash
cd CRSM
flutter pub get
flutter build macos --release
# Output: build/macos/Build/Products/Release/CRMS.app
```

### Universal (arm64 + x86_64) — only if you must ship Intel-native
```bash
flutter build macos --release
# Flutter builds arm64 by default on Apple Silicon. For a universal binary,
# build on an Apple Silicon Mac with the macos deployment configured for both
# archs in Xcode (Runner target → Build Settings → Architectures → Standard).
```
For police-issued modern MacBooks (all M-series), the default arm64 build is
correct and smallest. Skip universal unless old Intel hardware is in scope.

## Code signing + notarization (required for distribution)
You need an Apple Developer account ($99/yr) and a **Developer ID Application**
certificate installed in Keychain.

1. Sign during build by setting your Team in `macos/Runner.xcodeproj`
   (Signing & Capabilities → Team), or sign the built app manually:
   ```bash
   codesign --deep --force --options runtime \
     --sign "Developer ID Application: DB Square Technology (TEAMID)" \
     build/macos/Build/Products/Release/CRMS.app
   ```
2. Build the DMG (see `make_dmg.sh`).
3. Notarize the DMG with Apple:
   ```bash
   xcrun notarytool submit CRMS-<version>.dmg \
     --apple-id "you@example.com" --team-id TEAMID \
     --password "app-specific-password" --wait
   ```
4. Staple the ticket so it works offline:
   ```bash
   xcrun stapler staple CRMS-<version>.dmg
   ```

Without signing+notarization, Gatekeeper on macOS will block the app
("cannot be opened because the developer cannot be verified"); users would have
to right-click → Open. For a deployed product, notarize it.

## Entitlements (already configured)
`macos/Runner/Release.entitlements` enables:
- `network.client` — reach the Hostinger access/portal server + Google OAuth.
- `network.server` — the Google OAuth loopback HTTP server on localhost.
- `files.user-selected.read-write` — backups and report exports via the picker.

## Notes / platform differences handled in code
- **Auto-update**: the app checks `version.php?platform=macos` and, when a newer
  build exists, prompts the user. macOS can't silently install a `.dmg`, so
  "Update now" opens the `.dmg` download in the browser; the user drags CRMS to
  Applications. Windows downloads + launches the `.exe` silently. Publish macOS
  updates from the admin panel by uploading/registering the signed `.dmg` (it is
  tagged platform=macos automatically). A future option is a Sparkle feed for
  true silent macOS updates.
- **Native "अ" text editor** button is Windows-only; macOS uses the standard
  Flutter text fields (IME handles Marathi input natively).
- **Hardware id** (`hwid.dart`) uses the Mac's IOPlatformUUID instead of the
  Windows MachineGuid — the access server binds the approved email to it.
