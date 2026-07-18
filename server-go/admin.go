package main

import (
	"crypto/hmac"
	"crypto/sha256"
	"crypto/subtle"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"html/template"
	"net/http"
	"strconv"
	"strings"
	"time"
)

// The self-hosted admin panel. Tailnet-only (nginx never exposes /admin on the
// public port). All times shown to the admin are IST (Asia/Kolkata).

const adminCookie = "crms_admin"

func (a *App) registerAdmin(mux *http.ServeMux) {
	mux.HandleFunc("GET /admin/{$}", func(w http.ResponseWriter, r *http.Request) {
		http.Redirect(w, r, "/admin", http.StatusMovedPermanently)
	})
	mux.HandleFunc("GET /admin/login", a.adminLoginPage)
	mux.HandleFunc("POST /admin/login", a.adminLoginSubmit)
	mux.HandleFunc("GET /admin/logout", func(w http.ResponseWriter, r *http.Request) {
		http.SetCookie(w, &http.Cookie{Name: adminCookie, Value: "", Path: "/", MaxAge: -1})
		http.Redirect(w, r, "/admin/login", http.StatusFound)
	})
	mux.HandleFunc("GET /admin", a.adminAuth(a.adminDashboard))
	mux.HandleFunc("GET /admin/analytics", a.adminAuth(a.adminAnalytics))
	mux.HandleFunc("GET /admin/firs", a.adminAuth(a.adminFirs))
	mux.HandleFunc("GET /admin/fir", a.adminAuth(a.adminFirDetail))
	mux.HandleFunc("GET /admin/users", a.adminAuth(a.adminUsers))
	mux.HandleFunc("GET /admin/org", a.adminAuth(a.adminOrg))
	mux.HandleFunc("GET /admin/trash", a.adminAuth(a.adminTrash))
	mux.HandleFunc("GET /admin/deletions", a.adminAuth(a.adminDeletions))
	mux.HandleFunc("GET /admin/releases", a.adminAuth(a.adminReleases))
	mux.HandleFunc("GET /admin/messages", a.adminAuth(a.adminMessages))
	a.registerAdminActions(mux)
}

// --- Auth: password -> HMAC-signed expiring cookie ---------------------------

func (a *App) adminSign(exp int64) string {
	mac := hmac.New(sha256.New, []byte(a.cfg.AppKey))
	fmt.Fprintf(mac, "admin|%d", exp)
	return fmt.Sprintf("%d.%s", exp, hex.EncodeToString(mac.Sum(nil)))
}

func (a *App) adminCookieValid(v string) bool {
	parts := strings.SplitN(v, ".", 2)
	if len(parts) != 2 {
		return false
	}
	exp, err := strconv.ParseInt(parts[0], 10, 64)
	if err != nil || time.Now().Unix() > exp {
		return false
	}
	return subtle.ConstantTimeCompare([]byte(a.adminSign(exp)), []byte(v)) == 1
}

func (a *App) adminAuth(h http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		if a.cfg.AdminPassword == "" {
			http.Error(w, "admin panel disabled: ADMIN_PASSWORD not set", http.StatusServiceUnavailable)
			return
		}
		c, err := r.Cookie(adminCookie)
		if err != nil || !a.adminCookieValid(c.Value) {
			http.Redirect(w, r, "/admin/login", http.StatusFound)
			return
		}
		h(w, r)
	}
}

func (a *App) adminLoginPage(w http.ResponseWriter, r *http.Request) {
	renderAdmin(w, "login", adminPage{Title: "Login"})
}

func (a *App) adminLoginSubmit(w http.ResponseWriter, r *http.Request) {
	_ = r.ParseForm()
	pw := r.PostFormValue("password")
	if a.cfg.AdminPassword == "" ||
		subtle.ConstantTimeCompare([]byte(pw), []byte(a.cfg.AdminPassword)) != 1 {
		time.Sleep(time.Second) // slow brute force a little
		renderAdmin(w, "login", adminPage{Title: "Login", Error: "Wrong password"})
		return
	}
	exp := time.Now().Add(12 * time.Hour).Unix()
	http.SetCookie(w, &http.Cookie{
		Name: adminCookie, Value: a.adminSign(exp), Path: "/",
		HttpOnly: true, SameSite: http.SameSiteLaxMode, Secure: true, MaxAge: 12 * 3600,
	})
	http.Redirect(w, r, "/admin", http.StatusFound)
}

// --- Shared page model -------------------------------------------------------

type adminPage struct {
	Title      string
	Active     string
	MirrorMode bool
	LastSync   string
	Now        string
	Error      string
	Msg        string
	Data       any
}

func (a *App) page(r *http.Request, title, active string, data any) adminPage {
	p := adminPage{
		Title: title, Active: active,
		MirrorMode: a.cfg.MirrorBaseURL != "",
		Now:        istStamp(time.Now()),
		Data:       data,
	}
	p.Msg = r.URL.Query().Get("msg")
	var last *time.Time
	_ = a.db.QueryRow(r.Context(),
		`SELECT last_sync FROM mirror_state WHERE tbl = 'central_crimes'`).Scan(&last)
	if last != nil {
		p.LastSync = istStamp(*last) + " IST"
	}
	return p
}

// --- Dashboard ----------------------------------------------------------------

func (a *App) adminDashboard(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	d := map[string]any{}
	count := func(key, sql string) {
		var n int
		_ = a.db.QueryRow(ctx, sql).Scan(&n)
		d[key] = n
	}
	count("Total", `SELECT COUNT(*) FROM central_crimes`)
	count("Detected", `SELECT COUNT(*) FROM central_crimes WHERE status = 'detected'`)
	count("Undetected", `SELECT COUNT(*) FROM central_crimes WHERE status IS DISTINCT FROM 'detected'`)
	count("Unlinked", `SELECT COUNT(*) FROM central_crimes WHERE station_id IS NULL`)
	count("Users", `SELECT COUNT(*) FROM access_users`)
	count("Pending", `SELECT COUNT(*) FROM access_users WHERE status = 'pending'`)
	count("Trash", `SELECT COUNT(*) FROM central_trash`)

	type row struct {
		Name                        string
		Total, Detected, Undetected int
	}
	var zones, stations []row
	zr, err := a.db.Query(ctx, `
		SELECT z.name, COUNT(c.id),
		       COUNT(c.id) FILTER (WHERE c.status = 'detected'),
		       COUNT(c.id) FILTER (WHERE c.status IS DISTINCT FROM 'detected')
		  FROM org_zones z
		  LEFT JOIN org_divisions d ON d.zone_id = z.id
		  LEFT JOIN org_stations s ON s.division_id = d.id
		  LEFT JOIN central_crimes c ON c.station_id = s.id
		 GROUP BY z.id, z.name ORDER BY z.sort, z.id`)
	if err == nil {
		for zr.Next() {
			var x row
			if zr.Scan(&x.Name, &x.Total, &x.Detected, &x.Undetected) == nil {
				zones = append(zones, x)
			}
		}
		zr.Close()
	}
	sr, err := a.db.Query(ctx, `
		SELECT COALESCE(s.name, COALESCE(NULLIF(c.station_name, ''), '(no station)')),
		       COUNT(*),
		       COUNT(*) FILTER (WHERE c.status = 'detected'),
		       COUNT(*) FILTER (WHERE c.status IS DISTINCT FROM 'detected')
		  FROM central_crimes c LEFT JOIN org_stations s ON c.station_id = s.id
		 GROUP BY 1 ORDER BY 2 DESC LIMIT 25`)
	if err == nil {
		for sr.Next() {
			var x row
			if sr.Scan(&x.Name, &x.Total, &x.Detected, &x.Undetected) == nil {
				stations = append(stations, x)
			}
		}
		sr.Close()
	}

	// Charts: zone share donut + station bars — the same data as the tables
	// beside them, never shown twice.
	// Colorblind-safe categorical order (validated for CVD separation on the
	// dark card surface) — do not reorder casually.
	palette := []string{"#3987e5", "#008300", "#d55181", "#c98500", "#199e70", "#d95926", "#9085e9", "#e66767"}
	segs := []donutSeg{}
	zoneTotal := 0
	for i, z := range zones {
		if z.Total == 0 {
			continue
		}
		segs = append(segs, donutSeg{Label: z.Name, Value: float64(z.Total), Color: palette[i%len(palette)]})
		zoneTotal += z.Total
	}
	d["ZoneChart"] = svgDonut(segs, fmt.Sprintf("%d", zoneTotal), "linked FIRs")
	stPts := []chartPoint{}
	for i, s := range stations {
		if i >= 15 {
			break
		}
		stPts = append(stPts, chartPoint{Label: s.Name, Value: float64(s.Total),
			Hint: fmt.Sprintf("%d detected", s.Detected)})
	}
	d["StationChart"] = svgHBars(stPts, "#5b8cff")

	// Live pulse: uploads that reached this server in the last 14 days (IST).
	type act struct {
		Label string
		N     int
	}
	acts := []act{}
	actPts := []chartPoint{}
	ar, err := a.db.Query(ctx, `
		SELECT (updated_at AT TIME ZONE 'Asia/Kolkata')::date AS d, COUNT(*)
		  FROM central_crimes
		 WHERE updated_at > now() - INTERVAL '14 days'
		 GROUP BY 1 ORDER BY 1`)
	if err == nil {
		for ar.Next() {
			var day time.Time
			var n int
			if ar.Scan(&day, &n) == nil {
				lbl := day.Format("02 Jan")
				acts = append(acts, act{lbl, n})
				actPts = append(actPts, chartPoint{Label: lbl, Value: float64(n)})
			}
		}
		ar.Close()
	}
	d["Activity"] = acts
	d["ActivityChart"] = svgLine(actPts, "#34d399")

	d["Zones"] = zones
	d["Stations"] = stations
	renderAdmin(w, "dashboard", a.page(r, "Dashboard", "dashboard", d))
}

