import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/io/io_forms_catalog.dart';

void main() {
  test('every case gets the always-on forms', () {
    for (final cat in [null, 'Theft / चोरी', 'Murder / खून']) {
      final ids = suggestedForms(cat).map((f) => f.id).toSet();
      expect(ids, containsAll(['scene_panchnama', 'final_report', 'notice_35_3']),
          reason: 'always-on forms missing for $cat');
    }
  });

  test('theft surfaces the seizure sub-kit, not the inquest', () {
    final ids = suggestedForms('Theft / चोरी').map((f) => f.id).toSet();
    expect(ids, contains('seizure_panchnama'));
    expect(ids, contains('property_receipt'));
    expect(ids, contains('house_search'));
    expect(ids, isNot(contains('inquest')));
    expect(ids, isNot(contains('pm_request')));
  });

  test('a death crime surfaces the inquest sub-kit', () {
    final ids = suggestedForms('Murder / खून').map((f) => f.id).toSet();
    expect(ids, containsAll(['inquest', 'pm_request', 'body_receipt']));
  });

  test('sexual offences surface the DNA + medical forms', () {
    final ids =
        suggestedForms('Sexual Offences / लैंगिक गुन्हे').map((f) => f.id).toSet();
    expect(ids, contains('dna_form'));
    expect(ids, contains('medical_exam'));
  });

  test('suggested and other forms partition the catalogue with no overlap', () {
    const cat = 'Theft / चोरी';
    final suggested = suggestedForms(cat).map((f) => f.id).toSet();
    final other = otherForms(cat).map((f) => f.id).toSet();
    expect(suggested.intersection(other), isEmpty);
    expect(suggested.union(other).length, kIoForms.length);
  });

  test('every form id is unique and every form has fields', () {
    final ids = kIoForms.map((f) => f.id).toList();
    expect(ids.toSet().length, ids.length, reason: 'duplicate form id');
    for (final f in kIoForms) {
      expect(f.fields, isNotEmpty, reason: '${f.id} has no fields');
    }
  });
}
