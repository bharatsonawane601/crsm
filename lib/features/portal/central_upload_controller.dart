import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      // 1) Pull down server-side deletions first: if the admin removed any of
      // this device's FIRs, delete the local copies too so they don't reappear
      // (or get re-uploaded) after a restart.
      final suppressed = await client.fetchSuppressed(email: user.email);
      if (suppressed.isNotEmpty) {
        await ref.read(crimeRepositoryProvider).purgeLocalByUids(suppressed);
      }

      // 2) Upload whatever local records remain.
      final records = await ref.read(crimeRepositoryProvider).exportForCentral();
      if (records.isEmpty) {
        state = const CentralUploadState(phase: UploadPhase.done, saved: 0);
        return;
      }
      final settings = await ref.read(settingsProvider.future);
      final saved = await client.upload(
        email: user.email,
        records: records,
        defaultStation: settings.stationNameEnglish,
      );
      state = saved == null
          ? const CentralUploadState(phase: UploadPhase.failed)
          : CentralUploadState(phase: UploadPhase.done, saved: saved);
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
      final suppressed = await client.fetchSuppressed(email: user.email);
      if (suppressed.isEmpty) return 0;
      return await ref.read(crimeRepositoryProvider).purgeLocalByUids(suppressed);
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
        CentralUploadController.new);
