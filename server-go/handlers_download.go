package main

import (
	"encoding/json"
	"net/http"
	"strconv"
	"strings"
	"time"
)

// Two-way sync, pull half.
//
// Until now sync was upload-only: every FIR was typed on one machine and
// pushed up, and nothing ever came back down. That is why a freshly issued
// station login saw an EMPTY Crime Records list on their own PC — the records
// were on the server, not on their disk, and the app had no way to fetch them.
//
// handleDownload closes that gap. A station user pulls their own station's
// FIRs; a zone user pulls every station in their zone; senior officers pull
// their whole jurisdiction. Scoping is by station_id (the id the row was filed
// under), never by station NAME — name matching is what previously hid
// "एम.वाळूज" from the user assigned "MIDC Waluj".
//
// Rows are returned newest-changed first with a `since` watermark so repeat
// syncs are cheap, and paged so a 2,000-FIR station arrives in bounded chunks.
const downloadMaxLimit = 500

func (a *App) handleDownload(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)

	email := strings.ToLower(bodyStr(b, "email"))
	if email == "" {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	u, err := a.requireApprovedUser(ctx, email)
	if err != nil {
		respond(w, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	// Which stations may this account read? nil = unrestricted (cp/hq).
	stationIDs, err := a.baseStationIDs(ctx, u)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	// A scoped role with no assignment reads nothing — fail closed rather than
	// handing a mis-configured account the whole district.
	if stationIDs != nil && len(stationIDs) == 0 {
		respond(w, map[string]any{"ok": true, "records": []any{}, "more": false})
		return
	}

	limit := downloadMaxLimit
	if n, ok := bodyInt(b, "limit"); ok && n > 0 && n < downloadMaxLimit {
		limit = n
	}
	offset := 0
	if n, ok := bodyInt(b, "offset"); ok && n > 0 {
		offset = n
	}

	args := []any{}
	where := []string{"c.data_json IS NOT NULL"}
	if clause, extra := scopeClause(stationIDs, len(args)+1); clause != "" {
		where = append(where, clause)
		args = append(args, extra...)
	}
	// Incremental: only rows changed since the caller's watermark. The client
	// sends the timestamp the SERVER reported last time, so clock drift on the
	// station PC cannot skip rows.
	if s := bodyStr(b, "since"); s != "" {
		if ts, err := time.Parse(time.RFC3339, s); err == nil {
			args = append(args, ts)
			where = append(where, "c.updated_at > $"+strconv.Itoa(len(args)))
		}
	}

	args = append(args, limit+1) // +1 row tells us whether more pages remain
	limitArg := strconv.Itoa(len(args))
	args = append(args, offset)
	offsetArg := strconv.Itoa(len(args))

	sql := `
		SELECT c.remote_uid, c.station_name, c.fir_no, c.year, c.updated_at, c.data_json
		  FROM central_crimes c
		 WHERE ` + strings.Join(where, " AND ") + `
		 ORDER BY c.updated_at ASC, c.id ASC
		 LIMIT $` + limitArg + ` OFFSET $` + offsetArg

	rows, err := a.db.Query(ctx, sql, args...)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	defer rows.Close()

	out := make([]map[string]any, 0, limit)
	for rows.Next() {
		var (
			uid       string
			station   *string
			firNo     *string
			year      *int
			updatedAt time.Time
			raw       []byte
		)
		if err := rows.Scan(&uid, &station, &firNo, &year, &updatedAt, &raw); err != nil {
			continue
		}
		var data map[string]any
		if len(raw) > 0 {
			_ = json.Unmarshal(raw, &data)
		}
		if data == nil {
			data = map[string]any{}
		}
		out = append(out, map[string]any{
			"uid":        uid,
			"station":    strOr(station),
			"fir_no":     strOr(firNo),
			"year":       year,
			"updated_at": updatedAt.UTC().Format(time.RFC3339),
			"data":       data,
		})
	}

	more := len(out) > limit
	if more {
		out = out[:limit]
	}
	// The watermark the client should send back next time: the newest row it
	// actually received. Never "now" — a row written mid-page would be skipped.
	serverTime := ""
	if len(out) > 0 {
		serverTime, _ = out[len(out)-1]["updated_at"].(string)
	}

	respond(w, map[string]any{
		"ok":      true,
		"records": out,
		"more":    more,
		"cursor":  serverTime,
	})
}

func strOr(s *string) string {
	if s == nil {
		return ""
	}
	return *s
}
