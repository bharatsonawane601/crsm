/// The CRMS Brain — fuzzy understanding engine.
///
/// Police operators type fast, in two scripts, with typos: "Dolatabad",
/// "दौलताबद", "chori", "खुन". This engine scores how close a typed string is
/// to a known value so the UI can SUGGEST the right one (it never silently
/// replaces what the officer wrote — the human always confirms).
///
/// How it works, in order:
///  1. Normalize (lowercase, strip punctuation/spacing, ASCII digits).
///  2. Transliterate Devanagari → Roman so "चोरी" and "chori" land in the
///     same space.
///  3. Compare with Levenshtein edit distance → similarity score 0..1.
library;

/// A fuzzy match candidate with its similarity score (1 = exact).
class BrainMatch {
  const BrainMatch(this.value, this.score);

  /// The canonical value that matched (e.g. "Daulatabad").
  final String value;

  /// 0..1 similarity; 1.0 is an exact (post-normalization) match.
  final double score;
}

/// Devanagari → Roman transliteration for matching (not for display).
/// Approximate on purpose: both sides of a comparison go through the same
/// mapping, so "khun"/"खून" and "chori"/"चोरी" converge.
const Map<String, String> _dev2roman = {
  // vowels (independent)
  'अ': 'a', 'आ': 'a', 'इ': 'i', 'ई': 'i', 'उ': 'u', 'ऊ': 'u',
  'ए': 'e', 'ऐ': 'ai', 'ओ': 'o', 'औ': 'au', 'ऋ': 'ru', 'ॲ': 'a', 'ऑ': 'o',
  // consonants
  'क': 'k', 'ख': 'kh', 'ग': 'g', 'घ': 'gh', 'ङ': 'n',
  'च': 'ch', 'छ': 'chh', 'ज': 'j', 'झ': 'jh', 'ञ': 'n',
  'ट': 't', 'ठ': 'th', 'ड': 'd', 'ढ': 'dh', 'ण': 'n',
  'त': 't', 'थ': 'th', 'द': 'd', 'ध': 'dh', 'न': 'n',
  'प': 'p', 'फ': 'ph', 'ब': 'b', 'भ': 'bh', 'म': 'm',
  'य': 'y', 'र': 'r', 'ल': 'l', 'व': 'v', 'ळ': 'l',
  'श': 'sh', 'ष': 'sh', 'स': 's', 'ह': 'h',
  'क्ष': 'ksh', 'ज्ञ': 'dny', 'त्र': 'tr', 'श्र': 'shr',
  // matras (dependent vowel signs)
  'ा': 'a', 'ि': 'i', 'ी': 'i', 'ु': 'u', 'ू': 'u',
  'े': 'e', 'ै': 'ai', 'ो': 'o', 'ौ': 'au', 'ृ': 'ru', 'ॉ': 'o', 'ॅ': 'a',
  // signs
  'ं': 'n', 'ँ': 'n', 'ः': '', '्': '', 'ऽ': '',
  // digits
  '०': '0', '१': '1', '२': '2', '३': '3', '४': '4',
  '५': '5', '६': '6', '७': '7', '८': '8', '९': '9',
};

/// Devanagari consonants — needed for the inherent-'a' (schwa) rule below.
const String _devConsonants = 'कखगघङचछजझञटठडढणतथदधनपफबभमयरलवळशषसह';

/// Normalizes + transliterates [s] into comparison space:
/// lowercase Roman letters and digits only.
///
/// Two extra rules make Devanagari and Roman typing converge:
///  * Schwa: a consonant followed by another consonant gets its inherent 'a'
///    (द ौ ल त ा ब ा द → "daulatabad", not "daultabad"), matching how people
///    actually type Marathi in Roman letters (final schwa dropped: खून→khun).
///  * Phonetic folding (both scripts): c→k (outside "ch"), w→v, ph→f, z→j,
///    ee→i, oo→u, double letters collapsed — so CIDCO≈सिडको, Chhavani≈छावणी.
String brainKey(String s) {
  final b = StringBuffer();
  final runes = s.toLowerCase().trim().runes.toList();
  for (var i = 0; i < runes.length; i++) {
    final ch = String.fromCharCode(runes[i]);
    final mapped = _dev2roman[ch];
    if (mapped != null) {
      b.write(mapped);
      // Inherent 'a' when this consonant is directly followed by another
      // consonant (no matra/virama in between).
      if (_devConsonants.contains(ch) && i + 1 < runes.length) {
        final next = String.fromCharCode(runes[i + 1]);
        if (_devConsonants.contains(next)) b.write('a');
      }
      continue;
    }
    final r = runes[i];
    final isAscii = (r >= 0x61 && r <= 0x7a) || (r >= 0x30 && r <= 0x39);
    if (isAscii) b.write(ch);
    // Everything else (spaces, punctuation, unknown marks) is dropped.
  }
  return _fold(b.toString());
}

