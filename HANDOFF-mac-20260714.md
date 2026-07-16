# Mac session handoff — 2026-07-14 (for the Windows Claude)

Everything changed on the Mac today. No secrets in this file — passwords/keys
are in the Windows machine's own `HANDOFF-server.md` (note: the Mac's copy of
that file has newer edits; the important ones are repeated here).

## ⚠️ FIRST: infrastructure changed — update your notes

- **Office LAN renumbered 192.168.0.x → 192.168.1.x on 2026-07-14.**
  - Proxmox host: `192.168.1.200` (was .0.200)
  - VM "crms-server": `192.168.1.94` (was .0.94) — fix your SSH command:
    `ssh -i ~/.ssh/crms_vm bharat@192.168.1.94`
  - The VM's netplan was updated (old file backed up in the VM at
    `/root/netplan-backup-20260714.yaml`). Tailscale unchanged:
    `crms-server.tailcbd550.ts.net` (100.85.228.79).
- Public API (unchanged): `https://crms-server.tailcbd550.ts.net:8443/api`
- Proxmox pending items are DONE: VM 100 has `onboot 1`; weekly vzdump backup
  job exists & enabled (Sun 02:00, snapshot, zstd, keep 3).
- The Mac now has its own SSH key (`~/.ssh/crms_vm` on the Mac, different from
  the Windows key) with access to the VM and root on the Proxmox host.

## App version

