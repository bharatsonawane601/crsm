import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/db/database.dart';
import 'report_service.dart' show kBundledTemplates;
import 'template_repository.dart';

/// A template the user can pick in the "Generate Report" sheet — either a
/// bundled (system) template loaded from assets, or a user-created one from the
/// DB.
class TemplateChoice {
  const TemplateChoice({
    required this.key,
    required this.displayName,
    required this.isSystem,
    required this.defaultFormat,
    this.assetPath,
    this.dbId,
  });

  factory TemplateChoice.bundled(String id, String name, String assetPath) =>
      TemplateChoice(
        key: 'asset:$id',
        displayName: name,
        isSystem: true,
        defaultFormat: 'docx',
        assetPath: assetPath,
      );

  factory TemplateChoice.db(ReportTemplateRow row) => TemplateChoice(
        key: 'db:${row.id}',
        displayName: row.name,
        isSystem: row.isSystem,
        defaultFormat: row.outputFormat,
        dbId: row.id,
      );

  final String key;
  final String displayName;
  final bool isSystem;
  final String defaultFormat;
  final String? assetPath;
  final int? dbId;
}

/// All templates available to generate from: bundled first, then DB templates.
final templateChoicesProvider = Provider<List<TemplateChoice>>((ref) {
  final dbRows = ref.watch(dbTemplatesProvider).value ?? const [];
  return [
    for (final b in kBundledTemplates)
      TemplateChoice.bundled(b.id, b.displayName, b.assetPath),
    for (final r in dbRows) TemplateChoice.db(r),
  ];
});
