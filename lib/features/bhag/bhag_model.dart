// "भाग १ ते ५" (Bhag 1 to 5) comparison report — data model + pure compute.
//
// Each row references a crime type chosen from the crime catalogue
// (kCrimeCategories). A FIR is counted into a row when its stored crimeType
// matches the row's value (or, when the row is a top-level category, when the
// FIR's crimeType falls under that category). दाखल = registered, उघड = detected.
//
// The two comparison blocks are user-controlled via [BhagPeriod]:
//   • month block  : the selected MONTH, Year A vs Year B
//   • पावेतो block  : cumulative Jan → selected month, Year A vs Year B
//   • सन column    : full calendar Year A
// घट/वाढ is (Year A दाखल − Year B दाखल): a negative value means crime rose.

import '../analyzer/analytics_model.dart';
import '../crime_entry/data/crime_types_data.dart';

/// Marathi month names, indexed 1..12.
const List<String> kMonthsMr = [
  '', 'जानेवारी', 'फेब्रुवारी', 'मार्च', 'एप्रिल', 'मे', 'जून',
  'जुलै', 'ऑगस्ट', 'सप्टेंबर', 'ऑक्टोबर', 'नोव्हेंबर', 'डिसेंबर',
];

/// Sub-row markers (अ, ब, क …) for sub-crimes listed under a parent.
const List<String> kSubMarkers = [
  'अ', 'ब', 'क', 'ड', 'इ', 'ई', 'उ', 'ऊ', 'ए', 'ऐ', 'ओ', 'औ',
];

/// The ten value cells of a report row.
const List<String> kBhagCellKeys = [
  'mAd', 'mAu', 'mBd', 'mBu', // selected month: A दाखल/उघड, B दाखल/उघड
  'yAd', 'yAu', 'yBd', 'yBu', // year-to-date: A दाखल/उघड, B दाखल/उघड
  'sAd', 'sAu', // सन (full year A) दाखल/उघड
];

/// One editable report row. Usually a single crime type (category or sub-type),
/// but an "other/इतर"-style row can bundle **several** crime types under a
/// custom [label]. A FIR counts into the row if it matches ANY of [crimeTypes].
class BhagRow {
  BhagRow({required this.id, required this.crimeTypes, this.label});

  final String id;
  List<String> crimeTypes; // one or more catalogue values ("English / मराठी")
  String? label; // custom display name (for combined / इतर rows)

  /// A plain single-type row (participates in category sub-crime nesting).
  bool get isSingle => crimeTypes.length == 1 && (label == null || label!.isEmpty);
  String get primary => crimeTypes.isEmpty ? '' : crimeTypes.first;

  Map<String, dynamic> toJson() =>
      {'id': id, 'crimeTypes': crimeTypes, if (label != null) 'label': label};

  factory BhagRow.fromJson(Map<String, dynamic> j) {
    final id = (j['id'] ?? '').toString();
    // New multi-type shape.
    if (j['crimeTypes'] is List) {
      return BhagRow(
        id: id,
        crimeTypes: [for (final t in (j['crimeTypes'] as List)) t.toString()],
        label: j['label'] as String?,
      );
    }
    // Migrate the old single-type shape.
    final ct = (j['crimeType'] ?? '').toString();
    return BhagRow(id: id, crimeTypes: ct.isEmpty ? [] : [ct]);
  }
}

/// The compared periods, all derived from the month + two year pickers.
class BhagPeriod {
  const BhagPeriod({required this.month, required this.yearA, required this.yearB});
  final int month; // 1..12
  final int yearA; // older / reference year (सन column, "A")
  final int yearB; // newer year ("B")

  String get signature => '${yearA}_${yearB}_$month';
}

/// Computed (and possibly overridden) values for one row.
class BhagRowResult {
  BhagRowResult(this.row);
  final BhagRow row;
  final Map<String, int> v = {for (final k in kBhagCellKeys) k: 0};

  int get val => 0;
  int cell(String k) => v[k] ?? 0;

  /// घट/वाढ on दाखल: Year A − Year B (negative ⇒ increase).
  int get gvMonth => cell('mAd') - cell('mBd');
  int get gvYtd => cell('yAd') - cell('yBd');
}

