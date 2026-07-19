package main

import (
	"compress/gzip"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net"
	"net/http"
	"regexp"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

// App bundles the shared dependencies every handler needs.
type App struct {
	cfg Config
	db  *pgxpool.Pool
}

// openDB connects and creates the schema — the PostgreSQL translation of the
// MySQL tables in server/db.php. Data arrives via the Hostinger mirror (or
// directly from the apps once this server is primary), so there is no org seed
// here: org_zones/divisions/stations are mirrored from the existing install.
func openDB(ctx context.Context, url string) (*pgxpool.Pool, error) {
	pool, err := pgxpool.New(ctx, url)
	if err != nil {
		return nil, err
	}
	if err := pool.Ping(ctx); err != nil {
		return nil, err
	}
	for _, ddl := range schema {
		if _, err := pool.Exec(ctx, ddl); err != nil {
			return nil, fmt.Errorf("schema: %w\nin: %s", err, ddl)
		}
	}
	return pool, nil
}

var schema = []string{
	`CREATE TABLE IF NOT EXISTS access_users (
		id                BIGSERIAL PRIMARY KEY,
		email             TEXT NOT NULL UNIQUE,
		name              TEXT,
		status            TEXT NOT NULL DEFAULT 'pending',
		hwid              TEXT,
		role              TEXT NOT NULL DEFAULT 'station',
		scope_zone_id     BIGINT,
		scope_division_id BIGINT,
		scope_station_id  BIGINT,
		requested_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
		decided_at        TIMESTAMPTZ,
		expires_at        TIMESTAMPTZ,
		last_seen_at      TIMESTAMPTZ,
		last_ip           TEXT,
		user_agent        TEXT,
		client_platform   TEXT,
		client_os         TEXT,
		client_device     TEXT,
		app_version       TEXT
	)`,
	`CREATE TABLE IF NOT EXISTS org_zones (
		id      BIGINT PRIMARY KEY,
		name    TEXT NOT NULL,
		name_mr TEXT,
		sort    INT NOT NULL DEFAULT 0
	)`,
	`CREATE TABLE IF NOT EXISTS org_divisions (
		id      BIGINT PRIMARY KEY,
		zone_id BIGINT NOT NULL,
		name    TEXT NOT NULL,
		name_mr TEXT,
		sort    INT NOT NULL DEFAULT 0
	)`,
	`CREATE TABLE IF NOT EXISTS org_stations (
		id          BIGINT PRIMARY KEY,
		division_id BIGINT,
		name        TEXT NOT NULL,
		name_mr     TEXT,
		code        TEXT,
		sort        INT NOT NULL DEFAULT 0
	)`,
	`CREATE TABLE IF NOT EXISTS central_crimes (
		id              BIGSERIAL PRIMARY KEY,
		owner_email     TEXT NOT NULL,
		remote_uid      TEXT NOT NULL,
		station_id      BIGINT,
		station_name    TEXT,
		fir_no          TEXT,
		year            INT,
		crime_type      TEXT,
		section         TEXT,
		status          TEXT,
		date_occurred   DATE,
		date_registered DATE,
		data_json       JSONB,
		src_device      TEXT,
		src_platform    TEXT,
		src_os          TEXT,
		src_ip          TEXT,
		updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
		UNIQUE (owner_email, remote_uid)
	)`,
	`CREATE INDEX IF NOT EXISTS idx_crimes_station ON central_crimes (station_id)`,
	`CREATE INDEX IF NOT EXISTS idx_crimes_year ON central_crimes (year)`,
	`CREATE INDEX IF NOT EXISTS idx_crimes_status ON central_crimes (status)`,
	`CREATE INDEX IF NOT EXISTS idx_crimes_updated ON central_crimes (updated_at)`,
	`CREATE TABLE IF NOT EXISTS central_deletions (
		id           BIGSERIAL PRIMARY KEY,
		owner_email  TEXT NOT NULL,
		remote_uid   TEXT,
		fir_no       TEXT,
		year         INT,
		station_name TEXT,
		src_device   TEXT,
		src_platform TEXT,
		src_os       TEXT,
		src_ip       TEXT,
		deleted_at   TIMESTAMPTZ NOT NULL DEFAULT now()
	)`,
	`CREATE TABLE IF NOT EXISTS central_suppressed (
		owner_email   TEXT NOT NULL,
		remote_uid    TEXT NOT NULL,
		suppressed_at TIMESTAMPTZ NOT NULL DEFAULT now(),
		PRIMARY KEY (owner_email, remote_uid)
	)`,
	`CREATE TABLE IF NOT EXISTS central_trash (
		id              BIGSERIAL PRIMARY KEY,
		owner_email     TEXT NOT NULL,
		remote_uid      TEXT NOT NULL,
		station_id      BIGINT,
		station_name    TEXT,
		fir_no          TEXT,
		year            INT,
		crime_type      TEXT,
		section         TEXT,
		status          TEXT,
		date_occurred   DATE,
		date_registered DATE,
		data_json       JSONB,
		src_device      TEXT,
		src_platform    TEXT,
		src_os          TEXT,
		src_ip          TEXT,
		deleted_by      TEXT,
		deleted_at      TIMESTAMPTZ NOT NULL DEFAULT now()
	)`,
	`CREATE TABLE IF NOT EXISTS app_release (
		id         BIGSERIAL PRIMARY KEY,
		version    TEXT NOT NULL,
		build      INT NOT NULL,
		platform   TEXT NOT NULL DEFAULT 'windows',
		file_name  TEXT NOT NULL,
		notes      TEXT,
		mandatory  BOOLEAN NOT NULL DEFAULT false,
		sha256     TEXT,
		created_at TIMESTAMPTZ NOT NULL DEFAULT now()
	)`,
	`CREATE TABLE IF NOT EXISTS central_io_cases (
		id             BIGSERIAL PRIMARY KEY,
		owner_email    TEXT NOT NULL,
		remote_uid     TEXT NOT NULL,
		title          TEXT,
		crime_type     TEXT,
		crime_category TEXT,
		fir_no         TEXT,
		year           INT,
		district       TEXT,
		police_station TEXT,
		status         TEXT,
		data_json      JSONB,
		client_updated TIMESTAMPTZ,
		updated_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
		UNIQUE (owner_email, remote_uid)
	)`,
	// Mirror bookkeeping: high-water marks per source table.
	`CREATE TABLE IF NOT EXISTS mirror_state (
		tbl        TEXT PRIMARY KEY,
		last_sync  TIMESTAMPTZ,
		last_id    BIGINT NOT NULL DEFAULT 0
	)`,
	// Command messages: CP/DCP/ACP/HQ → zone / division / station / user / all.
	// target_label is rendered at send time so fetch and audit stay one query.
	`CREATE TABLE IF NOT EXISTS messages (
		id           BIGSERIAL PRIMARY KEY,
		sender_email TEXT NOT NULL,
		sender_name  TEXT,
		sender_role  TEXT NOT NULL,
		target_type  TEXT NOT NULL,
		target_id    BIGINT,
		target_email TEXT,
		target_label TEXT NOT NULL,
		body         TEXT NOT NULL,
		created_at   TIMESTAMPTZ NOT NULL DEFAULT now()
	)`,
	`CREATE INDEX IF NOT EXISTS idx_messages_id ON messages (id)`,

	// --- DB Square auth (replaces Google sign-in) --------------------------
	// Credentials are ISSUED BY AN ADMIN — nobody self-registers. access_users
	// stays the single source of truth for a user (role, scope, HWID binding,
	// access window); these columns add the login itself.
	`ALTER TABLE access_users
		ADD COLUMN IF NOT EXISTS login_id         TEXT,
		ADD COLUMN IF NOT EXISTS password_hash    TEXT,
		ADD COLUMN IF NOT EXISTS must_change_pw   BOOLEAN NOT NULL DEFAULT false,
		ADD COLUMN IF NOT EXISTS temp_expires_at  TIMESTAMPTZ,
		ADD COLUMN IF NOT EXISTS failed_attempts  INT NOT NULL DEFAULT 0,
		ADD COLUMN IF NOT EXISTS locked_until     TIMESTAMPTZ,
		ADD COLUMN IF NOT EXISTS pw_changed_at    TIMESTAMPTZ,
		ADD COLUMN IF NOT EXISTS designation      TEXT,
		ADD COLUMN IF NOT EXISTS gender           TEXT,
		ADD COLUMN IF NOT EXISTS phone            TEXT,
		ADD COLUMN IF NOT EXISTS recovery_email   TEXT,
		ADD COLUMN IF NOT EXISTS station_text     TEXT,
		ADD COLUMN IF NOT EXISTS request_note     TEXT,
		ADD COLUMN IF NOT EXISTS last_login_at    TIMESTAMPTZ,
		ADD COLUMN IF NOT EXISTS last_city        TEXT`,
	// Login IDs are case-insensitively unique. Partial index: rows that have no
	// login yet (pending requests, legacy Google users) don't collide on NULL.
	`CREATE UNIQUE INDEX IF NOT EXISTS idx_access_login_id
		ON access_users (lower(login_id)) WHERE login_id IS NOT NULL`,

	// Device-bound sessions. The app types a password once, then holds a token
	// that only works from the machine it was issued to.
	`CREATE TABLE IF NOT EXISTS auth_sessions (
		id           BIGSERIAL PRIMARY KEY,
		user_id      BIGINT NOT NULL REFERENCES access_users(id) ON DELETE CASCADE,
		token_hash   TEXT NOT NULL UNIQUE,
		hwid         TEXT NOT NULL,
		created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
		last_used_at TIMESTAMPTZ NOT NULL DEFAULT now(),
		expires_at   TIMESTAMPTZ,
		revoked_at   TIMESTAMPTZ,
		client_ip    TEXT,
		client_device TEXT,
		client_os    TEXT,
		app_version  TEXT
	)`,
	`CREATE INDEX IF NOT EXISTS idx_sessions_user ON auth_sessions (user_id)`,

	// Per-admin panel logins, so the audit trail names a person rather than
	// "whoever knew the shared password".
	`CREATE TABLE IF NOT EXISTS admin_users (
		id            BIGSERIAL PRIMARY KEY,
		username      TEXT NOT NULL UNIQUE,
		name          TEXT,
		password_hash TEXT NOT NULL,
		is_active     BOOLEAN NOT NULL DEFAULT true,
		must_change_pw BOOLEAN NOT NULL DEFAULT false,
		created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
		last_login_at TIMESTAMPTZ,
		last_ip       TEXT
	)`,

	// Security trail: logins, failures, device changes, resets, approvals.
	`CREATE TABLE IF NOT EXISTS login_audit (
		id          BIGSERIAL PRIMARY KEY,
		at          TIMESTAMPTZ NOT NULL DEFAULT now(),
		login_id    TEXT,
		email       TEXT,
		actor       TEXT,
		event       TEXT NOT NULL,
		detail      TEXT,
		ip          TEXT,
		hwid        TEXT,
		device      TEXT,
		os          TEXT,
		app_version TEXT
	)`,
	`CREATE INDEX IF NOT EXISTS idx_login_audit_at ON login_audit (at DESC)`,
	`CREATE INDEX IF NOT EXISTS idx_login_audit_login ON login_audit (login_id)`,
}

// --- Request helpers -------------------------------------------------------

// jsonBody decodes the request body into a generic map (like PHP's jsonBody()).
// Bodies sent with Content-Encoding: gzip (big uploads from the app) are
// decompressed transparently.
func jsonBody(r *http.Request) map[string]any {
	var reader io.Reader = r.Body
	if strings.EqualFold(r.Header.Get("Content-Encoding"), "gzip") {
		gz, err := gzip.NewReader(r.Body)
		if err != nil {
			return map[string]any{}
		}
		defer gz.Close()
		reader = gz
	}
	var m map[string]any
	if err := json.NewDecoder(reader).Decode(&m); err != nil || m == nil {
		return map[string]any{}
	}
	return m
}

func bodyStr(b map[string]any, key string) string {
	if v, ok := b[key]; ok && v != nil {
		return strings.TrimSpace(fmt.Sprintf("%v", v))
	}
	return ""
}

func bodyInt(b map[string]any, key string) (int, bool) {
	switch v := b[key].(type) {
	case float64:
		return int(v), true
	case string:
		var n int
		if _, err := fmt.Sscanf(strings.TrimSpace(v), "%d", &n); err == nil {
			return n, true
		}
	}
	return 0, false
}

// normStr trims and returns nil for empty — matches the PHP $norm closure.
func normStr(v string) *string {
	v = strings.TrimSpace(v)
	if v == "" {
		return nil
	}
	return &v
}

func truncate(s string, n int) string {
	if len(s) <= n {
		return s
	}
	return s[:n]
}

// parseDate accepts the formats the app and Excel imports produce
// (PHP strtotime equivalents we actually see): ISO dates/datetimes and
// d/m/Y or d-m-Y.
func parseDate(v string) *time.Time {
	v = strings.TrimSpace(v)
	if v == "" {
		return nil
	}
	layouts := []string{
		"2006-01-02T15:04:05.999999999Z07:00", "2006-01-02T15:04:05",
		"2006-01-02 15:04:05", "2006-01-02",
		"02/01/2006", "2/1/2006", "02-01-2006", "2-1-2006",
	}
	for _, l := range layouts {
		if t, err := time.Parse(l, v); err == nil {
			return &t
		}
	}
	return nil
}

// clientIP prefers the proxy headers Nginx / Tailscale set.
func clientIP(r *http.Request) string {
	if xf := r.Header.Get("X-Forwarded-For"); xf != "" {
		return strings.TrimSpace(strings.Split(xf, ",")[0])
	}
	if xr := r.Header.Get("X-Real-Ip"); xr != "" {
		return xr
	}
	host, _, err := net.SplitHostPort(r.RemoteAddr)
	if err != nil {
		return r.RemoteAddr
	}
	return host
}

// --- Station name normalization (mirror of normStationName in db.php and
// _normStation in bns_data.dart — keep the three in sync) -------------------

var (
	devanagariDigits = strings.NewReplacer(
		"०", "0", "१", "1", "२", "2", "३", "3", "४", "4",
		"५", "5", "६", "6", "७", "7", "८", "8", "९", "9",
	)
	stationTailRe = regexp.MustCompile(`(पोलीस|पोलिस)\s*(स्टेशन|ठाणे|स्टे)\.?|police\s*station|पो\.?\s*(स्टे|ठाणे)\.?`)
	stationSepRe  = regexp.MustCompile(`[\s.\-_,()]+`)
)

func normStationName(name string) string {
	name = devanagariDigits.Replace(name)
	name = strings.ToLower(name)
	name = stationTailRe.ReplaceAllString(name, "")
	return stationSepRe.ReplaceAllString(name, "")
}

// stationNameMap builds norm(name|name_mr|code) -> id, like the PHP helper.
func (a *App) stationNameMap(ctx context.Context) (map[string]int64, error) {
	rows, err := a.db.Query(ctx, `SELECT id, name, name_mr, code FROM org_stations`)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	m := map[string]int64{}
	for rows.Next() {
		var id int64
		var name string
		var nameMr, code *string
		if err := rows.Scan(&id, &name, &nameMr, &code); err != nil {
			return nil, err
		}
		for _, n := range []*string{&name, nameMr, code} {
			if n == nil || *n == "" {
				continue
			}
			if k := normStationName(*n); k != "" {
				m[k] = id
			}
		}
	}
	return m, rows.Err()
}

// --- Users and scopes -------------------------------------------------------

type accessUser struct {
	ID              int64
	Email           string
	Status          string
	Role            string
	Hwid            *string
	ExpiresAt       *time.Time
	ScopeZoneID     *int64
	ScopeDivisionID *int64
	ScopeStationID  *int64
}

var errNotApproved = errors.New("not approved")

// requireApprovedUser loads the user and rejects non-approved / expired ones —
// the Go twin of requireApprovedUser() in db.php.
func (a *App) requireApprovedUser(ctx context.Context, email string) (*accessUser, error) {
	u := &accessUser{}
	err := a.db.QueryRow(ctx, `
		SELECT id, email, status, role, hwid, expires_at,
		       scope_zone_id, scope_division_id, scope_station_id
		  FROM access_users WHERE email = $1`, email,
	).Scan(&u.ID, &u.Email, &u.Status, &u.Role, &u.Hwid, &u.ExpiresAt,
		&u.ScopeZoneID, &u.ScopeDivisionID, &u.ScopeStationID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, errNotApproved
		}
		return nil, err
	}
	if u.Status != "approved" {
		return nil, errNotApproved
	}
	if u.ExpiresAt != nil && u.ExpiresAt.Before(time.Now()) {
		return nil, errNotApproved
	}
	return u, nil
}

