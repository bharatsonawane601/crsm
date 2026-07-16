package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"sort"
	"strconv"
	"time"
)

// The Analytics page: read-only city-wide crime statistics for the admin —
// detection KPIs, yearly and monthly trends, crime-type mix, station league
// table and data-quality checks. Filterable by year and station. All numbers
// come from one scan of the filtered central_crimes rows, so every figure on
// the page is consistent with every other.

type analyticsKPI struct {
	Total, Detected, Undetected      int
	Chargesheeted, Arrested, Wanted  int
	Recovered                        float64
}

func (k analyticsKPI) DetectedPct() string {
	if k.Total == 0 {
		return "0"
	}
	return fmt.Sprintf("%.1f", float64(k.Detected)/float64(k.Total)*100)
}

func (k analyticsKPI) RecoveredFmt() string {
	return fmt.Sprintf("₹%.0f", k.Recovered)
}

// One labelled row in a trend/breakdown table, with a pre-computed bar width
// (percent of the largest row) so the template stays logic-free.
type analyticsRow struct {
	Label            string
	Total, Detected  int
	Bar              int
	Pct              string
}

func barRows(m map[string]*analyticsKPI, keys []string, limit int) []analyticsRow {
	max := 1
	for _, k := range keys {
		if m[k].Total > max {
			max = m[k].Total
		}
	}
	out := []analyticsRow{}
	for _, k := range keys {
		v := m[k]
		out = append(out, analyticsRow{
			Label: k, Total: v.Total, Detected: v.Detected,
			Bar: v.Total * 100 / max, Pct: v.DetectedPct(),
		})
		if limit > 0 && len(out) >= limit {
			break
		}
	}
	return out
}

func (a *App) adminAnalytics(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	year, _ := strconv.Atoi(r.URL.Query().Get("year"))
	stationID, _ := strconv.ParseInt(r.URL.Query().Get("station_id"), 10, 64)

	where := "TRUE"
	args := []any{}
	if year > 0 {
		args = append(args, year)
		where += fmt.Sprintf(" AND c.year = $%d", len(args))
	}
	if stationID > 0 {
		args = append(args, stationID)
		where += fmt.Sprintf(" AND c.station_id = $%d", len(args))
	}

	kpi := &analyticsKPI{}
	byYear := map[string]*analyticsKPI{}
	byMonth := map[string]*analyticsKPI{}
	byType := map[string]*analyticsKPI{}
	byStation := map[string]*analyticsKPI{}
	var noStation, noFirNo, noDate, noType int

	rows, err := a.db.Query(ctx, `
		SELECT c.year, COALESCE(c.status, ''), COALESCE(NULLIF(c.crime_type, ''), '(no type)'),
		       c.date_registered,
		       COALESCE(s.name, NULLIF(c.station_name, ''), '(no station)'),
		       c.data_json, (c.station_id IS NULL), (COALESCE(c.fir_no, '') = '')
		  FROM central_crimes c LEFT JOIN org_stations s ON c.station_id = s.id
		 WHERE `+where, args...)
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	bump := func(m map[string]*analyticsKPI, key string, detected bool) {
		v := m[key]
		if v == nil {
			v = &analyticsKPI{}
			m[key] = v
		}
		v.Total++
		if detected {
			v.Detected++
		} else {
			v.Undetected++
		}
	}
	for rows.Next() {
		var (
			yr               *int
			status, ct, st   string
			reg              *time.Time
			dataJSON         []byte
			unlinked, noFir  bool
		)
		if rows.Scan(&yr, &status, &ct, &reg, &st, &dataJSON, &unlinked, &noFir) != nil {
			continue
		}
		det := status == "detected"
		kpi.Total++
		if det {
			kpi.Detected++
		} else {
			kpi.Undetected++
		}
		if dataJSON != nil {
			var d map[string]any
			if json.Unmarshal(dataJSON, &d) == nil {
				kpi.Arrested += asInt(d["arrested_count"])
				kpi.Wanted += asInt(d["wanted_count"])
				kpi.Recovered += asFloat(d["recovered_value"])
				if s, _ := d["chargesheet_date"].(string); s != "" {
					kpi.Chargesheeted++
				}
			}
		}
		if yr != nil && *yr > 1900 {
			bump(byYear, strconv.Itoa(*yr), det)
		}
		if reg != nil {
			bump(byMonth, reg.Format("2006-01"), det)
		} else {
			noDate++
		}
		if ct == "(no type)" {
			noType++
		}
		bump(byType, ct, det)
		bump(byStation, st, det)
		if unlinked {
			noStation++
		}
		if noFir {
			noFirNo++
		}
	}
	rows.Close()

	// Years: newest first. Months: newest first, capped at 24.
	yearKeys := sortedKeys(byYear)
	monthKeys := sortedKeys(byMonth)
	if len(monthKeys) > 24 {
		monthKeys = monthKeys[:24]
	}
	// Crime types and stations: biggest first.
	typeKeys := keysByTotal(byType)
	stationKeys := keysByTotal(byStation)

	// Filter dropdowns.
	yearOpts := []int{}
	yr, err := a.db.Query(ctx,
		`SELECT DISTINCT year FROM central_crimes WHERE year IS NOT NULL AND year > 1900 ORDER BY year DESC`)
	if err == nil {
		for yr.Next() {
			var y int
			if yr.Scan(&y) == nil {
				yearOpts = append(yearOpts, y)
			}
		}
		yr.Close()
	}
	type orgOpt struct {
		ID   int64
		Name string
	}
	stationOpts := []orgOpt{}
	sr, err := a.db.Query(ctx, `SELECT id, name FROM org_stations ORDER BY sort, name`)
	if err == nil {
		for sr.Next() {
			var o orgOpt
			if sr.Scan(&o.ID, &o.Name) == nil {
				stationOpts = append(stationOpts, o)
			}
		}
		sr.Close()
	}

	renderAdmin(w, "analytics", a.page(r, "Analytics", "analytics", map[string]any{
		"KPI":         kpi,
		"ByYear":      barRows(byYear, yearKeys, 0),
		"ByMonth":     barRows(byMonth, monthKeys, 0),
		"ByType":      barRows(byType, typeKeys, 15),
		"ByStation":   barRows(byStation, stationKeys, 0),
		"NoStation":   noStation,
		"NoFirNo":     noFirNo,
		"NoDate":      noDate,
		"NoType":      noType,
		"Year":        year,
		"StationID":   stationID,
		"YearOpts":    yearOpts,
		"StationOpts": stationOpts,
	}))
}

// sortedKeys returns the map keys newest-first (works for "2025" and "2025-07"
// style keys, which sort correctly as strings).
func sortedKeys(m map[string]*analyticsKPI) []string {
	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	sort.Sort(sort.Reverse(sort.StringSlice(keys)))
	return keys
}

// keysByTotal returns the map keys biggest-total-first.
func keysByTotal(m map[string]*analyticsKPI) []string {
	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	sort.Slice(keys, func(i, j int) bool {
		if m[keys[i]].Total != m[keys[j]].Total {
			return m[keys[i]].Total > m[keys[j]].Total
		}
		return keys[i] < keys[j]
	})
	return keys
}
