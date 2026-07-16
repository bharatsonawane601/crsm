package main

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"strings"
	"time"
)

// portalUser loads the caller and enforces who may read central data: senior
// officers (acp/dcp/cp) across their jurisdiction, and station-role users with
// an admin-assigned station (their scope is exactly that one station). Writes
// the error response itself and returns nil when the caller may not proceed.
func (a *App) portalUser(w http.ResponseWriter, r *http.Request, b map[string]any) *accessUser {
	email := strings.ToLower(bodyStr(b, "email"))
	if email == "" {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return nil
	}
	u, err := a.requireApprovedUser(r.Context(), email)
	if err != nil {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return nil
	}
	stationScoped := u.Role == "station" && u.ScopeStationID != nil
	if u.Role != "acp" && u.Role != "dcp" && u.Role != "cp" && u.Role != "hq" && !stationScoped {
		respondStatus(w, http.StatusForbidden,
			map[string]any{"ok": false, "message": "access.error.server"})
		return nil
	}
	return u
}

// handlePortalScope returns the org hierarchy the officer may drill into:
// the legacy flat options tree plus the structured zones/divisions/stations
// lists for the cascading dropdowns (server/portal_scope.php).
func (a *App) handlePortalScope(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	u := a.portalUser(w, r, b)
	if u == nil {
		return
	}

	type opt = map[string]any
	options := []opt{}
	zones := []opt{}
	divisions := []opt{}
	stations := []opt{}

	nameOf := func(table string, id *int64) string {
		if id == nil || *id == 0 {
			return ""
		}
		var n string
		_ = a.db.QueryRow(ctx,
			fmt.Sprintf(`SELECT name FROM %s WHERE id = $1`, table), *id).Scan(&n)
		return n
	}

	addStations := func(divisionID int64, indent string) {
		rows, err := a.db.Query(ctx,
			`SELECT id, name FROM org_stations WHERE division_id = $1 ORDER BY sort, name`,
			divisionID)
		if err != nil {
			return
		}
		defer rows.Close()
		for rows.Next() {
			var id int64
			var name string
			if rows.Scan(&id, &name) == nil {
				options = append(options, opt{"label": indent + name, "type": "station", "id": id})
			}
		}
	}
	addDivisions := func(zoneID int64) {
		rows, err := a.db.Query(ctx,
			`SELECT id, name FROM org_divisions WHERE zone_id = $1 ORDER BY sort, id`, zoneID)
		if err != nil {
			return
		}
		type div struct {
			id   int64
			name string
		}
		var divs []div
		for rows.Next() {
			var d div
			if rows.Scan(&d.id, &d.name) == nil {
				divs = append(divs, d)
			}
		}
		rows.Close()
		for _, d := range divs {
			options = append(options, opt{"label": "   ↳ " + d.name + " (ACP)", "type": "division", "id": d.id})
			addStations(d.id, "        • ")
		}
	}

	switch u.Role {
	case "cp", "hq":
		options = append(options, opt{"label": "All city", "type": "all"})
		zrows, err := a.db.Query(ctx, `SELECT id, name FROM org_zones ORDER BY sort, id`)
		if err == nil {
			type zone struct {
				id   int64
				name string
			}
			var zs []zone
			for zrows.Next() {
				var z zone
				if zrows.Scan(&z.id, &z.name) == nil {
					zs = append(zs, z)
				}
			}
			zrows.Close()
			for _, z := range zs {
				options = append(options, opt{"label": z.name + " — whole zone", "type": "zone", "id": z.id})
				addDivisions(z.id)
				zones = append(zones, opt{"id": z.id, "name": z.name})
			}
		}
		// Stations without a division are visible to the CP only.
		urows, err := a.db.Query(ctx,
			`SELECT id, name FROM org_stations WHERE division_id IS NULL ORDER BY sort, name`)
		if err == nil {
			for urows.Next() {
				var id int64
				var name string
				if urows.Scan(&id, &name) == nil {
					options = append(options, opt{"label": "• " + name + " (unassigned)", "type": "station", "id": id})
				}
			}
			urows.Close()
		}
		drows, err := a.db.Query(ctx, `SELECT id, name, zone_id FROM org_divisions ORDER BY sort, id`)
		if err == nil {
			for drows.Next() {
				var id, zoneID int64
				var name string
				if drows.Scan(&id, &name, &zoneID) == nil {
					divisions = append(divisions, opt{"id": id, "name": name, "zone_id": zoneID})
				}
			}
			drows.Close()
		}
		srows, err := a.db.Query(ctx, `
			SELECT s.id, s.name, s.division_id, d.zone_id
			  FROM org_stations s LEFT JOIN org_divisions d ON s.division_id = d.id
			 ORDER BY s.sort, s.name`)
		if err == nil {
			for srows.Next() {
				var id int64
				var name string
				var divID, zoneID *int64
				if srows.Scan(&id, &name, &divID, &zoneID) == nil {
					stations = append(stations, opt{"id": id, "name": name, "division_id": divID, "zone_id": zoneID})
				}
			}
			srows.Close()
		}

	case "dcp":
		var zoneID int64
		if u.ScopeZoneID != nil {
			zoneID = *u.ScopeZoneID
		}
		zn := nameOf("org_zones", &zoneID)
		label := "zone"
		if zn != "" {
			label = zn
		}
		options = append(options, opt{"label": "All " + label + " — whole zone", "type": "zone", "id": zoneID})
		addDivisions(zoneID)
		if zn != "" {
			zones = append(zones, opt{"id": zoneID, "name": zn})
		}
		drows, err := a.db.Query(ctx,
			`SELECT id, name, zone_id FROM org_divisions WHERE zone_id = $1 ORDER BY sort, id`, zoneID)
		if err == nil {
			for drows.Next() {
				var id, zid int64
				var name string
				if drows.Scan(&id, &name, &zid) == nil {
					divisions = append(divisions, opt{"id": id, "name": name, "zone_id": zid})
				}
			}
			drows.Close()
		}
		srows, err := a.db.Query(ctx, `
			SELECT s.id, s.name, s.division_id, d.zone_id
			  FROM org_stations s JOIN org_divisions d ON s.division_id = d.id
			 WHERE d.zone_id = $1 ORDER BY s.sort, s.name`, zoneID)
		if err == nil {
			for srows.Next() {
				var id, divID, zid int64
				var name string
				if srows.Scan(&id, &name, &divID, &zid) == nil {
					stations = append(stations, opt{"id": id, "name": name, "division_id": divID, "zone_id": zid})
				}
			}
			srows.Close()
		}

	case "station":
		// Station user: the tree is exactly their one assigned station.
		var stID int64
		if u.ScopeStationID != nil {
			stID = *u.ScopeStationID
		}
		sn := nameOf("org_stations", &stID)
		if sn != "" {
			options = append(options, opt{"label": sn, "type": "station", "id": stID})
			var divID *int64
			_ = a.db.QueryRow(ctx,
				`SELECT division_id FROM org_stations WHERE id = $1`, stID).Scan(&divID)
			stations = append(stations, opt{"id": stID, "name": sn, "division_id": divID})
		}

	default: // acp
		var divID int64
		if u.ScopeDivisionID != nil {
			divID = *u.ScopeDivisionID
		}
		dn := nameOf("org_divisions", &divID)
		label := "division"
		if dn != "" {
			label = dn
		}
		options = append(options, opt{"label": "All " + label, "type": "division", "id": divID})
		addStations(divID, "   • ")
		var zoneID int64
		_ = a.db.QueryRow(ctx, `SELECT zone_id FROM org_divisions WHERE id = $1`, divID).Scan(&zoneID)
		if zoneID > 0 {
			if zn := nameOf("org_zones", &zoneID); zn != "" {
				zones = append(zones, opt{"id": zoneID, "name": zn})
			}
		}
		if dn != "" {
			divisions = append(divisions, opt{"id": divID, "name": dn, "zone_id": zoneID})
		}
		srows, err := a.db.Query(ctx,
			`SELECT id, name, division_id FROM org_stations WHERE division_id = $1 ORDER BY sort, name`, divID)
		if err == nil {
			for srows.Next() {
				var id, dID int64
				var name string
				if srows.Scan(&id, &name, &dID) == nil {
					stations = append(stations, opt{"id": id, "name": name, "division_id": dID, "zone_id": zoneID})
				}
			}
			srows.Close()
		}
	}

	respond(w, map[string]any{
		"ok":        true,
		"role":      u.Role,
		"options":   options,
		"zones":     zones,
		"divisions": divisions,
		"stations":  stations,
	})
}

