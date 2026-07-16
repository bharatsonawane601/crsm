package main

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strings"
	"time"
)

// runMirror keeps this server's PostgreSQL copy in sync with the Hostinger PHP
// install by polling server/export.php. One-way: Hostinger stays the source of
// truth until cutover, so mirrored tables are overwritten locally each cycle.
func (a *App) runMirror(ctx context.Context) {
	// First sync immediately, then on the interval.
	for {
		start := time.Now()
		if err := a.mirrorOnce(ctx); err != nil {
			log.Printf("mirror: %v", err)
		} else {
			log.Printf("mirror: cycle ok in %s", time.Since(start).Round(time.Millisecond))
		}
		select {
		case <-ctx.Done():
			return
		case <-time.After(a.cfg.MirrorInterval):
		}
	}
}

func (a *App) mirrorOnce(ctx context.Context) error {
	// Order matters: org tree before crimes (station_id references), users
	// before everything user-scoped.
	small := []struct {
		table string
		pk    []string
		cols  []string
	}{
		{"org_zones", []string{"id"}, []string{"id", "name", "name_mr", "sort"}},
		{"org_divisions", []string{"id"}, []string{"id", "zone_id", "name", "name_mr", "sort"}},
		{"org_stations", []string{"id"}, []string{"id", "division_id", "name", "name_mr", "code", "sort"}},
		{"access_users", []string{"email"}, []string{
			"email", "name", "status", "hwid", "role",
			"scope_zone_id", "scope_division_id", "scope_station_id",
			"requested_at", "decided_at", "expires_at", "last_seen_at",
			"last_ip", "user_agent", "client_platform", "client_os", "client_device", "app_version"}},
		{"app_release", []string{"id"}, []string{
			"id", "version", "build", "platform", "file_name", "notes", "mandatory", "sha256", "created_at"}},
		{"central_suppressed", []string{"owner_email", "remote_uid"},
			[]string{"owner_email", "remote_uid", "suppressed_at"}},
		// Keyed on the source id: the same (owner, uid) can be deleted, restored
		// and deleted again, giving multiple trash rows.
		{"central_trash", []string{"id"}, []string{
			"id", "owner_email", "remote_uid", "station_id", "station_name", "fir_no", "year",
			"crime_type", "section", "status", "date_occurred", "date_registered",
			"data_json", "src_device", "src_platform", "src_os", "src_ip",
			"deleted_by", "deleted_at"}},
	}
	for _, t := range small {
		if err := a.mirrorSmallTable(ctx, t.table, t.pk, t.cols); err != nil {
			return fmt.Errorf("%s: %w", t.table, err)
		}
	}
	// Local station deletions insert into central_trash via the sequence; keep
	// it above the mirrored source ids so the two can never collide.
	_, _ = a.db.Exec(ctx, `SELECT setval(pg_get_serial_sequence('central_trash','id'),
		GREATEST((SELECT COALESCE(MAX(id), 0) FROM central_trash), 1))`)
	// central_deletions is append-only: pull all, insert the ones we miss.
	if err := a.mirrorDeletions(ctx); err != nil {
		return fmt.Errorf("central_deletions: %w", err)
	}
	for _, t := range []string{"central_crimes", "central_io_cases"} {
		if err := a.mirrorIncremental(ctx, t); err != nil {
			return fmt.Errorf("%s: %w", t, err)
		}
		// In transition mode records are being written on BOTH servers, so a
		// row missing at Hostinger may simply be one uploaded here — never
		// delete based on the source then.
		if a.cfg.MirrorMode != "transition" {
			if err := a.mirrorReconcile(ctx, t); err != nil {
				return fmt.Errorf("%s reconcile: %w", t, err)
			}
		}
	}
	return nil
}

// export calls the Hostinger export.php endpoint.
func (a *App) export(ctx context.Context, body map[string]any) ([]map[string]any, error) {
	buf, _ := json.Marshal(body)
	req, err := http.NewRequestWithContext(ctx, http.MethodPost,
		strings.TrimRight(a.cfg.MirrorBaseURL, "/")+"/export.php", bytes.NewReader(buf))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("X-App-Key", a.cfg.AppKey)
	client := &http.Client{Timeout: 120 * time.Second}
	res, err := client.Do(req)
	if err != nil {
		return nil, err
	}
	defer res.Body.Close()
	var out struct {
		OK      bool             `json:"ok"`
		Message string           `json:"message"`
		Rows    []map[string]any `json:"rows"`
	}
	if err := json.NewDecoder(res.Body).Decode(&out); err != nil {
		return nil, err
	}
	if !out.OK {
		return nil, fmt.Errorf("export.php: %s (http %d)", out.Message, res.StatusCode)
	}
	return out.Rows, nil
}

