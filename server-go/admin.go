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

// The new self-hosted admin panel. While the Hostinger mirror is active the
// panel is read-only (any local edit would be overwritten by the next sync);
// after cutover (MIRROR_BASE_URL cleared) the write actions unlock.

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
	Error      string
	Msg        string
	Data       any
}

func (a *App) page(r *http.Request, title, active string, data any) adminPage {
	p := adminPage{Title: title, Active: active, MirrorMode: a.cfg.MirrorBaseURL != "", Data: data}
	p.Msg = r.URL.Query().Get("msg")
	var last *time.Time
	_ = a.db.QueryRow(r.Context(),
		`SELECT last_sync FROM mirror_state WHERE tbl = 'central_crimes'`).Scan(&last)
	if last != nil {
		p.LastSync = last.UTC().Format("2006-01-02 15:04") + " UTC"
	}
	return p
}

// --- Pages -------------------------------------------------------------------

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
	d["Zones"] = zones
	d["Stations"] = stations
	renderAdmin(w, "dashboard", a.page(r, "Dashboard", "dashboard", d))
}

type firRow struct {
	ID          int64
	Station     string
	FirNo       string
	Year        string
	CrimeType   string
	Section     string
	Status      string
	Registered  string
	Owner       string
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
	renderAdmin(w, "firs", a.page(r, "FIR Search", "firs", map[string]any{
		"Rows": list, "Total": total, "Q": q, "Year": year, "Status": status,
		"Page": page, "HasPrev": page > 1, "HasNext": page*pageSize < total,
		"PrevPage": page - 1, "NextPage": page + 1,
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
		"Updated": updated.UTC().Format("02-01-2006 15:04 UTC"), "Data": pretty,
	}))
}

