// CRIME DETAILS FORM — गुन्ह्याचा तपशीलाचा नमुना (Forms 2-A / 2-B / 2-C + the
// map / physical-evidence page). An exact replica; FIR-derived blanks auto-fill,
// the modus-operandi rows are filled by the IO. Pure Dart (no Flutter) so it is
// unit-testable and shared by the on-screen view, the PDF and the Word export.

import '../../../data/db/database.dart';
import '../../crime_entry/data/crime_types_data.dart';
import '../../crime_entry/models/crime_draft.dart';

/// This form is the scene / crime-details panchnama, so it reuses the existing
/// `scene_panchnama` catalogue id (stays in "every case" mapping, no new entry).
const String kCrimeDetailsId = 'scene_panchnama';

class CdField {
  const CdField(this.id, this.mr, this.en, {this.multiline = false});
  final String id;
  final String mr;
  final String en;
  final bool multiline;
}

class CdGroup {
  const CdGroup(this.titleMr, this.titleEn, this.fields);
  final String titleMr;
  final String titleEn;
  final List<CdField> fields;
}

const List<CdGroup> kCrimeDetailsGroups = [
  CdGroup('मथळा (2-A)', 'Header', [
    CdField('district', 'जिल्हा', 'District'),
    CdField('policeStation', 'पोलीस ठाणे', 'P.S.'),
    CdField('year', 'वर्ष', 'Year'),
    CdField('firNo', 'पहिली खबर क्र.', 'FIR No.'),
    CdField('firDate', 'तारीख', 'Date'),
    CdField('actSection', 'अधिनियम व कलम', 'Act and Section'),
  ]),
  CdGroup('घटनास्थळ दाखविणारा', 'Place shown by', [
    CdField('placeByName', 'नाव', 'Name'),
    CdField('placeByFather', 'पित्याचे/पतीचे नाव', "Father's/Husband's Name"),
    CdField('placeByAddress', 'पत्ता', 'Address'),
  ]),
  CdGroup('गुन्ह्याचा प्रकार', 'Type of crime', [
    CdField('majorHead', 'प्रमुख शीर्ष', 'Major Head'),
    CdField('minorHead', 'गौण शीर्ष', 'Minor Head'),
    CdField('method1', 'पध्दत (१)', 'Method (1)'),
    CdField('method2', 'पध्दत (२)', 'Method (2)'),
    CdField('method3', 'पध्दत (३)', 'Method (3)'),
    CdField('conveyances', 'वाहनांचा वापर', 'Conveyances used'),
    CdField('character', 'धारण केलेले चारित्र्य', 'Character assumed'),
    CdField('language', 'वापरलेली भाषा/बोली', 'Language / slang used'),
    CdField('feature1', 'विशेष वैशिष्ट्य १', 'Special Feature-1'),
    CdField('feature2', 'विशेष वैशिष्ट्य २', 'Special Feature-2'),
    CdField('feature3', 'विशेष वैशिष्ट्य ३', 'Special Feature-3'),
    CdField('placeType', 'घटनास्थळाचा प्रकार', 'Type of Place of Occurrence'),
    CdField('property1', 'मालमत्ता प्रकार (१)', 'Property type (1)'),
    CdField('property2', 'मालमत्ता प्रकार (२)', 'Property type (2)'),
    CdField('property3', 'मालमत्ता प्रकार (३)', 'Property type (3)'),
    CdField('property4', 'मालमत्ता प्रकार (४)', 'Property type (4)'),
  ]),
  CdGroup('हेतू / मालमत्ता / वर्णन (2-B)', 'Motive / Property / Scene', [
    CdField('motive', 'गुन्ह्याचा हेतू', 'Motive of Crime', multiline: true),
    CdField('propertiesInvolved', 'चोरीला/संबंधित मालमत्तेचा तपशील',
        'Details of properties stolen/involved', multiline: true),
    CdField('sceneDescription', 'घटनास्थळाचे वर्णन',
        'Description of place of occurrence', multiline: true),
    CdField('sceneDescriptionCont', 'वर्णन (पुढे) 2-C',
        'Description (Cont.)', multiline: true),
    CdField('physicalEvidence', 'भौतिक पुराव्याचे वर्णन',
        'Physical evidence recovered/seized', multiline: true),
  ]),
  CdGroup('पंचनामा', 'Panchnama', [
    CdField('panchnamaDate', 'पंचनामा दिनांक', 'Date of panchanama'),
    CdField('panchnamaTime', 'वेळ', 'Time'),
  ]),
  CdGroup('पंच', 'Panch', [
    CdField('panch1Name', 'पंच १ नाव', 'Panch 1 name'),
    CdField('panch1Address', 'पंच १ पत्ता', 'Panch 1 address'),
    CdField('panch2Name', 'पंच २ नाव', 'Panch 2 name'),
    CdField('panch2Address', 'पंच २ पत्ता', 'Panch 2 address'),
  ]),
  CdGroup('तपासी अंमलदार', 'Investigating Officer', [
    CdField('ioName', 'नाव', 'Name'),
    CdField('ioRank', 'पदनाम', 'Rank'),
    CdField('ioBuckle', 'बक्कल नंबर', 'B.No.'),
    CdField('ioDate', 'दिनांक', 'Date'),
  ]),
];

