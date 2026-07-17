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
    this.dateOccurred,
    this.timeOccurred,
    this.stolenValue = 0,
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

  /// When the offence actually happened (registration date is the fallback for
  /// day-of-week / hot-date bucketing).
  final DateTime? dateOccurred;

  /// Free-text occurrence time ("18:30", "6:30 PM", "रात्री ९ वा.").
  final String? timeOccurred;

  /// Total value of stolen property (गेला माल) attached to the crime.
  final double stolenValue;
}

/// A label + total + detected triple for the table-and-chart panels
/// (years, months, weekdays, crime types, station league …).
class RateRow {
  const RateRow(this.label, this.total, this.detected, {this.sub});

  final String label;

  /// Optional second line under the label (e.g. Marathi day name).
  final String? sub;
  final int total;
  final int detected;

  int get pct => total == 0 ? 0 : (detected * 100 / total).round();
}

/// One automatic finding from the dashboard's brain. [key] picks the
/// translated body `analyzer.ins.[key]`; [args] fill its placeholders.
/// [dow] (0..6, Mon..Sun) is translated by the UI when present.
class BrainInsight {
  const BrainInsight({
    required this.icon,
    required this.tone, // ok | warn | bad | info
    required this.key,
    this.args = const {},
    this.dow,
  });

  final String icon;
  final String tone;
  final String key;
  final Map<String, String> args;
  final int? dow;
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
    required this.lostValue,
    required this.yearRows,
    required this.monthRows,
    required this.weekdayRows,
    required this.hourBandCounts,
    required this.timedTotal,
    required this.weekOfMonthRows,
    required this.hotDates,
    required this.typeRows,
    required this.stationRows,
    required this.leagueRows,
    required this.insights,
    required this.last14Days,
    required this.missingFirNo,
    required this.missingType,
    required this.missingTime,
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

  /// Total value of stolen property (गेला माल); pairs with [recoveredValue]
  /// for the muddemal money-trail panel.
  final double lostValue;

  /// Year-wise volume + detection, newest first.
  final List<RateRow> yearRows;

  /// Month-wise volume + detection, oldest→newest, last 24 months.
  final List<RateRow> monthRows;

  /// Mon..Sun buckets by occurrence date (label = dow key 'mon'..'sun').
  final List<RateRow> weekdayRows;

  /// Eight 3-hour occurrence-time buckets (12–3 AM … 9 PM–12 AM).
  final List<int> hourBandCounts;

  /// How many cases had a parseable occurrence time.
  final int timedTotal;

  /// Week-of-month buckets 1..5 (salary-day / market-day clustering).
  final List<RateRow> weekOfMonthRows;

  /// Specific dates with the most crimes, "dd-MM-yyyy" → count, top 10.
  final List<MapEntry<String, int>> hotDates;

  /// Crime types with detection rate, biggest first.
  final List<RateRow> typeRows;

  /// Stations by caseload, biggest first (empty on single-station installs).
  final List<RateRow> stationRows;

  /// Stations ranked by detection rate — best solvers first.
  final List<RateRow> leagueRows;

  /// Automatic findings ("Saturday is the hot day", "वाहन चोरी loops on
  /// Sunday", …) — the dashboard's brain.
  final List<BrainInsight> insights;

  /// Registrations per day for the last 14 days ("dd-MM" → count, zero-filled,
  /// oldest→newest) — the dashboard's live pulse.
  final List<MapEntry<String, int>> last14Days;

  /// Data-quality counters: records missing an FIR number / crime type /
  /// occurrence time. Fixing these makes every report above accurate.
  final int missingFirNo;
  final int missingType;
  final int missingTime;
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

  // Occurrence-pattern accumulators (day of week / time / week of month /
  // hot dates) + money trail + detection splits for the duo panels.
  var lost = 0.0;
  var timedTotal = 0;
  final weekdayTotals = List<int>.filled(7, 0);
  final weekdayDetected = List<int>.filled(7, 0);
  final hourBands = List<int>.filled(8, 0);
  final womTotals = List<int>.filled(5, 0);
  final womDetected = List<int>.filled(5, 0);
  final dateCounts = <String, int>{};
  final yearTotals = <int, int>{};
  final yearDetected = <int, int>{};
  final monthlyDetected = <String, int>{};
  final stationDetected = <String, int>{};
  final typeWeekday = <String, List<int>>{};
  final start14 = startOfToday.subtract(const Duration(days: 13));
  final dailyCounts = <String, int>{};
  var missingFirNo = 0, missingType = 0, missingTime = 0;

