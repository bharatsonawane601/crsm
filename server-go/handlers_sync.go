package main

import (
	"context"
	"encoding/json"
	"net/http"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
)

// handleUpload receives a batch of station records and upserts them by
// (owner_email, remote_uid) — the Go twin of server/upload.php, including the
// suppressed-tombstone skip and the tolerant station-name lookup.
func (a *App) handleUpload(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	email := strings.ToLower(bodyStr(b, "email"))
	records, _ := b["records"].([]any)
	defaultStation := bodyStr(b, "default_station")
	if email == "" || records == nil {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	srcIP := clientIP(r)
	srcPlatform := truncate(strings.ToLower(bodyStr(b, "platform")), 20)
	srcOs := truncate(bodyStr(b, "os"), 160)
	srcDevice := truncate(bodyStr(b, "device"), 190)

	if _, err := a.requireApprovedUser(ctx, email); err != nil {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	suppressed, err := a.suppressedSet(ctx, email)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	stationMap, err := a.stationNameMap(ctx)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	lookup := func(name string) *int64 {
		key := normStationName(strings.TrimSpace(name))
		if key == "" {
			return nil
		}
		if id, ok := stationMap[key]; ok {
			return &id
		}
		return nil
	}

	tx, err := a.db.Begin(ctx)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	defer tx.Rollback(ctx)

	// All upserts go to Postgres as ONE pipelined batch (a single round trip)
	// instead of one Exec per record — big uploads stay fast at any chunk size.
	const upsertSQL = `
		INSERT INTO central_crimes
			(owner_email, remote_uid, station_id, station_name, fir_no, year,
			 crime_type, section, status, date_occurred, date_registered,
			 data_json, src_device, src_platform, src_os, src_ip, updated_at)
		VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16, now())
		ON CONFLICT (owner_email, remote_uid) DO UPDATE SET
			station_id = EXCLUDED.station_id,
			station_name = EXCLUDED.station_name,
			fir_no = EXCLUDED.fir_no,
			year = EXCLUDED.year,
			crime_type = EXCLUDED.crime_type,
			section = EXCLUDED.section,
			status = EXCLUDED.status,
			date_occurred = EXCLUDED.date_occurred,
			date_registered = EXCLUDED.date_registered,
			data_json = EXCLUDED.data_json,
			src_device = EXCLUDED.src_device,
			src_platform = EXCLUDED.src_platform,
			src_os = EXCLUDED.src_os,
			src_ip = EXCLUDED.src_ip,
			updated_at = now()`
	batch := &pgx.Batch{}
	count := 0
	for _, raw := range records {
		rec, ok := raw.(map[string]any)
		if !ok {
			continue
		}
		uid := bodyStr(rec, "uid")
		if uid == "" || suppressed[uid] {
			continue
		}
		stationName := bodyStr(rec, "police_station")
		if stationName == "" {
			stationName = defaultStation
		}
		var year *int
		if y, ok := bodyInt(rec, "year"); ok {
			year = &y
		}
		var dataJSON []byte
		if d, ok := rec["data"]; ok && d != nil {
			dataJSON, _ = json.Marshal(d)
		}
		batch.Queue(upsertSQL,
			email, uid, lookup(stationName), normStr(stationName),
			normStr(bodyStr(rec, "fir_no")), year,
			normStr(bodyStr(rec, "crime_type")), normStr(bodyStr(rec, "section")),
			normStr(bodyStr(rec, "status")),
			parseDate(bodyStr(rec, "date_occurred")), parseDate(bodyStr(rec, "date_registered")),
			dataJSON,
			normStr(srcDevice), normStr(srcPlatform), normStr(srcOs), normStr(srcIP))
		count++
	}
	if count > 0 {
		br := tx.SendBatch(ctx, batch)
		for i := 0; i < count; i++ {
			if _, err := br.Exec(); err != nil {
				br.Close()
				respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
				return
			}
		}
		if err := br.Close(); err != nil {
			respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
			return
		}
	}
	if err := tx.Commit(ctx); err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	respond(w, map[string]any{"ok": true, "saved": count})
}

func (a *App) suppressedSet(ctx context.Context, email string) (map[string]bool, error) {
	rows, err := a.db.Query(ctx,
		`SELECT remote_uid FROM central_suppressed WHERE owner_email = $1`, email)
	if err != nil {
		return nil, err
	}
	defer rows.Close()
	out := map[string]bool{}
	for rows.Next() {
		var uid string
		if err := rows.Scan(&uid); err != nil {
			return nil, err
		}
		out[uid] = true
	}
	return out, rows.Err()
}

// handleSuppressed returns the caller's admin-deleted FIR uids so the station
// app can purge its local copies (server/suppressed.php). An optional "since"
// timestamp returns only tombstones created after it, so the app's frequent
// background poll stays tiny instead of re-downloading the whole list.
//
// Every tombstone also carries the deleted FIR's IDENTITY (fir_no / year /
// station, taken from the recycle-bin copy). A uid alone is not safe to delete
// on: pre-v8 records were uploaded with their local row id as the uid ("1",
// "2", …), so a restored or reinstalled station whose ids start over at 1
// collides with another device's tombstones and wipes unrelated FIRs. The app
// deletes only when the identity matches too.
func (a *App) handleSuppressed(w http.ResponseWriter, r *http.Request) {
	b := jsonBody(r)
	email := strings.ToLower(bodyStr(b, "email"))
	if email == "" {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	// DISTINCT ON: the same (owner, uid) can be deleted, restored and deleted
	// again, leaving several trash rows — the newest one is the live identity.
	sql := `
		SELECT s.remote_uid, t.fir_no, t.year, t.station_name
		  FROM central_suppressed s
		  LEFT JOIN LATERAL (
		       SELECT fir_no, year, station_name
		         FROM central_trash x
		        WHERE x.owner_email = s.owner_email
		          AND x.remote_uid  = s.remote_uid
		        ORDER BY x.deleted_at DESC
		        LIMIT 1
		  ) t ON TRUE
		 WHERE s.owner_email = $1`
	args := []any{email}
	if since := parseDate(bodyStr(b, "since")); since != nil {
		sql += ` AND s.suppressed_at > $2`
		args = append(args, *since)
	}
	rows, err := a.db.Query(r.Context(), sql, args...)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	defer rows.Close()
	uids := []string{}
	items := []map[string]any{}
	for rows.Next() {
		var (
			uid              string
			firNo, stationNm *string
			year             *int
		)
		if err := rows.Scan(&uid, &firNo, &year, &stationNm); err != nil {
			continue
		}
		uids = append(uids, uid)
		items = append(items, map[string]any{
			"uid":            uid,
			"fir_no":         firNo,
			"year":           year,
			"police_station": stationNm,
		})
	}
	// "uids" is kept for older app builds, which ignore "items".
	respond(w, map[string]any{"ok": true, "uids": uids, "items": items})
}

// handleDeletions logs a station-side FIR deletion, moves the central copy to
// the 30-day recycle bin and removes it (server/deletions.php).
func (a *App) handleDeletions(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	email := strings.ToLower(bodyStr(b, "email"))
	uid := bodyStr(b, "uid")
	if email == "" {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	if _, err := a.requireApprovedUser(ctx, email); err != nil {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	firNo := normStr(bodyStr(b, "fir_no"))
	var year *int
	if y, ok := bodyInt(b, "year"); ok {
		year = &y
	}
	station := normStr(bodyStr(b, "police_station"))

	// Prefer the central copy's details (authoritative) when it exists.
	if uid != "" {
		var cFir, cStation *string
		var cYear *int
		err := a.db.QueryRow(ctx, `
			SELECT fir_no, year, station_name FROM central_crimes
			 WHERE owner_email = $1 AND remote_uid = $2`, email, uid,
		).Scan(&cFir, &cYear, &cStation)
		if err == nil {
			if cFir != nil {
				firNo = cFir
			}
			if cYear != nil {
				year = cYear
			}
			if cStation != nil {
				station = cStation
			}
		}
	}

	_, err := a.db.Exec(ctx, `
		INSERT INTO central_deletions
			(owner_email, remote_uid, fir_no, year, station_name,
			 src_device, src_platform, src_os, src_ip)
		VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9)`,
		email, normStr(uid), firNo, year, station,
		normStr(truncate(bodyStr(b, "device"), 190)),
		normStr(truncate(strings.ToLower(bodyStr(b, "platform")), 20)),
		normStr(truncate(bodyStr(b, "os"), 160)),
		normStr(clientIP(r)))
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	if uid != "" {
		_, _ = a.db.Exec(ctx, `
			INSERT INTO central_trash
				(owner_email, remote_uid, station_id, station_name, fir_no, year,
				 crime_type, section, status, date_occurred, date_registered,
				 data_json, src_device, src_platform, src_os, src_ip, deleted_by)
			SELECT owner_email, remote_uid, station_id, station_name, fir_no, year,
			       crime_type, section, status, date_occurred, date_registered,
			       data_json, src_device, src_platform, src_os, src_ip, $1
			  FROM central_crimes WHERE owner_email = $2 AND remote_uid = $3`,
			email, email, uid)
		_, _ = a.db.Exec(ctx,
			`DELETE FROM central_crimes WHERE owner_email = $1 AND remote_uid = $2`,
			email, uid)
	}
	respond(w, map[string]any{"ok": true})
}

// handleIoSync is the Investigating-Officer case sync: push upserts the
// caller's cases, pull returns them (server/io_sync.php).
func (a *App) handleIoSync(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	email := strings.ToLower(bodyStr(b, "email"))
	action := bodyStr(b, "action")
	if action == "" {
		action = "pull"
	}
	if email == "" {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	if _, err := a.requireApprovedUser(ctx, email); err != nil {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	if action == "push" {
		cases, _ := b["cases"].([]any)
		count := 0
		for _, raw := range cases {
			c, ok := raw.(map[string]any)
			if !ok {
				continue
			}
			uid := bodyStr(c, "uid")
			if uid == "" {
				continue
			}
			var year *int
			if y, ok := bodyInt(c, "year"); ok {
				year = &y
			}
			var dataJSON []byte
			if d, ok := c["data"]; ok && d != nil {
				dataJSON, _ = json.Marshal(d)
			}
			// The app sends its local timestamp as "updated_at"; it is stored
			// as client_updated (server keeps its own updated_at).
			clientUpdated := parseDate(bodyStr(c, "updated_at"))
			_, err := a.db.Exec(ctx, `
				INSERT INTO central_io_cases
					(owner_email, remote_uid, title, crime_type, crime_category,
					 fir_no, year, district, police_station, status,
					 data_json, client_updated, updated_at)
				VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12, now())
				ON CONFLICT (owner_email, remote_uid) DO UPDATE SET
					title = EXCLUDED.title,
					crime_type = EXCLUDED.crime_type,
					crime_category = EXCLUDED.crime_category,
					fir_no = EXCLUDED.fir_no,
					year = EXCLUDED.year,
					district = EXCLUDED.district,
					police_station = EXCLUDED.police_station,
					status = EXCLUDED.status,
					data_json = EXCLUDED.data_json,
					client_updated = EXCLUDED.client_updated,
					updated_at = now()`,
				email, uid,
				normStr(bodyStr(c, "title")), normStr(bodyStr(c, "crime_type")),
				normStr(bodyStr(c, "crime_category")), normStr(bodyStr(c, "fir_no")),
				year, normStr(bodyStr(c, "district")), normStr(bodyStr(c, "police_station")),
				normStr(bodyStr(c, "status")), dataJSON, clientUpdated)
			if err != nil {
				respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
				return
			}
			count++
		}
		respond(w, map[string]any{"ok": true, "saved": count})
		return
	}

	// pull — all the caller's cases, optionally only those updated since.
	// Response shape matches io_sync.php: uid / client_updated /
	// server_updated / data, as MySQL-style datetime strings.
	sql := `SELECT remote_uid, client_updated, updated_at, data_json
	          FROM central_io_cases WHERE owner_email = $1`
	args := []any{email}
	if since := parseDate(bodyStr(b, "since")); since != nil {
		sql += ` AND updated_at > $2`
		args = append(args, *since)
	}
	rows, err := a.db.Query(ctx, sql+` ORDER BY updated_at ASC`, args...)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	defer rows.Close()
	out := []map[string]any{}
	for rows.Next() {
		var (
			uid                      string
			dataJSON                 []byte
			clientUpdated, updatedAt *time.Time
		)
		if err := rows.Scan(&uid, &clientUpdated, &updatedAt, &dataJSON); err != nil {
			respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
			return
		}
		var data any
		if dataJSON != nil {
			_ = json.Unmarshal(dataJSON, &data)
		}
		fmtDT := func(t *time.Time) any {
			if t == nil {
				return nil
			}
			return t.UTC().Format("2006-01-02 15:04:05")
		}
		out = append(out, map[string]any{
			"uid":            uid,
			"client_updated": fmtDT(clientUpdated),
			"server_updated": fmtDT(updatedAt),
			"data":           data,
		})
	}
	respond(w, map[string]any{"ok": true, "cases": out})
}
