import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/crypto/cipher_provider.dart';
import '../../core/crypto/field_cipher.dart';
import '../../data/db/database.dart';
import '../../data/db/database_provider.dart';
import '../crime_list/models/crime_list_item.dart';
import 'models/crime_draft.dart';

/// Persists a [CrimeDraft] to the drift DB and reads it back. This is the only
/// place the crime-entry feature touches the ORM (PROJECT.md rule 5). Aadhaar
/// and PAN are encrypted here before they ever hit the database.
class CrimeRepository {
  CrimeRepository(this._db, this._cipher);

  final AppDatabase _db;
  final FieldCipher _cipher;

  /// Insert (new) or update (existing) a crime and all its child rows in one
  /// transaction. Returns the crime id. For edits, child rows are replaced
  /// wholesale (simpler and correct for this form-driven model).
  Future<int> saveDraft(CrimeDraft d) {
    final wasNew = d.isNew;
    return _db.transaction(() async {
      final crimeId = await _upsertCrime(d);
      await _deleteChildren(crimeId);
      await _insertChildren(crimeId, d);
      await _audit(wasNew ? 'create' : 'update', crimeId,
          'FIR ${d.firNo}/${d.year ?? ''}');
      return crimeId;
    });
  }

  /// Writes an audit-log entry. userId is null until real auth is wired.
  Future<void> _audit(String action, int crimeId, String summary) async {
    await _db.into(_db.auditLog).insert(
          AuditLogCompanion.insert(
            action: action,
            entityType: const Value('crime'),
            entityId: Value(crimeId),
            changesJson: Value(summary),
          ),
        );
  }

  Future<int> _upsertCrime(CrimeDraft d) async {
    final companion = CrimesCompanion(
      firNo: Value(d.firNo),
      year: Value(d.year ?? DateTime.now().year),
      section: Value(d.section),
      subSection: Value(d.subSection),
      stationId: Value(d.stationId),
      district: Value(d.district),
      policeStation: Value(d.policeStation),
      dateOccurred: Value(d.dateOccurred),
      timeOccurred: Value(d.timeOccurred),
      placeOccurred: Value(d.placeOccurred),
      dateRegistered: Value(d.dateRegistered),
      timeRegistered: Value(d.timeRegistered),
      crimeType: Value(d.crimeType),
      status: Value(d.status),
      detailedDescription: Value(d.detailedDescription),
      updatedAt: Value(DateTime.now()),
    );

    if (d.isNew) {
      return _db.into(_db.crimes).insert(companion);
    }
    await (_db.update(_db.crimes)..where((t) => t.id.equals(d.id!)))
        .write(companion);
    return d.id!;
  }

  Future<void> _deleteChildren(int crimeId) async {
    await (_db.delete(_db.complainants)
          ..where((t) => t.crimeId.equals(crimeId)))
        .go();
    await (_db.delete(_db.accused)..where((t) => t.crimeId.equals(crimeId)))
        .go();
    await (_db.delete(_db.stolenProperty)
          ..where((t) => t.crimeId.equals(crimeId)))
        .go();
    await (_db.delete(_db.recoveredProperty)
          ..where((t) => t.crimeId.equals(crimeId)))
        .go();
    await (_db.delete(_db.investigation)
          ..where((t) => t.crimeId.equals(crimeId)))
        .go();
    await (_db.delete(_db.verdict)..where((t) => t.crimeId.equals(crimeId)))
        .go();
    await (_db.delete(_db.attachments)
          ..where((t) => t.crimeId.equals(crimeId)))
        .go();
    await (_db.delete(_db.customFieldValues)
          ..where((t) => t.crimeId.equals(crimeId)))
        .go();
  }

