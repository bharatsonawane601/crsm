import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/analyzer/analytics_model.dart';
import 'package:crms/features/analyzer/stats_report.dart';

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
}
