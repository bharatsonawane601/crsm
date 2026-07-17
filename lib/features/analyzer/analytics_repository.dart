import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/db/database_provider.dart';
import 'analytics_model.dart';

/// Assembles [AnalyticsRow]s from several tables. Re-emits whenever crimes
/// change. For station-scale data, batch-loading child tables in memory is
/// simpler and fast enough.
class AnalyticsRepository {
  AnalyticsRepository(this._db);

  final AppDatabase _db;

  Stream<List<AnalyticsRow>> watchRows() {
    return _db.select(_db.crimes).watch().asyncMap((crimes) async {
      final investigations = await _db.select(_db.investigation).get();
      final verdicts = await _db.select(_db.verdict).get();
      final accused = await _db.select(_db.accused).get();
      final recovered = await _db.select(_db.recoveredProperty).get();
      final stolen = await _db.select(_db.stolenProperty).get();

      final officerByCrime = <int, String?>{
        for (final i in investigations) i.crimeId: i.officerName,
      };
      final preventiveByCrime = <int, String?>{
        for (final i in investigations) i.crimeId: i.preventiveAction,
      };
      final preventiveDateByCrime = <int, DateTime?>{
        for (final i in investigations) i.crimeId: i.preventiveDate,
      };
      final chargesheetByCrime = <int, DateTime?>{
        for (final v in verdicts) v.crimeId: v.chargesheetDate,
      };

      final recoveredByCrime = <int, double>{};
      for (final r in recovered) {
        recoveredByCrime.update(
          r.crimeId,
          (v) => v + (r.value ?? 0),
          ifAbsent: () => r.value ?? 0,
        );
      }
      final stolenByCrime = <int, double>{};
      for (final s in stolen) {
        stolenByCrime.update(
          s.crimeId,
          (v) => v + (s.value ?? 0),
          ifAbsent: () => s.value ?? 0,
        );
      }

      final accusedCount = <int, int>{};
      final arrestedCount = <int, int>{};
      final wantedCount = <int, int>{};
      for (final a in accused) {
        accusedCount.update(a.crimeId, (v) => v + 1, ifAbsent: () => 1);
        switch (a.arrestStatus) {
          case 'arrested':
            arrestedCount.update(a.crimeId, (v) => v + 1, ifAbsent: () => 1);
          case 'wanted':
          case 'absconding':
            wantedCount.update(a.crimeId, (v) => v + 1, ifAbsent: () => 1);
        }
      }

      return [
        for (final c in crimes)
          AnalyticsRow(
            id: c.id,
            status: c.status,
            firNo: c.firNo,
            year: c.year,
            // Effective date for trend/KPI bucketing: prefer the registration
            // date, fall back to the offence date, then Jan 1 of the record's
            // year (imported records often carry only a year), and finally the
            // record's createdAt — so a 2025 record never lands under 2026.
            dateRegistered: c.dateRegistered ??
                c.dateOccurred ??
                (c.year > 1900 ? DateTime(c.year) : c.createdAt),
            section: c.section,
            crimeType: c.crimeType,
            officerName: officerByCrime[c.id],
            station: c.policeStation,
            courtType: c.courtType,
            caseStage: c.caseStage,
            chargesheetDate: chargesheetByCrime[c.id],
            recoveredValue: recoveredByCrime[c.id] ?? 0,
            accusedCount: accusedCount[c.id] ?? 0,
            arrestedCount: arrestedCount[c.id] ?? 0,
            wantedCount: wantedCount[c.id] ?? 0,
            preventiveAction: preventiveByCrime[c.id],
            preventiveDate: preventiveDateByCrime[c.id],
            dateOccurred: c.dateOccurred,
            timeOccurred: c.timeOccurred,
            stolenValue: stolenByCrime[c.id] ?? 0,
          ),
      ];
    });
  }
}

final analyticsRepositoryProvider = Provider<AnalyticsRepository>(
  (ref) => AnalyticsRepository(ref.watch(databaseProvider)),
);

final analyticsRowsProvider = StreamProvider<List<AnalyticsRow>>(
  (ref) => ref.watch(analyticsRepositoryProvider).watchRows(),
);