/// One serial-numbered group: a parent (category) row plus any sub-crime rows
/// broken out under it. The parent's numbers are the SUM of its [subs]; when a
/// group has no subs, the parent counts the whole category (or a custom type).
class BhagGroupResult {
  BhagGroupResult({
    required this.label,
    required this.parent,
    required this.subs,
    this.parentEditableRow,
  });

  final String label; // Marathi label shown in विवरण
  final BhagRowResult parent; // aggregated cells
  final List<BhagRowResult> subs; // indented अ/ब/क detail rows

  /// The config row behind the parent when it is directly editable (a whole
  /// category or a custom type). Null when the parent is derived from subs.
  final BhagRow? parentEditableRow;
}

class BhagTableData {
  BhagTableData({required this.groups, required this.total});
  final List<BhagGroupResult> groups;
  final BhagRowResult total;
}

bool _typeMatches(String type, String crimeType) {
  if (isCrimeCategoryLabel(type)) return crimeCategoryOf(crimeType) == type;
  return crimeType == type;
}

bool _rowMatches(BhagRow row, String? crimeType) {
  if (crimeType == null || crimeType.isEmpty) return false;
  return row.crimeTypes.any((t) => _typeMatches(t, crimeType));
}

/// The display label for a row: its custom name, else the single type's Marathi,
/// else the joined Marathi names of a multi-type (combined) row.
String rowLabel(BhagRow row) {
  if (row.label != null && row.label!.isNotEmpty) return row.label!;
  if (row.crimeTypes.isEmpty) return '';
  if (row.crimeTypes.length == 1) return crimeTypeMarathi(row.crimeTypes.first);
  return row.crimeTypes.map(crimeTypeMarathi).join(' + ');
}

void _bump(BhagRowResult rr, DateTime d, bool det, BhagPeriod period) {
  if (d.year == period.yearA) {
    rr.v['sAd'] = rr.v['sAd']! + 1;
    if (det) rr.v['sAu'] = rr.v['sAu']! + 1;
    if (d.month <= period.month) {
      rr.v['yAd'] = rr.v['yAd']! + 1;
      if (det) rr.v['yAu'] = rr.v['yAu']! + 1;
    }
    if (d.month == period.month) {
      rr.v['mAd'] = rr.v['mAd']! + 1;
      if (det) rr.v['mAu'] = rr.v['mAu']! + 1;
    }
  }
  if (d.year == period.yearB) {
    if (d.month <= period.month) {
      rr.v['yBd'] = rr.v['yBd']! + 1;
      if (det) rr.v['yBu'] = rr.v['yBu']! + 1;
    }
    if (d.month == period.month) {
      rr.v['mBd'] = rr.v['mBd']! + 1;
      if (det) rr.v['mBu'] = rr.v['mBu']! + 1;
    }
  }
}

BhagRowResult _sum(List<BhagRowResult> items, String id, String label) {
  final res = BhagRowResult(BhagRow(id: id, crimeTypes: const [], label: label));
  for (final it in items) {
    for (final k in kBhagCellKeys) {
      res.v[k] = res.v[k]! + it.v[k]!;
    }
  }
  return res;
}

