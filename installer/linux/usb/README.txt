CRMS — Linux USB installer
==========================

This folder is meant to sit on a pendrive together with the CRMS .AppImage.
No Flutter, no internet and no admin rights are needed on the office PC.

Folder contents:
  crms-setup-<version>.AppImage   the whole app in one file
  install.sh                      install it (adds a menu icon, then launches)
  run-portable.sh                 just run it once, without installing

------------------------------------------------------------------
HOW TO USE ON AN OFFICE PC
------------------------------------------------------------------
1. Plug in the pendrive and open this folder.
2. Install (recommended):
       Right-click install.sh -> Run,  OR in a terminal:
       ./install.sh
   CRMS installs for your user and launches. Afterwards open it any time
   from the applications menu (search "CRMS") or by typing:  crms

   Just want to try it without installing?
       ./run-portable.sh

To remove it later:
       rm -rf ~/.local/share/crms ~/.local/bin/crms ~/.local/share/applications/crms.desktop

------------------------------------------------------------------
HOW TO GET THE .AppImage ONTO THIS FOLDER (one time)
------------------------------------------------------------------
Easiest — GitHub Actions (no Linux machine needed):
  - In the repo: Settings -> Secrets and variables -> Actions, add
    CRMS_APP_KEY, CRMS_GOOGLE_CLIENT_ID, CRMS_GOOGLE_CLIENT_SECRET.
  - Actions tab -> "Build Linux AppImage" -> Run workflow.
  - Download the "crms-linux-usb" artifact — it already contains the
    AppImage + these scripts. Unzip it onto the pendrive. Done.

Or build locally on any Linux box:
       bash installer/linux/build_appimage.sh
       cp installer/output/*.AppImage installer/linux/usb/
