import 'analytics_model.dart';

/// One solved/unsolved cell.
class StatCell {
  StatCell({this.solved = 0, this.unsolved = 0});
  int solved;
  int unsolved;
  int get total => solved + unsolved;
}

/// Per-crime-type statistics: 12 monthly cells (current year) plus the
/// current-year and previous-year totals.
class CrimeTypeStat {
  CrimeTypeStat(this.type)
      : months = List.generate(12, (_) => StatCell()),
        yearTotal = StatCell(),
        prevYearTotal = StatCell();

  final String type;
  final List<StatCell> months; // index 0 = Jan
  final StatCell yearTotal;
  final StatCell prevYearTotal;
}

/// The full statistics matrix for [year].
class StatsReport {
  StatsReport({
    required this.year,
    required this.rows,
    required this.totalRow,
  });

  final int year;
  final List<CrimeTypeStat> rows; // one per crime type, sorted
  final CrimeTypeStat totalRow; // grand totals (type = '')
}

bool _isSolved(String status) =>
    status == 'detected' || status == 'solved' || status == 'chargesheeted';

/// Pure computation: bucket crimes by crime type and registration month into
/// solved/unsolved counts, with current-year (per-month + total) and
/// previous-year totals. Crimes without a crime type or registration date are
/// grouped under [unknownLabel].
StatsReport computeStatsReport(
  List<AnalyticsRow> rows,
  int year, {
  String unknownLabel = '—',
}) {
  final byType = <String, CrimeTypeStat>{};
  final total = CrimeTypeStat('');

  CrimeTypeStat statFor(String type) =>
      byType.putIfAbsent(type, () => CrimeTypeStat(type));

  void add(StatCell cell, bool solved) {
    if (solved) {
      cell.solved++;
    } else {
      cell.unsolved++;
    }
  }

  for (final r in rows) {
    final d = r.dateRegistered;
    if (d == null) continue;
    if (d.year != year && d.year != year - 1) continue;

    final type = (r.crimeType ?? '').trim().isEmpty
        ? unknownLabel
        : r.crimeType!.trim();
    final solved = _isSolved(r.status);
    final stat = statFor(type);

    if (d.year == year) {
      add(stat.months[d.month - 1], solved);
      add(stat.yearTotal, solved);
      add(total.months[d.month - 1], solved);
      add(total.yearTotal, solved);
    } else {
      // previous year
      add(stat.prevYearTotal, solved);
      add(total.prevYearTotal, solved);
    }
  }

  final sorted = byType.values.toList()
    ..sort((a, b) => b.yearTotal.total.compareTo(a.yearTotal.total));

  return StatsReport(year: year, rows: sorted, totalRow: total);
}
