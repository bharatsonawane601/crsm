import '../analyzer/analytics_model.dart';
import '../crime_entry/data/crime_types_data.dart';

/// Report id for the "उघडकीस न आलेल्या भाग १ ते ५" (undetected major-head crimes)
/// station-wise review.
const String kUndetectedReportId = 'undet15';

/// True when a crime is still undetected (not detected / solved / chargesheeted).
bool isUndetected(AnalyticsRow r) =>
    r.status != 'detected' && r.status != 'solved' && r.status != 'chargesheeted';

/// One row (हेड). Matches a crime when its category is in [categories] OR its
/// exact crime-type is in [types]. [informational] rows (मो.वा.चोरी, मोबाईलचोरी)
/// are subsets shown with ** and excluded from column/grand totals. [isRemainder]
/// (इतर) catches undetected भाग-1-5 crimes not claimed by any other serial row.
class UndetRow {
  const UndetRow({
    required this.id,
    required this.label,
    this.categories = const {},
    this.types = const {},
    this.informational = false,
    this.isRemainder = false,
  });

  final String id;
  final String label;
  final Set<String> categories;
  final Set<String> types;
  final bool informational;
  final bool isRemainder;

  bool matches(String? crimeType) {
    if (crimeType == null) return false;
    if (types.contains(crimeType)) return true;
    final cat = crimeCategoryOf(crimeType);
    return cat != null && categories.contains(cat);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'categories': categories.toList(),
        'types': types.toList(),
        'informational': informational,
        'isRemainder': isRemainder,
      };

  factory UndetRow.fromJson(Map<String, dynamic> j) => UndetRow(
        id: (j['id'] ?? '').toString(),
        label: (j['label'] ?? '').toString(),
        categories: {for (final c in (j['categories'] as List? ?? [])) c.toString()},
        types: {for (final t in (j['types'] as List? ?? [])) t.toString()},
        informational: j['informational'] == true,
        isRemainder: j['isRemainder'] == true,
      );
}

/// One computed row: a count per station + the row total.
class UndetRowResult {
  UndetRowResult({required this.row, required this.byStation});
  final UndetRow row;
  final Map<String, int> byStation;

  int at(String station) => byStation[station] ?? 0;
  int get total => byStation.values.fold(0, (s, v) => s + v);
}

/// The whole matrix: station columns, row results, column totals + grand total.
class UndetData {
  UndetData({
    required this.stations,
    required this.rows,
    required this.colTotals,
  });
  final List<String> stations;
  final List<UndetRowResult> rows;

  /// Column totals over the serial (non-informational) rows only.
  final Map<String, int> colTotals;

  int get grandTotal => colTotals.values.fold(0, (s, v) => s + v);
}

/// The date range the report covers (दिनांक … ते … पावेतो).
class UndetRange {
  const UndetRange({required this.from, required this.to});
  final DateTime from;
  final DateTime to;

  // Inclusive of the whole "to" day, so a record registered at e.g. 14:30 on
  // the end date still counts: [from, to+1day 00:00).
  bool includes(DateTime? d) =>
      d != null &&
      !d.isBefore(from) &&
      d.isBefore(
          DateTime(to.year, to.month, to.day).add(const Duration(days: 1)));

  String get signature =>
      '${from.toIso8601String().split('T').first}..${to.toIso8601String().split('T').first}';
}

/// The categories that make up the भाग-1-5 "universe" — used by the इतर remainder
/// row so it only sweeps up major-head (body / property / public-order) crimes.
Set<String> defaultUniverse() => {
      'Murder / खून',
      'Attempt to Murder / खुनाचा प्रयत्न',
      'Culpable Homicide / सदोष मनुष्यवध',
      'Kidnapping & Abduction / अपहरण व पळवून नेणे',
      'Human Trafficking / मानवी तस्करी',
      'Sexual Offences / लैंगिक गुन्हे',
      'Crimes against Children (POCSO) / बाल अत्याचार (पोक्सो)',
      'Assault & Hurt / हल्ला व दुखापत',
      'Defamation & Intimidation / बदनामी व धमकी',
      'Robbery / जबरी चोरी',
      'Dacoity / दरोडा',
      'Theft / चोरी',
      'Burglary / House-breaking / घरफोडी',
      'Extortion / खंडणी',
      'Cheating & Fraud / फसवणूक',
      'Criminal Breach of Trust / विश्वासघात',
      'Forgery & Counterfeiting / बनावटगिरी',
      'Property / Mischief / Arson / मालमत्ता गुन्हे',
      'Public Order / Riot / सार्वजनिक सुव्यवस्था / दंगल',
    };

