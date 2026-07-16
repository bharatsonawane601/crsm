// PROPERTY SEARCH & SEIZURE FORM — मालमत्ता शोध व जप्तीचा नमुना (Search /
// Production / Recovery u/s 185 BNSS). An exact replica; FIR-derived fields
// auto-fill, the rest are filled by the IO. Pure Dart (no Flutter) so it is
// unit-testable and shared by the on-screen view, the PDF and the Word export.

import '../../../data/db/database.dart';
import '../../crime_entry/models/crime_draft.dart';

/// This form reuses the existing "seizure panchnama" catalogue id so it stays
/// in the crime → forms mapping (property crimes) with no extra entry.
const String kSeizureFormId = 'seizure_panchnama';

/// One editable field on the form.
class SeizureField {
  const SeizureField(this.id, this.mr, this.en, {this.multiline = false});
  final String id;
  final String mr;
  final String en;
  final bool multiline;
}

/// A titled group of fields (drives the editor's sections).
class SeizureGroup {
  const SeizureGroup(this.titleMr, this.titleEn, this.fields);
  final String titleMr;
  final String titleEn;
  final List<SeizureField> fields;
}

/// The full field set, grouped. Ids are stable (persisted in the form's JSON).
const List<SeizureGroup> kSeizureGroups = [
  SeizureGroup('मथळा', 'Header', [
    SeizureField('district', 'जिल्हा', 'District'),
    SeizureField('policeStation', 'पोलीस ठाणे', 'Police Station'),
    SeizureField('year', 'वर्षे', 'Year'),
    SeizureField('firNo', 'पहिली खबर क्र./कार्यवाही', 'FIR / Action No.'),
    SeizureField('firDate', 'दिनांक', 'Date'),
    SeizureField('actsSections', 'अधिनियम व कलमे', 'Acts & Sections'),
  ]),
  SeizureGroup('जप्त मालमत्ता', 'Seized property', [
    SeizureField('natureOfProperty', 'मालमत्तेचे स्वरूप',
        'Nature (stolen / unclaimed / illegal possession …)'),
    SeizureField('seizureDate', 'जप्तीची तारीख', 'Seizure date'),
    SeizureField('seizureTime', 'जप्तीची वेळ', 'Seizure time'),
    SeizureField('placeSeized', 'जेथून जप्त/परत मिळाली ती जागा',
        'Place seized / recovered'),
    SeizureField('placeDescription', 'जागेचे वर्णन', 'Description of place',
        multiline: true),
  ]),
  SeizureGroup('कोणाकडून जप्त केली', 'Seized from', [
    SeizureField('receiverProfessional', 'चोरीचा माल घेणारा धंदेवाईक (होय/नाही)',
        'Professional receiver (Yes/No)'),
    SeizureField('receiverName', 'नाव', 'Name'),
    SeizureField('receiverFather', 'पित्याचे/पतीचे नाव', 'Father/Husband name'),
    SeizureField('receiverGender', 'लिंग', 'Gender'),
    SeizureField('receiverAge', 'वय', 'Age'),
    SeizureField('receiverOccupation', 'व्यवसाय', 'Occupation'),
    SeizureField('receiverAddress', 'पत्ता', 'Address'),
  ]),
  SeizureGroup('साक्षीदार १', 'Witness 1', [
    SeizureField('w1Name', 'नाव', 'Name'),
    SeizureField('w1Father', 'पित्याचे/पतीचे नाव', 'Father/Husband name'),
    SeizureField('w1Gender', 'लिंग', 'Gender'),
    SeizureField('w1Age', 'वय', 'Age'),
    SeizureField('w1Occupation', 'व्यवसाय', 'Occupation'),
    SeizureField('w1Address', 'पत्ता', 'Address'),
  ]),
  SeizureGroup('साक्षीदार २', 'Witness 2', [
    SeizureField('w2Name', 'नाव', 'Name'),
    SeizureField('w2Father', 'पित्याचे/पतीचे नाव', 'Father/Husband name'),
    SeizureField('w2Gender', 'लिंग', 'Gender'),
    SeizureField('w2Age', 'वय', 'Age'),
    SeizureField('w2Occupation', 'व्यवसाय', 'Occupation'),
    SeizureField('w2Address', 'पत्ता', 'Address'),
  ]),
  SeizureGroup('शिफारशी', 'Recommendations', [
    SeizureField('perishableRec', 'नाशवंत मालमत्तेच्या विल्हेवाटीसाठी शिफारस/कार्यवाही',
        'Perishable property disposal', multiline: true),
    SeizureField('valuableRec', 'मौल्यवान मालमत्ता ठेवण्यासाठी शिफारस/कार्यवाही',
        'Valuable property storage', multiline: true),
    SeizureField('identificationNeeded', 'ओळख पटवावी लागली काय (होय/नाही)',
        'Identification needed (Yes/No)'),
    SeizureField('circumstances', 'जप्तीची परिस्थिती/कारणे',
        'Circumstances / reasons of seizure', multiline: true),
  ]),
  SeizureGroup('पंच', 'Panch', [
    SeizureField('panch1Name', 'पंच १ नाव', 'Panch 1 name'),
    SeizureField('panch1Address', 'पंच १ पत्ता', 'Panch 1 address'),
    SeizureField('panch2Name', 'पंच २ नाव', 'Panch 2 name'),
    SeizureField('panch2Address', 'पंच २ पत्ता', 'Panch 2 address'),
  ]),
  SeizureGroup('तपासी अंमलदार', 'Investigating Officer', [
    SeizureField('ioName', 'नाव', 'Name'),
    SeizureField('ioRank', 'पदनाम', 'Rank'),
    SeizureField('ioBuckle', 'बक्कल नंबर', 'Buckle No.'),
    SeizureField('formDate', 'दिनांक', 'Date'),
  ]),
];

