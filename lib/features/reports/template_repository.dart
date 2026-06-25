import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import '../../data/db/database_provider.dart';

/// CRUD for user-created report templates (the `report_templates` table).
/// `template_json` holds the same JSON shape the engine consumes.
class TemplateRepository {
  TemplateRepository(this._db);

  final AppDatabase _db;

  Stream<List<ReportTemplateRow>> watchAll() {
    return (_db.select(_db.reportTemplates)
          ..orderBy([(t) => OrderingTerm(expression: t.name)]))
        .watch();
  }

  Future<ReportTemplateRow?> getById(int id) {
    return (_db.select(_db.reportTemplates)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Insert (id == null) or update an existing template. Returns its id.
  Future<int> upsert({
    int? id,
    required String name,
    String? description,
    required String templateJson,
    String outputFormat = 'docx',
    String? createdBy,
  }) async {
    if (id == null) {
      return _db.into(_db.reportTemplates).insert(
            ReportTemplatesCompanion.insert(
              name: name,
              templateJson: templateJson,
              description: Value(description),
              outputFormat: Value(outputFormat),
              isSystem: const Value(false),
              createdBy: Value(createdBy),
            ),
          );
    }
    await (_db.update(_db.reportTemplates)..where((t) => t.id.equals(id))).write(
      ReportTemplatesCompanion(
        name: Value(name),
        description: Value(description),
        templateJson: Value(templateJson),
        outputFormat: Value(outputFormat),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return id;
  }

  Future<void> delete(int id) {
    return (_db.delete(_db.reportTemplates)..where((t) => t.id.equals(id)))
        .go();
  }
}

final templateRepositoryProvider = Provider<TemplateRepository>(
  (ref) => TemplateRepository(ref.watch(databaseProvider)),
);

/// Live list of user-created templates.
final dbTemplatesProvider = StreamProvider<List<ReportTemplateRow>>(
  (ref) => ref.watch(templateRepositoryProvider).watchAll(),
);