// --- FIRs ----------------------------------------------------------------------

type firRow struct {
	ID         int64
	Station    string
	FirNo      string
	Year       string
	CrimeType  string
	Section    string
	Status     string
	Registered string
	Owner      string
}

func (a *App) adminFirs(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	q := strings.TrimSpace(r.URL.Query().Get("q"))
	year := strings.TrimSpace(r.URL.Query().Get("year"))
	status := strings.TrimSpace(r.URL.Query().Get("status"))
	page, _ := strconv.Atoi(r.URL.Query().Get("page"))
	if page < 1 {
		page = 1
	}
	const pageSize = 50

	where := []string{}
	args := []any{}
	if q != "" {
		like := "%" + q + "%"
		// s.name_mr included so a Marathi query still finds records whose
		// station is stored under the canonical English spelling.
		where = append(where, fmt.Sprintf(
			`(c.fir_no ILIKE $%d OR c.section ILIKE $%d OR c.crime_type ILIKE $%d
			  OR c.station_name ILIKE $%d OR s.name ILIKE $%d OR s.name_mr ILIKE $%d
			  OR c.owner_email ILIKE $%d)`,
			len(args)+1, len(args)+2, len(args)+3, len(args)+4, len(args)+5,
			len(args)+6, len(args)+7))
		args = append(args, like, like, like, like, like, like, like)
	}
	if y, err := strconv.Atoi(year); err == nil && y > 0 {
		where = append(where, fmt.Sprintf("c.year = $%d", len(args)+1))
		args = append(args, y)
	}
	if status != "" {
		where = append(where, fmt.Sprintf("c.status = $%d", len(args)+1))
		args = append(args, status)
	}
	whereSQL := ""
	if len(where) > 0 {
		whereSQL = "WHERE " + strings.Join(where, " AND ")
	}

	var total int
	_ = a.db.QueryRow(ctx, fmt.Sprintf(
		`SELECT COUNT(*) FROM central_crimes c LEFT JOIN org_stations s ON c.station_id = s.id %s`,
		whereSQL), args...).Scan(&total)

	rows, err := a.db.Query(ctx, fmt.Sprintf(`
		SELECT c.id, COALESCE(s.name, COALESCE(c.station_name, '')), COALESCE(c.fir_no, ''),
		       c.year, COALESCE(c.crime_type, ''), COALESCE(c.section, ''),
		       COALESCE(c.status, ''), c.date_registered, c.owner_email
		  FROM central_crimes c LEFT JOIN org_stations s ON c.station_id = s.id
		  %s ORDER BY c.date_registered DESC NULLS LAST, c.id DESC
		  LIMIT %d OFFSET %d`, whereSQL, pageSize, (page-1)*pageSize), args...)
	list := []firRow{}
	if err == nil {
		for rows.Next() {
			var x firRow
			var yr *int
			var reg *time.Time
			if rows.Scan(&x.ID, &x.Station, &x.FirNo, &yr, &x.CrimeType,
				&x.Section, &x.Status, &reg, &x.Owner) == nil {
				if yr != nil {
					x.Year = strconv.Itoa(*yr)
				}
				if reg != nil {
					x.Registered = reg.Format("02-01-2006")
				}
				if len(x.Section) > 60 {
					x.Section = x.Section[:60] + "…"
				}
				list = append(list, x)
			}
		}
		rows.Close()
	}
	// Brain: nothing found — suggest the closest station names / crime types
	// ("vahan chori", "चोरि", "Dolatabad" → clickable corrected searches).
	didYouMean := []string{}
	if total == 0 && q != "" {
		cands := []string{}
		cr, err := a.db.Query(ctx, `
			SELECT name FROM org_stations
			UNION SELECT COALESCE(name_mr, '') FROM org_stations
			UNION SELECT DISTINCT COALESCE(crime_type, '') FROM central_crimes`)
		if err == nil {
			for cr.Next() {
				var s string
				if cr.Scan(&s) == nil {
					cands = append(cands, s)
				}
			}
			cr.Close()
		}
		didYouMean = brainSuggestions(q, cands, 3)
	}
	renderAdmin(w, "firs", a.page(r, "FIR Search", "firs", map[string]any{
		"Rows": list, "Total": total, "Q": q, "Year": year, "Status": status,
		"Page": page, "HasPrev": page > 1, "HasNext": page*pageSize < total,
		"PrevPage": page - 1, "NextPage": page + 1, "DidYouMean": didYouMean,
	}))
}

func (a *App) adminFirDetail(w http.ResponseWriter, r *http.Request) {
	id, _ := strconv.ParseInt(r.URL.Query().Get("id"), 10, 64)
	var (
		station, firNo, crimeType, section, status, owner, srcDevice, srcIP *string
		year                                                               *int
		reg, occ                                                           *time.Time
		updated                                                            time.Time
		dataJSON                                                           []byte
	)
	err := a.db.QueryRow(r.Context(), `
		SELECT COALESCE(s.name, c.station_name), c.fir_no, c.crime_type, c.section,
		       c.status, c.owner_email, c.src_device, c.src_ip, c.year,
		       c.date_registered, c.date_occurred, c.updated_at, c.data_json
		  FROM central_crimes c LEFT JOIN org_stations s ON c.station_id = s.id
		 WHERE c.id = $1`, id,
	).Scan(&station, &firNo, &crimeType, &section, &status, &owner, &srcDevice,
		&srcIP, &year, &reg, &occ, &updated, &dataJSON)
	if err != nil {
		http.NotFound(w, r)
		return
	}
	pretty := ""
	if dataJSON != nil {
		var v any
		if json.Unmarshal(dataJSON, &v) == nil {
			b, _ := json.MarshalIndent(v, "", "  ")
			pretty = string(b)
		}
	}
	sv := func(s *string) string {
		if s == nil {
			return ""
		}
		return *s
	}
	dv := func(t *time.Time) string {
		if t == nil {
			return ""
		}
		return t.Format("02-01-2006")
	}
	yv := ""
	if year != nil {
		yv = strconv.Itoa(*year)
	}
	renderAdmin(w, "fir", a.page(r, "FIR "+sv(firNo), "firs", map[string]any{
		"ID": id, "Station": sv(station), "FirNo": sv(firNo), "Year": yv,
		"CrimeType": sv(crimeType), "Section": sv(section), "Status": sv(status),
		"Owner": sv(owner), "Device": sv(srcDevice), "IP": sv(srcIP),
		"Registered": dv(reg), "Occurred": dv(occ),
		"Updated": istStamp(updated) + " IST", "Data": pretty,
	}))
}

// --- Users ---------------------------------------------------------------------

