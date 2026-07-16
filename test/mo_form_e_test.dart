import 'package:flutter_test/flutter_test.dart';

import 'package:crms/data/db/database.dart';
import 'package:crms/features/crime_entry/models/crime_draft.dart';
import 'package:crms/features/io/forms/mo_form_e_model.dart';

IoCase _case({String? firNo, int? year, String? ps}) => IoCase(
      id: 1,
      remoteUid: 'io_x',
      status: 'active',
      firNo: firNo,
      year: year,
      policeStation: ps,
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

void main() {
  test('Form "E" has exactly the 18 printed rows in order', () {
    expect(kMoFormERows.length, 18);
    expect(kMoFormERows.first.mr, 'पोलीस स्टेशन');
    expect(kMoFormERows.last.number, 18);
  });

  test('auto-fills FIR-derived rows and leaves MO rows blank', () {
    final fir = CrimeDraft(
      firNo: '123',
      year: 2026,
      section: '303(2) BNS',
      placeOccurred: 'CIDCO',
      dateOccurred: DateTime(2026, 5, 4),
      timeOccurred: '22:00',
      detailedDescription: 'रात्री घरफोडी झाली.',
      complainant: PersonDraft(name: 'राम', address: 'एन-७'),
      accused: [AccusedDraft(name: 'श्याम')],
      stolen: [StolenItemDraft(value: 50000)],
      recovered: [RecoveredItemDraft(value: 20000, description: 'सोने')],
    );

    final v = buildMoFormEValues(ioCase: _case(ps: 'CIDCO'), fir: fir);

    expect(v['policeStation'], 'CIDCO');
    expect(v['complainant'], 'राम, एन-७');
    expect(v['place'], 'CIDCO');
    expect(v['dateOccurred'], '4/5/2026');
    expect(v['firAndSection'], contains('123/2026'));
    expect(v['firAndSection'], contains('303(2) BNS'));
    expect(v['stolenValue'], '₹ 50000');
    expect(v['recoveredValue'], contains('₹ 20000'));
    expect(v['associates'], 'श्याम');
    expect(v['briefFacts'], 'रात्री घरफोडी झाली.');

    // Modus-operandi rows the FIR can't provide stay blank for the IO.
    for (final id in ['victimClass', 'meansToReach', 'method', 'instrument',
        'vehicle', 'identifyingMark', 'style', 'intentStatement']) {
      expect(v[id], '', reason: '$id should be blank');
    }
  });

  test('falls back to case parties/exhibits when there is no FIR', () {
    final v = buildMoFormEValues(
      ioCase: _case(ps: 'Kranti Chowk'),
      parties: [
        IoParty(id: 1, caseId: 1, role: 'complainant', name: 'सीता', sortOrder: 0),
        IoParty(id: 2, caseId: 1, role: 'accused', name: 'रावण', sortOrder: 0),
      ],
      exhibits: [
        IoExhibit(
            id: 1,
            caseId: 1,
            description: 'मोबाईल',
            value: 15000,
            seizedFrom: 'रावण',
            sortOrder: 0),
      ],
    );
    expect(v['policeStation'], 'Kranti Chowk');
    expect(v['complainant'], 'सीता');
    expect(v['associates'], 'रावण');
    expect(v['recoveredValue'], contains('₹ 15000'));
  });
}
