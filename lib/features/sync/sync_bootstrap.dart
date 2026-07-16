import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/crypto/cipher_provider.dart';
import 'sync_service.dart';

/// Called from main() BEFORE the database is opened. If the configured Drive
/// folder holds a copy newer than our last sync (e.g. edited on another
/// machine), pull it down and overwrite the local DB. Safe here because the
/// database isn't open yet. Never throws — sync problems must not block launch.
Future<void> pullOnLaunch() async {
  try {
    final prefs = await SharedPreferences.getInstance();
    final folder = prefs.getString(SyncPrefs.folder);
    if (folder == null) return;

    final lastMillis = prefs.getInt(SyncPrefs.lastSyncedAtMillis);
    final lastSyncedAt = lastMillis == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(lastMillis);

    final service = SyncService(defaultFieldCipher());
    final remoteSavedAt = await service.remoteSavedAt(folder);
    if (!shouldPullOnLaunch(
      remoteSavedAt: remoteSavedAt,
      lastSyncedAt: lastSyncedAt,
    )) {
      return;
    }

    final docs = await getApplicationDocumentsDirectory();
    final liveDb = File(p.join(docs.path, 'crms.sqlite'));
    // Safety net: the pull is last-write-wins, so if this machine also has
    // unsynced local edits they would be silently overwritten. Keep a local
    // copy of the current DB first so nothing is ever unrecoverable.
    await _backupBeforeOverwrite(liveDb, docs.path);
    final pulled = await service.pull(folder, liveDb);
    if (pulled && remoteSavedAt != null) {
      await prefs.setInt(
          SyncPrefs.lastSyncedAtMillis, remoteSavedAt.millisecondsSinceEpoch);
    }
  } catch (_) {
    // Ignore — app continues with whatever local data it has.
  }
}

/// Copies [liveDb] into `docs/sync_backups/pre-pull-<stamp>.sqlite` and prunes
/// old copies so at most the newest five are kept. Never throws.
Future<void> _backupBeforeOverwrite(File liveDb, String docsPath) async {
  try {
    if (!liveDb.existsSync()) return;
    final dir = Directory(p.join(docsPath, 'sync_backups'));
    await dir.create(recursive: true);
    final stamp = DateTime.now()
        .toIso8601String()
        .replaceAll(RegExp(r'[:.]'), '-')
        .substring(0, 19);
    await liveDb.copy(p.join(dir.path, 'pre-pull-$stamp.sqlite'));

    final backups = dir
        .listSync()
        .whereType<File>()
        .where((f) => p.basename(f.path).startsWith('pre-pull-'))
        .toList()
      ..sort((a, b) => b.path.compareTo(a.path)); // newest first (ISO stamps)
    for (final old in backups.skip(5)) {
      try {
        await old.delete();
      } catch (_) {/* best effort */}
    }
  } catch (_) {
    // Best effort — a failed backup must not block the pull/launch.
  }
}