func (a *App) adminUsers(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	type userRow struct {
		Email, Name, Status, Role, Scope string
		// ScopeKey is the single scope dropdown's value: "z:1" / "d:2" / "s:3"
		// ("" = no scope). One control instead of three, so a DCP's zone and a
		// station's station can never be set at the same time.
		ScopeKey                         string
		Device, OS, Platform, AppVer, IP string
		LastSeen                         string
	}
	type orgOpt struct {
		ID   int64
		Name string
	}
	list3 := func(sql string) []orgOpt {
		out := []orgOpt{}
		rs, err := a.db.Query(ctx, sql)
		if err != nil {
			return out
		}
		defer rs.Close()
		for rs.Next() {
			var o orgOpt
			if rs.Scan(&o.ID, &o.Name) == nil {
				out = append(out, o)
			}
		}
		return out
	}
	rows, err := a.db.Query(r.Context(), `
		SELECT u.email, COALESCE(u.name, ''), u.status, u.role,
		       COALESCE(s.name, COALESCE(d.name, COALESCE(z.name, ''))),
		       u.scope_zone_id, u.scope_division_id, u.scope_station_id,
		       COALESCE(u.client_device, ''), COALESCE(u.client_os, ''),
		       COALESCE(u.client_platform, ''), COALESCE(u.app_version, ''),
		       COALESCE(u.last_ip, ''), u.last_seen_at
		  FROM access_users u
		  LEFT JOIN org_zones z ON z.id = u.scope_zone_id
		  LEFT JOIN org_divisions d ON d.id = u.scope_division_id
		  LEFT JOIN org_stations s ON s.id = u.scope_station_id
		 ORDER BY u.status, u.email`)
	list := []userRow{}
	if err == nil {
		for rows.Next() {
			var x userRow
			var seen *time.Time
			var zoneID, divID, stID *int64
			if rows.Scan(&x.Email, &x.Name, &x.Status, &x.Role, &x.Scope,
				&zoneID, &divID, &stID,
				&x.Device, &x.OS, &x.Platform, &x.AppVer, &x.IP, &seen) == nil {
				switch {
				case stID != nil:
					x.ScopeKey = fmt.Sprintf("s:%d", *stID)
				case divID != nil:
					x.ScopeKey = fmt.Sprintf("d:%d", *divID)
				case zoneID != nil:
					x.ScopeKey = fmt.Sprintf("z:%d", *zoneID)
				}
				if seen != nil {
					x.LastSeen = istStamp(*seen)
				}
				list = append(list, x)
			}
		}
		rows.Close()
	}
	renderAdmin(w, "users", a.page(r, "Users", "users", map[string]any{
		"Users":     list,
		"Zones":     list3(`SELECT id, name FROM org_zones ORDER BY sort, id`),
		"Divisions": list3(`SELECT id, name FROM org_divisions ORDER BY sort, id`),
		"Stations":  list3(`SELECT id, name FROM org_stations ORDER BY sort, name`),
	}))
}

// --- Organization ---------------------------------------------------------------

func (a *App) adminOrg(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	type st struct {
		ID                 int64
		Name, NameMr, Code string
		Firs               int
	}
	type div struct {
		Name     string
		Stations []st
	}
	type zone struct {
		Name      string
		Divisions []div
	}
	var zonesOut []zone
	zr, _ := a.db.Query(ctx, `SELECT id, name FROM org_zones ORDER BY sort, id`)
	type zrow struct {
		id   int64
		name string
	}
	var zs []zrow
	for zr.Next() {
		var z zrow
		if zr.Scan(&z.id, &z.name) == nil {
			zs = append(zs, z)
		}
	}
	zr.Close()
	for _, z := range zs {
		zo := zone{Name: z.name}
		dr, _ := a.db.Query(ctx,
			`SELECT id, name FROM org_divisions WHERE zone_id = $1 ORDER BY sort, id`, z.id)
		var ds []zrow
		for dr.Next() {
			var d zrow
			if dr.Scan(&d.id, &d.name) == nil {
				ds = append(ds, d)
			}
		}
		dr.Close()
		for _, d := range ds {
			dv := div{Name: d.name}
			sr, _ := a.db.Query(ctx, `
				SELECT s.id, s.name, COALESCE(s.name_mr, ''), COALESCE(s.code, ''),
				       (SELECT COUNT(*) FROM central_crimes c WHERE c.station_id = s.id)
				  FROM org_stations s WHERE s.division_id = $1 ORDER BY s.sort, s.name`, d.id)
			for sr.Next() {
				var x st
				if sr.Scan(&x.ID, &x.Name, &x.NameMr, &x.Code, &x.Firs) == nil {
					dv.Stations = append(dv.Stations, x)
				}
			}
			sr.Close()
			zo.Divisions = append(zo.Divisions, dv)
		}
		zonesOut = append(zonesOut, zo)
	}
	// Data health: station names that never linked.
	type unl struct {
		Name string
		N    int
	}
	var unlinked []unl
	ur, _ := a.db.Query(ctx, `
		SELECT COALESCE(NULLIF(station_name, ''), '(blank)'), COUNT(*)
		  FROM central_crimes WHERE station_id IS NULL
		 GROUP BY 1 ORDER BY 2 DESC LIMIT 20`)
	for ur.Next() {
		var x unl
		if ur.Scan(&x.Name, &x.N) == nil {
			unlinked = append(unlinked, x)
		}
	}
	ur.Close()
	type orgOpt struct {
		ID   int64
		Name string
	}
	divOpts := []orgOpt{}
	dr2, _ := a.db.Query(ctx, `SELECT id, name FROM org_divisions ORDER BY sort, id`)
	for dr2.Next() {
		var o orgOpt
		if dr2.Scan(&o.ID, &o.Name) == nil {
			divOpts = append(divOpts, o)
		}
	}
	dr2.Close()
	renderAdmin(w, "org", a.page(r, "Organization", "org", map[string]any{
		"Zones": zonesOut, "Unlinked": unlinked, "DivOpts": divOpts,
	}))
}

// --- Trash / deletions / releases -----------------------------------------------

func (a *App) adminTrash(w http.ResponseWriter, r *http.Request) {
	type row struct {
		ID                                                int64
		Station, FirNo, Year, Owner, DeletedBy, DeletedAt string
	}
	rows, err := a.db.Query(r.Context(), `
		SELECT id, COALESCE(station_name, ''), COALESCE(fir_no, ''), year,
		       owner_email, COALESCE(deleted_by, ''), deleted_at
		  FROM central_trash ORDER BY deleted_at DESC LIMIT 300`)
	list := []row{}
	if err == nil {
		for rows.Next() {
			var x row
			var yr *int
			var at time.Time
			if rows.Scan(&x.ID, &x.Station, &x.FirNo, &yr, &x.Owner, &x.DeletedBy, &at) == nil {
				if yr != nil {
					x.Year = strconv.Itoa(*yr)
				}
				x.DeletedAt = istStamp(at)
				list = append(list, x)
			}
		}
		rows.Close()
	}
	// Delete-marker count for the tombstone panel: markers are what make
	// station apps drop local copies and refuse re-uploads.
	var tombstones int64
	_ = a.db.QueryRow(r.Context(),
		`SELECT COUNT(*) FROM central_suppressed`).Scan(&tombstones)
	renderAdmin(w, "trash", a.page(r, "Recycle bin", "trash", struct {
		Rows       []row
		Tombstones int64
	}{list, tombstones}))
}

func (a *App) adminDeletions(w http.ResponseWriter, r *http.Request) {
	type row struct {
		Owner, FirNo, Year, Station, Device, IP, When string
	}
	rows, err := a.db.Query(r.Context(), `
		SELECT owner_email, COALESCE(fir_no, ''), year, COALESCE(station_name, ''),
		       COALESCE(src_device, ''), COALESCE(src_ip, ''), deleted_at
		  FROM central_deletions ORDER BY deleted_at DESC LIMIT 300`)
	list := []row{}
	if err == nil {
		for rows.Next() {
			var x row
			var yr *int
			var at time.Time
			if rows.Scan(&x.Owner, &x.FirNo, &yr, &x.Station, &x.Device, &x.IP, &at) == nil {
				if yr != nil {
					x.Year = strconv.Itoa(*yr)
				}
				x.When = istStamp(at)
				list = append(list, x)
			}
		}
		rows.Close()
	}
	renderAdmin(w, "deletions", a.page(r, "Deletion log", "deletions", list))
}

func (a *App) adminReleases(w http.ResponseWriter, r *http.Request) {
	type row struct {
		Version, Platform, File, Created string
		Build                            int
		Mandatory                        bool
	}
	rows, err := a.db.Query(r.Context(), `
		SELECT version, build, platform, file_name, mandatory, created_at
		  FROM app_release ORDER BY build DESC, id DESC LIMIT 100`)
	list := []row{}
	if err == nil {
		for rows.Next() {
			var x row
			var at time.Time
			if rows.Scan(&x.Version, &x.Build, &x.Platform, &x.File, &x.Mandatory, &at) == nil {
				x.Created = istDate(at)
				list = append(list, x)
			}
		}
		rows.Close()
	}
	renderAdmin(w, "releases", a.page(r, "App releases", "releases", list))
}

// adminMessages: audit trail of every command message sent through the system.
func (a *App) adminMessages(w http.ResponseWriter, r *http.Request) {
	type row struct {
		From, Role, Target, Body, At string
	}
	rows, err := a.db.Query(r.Context(), `
		SELECT sender_email, COALESCE(sender_name, ''), sender_role,
		       target_label, body, created_at
		  FROM messages ORDER BY id DESC LIMIT 300`)
	list := []row{}
	if err == nil {
		for rows.Next() {
			var x row
			var name string
			var at time.Time
			if rows.Scan(&x.From, &name, &x.Role, &x.Target, &x.Body, &at) == nil {
				if name != "" {
					x.From = name + " <" + x.From + ">"
				}
				x.At = istStamp(at)
				list = append(list, x)
			}
		}
		rows.Close()
	}
	renderAdmin(w, "messages", a.page(r, "Messages", "messages", list))
}

