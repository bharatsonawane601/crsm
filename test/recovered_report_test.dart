import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/analyzer/analytics_model.dart';
import 'package:crms/features/bhag/recovered_report_model.dart';
import 'package:crms/features/bhag/station_report_model.dart';

AnalyticsRow _row(String station, String crimeType, double recovered,
        DateTime d) =>
    AnalyticsRow(
        id: 0,
        status: 'detected',
        station: station,
        crimeType: crimeType,
        recoveredValue: recovered,
        dateRegistered: d);

void main() {
  final mapping = defaultRecoveredMapping();
  const grouping = RecoveredGrouping(
    divisionOrder: ['सपोआ शहर', 'सपोआ छावणी'],
    stationDivision: {'सिटीचौक': 'सपोआ शहर', 'छावणी': 'सपोआ छावणी'},
    stationSort: {'सिटीचौक': 0, 'छावणी': 1},
  );
  const period = StationReportPeriod(month: 12, year: 2025);

  test('splits theft recoveries into columns, groups by सपोआ, totals up', () {
    final firs = [
      _row('सिटीचौक', 'Two-Wheeler Theft / दुचाकी चोरी', 100, DateTime(2025, 12, 1)),
      _row('सिटीचौक', 'Four-Wheeler Theft / चारचाकी चोरी', 200, DateTime(2025, 12, 2)),
      _row('सिटीचौक', 'Mobile Theft / मोबाईल चोरी', 50, DateTime(2025, 12, 3)),
      // Excluded: no recovered value.
      _row('सिटीचौक', 'Theft / चोरी', 0, DateTime(2025, 12, 4)),
      // Excluded: not a theft crime.
      _row('सिटीचौक', 'Murder / खून', 500, DateTime(2025, 12, 5)),
      _row('छावणी', 'Two-Wheeler Theft / दुचाकी चोरी', 300, DateTime(2025, 12, 6)),
    ];

    final data = computeRecoveredReport(
      firs: firs,
      mapping: mapping,
      grouping: grouping,
      period: period,
    );

    expect(data.groups.map((g) => g.name).toList(), ['सपोआ शहर', 'सपोआ छावणी']);

    final city = data.groups.first;
    final ct = city.rows.single;
    expect(ct.station, 'सिटीचौक');
    expect(ct.cell(RecoveredCol.twoWheeler).count, 1);
    expect(ct.cell(RecoveredCol.twoWheeler).value, 100);
    expect(ct.cell(RecoveredCol.fourWheeler).value, 200);
    expect(ct.cell(RecoveredCol.other).count, 1); // Mobile Theft
    expect(ct.cell(RecoveredCol.other).value, 50);
    expect(ct.cell(RecoveredCol.jewellery).count, 0); // no jewellery theft type

    // Grand totals across both sub-divisions.
    expect(data.total(RecoveredCol.twoWheeler).count, 2); // city + chhavani
    expect(data.total(RecoveredCol.twoWheeler).value, 400);
    expect(data.total(RecoveredCol.other).value, 50);
  });

  test('manual override fills दागिने and feeds subtotal + grand total', () {
    final firs = [
      _row('सिटीचौक', 'Two-Wheeler Theft / दुचाकी चोरी', 100, DateTime(2025, 12, 1)),
    ];
    // jewellery = col index 2.
    final data = computeRecoveredReport(
      firs: firs,
      mapping: mapping,
      grouping: grouping,
      period: period,
      overrides: {'सिटीचौक|2|c': 4, 'सिटीचौक|2|v': 999},
    );
    final ct = data.groups.first.rows.single;
    expect(ct.cell(RecoveredCol.jewellery).count, 4);
    expect(ct.cell(RecoveredCol.jewellery).value, 999);
    expect(data.total(RecoveredCol.jewellery).value, 999);
  });

  test('cumulative includes earlier months; month-only does not', () {
    final firs = [
      _row('सिटीचौक', 'Two-Wheeler Theft / दुचाकी चोरी', 10, DateTime(2025, 3, 1)),
      _row('सिटीचौक', 'Two-Wheeler Theft / दुचाकी चोरी', 20, DateTime(2025, 12, 1)),
    ];
    final cumulative = computeRecoveredReport(
      firs: firs,
      mapping: mapping,
      grouping: grouping,
      period: const StationReportPeriod(
          month: 12, year: 2025, mode: StationPeriodMode.cumulative),
    );
    expect(cumulative.total(RecoveredCol.twoWheeler).count, 2);

    final monthOnly = computeRecoveredReport(
      firs: firs,
      mapping: mapping,
      grouping: grouping,
      period: const StationReportPeriod(
          month: 12, year: 2025, mode: StationPeriodMode.month),
    );
    expect(monthOnly.total(RecoveredCol.twoWheeler).count, 1);
  });
}
