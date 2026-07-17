package main

// Command messaging: senior officers send orders/notes from the app to a
// zone, a division, a station, one user, or everyone; station apps pull their
// inbox. Rank decides reach (enforced HERE, never trusted from the client):
//   cp / hq → anywhere (zone / division / station / user / all)
//   dcp     → anything inside their zone (no "all")
//   acp     → anything inside their division (no "all", no zone)
//   station → cannot send
// Receiving: a user gets "all" + messages to them + messages to their own
// station / division / zone chain (per their role scope).

import (
	"fmt"
	"net/http"
	"strings"
	"time"
)

// orgChain resolves which zone/division/station ids a user belongs to for
// RECEIVING messages.
func (a *App) orgChain(r *http.Request, u *accessUser) (stations, divisions, zones []int64) {
	ctx := r.Context()
	addStationChain := func(stID int64) {
		stations = append(stations, stID)
		var divID, zoneID *int64
		_ = a.db.QueryRow(ctx, `
			SELECT s.division_id, d.zone_id
			  FROM org_stations s LEFT JOIN org_divisions d ON d.id = s.division_id
			 WHERE s.id = $1`, stID).Scan(&divID, &zoneID)
		if divID != nil {
			divisions = append(divisions, *divID)
		}
		if zoneID != nil {
			zones = append(zones, *zoneID)
		}
	}
	switch u.Role {
	case "station":
		if u.ScopeStationID != nil {
			addStationChain(*u.ScopeStationID)
		}
	case "acp":
		if u.ScopeDivisionID != nil {
			divisions = append(divisions, *u.ScopeDivisionID)
			var zoneID *int64
			_ = a.db.QueryRow(ctx, `SELECT zone_id FROM org_divisions WHERE id = $1`,
				*u.ScopeDivisionID).Scan(&zoneID)
			if zoneID != nil {
				zones = append(zones, *zoneID)
			}
		}
	case "dcp":
		if u.ScopeZoneID != nil {
			zones = append(zones, *u.ScopeZoneID)
		}
	}
	return
}

// handleMessages returns the caller's inbox (messages newer than since_id).
func (a *App) handleMessages(w http.ResponseWriter, r *http.Request) {
	body := jsonBody(r)
	email := strings.ToLower(bodyStr(body, "email"))
	u, err := a.requireApprovedUser(r.Context(), email)
	if err != nil {
		respondStatus(w, 403, map[string]any{"ok": false, "message": "access.error.notApproved"})
		return
	}
	sinceID, _ := bodyInt(body, "since_id")
	stations, divisions, zones := a.orgChain(r, u)

	rows, err := a.db.Query(r.Context(), `
		SELECT id, sender_email, COALESCE(sender_name, ''), sender_role,
		       target_type, target_label, body, created_at
		  FROM messages
		 WHERE id > $1 AND (
		       target_type = 'all'
		    OR (target_type = 'user' AND target_email = $2)
		    OR (target_type = 'station' AND target_id = ANY($3))
		    OR (target_type = 'division' AND target_id = ANY($4))
		    OR (target_type = 'zone' AND target_id = ANY($5)))
		 ORDER BY id DESC LIMIT 200`,
		sinceID, u.Email, stations, divisions, zones)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "server"})
		return
	}
	defer rows.Close()
	list := []map[string]any{}
	for rows.Next() {
		var (
			id                                       int64
			from, fromName, fromRole, tType, tLabel, msg string
			at                                       time.Time
		)
		if rows.Scan(&id, &from, &fromName, &fromRole, &tType, &tLabel, &msg, &at) != nil {
			continue
		}
		list = append(list, map[string]any{
			"id": id, "from": from, "from_name": fromName,
			"from_role": fromRole, "target_type": tType, "target": tLabel,
			"body": msg, "at": at.UTC().Format(time.RFC3339),
		})
	}
	respond(w, map[string]any{"ok": true, "messages": list})
}

