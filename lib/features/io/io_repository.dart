import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/db/database_provider.dart';
import '../access/access_config.dart';
import '../auth/auth_service.dart';
import 'io_forms_catalog.dart';
import 'io_sync_client.dart';

/// A stable, globally-unique id for a new case (`io_<random hex>`).
String _newCaseUid() {
  final r = Random.secure();
  final hex = List.generate(8, (_) => r.nextInt(256).toRadixString(16).padLeft(2, '0')).join();
  return 'io_$hex';
}

/// Data access for the IO portal (cases, forms, parties, exhibits, media).
class IoRepository {
  IoRepository(this._db);
  final AppDatabase _db;

  // --- Cases ---------------------------------------------------------------
  Stream<List<IoCase>> watchCases(String? ownerEmail) {
    final q = _db.select(_db.ioCases)
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    if (ownerEmail != null) {
      q.where((t) => t.ownerEmail.equals(ownerEmail));
    }
    return q.watch();
  }

  Future<IoCase> getCase(int id) =>
      (_db.select(_db.ioCases)..where((t) => t.id.equals(id))).getSingle();

  Stream<IoCase?> watchCase(int id) =>
      (_db.select(_db.ioCases)..where((t) => t.id.equals(id)))
          .watchSingleOrNull();

  Future<int> createCase({
    String? title,
    String? crimeType,
    String? crimeCategory,
    String? firNo,
    int? year,
    String? district,
    String? policeStation,
    String? linkedCrimeUid,
    String? ownerEmail,
  }) {
    return _db.into(_db.ioCases).insert(IoCasesCompanion.insert(
          remoteUid: _newCaseUid(),
          title: Value(title),
          crimeType: Value(crimeType),
          crimeCategory: Value(crimeCategory),
          firNo: Value(firNo),
          year: Value(year),
          district: Value(district),
          policeStation: Value(policeStation),
          linkedCrimeUid: Value(linkedCrimeUid),
          ownerEmail: Value(ownerEmail),
        ));
  }

  Future<void> touchCase(int id) => (_db.update(_db.ioCases)
        ..where((t) => t.id.equals(id)))
      .write(IoCasesCompanion(updatedAt: Value(DateTime.now())));

  /// Case-level shared data (IoCases.dataJson) decoded to a map.
  Future<Map<String, dynamic>> caseData(int id) async {
    final c = await getCase(id);
    if (c.dataJson == null || c.dataJson!.isEmpty) return {};
    try {
      return (jsonDecode(c.dataJson!) as Map).cast<String, dynamic>();
    } catch (_) {
      return {};
    }
  }

  Future<void> saveCaseData(int id, Map<String, dynamic> data) =>
      (_db.update(_db.ioCases)..where((t) => t.id.equals(id))).write(
          IoCasesCompanion(
              dataJson: Value(jsonEncode(data)),
              updatedAt: Value(DateTime.now())));

  Future<void> setCaseStatus(int id, String status) => (_db.update(_db.ioCases)
        ..where((t) => t.id.equals(id)))
      .write(IoCasesCompanion(
          status: Value(status), updatedAt: Value(DateTime.now())));

  Future<void> deleteCase(int id) =>
      (_db.delete(_db.ioCases)..where((t) => t.id.equals(id))).go();

  // --- Forms ---------------------------------------------------------------
  Stream<List<IoForm>> watchForms(int caseId) =>
      (_db.select(_db.ioForms)
            ..where((t) => t.caseId.equals(caseId))
            ..orderBy([(t) => OrderingTerm.asc(t.createdAt)]))
          .watch();

  Future<IoForm?> getForm(int caseId, String formId) =>
      (_db.select(_db.ioForms)
            ..where((t) => t.caseId.equals(caseId) & t.formId.equals(formId)))
          .getSingleOrNull();

  /// Returns the existing form instance for [formId] on the case, creating a
  /// blank draft (with header fields pre-filled from the case) if absent.
  Future<IoForm> ensureForm(int caseId, String formId) async {
    final existing = await getForm(caseId, formId);
    if (existing != null) return existing;
    final spec = kIoFormById[formId];
    final c = await getCase(caseId);
    final values = <String, dynamic>{};
    if (spec != null) {
      for (final f in spec.fields) {
        final v = _autofillValue(f.autofill, c);
        if (v != null) values[f.id] = v;
      }
    }
    await _db.into(_db.ioForms).insert(IoFormsCompanion.insert(
          caseId: caseId,
          formId: formId,
          title: Value(spec?.mr),
          valuesJson: Value(jsonEncode(values)),
        ));
    return (await getForm(caseId, formId))!;
  }