/// Counts [firs] into the configured [config] rows for [period], applies manual
/// [overrides] (keyed "rowId|cellKey"), then groups sub-crimes under their
/// parent category (parent = sum of its sub-crimes). Pure & testable.
BhagTableData computeBhag({
  required List<AnalyticsRow> firs,
  required List<BhagRow> config,
  required BhagPeriod period,
  Map<String, int> overrides = const {},
}) {
  // 1) Raw per-row counts. A sub-type row counts exact matches; a whole-category
  //    row counts every FIR in that category.
  final perRow = {for (final r in config) r.id: BhagRowResult(r)};
  for (final fir in firs) {
    final d = fir.dateRegistered;
    if (d == null) continue;
    final det = fir.status == 'detected';
    for (final r in config) {
      if (_rowMatches(r, fir.crimeType)) _bump(perRow[r.id]!, d, det, period);
    }
  }

  // 2) Manual overrides win over the auto count.
  overrides.forEach((k, value) {
    final i = k.indexOf('|');
    if (i <= 0) return;
    final rr = perRow[k.substring(0, i)];
    final cell = k.substring(i + 1);
    if (rr != null && rr.v.containsKey(cell)) rr.v[cell] = value;
  });

  // 3) Group rows for display. Every single-type row (a whole category OR a
  //    sub-type) is keyed by its category, so a category row and any sub-crimes
  //    of it share ONE group — the sub-crimes nest under the existing category
  //    row instead of forming a duplicate group. When a category row is present
  //    the parent shows that category's own count; otherwise the parent is the
  //    sum of the listed sub-crimes. Combined / custom rows stay standalone.
  //    The officer's ordering is preserved.
  final order = <String>[];
  final byKey = <String, List<BhagRow>>{};
  for (final r in config) {
    final cat = r.isSingle ? crimeCategoryOf(r.primary) : null;
    final key = cat != null ? 'cat:$cat' : 'std:${r.id}';
    if (!byKey.containsKey(key)) order.add(key);
    byKey.putIfAbsent(key, () => []).add(r);
  }

  final groups = <BhagGroupResult>[];
  for (final key in order) {
    final rows = byKey[key]!;
    if (key.startsWith('cat:')) {
      final catLabel = key.substring(4);
      final label = crimeTypeMarathi(catLabel);
      // A category-level row (its single type IS the category) becomes the
      // editable parent; the rest are the indented sub-crimes.
      BhagRow? catRow;
      final subRows = <BhagRow>[];
      for (final r in rows) {
        if (catRow == null && isCrimeCategoryLabel(r.primary)) {
          catRow = r;
        } else {
          subRows.add(r);
        }
      }
      final subs = [for (final r in subRows) perRow[r.id]!];
      if (catRow != null) {
        groups.add(BhagGroupResult(
          label: label,
          parent: _sum([perRow[catRow.id]!], catRow.id, label),
          subs: subs,
          parentEditableRow: catRow,
        ));
      } else {
        groups.add(BhagGroupResult(
          label: label,
          parent: _sum(subs, 'grp_$key', label),
          subs: subs,
        ));
      }
    } else {
      final row = rows.first;
      final label = rowLabel(row);
      groups.add(BhagGroupResult(
        label: label,
        parent: _sum([perRow[row.id]!], row.id, label),
        subs: const [],
        parentEditableRow: row,
      ));
    }
  }

  final total = _sum([for (final g in groups) g.parent], '__total__', '');
  return BhagTableData(groups: groups, total: total);
}

/// The default भाग १ ते ५ preset, mapped to the closest crime categories.
/// Fully editable by the officer afterwards.
List<BhagRow> defaultBhagRows() {
  const labels = [
    'Murder / खून',
    'Attempt to Murder / खुनाचा प्रयत्न',
    'Dacoity / दरोडा',
    'Robbery / जबरी चोरी',
    'Burglary / House-breaking / घरफोडी',
    'Theft / चोरी',
    'Assault & Hurt / हल्ला व दुखापत',
    'Public Order / Riot / सार्वजनिक सुव्यवस्था / दंगल',
    'Sexual Offences / लैंगिक गुन्हे',
    'Accidental / Unnatural Death / अपघाती / अनैसर्गिक मृत्यू',
  ];
  return [
    for (var i = 0; i < labels.length; i++)
      BhagRow(id: 'def_$i', crimeTypes: [labels[i]]),
  ];
}

/// Default rows for भाग ६ — the local & special-Act heads (जुगार, दारूबंदी,
/// अंमली पदार्थ, शस्त्र). These used to be empty, which made the report open
/// as a blank table and look broken; the officer can still add, remove or
/// combine rows and their setup is what gets saved.
List<BhagRow> defaultBhag6Rows() {
  const labels = [
    'Gambling / जुगार',
    'Excise / Prohibition / दारूबंदी / उत्पादन शुल्क',
    'Narcotics (NDPS) / अंमली पदार्थ (एनडीपीएस)',
    'Arms & Explosives / शस्त्र व स्फोटके',
  ];
  return [
    for (var i = 0; i < labels.length; i++)
      BhagRow(id: 'b6_$i', crimeTypes: [labels[i]]),
  ];
}
