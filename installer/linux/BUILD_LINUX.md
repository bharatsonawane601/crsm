# Building the CRMS Linux app (.AppImage)

CRMS now ships on **Windows (.exe)**, **macOS (.dmg)** and **Linux (.AppImage)**.
This guide builds the Linux release.

> **You must build on Linux.** A Flutter Linux desktop build can only be
> compiled on a Linux machine — exactly like the `.dmg` needs a Mac. From
> Windows you can edit everything, but the actual binary is produced here.
> A 64-bit Ubuntu 22.04+ machine (or VM, or a CI runner) is all you need.

The output is a single portable **`.AppImage`** file: no install, no root, runs
on most 64-bit distributions. The in-app updater downloads a new AppImage,
marks it executable and relaunches automatically — the same silent experience
as the Windows installer.

---

## 1. One-time setup on the Linux machine

```bash
# Flutter + Linux desktop toolchain
sudo apt update
sudo apt install -y clang cmake ninja-build pkg-config \
     libgtk-3-dev liblzma-dev libstdc++-12-dev curl git

# Flutter (if not already installed)
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
export PATH="$PATH:$HOME/flutter/bin"
flutter config --enable-linux-desktop
flutter doctor          # should show "Linux toolchain" with a ✓
```

## 2. Get the project onto the Linux machine

Copy the whole project folder over (git clone, USB, scp, shared drive — any
way). The repo already contains the generated `linux/` folder, so nothing extra
is needed.

## 3. Build the AppImage

```bash
cd <project root>
bash installer/linux/build_appimage.sh
```

The script:
1. runs `flutter build linux --release`,
2. assembles an AppDir (binary + `lib/` + `data/` + launcher + icon + desktop entry),
3. downloads `appimagetool` if needed,
4. writes **`installer/output/crms-setup-<version>.AppImage`** and prints its SHA-256.

The version is read from `pubspec.yaml`, so the filename already matches what
the admin panel expects.

## 4. Publish the update

In the **admin panel → 🐧 Linux** tab:

- **Small enough?** Upload the `.AppImage` directly.
- **Too big for the upload limit?** Drop it into `api/releases/` via FTP / File
  Manager, then click **Register** on the Linux tab (no size limit applies).

The version auto-detects from the filename. Add release notes, tick **Mandatory**
if you want to force the update, and publish. Linux clients then auto-update on
next launch — and from **Settings → Check for update** — just like Windows.

## 5. Running it on a client PC

The `.AppImage` is self-contained:

```bash
chmod +x crms-setup-<version>.AppImage
./crms-setup-<version>.AppImage
```

> If a client's distro lacks FUSE, run with `--appimage-extract-and-run`, or
> install `libfuse2` (`sudo apt install libfuse2`).

---

## Notes

- **Same database & sync everywhere.** The Linux app uses the identical local
  `crms.sqlite` and the same central server, so the Sync-data button, officer
  portal, deletions/recycle-bin and updates all behave exactly as on Windows/macOS.
- **Icon.** The build uses `assets/images/crms_logo.png`. Replace it (same path)
  for a different launcher icon.
- **CI option.** The whole thing runs headless, so you can produce the AppImage
  on a GitHub Actions `ubuntu-latest` runner and attach it to a release.
