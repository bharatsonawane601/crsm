package main

// The Analytics page: city-wide crime intelligence for the admin — KPIs,
// muddemal (property) money trail, automatic insights ("the brain"), time
// patterns (year / month / weekday / hour / week-of-month / hot dates), crime
// mix and the station detection league. Filterable by year and station.
// Everything is computed in ONE scan of the filtered central_crimes rows, so
// every figure on the page is consistent with every other, and each dataset
// appears exactly once: a table on the left, its chart on the right.

import (
	"encoding/json"
	"fmt"
	"net/http"
	"sort"
	"strconv"
	"strings"
	"time"
)

type analyticsKPI struct {
	Total, Detected, Undetected     int
	Chargesheeted, Arrested, Wanted int
	Recovered                       float64
	Lost                            float64
}

func (k analyticsKPI) DetectedPct() string {
	if k.Total == 0 {
		return "0"
	}
	return fmt.Sprintf("%.1f", float64(k.Detected)/float64(k.Total)*100)
}

// One labelled row in a breakdown table.
type analyticsRow struct {
	Label    string
	Sub      string // optional second line (e.g. Marathi weekday)
	Total    int
	Detected int
	Pct      string
}

func rowsOf(m map[string]*analyticsKPI, keys []string, limit int) []analyticsRow {
	out := []analyticsRow{}
	for _, k := range keys {
		v := m[k]
		out = append(out, analyticsRow{Label: k, Total: v.Total, Detected: v.Detected, Pct: v.DetectedPct()})
		if limit > 0 && len(out) >= limit {
			break
		}
	}
	return out
}

func pointsOf(rows []analyticsRow) []chartPoint {
	pts := make([]chartPoint, 0, len(rows))
	for _, r := range rows {
		pts = append(pts, chartPoint{Label: r.Label, Value: float64(r.Total), Hint: "detection " + r.Pct + "%"})
	}
	return pts
}

// parseHour extracts the hour (0-23) from the app's free-text occurrence time
// ("18:30", "6:30 PM", "06.15"...). Returns -1 when it can't tell.
func parseHour(s string) int {
	s = strings.TrimSpace(strings.ToLower(s))
	if s == "" {
		return -1
	}
	pm := strings.Contains(s, "pm") || strings.Contains(s, "सायं") || strings.Contains(s, "रात्री")
	am := strings.Contains(s, "am")
	digits := ""
	for _, r := range s {
		if r >= '0' && r <= '9' {
			digits += string(r)
			if len(digits) == 2 {
				break
			}
			continue
		}
		if digits != "" {
			break
		}
	}
	h, err := strconv.Atoi(digits)
	if err != nil || h < 0 || h > 24 {
		return -1
	}
	if h == 24 {
		h = 0
	}
	if pm && h < 12 {
		h += 12
	}
	if am && h == 12 {
		h = 0
	}
	if h > 23 {
		return -1
	}
	return h
}

