#!/usr/bin/env bash
# Removes a CRMS install done by install.sh (binary, launcher, menu icon).
# Your data (the local database in your home directory) is left untouched.
set -euo pipefail

echo "==> Removing CRMS (needs sudo)"
sudo rm -rf /opt/crms
sudo rm -f /usr/local/bin/crms
sudo rm -f /usr/share/applications/crms.desktop
sudo update-desktop-database /usr/share/applications >/dev/null 2>&1 || true
echo "==> Done. CRMS uninstalled (your records/database were not deleted)."