// crimeRow scans one central_crimes row into the JSON shape the app expects
// (dates as YYYY-MM-DD strings, data_json decoded into "data").
type crimeRowScan struct {
	id           int64
	stationName  *string
	firNo        *string
	year         *int
	crimeType    *string
	section      *string
	status       *string
	dateOcc      *time.Time
	dateReg      *time.Time
	dataJSON     []byte
	updatedAt    *time.Time
	withUpdated  bool
}

func (c *crimeRowScan) toJSON() map[string]any {
	fmtD := func(t *time.Time) any {
		if t == nil {
			return nil
		}
		return t.Format("2006-01-02")
	}
	var data any
	if c.dataJSON != nil {
		_ = json.Unmarshal(c.dataJSON, &data)
	}
	m := map[string]any{
		"id":              c.id,
		"station_name":    c.stationName,
		"fir_no":          c.firNo,
		"year":            c.year,
		"crime_type":      c.crimeType,
		"section":         c.section,
		"status":          c.status,
		"date_occurred":   fmtD(c.dateOcc),
		"date_registered": fmtD(c.dateReg),
		"data":            data,
	}
	if c.withUpdated {
		var u any
		if c.updatedAt != nil {
			u = c.updatedAt.UTC().Format("2006-01-02 15:04:05")
		}
		m["updated_at"] = u
	}
	return m
}

