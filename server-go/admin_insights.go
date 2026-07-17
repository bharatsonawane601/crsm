package main

// The panel's "brain": scans the aggregated crime data for repeating patterns
// and anomalies and turns them into plain-language findings. Pure arithmetic on
// the aggregates the analytics page already computes — no extra queries, no
// external AI service (this data must never leave the server).

import (
	"fmt"
	"sort"
)

type insight struct {
	Icon  string
	Title string
	Body  string
	Tone  string // ok | warn | bad | info
}

var weekdayNames = [7]string{
	"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday",
}
var weekdayNamesMr = [7]string{
	"सोमवार", "मंगळवार", "बुधवार", "गुरुवार", "शुक्रवार", "शनिवार", "रविवार",
}

// analyticsAgg is everything the one-pass scan in adminAnalytics collects that
// the insight engine needs.
type analyticsAgg struct {
	kpi          *analyticsKPI
	byMonth      map[string]*analyticsKPI // "2006-01"
	byYear      map[string]*analyticsKPI // "2006"
	byStation    map[string]*analyticsKPI
	weekday      [7]int // 0 = Monday
	hour         [24]int
	timedTotal   int
	typeTotals   map[string]int
	typeWeekday  map[string]*[7]int
	stationMonth map[string]map[string]int
	byDate       map[string]int // "2006-01-02"
	datedTotal   int
	lostValue    float64
	recovered    float64
}

