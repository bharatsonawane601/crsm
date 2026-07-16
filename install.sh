#!/usr/bin/env bash
# ===========================================================================
# CRMS — Linux installer (build from source + install with a menu icon)
#
# On the office PC, after `git clone`:
#     cd crsm
#     ./install.sh
#
# It builds the release, installs to /opt/crms, adds a launcher symlink
# (`crms`) and an application-menu icon — so it shows up and runs like normal
# installed software (the same feel as the Windows version).
#
# Secrets: the real API key + Google credentials are read from ./crms.env if it
# exists (see crms.env.sample). Without them the app builds in dev mode.
# Requires: a working Flutter Linux toolchain (see installer/linux/BUILD_LINUX.md)
# and sudo (to install under /opt and the system applications folder).
# ===========================================================================
set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${PROJECT_ROOT}"

PREFIX="/opt/crms"
DESKTOP_FILE="/usr/share/applications/crms.desktop"
BIN_LINK="/usr/local/bin/crms"

echo "==> CRMS Linux install"

# --- 0) Pre-flight ---------------------------------------------------------
if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: 'flutter' not found in PATH." >&2
  echo "       Install the Flutter Linux toolchain first — see" >&2
  echo "       installer/linux/BUILD_LINUX.md (section 1)." >&2
  exit 1
fi
flutter config --enable-linux-desktop >/dev/null 2>&1 || true

# --- 1) Load build secrets if provided -------------------------------------
if [ -f crms.env ]; then
  echo "==> Loading keys from crms.env"
  set -a; . ./crms.env; set +a
else
  echo "WARN: no crms.env found — building in DEV mode (access gate open)." >&2
  echo "      Copy crms.env.sample to crms.env and fill in the real keys for a" >&2
  echo "      production build that talks to your server." >&2
fi

DEFINES=()
[ -n "${CRMS_APP_KEY:-}" ]              && DEFINES+=(--dart-define=CRMS_APP_KEY="${CRMS_APP_KEY}")
[ -n "${CRMS_API_BASE_URL:-}" ]         && DEFINES+=(--dart-define=CRMS_API_BASE_URL="${CRMS_API_BASE_URL}")
[ -n "${CRMS_GOOGLE_CLIENT_ID:-}" ]     && DEFINES+=(--dart-define=CRMS_GOOGLE_CLIENT_ID="${CRMS_GOOGLE_CLIENT_ID}")
[ -n "${CRMS_GOOGLE_CLIENT_SECRET:-}" ] && DEFINES+=(--dart-define=CRMS_GOOGLE_CLIENT_SECRET="${CRMS_GOOGLE_CLIENT_SECRET}")
[ -n "${CRMS_FIELD_KEY:-}" ]            && DEFINES+=(--dart-define=CRMS_FIELD_KEY="${CRMS_FIELD_KEY}")

# --- 2) Build --------------------------------------------------------------
echo "==> Building (flutter build linux --release)"
flutter pub get
flutter build linux --release "${DEFINES[@]}"

BUNDLE="build/linux/x64/release/bundle"
if [ ! -x "${BUNDLE}/crms" ]; then
  echo "ERROR: build output missing at ${BUNDLE}/crms" >&2
  exit 1
fi

# --- 3) Install under /opt -------------------------------------------------
echo "==> Installing to ${PREFIX} (needs sudo)"
sudo rm -rf "${PREFIX}"
sudo mkdir -p "${PREFIX}"
sudo cp -r "${BUNDLE}/." "${PREFIX}/"

ICON_SRC="assets/images/crms_logo.png"
if [ -f "${ICON_SRC}" ]; then
  sudo cp "${ICON_SRC}" "${PREFIX}/crms.png"
fi

# --- 4) Launcher symlink + application-menu entry --------------------------
sudo ln -sf "${PREFIX}/crms" "${BIN_LINK}"

sudo tee "${DESKTOP_FILE}" >/dev/null <<EOF
[Desktop Entry]
Type=Application
Name=CRMS
GenericName=Crime Records Management System
Comment=Chhatrapati Sambhaji Nagar Police — Crime Records Management System
Exec=${PREFIX}/crms
Icon=${PREFIX}/crms.png
Categories=Office;Utility;
Terminal=false
StartupWMClass=crms
EOF

sudo update-desktop-database /usr/share/applications >/dev/null 2>&1 || true

echo
echo "==> Done. CRMS is installed."
echo "    • Launch from the applications menu (search 'CRMS'), or run: crms"
echo "    • Uninstall any time with: ./uninstall.sh"
