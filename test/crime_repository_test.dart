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