// scopeClause renders the station scope into SQL. nil ids = no restriction.
func scopeClause(ids []int64, argOffset int) (string, []any) {
	if ids == nil {
		return "", nil
	}
	if len(ids) == 0 {
		// Officer with an empty scope sees nothing.
		return "1 = 0", nil
	}
	return fmt.Sprintf("c.station_id = ANY($%d)", argOffset), []any{ids}
}

// handlePortalSearch is the scope-filtered paged search (portal_search.php).
func (a *App) handlePortalSearch(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	u := a.portalUser(w, r, b)
	if u == nil {
		return
	}
	ids, err := a.effectiveStationIDs(ctx, u, b)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	where := []string{}
	args := []any{}
	if clause, cArgs := scopeClause(ids, len(args)+1); clause != "" {
		where = append(where, clause)
		args = append(args, cArgs...)
	}
	if q := bodyStr(b, "q"); q != "" {
		like := "%" + q + "%"
		where = append(where, fmt.Sprintf(
			`(c.fir_no ILIKE $%d OR c.section ILIKE $%d OR c.crime_type ILIKE $%d`+
				` OR c.station_name ILIKE $%d OR s.name ILIKE $%d)`,
			len(args)+1, len(args)+2, len(args)+3, len(args)+4, len(args)+5))
		args = append(args, like, like, like, like, like)
	}
	if year, ok := bodyInt(b, "year"); ok && year > 0 {
		where = append(where, fmt.Sprintf("c.year = $%d", len(args)+1))
		args = append(args, year)
	}
	if status := bodyStr(b, "status"); status != "" {
		where = append(where, fmt.Sprintf("c.status = $%d", len(args)+1))
		args = append(args, status)
	}
	if ct := bodyStr(b, "crime_type"); ct != "" {
		where = append(where, fmt.Sprintf("c.crime_type = $%d", len(args)+1))
		args = append(args, ct)
	}

	whereSQL := ""
	if len(where) > 0 {
		whereSQL = "WHERE " + strings.Join(where, " AND ")
	}
	fromSQL := `FROM central_crimes c LEFT JOIN org_stations s ON c.station_id = s.id`

	var total int
	if err := a.db.QueryRow(ctx,
		fmt.Sprintf("SELECT COUNT(*) %s %s", fromSQL, whereSQL), args...).Scan(&total); err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	pageSize, _ := bodyInt(b, "page_size")
	if pageSize < 1 {
		pageSize = 50
	}
	if pageSize > 200 {
		pageSize = 200
	}
	page, _ := bodyInt(b, "page")
	if page < 1 {
		page = 1
	}

	sql := fmt.Sprintf(`
		SELECT c.id, COALESCE(s.name, c.station_name) AS station_name, c.fir_no,
		       c.year, c.crime_type, c.section, c.status,
		       c.date_occurred, c.date_registered, c.data_json, c.updated_at
		%s %s
		ORDER BY c.date_registered DESC NULLS LAST, c.id DESC
		LIMIT %d OFFSET %d`, fromSQL, whereSQL, pageSize, (page-1)*pageSize)
	rows, err := a.db.Query(ctx, sql, args...)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	defer rows.Close()
	out := []map[string]any{}
	for rows.Next() {
		c := crimeRowScan{withUpdated: true}
		if err := rows.Scan(&c.id, &c.stationName, &c.firNo, &c.year, &c.crimeType,
			&c.section, &c.status, &c.dateOcc, &c.dateReg, &c.dataJSON, &c.updatedAt); err != nil {
			respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
			return
		}
		out = append(out, c.toJSON())
	}
	respond(w, map[string]any{
		"ok": true, "total": total, "page": page, "page_size": pageSize, "rows": out,
	})
}