  Future<void> _insertChildren(int crimeId, CrimeDraft d) async {
    final c = d.complainant;
    if (_personHasData(c)) {
      await _db.into(_db.complainants).insert(ComplainantsCompanion.insert(
            crimeId: crimeId,
            name: c.name,
            gender: Value(c.gender),
            age: Value(c.age),
            address: Value(c.address),
            mobile: Value(c.mobile),
            email: Value(c.email),
            aadhaarEnc: Value(_cipher.encryptField(c.aadhaar)),
            panEnc: Value(_cipher.encryptField(c.pan)),
            passport: Value(c.passport),
          ));
    }

    for (final a in d.accused) {
      if (a.name.trim().isEmpty) continue;
      await _db.into(_db.accused).insert(AccusedCompanion.insert(
            crimeId: crimeId,
            name: a.name,
            gender: Value(a.gender),
            age: Value(a.age),
            address: Value(a.address),
            mobile: Value(a.mobile),
            email: Value(a.email),
            aadhaarEnc: Value(_cipher.encryptField(a.aadhaar)),
            panEnc: Value(_cipher.encryptField(a.pan)),
            passport: Value(a.passport),
            arrestStatus: Value(a.arrestStatus),
            arrestDate: Value(a.arrestDate),
            arrestTime: Value(a.arrestTime),
            photoPath: Value(a.photoPath),
          ));
    }

    for (final s in d.stolen) {
      if ((s.description ?? '').trim().isEmpty && s.value == null) continue;
      await _db.into(_db.stolenProperty).insert(StolenPropertyCompanion.insert(
            crimeId: crimeId,
            type: Value(s.type),
            description: Value(s.description),
            value: Value(s.value),
          ));
    }

    for (final r in d.recovered) {
      if ((r.description ?? '').trim().isEmpty && r.value == null) continue;
      await _db
          .into(_db.recoveredProperty)
          .insert(RecoveredPropertyCompanion.insert(
            crimeId: crimeId,
            description: Value(r.description),
            value: Value(r.value),
            recoveryDate: Value(r.recoveryDate),
          ));
    }

    final inv = d.investigation;
    if (_investigationHasData(inv)) {
      await _db.into(_db.investigation).insert(InvestigationCompanion.insert(
            crimeId: crimeId,
            officerName: Value(inv.officerName),
            officerId: Value(inv.officerId),
            officerMobile: Value(inv.officerMobile),
            filedBy: Value(inv.filedBy),
            preventiveAction: Value(inv.preventiveAction),
            preventiveNo: Value(inv.preventiveNo),
            preventiveDate: Value(inv.preventiveDate),
            wantedAccused: Value(inv.wantedAccused),
          ));
    }

    final v = d.verdict;
    if (_verdictHasData(v)) {
      await _db.into(_db.verdict).insert(VerdictCompanion.insert(
            crimeId: crimeId,
            chargesheetNo: Value(v.chargesheetNo),
            chargesheetDate: Value(v.chargesheetDate),
            rccNo: Value(v.rccNo),
            finalOrder: Value(v.finalOrder),
            foundGuilty: Value(v.foundGuilty),
            punishment: Value(v.punishment),
          ));
    }

    for (final at in d.attachments) {
      if (at.filePath.trim().isEmpty) continue;
      await _db.into(_db.attachments).insert(AttachmentsCompanion.insert(
            crimeId: crimeId,
            filePath: at.filePath,
            fileType: Value(at.fileType),
            description: Value(at.description),
          ));
    }

    for (final entry in d.customValues.entries) {
      final value = entry.value;
      if (value == null || value.trim().isEmpty) continue;
      await _db.into(_db.customFieldValues).insert(
            CustomFieldValuesCompanion.insert(
              crimeId: crimeId,
              customFieldId: entry.key,
              value: Value(value),
            ),
          );
    }
  }

