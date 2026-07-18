# Mac session — 2026-07-18 — macOS DMG build + production fixes

Everything done on the Mac today, in order. No server/app code was broken
by this session; two real bugs were found and fixed, one on the server DB
(not in git — see below) and one is just build configuration (also not
in git — dart-defines are passed at build time, not stored in source).

## 1. macOS app icon fixed (COMMITTED — the only source change today)
The `AppIcon.appiconset` PNGs were stale (from before the current CRMS
logo existed). Regenerated all 7 sizes from `assets/images/crms_logo.png`
with `sips`. Also had to blow away the OLD `/Applications/CRMS.app` and
force-refresh macOS Launch Services (`lsregister -f`) + restart
Dock/Finder, because the stale icon was cached under the same bundle id
(`com.mhpolice.crms`) and a plain rebuild doesn't override that cache.

Files changed (binary, all in `macos/Runner/Assets.xcassets/AppIcon.appiconset/`):
`app_icon_16.png`, `app_icon_32.png`, `app_icon_64.png`, `app_icon_128.png`,
`app_icon_256.png`, `app_icon_512.png`, `app_icon_1024.png`.

## 2. Google Sign-In was completely broken on macOS (build config, not code)
Root cause: the macOS release build was invoked with
`--dart-define=CRMS_GOOGLE_CLIENT_ID=...` but **not**
`--dart-define=CRMS_GOOGLE_CLIENT_SECRET=...`. Google's OAuth token
exchange requires both — every sign-in failed at the last step with
`invalid_request: client_secret is missing`, silently swallowed by the app
into a generic "Sign-in failed" toast (see `auth_service.dart` — all auth/
sync errors are caught and shown generically by design, so the real error
never surfaced without adding a temporary debug print to find it).

**Fix:** always pass all three dart-defines when building macOS:
```bash
flutter build macos --release \
  --dart-define=CRMS_APP_KEY="$CRMS_APP_KEY" \
  --dart-define=CRMS_GOOGLE_CLIENT_ID="$CRMS_GOOGLE_CLIENT_ID" \
  --dart-define=CRMS_GOOGLE_CLIENT_SECRET="$CRMS_GOOGLE_CLIENT_SECRET"
```
All three values are in `crms.env` (gitignored, same secrets used server-side).
**Nothing to pull from git for this fix** — just remember all three defines
next time anyone builds macOS. Windows/Linux build scripts already pass all
three correctly (only the manual macOS `flutter build` command was missing one).

## 3. Sync silently pushed nothing — stale local marker (device-local, not a code bug)
On a device that had synced successfully before today's earlier
"delete junk data" server cleanup, the local pref
`central_last_upload_millis` (SharedPreferences / macOS `NSUserDefaults`,
domain `com.mhpolice.crms`) still pointed at an old timestamp. Since
`exportForCentral(since: since)` only exports records touched after that
marker, and nothing local had changed, it correctly-by-its-own-logic
exported **zero** records every time — matching exactly what a full server
wipe + an untouched local dataset looks like. Fixed by clearing that one
key for the affected device:
```bash
defaults delete com.mhpolice.crms flutter.central_last_upload_millis
```
**Any other station device that had ever completed a sync before the
server-side "delete junk data" cleanup will have the same stale marker**
and will also silently export nothing until this key is cleared on that
device too. Worth checking if other stations report "sync says it worked
but the portal doesn't show their FIRs."

## 4. CRITICAL — restoring a local backup + syncing was deleting the restored data
This was live data-loss, not a build issue. Server DB `central_suppressed`
(the tombstone table — a list of record UIDs an admin deleted, so a
station's sync doesn't silently re-upload something intentionally removed)
had **50,266 stale tombstones**, left over from the earlier "delete junk
data" cleanup (which went through the normal delete path and tombstoned
every UID it touched — including real UIDs like this account's own
13,431). `uploadNow()` always does a **full** tombstone pull on manual
sync, then deletes any local record matching a tombstoned UID
(`purgeLocalByUids`). So: restore an old local backup → click Sync → the
huge stale tombstone list matches most of the restored records → they get
deleted again immediately.

**Fix applied directly on the production Postgres DB (VM: `crms-vm`):**
```sql
DELETE FROM central_suppressed;  -- was 50,266 rows, now 0
```
This is safe: worst case, a record an admin *genuinely* deleted in the
past could reappear if some station still has an old local copy and
syncs — a minor cleanup annoyance, not data loss. The alternative
(leaving it) was actively destroying restored backups.
**No code change** — this was corrupted/stale server data, not a bug in
the tombstone mechanism itself. If a similar bulk "delete junk data" pass
is ever done again, do it as a raw SQL `DELETE FROM central_crimes` that
does **not** go through the tombstone-creating path, or clear
`central_suppressed` again afterward.

## 5. DMG builds today
Final, verified build: `installer/macos/output/CRMS-1.13.3.dmg`
(unsigned/unnotarized — Gatekeeper will show "unidentified developer";
right-click → Open on first launch. Notarizing needs an Apple Developer ID
cert, not yet available).

Contains: real Google Sign-In (all 3 dart-defines), correct CRMS app icon,
points at the production server
(`https://crms-server.tailcbd550.ts.net:8443/api`). Verified end-to-end:
sign-in completed with a real Google account, local data (7,062 FIRs)
confirmed present, sync confirmed reaching the server after fixes #3 and #4.

## What's actually in git
Only the 7 icon PNGs (section 1) are a real source change — committed and
pushed on `main`. Everything else today (#2, #3, #4) was build-time
configuration or direct production-database fixes, nothing to pull.

## Still open
- DMG is unsigned/unnotarized — needs an Apple Developer ID cert to fix
  Gatekeeper's "unidentified developer" warning.
- Should proactively check other station devices for the stale
  `central_last_upload_millis` marker (#3) — they may be silently
  reporting "synced" while pushing zero records.