// mirrorSmallTable replaces the local copy of a small table: upsert every
// source row, delete local rows the source no longer has.
func (a *App) mirrorSmallTable(ctx context.Context, table string, pk, cols []string) error {
	rows, err := a.export(ctx, map[string]any{"table": table})
	if err != nil {
		return err
	}
	tx, err := a.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	placeholders := make([]string, len(cols))
	updates := []string{}
	for i, c := range cols {
		placeholders[i] = fmt.Sprintf("$%d", i+1)
		isPK := false
		for _, p := range pk {
			if p == c {
				isPK = true
			}
		}
		if !isPK {
			updates = append(updates, fmt.Sprintf("%s = EXCLUDED.%s", c, c))
		}
	}
	upsert := fmt.Sprintf(
		"INSERT INTO %s (%s) VALUES (%s) ON CONFLICT (%s) DO UPDATE SET %s",
		table, strings.Join(cols, ", "), strings.Join(placeholders, ", "),
		strings.Join(pk, ", "), strings.Join(updates, ", "))
	if len(updates) == 0 || a.cfg.MirrorMode == "transition" {
		// Transition: this panel is taking edits (approvals, org fixes) —
		// only ADD rows Hostinger has that we don't, never overwrite ours.
		upsert = fmt.Sprintf("INSERT INTO %s (%s) VALUES (%s) ON CONFLICT (%s) DO NOTHING",
			table, strings.Join(cols, ", "), strings.Join(placeholders, ", "),
			strings.Join(pk, ", "))
	}

	seen := map[string]bool{}
	for _, r := range rows {
		args := make([]any, len(cols))
		for i, c := range cols {
			args[i] = pgValue(c, r[c])
		}
		if _, err := tx.Exec(ctx, upsert, args...); err != nil {
			return err
		}
		key := ""
		for _, p := range pk {
			key += fmt.Sprintf("%v|", r[p])
		}
		seen[key] = true
	}

	// Delete local rows missing from the source (only when the pull returned
	// something, so a failed/empty export can never wipe the table). Skipped
	// in transition mode — local edits must survive.
	if len(rows) > 0 && a.cfg.MirrorMode != "transition" {
		sel := fmt.Sprintf("SELECT %s FROM %s", strings.Join(pk, ", "), table)
		lr, err := tx.Query(ctx, sel)
		if err != nil {
			return err
		}
		type delKey struct{ vals []any }
		var toDelete []delKey
		for lr.Next() {
			vals := make([]any, len(pk))
			ptrs := make([]any, len(pk))
			for i := range vals {
				ptrs[i] = &vals[i]
			}
			if err := lr.Scan(ptrs...); err != nil {
				lr.Close()
				return err
			}
			key := ""
			for _, v := range vals {
				key += fmt.Sprintf("%v|", v)
			}
			if !seen[key] {
				toDelete = append(toDelete, delKey{vals})
			}
		}
		lr.Close()
		for _, d := range toDelete {
			conds := make([]string, len(pk))
			for i, p := range pk {
				conds[i] = fmt.Sprintf("%s = $%d", p, i+1)
			}
			if _, err := tx.Exec(ctx,
				fmt.Sprintf("DELETE FROM %s WHERE %s", table, strings.Join(conds, " AND ")),
				d.vals...); err != nil {
				return err
			}
		}
	}
	return tx.Commit(ctx)
}

