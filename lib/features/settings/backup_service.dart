import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/crypto/cipher_provider.dart';
import '../../core/crypto/field_cipher.dart';
import '../../data/db/database.dart';
import '../../data/db/database_provider.dart';
import '../crime_entry/crime_repository.dart';
import '../crime_entry/models/crime_draft.dart';
import '../portal/central_upload_controller.dart';

/// What to do with a FIR in the backup that already exists locally.
enum RestoreConflictMode { replace, keepBoth }

/// The result of reading a backup before merging it in: every FIR it holds,
/// plus how many of them collide with existing local records.
class RestorePreview {
  RestorePreview({required this.drafts, required this.conflictCount});
  final List<CrimeDraft> drafts;
  final int conflictCount;
  int get total => drafts.length;
}

/// Encrypted backup & restore of the local SQLite database.
///
/// Backup uses `VACUUM INTO` to make a consistent copy while the DB is open,
/// then AES-encrypts it. Restore now MERGES: existing local FIRs are kept, the
/// backup's FIRs are added on top, and any FIR that already exists is handled
/// per [RestoreConflictMode] (replace it, or keep both copies). Nothing is
/// wiped, and no restart is needed.
class BackupService {
  BackupService(this._db, this._cipher);

  final AppDatabase _db;
  final FieldCipher _cipher;

  static const _liveDbName = 'crms.sqlite';
  static const _stagingName = 'crms.restore.sqlite';
  // Separate from _stagingName on purpose: a leftover _stagingName would be
  // picked up by [applyPendingRestore] and overwrite the live DB. This temp is
  // only ever read from and deleted right after.
  static const _readTempName = 'crms.restore_read.sqlite';

  /// SQLite file header — used to verify a restore file before reading it.
  static const _sqliteMagic = 'SQLite format 3\x00';

  /// Writes an encrypted backup into [destinationDir]; returns the file path.
  /// [prefix] distinguishes manual backups from automatic ones so the auto
  /// pruning never touches a manually made file.
  Future<String> backup(String destinationDir,
      {String prefix = 'crms-backup-'}) async {
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
    final dest = File(p.join(destinationDir, '$prefix$stamp.crmsbak'));
    await dest.writeAsBytes(encrypted);
    return dest.path;
  }

  // --- Automatic daily backup ----------------------------------------------

  static const _kFolder = 'backup_folder';
  static const _kAutoLastMillis = 'auto_backup_last_millis';
  static const _autoPrefix = 'crms-auto-';
  static const _autoKeep = 7;

