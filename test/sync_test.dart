import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crms/core/crypto/field_cipher.dart';
import 'package:crms/data/db/database.dart';
import 'package:crms/features/crime_entry/crime_repository.dart';
import 'package:crms/features/crime_entry/models/crime_draft.dart';
import 'package:crms/features/sync/sync_service.dart';

void main() {
  final cipher = FieldCipher.fromBytes(List<int>.generate(32, (i) => i));
  final service = SyncService(cipher);

  group('shouldPullOnLaunch', () {
    final t0 = DateTime(2026, 1, 1);
    final t1 = DateTime(2026, 1, 2);

    test('no remote -> never pull', () {
      expect(
          shouldPullOnLaunch(remoteSavedAt: null, lastSyncedAt: t0), isFalse);
    });
    test('remote but never synced -> pull', () {
      expect(
          shouldPullOnLaunch(remoteSavedAt: t0, lastSyncedAt: null), isTrue);
    });
    test('remote newer than last sync -> pull', () {
      expect(shouldPullOnLaunch(remoteSavedAt: t1, lastSyncedAt: t0), isTrue);
    });
    test('remote not newer -> skip', () {
      expect(shouldPullOnLaunch(remoteSavedAt: t0, lastSyncedAt: t1), isFalse);
    });
  });

  test('push then pull round-trips the database', () async {
    final folder = await Directory.systemTemp.createTemp('crms_sync_test');
    addTearDown(() => folder.delete(recursive: true));

    // Source DB with one crime.
    final src = AppDatabase.forTesting(NativeDatabase.memory());
    final repo = CrimeRepository(src, cipher);
    await repo.saveDraft(CrimeDraft(firNo: 'SYNC-1', year: 2026));

    // Push to the (encrypted) sync folder.
    await service.push(src, folder.path, device: 'test');
    await src.close();

    expect(service.dbFileIn(folder.path).existsSync(), isTrue);
    expect(await service.remoteSavedAt(folder.path), isNotNull);

    // The encrypted blob must not contain plaintext SQLite header.
    final encrypted = await service.dbFileIn(folder.path).readAsBytes();
    expect(String.fromCharCodes(encrypted.take(16).toList()),
        isNot(contains('SQLite format 3')));

    // Pull into a fresh file and verify the crime survived.
    final pulledFile = File('${folder.path}/pulled.sqlite');
    final pulled = await service.pull(folder.path, pulledFile);
    expect(pulled, isTrue);

    final restored = AppDatabase.forTesting(NativeDatabase(pulledFile));
    final crimes = await restored.select(restored.crimes).get();
    expect(crimes.single.firNo, 'SYNC-1');
    await restored.close();
  });

  test('pull returns false when the folder has no remote copy', () async {
    final folder = await Directory.systemTemp.createTemp('crms_sync_empty');
    addTearDown(() => folder.delete(recursive: true));
    final pulled =
        await service.pull(folder.path, File('${folder.path}/x.sqlite'));
    expect(pulled, isFalse);
  });
}
