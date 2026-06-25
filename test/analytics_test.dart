import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/analyzer/analytics_model.dart';

void main() {
  // Fixed "now": Wednesday, 15 April 2026.
  final now = DateTime(2026, 4, 15, 10);

  List<AnalyticsRow> sample() => [
        AnalyticsRow(
          id: 1,
          status: 'solved',
          dateRegistered: DateTime(2026, 4, 15), // today
          section: '379',
          crimeType: 'theft',
          officerName: 'PI Deshmukh',
          chargesheetDate: DateTime(2026, 4, 25), // +10 days
          recoveredValue: 5000,
          accusedCount: 2,
          arrestedCount: 1,
          wantedCount: 1,
        ),
        AnalyticsRow(
          id: 2,
          status: 'pending',
          dateRegistered: DateTime(2026, 4, 1), // this month/year
          section: '379',
          crimeType: 'theft',
          officerName: 'PI Deshmukh',
          recoveredValue: 2000,
          arrestedCount: 2,
        ),
        AnalyticsRow(
          id: 3,
          status: 'open',
          dateRegistered: DateTime(2026, 1, 10), // this year, not month
          section: '420',
          crimeType: 'fraud',
          officerName: 'PSI Kale',
        ),
        AnalyticsRow(
          id: 4,
          status: 'solved',
          dateRegistered: DateTime(2025, 12, 20), // last year
          section: '379',
        ),
      ];

  test('KPI windows count by registration date', () {
    final s = computeAnalytics(sample(), now: now);
    expect(s.total, 4);
    expect(s.today, 1);
    expect(s.thisWeek, 1); // week starts Mon 13 Apr -> only the 15th
    expect(s.thisMonth, 2); // 15 Apr + 1 Apr
    expect(s.thisYear, 3); // excludes Dec 2025
  });

  test('status / arrest / recovery aggregates', () {
    final s = computeAnalytics(sample(), now: now);
    expect(s.statusCounts['solved'], 2);
    expect(s.statusCounts['pending'], 1);
    expect(s.statusCounts['open'], 1);
    expect(s.arrested, 3);
    expect(s.wanted, 1);
    expect(s.recoveredValue, 7000);
  });

  test('avg days to chargesheet only over crimes with a chargesheet', () {
    final s = computeAnalytics(sample(), now: now);
    expect(s.avgDaysToChargesheet, 10);
  });

  test('top sections sorted desc, crime types, officers', () {
    final s = computeAnalytics(sample(), now: now);
    expect(s.topSections.first.key, '379');
    expect(s.topSections.first.value, 3);
    expect(s.crimeTypeCounts['theft'], 2);
    expect(s.officerCounts['PI Deshmukh'], 2);
  });

  test('day-of-week and monthly trend', () {
    final s = computeAnalytics(sample(), now: now);
    // Both 15 Apr and 1 Apr 2026 are Wednesdays -> index 2 has 2.
    expect(s.dayOfWeekCounts[2], 2);
    expect(s.monthlyTrend.map((e) => e.key), contains('2026-04'));
    expect(s.monthlyTrend.first.key, '2025-12'); // chronological
  });

  test('filter narrows the rows', () {
    final rows = sample();
    const f = AnalyticsFilter(status: 'solved');
    final filtered = rows.where(f.matches).toList();
    expect(filtered.length, 2);

    final byDate = AnalyticsFilter(from: DateTime(2026, 4, 1));
    expect(rows.where(byDate.matches).length, 2);
  });
}