func (a *App) adminUsers(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	type userRow struct {
		Email, Name, Status, Role, Scope, Device, AppVer, LastSeen string
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
		       COALESCE(u.client_device, ''), COALESCE(u.app_version, ''), u.last_seen_at
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
			if rows.Scan(&x.Email, &x.Name, &x.Status, &x.Role, &x.Scope,
				&x.Device, &x.AppVer, &seen) == nil {
				if seen != nil {
					x.LastSeen = seen.UTC().Format("02-01-2006 15:04")
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

func (a *App) adminTrash(w http.ResponseWriter, r *http.Request) {
	type row struct {
		ID                                                 int64
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
				x.DeletedAt = at.UTC().Format("02-01-2006 15:04")
				list = append(list, x)
			}
		}
		rows.Close()
	}
	renderAdmin(w, "trash", a.page(r, "Recycle bin", "trash", list))
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
				x.When = at.UTC().Format("02-01-2006 15:04")
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
				x.Created = at.UTC().Format("02-01-2006")
				list = append(list, x)
			}
		}
		rows.Close()
	}
	renderAdmin(w, "releases", a.page(r, "App releases", "releases", list))
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
:root{--bg:#0f1522;--card:#171f31;--line:#26314b;--tx:#dbe4f5;--dim:#8493b0;--acc:#4f8ef7;--ok:#2fbf71;--warn:#e5a53a;--bad:#e05656}
*{box-sizing:border-box;margin:0}body{background:var(--bg);color:var(--tx);font:15px/1.5 system-ui,'Segoe UI','Noto Sans Devanagari',sans-serif}
a{color:var(--acc);text-decoration:none}a:hover{text-decoration:underline}
.nav{display:flex;gap:4px;align-items:center;padding:10px 18px;background:var(--card);border-bottom:1px solid var(--line);flex-wrap:wrap;position:sticky;top:0}
.nav .brand{font-weight:700;margin-right:14px}
.nav a{padding:6px 12px;border-radius:8px;color:var(--dim)}
.nav a.on{background:var(--bg);color:var(--tx)}
.nav .sp{flex:1}
.wrap{max-width:1200px;margin:22px auto;padding:0 18px}
.banner{background:#3a2f16;border:1px solid #6b5620;color:#e8c56b;border-radius:10px;padding:10px 14px;margin-bottom:18px;font-size:14px}
.cards{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:12px;margin-bottom:22px}
.card{background:var(--card);border:1px solid var(--line);border-radius:12px;padding:14px 16px}
.card b{display:block;font-size:26px}.card span{color:var(--dim);font-size:13px}
table{width:100%;border-collapse:collapse;background:var(--card);border:1px solid var(--line);border-radius:12px;overflow:hidden}
th,td{padding:9px 12px;text-align:left;border-bottom:1px solid var(--line);font-size:14px}
th{color:var(--dim);font-weight:600;font-size:12px;text-transform:uppercase;letter-spacing:.4px}
tr:last-child td{border-bottom:none}
.tag{display:inline-block;padding:2px 9px;border-radius:20px;font-size:12px}
.tag.ok{background:#143726;color:#5ade9c}.tag.bad{background:#3a1a1a;color:#f08a8a}.tag.warn{background:#3a2f16;color:#e8c56b}.tag.dim{background:#232c42;color:var(--dim)}
h2{margin:22px 0 10px;font-size:17px}
form.search{display:flex;gap:8px;margin-bottom:16px;flex-wrap:wrap}
input,select{background:var(--bg);border:1px solid var(--line);color:var(--tx);border-radius:8px;padding:8px 12px;font:inherit}
button{background:var(--acc);border:none;color:#fff;border-radius:8px;padding:8px 16px;font:inherit;cursor:pointer}
.pager{display:flex;gap:10px;margin:14px 0;align-items:center;color:var(--dim)}
pre{background:var(--bg);border:1px solid var(--line);border-radius:10px;padding:14px;overflow-x:auto;font-size:13px}
.grid2{display:grid;grid-template-columns:1fr 1fr;gap:18px}@media(max-width:900px){.grid2{grid-template-columns:1fr}}
.kv td:first-child{color:var(--dim);width:180px}
.login{max-width:360px;margin:12vh auto;background:var(--card);border:1px solid var(--line);border-radius:14px;padding:28px}
.login h1{font-size:20px;margin-bottom:16px}.login input,.login button{width:100%;margin-top:10px}
.err{color:var(--bad);margin-top:10px;font-size:14px}
.msg{background:#143726;border:1px solid #1f6b45;color:#5ade9c;border-radius:10px;padding:10px 14px;margin-bottom:18px;font-size:14px}
form.inline{display:inline-flex;gap:6px;align-items:center;flex-wrap:wrap;margin:2px 0}
button.sm{padding:5px 10px;font-size:13px}
button.danger{background:var(--bad)}button.gray{background:#33415e}
select.sm,input.sm{padding:5px 8px;font-size:13px}
.barrow td{padding:5px 12px}
.bar{background:var(--acc);height:10px;border-radius:4px;min-width:2px}
.bar.ok{background:var(--ok)}
.scrolly{max-height:520px;overflow-y:auto;border-radius:12px}
</style></head><body>{{end}}

{{define "nav"}}
<div class="nav"><span class="brand">🚔 CRMS Admin</span>
<a href="/admin" class="{{if eq .Active "dashboard"}}on{{end}}">Dashboard</a>
<a href="/admin/analytics" class="{{if eq .Active "analytics"}}on{{end}}">Analytics</a>
<a href="/admin/firs" class="{{if eq .Active "firs"}}on{{end}}">FIRs</a>
<a href="/admin/users" class="{{if eq .Active "users"}}on{{end}}">Users</a>
<a href="/admin/org" class="{{if eq .Active "org"}}on{{end}}">Organization</a>
<a href="/admin/trash" class="{{if eq .Active "trash"}}on{{end}}">Recycle bin</a>
<a href="/admin/deletions" class="{{if eq .Active "deletions"}}on{{end}}">Deletion log</a>
<a href="/admin/releases" class="{{if eq .Active "releases"}}on{{end}}">Releases</a>
<span class="sp"></span><a href="/admin/logout">Logout</a></div>
<div class="wrap">
{{if .Msg}}<div class="msg">✓ {{.Msg}}</div>{{end}}
{{if .MirrorMode}}<div class="banner">🔄 <b>Rollout mode</b> — new records from the old server are still being pulled in{{if .LastSync}} (last pull {{.LastSync}}){{end}}. This panel is now the main one: changes made here stay.</div>{{end}}
{{end}}

{{define "foot"}}</div></body></html>{{end}}

{{define "login"}}{{template "head" .}}
<div class="login"><h1>🚔 CRMS Admin</h1>
<form method="post" action="/admin/login">
<input type="password" name="password" placeholder="Admin password" autofocus>
<button type="submit">Sign in</button>
{{if .Error}}<div class="err">{{.Error}}</div>{{end}}
</form></div></body></html>{{end}}

{{define "dashboard"}}{{template "head" .}}{{template "nav" .}}
{{with .Data}}
<div class="cards">
<div class="card"><b>{{.Total}}</b><span>Total FIRs</span></div>
<div class="card"><b>{{.Detected}}</b><span>Detected (उघड)</span></div>
<div class="card"><b>{{.Undetected}}</b><span>Undetected (न उघड)</span></div>
<div class="card"><b>{{.Unlinked}}</b><span>Not linked to a station</span></div>
<div class="card"><b>{{.Users}}</b><span>Users</span></div>
<div class="card"><b>{{.Pending}}</b><span>Pending approval</span></div>
<div class="card"><b>{{.Trash}}</b><span>In recycle bin</span></div>
</div>
<div class="grid2">
<div><h2>By zone</h2><table><tr><th>Zone</th><th>Total</th><th>Detected</th><th>Undetected</th></tr>
{{range .Zones}}<tr><td>{{.Name}}</td><td>{{.Total}}</td><td>{{.Detected}}</td><td>{{.Undetected}}</td></tr>{{end}}</table></div>
<div><h2>By station (top 25)</h2><table><tr><th>Station</th><th>Total</th><th>Detected</th><th>Undetected</th></tr>
{{range .Stations}}<tr><td>{{.Name}}</td><td>{{.Total}}</td><td>{{.Detected}}</td><td>{{.Undetected}}</td></tr>{{end}}</table></div>
</div>
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
<div class="card"><b>{{.Total}}</b><span>Total FIRs</span></div>
<div class="card"><b>{{.Detected}}</b><span>Detected (उघड)</span></div>
<div class="card"><b>{{.Undetected}}</b><span>Undetected (न उघड)</span></div>
<div class="card"><b>{{.DetectedPct}}%</b><span>Detection rate</span></div>
<div class="card"><b>{{.Chargesheeted}}</b><span>Chargesheeted (दोषारोपपत्र)</span></div>
<div class="card"><b>{{.Arrested}}</b><span>Arrested (अटक)</span></div>
<div class="card"><b>{{.Wanted}}</b><span>Wanted (पाहिजे)</span></div>
<div class="card"><b>{{.RecoveredFmt}}</b><span>Property recovered (मुद्देमाल)</span></div>
</div>
{{end}}
<div class="grid2">
<div><h2>Year-wise (detection trend)</h2>
<table>{{range .ByYear}}<tr class="barrow"><td style="width:60px">{{.Label}}</td>
<td style="width:70px">{{.Total}}</td><td style="width:60px">{{.Pct}}%</td>
<td><div class="bar" style="width:{{.Bar}}%"></div></td></tr>{{end}}</table></div>
<div><h2>Month-wise (last 24 months)</h2>
<table>{{range .ByMonth}}<tr class="barrow"><td style="width:80px">{{.Label}}</td>
<td style="width:70px">{{.Total}}</td><td style="width:60px">{{.Pct}}%</td>
<td><div class="bar ok" style="width:{{.Bar}}%"></div></td></tr>{{end}}</table></div>
</div>
<div class="grid2">
<div><h2>Top crime types</h2>
<table>{{range .ByType}}<tr class="barrow"><td style="max-width:200px">{{.Label}}</td>
<td style="width:70px">{{.Total}}</td><td style="width:60px">{{.Pct}}%</td>
<td><div class="bar" style="width:{{.Bar}}%"></div></td></tr>{{end}}</table></div>
<div><h2>Station league (detection rate)</h2>
<div class="scrolly"><table><tr><th>Station</th><th>Total</th><th>Detected</th><th>Rate</th></tr>
{{range .ByStation}}<tr><td>{{.Label}}</td><td>{{.Total}}</td><td>{{.Detected}}</td><td>{{.Pct}}%</td></tr>{{end}}</table></div></div>
</div>
<h2>Data quality (fix these to make every report accurate)</h2>
<div class="cards">
<div class="card"><b>{{.NoStation}}</b><span>Not linked to a station (Re-link on Organization page)</span></div>
<div class="card"><b>{{.NoFirNo}}</b><span>Missing FIR number</span></div>
<div class="card"><b>{{.NoDate}}</b><span>Missing registration date (excluded from month trend)</span></div>
<div class="card"><b>{{.NoType}}</b><span>Missing crime type</span></div>
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
<div class="pager"><span>{{.Total}} records</span><span class="sp" style="flex:1"></span>
<form method="post" action="/admin/fir/delete_bulk" onsubmit="return confirm('Move ALL {{.Total}} FIRs matching this search to the recycle bin? They will also be removed from the station apps on their next sync. You can restore them from the recycle bin.')">
<input type="hidden" name="all" value="1"><input type="hidden" name="q" value="{{.Q}}">
<input type="hidden" name="year" value="{{.Year}}"><input type="hidden" name="status" value="{{.Status}}">
<button class="sm danger">🗑 Delete ALL {{.Total}} matching</button></form></div>
<form method="post" action="/admin/fir/delete_bulk" onsubmit="return confirm('Move the selected FIRs to the recycle bin? They will also be removed from the station apps on their next sync.')">
<table><tr><th><input type="checkbox" onclick="document.querySelectorAll('input[name=ids]').forEach(c=>c.checked=this.checked)"></th><th>FIR</th><th>Year</th><th>Station</th><th>Type</th><th>Sections</th><th>Status</th><th>Registered</th><th>Owner</th></tr>
{{range .Rows}}<tr>
<td><input type="checkbox" name="ids" value="{{.ID}}"></td>
<td><a href="/admin/fir?id={{.ID}}">{{if .FirNo}}{{.FirNo}}{{else}}#{{.ID}}{{end}}</a></td>
<td>{{.Year}}</td><td>{{.Station}}</td><td>{{.CrimeType}}</td><td>{{.Section}}</td>
<td>{{if eq .Status "detected"}}<span class="tag ok">detected</span>{{else if .Status}}<span class="tag warn">{{.Status}}</span>{{else}}<span class="tag dim">—</span>{{end}}</td>
<td>{{.Registered}}</td><td>{{.Owner}}</td></tr>{{end}}</table>
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
<table><tr><th>Email</th><th>Status</th><th>Access</th><th>Role &amp; scope</th><th>Device</th><th>App</th><th>Last seen (UTC)</th></tr>
{{range .Data.Users}}<tr>
<td>{{.Email}}{{if .Name}}<br><small style="color:var(--dim)">{{.Name}}</small>{{end}}</td>
<td>{{if eq .Status "approved"}}<span class="tag ok">approved</span>{{else if eq .Status "pending"}}<span class="tag warn">pending</span>{{else}}<span class="tag bad">{{.Status}}</span>{{end}}
{{if .Scope}}<br><small style="color:var(--dim)">{{.Scope}}</small>{{end}}</td>
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
<option value="hq" {{if eq .Role "hq"}}selected{{end}}>HQ — all stations (entry + view)</option>
</select>
<select name="scope_zone_id" class="sm"><option value="">zone (DCP)…</option>{{range $zones}}<option value="{{.ID}}">{{.Name}}</option>{{end}}</select>
<select name="scope_division_id" class="sm"><option value="">division (ACP)…</option>{{range $divs}}<option value="{{.ID}}">{{.Name}}</option>{{end}}</select>
<select name="scope_station_id" class="sm"><option value="">station…</option>{{range $sts}}<option value="{{.ID}}">{{.Name}}</option>{{end}}</select>
<button class="sm">Save</button></form></td>
<td>{{.Device}}</td><td>{{.AppVer}}</td><td>{{.LastSeen}}</td></tr>{{end}}</table>
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
<td>{{.Firs}}</td><td></td></tr>{{end}}
</table>{{end}}{{end}}
<h2>Add a station</h2>
<form class="search" method="post" action="/admin/org/station/add">
<input name="name" placeholder="Station name (English)" required>
<input name="name_mr" placeholder="Marathi name">
<input name="code" placeholder="alias / code">
<select name="division_id"><option value="">No division</option>{{range .DivOpts}}<option value="{{.ID}}">{{.Name}}</option>{{end}}</select>
<button>Add</button></form>
{{if .Unlinked}}<h2>⚠ Station names not linked to any station</h2>
<table><tr><th>Uploaded name</th><th>FIRs</th></tr>
{{range .Unlinked}}<tr><td>{{.Name}}</td><td>{{.N}}</td></tr>{{end}}</table>{{end}}
{{end}}{{template "foot" .}}{{end}}

{{define "trash"}}{{template "head" .}}{{template "nav" .}}
<div style="display:flex;gap:10px;margin-bottom:12px;flex-wrap:wrap">
<form method="post" action="/admin/trash/restore_bulk" onsubmit="return confirm('Restore EVERYTHING in the recycle bin?')">
<input type="hidden" name="all" value="1"><button class="gray">↩ Restore ALL</button></form>
<form method="post" action="/admin/trash/purge" onsubmit="return confirm('PERMANENTLY delete everything in the recycle bin? This CANNOT be undone — the records are gone forever.')">
<input type="hidden" name="all" value="1"><button class="danger">🔥 Clear recycle bin (forever)</button></form>
</div>
<form method="post">
<table><tr><th><input type="checkbox" onclick="document.querySelectorAll('input[name=ids]').forEach(c=>c.checked=this.checked)"></th><th>FIR</th><th>Year</th><th>Station</th><th>Owner</th><th>Deleted by</th><th>When (UTC)</th></tr>
{{range .Data}}<tr><td><input type="checkbox" name="ids" value="{{.ID}}"></td>
<td>{{.FirNo}}</td><td>{{.Year}}</td><td>{{.Station}}</td><td>{{.Owner}}</td><td>{{.DeletedBy}}</td><td>{{.DeletedAt}}</td></tr>{{end}}</table>
<div class="pager">
<button class="sm gray" formaction="/admin/trash/restore_bulk" onclick="return confirm('Restore the selected FIRs?')">↩ Restore selected</button>
<button class="sm danger" formaction="/admin/trash/purge" onclick="return confirm('PERMANENTLY delete the selected FIRs? This CANNOT be undone.')">🔥 Delete selected forever</button>
</div>
</form>
{{template "foot" .}}{{end}}

{{define "deletions"}}{{template "head" .}}{{template "nav" .}}
<table><tr><th>FIR</th><th>Year</th><th>Station</th><th>Deleted by</th><th>Device</th><th>IP</th><th>When (UTC)</th></tr>
{{range .Data}}<tr><td>{{.FirNo}}</td><td>{{.Year}}</td><td>{{.Station}}</td><td>{{.Owner}}</td><td>{{.Device}}</td><td>{{.IP}}</td><td>{{.When}}</td></tr>{{end}}</table>
{{template "foot" .}}{{end}}

{{define "releases"}}{{template "head" .}}{{template "nav" .}}
<h2>Publish an update</h2>
<form class="search" method="post" action="/admin/release/upload" enctype="multipart/form-data">
<input type="file" name="file" required>
<input name="notes" placeholder="Release notes (optional)" style="flex:1;min-width:200px">
<label style="display:flex;align-items:center;gap:6px"><input type="checkbox" name="mandatory">Mandatory</label>
<button>⬆ Publish</button></form>
<p style="color:var(--dim);font-size:13px;margin-bottom:14px">File name must contain the version, e.g. <i>crms-setup-1.13.0.exe</i>. Apps see the update on their next launch.</p>
<table><tr><th>Version</th><th>Build</th><th>Platform</th><th>File</th><th>Mandatory</th><th>Published</th></tr>
{{range .Data}}<tr><td>{{.Version}}</td><td>{{.Build}}</td><td>{{.Platform}}</td><td>{{.File}}</td>
<td>{{if .Mandatory}}<span class="tag warn">yes</span>{{else}}no{{end}}</td><td>{{.Created}}</td></tr>{{end}}</table>
{{template "foot" .}}{{end}}
`
