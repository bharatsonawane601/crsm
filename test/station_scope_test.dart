import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/access/station_scope.dart';

// A station-scoped user must see and upload ONLY their assigned station's
// records. These are access-control rules, so both directions matter: the
// right rows must be let through, and every other station's must be blocked.
/// The normalised key-set the app builds from a station's server aliases.
Set<String> keys(List<String> aliases) => {
      for (final a in aliases)
        if (stationKey(a) != null) stationKey(a)!,
    };

void main() {
  group('stationInScope', () {
    test('unassigned user (null scope) sees everything', () {
      expect(stationInScope('City Chowk', null), isTrue);
      expect(stationInScope('Begumpura', null), isTrue);
      expect(stationInScope(null, null), isTrue);
    });

    test('assigned user sees their own station', () {
      expect(stationInScope('City Chowk', keys(['City Chowk'])), isTrue);
    });

    test('assigned user does NOT see another station', () {
      expect(stationInScope('Begumpura', keys(['City Chowk'])), isFalse);
      expect(stationInScope('MIDC Waluj', keys(['Waluj'])), isFalse);
      expect(stationInScope('Waluj', keys(['MIDC Waluj'])), isFalse);
    });

    test('matching ignores case, spacing and punctuation', () {
      expect(stationInScope('city chowk', keys(['City Chowk'])), isTrue);
      expect(stationInScope('  CITY  CHOWK  ', keys(['City Chowk'])), isTrue);
      expect(stationInScope('City-Chowk', keys(['City Chowk'])), isTrue);
    });

    test('matching folds the "police station" tail', () {
      expect(stationInScope('City Chowk Police Station', keys(['City Chowk'])), isTrue);
      expect(stationInScope('City Chowk', keys(['City Chowk police station'])), isTrue);
    });

    test('a record with no station stays VISIBLE to a scoped user', () {
      // An unfiled record is work-in-progress on the user's own machine, and
      // the server stamps it with their station on upload. Hiding it made
      // people's own half-entered FIRs vanish.
      expect(stationInScope(null, keys(['City Chowk'])), isTrue);
      expect(stationInScope('', keys(['City Chowk'])), isTrue);
      expect(stationInScope('   ', keys(['City Chowk'])), isTrue);
    });

    test('a server ALIAS of the assigned station matches (the real bug)', () {
      // FIRs are filed as "एम.वाळूज" while the station is named "MIDC Waluj".
      // The server sends both spellings; matching only the English name hid
      // every one of that station's records.
      final midcWaluj = keys(['MIDC Waluj', 'एम.वाळूज', 'MIDCWALUJ']);
      expect(stationInScope('एम.वाळूज', midcWaluj), isTrue);
      expect(stationInScope('MIDC Waluj', midcWaluj), isTrue);
      expect(stationInScope('MIDCWALUJ', midcWaluj), isTrue);
      // ...and a genuinely different station is still blocked.
      expect(stationInScope('Waluj', midcWaluj), isFalse);
      expect(stationInScope('City Chowk', midcWaluj), isFalse);
    });

    test('an empty alias set means unrestricted', () {
      expect(stationInScope('Anything', <String>{}), isTrue);
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

  group('zone office scope', () {
    // Zone staff get one flat alias list covering every station in their zone,
    // so the same single filter serves both roles.
    final zoneOne = <String>{
      for (final s in [
        'City Chowk', 'सिटी चौक',
        'Kranti Chowk', 'क्रांती चौक',
        'Vedant Nagar', 'वेदांत नगर',
        'Begumpura', 'बेगमपुरा',
        'Chhavani', 'chhavni',
        'Waluj', 'वाळूज',
        'MIDC Waluj', 'एम.वाळूज', 'MIDCWALUJ',
        'Daulatabad', 'दौलताबाद',
      ])
        if (stationKey(s) != null) stationKey(s)!,
    };

    test('every station in the zone is in scope', () {
      for (final s in ['City Chowk', 'Kranti Chowk', 'Waluj', 'Daulatabad']) {
        expect(stationInScope(s, zoneOne), isTrue, reason: s);
      }
    });

    test('the admin alias spelling is in scope, not just the app name', () {
      // The exact failure that hid 1,985 FIRs: data is filed as "एम.वाळूज",
      // which the app's built-in list does not know.
      expect(stationInScope('एम.वाळूज', zoneOne), isTrue);
      expect(stationInScope('chhavni', zoneOne), isTrue);
    });

    test('a station from the other zone is out of scope', () {
      for (final s in ['CIDCO', 'Usmanpura', 'Harsul', 'Satara']) {
        expect(stationInScope(s, zoneOne), isFalse, reason: s);
      }
    });
  });
}
