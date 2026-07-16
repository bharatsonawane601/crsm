import 'package:flutter_test/flutter_test.dart';

import 'package:crms/data/db/database.dart';
import 'package:crms/features/crime_entry/models/crime_draft.dart';
import 'package:crms/features/io/forms/seizure_form_model.dart';

IoCase _case({String? firNo, int? year, String? ps, String? district}) => IoCase(
      id: 1,
      remoteUid: 'io_x',
      status: 'active',
      firNo: firNo,
      year: year,
      policeStation: ps,
      district: district,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

void main() {
  test('every declared field has a value key after auto-fill', () {
    final v = buildSeizureValues(ioCase: _case());
    for (final f in kSeizureFields) {
      expect(v.containsKey(f.id), isTrue, reason: '${f.id} missing');
    }
  });

  test('auto-fills header, sections, seized-from and IO from the FIR', () {
    final fir = CrimeDraft(
      firNo: '77',
      year: 2026,
      district: 'यवतमाळ',
      policeStation: 'CIDCO',
      section: '303(2) BNS',
      placeOccurred: 'बसस्थानक',
      dateRegistered: DateTime(2026, 6, 1),
      accused: [
        AccusedDraft(
            name: 'श्याम',
            relativeName: 'राम',
            gender: 'पुरुष',
            age: 30,
            address: 'एन-५')
      ],
      investigation: InvestigationDraft(
          officerName: 'PSI पाटील',
          officerDesignation: 'PSI',
          officerId: '1234'),
    );

    final v = buildSeizureValues(ioCase: _case(ps: 'CIDCO'), fir: fir);

    expect(v['district'], 'यवतमाळ');
    expect(v['policeStation'], 'CIDCO');
    expect(v['year'], '2026');
    expect(v['firNo'], '77');
    expect(v['firDate'], '1/6/2026');
    expect(v['actsSections'], '303(2) BNS');
    expect(v['placeSeized'], 'बसस्थानक');
    expect(v['receiverName'], 'श्याम');
    expect(v['receiverFather'], 'राम');
    expect(v['receiverAge'], '30');
    expect(v['ioName'], 'PSI पाटील');
    expect(v['ioBuckle'], '1234');
  });

  test('property rows come from the case exhibits', () {
    final rows = seizurePropertyRows(exhibits: [
      IoExhibit(
          id: 1,
          caseId: 1,
          description: 'मोबाईल',
          value: 15000,
          seizedFrom: 'श्याम',
          sortOrder: 0),
    ]);
    expect(rows.length, 1);
    expect(rows.first.description, contains('मोबाईल'));
    expect(rows.first.description, contains('₹15000'));
  });
}
