import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../access/access_config.dart';
import '../access/station_scope.dart';
import '../auth/auth_service.dart';
import '../crime_entry/crime_repository.dart';
import '../settings/settings_repository.dart';
import 'central_client.dart';

enum UploadPhase { idle, uploading, done, failed, blocked }

class CentralUploadState {
  const CentralUploadState({
    this.phase = UploadPhase.idle,
    this.saved = 0,
    this.pendingServerDeletes = 0,
  });
  final UploadPhase phase;
  final int saved;

  /// How many LOCAL records the server's deletion list would remove — set when
  /// the mass-delete fuse trips ([UploadPhase.blocked]) so the UI can ask the
  /// user before anything is destroyed.
  final int pendingServerDeletes;
}

/// Keys shared with [BackupService]: a restore clears them so the next sync
/// re-sends everything instead of "nothing changed since the marker".
const kCentralLastUploadPref = 'central_last_upload_millis';
const kCentralLastSuppressedPref = 'central_last_suppressed_millis';

/// Watermark for the download half of sync: the `updated_at` of the newest
/// central record already applied locally. Server-issued (never this PC's
/// clock), so a station machine with a wrong date cannot skip records.
const kCentralLastDownloadPref = 'central_last_download_cursor';

/// Pushes this station's crime records to the central officer-portal store.
/// Runs quietly in the background for station (data-entry) users so senior
/// officers always see up-to-date data. No-op when the server isn't configured.
class CentralUploadController extends Notifier<CentralUploadState> {
  /// When the last fully-successful upload finished. Only records saved/edited
  /// after this are sent on the next sync (the server upsert keeps the rest).
  static const _lastUploadPrefKey = kCentralLastUploadPref;

  /// When the last suppressed-tombstone pull ran, so the frequent background
  /// poll only fetches NEW deletions instead of the whole (growing) list.
  static const _lastSuppressedPrefKey = kCentralLastSuppressedPref;

  /// How far the download half of sync has got (see [kCentralLastDownloadPref]).
  static const _lastDownloadPrefKey = kCentralLastDownloadPref;

  /// Mass-delete fuse: the most local records one sync may delete on the
  /// server's say-so without the user explicitly confirming. A server that was
  /// reset/wiped still carries delete-markers for every old record — obeying
  /// them blindly would erase a station's (possibly just-restored) data.
  static const massDeleteFuse = 25;

  /// Records per request. The Go server pipelines each chunk as one Postgres
  /// batch, so bigger chunks just mean fewer HTTP round trips; 1000 keeps a
  /// full 3000-record import to three requests while staying well inside the
  /// 180s timeout even on a slow uplink.
  static const _chunkSize = 1000;

  @override
  CentralUploadState build() => const CentralUploadState();

  Future<void> uploadNow({bool allowMassDelete = false}) async {
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
        final wouldDelete = await repo.countSuppressionMatches(suppressed);
        if (wouldDelete > massDeleteFuse && !allowMassDelete) {
          // Fuse tripped: the server wants a big chunk of this station's data
          // gone (typical after a server wipe while old delete-markers linger).
          // Keep everything, don't advance the marker, and let the UI ask.
          state = CentralUploadState(
              phase: UploadPhase.blocked, pendingServerDeletes: wouldDelete);
          return;
        }
        await repo.purgeLocalByUids(suppressed);
      }
      await prefs.setInt(_lastSuppressedPrefKey,
          suppressedPulledAt.millisecondsSinceEpoch);

      // 1b) Pull DOWN the FIRs this account is scoped to. Sync used to be
      // upload-only, so a newly issued station login opened an empty Crime
      // Records list — the records were on the server, not on their PC. The
      // server picks the scope from the account's assignment (one station, or
      // every station in a zone); the app never asks for a station by name.
      await _downloadScopedRecords(client, user.email, repo);

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
      var records = await repo.exportForCentral(since: since);
      // A user pinned to one police station uploads ONLY that station's
      // records, so a shared machine holding other stations' data can never
      // push it up under their account.
      final assigned = ref.read(assignedStationKeysProvider);
      if (assigned != null) {
        records = [
          for (final r in records)
            if (stationInScope(r['police_station'] as String?, assigned)) r,
        ];
      }
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

  /// Pages the account's scoped FIRs down from central into the local database.
  ///
  /// Resumes from a server-issued watermark so a repeat sync only carries what
  /// changed — the first sync on a new station PC pulls its whole station, later
  /// ones pull almost nothing. The watermark only advances on a page that fully
  /// applied: a failure mid-run leaves it where it was so the next sync retries
  /// rather than skipping records for good.
  Future<void> _downloadScopedRecords(
    CentralClient client,
    String email,
    CrimeRepository repo,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var cursor = prefs.getString(_lastDownloadPrefKey);
    var offset = 0;
    // Bounded so a bad cursor can never spin forever; 200 pages x 500 rows is
    // far more than a district holds.
    for (var page = 0; page < 200; page++) {
      final result =
          await client.download(email: email, cursor: cursor, offset: offset);
      if (result == null) return; // network/server failure — keep the watermark
      if (result.records.isNotEmpty) {
        await repo.importFromCentral(result.records);
      }
      if (result.cursor != null) {
        cursor = result.cursor;
        await prefs.setString(_lastDownloadPrefKey, cursor!);
        // The cursor now covers everything applied so far, so the next page
        // starts from the top of the remaining set.
        offset = 0;
      } else {
        // Empty page (or a server without cursors): step past it by offset so
        // paging still terminates.
        offset += result.records.length;
      }
      if (!result.more) return;
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
      if (suppressed.isEmpty) {
        await prefs.setInt(
            _lastSuppressedPrefKey, pulledAt.millisecondsSinceEpoch);
        return 0;
      }
      final repo = ref.read(crimeRepositoryProvider);
      final wouldDelete = await repo.countSuppressionMatches(suppressed);
      if (wouldDelete > massDeleteFuse) {
        // Same fuse as the manual sync, but never auto-applied here: the
        // background timer just flags it (the shell shows the confirm dialog)
        // and leaves the marker alone so nothing is lost while the user reads.
        state = CentralUploadState(
            phase: UploadPhase.blocked, pendingServerDeletes: wouldDelete);
        return 0;
      }
      await prefs.setInt(
          _lastSuppressedPrefKey, pulledAt.millisecondsSinceEpoch);
      return await repo.purgeLocalByUids(suppressed);
    } catch (_) {
      return 0;
    } finally {
      client.dispose();
    }
  }

  /// User chose "keep my data" on the mass-delete warning: go back to idle.
  /// The server's delete-markers stay untouched, so the question will come
  /// back on a future sync until the admin clears the markers server-side.
  void dismissBlocked() {
    if (state.phase == UploadPhase.blocked) {
      state = const CentralUploadState();
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
