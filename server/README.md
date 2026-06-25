# CRMS Access-Approval Server (Hostinger)

Self-hosted Gmail + admin-approval gate for CRMS. A user signs in with Google in
the app → the app asks this server → you approve from `admin.php` → the user gets
in. One approved email is locked to one device (HWID).

## Files
- `config.php` — your DB credentials, app key, admin password, Google client ID.
- `db.php` — MySQL connection + auto-creates the `access_users` and `app_release` tables.
- `check.php` — the endpoint the app calls (creates pending request + returns status).
- `version.php` — returns the latest released version (used by the in-app updater).
- `admin.php` — password-protected approve/deny panel **+ App Updates uploader**.
- `releases/` — created automatically; stores the uploaded installer EXEs.

## Setup on Hostinger (premium shared hosting)
1. **Create a MySQL database**: hPanel → *Databases → MySQL Databases*. Note the
   database name, username, password.
2. **Upload** the `server/` files into a folder of your domain, e.g.
   `public_html/api/` (so the URL becomes `https://yourdomain.com/api/`).
3. **Edit `config.php`** and fill in:
   - `DB_NAME`, `DB_USER`, `DB_PASS` (from step 1; `DB_HOST` is usually `localhost`).
   - `APP_KEY` — a long random string. **Put the same value** in the app
     (`lib/features/access/access_config.dart` → `appKey`).
   - `ADMIN_PASSWORD` — a strong password for the admin panel.
4. **Enable HTTPS** for your domain (hPanel → *SSL*; free with Hostinger).
5. In the app's `access_config.dart`, set `apiBaseUrl` to `https://yourdomain.com/api`.
6. Open `https://yourdomain.com/api/admin.php` → sign in → you'll see requests
   appear here as users try to log in.

## Approving users
- A new login shows up as **pending**. Click **Approve**.
- **Deny** blocks an email. **Reset device** clears the HWID so an approved user
  can move to a new computer. **Delete** removes the record.

## Google token verification (recommended for production)
While the app uses the demo sign-in stub there's no real Google token, so leave
`VERIFY_GOOGLE_TOKEN = false`. Once real Windows Google OAuth is wired in (the app
sends a real `id_token`), set:
- `GOOGLE_CLIENT_ID` = your OAuth **Desktop client ID**, and
- `VERIFY_GOOGLE_TOKEN = true`

so the server cryptographically verifies the identity instead of trusting the
email from the client.

## Auto-update (releasing a new version)
The app checks `version.php` **on every launch** (and from *Settings → Check for
update*). If the server's build number is higher than the running app's, it shows
an update prompt; mark a release **Mandatory** to force it.

Updates are only ever applied on launch or when the user clicks update — never
while someone is working.

The **version is the single source of truth** — the app derives a comparable
build number from it automatically, so you only ever bump the version.

To publish an update:
1. **Bump the version** in `pubspec.yaml`, e.g. `version: 1.1.0+1` (only the part
   before `+` matters; the `+` number is ignored now).
2. `flutter build windows --release`
3. Build the installer with **Inno Setup** using `installer/crms.iss` (set
   `MyAppVersion` to match). Output: `installer/output/crms-setup-1.1.0.exe`.
4. Open `admin.php` → **App Updates** → choose the EXE. The **version auto-fills
   from the file name**; add release notes, tick **Mandatory** if required, upload.
5. Done. Existing installs will offer/apply the update on their next launch.

> Newer = higher version. `1.1.0` > `1.0.0`; `1.0.10` > `1.0.9`. Each version
> part supports up to 999 (minor/patch) — plenty for normal versioning.

Notes:
- Large installers may exceed the host's `upload_max_filesize` / `post_max_size`.
  Raise these in hPanel → *PHP Configuration* if the upload fails.
- The installer is per-user (`%LOCALAPPDATA%\Programs\CRMS`), so updates don't
  trigger a UAC/admin prompt.

## Security notes
- Keep `APP_KEY` and `ADMIN_PASSWORD` secret and strong.
- The API only responds to callers presenting the correct `X-App-Key` header.
- Always serve over **HTTPS**.
- Consider restricting `admin.php` by IP (hPanel → *.htaccess*).
- Installer EXEs in `releases/` are downloadable by URL (not secret) — that's
  fine for an installer, but don't put anything sensitive in that folder.