// mirrorDeletions appends audit-log rows we don't have yet (matched on the
// source id, tracked in mirror_state.last_id).
func (a *App) mirrorDeletions(ctx context.Context) error {
	rows, err := a.export(ctx, map[string]any{"table": "central_deletions"})
	if err != nil {
		return err
	}
	var lastID int64
	_ = a.db.QueryRow(ctx,
		`SELECT last_id FROM mirror_state WHERE tbl = 'central_deletions'`).Scan(&lastID)
	maxID := lastID
	for _, r := range rows {
		id := asInt64(r["id"])
		if id <= lastID {
			continue
		}
		_, err := a.db.Exec(ctx, `
			INSERT INTO central_deletions
				(owner_email, remote_uid, fir_no, year, station_name,
				 src_device, src_platform, src_os, src_ip, deleted_at)
			VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
			pgValue("owner_email", r["owner_email"]), pgValue("remote_uid", r["remote_uid"]),
			pgValue("fir_no", r["fir_no"]), pgValue("year", r["year"]),
			pgValue("station_name", r["station_name"]), pgValue("src_device", r["src_device"]),
			pgValue("src_platform", r["src_platform"]), pgValue("src_os", r["src_os"]),
			pgValue("src_ip", r["src_ip"]), pgValue("deleted_at", r["deleted_at"]))
		if err != nil {
			return err
		}
		if id > maxID {
			maxID = id
		}
	}
	if maxID > lastID {
		_, err = a.db.Exec(ctx, `
			INSERT INTO mirror_state (tbl, last_id) VALUES ('central_deletions', $1)
			ON CONFLICT (tbl) DO UPDATE SET last_id = EXCLUDED.last_id`, maxID)
	}
	return err
}

// mirrorIncremental pulls new/changed rows by (updated_at, id) pages.
func (a *App) mirrorIncremental(ctx context.Context, table string) error {
	var since *time.Time
	var lastID int64
	_ = a.db.QueryRow(ctx,
		`SELECT last_sync, last_id FROM mirror_state WHERE tbl = $1`, table).Scan(&since, &lastID)

	for {
		body := map[string]any{"table": table, "limit": 500, "after_id": lastID}
		if since != nil {
			body["since"] = since.UTC().Format("2006-01-02 15:04:05")
		}
		rows, err := a.export(ctx, body)
		if err != nil {
			return err
		}
		if len(rows) == 0 {
			break
		}
		for _, r := range rows {
			if table == "central_crimes" {
				err = a.upsertMirroredCrime(ctx, r)
			} else {
				err = a.upsertMirroredIoCase(ctx, r)
			}
			if err != nil {
				return err
			}
			lastID = asInt64(r["id"])
			if t := parseDate(str(r["updated_at"])); t != nil {
				since = t
			}
		}
		_, err = a.db.Exec(ctx, `
			INSERT INTO mirror_state (tbl, last_sync, last_id) VALUES ($1, $2, $3)
			ON CONFLICT (tbl) DO UPDATE
			SET last_sync = EXCLUDED.last_sync, last_id = EXCLUDED.last_id`,
			table, since, lastID)
		if err != nil {
			return err
		}
		if len(rows) < 500 {
			break
		}
	}
	return nil
}

func (a *App) upsertMirroredCrime(ctx context.Context, r map[string]any) error {
	// In transition mode a station may have re-uploaded this FIR directly to
	// this server with a newer version — keep whichever copy is newest.
	guard := ""
	if a.cfg.MirrorMode == "transition" {
		guard = " WHERE central_crimes.updated_at <= EXCLUDED.updated_at"
	}
	_, err := a.db.Exec(ctx, `
		INSERT INTO central_crimes
			(owner_email, remote_uid, station_id, station_name, fir_no, year,
			 crime_type, section, status, date_occurred, date_registered,
			 data_json, src_device, src_platform, src_os, src_ip, updated_at)
		VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17)
		ON CONFLICT (owner_email, remote_uid) DO UPDATE SET
			station_id = EXCLUDED.station_id, station_name = EXCLUDED.station_name,
			fir_no = EXCLUDED.fir_no, year = EXCLUDED.year,
			crime_type = EXCLUDED.crime_type, section = EXCLUDED.section,
			status = EXCLUDED.status, date_occurred = EXCLUDED.date_occurred,
			date_registered = EXCLUDED.date_registered, data_json = EXCLUDED.data_json,
			src_device = EXCLUDED.src_device, src_platform = EXCLUDED.src_platform,
			src_os = EXCLUDED.src_os, src_ip = EXCLUDED.src_ip,
			updated_at = EXCLUDED.updated_at`+guard,
		str(r["owner_email"]), str(r["remote_uid"]),
		pgValue("station_id", r["station_id"]), pgValue("station_name", r["station_name"]),
		pgValue("fir_no", r["fir_no"]), pgValue("year", r["year"]),
		pgValue("crime_type", r["crime_type"]), pgValue("section", r["section"]),
		pgValue("status", r["status"]),
		pgValue("date_occurred", r["date_occurred"]), pgValue("date_registered", r["date_registered"]),
		pgValue("data_json", r["data_json"]),
		pgValue("src_device", r["src_device"]), pgValue("src_platform", r["src_platform"]),
		pgValue("src_os", r["src_os"]), pgValue("src_ip", r["src_ip"]),
		pgValue("updated_at", r["updated_at"]))
	return err
}

func (a *App) upsertMirroredIoCase(ctx context.Context, r map[string]any) error {
	guard := ""
	if a.cfg.MirrorMode == "transition" {
		guard = " WHERE central_io_cases.updated_at <= EXCLUDED.updated_at"
	}
	_, err := a.db.Exec(ctx, `
		INSERT INTO central_io_cases
			(owner_email, remote_uid, title, crime_type, crime_category, fir_no,
			 year, district, police_station, status, data_json, client_updated, updated_at)
		VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13)
		ON CONFLICT (owner_email, remote_uid) DO UPDATE SET
			title = EXCLUDED.title, crime_type = EXCLUDED.crime_type,
			crime_category = EXCLUDED.crime_category, fir_no = EXCLUDED.fir_no,
			year = EXCLUDED.year, district = EXCLUDED.district,
			police_station = EXCLUDED.police_station, status = EXCLUDED.status,
			data_json = EXCLUDED.data_json, client_updated = EXCLUDED.client_updated,
			updated_at = EXCLUDED.updated_at`+guard,
		str(r["owner_email"]), str(r["remote_uid"]),
		pgValue("title", r["title"]), pgValue("crime_type", r["crime_type"]),
		pgValue("crime_category", r["crime_category"]), pgValue("fir_no", r["fir_no"]),
		pgValue("year", r["year"]), pgValue("district", r["district"]),
		pgValue("police_station", r["police_station"]), pgValue("status", r["status"]),
		pgValue("data_json", r["data_json"]), pgValue("client_updated", r["client_updated"]),
		pgValue("updated_at", r["updated_at"]))
	return err
}

// mirrorReconcile deletes local rows whose (owner_email, remote_uid) no longer
// exists at the source — e.g. FIRs removed via the admin panel.
func (a *App) mirrorReconcile(ctx context.Context, table string) error {
	rows, err := a.export(ctx, map[string]any{"table": table, "mode": "ids"})
	if err != nil {
		return err
	}
	if len(rows) == 0 {
		// Only trust an empty source when we also hold nothing; otherwise skip
		// so a transient bad response can't wipe the mirror.
		var n int
		if err := a.db.QueryRow(ctx,
			fmt.Sprintf("SELECT COUNT(*) FROM %s", table)).Scan(&n); err != nil || n > 0 {
			return nil
		}
		return nil
	}
	source := map[string]bool{}
	for _, r := range rows {
		source[str(r["owner_email"])+"|"+str(r["remote_uid"])] = true
	}
	lr, err := a.db.Query(ctx,
		fmt.Sprintf("SELECT owner_email, remote_uid FROM %s", table))
	if err != nil {
		return err
	}
	type pair struct{ owner, uid string }
	var gone []pair
	for lr.Next() {
		var p pair
		if lr.Scan(&p.owner, &p.uid) == nil && !source[p.owner+"|"+p.uid] {
			gone = append(gone, p)
		}
	}
	lr.Close()
	for _, p := range gone {
		if _, err := a.db.Exec(ctx,
			fmt.Sprintf("DELETE FROM %s WHERE owner_email = $1 AND remote_uid = $2", table),
			p.owner, p.uid); err != nil {
			return err
		}
	}
	if len(gone) > 0 {
		log.Printf("mirror: %s: removed %d rows deleted at source", table, len(gone))
	}
	return nil
}

// --- Value coercion: MySQL/PHP JSON -> PostgreSQL ---------------------------

func str(v any) string {
	if v == nil {
		return ""
	}
	return fmt.Sprintf("%v", v)
}

func asInt64(v any) int64 {
	switch n := v.(type) {
	case float64:
		return int64(n)
	case string:
		var i int64
		fmt.Sscanf(n, "%d", &i)
		return i
	}
	return 0
}

// pgValue maps an exported JSON value to the right Postgres parameter type
// based on the column name conventions shared by all mirrored tables.
func pgValue(col string, v any) any {
	if v == nil {
		return nil
	}
	switch col {
	case "id", "zone_id", "division_id", "station_id",
		"scope_zone_id", "scope_division_id", "scope_station_id",
		"year", "sort", "build":
		return asInt64(v)
	case "mandatory":
		return asInt64(v) == 1 || v == true
	case "requested_at", "decided_at", "expires_at", "last_seen_at",
		"suppressed_at", "deleted_at", "created_at", "updated_at",
		"client_updated", "date_occurred", "date_registered":
		if t := parseDate(str(v)); t != nil {
			return *t
		}
		return nil
	case "data_json":
		s := str(v)
		if s == "" || !json.Valid([]byte(s)) {
			return nil
		}
		return []byte(s)
	default:
		s := str(v)
		if s == "" {
			return nil
		}
		return s
	}
}
