import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../../core/crypto/field_cipher.dart';
import '../../data/db/database.dart';

/// File-based Google Drive sync. The app writes an AES-encrypted copy of the
/// database into a user-chosen folder (typically a Google Drive for Desktop
/// folder). Google Drive Desktop then uploads it — including buffering while
/// offline — so the app stays fully offline-first and the cloud copy catches
/// up when a connection is available.
///
/// Layout in the sync folder:
///   crms-sync.crmsdb       — AES-encrypted SQLite database
///   crms-sync.meta.json    — { "savedAt": iso8601, "device": "..." }
class SyncService {
  SyncService(this._cipher);

  final FieldCipher _cipher;

  static const dbFileName = 'crms-sync.crmsdb';
  static const metaFileName = 'crms-sync.meta.json';
  static const _sqliteMagic = 'SQLite format 3\x00';

  File dbFileIn(String folder) => File(p.join(folder, dbFileName));
  File metaFileIn(String folder) => File(p.join(folder, metaFileName));

  /// Exports the open [db] and writes the encrypted copy + meta to [folder].
  Future<void> push(AppDatabase db, String folder, {String? device}) async {
    final dir = Directory(folder);
    if (!dir.existsSync()) await dir.create(recursive: true);

    final temp = File(p.join(folder, '.crms_export_tmp.sqlite'));
    if (temp.existsSync()) await temp.delete();
    await db.customStatement('VACUUM INTO ?', [temp.path]);
    final raw = await temp.readAsBytes();
    await temp.delete();

    final savedAt = DateTime.now().toUtc();
    await dbFileIn(folder).writeAsBytes(_cipher.encryptBytes(raw));
    await metaFileIn(folder).writeAsString(jsonEncode({
      'savedAt': savedAt.toIso8601String(),
      'device': device ?? '',
    }));
  }

  /// Reads the remote meta's savedAt, or null if there is no remote copy.
  Future<DateTime?> remoteSavedAt(String folder) async {
    final meta = metaFileIn(folder);
    if (!meta.existsSync() || !dbFileIn(folder).existsSync()) return null;
    try {
      final map = jsonDecode(await meta.readAsString()) as Map<String, dynamic>;
      return DateTime.tryParse(map['savedAt'] as String? ?? '');
    } catch (_) {
      return null;
    }
  }

  /// Decrypts the remote DB and writes it to [liveDbFile]. Returns false if
  /// there's no remote copy. Throws if the file can't be decrypted / verified.
  /// Call only when the database is NOT open (e.g. launch bootstrap).
  Future<bool> pull(String folder, File liveDbFile) async {
    final remote = dbFileIn(folder);
    if (!remote.existsSync()) return false;

    final decrypted = _cipher.decryptBytes(await remote.readAsBytes());
    final header =
        String.fromCharCodes(decrypted.take(_sqliteMagic.length).toList());
    if (header != _sqliteMagic) {
      throw const FormatException('Remote sync file is not a valid database');
    }
    await liveDbFile.parent.create(recursive: true);
    await liveDbFile.writeAsBytes(decrypted, flush: true);
    return true;
  }
}

/// shared_preferences keys for sync state (shared by controller + bootstrap).
class SyncPrefs {
  SyncPrefs._();
  static const folder = 'sync_folder';
  static const lastSyncedAtMillis = 'sync_last_at_millis';
  static const device = 'sync_device';
}

/// Decides whether the launch bootstrap should pull the remote copy:
/// only when the remote was saved after our last successful sync.
bool shouldPullOnLaunch({
  required DateTime? remoteSavedAt,
  required DateTime? lastSyncedAt,
}) {
  if (remoteSavedAt == null) return false;
  if (lastSyncedAt == null) return true;
  return remoteSavedAt.isAfter(lastSyncedAt);
}
