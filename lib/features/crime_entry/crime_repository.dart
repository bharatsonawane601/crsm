import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/crypto/cipher_provider.dart';
import '../../core/crypto/field_cipher.dart';
import '../../data/db/database.dart';
import '../../data/db/database_provider.dart';
import '../brain/fuzzy.dart';
import '../crime_list/models/crime_list_item.dart';
import 'data/bns_data.dart';
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
      // A freshly-inserted crime has no child rows yet — skipping the eight
      // wholesale deletes makes bulk imports noticeably faster.
      if (!wasNew) await _deleteChildren(crimeId);
      await _insertChildren(crimeId, d);
      await _audit(
        wasNew ? 'create' : 'update',
        crimeId,
        'FIR ${d.firNo}/${d.year ?? ''}',
      );
      return crimeId;
    });
  }

  /// Writes an audit-log entry. userId is null until real auth is wired.
  Future<void> _audit(String action, int crimeId, String summary) async {
    await _db
        .into(_db.auditLog)
        .insert(
          AuditLogCompanion.insert(
            action: action,
            entityType: const Value('crime'),
            entityId: Value(crimeId),
            changesJson: Value(summary),
          ),
        );
  }

  /// A stable, non-numeric central-server uid (`c_<random hex>`). The prefix
  /// guarantees it can never equal a legacy numeric uid, so a freshly-created
  /// record can never collide with the server's permanent deletion/suppression
  /// list (which is keyed by uid).
  static String _newRemoteUid() {
    final r = Random.secure();
    final hex = List<int>.generate(
      16,
      (_) => r.nextInt(256),
    ).map((b) => b.toRadixString(16).padLeft(2, '0')).join();
    return 'c_$hex';
  }

  /// Serialise the accused physical-description map to a JSON string (or null
  /// when there's nothing to store).
  static String? _encodePhysical(Map<String, String>? m) {
    if (m == null) return null;
    final clean = {
      for (final e in m.entries)
        if (e.value.trim().isNotEmpty) e.key: e.value.trim(),
    };
    return clean.isEmpty ? null : jsonEncode(clean);
  }

  /// Parse the stored physical-description JSON back to a map.
  static Map<String, String>? _decodePhysical(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    try {
      final m = jsonDecode(s) as Map<String, dynamic>;
      return {for (final e in m.entries) e.key: e.value.toString()};
    } catch (_) {
      return null;
    }
  }

  Future<int> _upsertCrime(CrimeDraft d) async {
    // Assign a stable uid once, on first save; keep it on later edits.
    d.remoteUid ??= _newRemoteUid();
    final companion = CrimesCompanion(
      remoteUid: Value(d.remoteUid),
      firNo: Value(d.firNo),
      // Derive the year from the record's own dates before falling back to
      // "now" — otherwise an imported old FIR without a वर्ष column lands in
      // the current year and inflates the dashboard's "this year".
      year: Value(
        d.year ??
            d.dateRegistered?.year ??
            d.dateOccurred?.year ??
            DateTime.now().year,
      ),
      section: Value(d.section),
      subSection: Value(d.subSection),
      stationId: Value(d.stationId),
      district: Value(d.district),
      policeStation: Value(d.policeStation),
      dateOccurred: Value(d.dateOccurred),
      dateOccurredTo: Value(d.dateOccurredTo),
      timeOccurred: Value(d.timeOccurred),
      timeOccurredTo: Value(d.timeOccurredTo),
      placeOccurred: Value(d.placeOccurred),
      dateRegistered: Value(d.dateRegistered),
      timeRegistered: Value(d.timeRegistered),
      crimeType: Value(d.crimeType),
      status: Value(d.status),
      courtType: Value(d.courtType),
      caseStage: Value(d.caseStage),
      detailedDescription: Value(d.detailedDescription),
      firDate: Value(d.firDate),
      firTime: Value(d.firTime),
      infoReceivedDate: Value(d.infoReceivedDate),
      infoReceivedTime: Value(d.infoReceivedTime),
      gdDate: Value(d.gdDate),
      gdTime: Value(d.gdTime),
      gdEntryNo: Value(d.gdEntryNo),
      occurrenceDay: Value(d.occurrenceDay),
      typeOfInformation: Value(d.typeOfInformation),
      beatNo: Value(d.beatNo),
      directionDistance: Value(d.directionDistance),
      outsidePsName: Value(d.outsidePsName),
      outsidePsDistrict: Value(d.outsidePsDistrict),
      delayReason: Value(d.delayReason),
      inquestUdNo: Value(d.inquestUdNo),
      updatedAt: Value(DateTime.now()),
    );

    if (d.isNew) {
      return _db.into(_db.crimes).insert(companion);
    }
    await (_db.update(
      _db.crimes,
    )..where((t) => t.id.equals(d.id!))).write(companion);
    return d.id!;
  }

  Future<void> _deleteChildren(int crimeId) async {
    await (_db.delete(
      _db.complainants,
    )..where((t) => t.crimeId.equals(crimeId))).go();
    await (_db.delete(
      _db.accused,
    )..where((t) => t.crimeId.equals(crimeId))).go();
    await (_db.delete(
      _db.stolenProperty,
    )..where((t) => t.crimeId.equals(crimeId))).go();
    await (_db.delete(
      _db.recoveredProperty,
    )..where((t) => t.crimeId.equals(crimeId))).go();
    await (_db.delete(
      _db.investigation,
    )..where((t) => t.crimeId.equals(crimeId))).go();
    await (_db.delete(
      _db.verdict,
    )..where((t) => t.crimeId.equals(crimeId))).go();
    await (_db.delete(
      _db.attachments,
    )..where((t) => t.crimeId.equals(crimeId))).go();
    await (_db.delete(
      _db.customFieldValues,
    )..where((t) => t.crimeId.equals(crimeId))).go();
  }

  Future<void> _insertChildren(int crimeId, CrimeDraft d) async {
    final c = d.complainant;
    if (_personHasData(c)) {
      await _db
          .into(_db.complainants)
          .insert(
            ComplainantsCompanion.insert(
              crimeId: crimeId,
              name: c.name,
              gender: Value(c.gender),
              age: Value(c.age),
              ageText: Value(c.ageText),
              address: Value(c.address),
              mobile: Value(c.mobile),
              email: Value(c.email),
              aadhaarEnc: Value(_cipher.encryptField(c.aadhaar)),
              panEnc: Value(_cipher.encryptField(c.pan)),
              passport: Value(c.passport),
              fatherHusbandName: Value(c.fatherHusbandName),
              birthYear: Value(c.birthYear),
              nationality: Value(c.nationality),
              occupation: Value(c.occupation),
              permanentAddress: Value(c.permanentAddress),
              idType: Value(c.idType),
              idNumber: Value(c.idNumber),
            ),
          );
    }

    for (final a in d.accused) {
      if (a.name.trim().isEmpty) continue;
      await _db
          .into(_db.accused)
          .insert(
            AccusedCompanion.insert(
              crimeId: crimeId,
              name: a.name,
              gender: Value(a.gender),
              age: Value(a.age),
              ageText: Value(a.ageText),
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
              alias: Value(a.alias),
              relativeName: Value(a.relativeName),
              physicalJson: Value(_encodePhysical(a.physical)),
            ),
          );
    }

    for (final s in d.stolen) {
      if ((s.description ?? '').trim().isEmpty && s.value == null) continue;
      await _db
          .into(_db.stolenProperty)
          .insert(
            StolenPropertyCompanion.insert(
              crimeId: crimeId,
              category: Value(s.category),
              type: Value(s.type),
              description: Value(s.description),
              value: Value(s.value),
            ),
          );
    }

    for (final r in d.recovered) {
      if ((r.description ?? '').trim().isEmpty && r.value == null) continue;
      await _db
          .into(_db.recoveredProperty)
          .insert(
            RecoveredPropertyCompanion.insert(
              crimeId: crimeId,
              description: Value(r.description),
              value: Value(r.value),
              recoveryDate: Value(r.recoveryDate),
            ),
          );
    }

    final inv = d.investigation;
    if (_investigationHasData(inv)) {
      await _db
          .into(_db.investigation)
          .insert(
            InvestigationCompanion.insert(
              crimeId: crimeId,
              officerName: Value(inv.officerName),
              officerId: Value(inv.officerId),
              officerDesignation: Value(inv.officerDesignation),
              officerMobile: Value(inv.officerMobile),
              filedBy: Value(inv.filedBy),
              preventiveAction: Value(inv.preventiveAction),
              preventiveNo: Value(inv.preventiveNo),
              preventiveDate: Value(inv.preventiveDate),
              wantedAccused: Value(inv.wantedAccused),
              registeringOfficerName: Value(inv.registeringOfficerName),
              registeringOfficerRank: Value(inv.registeringOfficerRank),
              registeringOfficerNo: Value(inv.registeringOfficerNo),
              actionTaken: Value(inv.actionTaken),
              courtDispatchDate: Value(inv.courtDispatchDate),
              courtDispatchTime: Value(inv.courtDispatchTime),
            ),
          );
    }

    final v = d.verdict;
    if (_verdictHasData(v)) {
      await _db
          .into(_db.verdict)
          .insert(
            VerdictCompanion.insert(
              crimeId: crimeId,
              chargesheetNo: Value(v.chargesheetNo),
              chargesheetDate: Value(v.chargesheetDate),
              rccNo: Value(v.rccNo),
              finalOrder: Value(v.finalOrder),
              foundGuilty: Value(v.foundGuilty),
              punishment: Value(v.punishment),
            ),
          );
    }

    for (final at in d.attachments) {
      if (at.filePath.trim().isEmpty) continue;
      await _db
          .into(_db.attachments)
          .insert(
            AttachmentsCompanion.insert(
              crimeId: crimeId,
              filePath: at.filePath,
              fileType: Value(at.fileType),
              description: Value(at.description),
            ),
          );
    }

    for (final entry in d.customValues.entries) {
      final value = entry.value;
      if (value == null || value.trim().isEmpty) continue;
      await _db
          .into(_db.customFieldValues)
          .insert(
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
    final crime = await (_db.select(
      _db.crimes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (crime == null) return null;

    final complainantRow = await (_db.select(
      _db.complainants,
    )..where((t) => t.crimeId.equals(id))).getSingleOrNull();
    final accusedRows = await (_db.select(
      _db.accused,
    )..where((t) => t.crimeId.equals(id))).get();
    final stolenRows = await (_db.select(
      _db.stolenProperty,
    )..where((t) => t.crimeId.equals(id))).get();
    final recoveredRows = await (_db.select(
      _db.recoveredProperty,
    )..where((t) => t.crimeId.equals(id))).get();
    final invRow = await (_db.select(
      _db.investigation,
    )..where((t) => t.crimeId.equals(id))).getSingleOrNull();
    final verdictRow = await (_db.select(
      _db.verdict,
    )..where((t) => t.crimeId.equals(id))).getSingleOrNull();
    final attachmentRows = await (_db.select(
      _db.attachments,
    )..where((t) => t.crimeId.equals(id))).get();
    final customRows = await (_db.select(
      _db.customFieldValues,
    )..where((t) => t.crimeId.equals(id))).get();

    return CrimeDraft(
      id: crime.id,
      remoteUid: crime.remoteUid,
      firNo: crime.firNo,
      year: crime.year,
      section: crime.section,
      subSection: crime.subSection,
      stationId: crime.stationId,
      district: crime.district,
      policeStation: crime.policeStation,
      dateOccurred: crime.dateOccurred,
      dateOccurredTo: crime.dateOccurredTo,
      timeOccurred: crime.timeOccurred,
      timeOccurredTo: crime.timeOccurredTo,
      placeOccurred: crime.placeOccurred,
      dateRegistered: crime.dateRegistered,
      timeRegistered: crime.timeRegistered,
      crimeType: crime.crimeType,
      status: crime.status,
      courtType: crime.courtType,
      caseStage: crime.caseStage,
      detailedDescription: crime.detailedDescription,
      firDate: crime.firDate,
      firTime: crime.firTime,
      infoReceivedDate: crime.infoReceivedDate,
      infoReceivedTime: crime.infoReceivedTime,
      gdDate: crime.gdDate,
      gdTime: crime.gdTime,
      gdEntryNo: crime.gdEntryNo,
      occurrenceDay: crime.occurrenceDay,
      typeOfInformation: crime.typeOfInformation,
      beatNo: crime.beatNo,
      directionDistance: crime.directionDistance,
      outsidePsName: crime.outsidePsName,
      outsidePsDistrict: crime.outsidePsDistrict,
      delayReason: crime.delayReason,
      inquestUdNo: crime.inquestUdNo,
      complainant: complainantRow == null
          ? PersonDraft()
          : PersonDraft(
              id: complainantRow.id,
              name: complainantRow.name,
              gender: complainantRow.gender,
              age: complainantRow.age,
              ageText: complainantRow.ageText,
              address: complainantRow.address,
              mobile: complainantRow.mobile,
              email: complainantRow.email,
              aadhaar: _cipher.decryptField(complainantRow.aadhaarEnc),
              pan: _cipher.decryptField(complainantRow.panEnc),
              passport: complainantRow.passport,
              fatherHusbandName: complainantRow.fatherHusbandName,
              birthYear: complainantRow.birthYear,
              nationality: complainantRow.nationality,
              occupation: complainantRow.occupation,
              permanentAddress: complainantRow.permanentAddress,
              idType: complainantRow.idType,
              idNumber: complainantRow.idNumber,
            ),
      accused: [
        for (final a in accusedRows)
          AccusedDraft(
            id: a.id,
            name: a.name,
            gender: a.gender,
            age: a.age,
            ageText: a.ageText,
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
            alias: a.alias,
            relativeName: a.relativeName,
            physical: _decodePhysical(a.physicalJson),
          ),
      ],
      stolen: [
        for (final s in stolenRows)
          StolenItemDraft(
            id: s.id,
            category: s.category,
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
              officerDesignation: invRow.officerDesignation,
              officerMobile: invRow.officerMobile,
              filedBy: invRow.filedBy,
              preventiveAction: invRow.preventiveAction,
              preventiveNo: invRow.preventiveNo,
              preventiveDate: invRow.preventiveDate,
              wantedAccused: invRow.wantedAccused,
              registeringOfficerName: invRow.registeringOfficerName,
              registeringOfficerRank: invRow.registeringOfficerRank,
              registeringOfficerNo: invRow.registeringOfficerNo,
              actionTaken: invRow.actionTaken,
              courtDispatchDate: invRow.courtDispatchDate,
              courtDispatchTime: invRow.courtDispatchTime,
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
      customValues: {for (final cv in customRows) cv.customFieldId: cv.value},
    );
  }

  /// Deletes a crime; child rows cascade (PRAGMA foreign_keys is ON). Returns
  /// the deleted FIR's identity so the caller can report it to the central
  /// store (deletion audit), or null if no such crime existed.
  Future<DeletedCrime?> deleteCrime(int id) async {
    final crime = await (_db.select(
      _db.crimes,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    await (_db.delete(_db.crimes)..where((t) => t.id.equals(id))).go();
    await _audit('delete', id, 'crime #$id');
    if (crime == null) return null;
    return DeletedCrime(
      // Report the stable uid so the server suppresses the right record
      // (falls back to the numeric id for legacy rows without one).
      uid: crime.remoteUid ?? id.toString(),
      firNo: crime.firNo,
      year: crime.year,
      policeStation: crime.policeStation,
    );
  }

  /// Deletes local crimes that were removed on the server (admin panel). [uids]
  /// are central remote_uids. Matches the stable [remoteUid] first; for legacy
  /// rows that never had one it falls back to the numeric id. Crucially it does
  /// NOT delete a freshly-created record just because it happens to reuse a
  /// numeric id that was suppressed long ago — new records carry a "c_" uid that
  /// can't appear in a numeric-only suppression. Returns how many were removed;
  /// child rows cascade.
  /// How many local crimes [purgeLocalByUids] would delete for [uids], without
  /// deleting anything. The sync fuse uses this to spot a suspicious server-side
  /// mass deletion (e.g. old delete-markers after a server wipe) BEFORE obeying.
  Future<int> countSuppressionMatches(List<String> uids) async {
    if (uids.isEmpty) return 0;
    final numericIds = uids.map(int.tryParse).whereType<int>().toList();
    const chunk = 500;
    final targetIds = <int>{};
    for (var i = 0; i < uids.length; i += chunk) {
      final part = uids.sublist(i, min(i + chunk, uids.length));
      final byUid = await (_db.select(
        _db.crimes,
      )..where((t) => t.remoteUid.isIn(part))).get();
      targetIds.addAll([for (final c in byUid) c.id]);
    }
    for (var i = 0; i < numericIds.length; i += chunk) {
      final part = numericIds.sublist(i, min(i + chunk, numericIds.length));
      final byLegacyId = await (_db.select(
        _db.crimes,
      )..where((t) => t.remoteUid.isNull() & t.id.isIn(part))).get();
      targetIds.addAll([for (final c in byLegacyId) c.id]);
    }
    return targetIds.length;
  }

  Future<int> purgeLocalByUids(List<String> uids) async {
    if (uids.isEmpty) return 0;
    final numericIds = uids.map(int.tryParse).whereType<int>().toList();

    // Everything runs in ONE transaction with set-based (IN …) statements —
    // a bulk admin deletion of thousands of FIRs clears locally in seconds,
    // not minutes of row-at-a-time disk syncs. Lists are chunked to stay
    // under SQLite's bound-variable limit.
    const chunk = 500;
    return _db.transaction(() async {
      final targetIds = <int>{};
      // 1) Records whose stable uid is in the suppressed set.
      for (var i = 0; i < uids.length; i += chunk) {
        final part = uids.sublist(i, min(i + chunk, uids.length));
        final byUid = await (_db.select(
          _db.crimes,
        )..where((t) => t.remoteUid.isIn(part))).get();
        targetIds.addAll([for (final c in byUid) c.id]);
      }
      // 2) Legacy rows without a stable uid, matched by their numeric id only.
      for (var i = 0; i < numericIds.length; i += chunk) {
        final part = numericIds.sublist(i, min(i + chunk, numericIds.length));
        final byLegacyId = await (_db.select(
          _db.crimes,
        )..where((t) => t.remoteUid.isNull() & t.id.isIn(part))).get();
        targetIds.addAll([for (final c in byLegacyId) c.id]);
      }
      if (targetIds.isEmpty) return 0;

      final ids = targetIds.toList();
      for (var i = 0; i < ids.length; i += chunk) {
        final part = ids.sublist(i, min(i + chunk, ids.length));
        await (_db.delete(_db.crimes)..where((t) => t.id.isIn(part))).go();
      }
      await _db.batch((b) {
        for (final id in ids) {
          b.insert(
            _db.auditLog,
            AuditLogCompanion.insert(
              action: 'server-delete',
              entityType: const Value('crime'),
              entityId: Value(id),
              changesJson: Value('crime #$id removed by admin'),
            ),
          );
        }
      });
      return ids.length;
    });
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
    ])..orderBy([OrderingTerm.desc(_db.crimes.createdAt)]);

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

  /// Canonical "fir|year|station" identity of a record — Devanagari digits map
  /// to ASCII and case/whitespace/punctuation are ignored, so "१२/२०२४ सिटी चौक"
  /// and "12/2024 सिटीचौक" identify the same FIR. Null when there's no FIR
  /// number to identify by. Mirrors the server's normalization in db.php.
  static String? firIdentityKey(String? firNo, int? year, String? station) {
    final fir = _normIdPart(firNo ?? '');
    if (fir.isEmpty) return null;
    return '$fir|${year ?? 0}|${_normIdPart(station ?? '')}';
  }

  static String _normIdPart(String s) {
    const dev = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
    var v = s.toLowerCase();
    for (var i = 0; i < 10; i++) {
      v = v.replaceAll(dev[i], '$i');
    }
    return v.replaceAll(RegExp(r'[\s.\-_,()]+'), '');
  }

  /// Runs [action] in a single database transaction. The Excel importer wraps
  /// the whole import in one so thousands of rows commit with ONE disk sync
  /// instead of one per row (the difference between seconds and many minutes).
  Future<T> runInTransaction<T>(Future<T> Function() action) =>
      _db.transaction(action);

  /// Rewrites stored police-station names to their canonical spelling (e.g.
  /// "दौलताबाद" -> "Daulatabad") so one station never shows as two entries in
  /// the dashboard or portal. Touches updatedAt so the incremental central
  /// sync re-uploads the corrected rows. Returns how many rows changed.
  Future<int> canonicalizeStationNames() async {
    final crimes = await _db.select(_db.crimes).get();
    var changed = 0;
    await _db.transaction(() async {
      for (final c in crimes) {
        final canon = canonicalStationName(c.policeStation);
        if (canon != null && canon != c.policeStation) {
          await (_db.update(_db.crimes)..where((t) => t.id.equals(c.id))).write(
            CrimesCompanion(
              policeStation: Value(canon),
              updatedAt: Value(DateTime.now()),
            ),
          );
          changed++;
        }
      }
    });
    return changed;
  }

  /// Identity keys of every stored crime, for the Excel importer to skip
  /// records that already exist instead of creating duplicates.
  Future<Set<String>> existingFirKeys() async {
    final crimes = await _db.select(_db.crimes).get();
    return {
      for (final c in crimes)
        if (firIdentityKey(c.firNo, c.year, c.policeStation) != null)
          firIdentityKey(c.firNo, c.year, c.policeStation)!,
    };
  }

  /// Brain intel on a typed accused name: how many OTHER crimes name (nearly)
  /// this person — matching their name OR alias, fuzzy so spelling drift
  /// between FIRs ("Ramesh Pawar" / "रमेश पवार" / "Ramesh Pavar") still counts
  /// — and, critically, the FIRs where they are marked WANTED or absconding.
  Future<BrainPersonIntel> accusedIntel(
    String name, {
    int? excludeCrimeId,
  }) async {
    final t = name.trim();
    if (t.length < 3) return const BrainPersonIntel(0, []);
    final rows = await _db.select(_db.accused).get();
    final ids = <int>{};
    final wantedIds = <int>{};
    for (final a in rows) {
      if (excludeCrimeId != null && a.crimeId == excludeCrimeId) continue;
      final alias = (a.alias ?? '').trim();
      final hit = brainSimilarity(t, a.name) >= 0.85 ||
          (alias.length >= 3 && brainSimilarity(t, alias) >= 0.85);
      if (!hit) continue;
      ids.add(a.crimeId);
      final st = (a.arrestStatus ?? '').toLowerCase();
      if (st == 'wanted' || st == 'absconding') wantedIds.add(a.crimeId);
    }
    var wantedIn = <String>[];
    if (wantedIds.isNotEmpty) {
      final crimes = await (_db.select(_db.crimes)
            ..where((c) => c.id.isIn(wantedIds.toList())))
          .get();
      wantedIn = [
        for (final c in crimes)
          '${c.firNo}/${c.year}'
              '${(c.policeStation ?? '').isEmpty ? '' : ' — ${c.policeStation}'}',
      ];
    }
    return BrainPersonIntel(ids.length, wantedIn);
  }

  /// How many OTHER crimes mention this mobile number (accused or
  /// complainant). Phones catch aliases that names can't.
  Future<int> crimesWithMobile(String mobile, {int? excludeCrimeId}) async {
    final digits = mobile.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 10) return 0;
    final ids = <int>{};
    void scan(int crimeId, String? m) {
      if (excludeCrimeId != null && crimeId == excludeCrimeId) return;
      if ((m ?? '').replaceAll(RegExp(r'\D'), '').contains(digits)) {
        ids.add(crimeId);
      }
    }

    for (final a in await _db.select(_db.accused).get()) {
      scan(a.crimeId, a.mobile);
    }
    for (final c in await _db.select(_db.complainants).get()) {
      scan(c.crimeId, c.mobile);
    }
    return ids.length;
  }

  /// The local crime id matching an FIR number + year, or null if none. Used by
  /// the IO portal to auto-fill forms (e.g. Form "E") from an existing FIR.
  Future<int?> findCrimeIdByFir(String firNo, int year) async {
    final row =
        await (_db.select(_db.crimes)
              ..where((t) => t.firNo.equals(firNo) & t.year.equals(year))
              ..limit(1))
            .getSingleOrNull();
    return row?.id;
  }

  /// Builds the records to upload to the central officer-portal store. Returns
  /// one map per crime with light indexed fields + a `data` blob for the portal
  /// detail view / PDF. Aadhaar & PAN are deliberately NOT included — encrypted
  /// PII never leaves the station machine in clear text.
  ///
  /// With [since], only crimes saved/edited after that moment are exported —
  /// the incremental sync path, so a routine sync sends a handful of records
  /// instead of the whole database every time.
  Future<List<Map<String, dynamic>>> exportForCentral({DateTime? since}) async {
    var crimes = await _db.select(_db.crimes).get();
    if (since != null) {
      crimes = [
        for (final c in crimes)
          if (c.updatedAt.isAfter(since)) c,
      ];
      if (crimes.isEmpty) return const [];
    }
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
      recoveredByCrime.update(
        r.crimeId,
        (v) => v + (r.value ?? 0),
        ifAbsent: () => r.value ?? 0,
      );
    }
    // Lost/involved property value (गेला माल) — powers the admin panel's
    // muddemal lost/recovered/remaining money trail.
    final stolenRows = await _db.select(_db.stolenProperty).get();
    final stolenByCrime = <int, double>{};
    for (final s in stolenRows) {
      stolenByCrime.update(
        s.crimeId,
        (v) => v + (s.value ?? 0),
        ifAbsent: () => s.value ?? 0,
      );
    }

    String? d(DateTime? dt) => dt?.toIso8601String();

    return [
      for (final c in crimes)
        () {
          final comp = compByCrime[c.id];
          final inv = invByCrime[c.id];
          final v = verdictByCrime[c.id];
          return <String, dynamic>{
            'uid': c.remoteUid ?? c.id.toString(),
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
              'case_stage': c.caseStage,
              'district': c.district,
              'police_station': c.policeStation,
              'date_occurred': d(c.dateOccurred),
              'date_occurred_to': d(c.dateOccurredTo),
              'time_occurred': c.timeOccurred,
              'time_occurred_to': c.timeOccurredTo,
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
              'stolen_value': stolenByCrime[c.id] ?? 0,
              'accused_count': accusedCount[c.id] ?? 0,
              'arrested_count': arrestedCount[c.id] ?? 0,
              'wanted_count': wantedCount[c.id] ?? 0,
              'preventive_action': inv?.preventiveAction,
              'preventive_date': d(inv?.preventiveDate),
            },
          };
        }(),
    ];
  }

  bool _personHasData(PersonDraft p) =>
      p.name.trim().isNotEmpty ||
      [
        p.gender,
        p.address,
        p.mobile,
        p.email,
        p.aadhaar,
        p.pan,
        p.passport,
        p.fatherHusbandName,
        p.nationality,
        p.occupation,
        p.permanentAddress,
        p.idType,
        p.idNumber,
      ].any((e) => (e ?? '').trim().isNotEmpty) ||
      p.age != null ||
      p.birthYear != null;

  bool _investigationHasData(InvestigationDraft i) =>
      [
        i.officerName,
        i.officerId,
        i.officerDesignation,
        i.officerMobile,
        i.filedBy,
        i.preventiveAction,
        i.preventiveNo,
        i.wantedAccused,
        i.registeringOfficerName,
        i.registeringOfficerRank,
        i.registeringOfficerNo,
        i.actionTaken,
        i.courtDispatchTime,
      ].any((e) => (e ?? '').trim().isNotEmpty) ||
      i.preventiveDate != null ||
      i.courtDispatchDate != null;

  bool _verdictHasData(VerdictDraft v) =>
      [
        v.chargesheetNo,
        v.rccNo,
        v.finalOrder,
        v.punishment,
      ].any((e) => (e ?? '').trim().isNotEmpty) ||
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

/// What the brain knows about a typed person name (see [CrimeRepository.accusedIntel]).
class BrainPersonIntel {
  const BrainPersonIntel(this.otherFirs, this.wantedIn);

  /// Distinct OTHER crimes naming this person (by name or alias).
  final int otherFirs;

  /// "FIR/year — station" labels where this person is wanted/absconding.
  final List<String> wantedIn;
}

final crimeRepositoryProvider = Provider<CrimeRepository>((ref) {
  return CrimeRepository(
    ref.watch(databaseProvider),
    ref.watch(cipherProvider),
  );
});