// handlePortalRows streams every scope-filtered row for the dashboard, capped
// like the PHP version (portal_rows.php).
func (a *App) handlePortalRows(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	u := a.portalUser(w, r, b)
	if u == nil {
		return
	}
	ids, err := a.effectiveStationIDs(ctx, u, b)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	whereSQL := ""
	args := []any{}
	if clause, cArgs := scopeClause(ids, 1); clause != "" {
		whereSQL = "WHERE " + clause
		args = cArgs
	}
	rows, err := a.db.Query(ctx, fmt.Sprintf(`
		SELECT c.id, COALESCE(s.name, c.station_name) AS station_name, c.fir_no,
		       c.year, c.crime_type, c.section, c.status,
		       c.date_occurred, c.date_registered, c.data_json
		  FROM central_crimes c
		  LEFT JOIN org_stations s ON c.station_id = s.id
		  %s
		 ORDER BY c.id DESC
		 LIMIT 20000`, whereSQL), args...)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	defer rows.Close()
	out := []map[string]any{}
	for rows.Next() {
		c := crimeRowScan{}
		if err := rows.Scan(&c.id, &c.stationName, &c.firNo, &c.year, &c.crimeType,
			&c.section, &c.status, &c.dateOcc, &c.dateReg, &c.dataJSON); err != nil {
			respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
			return
		}
		out = append(out, c.toJSON())
	}
	respond(w, map[string]any{"ok": true, "rows": out})
}

