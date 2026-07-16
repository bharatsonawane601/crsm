/// One crime flattened with the fields the analyzer needs. Assembled by the
/// analytics repository from several tables.
class AnalyticsRow {
  AnalyticsRow({
    required this.id,
    required this.status,
    this.firNo,
    this.year,
    this.dateRegistered,
    this.section,
    this.crimeType,
    this.officerName,
    this.station,
    this.courtType,
    this.caseStage,
    this.chargesheetDate,
    this.recoveredValue = 0,
    this.accusedCount = 0,
    this.arrestedCount = 0,
    this.wantedCount = 0,
    this.preventiveAction,
    this.preventiveDate,
  });

  final int id;
  final String status;

  /// FIR number + year, so deadline alerts can name the case (e.g. "12/2026").
  final String? firNo;
  final int? year;
  final DateTime? dateRegistered;
  final String? section;
  final String? crimeType;
  final String? officerName;

  /// Court handling the case ('sessions' = 90-day window, 'jmfc' = 60-day).
  final String? courtType;

  /// Comma-separated case stages (investigation / chargesheet / court / ...).
  final String? caseStage;

  /// Police station this crime belongs to. Only meaningful in the multi-station
  /// officer portal; null/single-valued for a single station install.
  final String? station;
  final DateTime? chargesheetDate;
  final double recoveredValue;
  final int accusedCount;
  final int arrestedCount;
  final int wantedCount;

  /// Free-text preventive-action provision (e.g. "126 BNSS", "MPDA"), from the
  /// investigation tab. Used by the प्रतिबंधक कार्यवाही report.
  final String? preventiveAction;

