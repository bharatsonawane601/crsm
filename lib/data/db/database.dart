import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/crime_tables.dart';
import 'tables/admin_tables.dart';
import 'tables/io_tables.dart';

part 'database.g.dart';

/// The app's single SQLite database (drift). All queries must go through
/// DAOs/this class — never raw SQL except migrations (PROJECT.md rule 5).
///
/// Encryption status:
///   - Sensitive FIELDS (Aadhaar, PAN) are encrypted via FieldCipher before
///     they are written here — see lib/core/crypto/field_cipher.dart. The key
///     is injected at build time (CRMS_FIELD_KEY, cipher_provider.dart).
///   - The DB copies that leave the machine ARE encrypted: Drive sync files
///     (sync_service.dart) and backups (backup_service.dart) are AES-GCM'd.
///   - TODO (dedicated task): whole-file encryption of the LIVE database.
///     The old sqlcipher_flutter_libs path is end-of-life; the current way is
///     sqlite3 3.x native assets built with SQLite3MultipleCiphers + PRAGMA
///     key (supported by drift >= 2.32). Needs per-platform build config and
///     a one-time plaintext->encrypted migration of existing user DBs, so it
///     must be done + tested as its own change, not slipped in.
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
    IoCases,
    IoParties,
    IoExhibits,
    IoForms,
    IoMedia,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_open());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 11;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
        },
        onUpgrade: (m, from, to) async {
          // v2: police station name carried per crime record.
          if (from < 2) {
            await _addColumnIfMissing(
                'crimes', 'police_station', () => m.addColumn(crimes, crimes.policeStation));
          }
          // v3: investigating officer designation (rank/post).
          if (from < 3) {
            await _addColumnIfMissing('investigation', 'officer_designation',
                () => m.addColumn(investigation, investigation.officerDesignation));
          }
          // v4: end time of the time-of-offence window (from–to).
          if (from < 4) {
            await _addColumnIfMissing('crimes', 'time_occurred_to',
                () => m.addColumn(crimes, crimes.timeOccurredTo));
          }
          // v5: court type (chargesheet deadline) + free-form age on people.
          if (from < 5) {
            await _addColumnIfMissing('crimes', 'court_type',
                () => m.addColumn(crimes, crimes.courtType));
            await _addColumnIfMissing('complainants', 'age_text',
                () => m.addColumn(complainants, complainants.ageText));
            await _addColumnIfMissing('accused', 'age_text',
                () => m.addColumn(accused, accused.ageText));
          }
          // v6: end date of the date-of-offence window (from–to).
          if (from < 6) {
            await _addColumnIfMissing('crimes', 'date_occurred_to',
                () => m.addColumn(crimes, crimes.dateOccurredTo));
          }
          // v7: case stage (investigation / chargesheet / both / court / ...).
          if (from < 7) {
            await _addColumnIfMissing('crimes', 'case_stage',
                () => m.addColumn(crimes, crimes.caseStage));
          }
          // v8: stable remote_uid for central sync. Backfill existing rows with
          // their numeric id (as text) so already-uploaded records keep the same
          // server identity; new records get a "c_<random>" uid going forward.
          if (from < 8) {
            await _addColumnIfMissing('crimes', 'remote_uid',
                () => m.addColumn(crimes, crimes.remoteUid));
            await customStatement(
                "UPDATE crimes SET remote_uid = CAST(id AS TEXT) "
                "WHERE remote_uid IS NULL OR remote_uid = ''");
          }
          // v9: extra NCRB IIF-1 FIR fields across crimes / complainants /
          // accused / investigation / stolen_property (all nullable).
          if (from < 9) {
            await _addColumnIfMissing('crimes', 'fir_date',
                () => m.addColumn(crimes, crimes.firDate));
            await _addColumnIfMissing('crimes', 'fir_time',
                () => m.addColumn(crimes, crimes.firTime));
            await _addColumnIfMissing('crimes', 'info_received_date',
                () => m.addColumn(crimes, crimes.infoReceivedDate));
            await _addColumnIfMissing('crimes', 'info_received_time',
                () => m.addColumn(crimes, crimes.infoReceivedTime));
            await _addColumnIfMissing('crimes', 'gd_date',
                () => m.addColumn(crimes, crimes.gdDate));
            await _addColumnIfMissing('crimes', 'gd_time',
                () => m.addColumn(crimes, crimes.gdTime));
            await _addColumnIfMissing('crimes', 'gd_entry_no',
                () => m.addColumn(crimes, crimes.gdEntryNo));
            await _addColumnIfMissing('crimes', 'occurrence_day',
                () => m.addColumn(crimes, crimes.occurrenceDay));
            await _addColumnIfMissing('crimes', 'type_of_information',
                () => m.addColumn(crimes, crimes.typeOfInformation));
            await _addColumnIfMissing('crimes', 'beat_no',
                () => m.addColumn(crimes, crimes.beatNo));
            await _addColumnIfMissing('crimes', 'direction_distance',
                () => m.addColumn(crimes, crimes.directionDistance));
            await _addColumnIfMissing('crimes', 'outside_ps_name',
                () => m.addColumn(crimes, crimes.outsidePsName));
            await _addColumnIfMissing('crimes', 'outside_ps_district',
                () => m.addColumn(crimes, crimes.outsidePsDistrict));
            await _addColumnIfMissing('crimes', 'delay_reason',
                () => m.addColumn(crimes, crimes.delayReason));
            await _addColumnIfMissing('crimes', 'inquest_ud_no',
                () => m.addColumn(crimes, crimes.inquestUdNo));

            await _addColumnIfMissing('complainants', 'father_husband_name',
                () => m.addColumn(complainants, complainants.fatherHusbandName));
            await _addColumnIfMissing('complainants', 'birth_year',
                () => m.addColumn(complainants, complainants.birthYear));
            await _addColumnIfMissing('complainants', 'nationality',
                () => m.addColumn(complainants, complainants.nationality));
            await _addColumnIfMissing('complainants', 'occupation',
                () => m.addColumn(complainants, complainants.occupation));
            await _addColumnIfMissing('complainants', 'permanent_address',
                () => m.addColumn(complainants, complainants.permanentAddress));
            await _addColumnIfMissing('complainants', 'id_type',
                () => m.addColumn(complainants, complainants.idType));
            await _addColumnIfMissing('complainants', 'id_number',
                () => m.addColumn(complainants, complainants.idNumber));

            await _addColumnIfMissing('accused', 'alias',
                () => m.addColumn(accused, accused.alias));
            await _addColumnIfMissing('accused', 'relative_name',
                () => m.addColumn(accused, accused.relativeName));
            await _addColumnIfMissing('accused', 'physical_json',
                () => m.addColumn(accused, accused.physicalJson));

            await _addColumnIfMissing('investigation', 'registering_officer_name',
                () => m.addColumn(investigation, investigation.registeringOfficerName));
            await _addColumnIfMissing('investigation', 'registering_officer_rank',
                () => m.addColumn(investigation, investigation.registeringOfficerRank));
            await _addColumnIfMissing('investigation', 'registering_officer_no',
                () => m.addColumn(investigation, investigation.registeringOfficerNo));
            await _addColumnIfMissing('investigation', 'action_taken',
                () => m.addColumn(investigation, investigation.actionTaken));
            await _addColumnIfMissing('investigation', 'court_dispatch_date',
                () => m.addColumn(investigation, investigation.courtDispatchDate));
            await _addColumnIfMissing('investigation', 'court_dispatch_time',
                () => m.addColumn(investigation, investigation.courtDispatchTime));

            await _addColumnIfMissing('stolen_property', 'category',
                () => m.addColumn(stolenProperty, stolenProperty.category));
          }
          // v10: Investigating-Officer (IO) portal tables. Created lazily here so
          // existing installs gain them without a full rebuild.
          if (from < 10) {
            await _createTableIfMissing('io_cases', () => m.createTable(ioCases));
            await _createTableIfMissing(
                'io_parties', () => m.createTable(ioParties));
            await _createTableIfMissing(
                'io_exhibits', () => m.createTable(ioExhibits));
            await _createTableIfMissing('io_forms', () => m.createTable(ioForms));
            await _createTableIfMissing('io_media', () => m.createTable(ioMedia));
          }
          // v11: case-level shared data blob for the IO forms auto-fill.
          if (from < 11) {
            await _addColumnIfMissing(
                'io_cases', 'data_json', () => m.addColumn(ioCases, ioCases.dataJson));
          }
        },
        beforeOpen: (details) async {
          // Enforce foreign keys (drift disables them by default in SQLite).
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Adds [column] to [table] only if it isn't already present. Makes upgrades
  /// idempotent so a half-applied migration (column added, but user_version not
  /// bumped — e.g. the app closed mid-migration, or the DB file is in a synced
  /// folder like OneDrive) can't crash the next launch with "duplicate column".
  Future<void> _addColumnIfMissing(
      String table, String column, Future<void> Function() add) async {
    final info = await customSelect('PRAGMA table_info($table)').get();
    final exists = info.any((row) => row.data['name'] == column);
    if (!exists) await add();
  }

  /// Creates [table] only if it isn't already present — keeps table-adding
  /// upgrades idempotent for the same half-applied / synced-folder reasons as
  /// [_addColumnIfMissing].
  Future<void> _createTableIfMissing(
      String table, Future<void> Function() create) async {
    final rows = await customSelect(
      "SELECT name FROM sqlite_master WHERE type='table' AND name=?",
      variables: [Variable<String>(table)],
    ).get();
    if (rows.isEmpty) await create();
  }

  static QueryExecutor _open() => driftDatabase(name: 'crms');
}
