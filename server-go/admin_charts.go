package main

// Server-rendered SVG charts for the admin panel. The panel is tailnet-only
// and must stay self-contained (no CDN JS), so every chart is built here as an
// inline <svg> string and dropped into the template as template.HTML. Labels
// are HTML-escaped; hover values use native <title> tooltips.

import (
	"fmt"
	"html/template"
	"math"
	"strings"
	"time"
)

// --- Time (the panel audience is in India — everything renders in IST) ------

var istLoc = time.FixedZone("IST", 5*3600+30*60)

func istStamp(t time.Time) string { return t.In(istLoc).Format("02 Jan 2006, 3:04 PM") }
func istDate(t time.Time) string  { return t.In(istLoc).Format("02 Jan 2006") }

// --- Money (Indian digit grouping: ₹12,34,56,789) ---------------------------

func fmtINR(v float64) string {
	sign := ""
	if v < 0 {
		sign = "-"
		v = -v
	}
	s := fmt.Sprintf("%.0f", v)
	if len(s) > 3 {
		head, tail := s[:len(s)-3], s[len(s)-3:]
		var parts []string
		for len(head) > 2 {
			parts = append([]string{head[len(head)-2:]}, parts...)
			head = head[:len(head)-2]
		}
		if head != "" {
			parts = append([]string{head}, parts...)
		}
		s = strings.Join(parts, ",") + "," + tail
	}
	return sign + "₹" + s
}

// fmtINRShort compacts to lakh / crore for KPI cards.
func fmtINRShort(v float64) string {
	a := math.Abs(v)
	switch {
	case a >= 1e7:
		return fmt.Sprintf("₹%.2f Cr", v/1e7)
	case a >= 1e5:
		return fmt.Sprintf("₹%.2f L", v/1e5)
	default:
		return fmtINR(v)
	}
}

// --- Shared chart bits -------------------------------------------------------

type chartPoint struct {
	Label string
	Value float64
	// Extra line for the tooltip (e.g. "detection 54%"). Optional.
	Hint string
}

func esc(s string) string { return template.HTMLEscapeString(s) }

func maxVal(pts []chartPoint) float64 {
	m := 1.0
	for _, p := range pts {
		if p.Value > m {
			m = p.Value
		}
	}
	return m
}

// niceCeil rounds the axis max up to a friendly number (1/2/5 × 10^n).
func niceCeil(v float64) float64 {
	if v <= 0 {
		return 1
	}
	p := math.Pow(10, math.Floor(math.Log10(v)))
	for _, m := range []float64{1, 2, 5, 10} {
		if m*p >= v {
			return m * p
		}
	}
	return 10 * p
}

func fmtTick(v float64) string {
	switch {
	case v >= 1e7:
		return fmt.Sprintf("%.3gCr", v/1e7)
	case v >= 1e5:
		return fmt.Sprintf("%.3gL", v/1e5)
	case v >= 1e3:
		return fmt.Sprintf("%.3gk", v/1e3)
	}
	return fmt.Sprintf("%g", v)
}

// --- Vertical bar chart ------------------------------------------------------

// svgVBars draws a vertical bar chart. Good for weekday / hour / week buckets.
func svgVBars(pts []chartPoint, color string) template.HTML {
	if len(pts) == 0 {
		return emptyChart()
	}
	const W, H = 620, 270
	const padL, padR, padT, padB = 44, 10, 14, 40
	plotW, plotH := float64(W-padL-padR), float64(H-padT-padB)
	max := niceCeil(maxVal(pts))

	var b strings.Builder
	fmt.Fprintf(&b, `<svg viewBox="0 0 %d %d" class="chart" role="img">`, W, H)
	// horizontal grid + ticks
	for i := 0; i <= 4; i++ {
		y := float64(padT) + plotH*float64(i)/4
		v := max * float64(4-i) / 4
		fmt.Fprintf(&b, `<line x1="%d" y1="%.1f" x2="%d" y2="%.1f" class="grid"/>`, padL, y, W-padR, y)
		fmt.Fprintf(&b, `<text x="%d" y="%.1f" class="tick" text-anchor="end">%s</text>`, padL-7, y+4, fmtTick(v))
	}
	n := len(pts)
	step := plotW / float64(n)
	barW := step * 0.62
	if barW > 46 {
		barW = 46
	}
	labelEvery := 1
	if n > 14 {
		labelEvery = (n + 13) / 14
	}
	for i, p := range pts {
		h := plotH * p.Value / max
		x := float64(padL) + step*float64(i) + (step-barW)/2
		y := float64(padT) + plotH - h
		tip := fmt.Sprintf("%s — %g", p.Label, p.Value)
		if p.Hint != "" {
			tip += " · " + p.Hint
		}
		fmt.Fprintf(&b,
			`<g><rect x="%.1f" y="%.1f" width="%.1f" height="%.1f" rx="4" fill="%s" class="vbar"><title>%s</title></rect></g>`,
			x, y, barW, h, color, esc(tip))
		if i%labelEvery == 0 {
			fmt.Fprintf(&b, `<text x="%.1f" y="%d" class="lbl" text-anchor="middle">%s</text>`,
				x+barW/2, H-padB+18, esc(shortLabel(p.Label, 8)))
		}
	}
	b.WriteString(`</svg>`)
	return template.HTML(b.String())
}

