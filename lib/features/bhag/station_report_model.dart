import '../analyzer/analytics_model.dart';
import '../crime_entry/data/crime_types_data.dart';

/// Report id for the division station-wise दाखल/उघड report (परिमंडळ ... report).
const String kStationReportId = 'divstation';

/// Which time window the station-wise report covers for the chosen month/year.
enum StationPeriodMode {
  /// Jan 1 .. end of the selected month of the year (…अखेर पावेतो).
  cumulative,

  /// Only the selected month.
  month,
}

/// The chosen month/year and window for the station-wise report.
class StationReportPeriod {
  const StationReportPeriod({
    required this.month,
    required this.year,
    this.mode = StationPeriodMode.cumulative,
  });

  final int month;
  final int year;
  final StationPeriodMode mode;

  /// True when [d] falls inside the selected window.
  bool includes(DateTime? d) {
    if (d == null || d.year != year) return false;
    return mode == StationPeriodMode.cumulative ? d.month <= month : d.month == month;
  }

  String get signature => '$year-$month-${mode.name}';
}

/// One police-station line: registered (दाखल) and detected (उघड) counts.
class StationTally {
  const StationTally({
    required this.station,
    required this.registered,
    required this.detected,
  });
  final String station;
  final int registered;
  final int detected;
}

/// One side of the report (property or body): station rows sorted by दाखल desc.
class StationSideTable {
  const StationSideTable({required this.rows});
  final List<StationTally> rows;

  int get totalRegistered => rows.fold(0, (s, r) => s + r.registered);
  int get totalDetected => rows.fold(0, (s, r) => s + r.detected);
}

/// Both tables side by side: property (मालमत्तेविरुद्ध) + body (शारीरिकविरुद्ध).
class StationReportData {
  const StationReportData({required this.property, required this.body});
  final StationSideTable property;
  final StationSideTable body;
}

/// The crime categories that count as **body** (शारीरिकविरुद्ध) crimes by default.
/// Editable in-app; these are just the seed values.
List<String> defaultBodyCategories() => const [
      'Murder / खून',
      'Attempt to Murder / खुनाचा प्रयत्न',
      'Culpable Homicide / सदोष मनुष्यवध',
      'Kidnapping & Abduction / अपहरण व पळवून नेणे',
      'Human Trafficking / मानवी तस्करी',
      'Sexual Offences / लैंगिक गुन्हे',
      'Crimes against Children (POCSO) / बाल अत्याचार (पोक्सो)',
      'Assault & Hurt / हल्ला व दुखापत',
      'Defamation & Intimidation / बदनामी व धमकी',
    ];

/// The crime categories that count as **property** (मालमत्तेविरुद्ध) crimes by
/// default. Editable in-app; these are just the seed values.
List<String> defaultPropertyCategories() => const [
      'Robbery / जबरी चोरी',
      'Dacoity / दरोडा',
      'Theft / चोरी',
      'Burglary / House-breaking / घरफोडी',
      'Extortion / खंडणी',
      'Cheating & Fraud / फसवणूक',
      'Criminal Breach of Trust / विश्वासघात',
      'Forgery & Counterfeiting / बनावटगिरी',
      'Property / Mischief / Arson / मालमत्ता गुन्हे',
    ];

/// Groups the scope-filtered FIRs by police station into the two side tables.
/// A FIR joins a side if its crime category is in that side's category set;
/// उघड counts the FIRs whose status is 'detected'. Stations are sorted by दाखल
/// descending, matching the printed परिमंडळ sheet.
StationReportData computeStationReport({
  required List<AnalyticsRow> firs,
  required Set<String> bodyCategories,
  required Set<String> propertyCategories,
  required StationReportPeriod period,
}) {
  // station -> [registered, detected]
  final body = <String, List<int>>{};
  final prop = <String, List<int>>{};

  for (final r in firs) {
    if (!period.includes(r.dateRegistered)) continue;
    final cat = crimeCategoryOf(r.crimeType);
    if (cat == null) continue;
    final station = (r.station ?? '').trim();
    if (station.isEmpty) continue;
    final det = r.status == 'detected' ? 1 : 0;
    if (bodyCategories.contains(cat)) {
      final e = body.putIfAbsent(station, () => [0, 0]);
      e[0]++;
      e[1] += det;
    }
    if (propertyCategories.contains(cat)) {
      final e = prop.putIfAbsent(station, () => [0, 0]);
      e[0]++;
      e[1] += det;
    }
  }

  StationSideTable build(Map<String, List<int>> m) {
    final rows = [
      for (final e in m.entries)
        StationTally(station: e.key, registered: e.value[0], detected: e.value[1]),
    ]..sort((a, b) => b.registered.compareTo(a.registered));
    return StationSideTable(rows: rows);
  }

  return StationReportData(property: build(prop), body: build(body));
}
