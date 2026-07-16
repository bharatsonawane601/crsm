import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/analyzer/analytics_model.dart';
import 'package:crms/features/bhag/bhag_model.dart';

AnalyticsRow _row(String crimeType, String status, DateTime date) =>
    AnalyticsRow(id: 0, status: status, crimeType: crimeType, dateRegistered: date);

void main() {
  // Compare December, Year A = 2024 vs Year B = 2025.
  const period = BhagPeriod(month: 12, yearA: 2024, yearB: 2025);
  final config = [BhagRow(id: 'theft', crimeTypes: ['Theft / चोरी'])];

  test('buckets a sub-type into its category row across month/YTD/year', () {
    final firs = [
      // Sub-type of Theft category -> should match the "Theft / चोरी" row.
      _row('Vehicle Theft / वाहन चोरी', 'detected', DateTime(2024, 12, 5)),
      _row('Vehicle Theft / वाहन चोरी', 'undetected', DateTime(2024, 6, 1)),
      _row('Theft / चोरी', 'undetected', DateTime(2025, 12, 20)),
      _row('Theft / चोरी', 'detected', DateTime(2025, 12, 21)),
      // A different category -> must NOT count into the Theft row.
      _row('Murder / खून', 'detected', DateTime(2024, 12, 9)),
    ];

    final data = computeBhag(firs: firs, config: config, period: period);
    final r = data.groups.single.parent;

    // December 2024: 1 registered, 1 detected.
    expect(r.cell('mAd'), 1);
    expect(r.cell('mAu'), 1);
    // December 2025: 2 registered, 1 detected.
    expect(r.cell('mBd'), 2);
    expect(r.cell('mBu'), 1);
    // YTD Jan–Dec 2024: 2 registered (Dec + June), 1 detected.
    expect(r.cell('yAd'), 2);
    expect(r.cell('yAu'), 1);
    // Full year A (सन 2024): same 2 registered, 1 detected.
    expect(r.cell('sAd'), 2);
    expect(r.cell('sAu'), 1);
    // घट/वाढ on दाखल for the month = A - B = 1 - 2 = -1 (crime rose).
    expect(r.gvMonth, -1);
  });

  test('manual override replaces the auto count and feeds the total', () {
    final firs = [_row('Theft / चोरी', 'undetected', DateTime(2025, 12, 1))];
    final data = computeBhag(
      firs: firs,
      config: config,
      period: period,
      overrides: {'theft|mBd': 9},
    );
    expect(data.groups.single.parent.cell('mBd'), 9);
    expect(data.total.cell('mBd'), 9);
  });

  test('sub-crimes nest under their category; parent = sum of sub-crimes', () {
    final subConfig = [
      BhagRow(id: 'ck', crimeTypes: ['Contract Killing (Supari) / सुपारी हत्या']),
      BhagRow(id: 'rv', crimeTypes: ['Revenge Murder / सूड हत्या']),
    ];
    final firs = [
      _row('Contract Killing (Supari) / सुपारी हत्या', 'detected', DateTime(2025, 12, 2)),
      _row('Contract Killing (Supari) / सुपारी हत्या', 'undetected', DateTime(2025, 12, 3)),
      _row('Revenge Murder / सूड हत्या', 'detected', DateTime(2025, 12, 4)),
      _row('Revenge Murder / सूड हत्या', 'detected', DateTime(2025, 12, 5)),
      _row('Revenge Murder / सूड हत्या', 'undetected', DateTime(2025, 12, 6)),
      // An unlisted murder sub-type must NOT be counted.
      _row('Dowry Murder / हुंडाबळी हत्या', 'detected', DateTime(2025, 12, 7)),
    ];

    final data = computeBhag(firs: firs, config: subConfig, period: period);

    // One serial group: खून, with two sub-crimes.
    expect(data.groups.length, 1);
    final g = data.groups.single;
    expect(g.label, 'खून');
    expect(g.subs.length, 2);
    expect(g.parentEditableRow, isNull); // derived parent, not directly editable

    // Parent = sum of the two listed sub-crimes (2 + 3 = 5 registered in Dec B).
    expect(g.parent.cell('mBd'), 5);
    // Detected: contract 1 + revenge 2 = 3.
    expect(g.parent.cell('mBu'), 3);
    // The unlisted Dowry Murder is excluded.
    expect(g.subs[0].cell('mBd'), 2); // contract killing
    expect(g.subs[1].cell('mBd'), 3); // revenge murder
  });

  test('adding a sub-crime nests under the existing category row (no duplicate group)', () {
    // A category row (खून) already present, then a sub-crime added afterwards.
    final cfg = [
      BhagRow(id: 'murder', crimeTypes: ['Murder / खून']),
      BhagRow(id: 'ck', crimeTypes: ['Contract Killing (Supari) / सुपारी हत्या']),
    ];
    final firs = [
      _row('Contract Killing (Supari) / सुपारी हत्या', 'detected', DateTime(2025, 12, 1)),
      _row('Personal Enmity Murder / वैयक्तिक वैरातून खून', 'undetected', DateTime(2025, 12, 2)),
      _row('Murder / खून', 'detected', DateTime(2025, 12, 3)),
    ];

    final data = computeBhag(firs: firs, config: cfg, period: period);

    // ONE खून group, not two.
    expect(data.groups.length, 1);
    final g = data.groups.single;
    expect(g.label, 'खून');
    // The category row is the editable parent; the sub-crime nests under it.
    expect(g.parentEditableRow?.id, 'murder');
    expect(g.subs.length, 1);
    // Parent = whole category count (all three murders in Dec B).
    expect(g.parent.cell('mBd'), 3);
    // Sub shows only its own count.
    expect(g.subs.single.cell('mBd'), 1);
  });

  test('combined (multi-type) इतर row sums all its selected crime types', () {
    final combined = [
      BhagRow(
        id: 'other',
        label: 'इतर भाग ६',
        crimeTypes: ['Gambling / जुगार', 'Arms & Explosives / शस्त्र व स्फोटके'],
      ),
    ];
    final firs = [
      _row('Gambling / जुगार', 'detected', DateTime(2025, 12, 1)),
      _row('Gambling / जुगार', 'detected', DateTime(2025, 12, 2)),
      _row('Arms & Explosives / शस्त्र व स्फोटके', 'undetected', DateTime(2025, 12, 3)),
      // Not in the combined set -> excluded.
      _row('Theft / चोरी', 'detected', DateTime(2025, 12, 4)),
    ];

    final data = computeBhag(firs: firs, config: combined, period: period);
    final g = data.groups.single;
    expect(g.label, 'इतर भाग ६');
    expect(g.subs, isEmpty); // standalone, not nested
    expect(g.parent.cell('mBd'), 3); // 2 gambling + 1 arms, theft excluded
  });
}
