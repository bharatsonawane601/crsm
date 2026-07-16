#!/usr/bin/env bash
# ===========================================================================
# CRMS — build a Linux .AppImage (run this ON a Linux machine)
#
# Produces:  installer/output/crms-setup-<version>.AppImage
# The version is read from pubspec.yaml, so the filename matches what the
# admin panel auto-detects (🐧 Linux Updates → upload / FTP-register).
#
# A Flutter Linux build can ONLY be produced on Linux — this script cannot run
# on Windows/macOS. See installer/linux/BUILD_LINUX.md for the full walkthrough.
#
# Usage:
#   cd <project root>
#   bash installer/linux/build_appimage.sh
# ===========================================================================
set -euo pipefail

# --- Resolve paths ---------------------------------------------------------
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
cd "${PROJECT_ROOT}"

# --- Read the version from pubspec.yaml (strip the +build suffix) ----------
VERSION="$(grep '^version:' pubspec.yaml | head -1 | sed 's/version:[[:space:]]*//; s/+.*//' | tr -d '[:space:]')"
if [ -z "${VERSION}" ]; then
  echo "ERROR: could not read version from pubspec.yaml" >&2
  exit 1
fi
echo "==> Building CRMS ${VERSION} for Linux"

# --- 1) Flutter release build ----------------------------------------------
# Secrets are injected via --dart-define so they never live in source. Set them
# in the environment before running (CI pulls them from GitHub Secrets):
#   CRMS_APP_KEY, CRMS_GOOGLE_CLIENT_ID, CRMS_GOOGLE_CLIENT_SECRET,
#   CRMS_API_BASE_URL (optional override). Any unset value falls back to the
#   in-code placeholder (a dev build with the access gate open).
DEFINES=()
[ -n "${CRMS_APP_KEY:-}" ]              && DEFINES+=(--dart-define=CRMS_APP_KEY="${CRMS_APP_KEY}")
[ -n "${CRMS_API_BASE_URL:-}" ]         && DEFINES+=(--dart-define=CRMS_API_BASE_URL="${CRMS_API_BASE_URL}")
[ -n "${CRMS_GOOGLE_CLIENT_ID:-}" ]     && DEFINES+=(--dart-define=CRMS_GOOGLE_CLIENT_ID="${CRMS_GOOGLE_CLIENT_ID}")
[ -n "${CRMS_GOOGLE_CLIENT_SECRET:-}" ] && DEFINES+=(--dart-define=CRMS_GOOGLE_CLIENT_SECRET="${CRMS_GOOGLE_CLIENT_SECRET}")
[ -n "${CRMS_FIELD_KEY:-}" ]            && DEFINES+=(--dart-define=CRMS_FIELD_KEY="${CRMS_FIELD_KEY}")

flutter --version
flutter pub get
flutter build linux --release "${DEFINES[@]}"

BUNDLE="build/linux/x64/release/bundle"
if [ ! -x "${BUNDLE}/crms" ]; then
  echo "ERROR: expected build output at ${BUNDLE}/crms — build failed?" >&2
  exit 1
fi

# --- 2) Assemble the AppDir ------------------------------------------------
APPDIR="build/linux/CRMS.AppDir"
rm -rf "${APPDIR}"
mkdir -p "${APPDIR}"
cp -r "${BUNDLE}/." "${APPDIR}/"   # crms binary + lib/ + data/ at AppDir root

# Launcher: AppImages exec ./AppRun; it sets the lib path and runs the binary.
cat > "${APPDIR}/AppRun" <<'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "${0}")")"
export LD_LIBRARY_PATH="${HERE}/lib:${LD_LIBRARY_PATH:-}"
exec "${HERE}/crms" "$@"
EOF
chmod +x "${APPDIR}/AppRun"

# Desktop entry + icon (both required at the AppDir root by appimagetool).
cp "installer/linux/crms.desktop" "${APPDIR}/crms.desktop"
ICON_SRC="assets/images/crms_logo.png"
if [ -f "${ICON_SRC}" ]; then
  cp "${ICON_SRC}" "${APPDIR}/crms.png"
else
  echo "WARN: ${ICON_SRC} not found — AppImage will use a default icon" >&2
  # appimagetool still needs *some* icon file; make a 1x1 placeholder.
  printf '' > "${APPDIR}/crms.png"
fi

# --- 3) Fetch appimagetool if needed ---------------------------------------
TOOL="build/linux/appimagetool-x86_64.AppImage"
if [ ! -x "${TOOL}" ]; then
  echo "==> Downloading appimagetool"
  curl -fL -o "${TOOL}" \
    "https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
  chmod +x "${TOOL}"
fi

# --- 4) Package the AppImage -----------------------------------------------
mkdir -p installer/output
OUT="installer/output/crms-setup-${VERSION}.AppImage"
rm -f "${OUT}"
# ARCH is required by appimagetool. --appimage-extract-and-run avoids needing
# FUSE on the build machine / CI.
ARCH=x86_64 "${TOOL}" --appimage-extract-and-run "${APPDIR}" "${OUT}"
chmod +x "${OUT}"

echo
echo "==> Done:  ${OUT}"
echo "    sha256: $(sha256sum "${OUT}" | cut -d' ' -f1)"
echo "    Upload this in the admin panel → 🐧 Linux Updates (or FTP-register it)."
