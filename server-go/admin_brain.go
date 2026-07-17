package main

// The panel's spelling brain — Go twin of lib/features/brain/fuzzy.dart.
// Transliterates Devanagari to Roman and scores edit distance, so an admin
// typing "vahan chori", "चोरि" or "Dolatabad" into FIR search still gets
// pointed at the right records via a "did you mean" suggestion.

import (
	"sort"
	"strings"
)

var dev2roman = map[rune]string{
	'अ': "a", 'आ': "a", 'इ': "i", 'ई': "i", 'उ': "u", 'ऊ': "u",
	'ए': "e", 'ऐ': "ai", 'ओ': "o", 'औ': "au", 'ऋ': "ru", 'ॲ': "a", 'ऑ': "o",
	'क': "k", 'ख': "kh", 'ग': "g", 'घ': "gh", 'ङ': "n",
	'च': "ch", 'छ': "chh", 'ज': "j", 'झ': "jh", 'ञ': "n",
	'ट': "t", 'ठ': "th", 'ड': "d", 'ढ': "dh", 'ण': "n",
	'त': "t", 'थ': "th", 'द': "d", 'ध': "dh", 'न': "n",
	'प': "p", 'फ': "ph", 'ब': "b", 'भ': "bh", 'म': "m",
	'य': "y", 'र': "r", 'ल': "l", 'व': "v", 'ळ': "l",
	'श': "sh", 'ष': "sh", 'स': "s", 'ह': "h",
	'ा': "a", 'ि': "i", 'ी': "i", 'ु': "u", 'ू': "u",
	'े': "e", 'ै': "ai", 'ो': "o", 'ौ': "au", 'ृ': "ru", 'ॉ': "o", 'ॅ': "a",
	'ं': "n", 'ँ': "n", 'ः': "", '्': "", 'ऽ': "",
	'०': "0", '१': "1", '२': "2", '३': "3", '४': "4",
	'५': "5", '६': "6", '७': "7", '८': "8", '९': "9",
}

const devConsonants = "कखगघङचछजझञटठडढणतथदधनपफबभमयरलवळशषसह"

// brainKeyGo lowercases, transliterates and strips to [a-z0-9], with the same
// schwa + phonetic-folding rules as the Dart twin (see fuzzy.dart).
func brainKeyGo(s string) string {
	runes := []rune(strings.ToLower(strings.TrimSpace(s)))
	var b strings.Builder
	for i, r := range runes {
		if m, ok := dev2roman[r]; ok {
			b.WriteString(m)
			// Inherent 'a' between two directly-adjacent consonants.
			if strings.ContainsRune(devConsonants, r) && i+1 < len(runes) &&
				strings.ContainsRune(devConsonants, runes[i+1]) {
				b.WriteByte('a')
			}
			continue
		}
		if (r >= 'a' && r <= 'z') || (r >= '0' && r <= '9') {
			b.WriteRune(r)
		}
	}
	return foldPhonetic(b.String())
}

// foldPhonetic — different spellings of the same sound compare equal.
func foldPhonetic(s string) string {
	rep := strings.NewReplacer(
		"chh", "ch", "ee", "i", "oo", "u", "ph", "f", "w", "v", "z", "j", "q", "k")
	s = rep.Replace(s)
	var b strings.Builder
	for i := 0; i < len(s); i++ {
		c := s[i]
		if c == 'c' && (i+1 >= len(s) || s[i+1] != 'h') {
			b.WriteByte('k')
			continue
		}
		b.WriteByte(c)
	}
	s = b.String()
	var out strings.Builder
	for i := 0; i < len(s); i++ {
		if i == 0 || s[i] != s[i-1] {
			out.WriteByte(s[i])
		}
	}
	return out.String()
}

func editDist(a, b string) int {
	if a == b {
		return 0
	}
	prev := make([]int, len(b)+1)
	cur := make([]int, len(b)+1)
	for j := range prev {
		prev[j] = j
	}
	for i := 0; i < len(a); i++ {
		cur[0] = i + 1
		for j := 0; j < len(b); j++ {
			cost := 1
			if a[i] == b[j] {
				cost = 0
			}
			m := cur[j] + 1
			if prev[j+1]+1 < m {
				m = prev[j+1] + 1
			}
			if prev[j]+cost < m {
				m = prev[j] + cost
			}
			cur[j+1] = m
		}
		copy(prev, cur)
	}
	return prev[len(b)]
}

func brainScore(typed, candidate string) float64 {
	a, b := brainKeyGo(typed), brainKeyGo(candidate)
	if a == "" || b == "" {
		return 0
	}
	if a == b {
		return 1
	}
	if len(a) >= 3 && strings.Contains(b, a) {
		return 0.9
	}
	d := editDist(a, b)
	max := len(a)
	if len(b) > max {
		max = len(b)
	}
	return 1 - float64(d)/float64(max)
}

// brainSuggestions returns up to [limit] candidates closest to the query,
// best first, above a sane threshold.
func brainSuggestions(q string, candidates []string, limit int) []string {
	type scored struct {
		v string
		s float64
	}
	var list []scored
	seen := map[string]bool{}
	for _, c := range candidates {
		if c == "" || seen[c] {
			continue
		}
		seen[c] = true
		if s := brainScore(q, c); s >= 0.6 {
			list = append(list, scored{c, s})
		}
	}
	sort.Slice(list, func(i, j int) bool { return list[i].s > list[j].s })
	out := []string{}
	for _, e := range list {
		out = append(out, e.v)
		if len(out) >= limit {
			break
		}
	}
	return out
}
