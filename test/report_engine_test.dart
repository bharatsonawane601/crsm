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

    test('{sn} numbers each accused in the loop (ब पत्रक serial)', () {
      final ctx = ReportContext.fromDraft(draft());
      final out = engine.renderValue('{#accused}{sn}) {name}{/accused}', ctx);
      expect(out, '1) Suresh, 2) Mahesh');
    });

    test('station.name_marathi folds an English station to Marathi', () {
      final ctx = ReportContext.fromDraft(
        draft(),
        station: const {'name_english': 'City Chowk'},
      );
      expect(engine.renderValue('{station.name_marathi}', ctx), 'सिटी चौक');
    });

    test('station.name_marathi passes an unknown name through unchanged', () {
      final ctx = ReportContext.fromDraft(
        draft(),
        station: const {'name_english': 'Somewhere Else'},
      );
      expect(engine.renderValue('{station.name_marathi}', ctx),
          'Somewhere Else');
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

  group('time of offence range', () {
    test('joins from + to with "ते"', () {
      final d = draft()
        ..timeOccurred = '1 PM'
        ..timeOccurredTo = '2 PM';
      final ctx = ReportContext.fromDraft(d);
      expect(engine.renderValue('{crime.time_occurred_range}', ctx), '1 PM ते 2 PM');
    });

    test('single time when only "from" is set', () {
      final d = draft()..timeOccurred = '1 PM';
      final ctx = ReportContext.fromDraft(d);
      expect(engine.renderValue('{crime.time_occurred_range}', ctx), '1 PM');
    });

    test('empty when neither end is set', () {
      final ctx = ReportContext.fromDraft(draft());
      expect(engine.renderValue('{crime.time_occurred_range}', ctx), '');
    });
  });

  group('date of offence range', () {
    test('joins from + to dates with "ते"', () {
      final d = draft()
        ..dateOccurred = DateTime(2026, 1, 1)
        ..dateOccurredTo = DateTime(2026, 1, 3);
      final ctx = ReportContext.fromDraft(d);
      expect(engine.renderValue('{crime.date_occurred_range}', ctx),
          '01-01-2026 ते 03-01-2026');
    });

    test('single date when both ends are the same / only one is set', () {
      final d = draft()..dateOccurred = DateTime(2026, 1, 1);
      final ctx = ReportContext.fromDraft(d);
      expect(engine.renderValue('{crime.date_occurred_range}', ctx),
          '01-01-2026');
    });
  });

  group('stolen property total', () {
    test('sums all stolen values into a total label', () {
      final d = CrimeDraft(firNo: '1', year: 2026);
      d.stolen.add(StolenItemDraft(description: 'Phone', value: 15000));
      d.stolen.add(StolenItemDraft(description: 'Cash', value: 30000));
      final ctx = ReportContext.fromDraft(d);
      expect(engine.renderValue('{stolen_total}', ctx), '45000');
      expect(engine.renderValue('{stolen_total_label}', ctx),
          '(एकूण किंमत 45000/-)');
    });

    test('no total label when nothing has a value', () {
      final d = CrimeDraft(firNo: '1', year: 2026);
      d.stolen.add(StolenItemDraft(description: 'Phone'));
      final ctx = ReportContext.fromDraft(d);
      expect(engine.renderValue('{stolen_total_label}', ctx), '');
    });
  });

  group('person age + status label', () {
    test('age prints the free-form ageText (e.g. 19.4) when set', () {
      final d = CrimeDraft(firNo: '1', year: 2026);
      d.complainant
        ..name = 'Ramesh'
        ..age = 19
        ..ageText = '19.4';
      final ctx = ReportContext.fromDraft(d);
      expect(engine.renderValue('{complainant.age}', ctx), '19.4');
    });

    test('age falls back to the integer when ageText is blank', () {
      final d = CrimeDraft(firNo: '1', year: 2026);
      d.complainant
        ..name = 'Ramesh'
        ..age = 40;
      final ctx = ReportContext.fromDraft(d);
      expect(engine.renderValue('{complainant.age}', ctx), '40');
    });

    test('status_label is Marathi उघड / अनउघड', () {
      final det = ReportContext.fromDraft(
          CrimeDraft(firNo: '1', year: 2026, status: 'detected'));
      expect(engine.renderValue('{crime.status_label}', det), 'उघड');
      final und = ReportContext.fromDraft(
          CrimeDraft(firNo: '1', year: 2026, status: 'undetected'));
      expect(engine.renderValue('{crime.status_label}', und), 'अनउघड');
      // Legacy 'solved' still maps to उघड.
      final legacy = ReportContext.fromDraft(
          CrimeDraft(firNo: '1', year: 2026, status: 'solved'));
      expect(engine.renderValue('{crime.status_label}', legacy), 'उघड');
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
