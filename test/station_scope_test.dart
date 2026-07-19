import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/access/station_scope.dart';

// A station-scoped user must see and upload ONLY their assigned station's
// records. These are access-control rules, so both directions matter: the
// right rows must be let through, and every other station's must be blocked.
void main() {
  group('stationInScope', () {
    test('unassigned user (null scope) sees everything', () {
      expect(stationInScope('City Chowk', null), isTrue);
      expect(stationInScope('Begumpura', null), isTrue);
      expect(stationInScope(null, null), isTrue);
    });

    test('assigned user sees their own station', () {
      expect(stationInScope('City Chowk', 'City Chowk'), isTrue);
    });

    test('assigned user does NOT see another station', () {
      expect(stationInScope('Begumpura', 'City Chowk'), isFalse);
      expect(stationInScope('MIDC Waluj', 'Waluj'), isFalse);
      expect(stationInScope('Waluj', 'MIDC Waluj'), isFalse);
    });

    test('matching ignores case, spacing and punctuation', () {
      expect(stationInScope('city chowk', 'City Chowk'), isTrue);
      expect(stationInScope('  CITY  CHOWK  ', 'City Chowk'), isTrue);
      expect(stationInScope('City-Chowk', 'City Chowk'), isTrue);
    });

    test('matching folds the "police station" tail', () {
      expect(stationInScope('City Chowk Police Station', 'City Chowk'), isTrue);
      expect(stationInScope('City Chowk', 'City Chowk police station'), isTrue);
    });

    test('a record with no station is hidden from a scoped user', () {
      // Station-less rows belong to no station — showing them would leak rows
      // the admin never granted.
      expect(stationInScope(null, 'City Chowk'), isFalse);
      expect(stationInScope('', 'City Chowk'), isFalse);
      expect(stationInScope('   ', 'City Chowk'), isFalse);
    });
  });

  group('stationKey', () {
    test('blank names have no key', () {
      expect(stationKey(null), isNull);
      expect(stationKey(''), isNull);
      expect(stationKey('   '), isNull);
    });

    test('spelling variants of one station share a key', () {
      final a = stationKey('City Chowk');
      expect(a, isNotNull);
      expect(stationKey('city chowk'), a);
      expect(stationKey('City Chowk Police Station'), a);
    });

    test('different stations have different keys', () {
      expect(stationKey('City Chowk'), isNot(stationKey('Begumpura')));
    });
  });
}
