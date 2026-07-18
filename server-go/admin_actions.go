package main

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"regexp"
	"strconv"
	"strings"

	"github.com/jackc/pgx/v5/pgconn"
)

// Write actions for the admin panel: user approval, FIR deletion/restore, org
// edits, data-health tools and release publishing. All POST + admin cookie.

func (a *App) registerAdminActions(mux *http.ServeMux) {
	mux.HandleFunc("POST /admin/user/status", a.adminAuth(a.actUserStatus))
	mux.HandleFunc("POST /admin/user/role", a.adminAuth(a.actUserRole))
	mux.HandleFunc("POST /admin/user/reset_device", a.adminAuth(a.actUserResetDevice))
	mux.HandleFunc("POST /admin/fir/delete", a.adminAuth(a.actFirDelete))
	mux.HandleFunc("POST /admin/fir/delete_bulk", a.adminAuth(a.actFirDeleteBulk))
	mux.HandleFunc("POST /admin/trash/restore", a.adminAuth(a.actTrashRestore))
	mux.HandleFunc("POST /admin/trash/restore_bulk", a.adminAuth(a.actTrashRestoreBulk))
	mux.HandleFunc("POST /admin/trash/purge", a.adminAuth(a.actTrashPurge))
	mux.HandleFunc("POST /admin/suppressed/clear", a.adminAuth(a.actSuppressedClear))
	mux.HandleFunc("POST /admin/org/station", a.adminAuth(a.actStationSave))
	mux.HandleFunc("POST /admin/org/unlinked/delete", a.adminAuth(a.actUnlinkedDelete))
	mux.HandleFunc("POST /admin/org/station/add", a.adminAuth(a.actStationAdd))
	mux.HandleFunc("POST /admin/health/relink", a.adminAuth(a.actRelink))
	mux.HandleFunc("POST /admin/health/dedupe", a.adminAuth(a.actDedupe))
	mux.HandleFunc("POST /admin/release/upload", a.adminAuth(a.actReleaseUpload))
}

func back(w http.ResponseWriter, r *http.Request, fallback, msg string) {
	to := r.Header.Get("Referer")
	if to == "" {
		to = fallback
	}
	u, err := url.Parse(to)
	if err != nil {
		u, _ = url.Parse(fallback)
	}
	q := u.Query()
	q.Set("msg", msg)
	u.RawQuery = q.Encode()
	http.Redirect(w, r, u.String(), http.StatusFound)
}

// --- Users -------------------------------------------------------------------

func (a *App) actUserStatus(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	email := strings.ToLower(strings.TrimSpace(r.PostFormValue("email")))
	status := r.PostFormValue("status")
	if email == "" || (status != "approved" && status != "denied" && status != "pending") {
		back(w, r, "/admin/users", "Invalid request")
		return
	}
	_, err := a.db.Exec(r.Context(), `
		UPDATE access_users SET status = $1, decided_at = now() WHERE email = $2`,
		status, email)
	if err != nil {
		back(w, r, "/admin/users", "Error: "+err.Error())
		return
	}
	back(w, r, "/admin/users", email+" → "+status)
}

func (a *App) actUserRole(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	email := strings.ToLower(strings.TrimSpace(r.PostFormValue("email")))
	role := r.PostFormValue("role")
	if email == "" ||
		(role != "station" && role != "acp" && role != "dcp" && role != "cp" && role != "hq") {
		back(w, r, "/admin/users", "Invalid request")
		return
	}
	// One dropdown carries the whole scope as "z:1" / "d:2" / "s:3" ("" = none),
	// so a user can never end up with a zone AND a station at once.
	var zone, division, station any
	kind, idStr, ok := strings.Cut(r.PostFormValue("scope"), ":")
	if id, err := strconv.ParseInt(idStr, 10, 64); ok && err == nil && id > 0 {
		switch kind {
		case "z":
			zone = id
		case "d":
			division = id
		case "s":
			station = id
		}
	}
	// Keep only the scope the role can actually use; CP/HQ are force-cleared
	// because they already see everything.
	switch role {
	case "dcp":
		division, station = nil, nil
	case "acp":
		zone, station = nil, nil
	case "station":
		zone, division = nil, nil
	default: // cp, hq
		zone, division, station = nil, nil, nil
	}
	_, err := a.db.Exec(r.Context(), `
		UPDATE access_users
		   SET role = $1, scope_zone_id = $2, scope_division_id = $3, scope_station_id = $4
		 WHERE email = $5`, role, zone, division, station, email)
	if err != nil {
		back(w, r, "/admin/users", "Error: "+err.Error())
		return
	}
	back(w, r, "/admin/users", email+" role → "+role)
}