func buildInsights(a analyticsAgg) []insight {
	out := []insight{}

	// 1. Peak weekday — is one day clearly hotter than the average day?
	wdTotal := 0
	for _, n := range a.weekday {
		wdTotal += n
	}
	if wdTotal >= 35 {
		avg := float64(wdTotal) / 7
		peak, low := 0, 0
		for i := 1; i < 7; i++ {
			if a.weekday[i] > a.weekday[peak] {
				peak = i
			}
			if a.weekday[i] < a.weekday[low] {
				low = i
			}
		}
		if up := (float64(a.weekday[peak]) - avg) / avg * 100; up >= 15 {
			out = append(out, insight{
				Icon:  "📅",
				Title: fmt.Sprintf("%s (%s) is the peak crime day", weekdayNames[peak], weekdayNamesMr[peak]),
				Body: fmt.Sprintf("%d cases occurred on %ss — %.0f%% above the daily average of %.0f. Consider extra patrolling and bandobast on that day. Quietest day: %s (%d cases).",
					a.weekday[peak], weekdayNames[peak], up, avg, weekdayNames[low], a.weekday[low]),
				Tone: "warn",
			})
		}
	}

	// 2. Peak time band (3-hour windows from time_occurred).
	if a.timedTotal >= 30 {
		bandName := func(h int) string {
			end := (h + 3) % 24
			ampm := func(x int) string {
				switch {
				case x == 0:
					return "12 AM"
				case x < 12:
					return fmt.Sprintf("%d AM", x)
				case x == 12:
					return "12 PM"
				default:
					return fmt.Sprintf("%d PM", x-12)
				}
			}
			return ampm(h) + "–" + ampm(end)
		}
		bestStart, bestN := 0, -1
		for h := 0; h < 24; h += 3 {
			n := a.hour[h] + a.hour[h+1] + a.hour[h+2]
			if n > bestN {
				bestStart, bestN = h, n
			}
		}
		share := float64(bestN) / float64(a.timedTotal) * 100
		if share >= 20 {
			out = append(out, insight{
				Icon:  "🕘",
				Title: fmt.Sprintf("Most crimes happen between %s", bandName(bestStart)),
				Body: fmt.Sprintf("%d of %d cases with a recorded time (%.0f%%) fall in this window. Night/evening beat planning should focus here.",
					bestN, a.timedTotal, share),
				Tone: "warn",
			})
		}
	}

	// 3. Crime loops: a crime type that keeps repeating on the same weekday.
	type loop struct {
		typ   string
		day   int
		n     int
		share float64
	}
	var loops []loop
	for typ, wd := range a.typeWeekday {
		total := 0
		peak := 0
		for i, n := range wd {
			total += n
			if n > wd[peak] {
				peak = i
			}
		}
		if total < 14 {
			continue
		}
		share := float64(wd[peak]) / float64(total)
		if share >= 0.30 { // expected 1/7 ≈ 14% — 30%+ is a real pattern
			loops = append(loops, loop{typ, peak, wd[peak], share})
		}
	}
	sort.Slice(loops, func(i, j int) bool { return loops[i].share > loops[j].share })
	for i, l := range loops {
		if i >= 3 {
			break
		}
		out = append(out, insight{
			Icon:  "🔁",
			Title: fmt.Sprintf("Repeating pattern: %s on %ss", shortLabel(l.typ, 30), weekdayNames[l.day]),
			Body: fmt.Sprintf("%.0f%% of \"%s\" cases (%d of them) occur on %s (%s) — far above the ~14%% expected by chance. This looks like an organised/repeat-offender loop worth targeting.",
				l.share*100, shortLabel(l.typ, 40), l.n, weekdayNames[l.day], weekdayNamesMr[l.day]),
			Tone: "bad",
		})
	}

	// 4. Three-month trend: rising or falling?
	monthKeys := make([]string, 0, len(a.byMonth))
	for k := range a.byMonth {
		monthKeys = append(monthKeys, k)
	}
	sort.Strings(monthKeys)
	if len(monthKeys) >= 6 {
		last3, prev3 := 0, 0
		for _, k := range monthKeys[len(monthKeys)-3:] {
			last3 += a.byMonth[k].Total
		}
		for _, k := range monthKeys[len(monthKeys)-6 : len(monthKeys)-3] {
			prev3 += a.byMonth[k].Total
		}
		if prev3 >= 10 {
			change := (float64(last3) - float64(prev3)) / float64(prev3) * 100
			switch {
			case change >= 15:
				out = append(out, insight{
					Icon:  "📈",
					Title: fmt.Sprintf("Crime is rising: +%.0f%% in the last 3 months", change),
					Body: fmt.Sprintf("The last three months (%s to %s) logged %d cases vs %d in the three months before — an upward trend to watch.",
						monthKeys[len(monthKeys)-3], monthKeys[len(monthKeys)-1], last3, prev3),
					Tone: "bad",
				})
			case change <= -15:
				out = append(out, insight{
					Icon:  "📉",
					Title: fmt.Sprintf("Crime is falling: %.0f%% in the last 3 months", change),
					Body: fmt.Sprintf("The last three months logged %d cases vs %d in the previous three — a clear improvement.",
						last3, prev3),
					Tone: "ok",
				})
			}
		}
	}

	// 5. Station spike: which station jumped the most in the latest month?
	if len(monthKeys) >= 2 {
		latest := monthKeys[len(monthKeys)-1]
		prior := monthKeys[:len(monthKeys)-1]
		if len(prior) > 3 {
			prior = prior[len(prior)-3:]
		}
		bestName, bestNow, bestAvg, bestUp := "", 0, 0.0, 0.0
		for st, months := range a.stationMonth {
			now := months[latest]
			if now < 5 {
				continue
			}
			sum := 0
			for _, k := range prior {
				sum += months[k]
			}
			avg := float64(sum) / float64(len(prior))
			if avg < 1 {
				avg = 1
			}
			up := (float64(now) - avg) / avg * 100
			if up > bestUp {
				bestName, bestNow, bestAvg, bestUp = st, now, avg, up
			}
		}
		if bestUp >= 50 {
			out = append(out, insight{
				Icon:  "🚨",
				Title: fmt.Sprintf("Spike at %s in %s", bestName, latest),
				Body: fmt.Sprintf("%s recorded %d cases in %s against a ~%.0f/month average over the previous months (+%.0f%%). Worth reviewing what changed there.",
					bestName, bestNow, latest, bestAvg, bestUp),
				Tone: "bad",
			})
		}
	}

	// 6. Hot dates: one specific date with an abnormal cluster of crimes.
	if a.datedTotal >= 60 && len(a.byDate) > 0 {
		avgPerDay := float64(a.datedTotal) / float64(len(a.byDate))
		bestDate, bestN := "", 0
		for d, n := range a.byDate {
			if n > bestN {
				bestDate, bestN = d, n
			}
		}
		if float64(bestN) >= 3*avgPerDay && bestN >= 5 {
			out = append(out, insight{
				Icon:  "📌",
				Title: fmt.Sprintf("Unusual cluster on %s", bestDate),
				Body: fmt.Sprintf("%d cases occurred on this single date — about %.0f× the typical day (%.1f cases). Check whether these are one incident filed as many FIRs, a festival/event day, or a data-entry batch.",
					bestN, float64(bestN)/avgPerDay, avgPerDay),
				Tone: "warn",
			})
		}
	}

	// 7. Detection-rate league: celebrate the best, flag the weakest.
	type stR struct {
		name string
		k    *analyticsKPI
	}
	var big []stR
	for name, k := range a.byStation {
		if k.Total >= 20 && name != "(no station)" {
			big = append(big, stR{name, k})
		}
	}
	if len(big) >= 2 {
		sort.Slice(big, func(i, j int) bool {
			return float64(big[i].k.Detected)/float64(big[i].k.Total) >
				float64(big[j].k.Detected)/float64(big[j].k.Total)
		})
		top, bot := big[0], big[len(big)-1]
		out = append(out, insight{
			Icon:  "🏆",
			Title: fmt.Sprintf("Best detection: %s (%s%%)", top.name, top.k.DetectedPct()),
			Body: fmt.Sprintf("%s leads with %d of %d cases detected. Lowest: %s at %s%% (%d of %d) — may need investigation support.",
				top.name, top.k.Detected, top.k.Total, bot.name, bot.k.DetectedPct(), bot.k.Detected, bot.k.Total),
			Tone: "ok",
		})
	}

	// 8. Muddemal recovery health.
	if a.lostValue > 0 {
		rate := a.recovered / a.lostValue * 100
		tone := "ok"
		if rate < 30 {
			tone = "bad"
		} else if rate < 60 {
			tone = "warn"
		}
		out = append(out, insight{
			Icon:  "💰",
			Title: fmt.Sprintf("Property recovery rate: %.1f%%", rate),
			Body: fmt.Sprintf("Of %s worth of property involved, %s has been recovered — %s is still outstanding.",
				fmtINRShort(a.lostValue), fmtINRShort(a.recovered), fmtINRShort(a.lostValue-a.recovered)),
			Tone: tone,
		})
	}

	// 9. Year-over-year detection movement.
	yearKeys := make([]string, 0, len(a.byYear))
	for k := range a.byYear {
		yearKeys = append(yearKeys, k)
	}
	sort.Strings(yearKeys)
	if len(yearKeys) >= 2 {
		cur, prev := a.byYear[yearKeys[len(yearKeys)-1]], a.byYear[yearKeys[len(yearKeys)-2]]
		if cur.Total >= 30 && prev.Total >= 30 {
			curR := float64(cur.Detected) / float64(cur.Total) * 100
			prevR := float64(prev.Detected) / float64(prev.Total) * 100
			diff := curR - prevR
			if diff >= 5 {
				out = append(out, insight{
					Icon: "✅", Tone: "ok",
					Title: fmt.Sprintf("Detection improved: %.1f%% in %s (was %.1f%%)", curR, yearKeys[len(yearKeys)-1], prevR),
					Body:  fmt.Sprintf("Detection rate moved up %.1f points versus %s.", diff, yearKeys[len(yearKeys)-2]),
				})
			} else if diff <= -5 {
				out = append(out, insight{
					Icon: "⚠️", Tone: "warn",
					Title: fmt.Sprintf("Detection slipped: %.1f%% in %s (was %.1f%%)", curR, yearKeys[len(yearKeys)-1], prevR),
					Body:  fmt.Sprintf("Detection rate is down %.1f points versus %s.", -diff, yearKeys[len(yearKeys)-2]),
				})
			}
		}
	}

	if len(out) == 0 {
		out = append(out, insight{
			Icon: "🧠", Tone: "info",
			Title: "No unusual patterns detected",
			Body:  "Crime is spread evenly across days, times and stations for the selected filter. Patterns appear here automatically as more dated records sync in.",
		})
	}
	return out
}
