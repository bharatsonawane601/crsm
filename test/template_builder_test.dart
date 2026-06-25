import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crms/data/db/database.dart';
import 'package:crms/features/crime_entry/models/crime_draft.dart';
import 'package:crms/features/reports/engine.dart';
import 'package:crms/features/reports/models/report_template.dart';
import 'package:crms/features/reports/template_repository.dart';
import 'package:crms/features/template_builder/template_draft.dart';

void main() {
  group('TemplateDraft JSON', () {
    test('round-trips and assigns sr by row position', () {
      final draft = TemplateDraft(
        name: 'My B-Patrak',
        header: 'ब पत्रक',
        pageSize: 'A4',
        rows: [
          TemplateRowDraft(label: 'गु.र.नं.', value: '{crime.fir_no}'),
          TemplateRowDraft(
              label: 'आरोपी',
              value: '{#accused}{name}{/accused}',
              fallback: 'अनोळखी'),
        ],
      );

      final restored = TemplateDraft.fromJsonString(draft.toJsonString());
      expect(restored.name, 'My B-Patrak');
      expect(restored.header, 'ब पत्रक');
      expect(restored.rows, hasLength(2));
      expect(restored.rows[1].value, '{#accused}{name}{/accused}');
      expect(restored.rows[1].fallback, 'अनोळखी');

      final json = draft.toJson();
      final rows = json['rows'] as List;
      expect((rows[0] as Map)['sr'], 1);
      expect((rows[1] as Map)['sr'], 2);
    });

    test('empty header falls back to the template name', () {
      final json = TemplateDraft(name: 'X', header: '').toJson();
      expect(json['header'], 'X');
    });
  });

  group('TemplateRepository', () {
    late AppDatabase db;
    late TemplateRepository repo;

    setUp(() {
      db = AppDatabase.forTesting(NativeDatabase.memory());
      repo = TemplateRepository(db);
    });
    tearDown(() => db.close());

    test('insert, update, fetch and delete', () async {
      final id = await repo.upsert(name: 'T1', templateJson: '{"name":"T1"}');
      var row = await repo.getById(id);
      expect(row, isNotNull);
      expect(row!.name, 'T1');
      expect(row.isSystem, isFalse);

      await repo.upsert(id: id, name: 'T1-edited', templateJson: '{"name":"x"}');
      row = await repo.getById(id);
      expect(row!.name, 'T1-edited');

      await repo.delete(id);
      expect(await repo.getById(id), isNull);
    });
  });

  test('a saved DB template renders through the engine', () async {
    // Build a template in the builder, serialize it as it would be stored.
    final draft = TemplateDraft(
      name: 'Mini',
      header: 'Mini Report',
      rows: [
        TemplateRowDraft(label: 'FIR', value: '{crime.fir_no}/{crime.year}'),
        TemplateRowDraft(
            label: 'Accused',
            value: '{#accused}{name}{/accused}',
            fallback: 'unknown'),
      ],
    );
    final storedJson = draft.toJsonString();

    // Later, the report service parses that JSON and renders it.
    final template = ReportTemplate.fromJson(
      jsonDecode(storedJson) as Map<String, dynamic>,
    );

    final crime = CrimeDraft(firNo: '77', year: 2026)
      ..accused.add(AccusedDraft(name: 'Ravi'));
    final report = const TemplateEngine()
        .render(template, ReportContext.fromDraft(crime));

    expect(report.header, 'Mini Report');
    expect(report.rows[0].value, '77/2026');
    expect(report.rows[1].value, 'Ravi');
  });
}