`pubspec.yaml`: **1.13.0+31 → 1.13.2+33**. The Windows exe for **1.13.2**
still needs to be built (on the Windows PC) and published on BOTH panels as
mandatory (old-version stations still check Hostinger's version.php).

## What was built today (3 features + performance)

### 1. Station-scoped users
Admin assigns a police station to a user (panel → Users → role `station` +
station dropdown, which already existed). Now it actually does something:
- Server portal endpoints accept station-role users WITH a station and scope
  them to exactly that station (verified: they see only their station's FIRs,
  requesting another station returns 0, unscoped station users still 403).
- App: crime-entry "Police station" field is pinned + read-only when assigned
  (from check.php `scope.station`); new sidebar item **"Station FIRs"** shows
  ALL central FIRs of their station (read-only reuse of the portal search).

### 2. HQ role (`hq`)
"HQ — all stations (entry + view)" in the panel role dropdown:
- Data entry for ANY station (entry field stays free) + full-city officer
  portal inside the station app (sidebar "Officer Portal" → PortalShell).
- Zero admin-panel powers (panel password remains the only way to
  delete/edit/restore/publish).
- **bharatsonawane601@gmail.com is now role `hq` in the DB** (168/260 stay cp).

### 3. Admin panel additions (all server-side, already live)
- **/admin/analytics** — year+station filters; KPI cards (detection rate,
  chargesheeted, arrested, wanted, recovered ₹); year & month trends; top
  crime types; station league table; data-quality counts.
- **Bulk FIR actions** — FIRs page: row checkboxes, "Delete selected",
  "Delete ALL <n> matching" (current filter). Recycle bin: "Restore
  selected/ALL", "Delete selected forever", "Clear recycle bin". Purge keeps
  suppression tombstones so purged FIRs can't come back from a station sync.

### 4. Sync performance (the "3000 FIRs = 15 min" complaint)
- App `purgeLocalByUids`: was one SQLite transaction PER ROW (+1 audit insert
  each) → now ONE transaction, chunked `IN` statements, batched audit rows.
  This was the 15-minute delete; now seconds.
- App upload: chunks 300 → 1000, timeout 60s → 180s, and the body is now
  **gzip-compressed** (`Content-Encoding: gzip`, ~75× smaller).
- App tombstone poll (90s timer): now incremental (`since` param); the
  launch/manual "Sync data" still pulls the full list as a correctness anchor.
- Server upload: per-record `Exec` loop → one pipelined `pgx.Batch`
  (measured: 3,000 records in 0.49s through the funnel).
- Server `suppressed.php`: accepts optional `since`.
- Server `jsonBody`: transparently gunzips gzipped request bodies.
- nginx: gzip for JSON/HTML responses (portal_rows measured 3.4MB → 85KB).
- New tombstone **janitor** (hourly, prunes tombstones older than the owner's
  last check-in) — gated: only runs when `MIRROR_BASE_URL` is empty, because
  the Hostinger mirror re-imports pruned tombstones (found the hard way).

## Exact files changed today

### Flutter app (lib/ + assets)
| File | Change |
|---|---|
| `pubspec.yaml` | version 1.13.2+33 |
| `lib/features/access/access_client.dart` | `OfficerRole` + `hq`; `_roleFrom` parses 'hq' |
| `lib/features/crime_entry/tabs.dart` | `CrimeInfoTab` → ConsumerWidget; station field pinned/read-only when access scope has a station; forces `d.policeStation = assigned` |
| `lib/features/app_shell.dart` | sidebar items: "Station FIRs" (when station assigned), "Officer Portal" (when role hq); watches accessControllerProvider |
| `lib/features/portal/station_firs_screen.dart` | NEW — station-wide FIR view (wraps PortalSearchView) |
| `lib/features/portal/portal_shell.dart` | `_PortalSearch` renamed public `PortalSearchView` (reused by the new screen); `_roleLabel` handles hq |
| `lib/features/portal/central_client.dart` | upload gzips body + 180s timeout; `fetchSuppressed(since:)` |
| `lib/features/portal/central_upload_controller.dart` | chunk 1000; incremental tombstone poll w/ `central_last_suppressed_millis` pref (10-min overlap); full pull on launch/manual sync |
| `lib/features/crime_entry/crime_repository.dart` | `purgeLocalByUids` rewritten: one transaction, 500-id chunks, batched audit inserts |
| `assets/translations/en.json` / `mr.json` | added `nav.stationFirs` (ठाणे गुन्हे), `nav.officerPortal` (अधिकारी पोर्टल), `crime.info.stationLocked` |
| `macos/Podfile` + `macos/Runner.xcodeproj/project.pbxproj` | macOS deployment target 10.15 → 11.0 (speech_to_text requires it; Mac-only, no Windows impact) |

### Go server (server-go/) — ALL DEPLOYED to the VM already
| File | Change |
|---|---|
| `db.go` | `baseStationIDs`: station role → its one station; cp+hq → nil (all); `jsonBody` gunzips gzip request bodies |
| `handlers_portal.go` | `portalUser` allows hq + station-with-scope; `handlePortalScope` cases for hq (full city) and station (single station) |
| `handlers_sync.go` | upload upserts via `pgx.Batch`; `suppressed.php` optional `since` |
| `admin.go` | nav + route + template for /admin/analytics; hq in role dropdown; bulk-action UI on FIRs + Recycle bin pages; bar/scroll CSS |
| `admin_actions.go` | role validation + hq; NEW: `/admin/fir/delete_bulk`, `/admin/trash/restore_bulk`, `/admin/trash/purge`; `restoreTrash` helper extracted |
| `admin_analytics.go` | NEW — analytics page handler (one-scan aggregation) |
| `janitor.go` | NEW — hourly tombstone pruner |
| `main.go` | starts janitor only when MIRROR_BASE_URL is empty |
| `Dockerfile` | `GOSUMDB=off` + cached `go mod download` layer (office network resets sum.golang.org connections; there is no go.sum) |
| `deploy/nginx-default.conf` | gzip on for JSON/HTML (also applied to `/opt/crms/nginx/default.conf` on the VM + nginx restarted) |

### Server DB state changes (already applied on the VM)
- `bharatsonawane601@gmail.com` → role `hq`.
- Junk station `hffdffh` (id 4807, 0 FIRs) deleted from org_stations.
- chhavni alias: already fixed earlier (code=chhavni on Chhavani, 0 unlinked).
- Note: panel dedupe at 13:33 UTC binned 340 Daulatabad FIRs (restorable).
  Live FIRs: 5,261. Recycle bin ~5k rows — purge is the user's call.

## What the Windows session must do

1. **Get this code.** Nothing from today is committed to git (146 modified
   files include older uncommitted work too). Either commit+push from the Mac
   first (preferred — ask Bharat), or copy the files in the tables above.
2. **Build Windows 1.13.2**: usual `flutter build windows --release` with the
   dart-defines from `crms.env` **plus**
   `--dart-define=CRMS_API_BASE_URL=https://crms-server.tailcbd550.ts.net:8443/api`,
   then Inno Setup → `crms-setup-1.13.2.exe`.
3. **Publish 1.13.2 mandatory on BOTH panels** (new + Hostinger — two stations
   are still on old versions and only see Hostinger).
4. Do NOT deploy server-go from stale Windows copies — the VM already runs
   today's newer code; pull it from the Mac/git first.

## Open items / rollout state
- Cutover blocked: `f6722422` on app 1.12.8, `dyashoda77` on 1.3.3,
  `ashvinisonawane2004` never signed in. When ALL show 1.13.x: clear
  `MIRROR_BASE_URL` in `/opt/crms/.env`, `docker compose up -d api`
  (janitor then activates automatically).
- macOS DMG 1.13.2 built at `installer/macos/output/CRMS-1.13.2.dmg`
  (adhoc-signed; right-click → Open).
- Optional later: Tailscale on the Windows dev PC (260 account) for direct
  LAN-speed sync; recycle-bin purge; response `since` for portal_rows.