/// The default rows exactly as the sheet: the major heads, सर्व चोरी with its two
/// ** subsets, and the इतर remainder.
List<UndetRow> defaultUndetRows() => const [
      UndetRow(id: 'murder', label: 'खुन', categories: {'Murder / खून'}),
      UndetRow(
          id: 'attempt',
          label: 'खुनाचा प्रयत्न',
          categories: {'Attempt to Murder / खुनाचा प्रयत्न'}),
      UndetRow(id: 'rape', label: 'बलत्कार', types: {
        'Rape / बलात्कार',
        'Gang Rape / सामूहिक बलात्कार',
        'Attempt to Rape / बलात्काराचा प्रयत्न',
      }),
      UndetRow(id: 'dacoity', label: 'दरोडा', categories: {'Dacoity / दरोडा'}),
      UndetRow(id: 'robbery', label: 'जबरी चोरी', categories: {'Robbery / जबरी चोरी'}),
      UndetRow(
          id: 'burglary',
          label: 'घरफोडी',
          categories: {'Burglary / House-breaking / घरफोडी'}),
      UndetRow(id: 'theft', label: 'सर्व चोरी', categories: {'Theft / चोरी'}),
      UndetRow(id: 'mvtheft', label: 'मो.वा.चोरी', informational: true, types: {
        'Vehicle Theft / वाहन चोरी',
        'Two-Wheeler Theft / दुचाकी चोरी',
        'Four-Wheeler Theft / चारचाकी चोरी',
      }),
      UndetRow(
          id: 'mobtheft',
          label: 'मोबाईलचोरी',
          informational: true,
          types: {'Mobile Theft / मोबाईल चोरी'}),
      UndetRow(
          id: 'riot',
          label: 'गर्दीमारामारी',
          categories: {'Public Order / Riot / सार्वजनिक सुव्यवस्था / दंगल'}),
      UndetRow(
          id: 'hurt', label: 'दुखापत', categories: {'Assault & Hurt / हल्ला व दुखापत'}),
      UndetRow(id: 'other', label: 'इतर भाग १ ते ५', isRemainder: true),
    ];

/// Builds the undetected matrix. Serial rows are mutually exclusive (first match
/// in list order wins); इतर sweeps the remaining universe crimes; informational
/// rows are tallied independently. [overrides] replaces a cell, keyed
/// "rowId|station".
UndetData computeUndetected({
  required List<AnalyticsRow> firs,
  required List<UndetRow> config,
  required Set<String> universe,
  required List<String> stations,
  required UndetRange range,
  Map<String, int> overrides = const {},
}) {
  final serial = [for (final r in config) if (!r.informational) r];
  final informational = [for (final r in config) if (r.informational) r];
  final explicit = [for (final r in serial) if (!r.isRemainder) r];
  final remainder = serial.where((r) => r.isRemainder).toList();

  final counts = {for (final r in config) r.id: <String, int>{}};
  final seenStations = <String>{};

  void add(String rowId, String station) {
    final m = counts[rowId]!;
    m[station] = (m[station] ?? 0) + 1;
  }

  for (final f in firs) {
    if (!isUndetected(f)) continue;
    if (!range.includes(f.dateRegistered)) continue;
    final station = (f.station ?? '').trim();
    if (station.isEmpty) continue;
    seenStations.add(station);
    final type = f.crimeType;

    // Serial assignment: first explicit match, else the इतर remainder.
    UndetRow? assigned;
    for (final r in explicit) {
      if (r.matches(type)) {
        assigned = r;
        break;
      }
    }
    if (assigned == null && remainder.isNotEmpty) {
      final cat = crimeCategoryOf(type);
      if (cat != null && universe.contains(cat)) assigned = remainder.first;
    }
    if (assigned != null) add(assigned.id, station);

    // Informational subsets are tallied on top (subset of their parent).
    for (final r in informational) {
      if (r.matches(type)) add(r.id, station);
    }
  }

  // Column order: given stations first (org order), then any extra seen.
  final cols = <String>[
    ...stations,
    ...seenStations.where((s) => !stations.contains(s)),
  ];

  int cellOf(UndetRow r, String station) =>
      overrides['${r.id}|$station'] ?? (counts[r.id]![station] ?? 0);

  final rows = [
    for (final r in config)
      UndetRowResult(
        row: r,
        byStation: {for (final s in cols) s: cellOf(r, s)},
      ),
  ];

  final colTotals = <String, int>{
    for (final s in cols)
      s: rows
          .where((rr) => !rr.row.informational)
          .fold(0, (sum, rr) => sum + rr.at(s)),
  };

  return UndetData(stations: cols, rows: rows, colTotals: colTotals);
}
