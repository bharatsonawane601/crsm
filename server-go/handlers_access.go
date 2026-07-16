package main

import (
	"context"
	"crypto/subtle"
	"encoding/json"
	"errors"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
)

// handleCheck is the app's launch check-in: registers unknown emails as
// pending, returns the approval status, enforces the subscription window and
// the one-device (HWID) binding. Mirrors server/check.php exactly.
func (a *App) handleCheck(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	email := strings.ToLower(bodyStr(b, "email"))
	hwid := bodyStr(b, "hwid")
	name := bodyStr(b, "name")

	ip := clientIP(r)
	ua := truncate(strings.TrimSpace(r.UserAgent()), 255)
	platform := truncate(strings.ToLower(bodyStr(b, "platform")), 20)
	clientOs := truncate(bodyStr(b, "os"), 160)
	device := truncate(bodyStr(b, "device"), 190)
	appVer := truncate(bodyStr(b, "app_version"), 40)

	if email == "" || hwid == "" {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	if a.cfg.VerifyGoogleToken {
		verified := verifyGoogleToken(ctx, bodyStr(b, "id_token"), a.cfg.GoogleClientID)
		if verified == "" || strings.ToLower(verified) != email {
			respond(w, map[string]any{"ok": false, "message": "access.error.server"})
			return
		}
	}

	var (
		id        int64
		status    string
		role      string
		boundHwid *string
		expiresAt *time.Time
	)
	err := a.db.QueryRow(ctx, `
		SELECT id, status, role, hwid, expires_at FROM access_users WHERE email = $1`,
		email).Scan(&id, &status, &role, &boundHwid, &expiresAt)
	if errors.Is(err, pgx.ErrNoRows) {
		_, err = a.db.Exec(ctx, `
			INSERT INTO access_users
				(email, name, hwid, status, last_seen_at,
				 last_ip, user_agent, client_platform, client_os, client_device, app_version)
			VALUES ($1, $2, $3, 'pending', now(), $4, $5, $6, $7, $8, $9)`,
			email, name, hwid, ip, ua, platform, clientOs, device, appVer)
		if err != nil {
			respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
			return
		}
		respond(w, map[string]any{"ok": true, "status": "pending"})
		return
	}
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	_, _ = a.db.Exec(ctx, `
		UPDATE access_users
		   SET last_seen_at = now(), last_ip = $1, user_agent = $2,
		       client_platform = $3, client_os = $4, client_device = $5, app_version = $6
		 WHERE id = $7`,
		ip, ua, platform, clientOs, device, appVer, id)

	if status == "denied" || status == "pending" {
		respond(w, map[string]any{"ok": true, "status": status})
		return
	}
	if expiresAt != nil && expiresAt.Before(time.Now()) {
		respond(w, map[string]any{"ok": true, "status": "expired"})
		return
	}
	if a.cfg.OneDevicePerEmail {
		if boundHwid == nil || *boundHwid == "" {
			_, _ = a.db.Exec(ctx, `UPDATE access_users SET hwid = $1 WHERE id = $2`, hwid, id)
		} else if subtle.ConstantTimeCompare([]byte(*boundHwid), []byte(hwid)) != 1 {
			respond(w, map[string]any{"ok": true, "status": "device_mismatch"})
			return
		}
	}

	respond(w, map[string]any{
		"ok":     true,
		"status": "approved",
		"role":   role,
		"portal": role == "acp" || role == "dcp" || role == "cp",
		"scope":  a.scopeLabels(ctx, email),
	})
}

// scopeLabels resolves the user's zone/division/station scope ids to names for
// the portal header.
func (a *App) scopeLabels(ctx context.Context, email string) map[string]any {
	out := map[string]any{"zone": nil, "division": nil, "station": nil}
	var zone, division, station *string
	err := a.db.QueryRow(ctx, `
		SELECT z.name, d.name, s.name
		  FROM access_users u
		  LEFT JOIN org_zones z ON z.id = u.scope_zone_id
		  LEFT JOIN org_divisions d ON d.id = u.scope_division_id
		  LEFT JOIN org_stations s ON s.id = u.scope_station_id
		 WHERE u.email = $1`, email).Scan(&zone, &division, &station)
	if err != nil {
		return out
	}
	if zone != nil {
		out["zone"] = *zone
	}
	if division != nil {
		out["division"] = *division
	}
	if station != nil {
		out["station"] = *station
	}
	return out
}

// verifyGoogleToken checks the id_token against Google's tokeninfo endpoint
// and returns the verified email ("" on any failure) — same as check.php.
func verifyGoogleToken(ctx context.Context, idToken, clientID string) string {
	if idToken == "" {
		return ""
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodGet,
		"https://oauth2.googleapis.com/tokeninfo?id_token="+url.QueryEscape(idToken), nil)
	if err != nil {
		return ""
	}
	res, err := http.DefaultClient.Do(req)
	if err != nil {
		return ""
	}
	defer res.Body.Close()
	var data map[string]any
	if json.NewDecoder(res.Body).Decode(&data) != nil {
		return ""
	}
	if aud, _ := data["aud"].(string); aud != clientID {
		return ""
	}
	switch v := data["email_verified"].(type) {
	case string:
		if v != "true" {
			return ""
		}
	case bool:
		if !v {
			return ""
		}
	default:
		return ""
	}
	email, _ := data["email"].(string)
	return email
}

// handleVersion returns the latest published release for ?platform= — the
// in-app updater endpoint (server/version.php).
func (a *App) handleVersion(w http.ResponseWriter, r *http.Request) {
	platform := strings.ToLower(strings.TrimSpace(r.URL.Query().Get("platform")))
	if platform != "macos" && platform != "linux" {
		platform = "windows"
	}
	var (
		version, fileName string
		build             int
		notes, sha256     *string
		mandatory         bool
	)
	err := a.db.QueryRow(r.Context(), `
		SELECT version, build, file_name, notes, mandatory, sha256
		  FROM app_release WHERE platform = $1
		 ORDER BY build DESC, id DESC LIMIT 1`, platform,
	).Scan(&version, &build, &fileName, &notes, &mandatory, &sha256)
	if err != nil {
		respond(w, map[string]any{"ok": true, "version": "", "build": 0})
		return
	}
	deref := func(s *string) string {
		if s == nil {
			return ""
		}
		return *s
	}
	// Same shape as releaseUrl() in db.php. While mirroring, the prefix points
	// at Hostinger's api/releases so downloads keep working from either server.
	fileURL := fileName
	if a.cfg.ReleaseURLPrefix != "" {
		fileURL = strings.TrimRight(a.cfg.ReleaseURLPrefix, "/") + "/" + url.PathEscape(fileName)
	}
	respond(w, map[string]any{
		"ok":        true,
		"version":   version,
		"build":     build,
		"notes":     deref(notes),
		"mandatory": mandatory,
		"sha256":    deref(sha256),
		"url":       fileURL,
	})
}
