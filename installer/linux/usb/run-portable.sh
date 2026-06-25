#!/usr/bin/env bash
# Run CRMS straight from the pendrive WITHOUT installing anything.
# (Installs nothing; just launches the AppImage next to this script.)
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPIMAGE="$(ls "${HERE}"/*.AppImage 2>/dev/null | head -1 || true)"
if [ -z "${APPIMAGE:-}" ]; then
  echo "ERROR: no .AppImage found next to this script." >&2
  exit 1
fi
chmod +x "${APPIMAGE}"
exec "${APPIMAGE}" --appimage-extract-and-run "$@"
