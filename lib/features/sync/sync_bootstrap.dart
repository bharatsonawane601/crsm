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
    final pulled = await service.pull(folder, liveDb);
    if (pulled && remoteSavedAt != null) {
      await prefs.setInt(
          SyncPrefs.lastSyncedAtMillis, remoteSavedAt.millisecondsSinceEpoch);
    }
  } catch (_) {
    // Ignore — app continues with whatever local data it has.
  }
}