func (a *App) actUserResetDevice(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	email := strings.ToLower(strings.TrimSpace(r.PostFormValue("email")))
	_, err := a.db.Exec(r.Context(),
		`UPDATE access_users SET hwid = NULL WHERE email = $1`, email)
	if err != nil {
		back(w, r, "/admin/users", "Error: "+err.Error())
		return
	}
	back(w, r, "/admin/users", "Device reset for "+email+" — next PC that signs in will be bound")
}

// --- FIRs --------------------------------------------------------------------

// softDeleteCrime moves one FIR to the recycle bin, writes the suppression
// tombstone (so the station's next sync doesn't re-create it) and removes it.
func (a *App) softDeleteCrime(ctx context.Context, id int64, reason string) error {
	tx, err := a.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)
	var owner, uid string
	if err := tx.QueryRow(ctx,
		`SELECT owner_email, remote_uid FROM central_crimes WHERE id = $1`, id,
	).Scan(&owner, &uid); err != nil {
		return err
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO central_trash
			(owner_email, remote_uid, station_id, station_name, fir_no, year,
			 crime_type, section, status, date_occurred, date_registered,
			 data_json, src_device, src_platform, src_os, src_ip, deleted_by)
		SELECT owner_email, remote_uid, station_id, station_name, fir_no, year,
		       crime_type, section, status, date_occurred, date_registered,
		       data_json, src_device, src_platform, src_os, src_ip, $1
		  FROM central_crimes WHERE id = $2`, reason, id); err != nil {
		return err
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO central_suppressed (owner_email, remote_uid)
		VALUES ($1, $2) ON CONFLICT DO NOTHING`, owner, uid); err != nil {
		return err
	}
	if _, err := tx.Exec(ctx, `DELETE FROM central_crimes WHERE id = $1`, id); err != nil {
		return err
	}
	return tx.Commit(ctx)
}

func (a *App) actFirDelete(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	id, _ := strconv.ParseInt(r.PostFormValue("id"), 10, 64)
	if err := a.softDeleteCrime(r.Context(), id, "Admin panel"); err != nil {
		back(w, r, "/admin/firs", "Error: "+err.Error())
		return
	}
	back(w, r, "/admin/firs", "FIR moved to the recycle bin")
}

// restoreTrash puts one recycle-bin row back into central_crimes and clears
// its suppression tombstone, so the station's copy stops being deleted.
func (a *App) restoreTrash(ctx context.Context, id int64) error {
	tx, err := a.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)
	var owner, uid string
	if err := tx.QueryRow(ctx,
		`SELECT owner_email, remote_uid FROM central_trash WHERE id = $1`, id,
	).Scan(&owner, &uid); err != nil {
		return err
	}
	if _, err = tx.Exec(ctx, `
		INSERT INTO central_crimes
			(owner_email, remote_uid, station_id, station_name, fir_no, year,
			 crime_type, section, status, date_occurred, date_registered,
			 data_json, src_device, src_platform, src_os, src_ip)
		SELECT owner_email, remote_uid, station_id, station_name, fir_no, year,
		       crime_type, section, status, date_occurred, date_registered,
		       data_json, src_device, src_platform, src_os, src_ip
		  FROM central_trash WHERE id = $1
		ON CONFLICT (owner_email, remote_uid) DO NOTHING`, id); err != nil {
		return err
	}
	if _, err = tx.Exec(ctx, `
		DELETE FROM central_suppressed WHERE owner_email = $1 AND remote_uid = $2`,
		owner, uid); err != nil {
		return err
	}
	if _, err = tx.Exec(ctx, `DELETE FROM central_trash WHERE id = $1`, id); err != nil {
		return err
	}
	return tx.Commit(ctx)
}