  /// Loads a full draft for editing, decrypting Aadhaar/PAN back to plaintext.
  Future<CrimeDraft?> loadDraft(int id) async {
    final crime = await (_db.select(_db.crimes)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (crime == null) return null;

    final complainantRow = await (_db.select(_db.complainants)
          ..where((t) => t.crimeId.equals(id)))
        .getSingleOrNull();
    final accusedRows = await (_db.select(_db.accused)
          ..where((t) => t.crimeId.equals(id)))
        .get();
    final stolenRows = await (_db.select(_db.stolenProperty)
          ..where((t) => t.crimeId.equals(id)))
        .get();
    final recoveredRows = await (_db.select(_db.recoveredProperty)
          ..where((t) => t.crimeId.equals(id)))
        .get();
    final invRow = await (_db.select(_db.investigation)
          ..where((t) => t.crimeId.equals(id)))
        .getSingleOrNull();
    final verdictRow = await (_db.select(_db.verdict)
          ..where((t) => t.crimeId.equals(id)))
        .getSingleOrNull();
    final attachmentRows = await (_db.select(_db.attachments)
          ..where((t) => t.crimeId.equals(id)))
        .get();
    final customRows = await (_db.select(_db.customFieldValues)
          ..where((t) => t.crimeId.equals(id)))
        .get();

    return CrimeDraft(
      id: crime.id,
      firNo: crime.firNo,
      year: crime.year,
      section: crime.section,
      subSection: crime.subSection,
      stationId: crime.stationId,
      district: crime.district,
      policeStation: crime.policeStation,
      dateOccurred: crime.dateOccurred,
      timeOccurred: crime.timeOccurred,
      placeOccurred: crime.placeOccurred,
      dateRegistered: crime.dateRegistered,
      timeRegistered: crime.timeRegistered,
      crimeType: crime.crimeType,
      status: crime.status,
      detailedDescription: crime.detailedDescription,
      complainant: complainantRow == null
          ? PersonDraft()
          : PersonDraft(
              id: complainantRow.id,
              name: complainantRow.name,
              gender: complainantRow.gender,
              age: complainantRow.age,
              address: complainantRow.address,
              mobile: complainantRow.mobile,
              email: complainantRow.email,
              aadhaar: _cipher.decryptField(complainantRow.aadhaarEnc),
              pan: _cipher.decryptField(complainantRow.panEnc),
              passport: complainantRow.passport,
            ),
      accused: [
        for (final a in accusedRows)
          AccusedDraft(
            id: a.id,
            name: a.name,
            gender: a.gender,
            age: a.age,
            address: a.address,
            mobile: a.mobile,
            email: a.email,
            aadhaar: _cipher.decryptField(a.aadhaarEnc),
            pan: _cipher.decryptField(a.panEnc),
            passport: a.passport,
            arrestStatus: a.arrestStatus,
            arrestDate: a.arrestDate,
            arrestTime: a.arrestTime,
            photoPath: a.photoPath,
          ),
      ],
      stolen: [
        for (final s in stolenRows)
          StolenItemDraft(
            id: s.id,
            type: s.type,
            description: s.description,
            value: s.value,
          ),
      ],
      recovered: [
        for (final r in recoveredRows)
          RecoveredItemDraft(
            id: r.id,
            description: r.description,
            value: r.value,
            recoveryDate: r.recoveryDate,
          ),
      ],
      investigation: invRow == null
          ? InvestigationDraft()
          : InvestigationDraft(
              id: invRow.id,
              officerName: invRow.officerName,
              officerId: invRow.officerId,
              officerMobile: invRow.officerMobile,
              filedBy: invRow.filedBy,
              preventiveAction: invRow.preventiveAction,
              preventiveNo: invRow.preventiveNo,
              preventiveDate: invRow.preventiveDate,
              wantedAccused: invRow.wantedAccused,
            ),
      verdict: verdictRow == null
          ? VerdictDraft()
          : VerdictDraft(
              id: verdictRow.id,
              chargesheetNo: verdictRow.chargesheetNo,
              chargesheetDate: verdictRow.chargesheetDate,
              rccNo: verdictRow.rccNo,
              finalOrder: verdictRow.finalOrder,
              foundGuilty: verdictRow.foundGuilty,
              punishment: verdictRow.punishment,
            ),
      attachments: [
        for (final at in attachmentRows)
          AttachmentDraft(
            id: at.id,
            filePath: at.filePath,
            fileType: at.fileType,
            description: at.description,
          ),
      ],
      customValues: {
        for (final cv in customRows) cv.customFieldId: cv.value,
      },
    );
  }

  /// Deletes a crime; child rows cascade (PRAGMA foreign_keys is ON). Returns
  /// the deleted FIR's identity so the caller can report it to the central
  /// store (deletion audit), or null if no such crime existed.
  Future<DeletedCrime?> deleteCrime(int id) async {
    final crime = await (_db.select(_db.crimes)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    await (_db.delete(_db.crimes)..where((t) => t.id.equals(id))).go();
    await _audit('delete', id, 'crime #$id');
    if (crime == null) return null;
    return DeletedCrime(
      uid: id.toString(),
      firNo: crime.firNo,
      year: crime.year,
      policeStation: crime.policeStation,
    );
  }

  /// Deletes local crimes that were removed on the server (admin panel). [uids]
  /// are central remote_uids (which equal the local crime id as a string). No
  /// central deletion is reported — they're already gone server-side. Returns
  /// how many local crimes were removed. Child rows cascade.
  Future<int> purgeLocalByUids(List<String> uids) async {
    final ids = uids.map(int.tryParse).whereType<int>().toList();
    if (ids.isEmpty) return 0;
    var removed = 0;
    for (final id in ids) {
      final existed = await (_db.delete(_db.crimes)..where((t) => t.id.equals(id))).go();
      if (existed > 0) {
        await _audit('server-delete', id, 'crime #$id removed by admin');
        removed++;
      }
    }
    return removed;
  }

  /// Live list of all crimes (newest first) joined with the complainant name
  /// and accused names, for the list/search screen. Re-emits whenever a crime
  /// or complainant row changes; saving a crime always touches the crimes row,
  /// so accused/property edits are reflected too.
  Stream<List<CrimeListItem>> watchCrimeList() {
    final query = _db.select(_db.crimes).join([
      leftOuterJoin(
        _db.complainants,
        _db.complainants.crimeId.equalsExp(_db.crimes.id),
      ),
    ])
      ..orderBy([OrderingTerm.desc(_db.crimes.createdAt)]);

    return query.watch().asyncMap((rows) async {
      final accusedRows = await _db.select(_db.accused).get();
      final namesByCrime = <int, List<String>>{};
      for (final a in accusedRows) {
        (namesByCrime[a.crimeId] ??= <String>[]).add(a.name);
      }
      return [
        for (final row in rows)
          () {
            final crime = row.readTable(_db.crimes);
            final complainant = row.readTableOrNull(_db.complainants);
            return CrimeListItem(
              crime: crime,
              complainantName: complainant?.name,
              accusedNames: namesByCrime[crime.id] ?? const [],
            );
          }(),
      ];
    });
  }

  /// Builds the records to upload to the central officer-portal store. Returns
  /// one map per crime with light indexed fields + a `data` blob for the portal
  /// detail view / PDF. Aadhaar & PAN are deliberately NOT included — encrypted
  /// PII never leaves the station machine in clear text.
  Future<List<Map<String, dynamic>>> exportForCentral() async {
    final crimes = await _db.select(_db.crimes).get();
    final complainants = await _db.select(_db.complainants).get();
    final accusedRows = await _db.select(_db.accused).get();
    final invRows = await _db.select(_db.investigation).get();
    final verdictRows = await _db.select(_db.verdict).get();
    final recoveredRows = await _db.select(_db.recoveredProperty).get();

    final compByCrime = {for (final c in complainants) c.crimeId: c};
    final invByCrime = {for (final i in invRows) i.crimeId: i};
    final verdictByCrime = {for (final v in verdictRows) v.crimeId: v};
    final accusedByCrime = <int, List<String>>{};
    // Counts that power the dashboard's arrest / caseload charts.
    final accusedCount = <int, int>{};
    final arrestedCount = <int, int>{};
    final wantedCount = <int, int>{};
    for (final a in accusedRows) {
      (accusedByCrime[a.crimeId] ??= <String>[]).add(a.name);
      accusedCount.update(a.crimeId, (v) => v + 1, ifAbsent: () => 1);
      switch (a.arrestStatus) {
        case 'arrested':
          arrestedCount.update(a.crimeId, (v) => v + 1, ifAbsent: () => 1);
        case 'wanted':
        case 'absconding':
          wantedCount.update(a.crimeId, (v) => v + 1, ifAbsent: () => 1);
      }
    }
    final recoveredByCrime = <int, double>{};
    for (final r in recoveredRows) {
      recoveredByCrime.update(r.crimeId, (v) => v + (r.value ?? 0),
          ifAbsent: () => r.value ?? 0);
    }

    String? d(DateTime? dt) => dt?.toIso8601String();

    return [
      for (final c in crimes)
        () {
          final comp = compByCrime[c.id];
          final inv = invByCrime[c.id];
          final v = verdictByCrime[c.id];
          return <String, dynamic>{
            'uid': c.id.toString(),
            'fir_no': c.firNo,
            'year': c.year,
            'crime_type': c.crimeType,
            'section': c.section,
            'status': c.status,
            'police_station': c.policeStation,
            'date_occurred': d(c.dateOccurred),
            'date_registered': d(c.dateRegistered),
            'data': {
              'fir_no': c.firNo,
              'year': c.year,
              'section': c.section,
              'sub_section': c.subSection,
              'crime_type': c.crimeType,
              'status': c.status,
              'district': c.district,
              'police_station': c.policeStation,
              'date_occurred': d(c.dateOccurred),
              'time_occurred': c.timeOccurred,
              'place_occurred': c.placeOccurred,
              'date_registered': d(c.dateRegistered),
              'time_registered': c.timeRegistered,
              'description': c.detailedDescription,
              'complainant_name': comp?.name,
              'complainant_mobile': comp?.mobile,
              'complainant_address': comp?.address,
              'accused_names': accusedByCrime[c.id] ?? const [],
              'investigating_officer': inv?.officerName,
              'final_order': v?.finalOrder,
              'punishment': v?.punishment,
              // Analytic fields for the officer-portal dashboard.
              'officer_name': inv?.officerName,
              'chargesheet_date': d(v?.chargesheetDate),
              'recovered_value': recoveredByCrime[c.id] ?? 0,
              'accused_count': accusedCount[c.id] ?? 0,
              'arrested_count': arrestedCount[c.id] ?? 0,
              'wanted_count': wantedCount[c.id] ?? 0,
            },
          };
        }(),
    ];
  }

  bool _personHasData(PersonDraft p) =>
      p.name.trim().isNotEmpty ||
      [p.gender, p.address, p.mobile, p.email, p.aadhaar, p.pan, p.passport]
          .any((e) => (e ?? '').trim().isNotEmpty) ||
      p.age != null;

  bool _investigationHasData(InvestigationDraft i) =>
      [
        i.officerName,
        i.officerId,
        i.officerMobile,
        i.filedBy,
        i.preventiveAction,
        i.preventiveNo,
        i.wantedAccused,
      ].any((e) => (e ?? '').trim().isNotEmpty) ||
      i.preventiveDate != null;

  bool _verdictHasData(VerdictDraft v) =>
      [v.chargesheetNo, v.rccNo, v.finalOrder, v.punishment]
          .any((e) => (e ?? '').trim().isNotEmpty) ||
      v.chargesheetDate != null ||
      v.foundGuilty != null;
}

/// Identity of a FIR that was just deleted, used to report the deletion to the
/// central store for the admin's deletion audit.
class DeletedCrime {
  const DeletedCrime({
    required this.uid,
    this.firNo,
    this.year,
    this.policeStation,
  });

  final String uid;
  final String? firNo;
  final int? year;
  final String? policeStation;
}

final crimeRepositoryProvider = Provider<CrimeRepository>((ref) {
  return CrimeRepository(
    ref.watch(databaseProvider),
    ref.watch(cipherProvider),
  );
});