// --- Line / area chart -------------------------------------------------------

// svgLine draws a smooth-ish area line, chronological left→right.
func svgLine(pts []chartPoint, color string) template.HTML {
	if len(pts) == 0 {
		return emptyChart()
	}
	const W, H = 620, 270
	const padL, padR, padT, padB = 44, 14, 14, 40
	plotW, plotH := float64(W-padL-padR), float64(H-padT-padB)
	max := niceCeil(maxVal(pts))

	var b strings.Builder
	fmt.Fprintf(&b, `<svg viewBox="0 0 %d %d" class="chart" role="img">`, W, H)
	for i := 0; i <= 4; i++ {
		y := float64(padT) + plotH*float64(i)/4
		v := max * float64(4-i) / 4
		fmt.Fprintf(&b, `<line x1="%d" y1="%.1f" x2="%d" y2="%.1f" class="grid"/>`, padL, y, W-padR, y)
		fmt.Fprintf(&b, `<text x="%d" y="%.1f" class="tick" text-anchor="end">%s</text>`, padL-7, y+4, fmtTick(v))
	}
	n := len(pts)
	xAt := func(i int) float64 {
		if n == 1 {
			return float64(padL) + plotW/2
		}
		return float64(padL) + plotW*float64(i)/float64(n-1)
	}
	yAt := func(v float64) float64 { return float64(padT) + plotH - plotH*v/max }

	var line, area strings.Builder
	fmt.Fprintf(&area, "M %.1f %.1f ", xAt(0), float64(padT)+plotH)
	for i, p := range pts {
		cmd := "L"
		if i == 0 {
			cmd = "M"
		}
		fmt.Fprintf(&line, "%s %.1f %.1f ", cmd, xAt(i), yAt(p.Value))
		fmt.Fprintf(&area, "L %.1f %.1f ", xAt(i), yAt(p.Value))
	}
	fmt.Fprintf(&area, "L %.1f %.1f Z", xAt(n-1), float64(padT)+plotH)
	fmt.Fprintf(&b, `<path d="%s" fill="%s" opacity="0.14"/>`, area.String(), color)
	fmt.Fprintf(&b, `<path d="%s" fill="none" stroke="%s" stroke-width="2.5" stroke-linejoin="round"/>`, line.String(), color)

	labelEvery := 1
	if n > 12 {
		labelEvery = (n + 11) / 12
	}
	for i, p := range pts {
		tip := fmt.Sprintf("%s — %g", p.Label, p.Value)
		if p.Hint != "" {
			tip += " · " + p.Hint
		}
		fmt.Fprintf(&b, `<circle cx="%.1f" cy="%.1f" r="3.4" fill="%s" class="dot"><title>%s</title></circle>`,
			xAt(i), yAt(p.Value), color, esc(tip))
		if i%labelEvery == 0 {
			fmt.Fprintf(&b, `<text x="%.1f" y="%d" class="lbl" text-anchor="middle">%s</text>`,
				xAt(i), H-padB+18, esc(shortLabel(p.Label, 7)))
		}
	}
	b.WriteString(`</svg>`)
	return template.HTML(b.String())
}

