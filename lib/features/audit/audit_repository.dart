import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/db/database_provider.dart';

/// Read access to the audit trail. Entries are written by CrimeRepository.
class AuditRepository {
  AuditRepository(this._db);

  final AppDatabase _db;

  Stream<List<AuditLogData>> watchRecent({int limit = 200}) {
    return (_db.select(_db.auditLog)
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .watch();
  }
}

final auditRepositoryProvider =
    Provider<AuditRepository>((ref) => AuditRepository(ref.watch(databaseProvider)));

final auditLogProvider = StreamProvider<List<AuditLogData>>(
  (ref) => ref.watch(auditRepositoryProvider).watchRecent(),
);