  Object? _autofillValue(String? key, IoCase c) => switch (key) {
        'district' => c.district,
        'policeStation' => c.policeStation,
        'firNo' => c.firNo,
        'year' => c.year,
        'crimeType' => c.crimeType,
        _ => null,
      };

  Future<void> saveForm(int caseId, String formId, Map<String, dynamic> values,
      {String? status}) async {
    await (_db.update(_db.ioForms)
          ..where((t) => t.caseId.equals(caseId) & t.formId.equals(formId)))
        .write(IoFormsCompanion(
      valuesJson: Value(jsonEncode(values)),
      status: status == null ? const Value.absent() : Value(status),
      updatedAt: Value(DateTime.now()),
    ));
    await touchCase(caseId);
  }

  Future<void> deleteForm(int caseId, String formId) =>
      (_db.delete(_db.ioForms)
            ..where((t) => t.caseId.equals(caseId) & t.formId.equals(formId)))
          .go();

  // --- Parties -------------------------------------------------------------
  Stream<List<IoParty>> watchParties(int caseId) => (_db.select(_db.ioParties)
        ..where((t) => t.caseId.equals(caseId))
        ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
      .watch();

  Future<int> addParty(int caseId, String role, String name,
          {Map<String, dynamic>? values}) =>
      _db.into(_db.ioParties).insert(IoPartiesCompanion.insert(
            caseId: caseId,
            role: role,
            name: name,
            valuesJson:
                Value(values == null ? null : jsonEncode(values)),
          ));

  Future<void> updateParty(int id,
          {String? name, Map<String, dynamic>? values}) =>
      (_db.update(_db.ioParties)..where((t) => t.id.equals(id))).write(
          IoPartiesCompanion(
        name: name == null ? const Value.absent() : Value(name),
        valuesJson:
            values == null ? const Value.absent() : Value(jsonEncode(values)),
      ));

  Future<void> deleteParty(int id) =>
      (_db.delete(_db.ioParties)..where((t) => t.id.equals(id))).go();

  // --- Exhibits ------------------------------------------------------------
  Stream<List<IoExhibit>> watchExhibits(int caseId) =>
      (_db.select(_db.ioExhibits)
            ..where((t) => t.caseId.equals(caseId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch();

  Future<int> addExhibit(int caseId, String description,
          {String? category, String? seizedFrom, double? value}) =>
      _db.into(_db.ioExhibits).insert(IoExhibitsCompanion.insert(
            caseId: caseId,
            description: description,
            category: Value(category),
            seizedFrom: Value(seizedFrom),
            value: Value(value),
          ));

  Future<void> updateExhibit(int id,
          {String? description,
          String? category,
          String? seizedFrom,
          double? value,
          Map<String, dynamic>? values}) =>
      (_db.update(_db.ioExhibits)..where((t) => t.id.equals(id))).write(
          IoExhibitsCompanion(
        description:
            description == null ? const Value.absent() : Value(description),
        category: Value(category),
        seizedFrom: Value(seizedFrom),
        value: Value(value),
        valuesJson:
            values == null ? const Value.absent() : Value(jsonEncode(values)),
      ));

  Future<void> deleteExhibit(int id) =>
      (_db.delete(_db.ioExhibits)..where((t) => t.id.equals(id))).go();

  // --- Media ---------------------------------------------------------------
  Stream<List<IoMediaData>> watchMedia(int caseId, {String? formId}) {
    final q = _db.select(_db.ioMedia)
      ..where((t) => t.caseId.equals(caseId))
      ..orderBy([(t) => OrderingTerm.desc(t.capturedAt)]);
    if (formId != null) q.where((t) => t.formId.equals(formId));
    return q.watch();
  }

  Future<int> addMedia(int caseId, String kind, String filePath,
          {String? formId, String? caption, double? lat, double? lng}) =>
      _db.into(_db.ioMedia).insert(IoMediaCompanion.insert(
            caseId: caseId,
            kind: kind,
            filePath: filePath,
            formId: Value(formId),
            caption: Value(caption),
            lat: Value(lat),
            lng: Value(lng),
          ));

  Future<void> deleteMedia(int id) =>
      (_db.delete(_db.ioMedia)..where((t) => t.id.equals(id))).go();

  // --- Sync (phone <-> central store <-> PC) -------------------------------
  Future<List<IoCase>> casesForOwner(String email) =>
      (_db.select(_db.ioCases)..where((t) => t.ownerEmail.equals(email))).get();

  Future<IoCase?> caseByUid(String uid) =>
      (_db.select(_db.ioCases)..where((t) => t.remoteUid.equals(uid)))
          .getSingleOrNull();

  Future<List<IoForm>> _forms(int caseId) =>
      (_db.select(_db.ioForms)..where((t) => t.caseId.equals(caseId))).get();
  Future<List<IoParty>> _parties(int caseId) =>
      (_db.select(_db.ioParties)..where((t) => t.caseId.equals(caseId))).get();
  Future<List<IoExhibit>> _exhibits(int caseId) =>
      (_db.select(_db.ioExhibits)..where((t) => t.caseId.equals(caseId))).get();

  /// One-shot reads (for form auto-fill, which needs a snapshot, not a stream).
  Future<List<IoParty>> partiesOnce(int caseId) => _parties(caseId);
  Future<List<IoExhibit>> exhibitsOnce(int caseId) => _exhibits(caseId);

  /// The scene GPS for a case — the most recent captured media that carries a
  /// location fix. Used to auto-place a map on the Crime Details form.
  Future<(double, double)?> sceneLatLng(int caseId) async {
    final m = await (_db.select(_db.ioMedia)
          ..where((t) => t.caseId.equals(caseId) & t.lat.isNotNull())
          ..orderBy([(t) => OrderingTerm.desc(t.capturedAt)])
          ..limit(1))
        .getSingleOrNull();
    if (m?.lat == null || m?.lng == null) return null;
    return (m!.lat!, m.lng!);
  }

  /// Serialises a case + its forms/parties/exhibits into a sync bundle. Scene
  /// media (binary files) are intentionally left out of the data sync.
  Future<Map<String, dynamic>> exportBundle(IoCase c) async {
    final forms = await _forms(c.id);
    final parties = await _parties(c.id);
    final exhibits = await _exhibits(c.id);
    return {
      'uid': c.remoteUid,
      'title': c.title,
      'crime_type': c.crimeType,
      'crime_category': c.crimeCategory,
      'fir_no': c.firNo,
      'year': c.year,
      'district': c.district,
      'police_station': c.policeStation,
      'status': c.status,
      'updated_at': c.updatedAt.toIso8601String(),
      'data': {
        'case': {
          'title': c.title,
          'crimeType': c.crimeType,
          'crimeCategory': c.crimeCategory,
          'firNo': c.firNo,
          'year': c.year,
          'district': c.district,
          'policeStation': c.policeStation,
          'linkedCrimeUid': c.linkedCrimeUid,
          'ownerEmail': c.ownerEmail,
          'status': c.status,
          'createdAt': c.createdAt.toIso8601String(),
          'updatedAt': c.updatedAt.toIso8601String(),
        },
        'forms': [
          for (final f in forms)
            {
              'formId': f.formId,
              'title': f.title,
              'valuesJson': f.valuesJson,
              'status': f.status,
            }
        ],
        'parties': [
          for (final p in parties)
            {
              'role': p.role,
              'name': p.name,
              'valuesJson': p.valuesJson,
              'sortOrder': p.sortOrder,
            }
        ],
        'exhibits': [
          for (final x in exhibits)
            {
              'description': x.description,
              'category': x.category,
              'seizedFrom': x.seizedFrom,
              'exhibitNo': x.exhibitNo,
              'value': x.value,
              'valuesJson': x.valuesJson,
              'sortOrder': x.sortOrder,
            }
        ],
      },
    };
  }

  /// Applies a pulled bundle: inserts a new case, or replaces the local one when
  /// the remote copy is newer (last-writer-wins on the case's updatedAt).
  Future<void> upsertFromBundle(Map<String, dynamic> bundle) async {
    final uid = bundle['uid']?.toString();
    final data = (bundle['data'] as Map?)?.cast<String, dynamic>();
    if (uid == null || data == null) return;
    final cm = (data['case'] as Map).cast<String, dynamic>();
    final remoteUpdated =
        DateTime.tryParse(cm['updatedAt']?.toString() ?? '') ?? DateTime.now();

    final existing = await caseByUid(uid);
    if (existing != null && !remoteUpdated.isAfter(existing.updatedAt)) {
      return; // local copy is same-or-newer
    }
    if (existing != null) await deleteCase(existing.id);

    final createdAt =
        DateTime.tryParse(cm['createdAt']?.toString() ?? '') ?? DateTime.now();
    final newId = await _db.into(_db.ioCases).insert(IoCasesCompanion.insert(
          remoteUid: uid,
          title: Value(cm['title'] as String?),
          crimeType: Value(cm['crimeType'] as String?),
          crimeCategory: Value(cm['crimeCategory'] as String?),
          firNo: Value(cm['firNo'] as String?),
          year: Value((cm['year'] as num?)?.toInt()),
          district: Value(cm['district'] as String?),
          policeStation: Value(cm['policeStation'] as String?),
          linkedCrimeUid: Value(cm['linkedCrimeUid'] as String?),
          ownerEmail: Value(cm['ownerEmail'] as String?),
          status: Value(cm['status']?.toString() ?? 'active'),
          createdAt: Value(createdAt),
          updatedAt: Value(remoteUpdated),
        ));

    for (final f in (data['forms'] as List? ?? [])) {
      final m = (f as Map).cast<String, dynamic>();
      await _db.into(_db.ioForms).insert(IoFormsCompanion.insert(
            caseId: newId,
            formId: m['formId'].toString(),
            title: Value(m['title'] as String?),
            valuesJson: Value(m['valuesJson'] as String?),
            status: Value(m['status']?.toString() ?? 'draft'),
          ));
    }
    for (final p in (data['parties'] as List? ?? [])) {
      final m = (p as Map).cast<String, dynamic>();
      await _db.into(_db.ioParties).insert(IoPartiesCompanion.insert(
            caseId: newId,
            role: m['role'].toString(),
            name: m['name'].toString(),
            valuesJson: Value(m['valuesJson'] as String?),
            sortOrder: Value((m['sortOrder'] as num?)?.toInt() ?? 0),
          ));
    }
    for (final x in (data['exhibits'] as List? ?? [])) {
      final m = (x as Map).cast<String, dynamic>();
      await _db.into(_db.ioExhibits).insert(IoExhibitsCompanion.insert(
            caseId: newId,
            description: m['description'].toString(),
            category: Value(m['category'] as String?),
            seizedFrom: Value(m['seizedFrom'] as String?),
            exhibitNo: Value(m['exhibitNo'] as String?),
            value: Value((m['value'] as num?)?.toDouble()),
            valuesJson: Value(m['valuesJson'] as String?),
            sortOrder: Value((m['sortOrder'] as num?)?.toInt() ?? 0),
          ));
    }
  }

  /// Two-way sync for the signed-in IO: push local cases, then pull + merge.
  Future<IoSyncOutcome> syncNow(String? email) async {
    if (email == null || email.isEmpty || !AccessConfig.isConfigured) {
      return IoSyncOutcome.offline;
    }
    final client = IoSyncClient();
    try {
      final locals = await casesForOwner(email);
      final bundles = [for (final c in locals) await exportBundle(c)];
      final saved = await client.push(email, bundles);
      final remote = await client.pull(email);
      for (final r in remote) {
        await upsertFromBundle(r);
      }
      return saved == null ? IoSyncOutcome.failed : IoSyncOutcome.ok;
    } catch (_) {
      return IoSyncOutcome.failed;
    } finally {
      client.dispose();
    }
  }
}

/// Result of a sync attempt (drives the toast in the shell).
enum IoSyncOutcome { ok, failed, offline }

final ioRepositoryProvider = Provider<IoRepository>(
    (ref) => IoRepository(ref.watch(databaseProvider)));

/// The signed-in IO's cases (own cases only).
final ioCasesProvider = StreamProvider<List<IoCase>>((ref) {
  final email = ref.watch(authControllerProvider).value?.email;
  return ref.watch(ioRepositoryProvider).watchCases(email);
});

final ioCaseProvider =
    StreamProvider.family<IoCase?, int>((ref, id) =>
        ref.watch(ioRepositoryProvider).watchCase(id));

final ioFormsProvider = StreamProvider.family<List<IoForm>, int>(
    (ref, caseId) => ref.watch(ioRepositoryProvider).watchForms(caseId));

final ioPartiesProvider = StreamProvider.family<List<IoParty>, int>(
    (ref, caseId) => ref.watch(ioRepositoryProvider).watchParties(caseId));

final ioExhibitsProvider = StreamProvider.family<List<IoExhibit>, int>(
    (ref, caseId) => ref.watch(ioRepositoryProvider).watchExhibits(caseId));

final ioMediaProvider = StreamProvider.family<List<IoMediaData>, int>(
    (ref, caseId) => ref.watch(ioRepositoryProvider).watchMedia(caseId));
