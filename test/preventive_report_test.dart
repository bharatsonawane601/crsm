import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/analyzer/analytics_model.dart';
import 'package:crms/features/bhag/bhag_model.dart' show BhagPeriod;
import 'package:crms/features/bhag/preventive_report_model.dart';

AnalyticsRow _row(String action, {DateTime? prevDate, DateTime? regDate}) =>
    AnalyticsRow(
        id: 0,
        status: 'detected',
        preventiveAction: action,
        preventiveDate: prevDate,
        dateRegistered: regDate);

PreventiveRowResult _res(PreventiveTableData d, String id) =>
    d.rows.firstWhere((e) => e.$1.id == id).$2;

void main() {
  const period = BhagPeriod(month: 12, yearA: 2024, yearB: 2025);
  final config = defaultPreventiveRows();

  test('counts month / पावेतो / सन windows and घट/वाढ per provision', () {
    final firs = [
      _row('126 BNSS', prevDate: DateTime(2024, 12, 5)),
      _row('126', prevDate: DateTime(2024, 6, 1)), // YTD + सन, not month
      _row('१२६ भा.ना.सु.सं.', prevDate: DateTime(2025, 12, 10)), // Devanagari digits
      _row('MPDA action', prevDate: DateTime(2025, 12, 11)),
      _row('128 BNSS', prevDate: DateTime(2024, 12, 1)),
      // No preventive date -> falls back to registration date.
      _row('129', regDate: DateTime(2024, 12, 2)),
      // Empty preventive action -> ignored.
      _row('', prevDate: DateTime(2024, 12, 9)),
    ];

    final data = computePreventive(firs: firs, config: config, period: period);

    final p126 = _res(data, 'p126');
    expect(p126.cell('mA'), 1); // Dec 2024
    expect(p126.cell('mB'), 1); // Dec 2025 (Devanagari)
    expect(p126.cell('yA'), 2); // Dec + June 2024
    expect(p126.cell('yB'), 1);
    expect(p126.cell('sA'), 2); // full year 2024
    expect(p126.gvMonth, 0); // mA - mB
    expect(p126.gvYtd, 1); // yA - yB

    expect(_res(data, 'pmpda').cell('mB'), 1);
    expect(_res(data, 'p129').cell('mA'), 1); // via registration-date fallback

    // Totals across all provisions.
    expect(data.total.cell('mA'), 3); // 126 + 128 + 129
    expect(data.total.cell('mB'), 2); // 126 + MPDA
  });

  test('manual override replaces the auto count and feeds the total', () {
    final firs = [_row('126', prevDate: DateTime(2024, 12, 1))];
    final data = computePreventive(
      firs: firs,
      config: config,
      period: period,
      overrides: {'p126|mA': 9},
    );
    expect(_res(data, 'p126').cell('mA'), 9);
    expect(data.total.cell('mA'), 9);
  });
}