func hourLabel(h int) string {
	switch {
	case h == 0:
		return "12 AM"
	case h < 12:
		return fmt.Sprintf("%d AM", h)
	case h == 12:
		return "12 PM"
	default:
		return fmt.Sprintf("%d PM", h-12)
	}
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
	var weekday [7]*analyticsKPI
	for i := range weekday {
		weekday[i] = &analyticsKPI{}
	}
	var weekOfMonth [5]*analyticsKPI
	for i := range weekOfMonth {
		weekOfMonth[i] = &analyticsKPI{}
	}
	var hour [24]int
	timedTotal := 0
	typeWeekday := map[string]*[7]int{}
	stationMonth := map[string]map[string]int{}
	byDate := map[string]int{}
	datedTotal := 0
	var noStation, noFirNo, noDate, noType int

	rows, err := a.db.Query(ctx, `
		SELECT c.year, COALESCE(c.status, ''), COALESCE(NULLIF(c.crime_type, ''), '(no type)'),
		       c.date_registered, c.date_occurred,
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
	bumpK := func(v *analyticsKPI, detected bool) {
		v.Total++
		if detected {
			v.Detected++
		} else {
			v.Undetected++
		}
	}
	for rows.Next() {
		var (
			yr              *int
			status, ct, st  string
			reg, occ        *time.Time
			dataJSON        []byte
			unlinked, noFir bool
		)
		if rows.Scan(&yr, &status, &ct, &reg, &occ, &st, &dataJSON, &unlinked, &noFir) != nil {
			continue
		}
		det := status == "detected"
		bumpK(kpi, det)
		if dataJSON != nil {
			var d map[string]any
			if json.Unmarshal(dataJSON, &d) == nil {
				kpi.Arrested += asInt(d["arrested_count"])
				kpi.Wanted += asInt(d["wanted_count"])
				kpi.Recovered += asFloat(d["recovered_value"])
				kpi.Lost += asFloat(d["stolen_value"])
				if s, _ := d["chargesheet_date"].(string); s != "" {
					kpi.Chargesheeted++
				}
				if ts, _ := d["time_occurred"].(string); ts != "" {
					if h := parseHour(ts); h >= 0 {
						hour[h]++
						timedTotal++
					}
				}
			}
		}
		if yr != nil && *yr > 1900 {
			bump(byYear, strconv.Itoa(*yr), det)
		}
		if reg != nil {
			mk := reg.Format("2006-01")
			bump(byMonth, mk, det)
			sm := stationMonth[st]
			if sm == nil {
				sm = map[string]int{}
				stationMonth[st] = sm
			}
			sm[mk]++
		} else {
			noDate++
		}
		// Time patterns use the date the crime HAPPENED (fallback: registered).
		when := occ
		if when == nil {
			when = reg
		}
		if when != nil {
			wd := (int(when.Weekday()) + 6) % 7 // 0 = Monday
			bumpK(weekday[wd], det)
			wk := (when.Day() - 1) / 7
			if wk > 4 {
				wk = 4
			}
			bumpK(weekOfMonth[wk], det)
			byDate[when.Format("2006-01-02")]++
			datedTotal++
			tw := typeWeekday[ct]
			if tw == nil {
				tw = &[7]int{}
				typeWeekday[ct] = tw
			}
			tw[wd]++
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

	// --- Insights (the brain) -------------------------------------------------
	agg := analyticsAgg{
		kpi: kpi, byMonth: byMonth, byYear: byYear, byStation: byStation,
		typeWeekday: typeWeekday, stationMonth: stationMonth, byDate: byDate,
		datedTotal: datedTotal, timedTotal: timedTotal, hour: hour,
		lostValue: kpi.Lost, recovered: kpi.Recovered,
	}
	typeTotals := map[string]int{}
	for k, v := range byType {
		typeTotals[k] = v.Total
	}
	agg.typeTotals = typeTotals
	for i := range agg.weekday {
		agg.weekday[i] = weekday[i].Total
	}
	insights := buildInsights(agg)

	// --- Tables + charts (each dataset exactly once) ---------------------------

	// Years: chronological for the chart, newest-first for the table.
	yearKeysAsc := sortedKeysAsc(byYear)
	yearRowsAsc := rowsOf(byYear, yearKeysAsc, 0)
	yearRows := reverseRows(yearRowsAsc)
	yearChart := svgLine(pointsOf(yearRowsAsc), "#5b8cff")

	// Months: last 24, chronological chart / newest-first table.
	monthKeysAsc := sortedKeysAsc(byMonth)
	if len(monthKeysAsc) > 24 {
		monthKeysAsc = monthKeysAsc[len(monthKeysAsc)-24:]
	}
	monthRowsAsc := rowsOf(byMonth, monthKeysAsc, 0)
	monthRows := reverseRows(monthRowsAsc)
	monthChart := svgLine(pointsOf(monthRowsAsc), "#37d5d6")

	// Weekdays, Monday..Sunday.
	wdRows := make([]analyticsRow, 7)
	wdPts := make([]chartPoint, 7)
	for i := 0; i < 7; i++ {
		v := weekday[i]
		wdRows[i] = analyticsRow{Label: weekdayNames[i], Sub: weekdayNamesMr[i],
			Total: v.Total, Detected: v.Detected, Pct: v.DetectedPct()}
		wdPts[i] = chartPoint{Label: weekdayNames[i][:3], Value: float64(v.Total),
			Hint: "detection " + v.DetectedPct() + "%"}
	}
	wdChart := svgVBars(wdPts, "#5b8cff")

	// Hour of day: 3-hour band table + 24h chart.
	bandRows := []analyticsRow{}
	for h := 0; h < 24; h += 3 {
		n := hour[h] + hour[h+1] + hour[h+2]
		pct := "0"
		if timedTotal > 0 {
			pct = fmt.Sprintf("%.1f", float64(n)/float64(timedTotal)*100)
		}
		bandRows = append(bandRows, analyticsRow{
			Label: hourLabel(h) + " – " + hourLabel((h+3)%24), Total: n, Pct: pct})
	}
	hourPts := make([]chartPoint, 24)
	for h := 0; h < 24; h++ {
		hourPts[h] = chartPoint{Label: hourLabel(h), Value: float64(hour[h])}
	}
	hourChart := svgVBars(hourPts, "#a78bfa")

	// Week of the month.
	wkRows := make([]analyticsRow, 5)
	wkPts := make([]chartPoint, 5)
	for i := 0; i < 5; i++ {
		v := weekOfMonth[i]
		lbl := fmt.Sprintf("Week %d", i+1)
		wkRows[i] = analyticsRow{Label: lbl, Sub: weekSpan(i),
			Total: v.Total, Detected: v.Detected, Pct: v.DetectedPct()}
		wkPts[i] = chartPoint{Label: lbl, Value: float64(v.Total), Hint: weekSpan(i)}
	}
	wkChart := svgVBars(wkPts, "#f59e0b")

	// Hottest single dates.
	type dateN struct {
		D string
		N int
	}
	dates := make([]dateN, 0, len(byDate))
	for d, n := range byDate {
		dates = append(dates, dateN{d, n})
	}
	sort.Slice(dates, func(i, j int) bool {
		if dates[i].N != dates[j].N {
			return dates[i].N > dates[j].N
		}
		return dates[i].D > dates[j].D
	})
	if len(dates) > 12 {
		dates = dates[:12]
	}
	dateRows := []analyticsRow{}
	datePts := []chartPoint{}
	for _, d := range dates {
		t, _ := time.Parse("2006-01-02", d.D)
		lbl := t.Format("02 Jan 2006")
		dateRows = append(dateRows, analyticsRow{Label: lbl, Sub: weekdayNames[(int(t.Weekday())+6)%7], Total: d.N})
		datePts = append(datePts, chartPoint{Label: lbl, Value: float64(d.N)})
	}
	dateChart := svgHBars(datePts, "#f87171")

	// Crime types (top 15).
	typeKeys := keysByTotal(byType)
	typeRows := rowsOf(byType, typeKeys, 15)
	typeChart := svgHBars(pointsOf(typeRows), "#5b8cff")

	// Station detection league: best solvers first (stations with 10+ cases),
	// small stations after. This is the RATE view — totals live on the Dashboard.
	stKeys := keysByTotal(byStation)
	sort.SliceStable(stKeys, func(i, j int) bool {
		a1, b1 := byStation[stKeys[i]], byStation[stKeys[j]]
		ba, bb := a1.Total >= 10, b1.Total >= 10
		if ba != bb {
			return ba
		}
		ra := float64(a1.Detected) / float64(max1(a1.Total))
		rb := float64(b1.Detected) / float64(max1(b1.Total))
		if ra != rb {
			return ra > rb
		}
		return a1.Total > b1.Total
	})
	leagueRows := rowsOf(byStation, stKeys, 0)
	leaguePts := []chartPoint{}
	for _, r := range leagueRows {
		if r.Total >= 10 && len(leaguePts) < 15 {
			pf, _ := strconv.ParseFloat(r.Pct, 64)
			leaguePts = append(leaguePts, chartPoint{Label: r.Label, Value: pf,
				Hint: fmt.Sprintf("%d of %d detected", r.Detected, r.Total)})
		}
	}
	leagueChart := svgHBars(leaguePts, "#34d399")

	// Muddemal money trail.
	remaining := kpi.Lost - kpi.Recovered
	if remaining < 0 {
		remaining = 0
	}
	var muddemalChart any
	if kpi.Lost > 0 {
		muddemalChart = svgDonut([]donutSeg{
			// Green/orange (not green/red) so the split survives colorblindness.
			{Label: "Recovered (हस्तगत)", Value: kpi.Recovered, Color: "#199e70"},
			{Label: "Still missing (बाकी)", Value: remaining, Color: "#d95926"},
		}, fmtINRShort(kpi.Lost), "total involved")
	}

	// Filter dropdowns.
	yearOpts := []int{}
	yr2, err := a.db.Query(ctx,
		`SELECT DISTINCT year FROM central_crimes WHERE year IS NOT NULL AND year > 1900 ORDER BY year DESC`)
	if err == nil {
		for yr2.Next() {
			var y int
			if yr2.Scan(&y) == nil {
				yearOpts = append(yearOpts, y)
			}
		}
		yr2.Close()
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
		"KPI":          kpi,
		"RecoveredFmt": fmtINRShort(kpi.Recovered),
		"LostFmt":      fmtINRShort(kpi.Lost),
		"RemainingFmt": fmtINRShort(remaining),
		"HasLost":      kpi.Lost > 0,
		"MuddemalChart": muddemalChart,
		"Insights":     insights,
		"YearRows":     yearRows, "YearChart": yearChart,
		"MonthRows": monthRows, "MonthChart": monthChart,
		"WdRows": wdRows, "WdChart": wdChart,
		"BandRows": bandRows, "HourChart": hourChart, "TimedTotal": timedTotal,
		"WkRows": wkRows, "WkChart": wkChart,
		"DateRows": dateRows, "DateChart": dateChart,
		"TypeRows": typeRows, "TypeChart": typeChart,
		"LeagueRows": leagueRows, "LeagueChart": leagueChart,
		"NoStation": noStation, "NoFirNo": noFirNo, "NoDate": noDate, "NoType": noType,
		"Year": year, "StationID": stationID,
		"YearOpts": yearOpts, "StationOpts": stationOpts,
	}))
}

func weekSpan(i int) string {
	switch i {
	case 0:
		return "1st – 7th"
	case 1:
		return "8th – 14th"
	case 2:
		return "15th – 21st"
	case 3:
		return "22nd – 28th"
	}
	return "29th – 31st"
}

func max1(n int) int {
	if n < 1 {
		return 1
	}
	return n
}

func reverseRows(in []analyticsRow) []analyticsRow {
	out := make([]analyticsRow, len(in))
	for i, r := range in {
		out[len(in)-1-i] = r
	}
	return out
}

// sortedKeysAsc returns map keys oldest-first ("2025" / "2025-07" keys sort
// correctly as strings).
func sortedKeysAsc(m map[string]*analyticsKPI) []string {
	keys := make([]string, 0, len(m))
	for k := range m {
		keys = append(keys, k)
	}
	sort.Strings(keys)
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
