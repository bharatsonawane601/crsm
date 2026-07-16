#!/usr/bin/env bash
# ===========================================================================
# CRMS — build a Debian/Ubuntu .deb package (run this ON a Linux machine)
#
# Produces:  installer/output/crms_<version>_amd64.deb
# The version is read from pubspec.yaml.
#
# This is the DEMO build for Linux: it is compiled with
# --dart-define=CRMS_DEMO_MODE=true, so it auto-signs-in a demo officer and
# needs NO Google sign-in / email verification. (Real keys, if exported in the
# environment, are still passed through but the access gate stays open.)
#
# A Flutter Linux build can ONLY be produced on Linux — this script cannot run
# on Windows/macOS. See installer/linux/BUILD_LINUX.md for prerequisites.
#
# Usage:
#   cd <project root>
#   bash installer/linux/build_deb.sh
#
# Requires: a working Flutter Linux toolchain + dpkg-deb (the `dpkg` package).
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
echo "==> Building CRMS ${VERSION} .deb (Linux demo build)"

command -v dpkg-deb >/dev/null 2>&1 || {
  echo "ERROR: dpkg-deb not found — install it with: sudo apt-get install dpkg" >&2
  exit 1
}

# --- 1) Flutter release build (demo mode ON) -------------------------------
# CRMS_DEMO_MODE=true → no login / no email verification. Optional real keys
# are taken from the environment if present (CI/GitHub Secrets).
DEFINES=(--dart-define=CRMS_DEMO_MODE=true)
[ -n "${CRMS_APP_KEY:-}" ]              && DEFINES+=(--dart-define=CRMS_APP_KEY="${CRMS_APP_KEY}")
[ -n "${CRMS_API_BASE_URL:-}" ]         && DEFINES+=(--dart-define=CRMS_API_BASE_URL="${CRMS_API_BASE_URL}")
[ -n "${CRMS_GOOGLE_CLIENT_ID:-}" ]     && DEFINES+=(--dart-define=CRMS_GOOGLE_CLIENT_ID="${CRMS_GOOGLE_CLIENT_ID}")
[ -n "${CRMS_GOOGLE_CLIENT_SECRET:-}" ] && DEFINES+=(--dart-define=CRMS_GOOGLE_CLIENT_SECRET="${CRMS_GOOGLE_CLIENT_SECRET}")
[ -n "${CRMS_FIELD_KEY:-}" ]            && DEFINES+=(--dart-define=CRMS_FIELD_KEY="${CRMS_FIELD_KEY}")

flutter --version
flutter config --enable-linux-desktop >/dev/null 2>&1 || true
flutter pub get
flutter build linux --release "${DEFINES[@]}"

BUNDLE="build/linux/x64/release/bundle"
if [ ! -x "${BUNDLE}/crms" ]; then
  echo "ERROR: expected build output at ${BUNDLE}/crms — build failed?" >&2
  exit 1
fi
                        
# --- 2) Assemble the .deb file tree ----------------------------------------
PKGROOT="build/linux/deb/crms_${VERSION}_amd64"
rm -rf "${PKGROOT}"
mkdir -p "${PKGROOT}/DEBIAN" \
         "${PKGROOT}/opt/crms" \
         "${PKGROOT}/usr/local/bin" \
         "${PKGROOT}/usr/share/applications" \
         "${PKGROOT}/usr/share/icons/hicolor/256x256/apps"

# App bundle → /opt/crms
cp -r "${BUNDLE}/." "${PKGROOT}/opt/crms/"

# Launcher wrapper on PATH (sets the bundled lib path, then runs the binary).
cat > "${PKGROOT}/usr/local/bin/crms" <<'EOF'
#!/bin/sh
HERE="/opt/crms"
export LD_LIBRARY_PATH="${HERE}/lib:${LD_LIBRARY_PATH:-}"
exec "${HERE}/crms" "$@"
EOF
chmod 755 "${PKGROOT}/usr/local/bin/crms"

# Desktop entry + menu icon.
cp "installer/linux/crms.desktop" "${PKGROOT}/usr/share/applications/crms.desktop"
ICON_SRC="assets/images/crms_logo.png"
if [ -f "${ICON_SRC}" ]; then
  cp "${ICON_SRC}" "${PKGROOT}/usr/share/icons/hicolor/256x256/apps/crms.png"
else
  echo "WARN: ${ICON_SRC} not found — package will ship without a menu icon" >&2
fi

# Installed size (KB) for the control file.
INSTALLED_KB="$(du -sk "${PKGROOT}/opt" | cut -f1)"

# --- 3) Debian control metadata --------------------------------------------
cat > "${PKGROOT}/DEBIAN/control" <<EOF
Package: crms
Version: ${VERSION}
Section: utils
Priority: optional
Architecture: amd64
Maintainer: DB Square Technology <support@dbsquaretechnology.com>
Installed-Size: ${INSTALLED_KB}
Depends: libgtk-3-0, libglib2.0-0, libstdc++6
Description: CRMS — Crime Records Management System (demo)
 Chhatrapati Sambhaji Nagar Police — bilingual (Marathi/English) crime records
 management system. This Linux build is a no-login demo: it signs in a demo
 officer automatically and requires no Google sign-in or email verification.
EOF

# Refresh the desktop/icon caches after install & removal.
cat > "${PKGROOT}/DEBIAN/postinst" <<'EOF'
#!/bin/sh
set -e
if command -v update-desktop-database >/dev/null 2>&1; then
  update-desktop-database -q /usr/share/applications || true
fi
if command -v gtk-update-icon-cache >/dev/null 2>&1; then
  gtk-update-icon-cache -q -t -f /usr/share/icons/hicolor || true
fi
exit 0
EOF
chmod 755 "${PKGROOT}/DEBIAN/postinst"
cp "${PKGROOT}/DEBIAN/postinst" "${PKGROOT}/DEBIAN/postrm"

# --- 4) Build the package --------------------------------------------------
mkdir -p installer/output
OUT="installer/output/crms_${VERSION}_amd64.deb"
rm -f "${OUT}"
dpkg-deb --root-owner-group --build "${PKGROOT}" "${OUT}"

echo
echo "==> Done:  ${OUT}"
echo "    sha256: $(sha256sum "${OUT}" | cut -d' ' -f1)"
echo "    Install with:  sudo apt install ./${OUT}    (or: sudo dpkg -i ${OUT})"
echo "    Launch from the app menu (CRMS) or run 'crms' in a terminal."