// --- Templates ---------------------------------------------------------------

var adminTmpl = template.Must(template.New("admin").Parse(adminHTML))

func renderAdmin(w http.ResponseWriter, name string, p adminPage) {
	w.Header().Set("Content-Type", "text/html; charset=utf-8")
	if err := adminTmpl.ExecuteTemplate(w, name, p); err != nil {
		http.Error(w, err.Error(), 500)
	}
}

const adminHTML = `
{{define "head"}}<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{.Title}} — CRMS Admin</title><style>
:root{
--bg:#0b1120;--card:#111a2e;--card2:#16213a;--line:#1e2b49;--line2:#2b3c63;
--tx:#e9effc;--dim:#8fa0c2;--faint:#5d6d90;
--acc:#5b8cff;--acc2:#37d5d6;--ok:#34d399;--warn:#fbbf24;--bad:#f87171;
--grad:linear-gradient(135deg,#5b8cff,#37d5d6);
--shadow:0 12px 32px rgba(3,8,22,.42);--r:16px;
}
*{box-sizing:border-box;margin:0}
html{scroll-behavior:smooth}
body{background:
 radial-gradient(1100px 700px at 85% -10%,#182553 0%,transparent 55%),
 radial-gradient(900px 600px at -10% 110%,#12203f 0%,transparent 50%),
 var(--bg);
color:var(--tx);font:15px/1.55 'Segoe UI Variable Text','Segoe UI',Inter,system-ui,'Noto Sans Devanagari',sans-serif;
-webkit-font-smoothing:antialiased;min-height:100vh}
a{color:var(--acc);text-decoration:none}a:hover{text-decoration:underline}
h1{font-size:23px;font-weight:750;letter-spacing:-.3px}
h2{margin:26px 0 12px;font-size:16.5px;font-weight:700}
::selection{background:rgba(91,140,255,.35)}
::-webkit-scrollbar{width:10px;height:10px}::-webkit-scrollbar-thumb{background:var(--line2);border-radius:6px}::-webkit-scrollbar-track{background:transparent}

/* ---- Shell: sidebar + main ---- */
.shell{display:flex;min-height:100vh}
.side{width:238px;flex-shrink:0;background:rgba(12,18,36,.72);-webkit-backdrop-filter:blur(10px);backdrop-filter:blur(10px);border-right:1px solid var(--line);
 padding:22px 14px 14px;display:flex;flex-direction:column;position:sticky;top:0;height:100vh;overflow-y:auto}
.brand{display:flex;gap:11px;align-items:center;padding:2px 10px 20px;font-weight:750;font-size:16px;letter-spacing:-.2px}
.brand .logo{width:38px;height:38px;border-radius:12px;background:var(--grad);display:flex;align-items:center;justify-content:center;
 font-size:19px;box-shadow:0 5px 16px rgba(91,140,255,.4)}
.brand small{display:block;font-weight:500;font-size:11px;color:var(--faint);letter-spacing:.4px}
.side .sec{color:var(--faint);font-size:10.5px;font-weight:700;letter-spacing:1.4px;text-transform:uppercase;padding:16px 12px 6px}
.side a{display:flex;gap:11px;align-items:center;padding:9px 12px;border-radius:11px;color:var(--dim);font-size:14px;margin:1px 0}
.side a:hover{background:rgba(255,255,255,.045);color:var(--tx);text-decoration:none}
.side a.on{background:linear-gradient(135deg,rgba(91,140,255,.2),rgba(55,213,214,.1));color:var(--tx);font-weight:650;
 box-shadow:inset 0 0 0 1px rgba(91,140,255,.3)}
.side .ico{width:20px;text-align:center}
.side .foot{margin-top:auto;padding:14px 12px 4px;border-top:1px solid var(--line);color:var(--faint);font-size:12px;line-height:1.8}
.side .foot b{color:var(--dim);font-weight:600}
.dot{display:inline-block;width:8px;height:8px;border-radius:50%;margin-right:6px}
.dot.ok{background:var(--ok);box-shadow:0 0 8px var(--ok)}
.dot.warn{background:var(--warn);box-shadow:0 0 8px var(--warn)}
.main{flex:1;min-width:0;padding:28px 36px 60px;max-width:1500px}
.pagehead{display:flex;align-items:baseline;justify-content:space-between;gap:14px;margin-bottom:20px;flex-wrap:wrap}
.pagehead .now{color:var(--faint);font-size:12.5px}
@media(max-width:1000px){
 .shell{flex-direction:column}
 .side{width:100%;height:auto;position:static;flex-direction:row;flex-wrap:wrap;align-items:center;gap:2px;padding:10px}
 .side .sec,.side .foot{display:none}.brand{padding:4px 8px}
 .main{padding:18px 16px 40px}
 table{display:block;overflow-x:auto;-webkit-overflow-scrolling:touch}
}
/* Phones: nav becomes one swipeable strip; every table scrolls sideways inside
   itself instead of stretching the page; inputs at 16px so iOS doesn't zoom. */
@media(max-width:760px){
 h1{font-size:19px}
 .main{padding:12px 10px 36px}
 .pagehead{margin-bottom:12px}
 .side{flex-wrap:nowrap;overflow-x:auto;-webkit-overflow-scrolling:touch;scrollbar-width:none}
 .side::-webkit-scrollbar{display:none}
 .side a{flex-shrink:0;padding:8px 10px;font-size:13px}
 .brand{flex-shrink:0;padding:2px 6px 2px 2px}
 .cards{grid-template-columns:repeat(auto-fit,minmax(126px,1fr));gap:9px}
 .card{padding:12px 13px}.card b{font-size:21px}
 th,td{padding:7px 9px;font-size:12.5px}
 table{white-space:nowrap}
 .duo>.t{max-height:320px}
 .duo>.c{padding:14px 12px}
 input,select{font-size:16px}
 pre{font-size:12px}
}

/* ---- Alerts / banners ---- */
.banner{background:rgba(251,191,36,.08);border:1px solid rgba(251,191,36,.35);color:#f5cf6b;border-radius:12px;padding:11px 15px;margin-bottom:18px;font-size:13.5px}
.msg{background:rgba(52,211,153,.09);border:1px solid rgba(52,211,153,.4);color:#6fe3ac;border-radius:12px;padding:11px 15px;margin-bottom:18px;font-size:13.5px}
.err{color:var(--bad);margin-top:10px;font-size:14px}

/* ---- KPI cards ---- */
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(158px,1fr));gap:13px;margin-bottom:24px}
.card{background:var(--card);border:1px solid var(--line);border-radius:var(--r);padding:16px 17px;box-shadow:var(--shadow);
 transition:transform .15s,border-color .15s}
.card:hover{transform:translateY(-2px);border-color:var(--line2)}
.card .ic{width:38px;height:38px;border-radius:11px;display:flex;align-items:center;justify-content:center;font-size:18px;
 background:rgba(91,140,255,.13);margin-bottom:11px}
.card .ic.ok{background:rgba(52,211,153,.13)}.card .ic.warn{background:rgba(251,191,36,.12)}.card .ic.bad{background:rgba(248,113,113,.12)}
.card b{display:block;font-size:25px;font-weight:750;letter-spacing:-.5px;font-variant-numeric:tabular-nums}
.card span{color:var(--dim);font-size:12.5px}

/* ---- Panels: table (left) + chart (right) ---- */
.panel{background:var(--card);border:1px solid var(--line);border-radius:var(--r);box-shadow:var(--shadow);margin-bottom:22px;overflow:hidden}
.panel>header{padding:15px 20px;border-bottom:1px solid var(--line);display:flex;justify-content:space-between;align-items:center;gap:10px;flex-wrap:wrap}
.panel h3{font-size:15px;font-weight:700}
.panel .sub{color:var(--dim);font-size:12.5px;margin-top:2px}
.duo{display:grid;grid-template-columns:minmax(0,5fr) minmax(0,7fr)}
.duo>.t{border-right:1px solid var(--line);max-height:430px;overflow:auto}
.duo>.c{padding:20px 22px;display:flex;align-items:center}
@media(max-width:1150px){.duo{grid-template-columns:1fr}.duo>.t{border-right:none;border-bottom:1px solid var(--line)}}
.chart{width:100%;height:auto;display:block}
.chart .grid{stroke:var(--line);stroke-width:1}
.chart .tick{fill:var(--faint);font-size:11px}
.chart .lbl{fill:var(--dim);font-size:11px}
.chart .val{fill:var(--tx);font-size:12px;font-weight:600}
.chart .leg{fill:var(--dim);font-size:13px}
.chart .donut-big{fill:var(--tx);font-size:21px;font-weight:750}
.chart .vbar{transition:opacity .12s}.chart .vbar:hover{opacity:.75}
.nodata{color:var(--faint);padding:40px;text-align:center;width:100%;font-size:13.5px}

/* ---- Tables ---- */
table{width:100%;border-collapse:collapse;background:var(--card);border:1px solid var(--line);border-radius:14px;overflow:hidden}
.panel table,.duo table{border:none;border-radius:0;background:transparent}
th,td{padding:9px 14px;text-align:left;border-bottom:1px solid var(--line);font-size:13.5px}
th{color:var(--dim);font-weight:650;font-size:11.5px;text-transform:uppercase;letter-spacing:.5px;background:var(--card2);position:sticky;top:0;z-index:1}
tr:last-child td{border-bottom:none}
tbody tr:hover td,tr:hover td{background:rgba(91,140,255,.04)}
td small{color:var(--faint)}
.num{font-variant-numeric:tabular-nums}
.scrolly{max-height:calc(100vh - 230px);min-height:300px;overflow:auto;border-radius:14px;border:1px solid var(--line)}
.scrolly table{border:none}

/* ---- Tags ---- */
.tag{display:inline-block;padding:2.5px 10px;border-radius:20px;font-size:12px;font-weight:600}
.tag.ok{background:rgba(52,211,153,.14);color:#5ee0a4}.tag.bad{background:rgba(248,113,113,.14);color:#f39a9a}
.tag.warn{background:rgba(251,191,36,.13);color:#eecb70}.tag.dim{background:rgba(143,160,194,.12);color:var(--dim)}

/* ---- Insights ---- */
.insights{display:grid;grid-template-columns:repeat(auto-fit,minmax(330px,1fr));gap:14px;margin-bottom:24px}
.ins{background:var(--card);border:1px solid var(--line);border-left:4px solid var(--acc);border-radius:13px;padding:16px 18px;box-shadow:var(--shadow)}
.ins.ok{border-left-color:var(--ok)}.ins.warn{border-left-color:var(--warn)}.ins.bad{border-left-color:var(--bad)}
.ins .h{display:flex;gap:9px;align-items:center;font-weight:650;font-size:14.5px}
.ins .b{color:var(--dim);font-size:13px;line-height:1.6;margin-top:7px}

/* ---- Forms ---- */
form.search{display:flex;gap:9px;margin-bottom:18px;flex-wrap:wrap}
input,select{background:rgba(11,17,32,.7);border:1px solid var(--line2);color:var(--tx);border-radius:10px;padding:8px 13px;font:inherit;outline:none;transition:border-color .12s,box-shadow .12s}
input:focus,select:focus{border-color:var(--acc);box-shadow:0 0 0 3px rgba(91,140,255,.18)}
button{background:var(--grad);border:none;color:#fff;border-radius:10px;padding:8.5px 17px;font:inherit;font-weight:650;cursor:pointer;transition:filter .12s,transform .12s}
button:hover{filter:brightness(1.12)}button:active{transform:translateY(1px)}
button.sm{padding:5px 11px;font-size:12.5px;border-radius:8px}
button.danger{background:linear-gradient(135deg,#ef4444,#f97316)}
button.gray{background:#33415e}
select.sm,input.sm{padding:5px 9px;font-size:13px;border-radius:8px}
form.inline{display:inline-flex;gap:6px;align-items:center;flex-wrap:wrap;margin:2px 0}
.pager{display:flex;gap:12px;margin:15px 0;align-items:center;color:var(--dim);flex-wrap:wrap}
pre{background:rgba(11,17,32,.7);border:1px solid var(--line);border-radius:12px;padding:15px;overflow-x:auto;font-size:13px;line-height:1.5}
.grid2{display:grid;grid-template-columns:1fr 1fr;gap:20px}@media(max-width:1000px){.grid2{grid-template-columns:1fr}}
.kv td:first-child{color:var(--dim);width:190px}

/* ---- Login ---- */
.login{width:min(380px,calc(100% - 32px));margin:14vh auto;background:var(--card);border:1px solid var(--line);border-radius:20px;padding:34px 32px;box-shadow:var(--shadow)}
.login .logo{width:52px;height:52px;border-radius:15px;background:var(--grad);display:flex;align-items:center;justify-content:center;font-size:26px;margin-bottom:16px;box-shadow:0 8px 24px rgba(91,140,255,.4)}
.login h1{font-size:21px;margin-bottom:4px}
.login p{color:var(--dim);font-size:13px;margin-bottom:14px}
.login input,.login button{width:100%;margin-top:11px}
</style></head><body>{{end}}

{{define "nav"}}
<div class="shell"><aside class="side">
<div class="brand"><div class="logo">🚔</div><div>CRMS<small>Admin Console</small></div></div>
<div class="sec">Overview</div>
<a href="/admin" class="{{if eq .Active "dashboard"}}on{{end}}"><span class="ico">🏠</span>Dashboard</a>
<a href="/admin/analytics" class="{{if eq .Active "analytics"}}on{{end}}"><span class="ico">📊</span>Analytics</a>
<div class="sec">Data</div>
<a href="/admin/firs" class="{{if eq .Active "firs"}}on{{end}}"><span class="ico">🗂️</span>FIRs</a>
<a href="/admin/users" class="{{if eq .Active "users"}}on{{end}}"><span class="ico">👥</span>Users</a>
<a href="/admin/org" class="{{if eq .Active "org"}}on{{end}}"><span class="ico">🏢</span>Organization</a>
<a href="/admin/messages" class="{{if eq .Active "messages"}}on{{end}}"><span class="ico">📨</span>Messages</a>
<div class="sec">Housekeeping</div>
<a href="/admin/trash" class="{{if eq .Active "trash"}}on{{end}}"><span class="ico">🗑️</span>Recycle bin</a>
<a href="/admin/deletions" class="{{if eq .Active "deletions"}}on{{end}}"><span class="ico">📜</span>Deletion log</a>
<a href="/admin/releases" class="{{if eq .Active "releases"}}on{{end}}"><span class="ico">🚀</span>Releases</a>
<div class="sec">Session</div>
<a href="/admin/logout"><span class="ico">🚪</span>Logout</a>
<div class="foot">
{{if .MirrorMode}}<span class="dot warn"></span><b>Rollout mode</b>{{else}}<span class="dot ok"></span><b>Standalone primary</b>{{end}}<br>
{{if .LastSync}}Last pull: {{.LastSync}}<br>{{end}}
{{.Now}} IST
</div>
</aside><main class="main">
<div class="pagehead"><h1>{{.Title}}</h1><span class="now">Server time: {{.Now}} IST</span></div>
{{if .Msg}}<div class="msg">✓ {{.Msg}}</div>{{end}}
{{if .MirrorMode}}<div class="banner">🔄 <b>Rollout mode</b> — new records from the old server are still being pulled in{{if .LastSync}} (last pull {{.LastSync}}){{end}}. This panel is now the main one: changes made here stay.</div>{{end}}
{{end}}

{{define "foot"}}</main></div></body></html>{{end}}

{{define "login"}}{{template "head" .}}
<div class="login"><div class="logo">🚔</div><h1>CRMS Admin</h1>
<p>Central crime records — authorized personnel only.</p>
<form method="post" action="/admin/login">
<input type="password" name="password" placeholder="Admin password" autofocus>
<button type="submit">Sign in</button>
{{if .Error}}<div class="err">{{.Error}}</div>{{end}}
</form></div></body></html>{{end}}

{{define "dashboard"}}{{template "head" .}}{{template "nav" .}}
{{with .Data}}
<div class="cards">
<div class="card"><div class="ic">🗂️</div><b class="num">{{.Total}}</b><span>Total FIRs</span></div>
<div class="card"><div class="ic ok">✅</div><b class="num">{{.Detected}}</b><span>Detected (उघड)</span></div>
<div class="card"><div class="ic bad">🔍</div><b class="num">{{.Undetected}}</b><span>Undetected (न उघड)</span></div>
<div class="card"><div class="ic warn">🔗</div><b class="num">{{.Unlinked}}</b><span>Not linked to a station</span></div>
<div class="card"><div class="ic">👥</div><b class="num">{{.Users}}</b><span>Users</span></div>
<div class="card"><div class="ic warn">⏳</div><b class="num">{{.Pending}}</b><span>Pending approval</span></div>
<div class="card"><div class="ic">🗑️</div><b class="num">{{.Trash}}</b><span>In recycle bin</span></div>
</div>

<div class="panel"><header><div><h3>Sync activity — last 14 days</h3>
<div class="sub">FIRs created or updated on this server per day (IST)</div></div></header>
<div class="duo"><div class="t"><table><tr><th>Date</th><th>Records</th></tr>
{{range .Activity}}<tr><td>{{.Label}}</td><td class="num">{{.N}}</td></tr>{{end}}</table></div>
<div class="c">{{.ActivityChart}}</div></div></div>

<div class="panel"><header><div><h3>Crime by zone</h3>
<div class="sub">Where the city's FIRs sit across zones</div></div></header>
<div class="duo"><div class="t"><table><tr><th>Zone</th><th>Total</th><th>Detected</th><th>Undetected</th></tr>
{{range .Zones}}<tr><td>{{.Name}}</td><td class="num">{{.Total}}</td><td class="num">{{.Detected}}</td><td class="num">{{.Undetected}}</td></tr>{{end}}</table></div>
<div class="c">{{.ZoneChart}}</div></div></div>

<div class="panel"><header><div><h3>Top stations by caseload</h3>
<div class="sub">Top 25 in the table · top 15 charted</div></div></header>
<div class="duo"><div class="t"><table><tr><th>Station</th><th>Total</th><th>Detected</th><th>Undetected</th></tr>
{{range .Stations}}<tr><td>{{.Name}}</td><td class="num">{{.Total}}</td><td class="num">{{.Detected}}</td><td class="num">{{.Undetected}}</td></tr>{{end}}</table></div>
<div class="c">{{.StationChart}}</div></div></div>
{{end}}{{template "foot" .}}{{end}}

{{define "analytics"}}{{template "head" .}}{{template "nav" .}}
{{with .Data}}
<form class="search" method="get" action="/admin/analytics">
<select name="year"><option value="">All years</option>
{{$y := .Year}}{{range .YearOpts}}<option value="{{.}}" {{if eq . $y}}selected{{end}}>{{.}}</option>{{end}}</select>
<select name="station_id"><option value="">All stations</option>
{{$s := .StationID}}{{range .StationOpts}}<option value="{{.ID}}" {{if eq .ID $s}}selected{{end}}>{{.Name}}</option>{{end}}</select>
<button>Apply</button></form>

{{with .KPI}}
<div class="cards">
<div class="card"><div class="ic">🗂️</div><b class="num">{{.Total}}</b><span>Total FIRs</span></div>
<div class="card"><div class="ic ok">✅</div><b class="num">{{.Detected}}</b><span>Detected (उघड)</span></div>
<div class="card"><div class="ic bad">🔍</div><b class="num">{{.Undetected}}</b><span>Undetected (न उघड)</span></div>
<div class="card"><div class="ic">🎯</div><b class="num">{{.DetectedPct}}%</b><span>Detection rate</span></div>
<div class="card"><div class="ic">📄</div><b class="num">{{.Chargesheeted}}</b><span>Chargesheeted (दोषारोपपत्र)</span></div>
<div class="card"><div class="ic warn">🚔</div><b class="num">{{.Arrested}}</b><span>Arrested (अटक)</span></div>
<div class="card"><div class="ic bad">🕵️</div><b class="num">{{.Wanted}}</b><span>Wanted (पाहिजे)</span></div>
</div>
{{end}}

<h2>🧠 Automatic insights</h2>
<div class="insights">
{{range .Insights}}<div class="ins {{.Tone}}"><div class="h"><span>{{.Icon}}</span>{{.Title}}</div><div class="b">{{.Body}}</div></div>{{end}}
</div>

<div class="panel"><header><div><h3>💰 Muddemal — property money trail (मुद्देमाल)</h3>
<div class="sub">Value of property involved in crimes vs recovered</div></div></header>
<div class="duo"><div class="t"><table>
<tr><th>Measure</th><th>Amount</th></tr>
<tr><td>Property lost / involved (गेला माल)</td><td class="num"><b>{{.LostFmt}}</b></td></tr>
<tr><td>Recovered (हस्तगत माल)</td><td class="num" style="color:var(--ok)"><b>{{.RecoveredFmt}}</b></td></tr>
<tr><td>Still to recover (बाकी)</td><td class="num" style="color:var(--bad)"><b>{{.RemainingFmt}}</b></td></tr>
</table>
{{if not .HasLost}}<div style="padding:12px 14px;color:var(--faint);font-size:12.5px">Lost-property values will start filling in as stations sync after their next app update — recovered values are live already.</div>{{end}}
</div>
<div class="c">{{if .MuddemalChart}}{{.MuddemalChart}}{{else}}<div class="nodata">Recovery donut appears when lost-property values arrive</div>{{end}}</div></div></div>

<div class="panel"><header><div><h3>Year-wise trend</h3><div class="sub">Case volume and detection by year</div></div></header>
<div class="duo"><div class="t"><table><tr><th>Year</th><th>Total</th><th>Detected</th><th>Rate</th></tr>
{{range .YearRows}}<tr><td>{{.Label}}</td><td class="num">{{.Total}}</td><td class="num">{{.Detected}}</td><td class="num">{{.Pct}}%</td></tr>{{end}}</table></div>
<div class="c">{{.YearChart}}</div></div></div>

<div class="panel"><header><div><h3>Month-wise trend</h3><div class="sub">Last 24 months, by registration date</div></div></header>
<div class="duo"><div class="t"><table><tr><th>Month</th><th>Total</th><th>Detected</th><th>Rate</th></tr>
{{range .MonthRows}}<tr><td>{{.Label}}</td><td class="num">{{.Total}}</td><td class="num">{{.Detected}}</td><td class="num">{{.Pct}}%</td></tr>{{end}}</table></div>
<div class="c">{{.MonthChart}}</div></div></div>

<div class="panel"><header><div><h3>📅 Day of the week</h3><div class="sub">When crimes actually happen (occurrence date) — spot the hot days</div></div></header>
<div class="duo"><div class="t"><table><tr><th>Day</th><th>Total</th><th>Detected</th><th>Rate</th></tr>
{{range .WdRows}}<tr><td>{{.Label}}<br><small>{{.Sub}}</small></td><td class="num">{{.Total}}</td><td class="num">{{.Detected}}</td><td class="num">{{.Pct}}%</td></tr>{{end}}</table></div>
<div class="c">{{.WdChart}}</div></div></div>

<div class="panel"><header><div><h3>🕘 Time of day</h3><div class="sub">{{.TimedTotal}} cases have a recorded occurrence time</div></div></header>
<div class="duo"><div class="t"><table><tr><th>Time window</th><th>Cases</th><th>Share</th></tr>
{{range .BandRows}}<tr><td>{{.Label}}</td><td class="num">{{.Total}}</td><td class="num">{{.Pct}}%</td></tr>{{end}}</table></div>
<div class="c">{{.HourChart}}</div></div></div>

<div class="panel"><header><div><h3>📆 Week of the month</h3><div class="sub">Does crime cluster around a particular week (salary days, market days)?</div></div></header>
<div class="duo"><div class="t"><table><tr><th>Week</th><th>Total</th><th>Detected</th><th>Rate</th></tr>
{{range .WkRows}}<tr><td>{{.Label}}<br><small>{{.Sub}}</small></td><td class="num">{{.Total}}</td><td class="num">{{.Detected}}</td><td class="num">{{.Pct}}%</td></tr>{{end}}</table></div>
<div class="c">{{.WkChart}}</div></div></div>

<div class="panel"><header><div><h3>📌 Hottest single dates</h3><div class="sub">Specific dates with the most crimes — festivals, incidents, patterns</div></div></header>
<div class="duo"><div class="t"><table><tr><th>Date</th><th>Cases</th></tr>
{{range .DateRows}}<tr><td>{{.Label}}<br><small>{{.Sub}}</small></td><td class="num">{{.Total}}</td></tr>{{end}}</table></div>
<div class="c">{{.DateChart}}</div></div></div>

<div class="panel"><header><div><h3>Top crime types</h3><div class="sub">The 15 most common crime heads</div></div></header>
<div class="duo"><div class="t"><table><tr><th>Type</th><th>Total</th><th>Detected</th><th>Rate</th></tr>
{{range .TypeRows}}<tr><td>{{.Label}}</td><td class="num">{{.Total}}</td><td class="num">{{.Detected}}</td><td class="num">{{.Pct}}%</td></tr>{{end}}</table></div>
<div class="c">{{.TypeChart}}</div></div></div>

<div class="panel"><header><div><h3>🏆 Station detection league</h3><div class="sub">Best solvers first (stations with 10+ cases ranked; chart shows detection %)</div></div></header>
<div class="duo"><div class="t"><table><tr><th>Station</th><th>Total</th><th>Detected</th><th>Rate</th></tr>
{{range .LeagueRows}}<tr><td>{{.Label}}</td><td class="num">{{.Total}}</td><td class="num">{{.Detected}}</td><td class="num">{{.Pct}}%</td></tr>{{end}}</table></div>
<div class="c">{{.LeagueChart}}</div></div></div>

<h2>Data quality (fix these to make every report accurate)</h2>
<div class="cards">
<div class="card"><div class="ic warn">🔗</div><b class="num">{{.NoStation}}</b><span>Not linked to a station (Re-link on Organization page)</span></div>
<div class="card"><div class="ic warn">#️⃣</div><b class="num">{{.NoFirNo}}</b><span>Missing FIR number</span></div>
<div class="card"><div class="ic warn">📅</div><b class="num">{{.NoDate}}</b><span>Missing registration date (excluded from month trend)</span></div>
<div class="card"><div class="ic warn">🏷️</div><b class="num">{{.NoType}}</b><span>Missing crime type</span></div>
</div>
{{end}}{{template "foot" .}}{{end}}

{{define "firs"}}{{template "head" .}}{{template "nav" .}}
{{with .Data}}
<form class="search" method="get" action="/admin/firs">
<input name="q" value="{{.Q}}" placeholder="Search FIR no / section / station / email…" style="flex:1;min-width:220px">
<input name="year" value="{{.Year}}" placeholder="Year" style="width:90px">
<select name="status"><option value="">Any status</option>
<option value="detected" {{if eq .Status "detected"}}selected{{end}}>Detected</option>
<option value="undetected" {{if eq .Status "undetected"}}selected{{end}}>Undetected</option></select>
<button>Search</button></form>
{{if .DidYouMean}}<div class="msg">🧠 Did you mean:
{{range .DidYouMean}}&nbsp;<a href="/admin/firs?q={{.}}"><b>{{.}}</b></a>{{end}}</div>{{end}}
<div class="pager"><span>{{.Total}} records</span><span class="sp" style="flex:1"></span>
<form method="post" action="/admin/fir/delete_bulk" onsubmit="var n=prompt('This moves ALL {{.Total}} matching FIRs to the recycle bin AND deletes them from the station apps on their next sync.\n\nType the number {{.Total}} to confirm:');if(n===null)return false;if(n.trim()!=={{.Total}}+''){alert('Number did not match — nothing was deleted.');return false}return true">
<input type="hidden" name="all" value="1"><input type="hidden" name="q" value="{{.Q}}">
<input type="hidden" name="year" value="{{.Year}}"><input type="hidden" name="status" value="{{.Status}}">
<input type="hidden" name="expected" value="{{.Total}}">
<button class="sm danger">🗑 Delete ALL {{.Total}} matching</button></form></div>
<form method="post" action="/admin/fir/delete_bulk" onsubmit="return confirm('Move the selected FIRs to the recycle bin? They will also be removed from the station apps on their next sync.')">
<div class="scrolly"><table><tr><th><input type="checkbox" onclick="document.querySelectorAll('input[name=ids]').forEach(c=>c.checked=this.checked)"></th><th>FIR</th><th>Year</th><th>Station</th><th>Type</th><th>Sections</th><th>Status</th><th>Registered</th><th>Owner</th></tr>
{{range .Rows}}<tr>
<td><input type="checkbox" name="ids" value="{{.ID}}"></td>
<td><a href="/admin/fir?id={{.ID}}">{{if .FirNo}}{{.FirNo}}{{else}}#{{.ID}}{{end}}</a></td>
<td>{{.Year}}</td><td>{{.Station}}</td><td>{{.CrimeType}}</td><td>{{.Section}}</td>
<td>{{if eq .Status "detected"}}<span class="tag ok">detected</span>{{else if .Status}}<span class="tag warn">{{.Status}}</span>{{else}}<span class="tag dim">—</span>{{end}}</td>
<td>{{.Registered}}</td><td>{{.Owner}}</td></tr>{{end}}</table></div>
<div class="pager"><button class="sm danger">🗑 Delete selected</button></div>
</form>
<div class="pager">
{{if .HasPrev}}<a href="/admin/firs?q={{.Q}}&year={{.Year}}&status={{.Status}}&page={{.PrevPage}}">← Prev</a>{{end}}
<span>Page {{.Page}}</span>
{{if .HasNext}}<a href="/admin/firs?q={{.Q}}&year={{.Year}}&status={{.Status}}&page={{.NextPage}}">Next →</a>{{end}}
</div>
{{end}}{{template "foot" .}}{{end}}

{{define "fir"}}{{template "head" .}}{{template "nav" .}}
{{with .Data}}
<h2>FIR {{.FirNo}}{{if .Year}} / {{.Year}}{{end}} — {{.Station}}</h2>
<table class="kv">
<tr><td>Status</td><td>{{.Status}}</td></tr>
<tr><td>Crime type</td><td>{{.CrimeType}}</td></tr>
<tr><td>Sections</td><td>{{.Section}}</td></tr>
<tr><td>Date registered</td><td>{{.Registered}}</td></tr>
<tr><td>Date occurred</td><td>{{.Occurred}}</td></tr>
<tr><td>Uploaded by</td><td>{{.Owner}}</td></tr>
<tr><td>From device</td><td>{{.Device}} {{if .IP}}({{.IP}}){{end}}</td></tr>
<tr><td>Last updated</td><td>{{.Updated}}</td></tr>
</table>
<form method="post" action="/admin/fir/delete" style="margin:14px 0" onsubmit="return confirm('Move this FIR to the recycle bin? Its station app will also remove it on next sync.')">
<input type="hidden" name="id" value="{{.ID}}"><button class="danger">🗑 Delete FIR</button></form>
<h2>Full record</h2><pre>{{.Data}}</pre>
{{end}}{{template "foot" .}}{{end}}

{{define "users"}}{{template "head" .}}{{template "nav" .}}
{{$zones := .Data.Zones}}{{$divs := .Data.Divisions}}{{$sts := .Data.Stations}}
<div class="scrolly"><table><tr><th>Email</th><th>Status</th><th>Access</th><th>Role &amp; scope</th><th>Device</th><th>App</th><th>IP address</th><th>Last seen (IST)</th></tr>
{{range .Data.Users}}<tr>
<td>{{.Email}}{{if .Name}}<br><small>{{.Name}}</small>{{end}}</td>
<td>{{if eq .Status "approved"}}<span class="tag ok">approved</span>{{else if eq .Status "pending"}}<span class="tag warn">pending</span>{{else}}<span class="tag bad">{{.Status}}</span>{{end}}
{{if .Scope}}<br><small>{{.Scope}}</small>{{end}}</td>
<td>
{{if ne .Status "approved"}}<form class="inline" method="post" action="/admin/user/status"><input type="hidden" name="email" value="{{.Email}}"><input type="hidden" name="status" value="approved"><button class="sm">✓ Approve</button></form>{{end}}
{{if ne .Status "denied"}}<form class="inline" method="post" action="/admin/user/status" onsubmit="return confirm('Deny {{.Email}}?')"><input type="hidden" name="email" value="{{.Email}}"><input type="hidden" name="status" value="denied"><button class="sm danger">✕ Deny</button></form>{{end}}
<form class="inline" method="post" action="/admin/user/reset_device" onsubmit="return confirm('Reset the bound device for {{.Email}}? The next PC that signs in becomes their device.')"><input type="hidden" name="email" value="{{.Email}}"><button class="sm gray">↺ Reset device</button></form>
</td>
<td><form class="inline" method="post" action="/admin/user/role">
<input type="hidden" name="email" value="{{.Email}}">
<select name="role" class="sm">
<option value="station" {{if eq .Role "station"}}selected{{end}}>station</option>
<option value="acp" {{if eq .Role "acp"}}selected{{end}}>ACP</option>
<option value="dcp" {{if eq .Role "dcp"}}selected{{end}}>DCP</option>
<option value="cp" {{if eq .Role "cp"}}selected{{end}}>CP</option>
<option value="hq" {{if eq .Role "hq"}}selected{{end}}>Tester — sees everything (all stations + portal + entry)</option>
</select>
{{$sk := .ScopeKey}}
<select name="scope" class="sm" style="max-width:210px">
<option value="">— no scope (CP / Tester) —</option>
<optgroup label="Zone — for DCP">
{{range $zones}}<option value="z:{{.ID}}"{{if eq (printf "z:%d" .ID) $sk}} selected{{end}}>{{.Name}}</option>{{end}}
</optgroup>
<optgroup label="Division — for ACP">
{{range $divs}}<option value="d:{{.ID}}"{{if eq (printf "d:%d" .ID) $sk}} selected{{end}}>{{.Name}}</option>{{end}}
</optgroup>
<optgroup label="Police station — for station">
{{range $sts}}<option value="s:{{.ID}}"{{if eq (printf "s:%d" .ID) $sk}} selected{{end}}>{{.Name}}</option>{{end}}
</optgroup>
</select>
<button class="sm">Save</button></form></td>
<td>{{.Device}}{{if .OS}}<br><small>{{.OS}}{{if .Platform}} · {{.Platform}}{{end}}</small>{{end}}</td>
<td>{{.AppVer}}</td>
<td class="num">{{.IP}}</td>
<td>{{.LastSeen}}</td></tr>{{end}}</table></div>
{{template "foot" .}}{{end}}

{{define "org"}}{{template "head" .}}{{template "nav" .}}
{{with .Data}}
<div style="display:flex;gap:10px;margin-bottom:8px;flex-wrap:wrap">
<form method="post" action="/admin/health/relink"><button>🔗 Re-link stations</button></form>
<form method="post" action="/admin/health/dedupe" onsubmit="return confirm('Remove duplicate FIRs (same FIR no + year + station)? The newest copy of each is kept; the rest go to the recycle bin.')"><button class="gray">♻️ Remove duplicates</button></form>
</div>
<p style="color:var(--dim);font-size:13px;margin-bottom:14px">Edit the Marathi name or add an alias (any other spelling stations use, e.g. <i>chhavni</i>), press Save, then 🔗 Re-link to apply to existing FIRs.</p>
{{range .Zones}}<h2>{{.Name}}</h2>
{{range .Divisions}}
<table style="margin-bottom:14px"><tr><th colspan="4">{{.Name}} (ACP)</th></tr>
<tr><th>Station</th><th>Marathi / alias</th><th>FIRs</th><th></th></tr>
{{range .Stations}}<tr><td>{{.Name}}</td>
<td><form class="inline" method="post" action="/admin/org/station">
<input type="hidden" name="id" value="{{.ID}}">
<input class="sm" name="name_mr" value="{{.NameMr}}" placeholder="Marathi name" style="width:150px">
<input class="sm" name="code" value="{{.Code}}" placeholder="alias / code" style="width:110px">
<button class="sm">Save</button></form></td>
<td class="num">{{.Firs}}</td><td></td></tr>{{end}}
</table>{{end}}{{end}}
<h2>Add a station</h2>
<form class="search" method="post" action="/admin/org/station/add">
<input name="name" placeholder="Station name (English)" required>
<input name="name_mr" placeholder="Marathi name">
<input name="code" placeholder="alias / code">
<select name="division_id"><option value="">No division</option>{{range .DivOpts}}<option value="{{.ID}}">{{.Name}}</option>{{end}}</select>
<button>Add</button></form>
{{if .Unlinked}}<h2>⚠ Station names not linked to any station</h2>
<p style="color:var(--dim);font-size:13px;margin-bottom:8px">Link a name by adding it as a station alias above — or move its FIRs to the recycle bin if they're junk (restorable for 30 days).</p>
<table><tr><th>Uploaded name</th><th>FIRs</th><th></th></tr>
{{range .Unlinked}}<tr><td>{{.Name}}</td><td class="num">{{.N}}</td>
<td><form class="inline" method="post" action="/admin/org/unlinked/delete" onsubmit="return confirm('Move all {{.N}} FIRs with station name {{.Name}} to the recycle bin? They can be restored from there. Station apps are also told to remove them on their next sync (the app asks the user before applying a mass deletion).')">
<input type="hidden" name="name" value="{{.Name}}">
<button class="sm danger">🗑 Move {{.N}} to recycle bin</button></form></td></tr>{{end}}</table>{{end}}
{{end}}{{template "foot" .}}{{end}}

{{define "trash"}}{{template "head" .}}{{template "nav" .}}
<div style="display:flex;gap:10px;margin-bottom:12px;flex-wrap:wrap">
<form method="post" action="/admin/trash/restore_bulk" onsubmit="return confirm('Restore EVERYTHING in the recycle bin?')">
<input type="hidden" name="all" value="1"><button class="gray">↩ Restore ALL</button></form>
<form method="post" action="/admin/trash/purge" onsubmit="return confirm('PERMANENTLY delete everything in the recycle bin? This CANNOT be undone — the records are gone forever.')">
<input type="hidden" name="all" value="1"><button class="danger">🔥 Clear recycle bin (forever)</button></form>
</div>
<form method="post">
<div class="scrolly"><table><tr><th><input type="checkbox" onclick="document.querySelectorAll('input[name=ids]').forEach(c=>c.checked=this.checked)"></th><th>FIR</th><th>Year</th><th>Station</th><th>Owner</th><th>Deleted by</th><th>When (IST)</th></tr>
{{range .Data.Rows}}<tr><td><input type="checkbox" name="ids" value="{{.ID}}"></td>
<td>{{.FirNo}}</td><td>{{.Year}}</td><td>{{.Station}}</td><td>{{.Owner}}</td><td>{{.DeletedBy}}</td><td>{{.DeletedAt}}</td></tr>{{end}}</table></div>
<div class="pager">
<button class="sm gray" formaction="/admin/trash/restore_bulk" onclick="return confirm('Restore the selected FIRs?')">↩ Restore selected</button>
<button class="sm danger" formaction="/admin/trash/purge" onclick="return confirm('PERMANENTLY delete the selected FIRs? This CANNOT be undone.')">🔥 Delete selected forever</button>
</div>
</form>
<h2>Delete-markers (tombstones)</h2>
<p style="color:var(--dim);font-size:13px;margin-bottom:10px">
The server holds <b>{{.Data.Tombstones}}</b> delete-markers. A marker tells every station app to delete that record locally and blocks it from being re-uploaded.
If the server's data was wiped/reset, or a station restored a backup and its sync is blocked by the mass-delete warning, clear the markers so stations can send their records back. Clearing markers deletes NO data.</p>
<form method="post" action="/admin/suppressed/clear" class="search" onsubmit="return confirm('Clear delete-markers? Station apps will be allowed to keep and re-upload those records on their next sync. No records are deleted by this action.')">
<input class="sm" name="email" placeholder="Only this owner email (empty = ALL markers)" style="min-width:280px">
<button class="sm gray">♻ Clear delete-markers</button></form>
{{template "foot" .}}{{end}}

{{define "deletions"}}{{template "head" .}}{{template "nav" .}}
<div class="scrolly"><table><tr><th>FIR</th><th>Year</th><th>Station</th><th>Deleted by</th><th>Device</th><th>IP</th><th>When (IST)</th></tr>
{{range .Data}}<tr><td>{{.FirNo}}</td><td>{{.Year}}</td><td>{{.Station}}</td><td>{{.Owner}}</td><td>{{.Device}}</td><td class="num">{{.IP}}</td><td>{{.When}}</td></tr>{{end}}</table></div>
{{template "foot" .}}{{end}}

{{define "messages"}}{{template "head" .}}{{template "nav" .}}
<p style="color:var(--dim);font-size:13px;margin-bottom:14px">Every command message sent by CP / DCP / ACP / Tester from the app. Messages are composed in the app's Officer Portal — this page is the audit trail.</p>
<div class="scrolly"><table><tr><th>From</th><th>Rank</th><th>To</th><th>Message</th><th>Sent (IST)</th></tr>
{{range .Data}}<tr><td>{{.From}}</td><td><span class="tag dim">{{.Role}}</span></td><td>{{.Target}}</td><td style="max-width:420px">{{.Body}}</td><td>{{.At}}</td></tr>{{end}}</table></div>
{{template "foot" .}}{{end}}

{{define "releases"}}{{template "head" .}}{{template "nav" .}}
<h2>Publish an update</h2>
<form class="search" method="post" action="/admin/release/upload" enctype="multipart/form-data">
<input type="file" name="file" required>
<input name="notes" placeholder="Release notes (optional)" style="flex:1;min-width:200px">
<label style="display:flex;align-items:center;gap:6px"><input type="checkbox" name="mandatory">Mandatory</label>
<button>⬆ Publish</button></form>
<p style="color:var(--dim);font-size:13px;margin-bottom:14px">File name must contain the version, e.g. <i>crms-setup-1.13.0.exe</i>. Apps see the update on their next launch.</p>
<table><tr><th>Version</th><th>Build</th><th>Platform</th><th>File</th><th>Mandatory</th><th>Published (IST)</th></tr>
{{range .Data}}<tr><td>{{.Version}}</td><td class="num">{{.Build}}</td><td>{{.Platform}}</td><td>{{.File}}</td>
<td>{{if .Mandatory}}<span class="tag warn">yes</span>{{else}}no{{end}}</td><td>{{.Created}}</td></tr>{{end}}</table>
{{template "foot" .}}{{end}}
`
