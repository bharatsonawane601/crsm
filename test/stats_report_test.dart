import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/analyzer/analytics_model.dart';
import 'package:crms/features/analyzer/stats_report.dart';
import 'package:crms/features/crime_entry/data/crime_types_data.dart';

void main() {
  AnalyticsRow row(String type, DateTime date, String status) =>
      AnalyticsRow(id: 0, status: status, crimeType: type, dateRegistered: date);

  test('buckets solved/unsolved by crime type and month', () {
    final rows = [
      // theft, Jan 2026: 1 solved, 1 unsolved
      row('theft', DateTime(2026, 1, 5), 'solved'),
      row('theft', DateTime(2026, 1, 20), 'open'),
      // theft, Feb 2026: 1 chargesheeted (counts as solved)
      row('theft', DateTime(2026, 2, 10), 'chargesheeted'),
      // fraud, Jan 2026: 1 pending (unsolved)
      row('fraud', DateTime(2026, 1, 15), 'pending'),
      // theft, 2025 (previous year): 1 solved
      row('theft', DateTime(2025, 6, 1), 'solved'),
    ];

    final report = computeStatsReport(rows, 2026);
    final theft = report.rows.firstWhere((r) => r.type == 'theft');

    // Jan = index 0
    expect(theft.months[0].solved, 1);
    expect(theft.months[0].unsolved, 1);
    // Feb = index 1
    expect(theft.months[1].solved, 1);
    expect(theft.months[1].unsolved, 0);
    // Year total (2026): 2 solved, 1 unsolved
    expect(theft.yearTotal.solved, 2);
    expect(theft.yearTotal.unsolved, 1);
    // Previous year (2025): 1 solved
    expect(theft.prevYearTotal.solved, 1);
    expect(theft.prevYearTotal.unsolved, 0);
  });

  test('grand total row sums all crime types for the year', () {
    final rows = [
      row('theft', DateTime(2026, 1, 5), 'solved'),
      row('fraud', DateTime(2026, 1, 15), 'pending'),
      row('assault', DateTime(2026, 3, 2), 'solved'),
    ];
    final report = computeStatsReport(rows, 2026);
    expect(report.totalRow.yearTotal.solved, 2);
    expect(report.totalRow.yearTotal.unsolved, 1);
    expect(report.totalRow.yearTotal.total, 3);
  });

  test('rows sorted by year total desc; blank type grouped under label', () {
    final rows = [
      row('theft', DateTime(2026, 1, 1), 'open'),
      row('theft', DateTime(2026, 2, 1), 'open'),
      row('fraud', DateTime(2026, 1, 1), 'open'),
      AnalyticsRow(
          id: 0, status: 'open', crimeType: '', dateRegistered: DateTime(2026, 1, 1)),
    ];
    final report = computeStatsReport(rows, 2026, unknownLabel: 'NA');
    expect(report.rows.first.type, 'theft'); // highest count first
    expect(report.rows.any((r) => r.type == 'NA'), isTrue);
  });

  test('crimes outside the year window are ignored', () {
    final rows = [
      row('theft', DateTime(2024, 1, 1), 'solved'), // 2 years back
      row('theft', DateTime(2026, 1, 1), 'solved'),
    ];
    final report = computeStatsReport(rows, 2026);
    final theft = report.rows.firstWhere((r) => r.type == 'theft');
    expect(theft.yearTotal.solved, 1);
    expect(theft.prevYearTotal.total, 0); // 2024 not counted for year 2026
  });

  // --- Category roll-up -----------------------------------------------------
  // The Crime Statistics screen showed "Revenge Murder / सूड हत्या" as its own
  // row while Murder / खून read 1, because it bucketed the leaf sub-type the
  // officer picked instead of that sub-type's category.

  AnalyticsRow fir(String type, DateTime on, {bool detected = false}) =>
      AnalyticsRow(
        id: on.microsecondsSinceEpoch + type.hashCode,
        status: detected ? 'detected' : 'undetected',
        crimeType: type,
        dateRegistered: on,
      );

  CrimeTypeStat rowFor(StatsReport r, String type) =>
      r.rows.firstWhere((s) => s.type == type);

  test('murder sub-types count on the Murder row, not their own', () {
    final report = computeStatsReport([
      fir('Revenge Murder / सूड हत्या', DateTime(2026, 1, 9)),
      fir('Love Affair Murder / प्रेमप्रकरणातून खून', DateTime(2026, 1, 20),
          detected: true),
      fir('Murder / खून', DateTime(2026, 3, 2)),
    ], 2026);

    final murder = rowFor(report, 'Murder / खून');
    expect(murder.yearTotal.total, 3, reason: 'all three are murders');
    expect(murder.months[0].total, 2, reason: 'two in January');
    expect(murder.months[0].solved, 1);
    expect(murder.months[2].total, 1, reason: 'one in March');

    expect(report.rows.any((s) => s.type == 'Revenge Murder / सूड हत्या'),
        isFalse,
        reason: 'sub-type must not get its own row');
  });

  test('every crime head is listed even with no crimes', () {
    final report = computeStatsReport(const [], 2026);
    for (final label in kCrimeCategoryLabels) {
      expect(report.rows.any((s) => s.type == label), isTrue,
          reason: '$label must show as a zero row');
    }
    expect(report.totalRow.yearTotal.total, 0);
  });

  test('previous-year sub-type lands on the category prev-year column', () {
    final report = computeStatsReport([
      fir('Dowry Murder / हुंडाबळी हत्या', DateTime(2025, 6, 1)),
    ], 2026);
    final murder = rowFor(report, 'Murder / खून');
    expect(murder.prevYearTotal.total, 1);
    expect(murder.yearTotal.total, 0);
  });

  test('custom free-text type keeps its own row and is not lost', () {
    final report = computeStatsReport([
      fir('काहीतरी वेगळा गुन्हा', DateTime(2026, 2, 4)),
    ], 2026);
    expect(rowFor(report, 'काहीतरी वेगळा गुन्हा').yearTotal.total, 1);
    expect(report.totalRow.yearTotal.total, 1);
  });
}
