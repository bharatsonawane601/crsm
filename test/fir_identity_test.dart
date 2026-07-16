import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/analyzer/analytics_model.dart';
import 'package:crms/features/crime_entry/crime_repository.dart';
import 'package:crms/features/crime_entry/data/bns_data.dart';

void main() {
  group('canonicalStationName (one station = one spelling)', () {
    test('Marathi spellings fold into the canonical English name', () {
      expect(canonicalStationName('दौलताबाद'), 'Daulatabad');
      expect(canonicalStationName('सिटी चौक'), 'City Chowk');
      expect(canonicalStationName('सिटीचौक'), 'City Chowk');
      expect(canonicalStationName('एमआयडीसी सिडको'), 'MIDC CIDCO');
    });

    test('case/spacing variants of English names fold too', () {
      expect(canonicalStationName('daulatabad'), 'Daulatabad');
      expect(canonicalStationName('  city  chowk '), 'City Chowk');
      expect(canonicalStationName('MIDC-Waluj'), 'MIDC Waluj');
    });

    test('a "पोलीस स्टेशन" tail is ignored', () {
      expect(canonicalStationName('दौलताबाद पोलीस स्टेशन'), 'Daulatabad');
      expect(canonicalStationName('Satara police station'), 'Satara');
    });

    test('unknown names pass through unchanged; blank stays null', () {
      expect(canonicalStationName('Some Rural PS'), 'Some Rural PS');
      expect(canonicalStationName('   '), isNull);
      expect(canonicalStationName(null), isNull);
    });
  });

  group('computeAnalytics KPI windows', () {
    AnalyticsRow row(DateTime d) =>
        AnalyticsRow(id: 1, status: 'undetected', dateRegistered: d);

    test('future-dated records count in NO window', () {
      final now = DateTime(2026, 7, 9); // Thursday
      final s = computeAnalytics(
        [row(DateTime(2026, 7, 10)), row(DateTime(2027, 1, 1))],
        now: now,
      );
      expect(s.today, 0);
      expect(s.thisWeek, 0);
      expect(s.thisMonth, 0);
      expect(s.thisYear, 0);
      expect(s.total, 2); // still part of the overall total
    });

    test('a record dated today counts in all four windows', () {
      final now = DateTime(2026, 7, 9, 15);
      final s = computeAnalytics([row(DateTime(2026, 7, 9))], now: now);
      expect(s.today, 1);
      expect(s.thisWeek, 1);
      expect(s.thisMonth, 1);
      expect(s.thisYear, 1);
    });
  });

  group('CrimeRepository.firIdentityKey (import duplicate detection)', () {
    test('same FIR in Devanagari and ASCII digits produces the same key', () {
      expect(
        CrimeRepository.firIdentityKey('१२/२०२४', 2024, 'सिटी चौक'),
        CrimeRepository.firIdentityKey('12/2024', 2024, 'सिटीचौक'),
      );
    });

    test('case / spacing / punctuation variants match', () {
      expect(
        CrimeRepository.firIdentityKey('123', 2025, 'City  Chowk'),
        CrimeRepository.firIdentityKey(' 123 ', 2025, 'city chowk'),
      );
      expect(
        CrimeRepository.firIdentityKey('45', 2025, 'MIDC-Waluj'),
        CrimeRepository.firIdentityKey('45', 2025, 'midc waluj'),
      );
    });

    test('different FIR no, year or station give different keys', () {
      final a = CrimeRepository.firIdentityKey('12', 2024, 'Satara');
      expect(CrimeRepository.firIdentityKey('13', 2024, 'Satara'), isNot(a));
      expect(CrimeRepository.firIdentityKey('12', 2025, 'Satara'), isNot(a));
      expect(CrimeRepository.firIdentityKey('12', 2024, 'Harsul'), isNot(a));
    });

    test('no FIR number -> null (never treated as a duplicate)', () {
      expect(CrimeRepository.firIdentityKey(null, 2024, 'Satara'), isNull);
      expect(CrimeRepository.firIdentityKey('  ', 2024, 'Satara'), isNull);
    });
  });
}