  /// Remembers [dir] as the preferred backup destination (called after a
  /// successful manual backup) so the daily auto backup can reuse it.
  static Future<void> rememberFolder(String dir) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kFolder, dir);
  }

  /// Daily automatic backup (PROJECT.md module 7). Called once on app start
  /// (after the DB is open): if the last auto backup is older than [every],
  /// writes an encrypted backup to the remembered folder — falling back to a
  /// local `auto_backups` folder when none is set — and keeps only the newest
  /// [_autoKeep] auto files. Never throws; a failed backup must not block use.
  Future<void> autoBackupIfDue(
      {Duration every = const Duration(hours: 24)}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final last = prefs.getInt(_kAutoLastMillis);
      final now = DateTime.now().millisecondsSinceEpoch;
      if (last != null && now - last < every.inMilliseconds) return;

      var folder = prefs.getString(_kFolder);
      if (folder == null || !Directory(folder).existsSync()) {
        final docs = await getApplicationDocumentsDirectory();
        folder = p.join(docs.path, 'auto_backups');
        await Directory(folder).create(recursive: true);
      }

      await backup(folder, prefix: _autoPrefix);
      await prefs.setInt(_kAutoLastMillis, now);

      // Prune old AUTO backups only (ISO stamps sort newest-first by name).
      final autos = Directory(folder)
          .listSync()
          .whereType<File>()
          .where((f) => p.basename(f.path).startsWith(_autoPrefix))
          .toList()
        ..sort((a, b) => b.path.compareTo(a.path));
      for (final old in autos.skip(_autoKeep)) {
        try {
          await old.delete();
        } catch (_) {/* best effort */}
      }
    } catch (_) {
      // Best effort by design.
    }
  }

  /// Decrypts [backupPath], reads every FIR it contains into memory, and counts
  /// how many already exist locally (same FIR no. + year). The live database is
  /// NOT changed here — call [applyRestore] to merge. Throws if the file can't
  /// be decrypted or isn't a CRMS backup.
  Future<RestorePreview> previewRestore(String backupPath) async {
    final encrypted = await File(backupPath).readAsBytes();
    final decrypted = _cipher.decryptBytes(encrypted);

    final header =
        String.fromCharCodes(decrypted.take(_sqliteMagic.length).toList());
    if (header != _sqliteMagic) {
      throw const FormatException('Not a valid CRMS backup');
    }

    // Open the backup as a temporary second database and read all FIRs out of
    // it (drift migrates it to the current schema on open). We keep the drafts
    // in memory, then close + delete the temp copy.
    final docs = await getApplicationDocumentsDirectory();
    final tempFile = File(p.join(docs.path, _readTempName));
    await tempFile.writeAsBytes(decrypted);

    final drafts = <CrimeDraft>[];
    final backupDb = AppDatabase.forTesting(NativeDatabase(tempFile));
    try {
      final backupRepo = CrimeRepository(backupDb, _cipher);
      final rows = await backupDb.select(backupDb.crimes).get();
      for (final r in rows) {
        final d = await backupRepo.loadDraft(r.id);
        if (d != null) drafts.add(d);
      }
    } finally {
      await backupDb.close();
      if (tempFile.existsSync()) await tempFile.delete();
    }

    final live = await _db.select(_db.crimes).get();
    var conflicts = 0;
    for (final d in drafts) {
      if (_findLiveId(live, d.firNo, d.year) != null) conflicts++;
    }
    return RestorePreview(drafts: drafts, conflictCount: conflicts);
  }

  /// Merges the previewed backup into the live database, keeping all existing
  /// local data. Each backup FIR is added as a new record; when a FIR already
  /// exists, [mode] decides whether to replace the local one or keep both.
  /// Returns how many records were added.
  Future<int> applyRestore(
      RestorePreview preview, RestoreConflictMode mode) async {
    final repo = CrimeRepository(_db, _cipher);
    final live = await _db.select(_db.crimes).get();
    var added = 0;
    for (final d in preview.drafts) {
      try {
        if (mode == RestoreConflictMode.replace) {
          final existingId = _findLiveId(live, d.firNo, d.year);
          if (existingId != null) {
            await (_db.delete(_db.crimes)
                  ..where((t) => t.id.equals(existingId)))
                .go();
          }
        }
        d.id = null; // always insert as a fresh local record
        await repo.saveDraft(d);
        added++;
      } catch (_) {
        // Skip any record that can't be merged (e.g. dangling custom-field ref).
      }
    }
    await _resetCentralSyncMarkers();
    return added;
  }

  /// After any restore, the central-sync markers lie: the restored records are
  /// older than the "last upload" marker (so they'd never re-upload) and the
  /// delete-marker pull would be incremental (so old tombstones wouldn't be
  /// re-checked through the mass-delete fuse). Clearing both forces the next
  /// sync to start from scratch.
  static Future<void> _resetCentralSyncMarkers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(kCentralLastUploadPref);
    await prefs.remove(kCentralLastSuppressedPref);
  }

  /// Finds the local crime id matching [firNo] (+ [year] when set), or null.
  int? _findLiveId(List<dynamic> live, String firNo, int? year) {
    final fir = firNo.trim();
    if (fir.isEmpty) return null;
    for (final c in live) {
      if ((c.firNo as String).trim() == fir &&
          (year == null || c.year == year)) {
        return c.id as int;
      }
    }
    return null;
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
    await _resetCentralSyncMarkers();
    return true;
  }
}

final backupServiceProvider = Provider<BackupService>(
  (ref) => BackupService(
    ref.watch(databaseProvider),
    ref.watch(cipherProvider),
  ),
);