  /// When the preventive action was taken (falls back to registration date for
  /// period bucketing when null).
  final DateTime? preventiveDate;
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
    if (to != null) {
      // Inclusive of the whole "to" day: [to 00:00, to+1day 00:00).
      final end = DateTime(
        to!.year,
        to!.month,
        to!.day,
      ).add(const Duration(days: 1));
      if (d == null || !d.isBefore(end)) return false;
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

/// One pending chargesheet approaching (or past) its court deadline —
/// actionable: names the FIR and how many days remain.
class ChargesheetDueCase {
  const ChargesheetDueCase({
    required this.crimeId,
    required this.label,
    required this.deadline,
    required this.daysLeft,
    required this.window,
  });

  final int crimeId;

  /// Human case label, e.g. "12/2026" (FIR no/year) or "#37" as a fallback.
  final String label;
  final DateTime deadline;

  /// Days until the deadline; negative = already overdue by that many days.
  final int daysLeft;

  /// '60' (JMFC) or '90' (Sessions).
  final String window;

  bool get overdue => daysLeft < 0;
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
    required this.stageCounts,
    required this.chargesheetWithin,
    required this.chargesheetOverdue,
    required this.chargesheetFiled,
    required this.chargesheetDue,
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

  /// Count of cases at each case stage (investigation / chargesheet / ...).
  final Map<String, int> stageCounts;

  /// Pending-chargesheet cases still within their deadline, keyed by window
  /// label ('60' for JMFC, '90' for Sessions).
  final Map<String, int> chargesheetWithin;

  /// Pending-chargesheet cases past their deadline, keyed by window ('60'/'90').
  final Map<String, int> chargesheetOverdue;

  /// Cases whose chargesheet is already filed, keyed by window ('60'/'90').
  final Map<String, int> chargesheetFiled;

  /// Actionable deadline alerts: every pending-chargesheet case that is
  /// overdue or due within [kChargesheetDueSoonDays], most urgent first.
  final List<ChargesheetDueCase> chargesheetDue;
}

/// A pending chargesheet whose deadline is within this many days (or already
/// past) appears in [AnalyticsSummary.chargesheetDue].
const int kChargesheetDueSoonDays = 7;

/// Pure aggregation of analytics rows into a [AnalyticsSummary]. [now] is
/// injectable for deterministic tests.
AnalyticsSummary computeAnalytics(List<AnalyticsRow> rows, {DateTime? now}) {
  final n = now ?? DateTime.now();
  final startOfToday = DateTime(n.year, n.month, n.day);
  final startOfTomorrow = startOfToday.add(const Duration(days: 1));
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
  final stageCounts = <String, int>{};
  final chargesheetWithin = <String, int>{'60': 0, '90': 0};
  final chargesheetOverdue = <String, int>{'60': 0, '90': 0};
  final chargesheetFiled = <String, int>{'60': 0, '90': 0};
  final chargesheetDue = <ChargesheetDueCase>[];

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
      final solved =
          r.status == 'detected' ||
          r.status == 'solved' ||
          r.status == 'chargesheeted';
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
      // A future-dated record (data-entry typo) must not count in any window —
      // otherwise it inflates today/week/month/year all at once.
      final notFuture = d.isBefore(startOfTomorrow);
      if (notFuture && !d.isBefore(startOfToday)) today++;
      if (notFuture && !d.isBefore(startOfWeek)) week++;
      if (notFuture && !d.isBefore(startOfMonth)) month++;
      if (notFuture && !d.isBefore(startOfYear)) year++;
      dayOfWeek[d.weekday - 1]++;
      final ym =
          '${d.year.toString().padLeft(4, '0')}-'
          '${d.month.toString().padLeft(2, '0')}';
      monthly.update(ym, (v) => v + 1, ifAbsent: () => 1);

      if (r.chargesheetDate != null) {
        chargesheetDaysSum += r.chargesheetDate!.difference(d).inDays;
        chargesheetCount++;
      }

      // Chargesheet deadline tracking, split by the court's window. Only cases
      // with a court selected (60-day JMFC / 90-day Sessions) count here.
      final window = switch (r.courtType) {
        'sessions' => '90',
        'jmfc' => '60',
        _ => null,
      };
      if (window != null) {
        final stages = (r.caseStage ?? '').toLowerCase();
        final filed =
            r.chargesheetDate != null ||
            stages.contains('chargesheet') ||
            stages.contains('both') ||
            stages.contains('court') ||
            stages.contains('disposed');
        if (filed) {
          chargesheetFiled.update(window, (v) => v + 1, ifAbsent: () => 1);
        } else {
          final days = int.parse(window);
          final deadline = d.add(Duration(days: days));
          if (deadline.isBefore(startOfToday)) {
            chargesheetOverdue.update(window, (v) => v + 1, ifAbsent: () => 1);
          } else {
            chargesheetWithin.update(window, (v) => v + 1, ifAbsent: () => 1);
          }
          // Actionable alert entry: overdue, or due within the soon-window.
          final daysLeft = deadline.difference(startOfToday).inDays;
          if (daysLeft <= kChargesheetDueSoonDays) {
            final fir = (r.firNo ?? '').trim();
            final label = fir.isEmpty
                ? '#${r.id}'
                : (r.year == null ? fir : '$fir/${r.year}');
            chargesheetDue.add(
              ChargesheetDueCase(
                crimeId: r.id,
                label: label,
                deadline: deadline,
                daysLeft: daysLeft,
                window: window,
              ),
            );
          }
        }
      }
    }

    // Case-stage tally (a record can list several stages).
    for (final st
        in (r.caseStage ?? 'investigation')
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)) {
      stageCounts.update(st, (v) => v + 1, ifAbsent: () => 1);
    }
  }

  final topSections = sectionCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final trend = monthly.entries.toList()
    ..sort((a, b) => a.key.compareTo(b.key));
  chargesheetDue.sort((a, b) => a.daysLeft.compareTo(b.daysLeft));

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
    avgDaysToChargesheet: chargesheetCount == 0
        ? null
        : chargesheetDaysSum / chargesheetCount,
    crimeTypeCounts: crimeTypeCounts,
    solvedByType: solvedByType,
    openByType: openByType,
    topSections: topSections,
    officerCounts: officerCounts,
    stationCounts: stationCounts,
    dayOfWeekCounts: dayOfWeek,
    monthlyTrend: trend,
    stageCounts: stageCounts,
    chargesheetWithin: chargesheetWithin,
    chargesheetOverdue: chargesheetOverdue,
    chargesheetFiled: chargesheetFiled,
    chargesheetDue: chargesheetDue,
  );
}