/// Phonetic folding so different spellings of the same sound compare equal.
String _fold(String s) {
  s = s
      .replaceAll('chh', 'ch')
      .replaceAll('ee', 'i')
      .replaceAll('oo', 'u')
      .replaceAll('ph', 'f')
      .replaceAll('w', 'v')
      .replaceAll('z', 'j')
      .replaceAll('q', 'k');
  // c → k except when it starts "ch" (chori keeps its ch).
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    final c = s[i];
    if (c == 'c' && (i + 1 >= s.length || s[i + 1] != 'h')) {
      b.write('k');
    } else {
      b.write(c);
    }
  }
  s = b.toString();
  // Collapse doubled letters (aa→a, ll→l …).
  final out = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i == 0 || s[i] != s[i - 1]) out.write(s[i]);
  }
  return out.toString();
}

/// Levenshtein edit distance with a small early-exit budget.
int _editDistance(String a, String b) {
  if (a == b) return 0;
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  var prev = List<int>.generate(b.length + 1, (i) => i);
  final cur = List<int>.filled(b.length + 1, 0);
  for (var i = 0; i < a.length; i++) {
    cur[0] = i + 1;
    for (var j = 0; j < b.length; j++) {
      final cost = a.codeUnitAt(i) == b.codeUnitAt(j) ? 0 : 1;
      cur[j + 1] = [
        cur[j] + 1, // insertion
        prev[j + 1] + 1, // deletion
        prev[j] + cost, // substitution
      ].reduce((x, y) => x < y ? x : y);
    }
    prev = List<int>.from(cur);
  }
  return prev[b.length];
}

/// Similarity of two raw strings in 0..1 (1 = same after normalization).
/// Also rewards prefix/containment so partial typing scores well while the
/// officer is still mid-word.
double brainSimilarity(String typed, String candidate) {
  final a = brainKey(typed);
  final b = brainKey(candidate);
  if (a.isEmpty || b.isEmpty) return 0;
  if (a == b) return 1;
  // Mid-typing: "daula" should strongly suggest "daulatabad".
  if (b.startsWith(a) && a.length >= 3) return 0.93;
  if (b.contains(a) && a.length >= 4) return 0.85;
  final dist = _editDistance(a, b);
  final maxLen = a.length > b.length ? a.length : b.length;
  return 1 - dist / maxLen;
}

/// The best fuzzy matches of [typed] among [candidates], best first.
/// Only matches scoring >= [threshold] are returned.
List<BrainMatch> brainMatches(
  String typed,
  Iterable<String> candidates, {
  int limit = 5,
  double threshold = 0.65,
}) {
  if (typed.trim().isEmpty) return const [];
  final scored = <BrainMatch>[];
  for (final c in candidates) {
    final s = brainSimilarity(typed, c);
    if (s >= threshold) scored.add(BrainMatch(c, s));
  }
  scored.sort((x, y) => y.score.compareTo(x.score));
  return scored.length > limit ? scored.sublist(0, limit) : scored;
}

/// The single best match, or null if nothing clears [threshold].
/// [exactIsNull]: when the typed text already exactly equals a candidate
/// (post-normalization) return null — there is nothing to suggest.
BrainMatch? brainBest(
  String typed,
  Iterable<String> candidates, {
  double threshold = 0.72,
  bool exactIsNull = true,
}) {
  final m = brainMatches(typed, candidates, limit: 1, threshold: threshold);
  if (m.isEmpty) return null;
  if (exactIsNull && m.first.score >= 0.999) return null;
  return m.first;
}

/// --- Indian amount understanding -------------------------------------------
///
/// "1.5 लाख" → 150000, "2 कोटी" → 20000000, "3.5L" → 350000, "80 हजार" → 80000,
/// "1,20,000" → 120000. Returns null when the text isn't an amount.
double? parseIndianAmount(String raw) {
  var s = raw.toLowerCase().trim();
  if (s.isEmpty) return null;
  // Devanagari digits → ASCII.
  const dev = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
  for (var i = 0; i < 10; i++) {
    s = s.replaceAll(dev[i], '$i');
  }
  s = s.replaceAll('₹', '').replaceAll('rs.', '').replaceAll('rs', '').trim();

  double mult = 1;
  const units = <String, double>{
    'कोटी': 1e7, 'करोड': 1e7, 'crore': 1e7, 'cr': 1e7,
    'लाख': 1e5, 'लक्ष': 1e5, 'lakh': 1e5, 'lac': 1e5, 'lakhs': 1e5,
    'हजार': 1e3, 'thousand': 1e3,
  };
  for (final e in units.entries) {
    if (s.contains(e.key)) {
      mult = e.value;
      s = s.replaceAll(e.key, '').trim();
      break;
    }
  }
  // Single trailing letter units: 2.5L / 80k / 1.2c (only when it ends the text).
  if (mult == 1 && s.isNotEmpty) {
    final last = s[s.length - 1];
    if (last == 'l') {
      mult = 1e5;
      s = s.substring(0, s.length - 1);
    } else if (last == 'k') {
      mult = 1e3;
      s = s.substring(0, s.length - 1);
    }
  }
  s = s.replaceAll(',', '').replaceAll(' ', '');
  final n = double.tryParse(s);
  if (n == null) return null;
  return n * mult;
}