List<CdField> get kCrimeDetailsFields =>
    [for (final g in kCrimeDetailsGroups) ...g.fields];

/// One victim row of the 2-B particulars table.
class CdVictim {
  const CdVictim({
    this.fullName = '',
    this.dob = '',
    this.sex = '',
    this.nationality = '',
    this.religion = '',
    this.scst = '',
    this.occupation = '',
    this.address = '',
    this.injury = '',
    this.means = '',
  });
  final String fullName;
  final String dob;
  final String sex;
  final String nationality;
  final String religion;
  final String scst;
  final String occupation;
  final String address;
  final String injury;
  final String means;

  List<String> get cells =>
      [fullName, dob, sex, nationality, religion, scst, occupation, address, injury, means];
}

String _date(DateTime? d) =>
    d == null ? '' : '${d.day}/${d.month}/${d.year}';

/// Auto-fills the scalar fields from the linked FIR (+ case fallback).
Map<String, String> buildCrimeDetailsValues({
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
  v['actSection'] = [fir?.section, fir?.subSection]
      .where((s) => (s ?? '').trim().isNotEmpty)
      .join('  ');

  // Place shown by — the complainant.
  final c = fir?.complainant;
  if (c != null && c.name.trim().isNotEmpty) {
    v['placeByName'] = c.name;
    v['placeByFather'] = c.fatherHusbandName ?? '';
    v['placeByAddress'] = c.address ?? '';
  }

  // Type of crime — Major = category, Minor = sub-type.
  final type = fir?.crimeType ?? ioCase.crimeType;
  if (type != null && type.trim().isNotEmpty) {
    final cat = crimeCategoryOf(type);
    v['majorHead'] = cat != null ? crimeTypeMarathi(cat) : '';
    v['minorHead'] = crimeTypeMarathi(type);
  }

  // Property types (up to 4 distinct stolen categories).
  final cats = <String>{};
  for (final s in fir?.stolen ?? []) {
    final cc = (s.category ?? s.type ?? '').trim();
    if (cc.isNotEmpty) cats.add(cc);
  }
  final catList = cats.toList();
  for (var i = 0; i < 4; i++) {
    v['property${i + 1}'] = i < catList.length ? catList[i] : '';
  }

  // 7) Properties stolen/involved.
  v['propertiesInvolved'] = (fir?.stolen ?? [])
      .map((s) => [
            s.description ?? s.type,
            if (s.value != null) '₹${s.value!.toStringAsFixed(0)}',
          ].where((e) => (e ?? '').toString().trim().isNotEmpty).join(' '))
      .where((e) => e.trim().isNotEmpty)
      .join('; ');

  // 8) Scene description.
  v['sceneDescription'] = fir?.detailedDescription ?? '';

  // 10) Physical evidence — recovered items / exhibits.
  final ev = <String>[];
  for (final r in fir?.recovered ?? []) {
    if ((r.description ?? '').trim().isNotEmpty) ev.add(r.description!);
  }
  for (final x in exhibits) {
    ev.add(x.description);
  }
  v['physicalEvidence'] = ev.join('; ');

  // Panch + IO.
  final panch = parties.where((p) => p.role == 'panch').toList();
  if (panch.isNotEmpty) v['panch1Name'] = panch[0].name;
  if (panch.length > 1) v['panch2Name'] = panch[1].name;
  final inv = fir?.investigation;
  v['ioName'] = inv?.officerName ?? '';
  v['ioRank'] = inv?.officerDesignation ?? '';
  v['ioBuckle'] = inv?.officerId ?? '';

  for (final f in kCrimeDetailsFields) {
    v.putIfAbsent(f.id, () => '');
  }
  return v;
}

/// Victim rows for the 2-B table. Row 1 auto-fills from the complainant (often
/// the injured/aggrieved person); the IO adds more on the printed sheet.
List<CdVictim> buildCrimeDetailsVictims({CrimeDraft? fir}) {
  final c = fir?.complainant;
  if (c == null || c.name.trim().isEmpty) return const [];
  return [
    CdVictim(
      fullName: c.name,
      dob: c.birthYear?.toString() ?? c.ageText ?? (c.age?.toString() ?? ''),
      sex: c.gender ?? '',
      nationality: c.nationality ?? '',
      occupation: c.occupation ?? '',
      address: c.address ?? '',
    ),
  ];
}