// --- Horizontal bar chart ----------------------------------------------------

// svgHBars draws ranked horizontal bars — for crime types and station leagues.
// Height grows with the row count so it pairs with a same-height table.
func svgHBars(pts []chartPoint, color string) template.HTML {
	if len(pts) == 0 {
		return emptyChart()
	}
	const W = 620
	const rowH, padT, padB = 30, 8, 8
	const labelW = 168
	H := padT + padB + rowH*len(pts)
	plotW := float64(W - labelW - 66)
	max := maxVal(pts)

	var b strings.Builder
	fmt.Fprintf(&b, `<svg viewBox="0 0 %d %d" class="chart" role="img">`, W, H)
	for i, p := range pts {
		y := float64(padT + i*rowH)
		w := plotW * p.Value / max
		if w < 2 {
			w = 2
		}
		tip := fmt.Sprintf("%s — %g", p.Label, p.Value)
		if p.Hint != "" {
			tip += " · " + p.Hint
		}
		fmt.Fprintf(&b, `<text x="%d" y="%.1f" class="lbl" text-anchor="end">%s</text>`,
			labelW-8, y+rowH/2+4, esc(shortLabel(p.Label, 20)))
		fmt.Fprintf(&b,
			`<rect x="%d" y="%.1f" width="%.1f" height="%d" rx="5" fill="%s" class="vbar"><title>%s</title></rect>`,
			labelW, y+5, w, rowH-10, color, esc(tip))
		fmt.Fprintf(&b, `<text x="%.1f" y="%.1f" class="val">%g</text>`,
			float64(labelW)+w+8, y+rowH/2+4, p.Value)
	}
	b.WriteString(`</svg>`)
	return template.HTML(b.String())
}

// --- Donut -------------------------------------------------------------------

type donutSeg struct {
	Label string
	Value float64
	Color string
}

// svgDonut draws a donut with a center headline (e.g. total count).
func svgDonut(segs []donutSeg, center, caption string) template.HTML {
	total := 0.0
	for _, s := range segs {
		total += s.Value
	}
	if total <= 0 {
		return emptyChart()
	}
	const W, H = 620, 270
	cx, cy, r := 150.0, 135.0, 88.0
	circ := 2 * math.Pi * r

	var b strings.Builder
	fmt.Fprintf(&b, `<svg viewBox="0 0 %d %d" class="chart" role="img">`, W, H)
	off := 0.0
	for _, s := range segs {
		frac := s.Value / total
		dash := frac * circ
		fmt.Fprintf(&b,
			`<circle cx="%.0f" cy="%.0f" r="%.0f" fill="none" stroke="%s" stroke-width="30" stroke-dasharray="%.2f %.2f" stroke-dashoffset="%.2f" transform="rotate(-90 %.0f %.0f)"><title>%s — %g (%.1f%%)</title></circle>`,
			cx, cy, r, s.Color, dash, circ-dash, -off, cx, cy, esc(s.Label), s.Value, frac*100)
		off += dash
	}
	fmt.Fprintf(&b, `<text x="%.0f" y="%.0f" class="donut-big" text-anchor="middle">%s</text>`, cx, cy-2, esc(center))
	fmt.Fprintf(&b, `<text x="%.0f" y="%.0f" class="tick" text-anchor="middle">%s</text>`, cx, cy+20, esc(caption))
	// legend
	ly := 60.0
	for _, s := range segs {
		frac := s.Value / total * 100
		fmt.Fprintf(&b, `<rect x="300" y="%.0f" width="12" height="12" rx="3" fill="%s"/>`, ly-10, s.Color)
		fmt.Fprintf(&b, `<text x="320" y="%.0f" class="leg">%s — %g (%.1f%%)</text>`, ly, esc(shortLabel(s.Label, 26)), s.Value, frac)
		ly += 26
	}
	b.WriteString(`</svg>`)
	return template.HTML(b.String())
}

func emptyChart() template.HTML {
	return template.HTML(`<div class="nodata">No data yet</div>`)
}

// shortLabel trims long labels for axis space (rune-safe for Marathi).
func shortLabel(s string, n int) string {
	r := []rune(s)
	if len(r) <= n {
		return s
	}
	return string(r[:n-1]) + "…"
}