  for (final r in rows) {
    statusCounts.update(r.status, (v) => v + 1, ifAbsent: () => 1);
    arrested += r.arrestedCount;
    wanted += r.wantedCount;
    recovered += r.recoveredValue;
    lost += r.stolenValue;

    final solved = r.status == 'detected' ||
        r.status == 'solved' ||
        r.status == 'chargesheeted';

    final type = (r.crimeType ?? '').trim();
    if (type.isNotEmpty) {
      crimeTypeCounts.update(type, (v) => v + 1, ifAbsent: () => 1);
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
      if (solved) {
        stationDetected.update(station, (v) => v + 1, ifAbsent: () => 1);
      }
    }

    // When did it actually happen? Prefer the offence date over registration.
    final occ = r.dateOccurred ?? r.dateRegistered;
    if (occ != null) {
      final wd = occ.weekday - 1;
      weekdayTotals[wd]++;
      if (solved) weekdayDetected[wd]++;
      final wom = ((occ.day - 1) ~/ 7).clamp(0, 4);
      womTotals[wom]++;
      if (solved) womDetected[wom]++;
      final key = '${occ.day.toString().padLeft(2, '0')}-'
          '${occ.month.toString().padLeft(2, '0')}-${occ.year}';
      dateCounts.update(key, (v) => v + 1, ifAbsent: () => 1);
      if (type.isNotEmpty) {
        typeWeekday.putIfAbsent(type, () => List<int>.filled(7, 0))[wd]++;
      }
    }
    final hour = parseOccurrenceHour(r.timeOccurred);
    if (hour != null) {
      hourBands[hour ~/ 3]++;
      timedTotal++;
    } else {
      missingTime++;
    }
    if ((r.firNo ?? '').trim().isEmpty) missingFirNo++;
    if (type.isEmpty) missingType++;
    final reg = r.dateRegistered;
    if (reg != null &&
        !reg.isBefore(start14) &&
        reg.isBefore(startOfTomorrow)) {
      final key = '${reg.day.toString().padLeft(2, '0')}-'
          '${reg.month.toString().padLeft(2, '0')}';
      dailyCounts.update(key, (v) => v + 1, ifAbsent: () => 1);
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
      yearTotals.update(d.year, (v) => v + 1, ifAbsent: () => 1);
      if (solved) {
        yearDetected.update(d.year, (v) => v + 1, ifAbsent: () => 1);
        monthlyDetected.update(ym, (v) => v + 1, ifAbsent: () => 1);
      }

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

  // --- Duo-panel rows -------------------------------------------------------
  const dowKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];
  final yearRows = [
    for (final y in yearTotals.keys.toList()..sort((a, b) => b.compareTo(a)))
      RateRow('$y', yearTotals[y]!, yearDetected[y] ?? 0),
  ];
  final monthKeysAsc = monthly.keys.toList()..sort();
  final monthRows = [
    for (final ym in monthKeysAsc.length > 24
        ? monthKeysAsc.sublist(monthKeysAsc.length - 24)
        : monthKeysAsc)
      RateRow(ym, monthly[ym]!, monthlyDetected[ym] ?? 0),
  ];
  final weekdayRows = [
    for (var i = 0; i < 7; i++)
      RateRow(dowKeys[i], weekdayTotals[i], weekdayDetected[i]),
  ];
  final weekOfMonthRows = [
    for (var i = 0; i < 5; i++)
      RateRow('${i + 1}', womTotals[i], womDetected[i]),
  ];
  final hotDates = dateCounts.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final typeRows = [
    for (final e in crimeTypeCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)))
      RateRow(e.key, e.value, solvedByType[e.key] ?? 0),
  ];
  final stationRows = [
    for (final e in stationCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value)))
      RateRow(e.key, e.value, stationDetected[e.key] ?? 0),
  ];
  // League: rank by detection rate; stations with a real caseload (10+) first
  // so a 2-case station can't top the table.
  final leagueRows = stationRows.toList()
    ..sort((a, b) {
      final aBig = a.total >= 10, bBig = b.total >= 10;
      if (aBig != bBig) return aBig ? -1 : 1;
      final byPct = b.pct.compareTo(a.pct);
      return byPct != 0 ? byPct : b.total.compareTo(a.total);
    });

  final insights = _buildInsights(
    datedTotal: weekdayTotals.reduce((a, b) => a + b),
    weekdayTotals: weekdayTotals,
    hourBands: hourBands,
    timedTotal: timedTotal,
    typeWeekday: typeWeekday,
    crimeTypeCounts: crimeTypeCounts,
    monthRows: monthRows,
    lost: lost,
    recovered: recovered,
    leagueRows: leagueRows,
    hotDates: hotDates,
    yearRows: yearRows,
    now: n,
  );

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
    lostValue: lost,
    yearRows: yearRows,
    monthRows: monthRows,
    weekdayRows: weekdayRows,
    hourBandCounts: hourBands,
    timedTotal: timedTotal,
    weekOfMonthRows: weekOfMonthRows,
    hotDates: hotDates.take(10).toList(),
    typeRows: typeRows,
    stationRows: stationRows,
    leagueRows: leagueRows,
    insights: insights,
    last14Days: [
      for (var i = 0; i < 14; i++)
        () {
          final day = start14.add(Duration(days: i));
          final key = '${day.day.toString().padLeft(2, '0')}-'
              '${day.month.toString().padLeft(2, '0')}';
          return MapEntry(key, dailyCounts[key] ?? 0);
        }(),
    ],
    missingFirNo: missingFirNo,
    missingType: missingType,
    missingTime: missingTime,
  );
}

