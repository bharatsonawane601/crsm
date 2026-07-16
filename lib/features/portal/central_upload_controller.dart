import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../access/access_config.dart';
import '../auth/auth_service.dart';
import '../crime_entry/crime_repository.dart';
import '../settings/settings_repository.dart';
import 'central_client.dart';

enum UploadPhase { idle, uploading, done, failed }

class CentralUploadState {
  const CentralUploadState({this.phase = UploadPhase.idle, this.saved = 0});
  final UploadPhase phase;
  final int saved;
}

/// Pushes this station's crime records to the central officer-portal store.
/// Runs quietly in the background for station (data-entry) users so senior
/// officers always see up-to-date data. No-op when the server isn't configured.
class CentralUploadController extends Notifier<CentralUploadState> {
  /// When the last fully-successful upload finished. Only records saved/edited
  /// after this are sent on the next sync (the server upsert keeps the rest).
  static const _lastUploadPrefKey = 'central_last_upload_millis';

  /// When the last suppressed-tombstone pull ran, so the frequent background
  /// poll only fetches NEW deletions instead of the whole (growing) list.
  static const _lastSuppressedPrefKey = 'central_last_suppressed_millis';

  /// Records per request. The Go server pipelines each chunk as one Postgres
  /// batch, so bigger chunks just mean fewer HTTP round trips; 1000 keeps a
  /// full 3000-record import to three requests while staying well inside the
  /// 180s timeout even on a slow uplink.
  static const _chunkSize = 1000;

  @override
  CentralUploadState build() => const CentralUploadState();

  Future<void> uploadNow() async {
    if (!AccessConfig.isConfigured) return;
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;
    if (state.phase == UploadPhase.uploading) return;

    state = const CentralUploadState(phase: UploadPhase.uploading);
    final client = CentralClient();
    try {
      final repo = ref.read(crimeRepositoryProvider);

      // 1) Pull down server-side deletions first: if the admin removed any of
      // this device's FIRs, delete the local copies too so they don't reappear
      // (or get re-uploaded) after a restart. The manual/launch sync always
      // pulls the FULL list (correctness anchor for the incremental poll).
      final prefs = await SharedPreferences.getInstance();
      final suppressedPulledAt = DateTime.now();
      final suppressed = await client.fetchSuppressed(email: user.email);
      if (suppressed.isNotEmpty) {
        await repo.purgeLocalByUids(suppressed);
      }
      await prefs.setInt(_lastSuppressedPrefKey,
          suppressedPulledAt.millisecondsSinceEpoch);

      // 2) One station = one spelling: fold Marathi/variant station names into
      // the canonical one before export, so the portal never shows the same
      // station twice. Touched rows get a fresh updatedAt and re-upload below.
      await repo.canonicalizeStationNames();

      // 3) Upload only what changed since the last successful sync (full
      // upload the first time). [startedAt] is stamped before the export so a
      // record saved mid-sync is re-sent next time — the upsert makes that safe.
      final lastMillis = prefs.getInt(_lastUploadPrefKey);
      final since = lastMillis == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(lastMillis);
      final startedAt = DateTime.now();
      final records = await repo.exportForCentral(since: since);
      if (records.isEmpty) {
        state = const CentralUploadState(phase: UploadPhase.done, saved: 0);
        return;
      }
      final settings = await ref.read(settingsProvider.future);

      var savedTotal = 0;
      for (var i = 0; i < records.length; i += _chunkSize) {
        final chunk = records.sublist(i, min(i + _chunkSize, records.length));
        final saved = await client.upload(
          email: user.email,
          records: chunk,
          defaultStation: settings.stationNameEnglish,
        );
        if (saved == null) {
          // Don't advance the marker — the failed remainder is retried in
          // full on the next sync.
          state = const CentralUploadState(phase: UploadPhase.failed);
          return;
        }
        savedTotal += saved;
      }
      await prefs.setInt(_lastUploadPrefKey, startedAt.millisecondsSinceEpoch);
      state = CentralUploadState(phase: UploadPhase.done, saved: savedTotal);
    } catch (_) {
      state = const CentralUploadState(phase: UploadPhase.failed);
    } finally {
      client.dispose();
    }
  }

  /// Lightweight: pulls down only the server-side deletions and removes the
  /// matching local FIRs — no upload. Safe to call frequently (e.g. on a timer)
  /// so an admin deletion is reflected on this device within a minute or two.
  /// Returns how many local FIRs were removed.
  Future<int> pullServerDeletions() async {
    if (!AccessConfig.isConfigured) return 0;
    final user = ref.read(authControllerProvider).value;
    if (user == null) return 0;
    final client = CentralClient();
    try {
      // Incremental: only tombstones newer than the last pull (with a 10-min
      // overlap for clock skew). The launch/manual sync still does the full
      // pull, so a missed tombstone is corrected there at the latest.
      final prefs = await SharedPreferences.getInstance();
      final lastMillis = prefs.getInt(_lastSuppressedPrefKey);
      final since = lastMillis == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(lastMillis)
              .subtract(const Duration(minutes: 10));
      final pulledAt = DateTime.now();
      final suppressed =
          await client.fetchSuppressed(email: user.email, since: since);
      await prefs.setInt(
          _lastSuppressedPrefKey, pulledAt.millisecondsSinceEpoch);
      if (suppressed.isEmpty) return 0;
      return await ref
          .read(crimeRepositoryProvider)
          .purgeLocalByUids(suppressed);
    } catch (_) {
      return 0;
    } finally {
      client.dispose();
    }
  }

  /// Tells the central store a FIR was deleted on this station so the central
  /// copy is removed and the deletion is logged for the admin. Fire-and-forget:
  /// never throws and never blocks the UI (a failed report is retried implicitly
  /// because the next full upload won't re-create a locally-deleted record).
  Future<void> reportDeletion(DeletedCrime deleted) async {
    if (!AccessConfig.isConfigured) return;
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;
    final client = CentralClient();
    try {
      String? station = deleted.policeStation;
      if (station == null || station.isEmpty) {
        final settings = await ref.read(settingsProvider.future);
        station = settings.stationNameEnglish;
      }
      await client.reportDeletion(
        email: user.email,
        uid: deleted.uid,
        firNo: deleted.firNo,
        year: deleted.year,
        policeStation: station,
      );
    } catch (_) {
      // Best-effort; ignore failures.
    } finally {
      client.dispose();
    }
  }
}

final centralUploadControllerProvider =
    NotifierProvider<CentralUploadController, CentralUploadState>(
      CentralUploadController.new,
    );