// senderCanTarget enforces rank reach; returns the human target label.
func (a *App) senderCanTarget(r *http.Request, u *accessUser,
	tType string, tID int64, tEmail string) (string, bool) {
	ctx := r.Context()
	nameOf := func(table string, id int64) (string, bool) {
		var n string
		err := a.db.QueryRow(ctx,
			fmt.Sprintf(`SELECT name FROM %s WHERE id = $1`, table), id).Scan(&n)
		return n, err == nil
	}
	zoneOfDivision := func(id int64) int64 {
		var z *int64
		_ = a.db.QueryRow(ctx, `SELECT zone_id FROM org_divisions WHERE id = $1`, id).Scan(&z)
		if z == nil {
			return 0
		}
		return *z
	}
	chainOfStation := func(id int64) (div, zone int64) {
		var d, z *int64
		_ = a.db.QueryRow(ctx, `
			SELECT s.division_id, dv.zone_id
			  FROM org_stations s LEFT JOIN org_divisions dv ON dv.id = s.division_id
			 WHERE s.id = $1`, id).Scan(&d, &z)
		if d != nil {
			div = *d
		}
		if z != nil {
			zone = *z
		}
		return
	}
	// Where does the TARGET USER sit (for user-targeted scope checks)?
	userInScope := func(email string) bool {
		if u.Role == "cp" || u.Role == "hq" {
			return true
		}
		tu := &accessUser{}
		err := a.db.QueryRow(ctx, `
			SELECT id, email, status, role, hwid, expires_at,
			       scope_zone_id, scope_division_id, scope_station_id
			  FROM access_users WHERE email = $1`, email,
		).Scan(&tu.ID, &tu.Email, &tu.Status, &tu.Role, &tu.Hwid, &tu.ExpiresAt,
			&tu.ScopeZoneID, &tu.ScopeDivisionID, &tu.ScopeStationID)
		if err != nil {
			return false
		}
		var tZone, tDiv int64
		if tu.ScopeStationID != nil {
			tDiv, tZone = chainOfStation(*tu.ScopeStationID)
		} else if tu.ScopeDivisionID != nil {
			tDiv, tZone = *tu.ScopeDivisionID, zoneOfDivision(*tu.ScopeDivisionID)
		} else if tu.ScopeZoneID != nil {
			tZone = *tu.ScopeZoneID
		}
		if u.Role == "dcp" {
			return u.ScopeZoneID != nil && tZone == *u.ScopeZoneID
		}
		return u.ScopeDivisionID != nil && tDiv == *u.ScopeDivisionID // acp
	}

	top := u.Role == "cp" || u.Role == "hq"
	switch tType {
	case "all":
		if !top {
			return "", false
		}
		return "All", true
	case "zone":
		n, ok := nameOf("org_zones", tID)
		if !ok {
			return "", false
		}
		if !top && !(u.Role == "dcp" && u.ScopeZoneID != nil && *u.ScopeZoneID == tID) {
			return "", false
		}
		return "Zone: " + n, true
	case "division":
		n, ok := nameOf("org_divisions", tID)
		if !ok {
			return "", false
		}
		switch {
		case top:
		case u.Role == "dcp":
			if u.ScopeZoneID == nil || zoneOfDivision(tID) != *u.ScopeZoneID {
				return "", false
			}
		case u.Role == "acp":
			if u.ScopeDivisionID == nil || *u.ScopeDivisionID != tID {
				return "", false
			}
		default:
			return "", false
		}
		return "Division: " + n, true
	case "station":
		n, ok := nameOf("org_stations", tID)
		if !ok {
			return "", false
		}
		div, zone := chainOfStation(tID)
		switch {
		case top:
		case u.Role == "dcp":
			if u.ScopeZoneID == nil || zone != *u.ScopeZoneID {
				return "", false
			}
		case u.Role == "acp":
			if u.ScopeDivisionID == nil || div != *u.ScopeDivisionID {
				return "", false
			}
		default:
			return "", false
		}
		return "Station: " + n, true
	case "user":
		if tEmail == "" || !userInScope(tEmail) {
			return "", false
		}
		return "User: " + tEmail, true
	}
	return "", false
}

