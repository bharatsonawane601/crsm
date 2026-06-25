#!/usr/bin/env bash
# ===========================================================================
# CRMS — USB / offline installer (NO Flutter, NO internet, NO admin needed)
#
# Put this script next to a CRMS .AppImage (the GitHub Actions build, or
# build_appimage.sh output) on a pendrive. On any 64-bit Linux office PC:
#
#     plug in the pendrive  →  open this folder  →  run:   ./install.sh
#
# It installs CRMS for the current user and launches it. Find "CRMS" in the
# applications menu afterwards (with icon), exactly like installed software.
# ===========================================================================
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPIMAGE="$(ls "${HERE}"/*.AppImage 2>/dev/null | head -1 || true)"
if [ -z "${APPIMAGE:-}" ]; then
  echo "ERROR: no .AppImage found next to this installer." >&2
  echo "       Copy the CRMS .AppImage into this same folder, then re-run." >&2
  exit 1
fi

echo "==> Installing CRMS for $(whoami) (no admin required)"
APPDIR="${HOME}/.local/share/crms"
APPS="${HOME}/.local/share/applications"
BIN="${HOME}/.local/bin"
mkdir -p "${APPS}" "${BIN}"
rm -rf "${APPDIR}"
mkdir -p "${APPDIR}"

# Extract the AppImage into place so it runs even on PCs without FUSE.
chmod +x "${APPIMAGE}"
tmp="$(mktemp -d)"
( cd "${tmp}" && "${APPIMAGE}" --appimage-extract >/dev/null )
cp -r "${tmp}/squashfs-root/." "${APPDIR}/"
rm -rf "${tmp}"

# Icon + launcher
ICON="${APPDIR}/crms.png"
[ -f "${ICON}" ] || ICON="$(ls "${APPDIR}"/*.png 2>/dev/null | head -1 || true)"
ln -sf "${APPDIR}/AppRun" "${BIN}/crms"

cat > "${APPS}/crms.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=CRMS
GenericName=Crime Records Management System
Comment=Chhatrapati Sambhaji Nagar Police — Crime Records Management System
Exec=${APPDIR}/AppRun
Icon=${ICON}
Categories=Office;Utility;
Terminal=false
StartupWMClass=crms
EOF
chmod +x "${APPS}/crms.desktop"
update-desktop-database "${APPS}" >/dev/null 2>&1 || true

echo "==> Installed. Launching CRMS…"
echo "    (Next time: open it from the applications menu, or run 'crms'.)"
nohup "${APPDIR}/AppRun" >/dev/null 2>&1 &
disown || true
