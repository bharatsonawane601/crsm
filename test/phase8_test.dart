import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crms/core/crypto/field_cipher.dart';
import 'package:crms/data/db/database.dart';
import 'package:crms/features/crime_entry/crime_repository.dart';
import 'package:crms/features/crime_entry/models/crime_draft.dart';
import 'package:crms/features/settings/settings_repository.dart';

void main() {
  final cipher = FieldCipher.fromBytes(List<int>.generate(32, (i) => i));

  group('SettingsRepository', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      SharedPreferences.setMockInitialValues(const {});
    });

    test('saves and loads station settings', () async {
      final repo = SettingsRepository();
      await repo.save(const AppSettings(
        stationNameMarathi: 'पुणे ठाणे',
        district: 'पुणे',
        code: 'PN01',
        defaultTemplateKey: 'asset:b_patrak',
      ));

      final loaded = await repo.load();
      expect(loaded.stationNameMarathi, 'पुणे ठाणे');
      expect(loaded.district, 'पुणे');
      expect(loaded.defaultTemplateKey, 'asset:b_patrak');
      expect(loaded.hasStation, isTrue);
      expect(loaded.stationMap['name_marathi'], 'पुणे ठाणे');
    });

    test('empty settings report no station and null default', () async {
      final loaded = await SettingsRepository().load();
      expect(loaded.hasStation, isFalse);
      expect(loaded.defaultTemplateKey, isNull);
    });
  });

  group('backup byte cipher', () {
    test('round-trips arbitrary bytes', () {
      final data = Uint8List.fromList(List<int>.generate(500, (i) => i % 256));
      final enc = cipher.encryptBytes(data);
      expect(enc, isNot(equals(data)));
      expect(cipher.decryptBytes(enc), equals(data));
    });
  });

  group('audit logging', () {
    late AppDatabase db;
    late CrimeRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = CrimeRepository(db, cipher);
    });
    tearDown(() => db.close());

    Future<List<String>> actions() async =>
        (await db.select(db.auditLog).get()).map((e) => e.action).toList();

    test('logs create, update and delete', () async {
      final id = await repo.saveDraft(CrimeDraft(firNo: '1', year: 2026));
      expect(await actions(), ['create']);

      final draft = await repo.loadDraft(id);
      await repo.saveDraft(draft!);
      expect(await actions(), ['create', 'update']);

      await repo.deleteCrime(id);
      expect(await actions(), containsAll(['create', 'update', 'delete']));
    });
  });
}
