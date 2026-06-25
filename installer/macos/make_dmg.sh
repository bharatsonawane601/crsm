#!/usr/bin/env bash
# Build a distributable .dmg for CRMS on macOS.
# Run on a Mac AFTER: flutter build macos --release
#
#   ./installer/macos/make_dmg.sh 1.3.2
#
# Produces installer/macos/output/CRMS-<version>.dmg with a drag-to-Applications
# layout. Sign the .app and notarize the .dmg afterwards (see BUILD_MACOS.md).
set -euo pipefail

VERSION="${1:?Usage: make_dmg.sh <version>  e.g. make_dmg.sh 1.3.2}"
APP_NAME="CRMS"
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
APP="$ROOT/build/macos/Build/Products/Release/$APP_NAME.app"
OUT_DIR="$ROOT/installer/macos/output"
DMG="$OUT_DIR/$APP_NAME-$VERSION.dmg"

if [[ ! -d "$APP" ]]; then
  echo "Error: $APP not found. Run 'flutter build macos --release' first." >&2
  exit 1
fi

mkdir -p "$OUT_DIR"
rm -f "$DMG"

# Prefer create-dmg (brew install create-dmg) for a nice window layout;
# fall back to plain hdiutil if it isn't installed.
if command -v create-dmg >/dev/null 2>&1; then
  create-dmg \
    --volname "$APP_NAME $VERSION" \
    --window-size 540 360 \
    --icon-size 110 \
    --icon "$APP_NAME.app" 140 170 \
    --app-drop-link 400 170 \
    --hide-extension "$APP_NAME.app" \
    "$DMG" "$APP"
else
  echo "create-dmg not found; building a simple DMG with hdiutil."
  STAGE="$(mktemp -d)"
  cp -R "$APP" "$STAGE/"
  ln -s /Applications "$STAGE/Applications"
  hdiutil create -volname "$APP_NAME $VERSION" -srcfolder "$STAGE" \
    -ov -format UDZO "$DMG"
  rm -rf "$STAGE"
fi

echo "Built: $DMG"
echo "Next: notarize + staple (see BUILD_MACOS.md)."
