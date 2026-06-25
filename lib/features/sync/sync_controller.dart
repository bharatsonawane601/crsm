import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/crypto/cipher_provider.dart';
import '../../data/db/database.dart';
import '../../data/db/database_provider.dart';
import 'sync_service.dart';

enum SyncStatus { notConfigured, synced, pending, syncing, error }

/// Drives offline-first folder sync: watches the local DB for changes and
/// pushes an encrypted copy to the configured Google Drive folder (debounced).
/// The actual cloud upload is handled by Google Drive for Desktop.
class SyncController extends ChangeNotifier {
  SyncController(this._db, this._service);

  final AppDatabase _db;
  final SyncService _service;

  String? _folder;
  DateTime? _lastSyncedAt;
  String _device = '';
  SyncStatus _status = SyncStatus.notConfigured;

  StreamSubscription<void>? _dbSub;
  Timer? _debounce;
  bool _sawFirst = false;

  String? get folder => _folder;
  DateTime? get lastSyncedAt => _lastSyncedAt;
  SyncStatus get status => _status;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _folder = prefs.getString(SyncPrefs.folder);
    final millis = prefs.getInt(SyncPrefs.lastSyncedAtMillis);
    _lastSyncedAt =
        millis == null ? null : DateTime.fromMillisecondsSinceEpoch(millis);
    _device = prefs.getString(SyncPrefs.device) ?? '';
    if (_device.isEmpty) {
      final rnd = Random();
      _device = '${DateTime.now().millisecondsSinceEpoch.toRadixString(16)}'
          '-${rnd.nextInt(1 << 32).toRadixString(16)}';
      await prefs.setString(SyncPrefs.device, _device);
    }
    _status = _folder == null ? SyncStatus.notConfigured : SyncStatus.synced;

    // Auto-push when local data changes (skip the initial emission).
    _dbSub = _db.select(_db.crimes).watch().listen((_) {
      if (!_sawFirst) {
        _sawFirst = true;
        return;
      }
      _markPendingAndSchedule();
    });
    notifyListeners();
  }

  Future<void> setFolder(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(SyncPrefs.folder, path);
    _folder = path;
    notifyListeners();
    await syncNow();
  }

  void _markPendingAndSchedule() {
    if (_folder == null) return;
    _status = SyncStatus.pending;
    notifyListeners();
    _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), syncNow);
  }

  /// Push the current DB to the sync folder now.
  Future<void> syncNow() async {
    final folder = _folder;
    if (folder == null) {
      _status = SyncStatus.notConfigured;
      notifyListeners();
      return;
    }
    _debounce?.cancel();
    _status = SyncStatus.syncing;
    notifyListeners();
    try {
      await _service.push(_db, folder, device: _device);
      _lastSyncedAt = DateTime.now().toUtc();
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(
          SyncPrefs.lastSyncedAtMillis, _lastSyncedAt!.millisecondsSinceEpoch);
      _status = SyncStatus.synced;
    } catch (_) {
      _status = SyncStatus.error;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _dbSub?.cancel();
    super.dispose();
  }
}

final syncControllerProvider = Provider<SyncController>((ref) {
  final controller = SyncController(
    ref.watch(databaseProvider),
    SyncService(ref.watch(cipherProvider)),
  );
  controller.init();
  ref.onDispose(controller.dispose);
  return controller;
});
