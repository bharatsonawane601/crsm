import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/analyzer/analytics_model.dart';
import 'package:crms/features/bhag/bhag_model.dart';
import 'package:crms/features/crime_entry/data/crime_types_data.dart';

/// Guards the bug the CP reported: picking a sub-type such as
/// "Love Affair Murder / प्रेमप्रकरणातून खून" must still count under the
/// Murder / खून row of भाग १-५ and in the dashboard's crime statistics —
/// not vanish into its own bucket.
void main() {
  AnalyticsRow fir(String type, {required DateTime on, bool detected = false}) =>
      AnalyticsRow(
        id: on.millisecondsSinceEpoch + type.hashCode,
        status: detected ? 'detected' : 'undetected',
        crimeType: type,
        dateRegistered: on,
        dateOccurred: on,
      );

  test('भाग १-५ counts murder sub-types under the Murder category row', () {
    final firs = [
      fir('Love Affair Murder / प्रेमप्रकरणातून खून', on: DateTime(2026, 3, 5)),
      fir('Dowry Murder / हुंडाबळी हत्या',
          on: DateTime(2026, 3, 9), detected: true),
      fir('Murder / खून', on: DateTime(2026, 3, 20)),
      // A theft must NOT land in the murder row.
      fir('Mobile Theft / मोबाईल चोरी', on: DateTime(2026, 3, 11)),
    ];

    final data = computeBhag(
      firs: firs,
      config: defaultBhagRows(),
      period: const BhagPeriod(month: 3, yearA: 2026, yearB: 2025),
    );

    final murder = data.groups.firstWhere((g) => g.label == 'खून').parent;
    expect(murder.cell('mAd'), 3, reason: '3 murders registered in Mar 2026');
    expect(murder.cell('mAu'), 1, reason: '1 of them detected');
  });

  test('भाग ६ opens with working default rows (was blank)', () {
    final rows = defaultBhag6Rows();
    expect(rows, isNotEmpty, reason: 'भाग ६ must not open as an empty table');
    // Every default must be a real catalogue category, otherwise the row
    // silently counts nothing.
    for (final r in rows) {
      expect(isCrimeCategoryLabel(r.primary), isTrue,
          reason: '"${r.primary}" is not a crime category label');
    }

    final data = computeBhag(
      firs: [
        fir('Card Gambling / पत्ते जुगार', on: DateTime(2026, 3, 4)),
        fir('Illegal Sale of Liquor / अवैध दारू विक्री',
            on: DateTime(2026, 3, 6), detected: true),
      ],
      config: rows,
      period: const BhagPeriod(month: 3, yearA: 2026, yearB: 2025),
    );
    final gambling = data.groups.firstWhere((g) => g.label == 'जुगार').parent;
    expect(gambling.cell('mAd'), 1);
  });

  test('dashboard statistics roll sub-types up into their category', () {
    final s = computeAnalytics([
      fir('Love Affair Murder / प्रेमप्रकरणातून खून', on: DateTime(2026, 3, 5)),
      fir('Contract Killing (Supari) / सुपारी हत्या', on: DateTime(2026, 3, 6)),
      fir('Mobile Theft / मोबाईल चोरी', on: DateTime(2026, 3, 7)),
    ], now: DateTime(2026, 3, 31));

    expect(s.crimeTypeCounts['Murder / खून'], 2,
        reason: 'both murder sub-types roll up into Murder');
    expect(s.crimeTypeCounts.containsKey('Love Affair Murder / प्रेमप्रकरणातून खून'),
        isFalse,
        reason: 'sub-type must not be its own bucket');
  });
}
