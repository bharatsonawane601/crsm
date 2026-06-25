# CRMS — Crime Records Management System

Bilingual (मराठी / English) **offline-first** desktop application for the
Chhatrapati Sambhaji Nagar Police, built by **DB Square Technology**.

Runs on **Windows**, **macOS** and **Linux**, with a self-hosted PHP + MySQL
backend (officer portal, access approval, and auto-updates).

---

## ✨ Features

- **Offline-first** FIR / crime records in a local encrypted SQLite database.
- **Officer portal** (CP → DCP → ACP → Station) — scope-filtered, read-only
  dashboards and search across the jurisdiction.
- **Central sync** — stations upload records to one shared store; a **Sync data**
  button (manual + auto every 90s) keeps every device current. Admin deletions
  propagate down to clients; a 30-day recycle bin allows recovery.
- **In-app auto-update** on all three platforms (.exe / .dmg / .AppImage).
- **Admin panel** — users & access, FIR control, deletions audit, recycle bin,
  hierarchy, and per-platform update publishing.

---

## 🔐 Security — read before building

Secrets are **never** committed. They are injected at build time with Dart
`--dart-define` (and via GitHub Secrets in CI). The live server credentials live
only in `server/config.php`, which is git-ignored — start from
[`server/config.sample.php`](server/config.sample.php).

Build-time variables:

| Variable | What it is | Where it comes from |
|---|---|---|
| `CRMS_APP_KEY` | Shared `X-App-Key` (must match `APP_KEY` in `config.php`) | GitHub secret / your build command |
| `CRMS_GOOGLE_CLIENT_ID` | Google OAuth Desktop client ID | GitHub secret |
| `CRMS_GOOGLE_CLIENT_SECRET` | Google OAuth Desktop client secret | GitHub secret |
| `CRMS_API_BASE_URL` | (optional) override the backend URL | GitHub secret |

> Without these defines the app builds in **development mode** (access gate open,
> demo sign-in). A real client build **must** pass at least `CRMS_APP_KEY`.

---

## 🛠️ Building

### Windows (`.exe`)
```bat
flutter build windows --release ^
  --dart-define=CRMS_APP_KEY=YOUR_KEY ^
  --dart-define=CRMS_GOOGLE_CLIENT_ID=YOUR_ID ^
  --dart-define=CRMS_GOOGLE_CLIENT_SECRET=YOUR_SECRET
:: then compile the installer with Inno Setup:
"C:\Program Files (x86)\Inno Setup 6\ISCC.exe" installer\crms.iss
```

### macOS (`.dmg`) — must run on a Mac
See [`installer/macos/BUILD_MACOS.md`](installer/macos/BUILD_MACOS.md).

### Linux (`.AppImage`) — must run on Linux (or use CI below)
See [`installer/linux/BUILD_LINUX.md`](installer/linux/BUILD_LINUX.md). One command:
```bash
export CRMS_APP_KEY=YOUR_KEY CRMS_GOOGLE_CLIENT_ID=YOUR_ID CRMS_GOOGLE_CLIENT_SECRET=YOUR_SECRET
bash installer/linux/build_appimage.sh
# → installer/output/crms-setup-<version>.AppImage
```

### Linux via GitHub Actions (no Linux machine needed)
1. In the repo: **Settings → Secrets and variables → Actions → New repository
   secret** and add `CRMS_APP_KEY`, `CRMS_GOOGLE_CLIENT_ID`,
   `CRMS_GOOGLE_CLIENT_SECRET` (and optionally `CRMS_API_BASE_URL`).
2. **Actions → Build Linux AppImage → Run workflow** — or push a tag `vX.Y.Z`
   to also publish a GitHub Release with the `.AppImage` attached.
3. Download the AppImage from the run's **Artifacts** (or the Release).

---

## 📦 Installing (end users)

- **Windows:** run `crms-setup-<version>.exe`. If SmartScreen warns, click
  *More info → Run anyway* (the installer is unsigned until a code-signing
  certificate is added).
- **macOS:** open the `.dmg` and drag CRMS to Applications.
- **Linux:**
  ```bash
  chmod +x crms-setup-<version>.AppImage
  ./crms-setup-<version>.AppImage
  ```
  On Ubuntu 22.04 install FUSE2 once if needed: `sudo apt install libfuse2`.

After install, the app auto-updates from the admin panel's published releases.

---

## 🌐 Server setup

Upload the `server/` folder to your host (e.g. Hostinger, into `api/`), copy
`config.sample.php` → `config.php`, and fill in the real values. Tables
auto-create on first request. Open `admin.php` to manage users, FIRs, deletions
and publish updates (🪟 Windows / 🍎 macOS / 🐧 Linux tabs).

---

© DB Square Technology. For authorised police use.
