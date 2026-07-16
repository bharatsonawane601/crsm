// FORM "E" — मोडस ऑपरेंडी ब्युरोला पुरविण्यात यावयाची माहिती (Modus Operandi
// Bureau information). An exact 18-row replica; the FIR-derived rows auto-fill,
// the modus-operandi rows are filled by the IO. Pure Dart (no Flutter) so it is
// unit-testable and shared by the on-screen view, the PDF and the Word export.

import '../../../data/db/database.dart';
import '../../crime_entry/models/crime_draft.dart';

const String kMoFormEId = 'mo_form_e';

/// One numbered row of Form "E".
class MoRow {
  const MoRow(this.id, this.number, this.mr);
  final String id;
  final int number;
  final String mr;
}

/// The 18 rows, in the exact order and wording of the printed form.
const List<MoRow> kMoFormERows = [
  MoRow('policeStation', 1, 'पोलीस स्टेशन'),
  MoRow('complainant', 2, 'तक्रार दाखल करणाऱ्याचे नांव व पत्ता'),
  MoRow('place', 3, 'गुन्हा घडला ते शहर अथवा गांव ई.'),
  MoRow('dateOccurred', 4, 'गुन्हा घडल्याची तारीख'),
  MoRow('firAndSection', 5, 'अप क्रमांक व कलम'),
  MoRow('stolenValue', 6, 'चोरीस गेलेल्या मालमत्तेची किंमत'),
  MoRow('recoveredValue', 7,
      'परत मिळालेल्या मालमत्तेची किंमत (मालमत्ता कोणाकडून व कोणत्या ठिकाणी परत मिळाली)'),
  MoRow('victimClass', 8,
      'ज्याच्यावर हमला करण्यात आला त्या ईसमाचा अथवा मिळकतीचा वर्ग'),
  MoRow('meansToReach', 9,
      'गुन्ह्याच्या जागी पोहचण्याकरीता उपयोगात आणलेले साधन'),
  MoRow('method', 10, 'गुन्हा करण्यासाठी वापरलेली रीत'),
  MoRow('instrument', 11, 'गुन्हा करण्यासाठी वापरलेले साधन'),
  MoRow('timeOfDay', 12, 'दिवसाचा वेळ'),
  MoRow('associates', 13, 'साथीदार'),
  MoRow('vehicle', 14, 'वाहन'),
  MoRow('identifyingMark', 15, 'विशिष्ट निदर्शक खुण'),
  MoRow('style', 16, 'शैली'),
  MoRow('intentStatement', 17,
      'रचुन सांगीतलेली हकीकत, गुन्हाकरण्याबाबत केलेले हेतुनिवेदन'),
  MoRow('briefFacts', 18, 'गुन्ह्यासंबंधीत थोडक्यात हकीकत'),
];

String _money(double v) => '₹ ${v.toStringAsFixed(0)}';

String _date(DateTime? d) =>
    d == null ? '' : '${d.day}/${d.month}/${d.year}';

/// Auto-fills Form "E" from the available sources. Rows the FIR can't provide
/// (the modus-operandi fields) are left blank for the IO. [fir] is the linked
/// FIR draft when found; [parties]/[exhibits] are the IO case's own entries and
/// act as a fallback when there is no linked FIR.
Map<String, String> buildMoFormEValues({
  required IoCase ioCase,
  CrimeDraft? fir,
  List<IoParty> parties = const [],
  List<IoExhibit> exhibits = const [],
}) {
  final v = <String, String>{};

  // 1. Police station.
  v['policeStation'] =
      (ioCase.policeStation?.trim().isNotEmpty ?? false)
          ? ioCase.policeStation!
          : (fir?.policeStation ?? '');

  // 2. Complainant name + address.
  if (fir != null && fir.complainant.name.trim().isNotEmpty) {
    final c = fir.complainant;
    v['complainant'] =
        [c.name, c.address].where((s) => (s ?? '').trim().isNotEmpty).join(', ');
  } else {
    final comp = parties.where((p) => p.role == 'complainant');
    v['complainant'] = comp.isEmpty ? '' : comp.first.name;
  }

  // 3. City / village of occurrence.
  v['place'] = fir?.placeOccurred ?? '';

  // 4. Date of occurrence (single day, or a from–to window).
  final d1 = _date(fir?.dateOccurred);
  final d2 = _date(fir?.dateOccurredTo);
  v['dateOccurred'] = d2.isEmpty ? d1 : '$d1 ते $d2';

  // 5. FIR number + sections.
  final firNo = fir?.firNo ?? ioCase.firNo ?? '';
  final year = fir?.year ?? ioCase.year;
  final sec = [fir?.section, fir?.subSection]
      .where((s) => (s ?? '').trim().isNotEmpty)
      .join(' ');
  v['firAndSection'] = [
    if (firNo.isNotEmpty) '$firNo${year != null ? '/$year' : ''}',
    if (sec.isNotEmpty) sec,
  ].join('  ');

  // 6. Value of stolen property.
  final stolenSum = (fir?.stolen ?? [])
      .fold<double>(0, (a, s) => a + (s.value ?? 0));
  v['stolenValue'] = stolenSum > 0 ? _money(stolenSum) : '';

  // 7. Value of recovered property (with from-whom / where).
  final recovered = fir?.recovered ?? [];
  if (recovered.isNotEmpty) {
    final sum = recovered.fold<double>(0, (a, r) => a + (r.value ?? 0));
    final detail = recovered
        .map((r) => [
              r.description,
              if (r.recoveryDate != null) _date(r.recoveryDate),
            ].where((s) => (s ?? '').toString().trim().isNotEmpty).join(' '))
        .where((s) => s.trim().isNotEmpty)
        .join('; ');
    v['recoveredValue'] =
        [if (sum > 0) _money(sum), if (detail.isNotEmpty) detail].join(' — ');
  } else if (exhibits.isNotEmpty) {
    final sum = exhibits.fold<double>(0, (a, x) => a + (x.value ?? 0));
    final detail = exhibits
        .map((x) => [
              x.description,
              if ((x.seizedFrom ?? '').trim().isNotEmpty) '(${x.seizedFrom})',
            ].join(' '))
        .join('; ');
    v['recoveredValue'] =
        [if (sum > 0) _money(sum), detail].where((s) => s.isNotEmpty).join(' — ');
  } else {
    v['recoveredValue'] = '';
  }

  // 12. Time of day of occurrence.
  final t1 = fir?.timeOccurred ?? '';
  final t2 = fir?.timeOccurredTo ?? '';
  v['timeOfDay'] = t2.isEmpty ? t1 : '$t1 ते $t2';

  // 13. Associates (accused / co-accused).
  final accusedNames = (fir?.accused ?? [])
      .map((a) => a.name)
      .where((n) => n.trim().isNotEmpty)
      .toList();
  if (accusedNames.isNotEmpty) {
    v['associates'] = accusedNames.join(', ');
  } else {
    final acc = parties.where((p) => p.role == 'accused').map((p) => p.name);
    v['associates'] = acc.join(', ');
  }

  // 18. Brief facts of the crime.
  v['briefFacts'] = fir?.detailedDescription ?? '';

  // Modus-operandi rows the FIR can't provide — left blank for the IO to fill:
  // victimClass(8), meansToReach(9), method(10), instrument(11), vehicle(14),
  // identifyingMark(15), style(16), intentStatement(17).
  for (final id in [
    'victimClass',
    'meansToReach',
    'method',
    'instrument',
    'vehicle',
    'identifyingMark',
    'style',
    'intentStatement',
  ]) {
    v.putIfAbsent(id, () => '');
  }

  return v;
}
