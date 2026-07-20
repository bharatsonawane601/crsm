import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crms/core/crypto/field_cipher.dart';
import 'package:crms/data/db/database.dart';
import 'package:crms/features/crime_entry/crime_repository.dart';
import 'package:crms/features/crime_entry/models/crime_draft.dart';
import 'package:crms/features/portal/central_client.dart' show SuppressedRecord;

void main() {
  late AppDatabase db;
  late CrimeRepository repo;
  final cipher = FieldCipher.fromBytes(List<int>.generate(32, (i) => i));

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = CrimeRepository(db, cipher);
  });

  tearDown(() => db.close());

  CrimeDraft sampleDraft() {
    final d = CrimeDraft(firNo: '123/2026', year: 2026, section: '379');
    d.complainant
      ..name = 'Ramesh Patil'
      ..mobile = '9876543210'
      ..aadhaar = '123456789012';
    d.accused.add(AccusedDraft(name: 'Accused One', aadhaar: '999988887777'));
    d.accused.add(AccusedDraft(name: 'Accused Two'));
    d.stolen.add(StolenItemDraft(description: 'Mobile phone', value: 15000));
    d.recovered.add(RecoveredItemDraft(description: 'Cash', value: 5000));
    d.investigation.officerName = 'PI Deshmukh';
    d.verdict.chargesheetNo = 'CS-1';
    return d;
  }

  test('save then load round-trips the full draft', () async {
    final id = await repo.saveDraft(sampleDraft());
    final loaded = await repo.loadDraft(id);

    expect(loaded, isNotNull);
    expect(loaded!.firNo, '123/2026');
    expect(loaded.year, 2026);
    expect(loaded.section, '379');
    expect(loaded.complainant.name, 'Ramesh Patil');
    // Aadhaar comes back decrypted.
    expect(loaded.complainant.aadhaar, '123456789012');
    expect(loaded.accused.length, 2);
    expect(loaded.accused.first.name, 'Accused One');
    expect(loaded.accused.first.aadhaar, '999988887777');
    expect(loaded.stolen.single.value, 15000);
    expect(loaded.recovered.single.value, 5000);
    expect(loaded.investigation.officerName, 'PI Deshmukh');
    expect(loaded.verdict.chargesheetNo, 'CS-1');
  });

  test('new NCRB FIR fields round-trip (crime / person / accused / property / inv)',
      () async {
    final d = sampleDraft()
      ..firDate = DateTime(2026, 3, 30)
      ..firTime = '19:02'
      ..gdEntryNo = '040'
      ..beatNo = '1'
      ..directionDistance = 'East, 1 km'
      ..delayReason = 'No delay'
      ..inquestUdNo = 'UD-9';
    d.complainant
      ..fatherHusbandName = 'Kadubal'
      ..birthYear = 1997
      ..nationality = 'India'
      ..occupation = 'Private job'
      ..permanentAddress = 'Bakwal Nagar'
      ..idType = 'Aadhaar'
      ..idNumber = 'XXXX';
    d.accused.first
      ..alias = 'Unknown-1'
      ..relativeName = 'Father: Unknown'
      ..physical = {'build': 'Medium', 'height': '170'};
    d.stolen.first.category = 'Vehicles and others';
    d.investigation
      ..registeringOfficerName = 'narendra padalkar'
      ..registeringOfficerRank = 'Inspector'
      ..registeringOfficerNo = '50686'
      ..actionTaken = 'Registered the case'
      ..courtDispatchDate = DateTime(2026, 4, 1)
      ..courtDispatchTime = '10:00';

    final id = await repo.saveDraft(d);
    final l = await repo.loadDraft(id);

    expect(l!.firTime, '19:02');
    expect(l.gdEntryNo, '040');
    expect(l.directionDistance, 'East, 1 km');
    expect(l.inquestUdNo, 'UD-9');
    expect(l.complainant.fatherHusbandName, 'Kadubal');
    expect(l.complainant.birthYear, 1997);
    expect(l.complainant.permanentAddress, 'Bakwal Nagar');
    expect(l.accused.first.alias, 'Unknown-1');
    expect(l.accused.first.physical?['height'], '170');
    expect(l.stolen.first.category, 'Vehicles and others');
    expect(l.investigation.registeringOfficerNo, '50686');
    expect(l.investigation.courtDispatchTime, '10:00');
  });

  test('Aadhaar is persisted encrypted, never as plaintext', () async {
    final id = await repo.saveDraft(sampleDraft());
    final row = await (db.select(db.complainants)
          ..where((t) => t.crimeId.equals(id)))
        .getSingle();

    expect(row.aadhaarEnc, isNotNull);
    expect(row.aadhaarEnc, isNot(contains('123456789012')));
    expect(cipher.decryptField(row.aadhaarEnc), '123456789012');
  });

  test('editing replaces child rows (no duplicates)', () async {
    final id = await repo.saveDraft(sampleDraft());

    final draft = await repo.loadDraft(id);
    draft!.accused.removeLast(); // 2 -> 1
    draft.firNo = '123/2026-A';
    await repo.saveDraft(draft);

    final reloaded = await repo.loadDraft(id);
    expect(reloaded!.firNo, '123/2026-A');
    expect(reloaded.accused.length, 1);

    // Only one crime row total.
    final allCrimes = await db.select(db.crimes).get();
    expect(allCrimes.length, 1);
  });

  test('deleting a crime cascades to children', () async {
    final id = await repo.saveDraft(sampleDraft());
    await repo.deleteCrime(id);

    expect(await repo.loadDraft(id), isNull);
    expect(await db.select(db.accused).get(), isEmpty);
    expect(await db.select(db.stolenProperty).get(), isEmpty);
  });

  group('central sync uid (server deletion safety)', () {
    test('new crime gets a stable non-numeric "c_" uid, exported as uid',
        () async {
      final id = await repo.saveDraft(CrimeDraft(firNo: 'A/2026', year: 2026));
      final loaded = await repo.loadDraft(id);
      expect(loaded!.remoteUid, isNotNull);
      expect(loaded.remoteUid, startsWith('c_'));

      final exported = await repo.exportForCentral();
      expect(exported.single['uid'], loaded.remoteUid);
    });

    test('purge by an OLD numeric uid does NOT delete a freshly-created record',
        () async {
      // The bug: admin deleted FIR with numeric uid "1"; the server suppresses
      // "1" forever. A new record that happens to reuse local id 1 must NOT be
      // purged, because it now carries a unique "c_" uid.
      final id = await repo.saveDraft(CrimeDraft(firNo: 'NEW/2026', year: 2026));

      final removed = await repo.purgeLocalByUids(const [
        SuppressedRecord(uid: '1'),
        SuppressedRecord(uid: '2'),
        SuppressedRecord(uid: '3'),
      ]);
      expect(removed, 0);
      expect(await repo.loadDraft(id), isNotNull); // survived the sync
    });

    test('purge by the record\'s real remote uid removes it', () async {
      final id = await repo.saveDraft(CrimeDraft(firNo: 'DEL/2026', year: 2026));
      final uid = (await repo.loadDraft(id))!.remoteUid!;

      final removed = await repo.purgeLocalByUids([
        SuppressedRecord(uid: uid, firNo: 'DEL/2026', year: 2026),
      ]);
      expect(removed, 1);
      expect(await repo.loadDraft(id), isNull);
    });

    test('legacy row (numeric remote_uid) is still purged by its id', () async {
      final id = await repo.saveDraft(CrimeDraft(firNo: 'OLD/2026', year: 2026));
      // Simulate a pre-v8 record whose uid is its numeric id.
      await (db.update(db.crimes)..where((t) => t.id.equals(id)))
          .write(CrimesCompanion(remoteUid: Value(id.toString())));

      final removed = await repo.purgeLocalByUids([
        SuppressedRecord(uid: id.toString(), firNo: 'OLD/2026', year: 2026),
      ]);
      expect(removed, 1);
      expect(await repo.loadDraft(id), isNull);
    });

    test('a numeric uid that collides with a DIFFERENT FIR is not purged',
        () async {
      // The real-world data loss: this PC was restored from a backup, so its
      // legacy row reuses uid "7" — which the server tombstoned for a totally
      // different FIR belonging to another device. Identity must save it.
      final id = await repo.saveDraft(CrimeDraft(firNo: 'MINE/2026', year: 2026));
      await (db.update(db.crimes)..where((t) => t.id.equals(id)))
          .write(const CrimesCompanion(remoteUid: Value('7')));

      final removed = await repo.purgeLocalByUids(const [
        SuppressedRecord(uid: '7', firNo: 'THEIRS/2026', year: 2026),
      ]);
      expect(removed, 0);
      expect(await repo.loadDraft(id), isNotNull);
    });

    test('same FIR number but a different year is not purged', () async {
      final id = await repo.saveDraft(CrimeDraft(firNo: '12/2026', year: 2026));
      final uid = (await repo.loadDraft(id))!.remoteUid!;

      final removed = await repo.purgeLocalByUids([
        SuppressedRecord(uid: uid, firNo: '12/2026', year: 2019),
      ]);
      expect(removed, 0);
      expect(await repo.loadDraft(id), isNotNull);
    });

    test('Devanagari FIR digits still match their ASCII tombstone', () async {
      final id = await repo.saveDraft(CrimeDraft(firNo: '१२/२०२६', year: 2026));
      final uid = (await repo.loadDraft(id))!.remoteUid!;

      final removed = await repo.purgeLocalByUids([
        SuppressedRecord(uid: uid, firNo: '12/2026', year: 2026),
      ]);
      expect(removed, 1);
    });

    test('an identity-less tombstone (old server) still purges by uid',
        () async {
      final id = await repo.saveDraft(CrimeDraft(firNo: 'LEG/2026', year: 2026));
      final uid = (await repo.loadDraft(id))!.remoteUid!;

      final removed = await repo.purgeLocalByUids([SuppressedRecord(uid: uid)]);
      expect(removed, 1);
    });
  });

  test('watchCrimeList includes complainant + accused names; search matches',
      () async {
    await repo.saveDraft(sampleDraft());

    final list = await repo.watchCrimeList().first;
    expect(list.length, 1);

    final item = list.single;
    expect(item.crime.firNo, '123/2026');
    expect(item.complainantName, 'Ramesh Patil');
    expect(item.accusedNames, containsAll(['Accused One', 'Accused Two']));

    // Search matches FIR no, complainant, accused, section — case-insensitive.
    expect(item.matches('123/2026'), isTrue);
    expect(item.matches('ramesh'), isTrue);
    expect(item.matches('accused two'), isTrue);
    expect(item.matches('379'), isTrue);
    expect(item.matches('nonexistent'), isFalse);
    expect(item.matches(''), isTrue);
  });

  // --- download half of sync (importFromCentral) ---------------------------
  //
  // Sync used to be upload-only, so a freshly issued station login opened an
  // EMPTY Crime Records list: every FIR sat on the server with no way down.

  Map<String, dynamic> centralRow({
    required String uid,
    String firNo = '77/2026',
    int year = 2026,
    String station = 'City Chowk',
    required DateTime updatedAt,
    Map<String, dynamic> extra = const {},
  }) =>
      {
        'uid': uid,
        'station': station,
        'fir_no': firNo,
        'year': year,
        'updated_at': updatedAt.toUtc().toIso8601String(),
        'data': {
          'fir_no': firNo,
          'year': year,
          'police_station': station,
          'crime_type': 'Theft',
          'section': '303',
          ...extra,
        },
      };

  test('imports central records this PC has never seen', () async {
    final res = await repo.importFromCentral([
      centralRow(uid: 'c_aaa', updatedAt: DateTime.now()),
      centralRow(uid: 'c_bbb', firNo: '78/2026', updatedAt: DateTime.now()),
    ]);

    expect(res.created, 2);
    expect(res.updated, 0);
    final list = await repo.watchCrimeList().first;
    expect(list.map((e) => e.crime.firNo), containsAll(['77/2026', '78/2026']));
  });

  test('re-importing the same records creates no duplicates', () async {
    final rows = [centralRow(uid: 'c_aaa', updatedAt: DateTime.now())];
    await repo.importFromCentral(rows);
    final second = await repo.importFromCentral(rows);

    expect(second.created, 0);
    expect((await repo.watchCrimeList().first).length, 1);
  });

  test('matches a legacy local record by FIR identity, not just uid', () async {
    // Pre-v8 rows were uploaded under their local id and old imports have no
    // uid at all — without identity matching the station would get a second
    // copy of every FIR it already had.
    final d = CrimeDraft(firNo: '77/2026', year: 2026);
    d.policeStation = 'City Chowk';
    await repo.saveDraft(d);

    final res = await repo.importFromCentral(
      [centralRow(uid: 'c_server', updatedAt: DateTime(2020))],
    );

    expect(res.created, 0);
    expect((await repo.watchCrimeList().first).length, 1);
  });

  test('a local edit that has not uploaded yet is never overwritten', () async {
    final d = CrimeDraft(firNo: '77/2026', year: 2026);
    d.policeStation = 'City Chowk';
    d.crimeType = 'Typed on this PC';
    final id = await repo.saveDraft(d);

    // Server copy is OLDER than the local row.
    await repo.importFromCentral(
      [centralRow(uid: 'c_srv', updatedAt: DateTime(2020))],
    );

    expect((await repo.loadDraft(id))!.crimeType, 'Typed on this PC');
  });

  test('a newer central copy updates the local record', () async {
    final d = CrimeDraft(firNo: '77/2026', year: 2026);
    d.policeStation = 'City Chowk';
    d.crimeType = 'Stale';
    final id = await repo.saveDraft(d);

    final res = await repo.importFromCentral([
      centralRow(
        uid: 'c_srv',
        updatedAt: DateTime.now().add(const Duration(days: 1)),
        extra: {'crime_type': 'Corrected at the zone office'},
      ),
    ]);

    expect(res.updated, 1);
    expect((await repo.loadDraft(id))!.crimeType, 'Corrected at the zone office');
  });

  test('an update keeps accused detail central does not carry', () async {
    // Central stores accused as bare names. Rewriting them wholesale would
    // strip the aadhaar/address an officer typed on the station PC.
    final d = CrimeDraft(firNo: '77/2026', year: 2026);
    d.policeStation = 'City Chowk';
    d.accused.add(AccusedDraft(name: 'Accused One', aadhaar: '999988887777'));
    final id = await repo.saveDraft(d);

    await repo.importFromCentral([
      centralRow(
        uid: 'c_srv',
        updatedAt: DateTime.now().add(const Duration(days: 1)),
        extra: {'accused_names': ['Accused One']},
      ),
    ]);

    final loaded = await repo.loadDraft(id);
    expect(loaded!.accused.single.aadhaar, '999988887777');
  });

  test('a downloaded record seeds accused names when this PC has none', () async {
    await repo.importFromCentral([
      centralRow(
        uid: 'c_new',
        updatedAt: DateTime.now(),
        extra: {'accused_names': ['Accused One', 'Accused Two']},
      ),
    ]);

    final id = (await repo.watchCrimeList().first).single.crime.id;
    expect((await repo.loadDraft(id))!.accused.map((a) => a.name),
        ['Accused One', 'Accused Two']);
  });

  test('the same FIR from two accounts imports once, newest wins', () async {
    // Central stores one row per uploading account (unique on owner_email +
    // remote_uid), so two accounts that synced the same station each hold a
    // copy. On the live server that is 504 FIRs. Both copies arrive in the
    // same download batch and must collapse to one local record.
    final res = await repo.importFromCentral([
      centralRow(
        uid: 'c_ownerA',
        updatedAt: DateTime(2026, 1, 1),
        extra: {'crime_type': 'Older copy'},
      ),
      centralRow(
        uid: 'c_ownerB',
        updatedAt: DateTime(2026, 6, 1),
        extra: {'crime_type': 'Newer copy'},
      ),
    ]);

    expect(res.created, 1, reason: 'second copy must not create a record');
    final list = await repo.watchCrimeList().first;
    expect(list.length, 1);
    expect((await repo.loadDraft(list.single.crime.id))!.crimeType,
        'Newer copy');
  });

  test('duplicate copies arriving newest-first keep the newest', () async {
    // Same as above but the older copy is second — it must not overwrite.
    await repo.importFromCentral([
      centralRow(
        uid: 'c_ownerB',
        updatedAt: DateTime(2026, 6, 1),
        extra: {'crime_type': 'Newer copy'},
      ),
      centralRow(
        uid: 'c_ownerA',
        updatedAt: DateTime(2026, 1, 1),
        extra: {'crime_type': 'Older copy'},
      ),
    ]);

    final list = await repo.watchCrimeList().first;
    expect(list.length, 1);
    expect((await repo.loadDraft(list.single.crime.id))!.crimeType,
        'Newer copy');
  });

  test('a downloaded record keeps the server time, not "now"', () async {
    // If an import stamped updatedAt = now(), the whole downloaded set would
    // look locally edited and the next sync would upload it all back under
    // this account -- central keys rows by (owner_email, remote_uid), so that
    // is a second copy of every FIR. Every station would duplicate its own
    // register on its first sync.
    final serverAt = DateTime.utc(2026, 3, 4, 5, 6, 7);
    final res = await repo.importFromCentral(
      [centralRow(uid: 'c_srv', updatedAt: serverAt)],
    );

    expect(res.uids, {'c_srv'}, reason: 'caller needs this to skip re-upload');
    final exported = await repo.exportForCentral(
      since: serverAt.add(const Duration(seconds: 1)),
    );
    expect(exported, isEmpty,
        reason: 'an untouched downloaded record is not pending upload');
  });

  test('rows with neither uid nor FIR number are ignored', () async {
    final res = await repo.importFromCentral([
      {'uid': '', 'fir_no': '', 'updated_at': '', 'data': const {}},
    ]);

    expect(res.created, 0);
    expect((await repo.watchCrimeList().first), isEmpty);
  });
}