func (a *App) actTrashRestore(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	id, _ := strconv.ParseInt(r.PostFormValue("id"), 10, 64)
	if err := a.restoreTrash(r.Context(), id); err != nil {
		back(w, r, "/admin/trash", "Error: "+err.Error())
		return
	}
	back(w, r, "/admin/trash", "FIR restored")
}

// formIDs reads the checked-row ids ("ids" checkboxes) from a bulk form.
func formIDs(r *http.Request) []int64 {
	out := []int64{}
	for _, s := range r.PostForm["ids"] {
		if id, err := strconv.ParseInt(s, 10, 64); err == nil && id > 0 {
			out = append(out, id)
		}
	}
	return out
}

// actFirDeleteBulk moves the selected FIRs — or, with all=1, every FIR
// matching the current search filter — to the recycle bin.
func (a *App) actFirDeleteBulk(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	ctx := r.Context()
	ids := formIDs(r)
	if r.PostFormValue("all") == "1" {
		// Rebuild the same filter as the FIRs page from the hidden fields.
		where := []string{"TRUE"}
		args := []any{}
		if q := strings.TrimSpace(r.PostFormValue("q")); q != "" {
			like := "%" + q + "%"
			where = append(where, fmt.Sprintf(
				`(c.fir_no ILIKE $%d OR c.section ILIKE $%d OR c.crime_type ILIKE $%d
				  OR c.station_name ILIKE $%d OR s.name ILIKE $%d OR s.name_mr ILIKE $%d
				  OR c.owner_email ILIKE $%d)`,
				len(args)+1, len(args)+2, len(args)+3, len(args)+4, len(args)+5,
				len(args)+6, len(args)+7))
			args = append(args, like, like, like, like, like, like, like)
		}
		if y, err := strconv.Atoi(r.PostFormValue("year")); err == nil && y > 0 {
			where = append(where, fmt.Sprintf("c.year = $%d", len(args)+1))
			args = append(args, y)
		}
		if st := strings.TrimSpace(r.PostFormValue("status")); st != "" {
			where = append(where, fmt.Sprintf("c.status = $%d", len(args)+1))
			args = append(args, st)
		}
		var err error
		ids, err = a.collectIDs(ctx, `
			SELECT c.id FROM central_crimes c LEFT JOIN org_stations s ON c.station_id = s.id
			 WHERE `+strings.Join(where, " AND "), args...)
		if err != nil {
			back(w, r, "/admin/firs", "Error: "+err.Error())
			return
		}
		// Type-to-confirm guard for the button that once wiped 35k records:
		// the page embeds the match count it displayed; refuse when the live
		// match count differs (new uploads, changed filter, stale tab).
		if exp, err := strconv.Atoi(r.PostFormValue("expected")); err != nil || exp != len(ids) {
			back(w, r, "/admin/firs", fmt.Sprintf(
				"Nothing deleted: this search now matches %d FIRs but the page showed %q. Refresh and try again.",
				len(ids), r.PostFormValue("expected")))
			return
		}
	}
	n := 0
	for _, id := range ids {
		if a.softDeleteCrime(ctx, id, "Admin panel (bulk)") == nil {
			n++
		}
	}
	back(w, r, "/admin/firs", fmt.Sprintf("%d FIRs moved to the recycle bin", n))
}