/// Flat list of every field (for the editor + merge).
List<SeizureField> get kSeizureFields =>
    [for (final g in kSeizureGroups) ...g.fields];

String _date(DateTime? d) =>
    d == null ? '' : '${d.day}/${d.month}/${d.year}';

/// Auto-fills the form from the linked FIR (+ the IO case's own parties /
/// exhibits as a fallback). FIR-less rows and the modus-specific fields are left
/// blank for the IO.
Map<String, String> buildSeizureValues({
  required IoCase ioCase,
  CrimeDraft? fir,
  List<IoParty> parties = const [],
  List<IoExhibit> exhibits = const [],
}) {
  final v = <String, String>{};

  v['district'] = fir?.district ?? ioCase.district ?? '';
  v['policeStation'] =
      (ioCase.policeStation?.trim().isNotEmpty ?? false)
          ? ioCase.policeStation!
          : (fir?.policeStation ?? '');
  final year = fir?.year ?? ioCase.year;
  v['year'] = year?.toString() ?? '';
  v['firNo'] = fir?.firNo ?? ioCase.firNo ?? '';
  v['firDate'] = _date(fir?.dateRegistered ?? fir?.firDate);
  v['actsSections'] = [fir?.section, fir?.subSection]
      .where((s) => (s ?? '').trim().isNotEmpty)
      .join('  ');

  v['placeSeized'] = fir?.placeOccurred ?? '';

  // Seized-from (first accused, when known).
  final accused = fir?.accused ?? [];
  if (accused.isNotEmpty) {
    final a = accused.first;
    v['receiverName'] = a.name;
    v['receiverFather'] = a.relativeName ?? '';
    v['receiverGender'] = a.gender ?? '';
    v['receiverAge'] = a.ageText ?? (a.age?.toString() ?? '');
    v['receiverAddress'] = a.address ?? '';
  }

  // Witnesses from the case's own witness parties.
  final witnesses = parties.where((p) => p.role == 'witness').toList();
  if (witnesses.isNotEmpty) v['w1Name'] = witnesses[0].name;
  if (witnesses.length > 1) v['w2Name'] = witnesses[1].name;

  // Panch from the case's panch parties.
  final panch = parties.where((p) => p.role == 'panch').toList();
  if (panch.isNotEmpty) v['panch1Name'] = panch[0].name;
  if (panch.length > 1) v['panch2Name'] = panch[1].name;

  // Investigating officer from the FIR's investigation block.
  final inv = fir?.investigation;
  v['ioName'] = inv?.officerName ?? '';
  v['ioRank'] = inv?.officerDesignation ?? '';
  v['ioBuckle'] = inv?.officerId ?? '';

  // Ensure every field has a key so the editor shows them all.
  for (final f in kSeizureFields) {
    v.putIfAbsent(f.id, () => '');
  }
  return v;
}

/// One row of the seized-property table (item 13).
class SeizurePropertyRow {
  const SeizurePropertyRow(this.description, this.signedOn);
  final String description;
  final String signedOn;
}

/// The seized-property rows for the table — the case's exhibits, else the FIR's
/// recovered/stolen items.
List<SeizurePropertyRow> seizurePropertyRows({
  CrimeDraft? fir,
  List<IoExhibit> exhibits = const [],
}) {
  if (exhibits.isNotEmpty) {
    return [
      for (final x in exhibits)
        SeizurePropertyRow(
          [
            x.description,
            if ((x.seizedFrom ?? '').trim().isNotEmpty) '(${x.seizedFrom})',
            if (x.value != null) '₹${x.value!.toStringAsFixed(0)}',
          ].join(' '),
          '',
        ),
    ];
  }
  final items = <SeizurePropertyRow>[];
  for (final r in fir?.recovered ?? []) {
    items.add(SeizurePropertyRow(
        [r.description, if (r.value != null) '₹${r.value!.toStringAsFixed(0)}']
            .where((s) => (s ?? '').toString().trim().isNotEmpty)
            .join(' '),
        ''));
  }
  return items;
}
