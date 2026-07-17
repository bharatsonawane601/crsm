import '../crime_entry/data/crime_types_data.dart';
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
///
/// Crimes count under their CATEGORY, not the leaf sub-type the officer picked:
/// a "Revenge Murder / सूड हत्या" FIR belongs on the Murder / खून row. Counting
/// the raw sub-type instead split every murder into its own one-case row and
/// left the real Murder row reading 1 (or 0).
///
/// Every catalogue category is listed even when it has no crimes this year, so
/// the report opens as the full crime-head sheet (zeros included) the way the
/// paper statement does, instead of only whatever happens to exist.
StatsReport computeStatsReport(
  List<AnalyticsRow> rows,
  int year, {
  String unknownLabel = '—',
}) {
  final byType = <String, CrimeTypeStat>{};
  final total = CrimeTypeStat('');

  CrimeTypeStat statFor(String type) =>
      byType.putIfAbsent(type, () => CrimeTypeStat(type));

  // Seed the standard crime heads so they always have a row.
  for (final label in kCrimeCategoryLabels) {
    statFor(label);
  }

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

    final raw = (r.crimeType ?? '').trim();
    // Sub-type -> its category; custom free text keeps its own row.
    final type = raw.isEmpty ? unknownLabel : (crimeCategoryOf(raw) ?? raw);
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

  // Busiest heads first; heads with nothing this year keep the catalogue's
  // order so the zero rows read as a stable, familiar list rather than
  // shuffling around. The "no crime type" row always sits last.
  final catOrder = {
    for (var i = 0; i < kCrimeCategoryLabels.length; i++)
      kCrimeCategoryLabels[i]: i,
  };
  int rank(CrimeTypeStat s) => catOrder[s.type] ?? kCrimeCategoryLabels.length;
  final sorted = byType.values.toList()
    ..sort((a, b) {
      if (a.type == unknownLabel) return 1;
      if (b.type == unknownLabel) return -1;
      final byTotal = b.yearTotal.total.compareTo(a.yearTotal.total);
      if (byTotal != 0) return byTotal;
      final byPrev = b.prevYearTotal.total.compareTo(a.prevYearTotal.total);
      if (byPrev != 0) return byPrev;
      final byCat = rank(a).compareTo(rank(b));
      return byCat != 0 ? byCat : a.type.compareTo(b.type);
    });

  return StatsReport(year: year, rows: sorted, totalRow: total);
}
