import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crms/core/crypto/field_cipher.dart';
import 'package:crms/data/db/database.dart';
import 'package:crms/features/crime_entry/crime_repository.dart';
import 'package:crms/features/crime_entry/models/crime_draft.dart';

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

      final removed = await repo.purgeLocalByUids(['1', '2', '3']);
      expect(removed, 0);
      expect(await repo.loadDraft(id), isNotNull); // survived the sync
    });

    test('purge by the record\'s real remote uid removes it', () async {
      final id = await repo.saveDraft(CrimeDraft(firNo: 'DEL/2026', year: 2026));
      final uid = (await repo.loadDraft(id))!.remoteUid!;

      final removed = await repo.purgeLocalByUids([uid]);
      expect(removed, 1);
      expect(await repo.loadDraft(id), isNull);
    });

    test('legacy row (numeric remote_uid) is still purged by its id', () async {
      final id = await repo.saveDraft(CrimeDraft(firNo: 'OLD/2026', year: 2026));
      // Simulate a pre-v8 record whose uid is its numeric id.
      await (db.update(db.crimes)..where((t) => t.id.equals(id)))
          .write(CrimesCompanion(remoteUid: Value(id.toString())));

      final removed = await repo.purgeLocalByUids([id.toString()]);
      expect(removed, 1);
      expect(await repo.loadDraft(id), isNull);
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
}
