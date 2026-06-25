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

## 🐧 Install on Linux

### Easiest — USB / pendrive (no Flutter, no internet, no admin)
Build the app **once** in the cloud, then carry it on a pendrive to every PC:
1. Add the repo secrets (**Settings → Secrets and variables → Actions**):
   `CRMS_APP_KEY`, `CRMS_GOOGLE_CLIENT_ID`, `CRMS_GOOGLE_CLIENT_SECRET`.
2. **Actions → Build Linux AppImage → Run workflow**, then download the
   **`crms-linux-usb`** artifact and unzip it onto a pendrive.
3. On each office PC: plug in → open the folder → run **`./install.sh`**.
   It installs CRMS for that user (menu icon + launcher) and launches it — no
   Flutter, internet or admin needed. `./run-portable.sh` runs it without
   installing. Details: [`installer/linux/usb/README.txt`](installer/linux/usb/README.txt).

### From source — clone & build
On the target PC (Ubuntu 22.04+):

```bash
# one-time: Flutter Linux toolchain (see installer/linux/BUILD_LINUX.md §1)
git clone https://github.com/bharatsonawane601/crsm.git
cd crsm
cp crms.env.sample crms.env     # then edit crms.env with the real keys
./install.sh
```

`install.sh` builds the release, installs to `/opt/crms`, and adds a launcher
(`crms`) plus an **application-menu icon** — so it shows up and runs like normal
installed software. Remove it with `./uninstall.sh`.

> Without a filled-in `crms.env` the app still builds, but in **dev mode**
> (access gate open). Fill in `CRMS_APP_KEY` (and the Google keys) for a build
> that talks to your live server.

### Other Linux build options
- **Portable `.AppImage`** (no install): see
  [`installer/linux/BUILD_LINUX.md`](installer/linux/BUILD_LINUX.md) /
  `installer/linux/build_appimage.sh`.
- **GitHub Actions** (no local Linux machine): add `CRMS_APP_KEY`,
  `CRMS_GOOGLE_CLIENT_ID`, `CRMS_GOOGLE_CLIENT_SECRET` as repo **Settings →
  Secrets → Actions**, then run the **Build Linux AppImage** workflow (or push a
  `vX.Y.Z` tag to publish a Release with the AppImage attached).

### macOS (`.dmg`)
Built separately on a Mac — see
[`installer/macos/BUILD_MACOS.md`](installer/macos/BUILD_MACOS.md).

> **Windows** builds are produced from the developer machine (the `windows/`
> project files are kept out of this Linux-focused repo).

---

## 🌐 Server setup

Upload the `server/` folder to your host (e.g. Hostinger, into `api/`), copy
`config.sample.php` → `config.php`, and fill in the real values. Tables
auto-create on first request. Open `admin.php` to manage users, FIRs, deletions
and publish updates (🪟 Windows / 🍎 macOS / 🐧 Linux tabs).

---

© DB Square Technology. For authorised police use.
