import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/crime_entry/models/crime_draft.dart';
import 'package:crms/features/reports/engine.dart';
import 'package:crms/features/reports/models/report_template.dart';

void main() {
  const engine = TemplateEngine();

  CrimeDraft draft() {
    final d = CrimeDraft(firNo: '123', year: 2026, section: '379');
    d.district = 'Pune';
    d.complainant
      ..name = 'Ramesh'
      ..age = 40
      ..address = 'Kothrud'
      ..mobile = '9876543210';
    d.accused.add(AccusedDraft(name: 'Suresh', age: 30));
    d.accused.add(AccusedDraft(name: 'Mahesh', age: 25));
    d.stolen.add(StolenItemDraft(description: 'Phone'));
    d.stolen.add(StolenItemDraft(description: 'Cash'));
    return d;
  }

  group('placeholders', () {
    test('simple + combined placeholders with literal text', () {
      final ctx = ReportContext.fromDraft(draft());
      final out = engine.renderValue(
        '{crime.fir_no}/{crime.year} कलम {crime.section}',
        ctx,
      );
      expect(out, '123/2026 कलम 379');
    });

    test('missing value resolves to empty string', () {
      final ctx = ReportContext.fromDraft(draft());
      expect(engine.renderValue('{crime.nonexistent}', ctx), '');
    });

    test('loop over accused joins items with comma', () {
      final ctx = ReportContext.fromDraft(draft());
      final out = engine.renderValue('{#accused}{name} वय-{age}{/accused}', ctx);
      expect(out, 'Suresh वय-30, Mahesh वय-25');
    });

    test('loop over stolen property descriptions', () {
      final ctx = ReportContext.fromDraft(draft());
      final out = engine.renderValue(
          '{#stolen_property}{description}{/stolen_property}', ctx);
      expect(out, 'Phone, Cash');
    });

    test('empty loop yields empty -> fallback applies at row level', () {
      final d = draft()..accused.clear();
      final ctx = ReportContext.fromDraft(d);
      final template = ReportTemplate.fromJson({
        'name': 'T',
        'rows': [
          {
            'sr': 1,
            'label': 'आरोपी',
            'value': '{#accused}{name}{/accused}',
            'fallback': 'अनोळखी',
          },
        ],
      });
      final report = engine.render(template, ctx);
      expect(report.rows.single.value, 'अनोळखी');
    });
  });

  test('renders a full B-Patrak-style template end to end', () {
    final ctx = ReportContext.fromDraft(draft());
    final template = ReportTemplate.fromJson({
      'name': 'ब पत्रक',
      'header': 'ब पत्रक',
      'page_size': 'A4',
      'rows': [
        {'sr': 1, 'label': 'गु.र.नं.', 'value': '{crime.fir_no}/{crime.year}'},
        {
          'sr': 2,
          'label': 'फिर्यादी',
          'value': '{complainant.name} वय-{complainant.age}',
        },
        {
          'sr': 3,
          'label': 'आरोपी',
          'value': '{#accused}{name}{/accused}',
          'fallback': 'अनोळखी',
        },
      ],
    });

    final report = engine.render(template, ctx);
    expect(report.header, 'ब पत्रक');
    expect(report.rows, hasLength(3));
    expect(report.rows[0].value, '123/2026');
    expect(report.rows[1].value, 'Ramesh वय-40');
    expect(report.rows[2].value, 'Suresh, Mahesh');
  });
}