// handleMessageSend stores a message after checking the sender's reach.
func (a *App) handleMessageSend(w http.ResponseWriter, r *http.Request) {
	body := jsonBody(r)
	email := strings.ToLower(bodyStr(body, "email"))
	u, err := a.requireApprovedUser(r.Context(), email)
	if err != nil {
		respondStatus(w, 403, map[string]any{"ok": false, "message": "access.error.notApproved"})
		return
	}
	if u.Role == "station" {
		respondStatus(w, 403, map[string]any{"ok": false, "message": "messages.error.rank"})
		return
	}
	text := strings.TrimSpace(bodyStr(body, "body"))
	if text == "" || len(text) > 4000 {
		respondStatus(w, 400, map[string]any{"ok": false, "message": "messages.error.body"})
		return
	}
	tType := bodyStr(body, "target_type")
	tID64 := int64(0)
	if id, ok := bodyInt(body, "target_id"); ok {
		tID64 = int64(id)
	}
	tEmail := strings.ToLower(bodyStr(body, "target_email"))

	label, ok := a.senderCanTarget(r, u, tType, tID64, tEmail)
	if !ok {
		respondStatus(w, 403, map[string]any{"ok": false, "message": "messages.error.scope"})
		return
	}
	var senderName *string
	_ = a.db.QueryRow(r.Context(),
		`SELECT name FROM access_users WHERE email = $1`, u.Email).Scan(&senderName)
	var tIDPtr *int64
	if tType == "zone" || tType == "division" || tType == "station" {
		tIDPtr = &tID64
	}
	var tEmailPtr *string
	if tType == "user" {
		tEmailPtr = &tEmail
	}
	var id int64
	err = a.db.QueryRow(r.Context(), `
		INSERT INTO messages (sender_email, sender_name, sender_role,
		                      target_type, target_id, target_email, target_label, body)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING id`,
		u.Email, senderName, u.Role, tType, tIDPtr, tEmailPtr, label, text).Scan(&id)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "server"})
		return
	}
	respond(w, map[string]any{"ok": true, "id": id, "target": label})
}

// handleMessageUsers lists the approved users a sender may target
// individually (compose screen dropdown), scope-filtered by rank.
func (a *App) handleMessageUsers(w http.ResponseWriter, r *http.Request) {
	body := jsonBody(r)
	email := strings.ToLower(bodyStr(body, "email"))
	u, err := a.requireApprovedUser(r.Context(), email)
	if err != nil || u.Role == "station" {
		respondStatus(w, 403, map[string]any{"ok": false, "message": "access.error.notApproved"})
		return
	}
	rows, err := a.db.Query(r.Context(), `
		SELECT u.email, COALESCE(u.name, ''), u.role,
		       COALESCE(s.name, COALESCE(d.name, COALESCE(z.name, '')))
		  FROM access_users u
		  LEFT JOIN org_zones z ON z.id = u.scope_zone_id
		  LEFT JOIN org_divisions d ON d.id = u.scope_division_id
		  LEFT JOIN org_stations s ON s.id = u.scope_station_id
		 WHERE u.status = 'approved' AND u.email <> $1
		 ORDER BY u.email`, u.Email)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "server"})
		return
	}
	defer rows.Close()
	list := []map[string]any{}
	for rows.Next() {
		var em, name, role, scope string
		if rows.Scan(&em, &name, &role, &scope) != nil {
			continue
		}
		// dcp/acp only see users inside their own reach.
		if u.Role == "dcp" || u.Role == "acp" {
			if _, ok := a.senderCanTarget(r, u, "user", 0, em); !ok {
				continue
			}
		}
		list = append(list, map[string]any{
			"email": em, "name": name, "role": role, "scope": scope,
		})
	}
	respond(w, map[string]any{"ok": true, "users": list})
}