// actTrashRestoreBulk restores the selected recycle-bin rows (all=1: all).
func (a *App) actTrashRestoreBulk(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	ctx := r.Context()
	ids := formIDs(r)
	if r.PostFormValue("all") == "1" {
		var err error
		ids, err = a.collectIDs(ctx, `SELECT id FROM central_trash ORDER BY id`)
		if err != nil {
			back(w, r, "/admin/trash", "Error: "+err.Error())
			return
		}
	}
	n := 0
	for _, id := range ids {
		if a.restoreTrash(ctx, id) == nil {
			n++
		}
	}
	back(w, r, "/admin/trash", fmt.Sprintf("%d FIRs restored", n))
}

// actTrashPurge permanently deletes the selected recycle-bin rows (all=1:
// empties the bin). Suppression tombstones stay, so a purged FIR does not
// come back from a station's next sync.
func (a *App) actTrashPurge(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	ctx := r.Context()
	var (
		tag pgconn.CommandTag
		err error
	)
	if r.PostFormValue("all") == "1" {
		tag, err = a.db.Exec(ctx, `DELETE FROM central_trash`)
	} else {
		ids := formIDs(r)
		if len(ids) == 0 {
			back(w, r, "/admin/trash", "Nothing selected")
			return
		}
		tag, err = a.db.Exec(ctx, `DELETE FROM central_trash WHERE id = ANY($1)`, ids)
	}
	if err != nil {
		back(w, r, "/admin/trash", "Error: "+err.Error())
		return
	}
	back(w, r, "/admin/trash",
		fmt.Sprintf("%d FIRs permanently deleted from the recycle bin", tag.RowsAffected()))
}

// actUnlinkedDelete moves every station-less FIR carrying the given uploaded
// name ("(blank)" = no name at all) to the recycle bin — the cleanup button on
// the Organization page's "not linked to any station" list.
func (a *App) actUnlinkedDelete(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	ctx := r.Context()
	name := strings.TrimSpace(r.PostFormValue("name"))
	var (
		ids []int64
		err error
	)
	if name == "" || name == "(blank)" {
		ids, err = a.collectIDs(ctx, `
			SELECT id FROM central_crimes
			 WHERE station_id IS NULL AND COALESCE(station_name, '') = ''`)
	} else {
		ids, err = a.collectIDs(ctx, `
			SELECT id FROM central_crimes
			 WHERE station_id IS NULL AND station_name = $1`, name)
	}
	if err != nil {
		back(w, r, "/admin/org", "Error: "+err.Error())
		return
	}
	n := 0
	for _, id := range ids {
		if a.softDeleteCrime(ctx, id, "Admin panel (unlinked cleanup)") == nil {
			n++
		}
	}
	back(w, r, "/admin/org", fmt.Sprintf("%d FIRs moved to the recycle bin", n))
}

// actSuppressedClear removes delete-markers (tombstones) so station apps may
// keep and re-upload those records — the recovery path after a server wipe or
// when a station restores an old backup and its sync trips the mass-delete
// fuse. Deletes no crime data itself. Optional owner email narrows the clear.
func (a *App) actSuppressedClear(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	email := strings.ToLower(strings.TrimSpace(r.PostFormValue("email")))
	var (
		tag pgconn.CommandTag
		err error
	)
	if email == "" {
		tag, err = a.db.Exec(r.Context(), `DELETE FROM central_suppressed`)
	} else {
		tag, err = a.db.Exec(r.Context(),
			`DELETE FROM central_suppressed WHERE owner_email = $1`, email)
	}
	if err != nil {
		back(w, r, "/admin/trash", "Error: "+err.Error())
		return
	}
	back(w, r, "/admin/trash", fmt.Sprintf(
		"%d delete-markers cleared — stations can re-upload those records on their next sync",
		tag.RowsAffected()))
}

// --- Organization ------------------------------------------------------------