func (a *App) stationIDsInZone(ctx context.Context, zoneID int64) ([]int64, error) {
	return a.collectIDs(ctx, `
		SELECT s.id FROM org_stations s
		JOIN org_divisions d ON s.division_id = d.id
		WHERE d.zone_id = $1`, zoneID)
}

func (a *App) stationIDsInDivision(ctx context.Context, divID int64) ([]int64, error) {
	return a.collectIDs(ctx, `SELECT id FROM org_stations WHERE division_id = $1`, divID)
}

func (a *App) collectIDs(ctx context.Context, sql string, args ...any) ([]int64, error) {
	rows, err := a.db.Query(ctx, sql, args...)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	var out []int64
	for rows.Next() {
		var id int64
		if err := rows.Scan(&id); err != nil {
			return nil, err
		}
		out = append(out, id)
	}
	return out, rows.Err()
}

// baseStationIDs computes the stations a portal officer may read.
// nil = unrestricted (CP sees the whole city, including station-less rows).
// A station-role user with an assigned station reads exactly that station.
func (a *App) baseStationIDs(ctx context.Context, u *accessUser) ([]int64, error) {
	switch u.Role {
	case "cp", "hq":
		return nil, nil
	case "dcp":
		if u.ScopeZoneID == nil {
			return []int64{}, nil
		}
		return a.stationIDsInZone(ctx, *u.ScopeZoneID)
	case "acp":
		if u.ScopeDivisionID == nil {
			return []int64{}, nil
		}
		return a.stationIDsInDivision(ctx, *u.ScopeDivisionID)
	case "station":
		if u.ScopeStationID == nil {
			return []int64{}, nil
		}
		return []int64{*u.ScopeStationID}, nil
	}
	return []int64{}, nil
}

// effectiveStationIDs narrows the base scope by the request's most specific
// filter (station_id > division_id > zone_id), mirroring effectiveScope() +
// scopeWhere() in db.php. nil = no filtering (all rows).
func (a *App) effectiveStationIDs(ctx context.Context, u *accessUser, body map[string]any) ([]int64, error) {
	base, err := a.baseStationIDs(ctx, u)
	if err != nil {
		return nil, err
	}
	var requested []int64
	if id, ok := bodyInt(body, "station_id"); ok && id > 0 {
		requested = []int64{int64(id)}
	} else if id, ok := bodyInt(body, "division_id"); ok && id > 0 {
		requested, err = a.stationIDsInDivision(ctx, int64(id))
	} else if id, ok := bodyInt(body, "zone_id"); ok && id > 0 {
		requested, err = a.stationIDsInZone(ctx, int64(id))
	}
	if err != nil {
		return nil, err
	}
	if requested == nil {
		return base, nil
	}
	if base == nil {
		return requested, nil
	}
	allowed := map[int64]bool{}
	for _, id := range base {
		allowed[id] = true
	}
	out := []int64{}
	for _, id := range requested {
		if allowed[id] {
			out = append(out, id)
		}
	}
	return out, nil
}
