import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../core/crypto/cipher_provider.dart';
import '../../core/crypto/field_cipher.dart';
import '../../data/db/database.dart';
import '../../data/db/database_provider.dart';

/// Encrypted backup & restore of the local SQLite database.
///
/// Backup uses `VACUUM INTO` to make a consistent copy while the DB is open,
/// then AES-encrypts it. Restore is staged to a side file and applied on the
/// next launch (see [applyPendingRestore]) so we never overwrite a DB file
/// that's currently open (which Windows locks).
class BackupService {
  BackupService(this._db, this._cipher);

  final AppDatabase _db;
  final FieldCipher _cipher;

  static const _liveDbName = 'crms.sqlite';
  static const _stagingName = 'crms.restore.sqlite';

  /// SQLite file header — used to verify a restore file before staging it.
  static const _sqliteMagic = 'SQLite format 3\x00';

  /// Writes an encrypted backup into [destinationDir]; returns the file path.
  Future<String> backup(String destinationDir) async {
    final docs = await getApplicationDocumentsDirectory();
    final temp = File(p.join(docs.path, 'crms_backup_tmp.sqlite'));
    if (temp.existsSync()) await temp.delete();

    await _db.customStatement('VACUUM INTO ?', [temp.path]);
    final raw = await temp.readAsBytes();
    await temp.delete();

    final encrypted = _cipher.encryptBytes(raw);
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(RegExp(r'[:.]'), '-')
        .substring(0, 19);
    final dest = File(p.join(destinationDir, 'crms-backup-$stamp.crmsbak'));
    await dest.writeAsBytes(encrypted);
    return dest.path;
  }

  /// Decrypts [backupPath] and stages it for restore on next launch.
  /// Throws if the file can't be decrypted or isn't a SQLite database.
  Future<void> stageRestore(String backupPath) async {
    final encrypted = await File(backupPath).readAsBytes();
    final decrypted = _cipher.decryptBytes(encrypted);

    final header = String.fromCharCodes(
        decrypted.take(_sqliteMagic.length).toList());
    if (header != _sqliteMagic) {
      throw const FormatException('Not a valid CRMS backup');
    }

    final docs = await getApplicationDocumentsDirectory();
    await File(p.join(docs.path, _stagingName)).writeAsBytes(decrypted);
  }

  /// If a staged restore exists, replace the live DB with it. Call this in
  /// main() BEFORE the database is opened. Returns true if a restore was applied.
  static Future<bool> applyPendingRestore() async {
    final docs = await getApplicationDocumentsDirectory();
    final staging = File(p.join(docs.path, _stagingName));
    if (!staging.existsSync()) return false;
    final live = File(p.join(docs.path, _liveDbName));
    await staging.copy(live.path);
    await staging.delete();
    return true;
  }
}

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    ref.watch(databaseProvider),
    ref.watch(cipherProvider),
  ),
);