func (a *App) actStationSave(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	id, _ := strconv.ParseInt(r.PostFormValue("id"), 10, 64)
	nameMr := strings.TrimSpace(r.PostFormValue("name_mr"))
	code := strings.TrimSpace(r.PostFormValue("code"))
	_, err := a.db.Exec(r.Context(), `
		UPDATE org_stations SET name_mr = NULLIF($1, ''), code = NULLIF($2, '')
		 WHERE id = $3`, nameMr, code, id)
	if err != nil {
		back(w, r, "/admin/org", "Error: "+err.Error())
		return
	}
	back(w, r, "/admin/org", "Station saved — run Re-link to apply to existing FIRs")
}

func (a *App) actStationAdd(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	name := strings.TrimSpace(r.PostFormValue("name"))
	divID, _ := strconv.ParseInt(r.PostFormValue("division_id"), 10, 64)
	if name == "" {
		back(w, r, "/admin/org", "Station name required")
		return
	}
	var div any
	if divID > 0 {
		div = divID
	}
	// Mirrored org ids come from Hostinger; put locally-created ones far above
	// that range so the two can never collide.
	_, err := a.db.Exec(r.Context(), `
		INSERT INTO org_stations (id, division_id, name, name_mr, code)
		VALUES ((SELECT GREATEST(COALESCE(MAX(id), 0) + 1, 10000) FROM org_stations),
		        $1, $2, NULLIF($3, ''), NULLIF($4, ''))`,
		div, name, strings.TrimSpace(r.PostFormValue("name_mr")),
		strings.TrimSpace(r.PostFormValue("code")))
	if err != nil {
		back(w, r, "/admin/org", "Error: "+err.Error())
		return
	}
	back(w, r, "/admin/org", "Station added: "+name)
}

// --- Data health -------------------------------------------------------------

func (a *App) actRelink(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	m, err := a.stationNameMap(ctx)
	if err != nil {
		back(w, r, "/admin/org", "Error: "+err.Error())
		return
	}
	rows, err := a.db.Query(ctx, `
		SELECT id, station_name FROM central_crimes
		 WHERE station_id IS NULL AND station_name IS NOT NULL AND station_name <> ''`)
	if err != nil {
		back(w, r, "/admin/org", "Error: "+err.Error())
		return
	}
	type upd struct {
		id  int64
		sid int64
	}
	var updates []upd
	for rows.Next() {
		var id int64
		var name string
		if rows.Scan(&id, &name) == nil {
			if sid, ok := m[normStationName(name)]; ok {
				updates = append(updates, upd{id, sid})
			}
		}
	}
	rows.Close()
	for _, u := range updates {
		_, _ = a.db.Exec(ctx,
			`UPDATE central_crimes SET station_id = $1 WHERE id = $2`, u.sid, u.id)
	}
	back(w, r, "/admin/org", fmt.Sprintf("Re-link done: %d FIRs linked", len(updates)))
}

func (a *App) actDedupe(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	rows, err := a.db.Query(ctx, `
		SELECT id, owner_email, fir_no, year, station_name FROM central_crimes
		 WHERE fir_no IS NOT NULL AND fir_no <> '' ORDER BY id DESC`)
	if err != nil {
		back(w, r, "/admin/org", "Error: "+err.Error())
		return
	}
	seen := map[string]bool{}
	var dupes []int64
	for rows.Next() {
		var id int64
		var owner, fir string
		var year *int
		var station *string
		if rows.Scan(&id, &owner, &fir, &year, &station) != nil {
			continue
		}
		st := ""
		if station != nil {
			st = *station
		}
		y := 0
		if year != nil {
			y = *year
		}
		key := fmt.Sprintf("%s|%s|%s|%d",
			strings.ToLower(owner), normStationName(st), normStationName(fir), y)
		if seen[key] {
			dupes = append(dupes, id)
		} else {
			seen[key] = true
		}
	}
	rows.Close()
	for _, id := range dupes {
		_ = a.softDeleteCrime(ctx, id, "Admin panel (duplicate)")
	}
	back(w, r, "/admin/org", fmt.Sprintf("Removed %d duplicates (kept the newest copy of each)", len(dupes)))
}

