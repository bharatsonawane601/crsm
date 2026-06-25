/// One crime flattened with the fields the analyzer needs. Assembled by the
/// analytics repository from several tables.
class AnalyticsRow {
  AnalyticsRow({
    required this.id,
    required this.status,
    this.dateRegistered,
    this.section,
    this.crimeType,
    this.officerName,
    this.station,
    this.chargesheetDate,
    this.recoveredValue = 0,
    this.accusedCount = 0,
    this.arrestedCount = 0,
    this.wantedCount = 0,
  });

  final int id;
  final String status;
  final DateTime? dateRegistered;
  final String? section;
  final String? crimeType;
  final String? officerName;

  /// Police station this crime belongs to. Only meaningful in the multi-station
  /// officer portal; null/single-valued for a single station install.
  final String? station;
  final DateTime? chargesheetDate;
  final double recoveredValue;
  final int accusedCount;
  final int arrestedCount;
  final int wantedCount;
}

/// Shared filter applied across every KPI and chart.
class AnalyticsFilter {
  const AnalyticsFilter({
    this.from,
    this.to,
    this.status,
    this.crimeTypes = const {},
  });

  final DateTime? from;
  final DateTime? to;
  final String? status;

  /// Filter by one or more crime types (गुन्ह्याचा प्रकार) — the human crime
  /// names, not the raw section codes. Empty = all types.
  final Set<String> crimeTypes;

  bool get isEmpty =>
      from == null && to == null && status == null && crimeTypes.isEmpty;

  bool matches(AnalyticsRow r) {
    final d = r.dateRegistered;
    if (from != null && (d == null || d.isBefore(from!))) return false;
    if (to != null &&
        (d == null || d.isAfter(to!.add(const Duration(days: 1))))) {
      return false;
    }
    if (status != null && r.status != status) return false;
    if (crimeTypes.isNotEmpty && !crimeTypes.contains(r.crimeType ?? '')) {
      return false;
    }
    return true;
  }

  AnalyticsFilter copyWith({
    DateTime? from,
    DateTime? to,
    String? status,
    Set<String>? crimeTypes,
    bool clearFrom = false,
    bool clearTo = false,
    bool clearStatus = false,
  }) {
    return AnalyticsFilter(
      from: clearFrom ? null : (from ?? this.from),
      to: clearTo ? null : (to ?? this.to),
      status: clearStatus ? null : (status ?? this.status),
      crimeTypes: crimeTypes ?? this.crimeTypes,
    );
  }
}

/// Computed dashboard data: KPI numbers plus series for the charts.
class AnalyticsSummary {
  AnalyticsSummary({
    required this.total,
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.thisYear,
    required this.statusCounts,
    required this.arrested,
    required this.wanted,
    required this.recoveredValue,
    required this.avgDaysToChargesheet,
    required this.crimeTypeCounts,
    required this.solvedByType,
    required this.openByType,
    required this.topSections,
    required this.officerCounts,
    required this.stationCounts,
    required this.dayOfWeekCounts,
    required this.monthlyTrend,
  });

  final int total;
  final int today;
  final int thisWeek;
  final int thisMonth;
  final int thisYear;
  final Map<String, int> statusCounts;
  final int arrested;
  final int wanted;
  final double recoveredValue;
  final double? avgDaysToChargesheet;
  final Map<String, int> crimeTypeCounts;

  /// Solved (solved + chargesheeted) count per crime type.
  final Map<String, int> solvedByType;

  /// Open (not yet solved) count per crime type.
  final Map<String, int> openByType;

  /// Sections sorted by count desc.
  final List<MapEntry<String, int>> topSections;
  final Map<String, int> officerCounts;

  /// Crimes per police station (for the officer portal's station comparison).
  final Map<String, int> stationCounts;

  /// Counts indexed Mon..Sun (0..6).
  final List<int> dayOfWeekCounts;

  /// "yyyy-MM" -> count, chronologically sorted.
  final List<MapEntry<String, int>> monthlyTrend;
}

/// Pure aggregation of analytics rows into a [AnalyticsSummary]. [now] is
/// injectable for deterministic tests.
AnalyticsSummary computeAnalytics(
  List<AnalyticsRow> rows, {
  DateTime? now,
}) {
  final n = now ?? DateTime.now();
  final startOfToday = DateTime(n.year, n.month, n.day);
  final startOfWeek = startOfToday.subtract(Duration(days: n.weekday - 1));
  final startOfMonth = DateTime(n.year, n.month);
  final startOfYear = DateTime(n.year);

  var today = 0, week = 0, month = 0, year = 0;
  var arrested = 0, wanted = 0;
  var recovered = 0.0;
  final statusCounts = <String, int>{};
  final crimeTypeCounts = <String, int>{};
  final solvedByType = <String, int>{};
  final openByType = <String, int>{};
  final sectionCounts = <String, int>{};
  final officerCounts = <String, int>{};
  final stationCounts = <String, int>{};
  final dayOfWeek = List<int>.filled(7, 0);
  final monthly = <String, int>{};

  var chargesheetDaysSum = 0;
  var chargesheetCount = 0;

  for (final r in rows) {
    statusCounts.update(r.status, (v) => v + 1, ifAbsent: () => 1);
    arrested += r.arrestedCount;
    wanted += r.wantedCount;
    recovered += r.recoveredValue;

    final type = (r.crimeType ?? '').trim();
    if (type.isNotEmpty) {
      crimeTypeCounts.update(type, (v) => v + 1, ifAbsent: () => 1);
      final solved = r.status == 'solved' || r.status == 'chargesheeted';
      if (solved) {
        solvedByType.update(type, (v) => v + 1, ifAbsent: () => 1);
      } else {
        openByType.update(type, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    final section = (r.section ?? '').trim();
    if (section.isNotEmpty) {
      sectionCounts.update(section, (v) => v + 1, ifAbsent: () => 1);
    }
    final officer = (r.officerName ?? '').trim();
    if (officer.isNotEmpty) {
      officerCounts.update(officer, (v) => v + 1, ifAbsent: () => 1);
    }
    final station = (r.station ?? '').trim();
    if (station.isNotEmpty) {
      stationCounts.update(station, (v) => v + 1, ifAbsent: () => 1);
    }

    final d = r.dateRegistered;
    if (d != null) {
      if (!d.isBefore(startOfToday)) today++;
      if (!d.isBefore(startOfWeek)) week++;
      if (!d.isBefore(startOfMonth)) month++;
      if (!d.isBefore(startOfYear)) year++;
      dayOfWeek[d.weekday - 1]++;
      final ym = '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}';
      monthly.update(ym, (v) => v + 1, ifAbsent: () => 1);

      if (r.chargesheetDate != null) {
        chargesheetDaysSum += r.chargesheetDate!.difference(d).inDays;
        chargesheetCount++;
      }
    }
  }

  final topSections = sectionCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final trend = monthly.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));

  return AnalyticsSummary(
    total: rows.length,
    today: today,
    thisWeek: week,
    thisMonth: month,
    thisYear: year,
    statusCounts: statusCounts,
    arrested: arrested,
    wanted: wanted,
    recoveredValue: recovered,
    avgDaysToChargesheet:
        chargesheetCount == 0 ? null : chargesheetDaysSum / chargesheetCount,
    crimeTypeCounts: crimeTypeCounts,
    solvedByType: solvedByType,
    openByType: openByType,
    topSections: topSections,
    officerCounts: officerCounts,
    stationCounts: stationCounts,
    dayOfWeekCounts: dayOfWeek,
    monthlyTrend: trend,
  );
}