// handlePortalCompare builds a KPI bundle per requested station / division /
// zone, intersected with the officer's own scope (portal_compare.php).
func (a *App) handlePortalCompare(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	u := a.portalUser(w, r, b)
	if u == nil {
		return
	}
	base, err := a.baseStationIDs(ctx, u)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	allow := func(stationIDs []int64) []int64 {
		if base == nil {
			return stationIDs
		}
		allowed := map[int64]bool{}
		for _, id := range base {
			allowed[id] = true
		}
		out := []int64{}
		for _, id := range stationIDs {
			if allowed[id] {
				out = append(out, id)
			}
		}
		return out
	}

	by := bodyStr(b, "by")
	if by != "zone" && by != "division" && by != "station" {
		by = "station"
	}
	rawIDs, _ := b["ids"].([]any)
	seen := map[int64]bool{}
	entIDs := []int64{}
	for _, v := range rawIDs {
		if f, ok := v.(float64); ok && f > 0 && !seen[int64(f)] {
			seen[int64(f)] = true
			entIDs = append(entIDs, int64(f))
		}
	}

	rows := []map[string]any{}
	for _, entID := range entIDs {
		var label string
		var stIDs []int64
		switch by {
		case "zone":
			_ = a.db.QueryRow(ctx, `SELECT name FROM org_zones WHERE id = $1`, entID).Scan(&label)
			ids, _ := a.stationIDsInZone(ctx, entID)
			stIDs = allow(ids)
		case "division":
			_ = a.db.QueryRow(ctx, `SELECT name FROM org_divisions WHERE id = $1`, entID).Scan(&label)
			ids, _ := a.stationIDsInDivision(ctx, entID)
			stIDs = allow(ids)
		default:
			_ = a.db.QueryRow(ctx, `SELECT name FROM org_stations WHERE id = $1`, entID).Scan(&label)
			stIDs = allow([]int64{entID})
		}
		if label == "" {
			label = fmt.Sprintf("#%d", entID)
		}
		kpi := a.compareKPI(ctx, stIDs)
		rows = append(rows, map[string]any{"id": entID, "label": label, "kpi": kpi})
	}
	respond(w, map[string]any{"ok": true, "by": by, "rows": rows})
}

func (a *App) compareKPI(ctx context.Context, stationIDs []int64) map[string]any {
	kpi := map[string]any{
		"total": 0, "detected": 0, "undetected": 0, "arrested": 0,
		"wanted": 0, "recovered": 0.0, "chargesheeted": 0,
	}
	if len(stationIDs) == 0 {
		return kpi
	}
	rows, err := a.db.Query(ctx,
		`SELECT status, data_json FROM central_crimes WHERE station_id = ANY($1)`, stationIDs)
	if err != nil {
		return kpi
	}
	defer rows.Close()
	var total, detected, undetected, arrested, wanted, chargesheeted int
	var recovered float64
	for rows.Next() {
		var status *string
		var dataJSON []byte
		if rows.Scan(&status, &dataJSON) != nil {
			continue
		}
		total++
		if status != nil && *status == "detected" {
			detected++
		} else {
			undetected++
		}
		if dataJSON != nil {
			var d map[string]any
			if json.Unmarshal(dataJSON, &d) == nil {
				arrested += asInt(d["arrested_count"])
				wanted += asInt(d["wanted_count"])
				recovered += asFloat(d["recovered_value"])
				if s, _ := d["chargesheet_date"].(string); s != "" {
					chargesheeted++
				}
			}
		}
	}
	kpi["total"] = total
	kpi["detected"] = detected
	kpi["undetected"] = undetected
	kpi["arrested"] = arrested
	kpi["wanted"] = wanted
	kpi["recovered"] = recovered
	kpi["chargesheeted"] = chargesheeted
	return kpi
}

func asInt(v any) int {
	switch n := v.(type) {
	case float64:
		return int(n)
	case string:
		var i int
		fmt.Sscanf(n, "%d", &i)
		return i
	}
	return 0
}

func asFloat(v any) float64 {
	switch n := v.(type) {
	case float64:
		return n
	case string:
		var f float64
		fmt.Sscanf(n, "%f", &f)
		return f
	}
	return 0
}