// --- Releases ----------------------------------------------------------------

var releaseNameRe = regexp.MustCompile(`^[\w.\- ]+\.(exe|dmg|pkg|AppImage|deb)$`)
var releaseVerRe = regexp.MustCompile(`(\d+)\.(\d+)\.(\d+)`)

// versionToBuild maps "1.14.1" to a single comparable integer
// (major*1_000_000 + minor*1_000 + patch), identical to the app's
// UpdateService.versionToBuild in lib/features/update/update_service.dart —
// both sides must agree on ordering or update checks silently stall.
func versionToBuild(version string) int {
	parts := strings.FieldsFunc(version, func(r rune) bool {
		return r == '.' || r == '+' || r == '-'
	})
	at := func(i int) int {
		if i >= len(parts) {
			return 0
		}
		n, err := strconv.Atoi(strings.TrimSpace(parts[i]))
		if err != nil {
			return 0
		}
		return n
	}
	clamp := func(v, max int) int {
		if v < 0 {
			return 0
		}
		if v > max {
			return max
		}
		return v
	}
	return clamp(at(0), 2000)*1000000 + clamp(at(1), 999)*1000 + clamp(at(2), 999)
}

func (a *App) actReleaseUpload(w http.ResponseWriter, r *http.Request) {
	if err := r.ParseMultipartForm(512 << 20); err != nil {
		back(w, r, "/admin/releases", "Upload error: "+err.Error())
		return
	}
	file, hdr, err := r.FormFile("file")
	if err != nil {
		back(w, r, "/admin/releases", "Pick an installer file")
		return
	}
	defer file.Close()
	name := filepath.Base(hdr.Filename)
	if !releaseNameRe.MatchString(name) {
		back(w, r, "/admin/releases", "Only .exe / .dmg / .pkg / .AppImage / .deb files")
		return
	}
	ver := releaseVerRe.FindString(name)
	if ver == "" {
		back(w, r, "/admin/releases", "File name must contain a version like crms-setup-1.13.0.exe")
		return
	}
	platform := map[string]string{
		".exe": "windows", ".dmg": "macos", ".pkg": "macos",
		".AppImage": "linux", ".deb": "linux",
	}[filepath.Ext(name)]

	dir := os.Getenv("RELEASES_DIR")
	if dir == "" {
		dir = "/data/releases"
	}
	_ = os.MkdirAll(dir, 0o755)
	dst, err := os.Create(filepath.Join(dir, name))
	if err != nil {
		back(w, r, "/admin/releases", "Save error: "+err.Error())
		return
	}
	h := sha256.New()
	if _, err := io.Copy(io.MultiWriter(dst, h), file); err != nil {
		dst.Close()
		back(w, r, "/admin/releases", "Save error: "+err.Error())
		return
	}
	dst.Close()

	// The build MUST be derived from the version, in lock-step with the app's
	// UpdateService.versionToBuild (major*1e6 + minor*1e3 + patch): the app
	// compares its own version-derived number against this one. A sequential
	// counter only worked by coincidence during 1.13.x and stalled every app
	// the moment it reached 1.14.0 (its 1014000 outran the counter's 1013005).
	build := versionToBuild(ver)
	_, err = a.db.Exec(r.Context(), `
		INSERT INTO app_release (version, build, platform, file_name, notes, mandatory, sha256)
		VALUES ($1, $2, $3, $4, NULLIF($5, ''), $6, $7)`,
		ver, build, platform, name,
		strings.TrimSpace(r.PostFormValue("notes")),
		r.PostFormValue("mandatory") == "on",
		hex.EncodeToString(h.Sum(nil)))
	if err != nil {
		back(w, r, "/admin/releases", "DB error: "+err.Error())
		return
	}
	back(w, r, "/admin/releases",
		fmt.Sprintf("Published %s (build %d, %s) — apps will pick it up on next launch", ver, build, platform))
}
