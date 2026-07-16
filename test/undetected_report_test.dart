import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/analyzer/analytics_model.dart';
import 'package:crms/features/bhag/undetected_report_model.dart';

AnalyticsRow _row(String station, String crimeType, String status) =>
    AnalyticsRow(
        id: 0,
        status: status,
        station: station,
        crimeType: crimeType,
        dateRegistered: DateTime(2025, 6, 15));

UndetRowResult _r(UndetData d, String id) =>
    d.rows.firstWhere((e) => e.row.id == id);

void main() {
  final config = defaultUndetRows();
  final universe = defaultUniverse();
  const stations = ['सिटीचौक', 'क्रांतीचौक'];
  final range = UndetRange(from: DateTime(2025, 1, 1), to: DateTime(2025, 12, 31));

  UndetData run(List<AnalyticsRow> firs, {Map<String, int> overrides = const {}}) =>
      computeUndetected(
        firs: firs,
        config: config,
        universe: universe,
        stations: stations,
        range: range,
        overrides: overrides,
      );

  test('matrix: undetected only, ** subsets excluded, इतर = remainder', () {
    final firs = [
      _row('सिटीचौक', 'Murder / खून', 'undetected'),
      _row('सिटीचौक', 'Mobile Theft / मोबाईल चोरी', 'undetected'),
      _row('क्रांतीचौक', 'Two-Wheeler Theft / दुचाकी चोरी', 'undetected'),
      // Detected theft -> excluded entirely.
      _row('क्रांतीचौक', 'Theft / चोरी', 'detected'),
      // In universe but no explicit row -> इतर.
      _row('सिटीचौक', 'Kidnapping for Ransom / खंडणीसाठी अपहरण', 'undetected'),
      // Not in the भाग-1-5 universe -> counted nowhere.
      _row('सिटीचौक', 'Hacking / हॅकिंग', 'undetected'),
      _row('क्रांतीचौक', 'Highway Robbery / महामार्ग जबरी चोरी', 'undetected'),
    ];

    final d = run(firs);

    expect(_r(d, 'murder').at('सिटीचौक'), 1);
    // सर्व चोरी = all undetected theft (mobile + two-wheeler across stations).
    expect(_r(d, 'theft').at('सिटीचौक'), 1);
    expect(_r(d, 'theft').at('क्रांतीचौक'), 1);
    expect(_r(d, 'theft').total, 2);
    // ** subsets are tallied but excluded from totals.
    expect(_r(d, 'mobtheft').at('सिटीचौक'), 1);
    expect(_r(d, 'mvtheft').at('क्रांतीचौक'), 1);
    // इतर catches the kidnapping (universe, unmatched).
    expect(_r(d, 'other').at('सिटीचौक'), 1);
    expect(_r(d, 'robbery').at('क्रांतीचौक'), 1);

    // Column totals over serial rows only (** excluded).
    expect(d.colTotals['सिटीचौक'], 3); // murder + theft + other
    expect(d.colTotals['क्रांतीचौक'], 2); // theft + robbery
    expect(d.grandTotal, 5); // Hacking excluded
  });

  test('per-cell override replaces the count and feeds column/grand totals', () {
    final firs = [_row('सिटीचौक', 'Murder / खून', 'undetected')];
    final d = run(firs, overrides: {'murder|सिटीचौक': 9});
    expect(_r(d, 'murder').at('सिटीचौक'), 9);
    expect(d.colTotals['सिटीचौक'], 9);
    expect(d.grandTotal, 9);
  });
}
