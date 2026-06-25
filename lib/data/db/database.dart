import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/crime_tables.dart';
import 'tables/admin_tables.dart';

part 'database.g.dart';

/// The app's single SQLite database (drift). All queries must go through
/// DAOs/this class — never raw SQL except migrations (PROJECT.md rule 5).
///
/// Encryption status (Phase 1):
///   - Sensitive FIELDS (Aadhaar, PAN) are encrypted via FieldCipher before
///     they are written here — see lib/core/crypto/field_cipher.dart.
///   - TODO (Phase 1 hardening): enable whole-file SQLCipher encryption
///     (PRAGMA key via sqlcipher_flutter_libs) and/or AES-encrypt the DB file
///     before it is uploaded to the user's Google Drive (sync model).
@DriftDatabase(
  tables: [
    Crimes,
    Complainants,
    Accused,
    StolenProperty,
    RecoveredProperty,
    Investigation,
    Verdict,
    Attachments,
    CustomFields,
    CustomFieldValues,
    Stations,
    Users,
    ReportTemplates,
    AuditLog,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // v2: police station name carried per crime record.
          if (from < 2) {
            await m.addColumn(crimes, crimes.policeStation);
          }
        },
        beforeOpen: (details) async {
          // Enforce foreign keys (drift disables them by default in SQLite).
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  static QueryExecutor _open() => driftDatabase(name: 'crms');
}