/// Parses a free-text occurrence time to an hour 0..23. Understands "18:30",
/// "6.30 PM", Devanagari digits and Marathi day-part words (रात्री/सायं = PM,
/// सकाळी/पहाटे = AM). Returns null when no hour can be read.
int? parseOccurrenceHour(String? s) {
  if (s == null) return null;
  var t = s.trim().toLowerCase();
  if (t.isEmpty) return null;
  const dev = {
    '०': '0', '१': '1', '२': '2', '३': '3', '४': '4',
    '५': '5', '६': '6', '७': '7', '८': '8', '९': '9',
  };
  t = t.split('').map((c) => dev[c] ?? c).join();
  final m = RegExp(r'(\d{1,2})').firstMatch(t);
  if (m == null) return null;
  var h = int.parse(m.group(1)!);
  final pm = t.contains('pm') ||
      t.contains('सायं') ||
      t.contains('रात्र') ||
      t.contains('दुपार') ||
      t.contains('संध्या');
  final am = t.contains('am') ||
      t.contains('सकाळ') ||
      t.contains('पहाट');
  if (pm && h < 12) h += 12;
  if (am && h == 12) h = 0;
  return (h >= 0 && h <= 23) ? h : null;
}

/// The dashboard brain: turns the aggregates into human findings. Pure and
/// deterministic — every detector has a minimum-data guard so small stations
/// don't get noise.
List<BrainInsight> _buildInsights({
  required int datedTotal,
  required List<int> weekdayTotals,
  required List<int> hourBands,
  required int timedTotal,
  required Map<String, List<int>> typeWeekday,
  required Map<String, int> crimeTypeCounts,
  required List<RateRow> monthRows,
  required double lost,
  required double recovered,
  required List<RateRow> leagueRows,
  required List<MapEntry<String, int>> hotDates,
  required List<RateRow> yearRows,
  required DateTime now,
}) {
  final out = <BrainInsight>[];
  String pctOf(int part, int whole) =>
      whole == 0 ? '0' : (part * 100 / whole).round().toString();

  // 1. Peak weekday (expected share for an even week is ~14%).
  if (datedTotal >= 50) {
    var peak = 0;
    for (var i = 1; i < 7; i++) {
      if (weekdayTotals[i] > weekdayTotals[peak]) peak = i;
    }
    final share = weekdayTotals[peak] * 100 / datedTotal;
    if (share >= 16) {
      out.add(BrainInsight(
        icon: '📅',
        tone: 'warn',
        key: 'peakDay',
        dow: peak,
        args: {
          'count': '${weekdayTotals[peak]}',
          'total': '$datedTotal',
          'pct': share.round().toString(),
        },
      ));
    }
  }

  // 2. Dominant 3-hour time band.
  if (timedTotal >= 30) {
    var peak = 0;
    for (var i = 1; i < 8; i++) {
      if (hourBands[i] > hourBands[peak]) peak = i;
    }
    final share = hourBands[peak] * 100 / timedTotal;
    if (share >= 25) {
      out.add(BrainInsight(
        icon: '🌙',
        tone: 'warn',
        key: 'timeBand',
        args: {
          'band': kHourBandLabels[peak],
          'pct': share.round().toString(),
          'total': '$timedTotal',
        },
      ));
    }
  }

  // 3. Crime-type × weekday loop (a repeating gang route smells like this).
  String? loopType;
  int loopDow = 0, loopPct = 0;
  typeWeekday.forEach((type, wd) {
    final total = wd.reduce((a, b) => a + b);
    if (total < 20) return;
    var peak = 0;
    for (var i = 1; i < 7; i++) {
      if (wd[i] > wd[peak]) peak = i;
    }
    final pct = wd[peak] * 100 ~/ total;
    if (pct >= 30 && pct > loopPct) {
      loopType = type;
      loopDow = peak;
      loopPct = pct;
    }
  });
  if (loopType != null) {
    out.add(BrainInsight(
      icon: '🔁',
      tone: 'bad',
      key: 'typeLoop',
      dow: loopDow,
      args: {'type': loopType!, 'pct': '$loopPct'},
    ));
  }

  // 4. Three-month trend (last 3 full months vs the 3 before them).
  if (monthRows.length >= 7) {
    // Drop the current (incomplete) month if it is the last row.
    final nowYm = '${now.year.toString().padLeft(4, '0')}-'
        '${now.month.toString().padLeft(2, '0')}';
    final closed = monthRows.last.label == nowYm
        ? monthRows.sublist(0, monthRows.length - 1)
        : monthRows;
    if (closed.length >= 6) {
      final recent = closed
          .sublist(closed.length - 3)
          .fold(0, (a, r) => a + r.total);
      final before = closed
          .sublist(closed.length - 6, closed.length - 3)
          .fold(0, (a, r) => a + r.total);
      if (before >= 30) {
        final change = (recent - before) * 100 ~/ before;
        if (change <= -8) {
          out.add(BrainInsight(
            icon: '📉',
            tone: 'ok',
            key: 'downTrend',
            args: {'pct': '${-change}', 'a': '$recent', 'b': '$before'},
          ));
        } else if (change >= 8) {
          out.add(BrainInsight(
            icon: '📈',
            tone: 'warn',
            key: 'upTrend',
            args: {'pct': '$change', 'a': '$recent', 'b': '$before'},
          ));
        }
      }
    }
  }

  // 5. Muddemal recovery rate.
  if (lost > 0) {
    final rate = (recovered * 100 / lost).round();
    out.add(BrainInsight(
      icon: '💰',
      tone: rate < 50 ? 'warn' : 'ok',
      key: rate < 50 ? 'lowRecovery' : 'goodRecovery',
      args: {'pct': '$rate'},
    ));
  }

  // 6. Detection leader (only meaningful across stations).
  if (leagueRows.length >= 2 && leagueRows.first.total >= 10) {
    final best = leagueRows.first;
    final totalAll = leagueRows.fold(0, (a, r) => a + r.total);
    final detAll = leagueRows.fold(0, (a, r) => a + r.detected);
    out.add(BrainInsight(
      icon: '🏆',
      tone: 'ok',
      key: 'bestStation',
      args: {
        'station': best.label,
        'pct': '${best.pct}',
        'avg': pctOf(detAll, totalAll),
      },
    ));
  }

  // 7. Hottest single date.
  if (hotDates.isNotEmpty && hotDates.first.value >= 5) {
    out.add(BrainInsight(
      icon: '📌',
      tone: 'info',
      key: 'hotDate',
      args: {'date': hotDates.first.key, 'n': '${hotDates.first.value}'},
    ));
  }

  // 8. Year-on-year detection movement.
  if (yearRows.length >= 2 &&
      yearRows[0].total >= 50 &&
      yearRows[1].total >= 50) {
    final cur = yearRows[0], prev = yearRows[1];
    if (cur.pct >= prev.pct + 3) {
      out.add(BrainInsight(
        icon: '🎯',
        tone: 'ok',
        key: 'yoyUp',
        args: {
          'y1': cur.label, 'p1': '${cur.pct}',
          'y0': prev.label, 'p0': '${prev.pct}',
        },
      ));
    } else if (cur.pct + 3 <= prev.pct) {
      out.add(BrainInsight(
        icon: '🎯',
        tone: 'warn',
        key: 'yoyDown',
        args: {
          'y1': cur.label, 'p1': '${cur.pct}',
          'y0': prev.label, 'p0': '${prev.pct}',
        },
      ));
    }
  }

  return out;
}

/// Fixed labels for the eight 3-hour occurrence bands (index = hour ~/ 3).
const List<String> kHourBandLabels = [
  '12–3 AM', '3–6 AM', '6–9 AM', '9 AM–12 PM',
  '12–3 PM', '3–6 PM', '6–9 PM', '9 PM–12 AM',
];
