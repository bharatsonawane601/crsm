// The Investigating-Officer form catalogue and the crime → forms default
// mapping. Pure Dart (no Flutter) so it is unit-testable.
//
// Each [IoFormSpec] is one government form from the BNSS/BNS/BSA-2023 IO kit.
// A case surfaces the forms that apply to its crime category (plus the ones that
// apply to EVERY case); the IO can always add any other form by hand.
//
// Field labels are stored bilingually inline (Marathi + English), the same way
// the crime-type catalogue does — these are fixed legal terms, not UI chrome, so
// they don't live in the easy_localization JSON.

import 'forms/mo_form_e_model.dart';

/// Which part of the kit a form belongs to (drives grouping in the UI).
enum IoFormGroup { scene, seizure, arrest, death, medical, notice, closure, other }

/// Input type for one field on a form.
enum IoFieldType { text, multiline, number, date, time, money, dropdown, checkbox }

/// One fillable field on a form.
class IoField {
  const IoField(
    this.id,
    this.mr,
    this.en, {
    this.type = IoFieldType.text,
    this.options = const [],
    this.autofill,
  });

  final String id;
  final String mr;
  final String en;
  final IoFieldType type;

  /// Options for [IoFieldType.dropdown] (bilingual "mr / en" values).
  final List<String> options;

  /// When set, the field pre-fills from a case-level value with this key
  /// (e.g. 'district', 'policeStation', 'firNo', 'crimeType') on first open.
  final String? autofill;

  String get label => '$mr / $en';
}

/// One government form definition.
class IoFormSpec {
  const IoFormSpec({
    required this.id,
    required this.mr,
    required this.en,
    required this.group,
    this.fields = const [],
    this.always = false,
    this.categories = const {},
    this.usesParties = const {},
    this.usesExhibits = false,
  });

  final String id;
  final String mr;
  final String en;
  final IoFormGroup group;
  final List<IoField> fields;

  /// True when the form applies to EVERY case (scene panchnama, final report…).
  final bool always;

  /// Crime-category labels (from kCrimeCategories, e.g. "Theft / चोरी") for which
  /// this form is suggested. Empty + [always]=false → manual-add only.
  final Set<String> categories;

  /// Party roles this form pulls in (panch/complainant/accused/deceased/…).
  final Set<String> usesParties;

  /// True when the form renders the case's seized-exhibit (मुद्देमाल) list.
  final bool usesExhibits;

  String get label => '$mr / $en';
}

// --- Shared header fields, auto-filled from the case ------------------------
const List<IoField> _header = [
  IoField('district', 'जिल्हा', 'District', autofill: 'district'),
  IoField('policeStation', 'पोलीस ठाणे', 'Police Station',
      autofill: 'policeStation'),
  IoField('firNo', 'गुन्हा रजि. नं.', 'Crime/FIR No.', autofill: 'firNo'),
  IoField('year', 'वर्ष', 'Year', type: IoFieldType.number, autofill: 'year'),
  IoField('sections', 'कलम', 'Sections'),
  IoField('crimeType', 'गुन्ह्याचा प्रकार', 'Crime type', autofill: 'crimeType'),
];

// --- Category groupings (kept in sync with kCrimeCategories labels) ---------
const _catMurder = 'Murder / खून';
const _catCulpable = 'Culpable Homicide / सदोष मनुष्यवध';
const _catAttempt = 'Attempt to Murder / खुनाचा प्रयत्न';
const _catRobbery = 'Robbery / जबरी चोरी';
const _catDacoity = 'Dacoity / दरोडा';
const _catTheft = 'Theft / चोरी';
const _catBurglary = 'Burglary / House-breaking / घरफोडी';
const _catExtortion = 'Extortion / खंडणी';
const _catSexual = 'Sexual Offences / लैंगिक गुन्हे';
const _catPocso = 'Crimes against Children (POCSO) / बाल अत्याचार (पोक्सो)';
const _catDowry = 'Domestic Violence & Dowry / कौटुंबिक हिंसा व हुंडा';
const _catAssault = 'Assault & Hurt / हल्ला व दुखापत';
const _catNdps = 'Narcotics (NDPS) / अंमली पदार्थ (एनडीपीएस)';
const _catExcise = 'Excise / Prohibition / दारूबंदी / उत्पादन शुल्क';
const _catTraffic = 'Traffic / Motor Vehicle / वाहतूक / मोटार वाहन';
const _catUnnatural =
    'Accidental / Unnatural Death / अपघाती / अनैसर्गिक मृत्यू';

/// All crime categories that involve a death → the inquest/PM sub-kit.
const Set<String> kDeathCategories = {
  _catMurder,
  _catCulpable,
  _catDowry,
  _catUnnatural,
};

/// Categories that typically involve seized property → the seizure sub-kit.
const Set<String> kSeizureCategories = {
  _catTheft,
  _catBurglary,
  _catRobbery,
  _catDacoity,
  _catExtortion,
  _catTraffic,
  _catNdps,
  _catExcise,
};

/// Categories with a likely medical/injury exam.
const Set<String> kMedicalCategories = {
  _catAssault,
  _catAttempt,
  _catSexual,
  _catPocso,
  _catMurder,
};

// ===========================================================================
// The form catalogue.
// ===========================================================================
final List<IoFormSpec> kIoForms = [
  // --- Every case ----------------------------------------------------------
  IoFormSpec(
    id: 'scene_panchnama',
    mr: 'घटनास्थळ पंचनामा / गुन्हा तपशील (2-A/B/C)',
    en: 'Crime Details / Scene Panchnama (2-A/B/C)',
    group: IoFormGroup.scene,
    always: true,
    usesParties: {'panch', 'complainant'},
    usesExhibits: true,
    fields: [
      ..._header,
      IoField('sceneDate', 'पंचनामा दिनांक', 'Date', type: IoFieldType.date),
      IoField('startTime', 'सुरु वेळ', 'Start time', type: IoFieldType.time),
      IoField('endTime', 'समाप्त वेळ', 'End time', type: IoFieldType.time),
      IoField('place', 'घटनास्थळाचे वर्णन', 'Place of occurrence',
          type: IoFieldType.multiline),
      IoField('directionDistance', 'ठाण्यापासून दिशा व अंतर',
          'Direction & distance from PS'),
      IoField('description', 'घटनास्थळाचा तपशील', 'Scene description',
          type: IoFieldType.multiline),
      IoField('articles', 'सापडलेला मुद्देमाल / वस्तू', 'Articles found',
          type: IoFieldType.multiline),
      IoField('remarks', 'शेरा', 'Remarks', type: IoFieldType.multiline),
    ],
  ),
  IoFormSpec(
    id: 'final_report',
    mr: 'अंतिम अहवाल (दोषारोपपत्र)',
    en: 'Final Report / Chargesheet',
    group: IoFormGroup.closure,
    always: true,
    usesParties: {'complainant', 'accused'},
    usesExhibits: true,
    fields: [
      ..._header,
      IoField('reportType', 'अहवालाचा प्रकार', 'Report type',
          type: IoFieldType.dropdown,
          options: [
            'दोषारोपपत्र / Chargesheet',
            'अ वर्ग (खरे पण उघड नाही) / Summary A',
            'ब वर्ग (खोटे) / Summary B',
            'क वर्ग (दिवाणी) / Summary C',
          ]),
      IoField('briefFacts', 'थोडक्यात हकीकत', 'Brief facts',
          type: IoFieldType.multiline),
      IoField('sectionsCharged', 'दाखल कलमे', 'Sections charged'),
      IoField('result', 'तपासाचा निष्कर्ष', 'Investigation result',
          type: IoFieldType.multiline),
      IoField('reportDate', 'अहवाल दिनांक', 'Report date',
          type: IoFieldType.date),
    ],
  ),
  IoFormSpec(
    id: 'notice_35_3',
    mr: 'नोटीस कलम ३५(३) BNSS',
    en: 'Notice u/s 35(3) BNSS',
    group: IoFormGroup.notice,
    always: true,
    usesParties: {'accused'},
    fields: [
      ..._header,
      IoField('noticeDate', 'नोटीस दिनांक', 'Notice date',
          type: IoFieldType.date),
      IoField('appearDate', 'हजर राहण्याचा दिनांक', 'Date to appear',
          type: IoFieldType.date),
      IoField('appearPlace', 'हजर राहण्याचे ठिकाण', 'Place to appear'),
      IoField('remarks', 'शेरा', 'Remarks', type: IoFieldType.multiline),
    ],
  ),

  // --- Seizure sub-kit -----------------------------------------------------
  IoFormSpec(
    id: 'seizure_panchnama',
    mr: 'मालमत्ता शोध व जप्तीचा नमुना (कलम १८५)',
    en: 'Property Search & Seizure Form (s.185)',
    group: IoFormGroup.seizure,
    categories: kSeizureCategories,
    usesParties: {'panch'},
    usesExhibits: true,
    fields: [
      ..._header,
      IoField('seizureDate', 'जप्ती दिनांक', 'Date', type: IoFieldType.date),
      IoField('seizureTime', 'जप्ती वेळ', 'Time', type: IoFieldType.time),
      IoField('seizurePlace', 'जप्तीचे ठिकाण', 'Place of seizure',
          type: IoFieldType.multiline),
      IoField('seizedFrom', 'ज्याच्याकडून जप्त', 'Seized from whom'),
      IoField('sealDetail', 'शिक्क्याचे वर्णन', 'Seal description'),
      IoField('remarks', 'शेरा', 'Remarks', type: IoFieldType.multiline),
    ],
  ),
  IoFormSpec(
    id: 'property_receipt',
    mr: 'मुद्देमाल ताबा पावती',
    en: 'Property Seizure Receipt',
    group: IoFormGroup.seizure,
    categories: kSeizureCategories,
    usesExhibits: true,
    fields: [
      ..._header,
      IoField('receiptDate', 'पावती दिनांक', 'Date', type: IoFieldType.date),
      IoField('receivedFrom', 'ज्याच्याकडून प्राप्त', 'Received from'),
      IoField('receivedBy', 'ताबा घेणारा अधिकारी', 'Received by (officer)'),
      IoField('remarks', 'शेरा', 'Remarks', type: IoFieldType.multiline),
    ],
  ),
  IoFormSpec(
    id: 'house_search',
    mr: 'घरझडती पंचनामा',
    en: 'House Search Panchnama',
    group: IoFormGroup.seizure,
    categories: {_catTheft, _catBurglary, _catRobbery, _catDacoity, _catNdps},
    usesParties: {'panch'},
    usesExhibits: true,
    fields: [
      ..._header,
      IoField('searchDate', 'झडती दिनांक', 'Date', type: IoFieldType.date),
      IoField('searchTime', 'झडती वेळ', 'Time', type: IoFieldType.time),
      IoField('searchPlace', 'झडतीचे ठिकाण', 'Place searched',
          type: IoFieldType.multiline),
      IoField('nilOrFound', 'निष्पत्ती', 'Result',
          type: IoFieldType.dropdown,
          options: ['निल (काही नाही) / Nil', 'मुद्देमाल मिळाला / Found']),
      IoField('remarks', 'शेरा', 'Remarks', type: IoFieldType.multiline),
    ],
  ),
  IoFormSpec(
    id: 'mobile_seal',
    mr: 'मोबाईल सील लेबल',
    en: 'Mobile / Electronics Seal Label',
    group: IoFormGroup.seizure,
    usesExhibits: true,
    fields: [
      ..._header,
      IoField('make', 'कंपनी / मॉडेल', 'Make / Model'),
      IoField('imei', 'IMEI क्रमांक', 'IMEI number'),
      IoField('sealNo', 'सील क्रमांक', 'Seal number'),
      IoField('sealDate', 'सील दिनांक', 'Seal date', type: IoFieldType.date),
    ],
  ),

  // --- Arrest sub-kit ------------------------------------------------------
  IoFormSpec(
    id: 'arrest_memo',
    mr: 'अटक पंचनामा / मेमो',
    en: 'Arrest–Surrender Memo',
    group: IoFormGroup.arrest,
    always: true,
    usesParties: {'accused'},
    fields: [
      ..._header,
      IoField('arrestDate', 'अटक दिनांक', 'Date', type: IoFieldType.date),
      IoField('arrestTime', 'अटक वेळ', 'Time', type: IoFieldType.time),
      IoField('arrestPlace', 'अटकेचे ठिकाण', 'Place of arrest'),
      IoField('grounds', 'अटकेची कारणे', 'Grounds of arrest',
          type: IoFieldType.multiline),
      IoField('arrestingOfficer', 'अटक करणारा अधिकारी', 'Arresting officer'),
      IoField('memoWitness', 'मेमो साक्षीदार', 'Memo witness'),
      IoField('relativeInformed', 'नातेवाईकास कळविले', 'Relative informed'),
      IoField('health', 'आरोग्य स्थिती', 'Health condition'),
    ],
  ),
  IoFormSpec(
    id: 'disclosure_memo',
    mr: 'निवेदन ज्ञापन (कलम २३(२) BSA)',
    en: 'Disclosure Memorandum (s.23(2) BSA)',
    group: IoFormGroup.arrest,
    categories: {...kSeizureCategories, _catMurder},
    usesParties: {'accused', 'panch'},
    usesExhibits: true,
    fields: [
      ..._header,
      IoField('memoDate', 'दिनांक', 'Date', type: IoFieldType.date),
      IoField('statement', 'आरोपीचे निवेदन', "Accused's statement",
          type: IoFieldType.multiline),
      IoField('recoveryDetail', 'हस्तगत मुद्देमाल तपशील', 'Recovery detail',
          type: IoFieldType.multiline),
    ],
  ),
  IoFormSpec(
    id: 'interrogation',
    mr: 'आरोपी चौकशी नोंद',
    en: 'Interrogation / Case Diary Note',
    group: IoFormGroup.arrest,
    usesParties: {'accused'},
    fields: [
      ..._header,
      IoField('interrogationDate', 'दिनांक', 'Date', type: IoFieldType.date),
      IoField('notes', 'चौकशी तपशील', 'Interrogation notes',
          type: IoFieldType.multiline),
    ],
  ),

  // --- Death / inquest sub-kit ---------------------------------------------
  IoFormSpec(
    id: 'inquest',
    mr: 'मरणोत्तर पंचनामा (कलम १९४)',
    en: 'Inquest Panchnama (s.194)',
    group: IoFormGroup.death,
    categories: kDeathCategories,
    usesParties: {'deceased', 'panch'},
    fields: [
      ..._header,
      IoField('inquestDate', 'दिनांक', 'Date', type: IoFieldType.date),
      IoField('inquestTime', 'वेळ', 'Time', type: IoFieldType.time),
      IoField('inquestPlace', 'ठिकाण', 'Place'),
      IoField('deceasedName', 'मृताचे नाव', 'Deceased name'),
      IoField('apparentCause', 'मृत्यूचे उघड कारण', 'Apparent cause of death',
          type: IoFieldType.multiline),
      IoField('bodyDescription', 'मृतदेहाचे वर्णन', 'Body description',
          type: IoFieldType.multiline),
      IoField('injuries', 'दिसणाऱ्या जखमा', 'Injuries noted',
          type: IoFieldType.multiline),
      IoField('sentForPM', 'शवविच्छेदनासाठी पाठविले', 'Sent for post-mortem',
          type: IoFieldType.checkbox),
      IoField('hospital', 'रुग्णालयाचे नाव', 'Hospital name'),
    ],
  ),
  IoFormSpec(
    id: 'pm_request',
    mr: 'शवविच्छेदन विनंती + १४ कलमी',
    en: 'Post-mortem Request + 14-point',
    group: IoFormGroup.death,
    categories: kDeathCategories,
    usesParties: {'deceased'},
    fields: [
      ..._header,
      IoField('requestDate', 'दिनांक', 'Date', type: IoFieldType.date),
      IoField('hospital', 'रुग्णालय', 'Hospital'),
      IoField('history', 'संक्षिप्त इतिहास', 'Brief history',
          type: IoFieldType.multiline),
    ],
  ),
  IoFormSpec(
    id: 'body_receipt',
    mr: 'प्रेत ताबा पावती',
    en: 'Body Handover Receipt',
    group: IoFormGroup.death,
    categories: kDeathCategories,
    usesParties: {'deceased'},
    fields: [
      ..._header,
      IoField('handoverDate', 'दिनांक', 'Date', type: IoFieldType.date),
      IoField('handedTo', 'ताबा घेणारा', 'Handed over to'),
      IoField('relation', 'नाते', 'Relation'),
    ],
  ),
  IoFormSpec(
    id: 'relative_summons',
    mr: 'नातेवाईक समन्स (कलम १७९)',
    en: 'Relative Summons (s.179)',
    group: IoFormGroup.death,
    categories: kDeathCategories,
    fields: [
      ..._header,
      IoField('summonsDate', 'दिनांक', 'Date', type: IoFieldType.date),
      IoField('toName', 'ज्यांना', 'To (name)'),
      IoField('appearDate', 'हजर दिनांक', 'Appear date', type: IoFieldType.date),
    ],
  ),

  // --- Medical sub-kit -----------------------------------------------------
  IoFormSpec(
    id: 'medical_exam',
    mr: 'वैद्यकीय तपासणी विनंती (कलम ५१)',
    en: 'Medical Examination Request (s.51)',
    group: IoFormGroup.medical,
    categories: kMedicalCategories,
    usesParties: {'accused', 'complainant'},
    fields: [
      ..._header,
      IoField('examDate', 'दिनांक', 'Date', type: IoFieldType.date),
      IoField('personName', 'तपासावयाची व्यक्ती', 'Person to examine'),
      IoField('hospital', 'रुग्णालय', 'Hospital'),
      IoField('purpose', 'तपासणीचे कारण', 'Purpose',
          type: IoFieldType.multiline),
    ],
  ),
  IoFormSpec(
    id: 'injury_certificate',
    mr: 'जखम प्रमाणपत्र (MLC)',
    en: 'Injury Certificate (MLC)',
    group: IoFormGroup.medical,
    categories: {_catAssault, _catAttempt, _catMurder},
    usesParties: {'complainant'},
    fields: [
      ..._header,
      IoField('injuredName', 'जखमी व्यक्ती', 'Injured person'),
      IoField('injuries', 'जखमांचे वर्णन', 'Injuries',
          type: IoFieldType.multiline),
      IoField('nature', 'जखमांचे स्वरूप', 'Nature of injuries'),
    ],
  ),
  IoFormSpec(
    id: 'dna_form',
    mr: 'DNA ओळख नमुना फॉर्म',
    en: 'DNA Identification Form',
    group: IoFormGroup.medical,
    categories: {_catSexual, _catPocso, _catMurder},
    fields: [
      ..._header,
      IoField('sampleFrom', 'नमुना कोणाकडून', 'Sample from'),
      IoField('sampleType', 'नमुन्याचा प्रकार', 'Sample type'),
      IoField('sealNo', 'सील क्रमांक', 'Seal number'),
      IoField('collectedDate', 'संकलन दिनांक', 'Collected date',
          type: IoFieldType.date),
    ],
  ),
  IoFormSpec(
    id: 'ndps_sample_seal',
    mr: 'अंमली पदार्थ नमुना सील',
    en: 'NDPS Sample Seal Label',
    group: IoFormGroup.seizure,
    categories: {_catNdps},
    usesExhibits: true,
    fields: [
      ..._header,
      IoField('substance', 'पदार्थाचे नाव', 'Substance'),
      IoField('quantity', 'वजन / प्रमाण', 'Quantity / weight'),
      IoField('sealNo', 'सील क्रमांक', 'Seal number'),
    ],
  ),

  // --- Modus Operandi Bureau -----------------------------------------------
  IoFormSpec(
    id: kMoFormEId,
    mr: 'फॉर्म "ई" (मोडस ऑपरेंडी)',
    en: 'Form "E" (Modus Operandi Bureau)',
    group: IoFormGroup.other,
    categories: kSeizureCategories,
    usesParties: {'complainant', 'accused'},
    usesExhibits: true,
    fields: [
      for (final r in kMoFormERows)
        IoField(r.id, r.mr, '', type: IoFieldType.multiline),
    ],
  ),

  // --- Juvenile ------------------------------------------------------------
  IoFormSpec(
    id: 'juvenile_social',
    mr: 'विधीसंघर्षग्रस्त बालक सामाजिक अहवाल',
    en: 'Juvenile Social Background Report',
    group: IoFormGroup.other,
    usesParties: {'accused'},
    fields: [
      ..._header,
      IoField('childName', 'बालकाचे नाव', 'Child name'),
      IoField('age', 'वय', 'Age', type: IoFieldType.number),
      IoField('guardian', 'पालक', 'Guardian'),
      IoField('background', 'सामाजिक पार्श्वभूमी', 'Social background',
          type: IoFieldType.multiline),
    ],
  ),
];

/// Fast lookup by form id.
final Map<String, IoFormSpec> kIoFormById = {
  for (final f in kIoForms) f.id: f,
};

/// The forms suggested for a case of [crimeCategory] — every "always" form plus
/// the ones whose [IoFormSpec.categories] include the category. Order follows
/// [kIoForms] (scene → seizure → arrest → death → medical → notice → closure).
List<IoFormSpec> suggestedForms(String? crimeCategory) {
  return [
    for (final f in kIoForms)
      if (f.always || (crimeCategory != null && f.categories.contains(crimeCategory)))
        f,
  ];
}

/// Forms NOT suggested for [crimeCategory] — offered under "add another form".
List<IoFormSpec> otherForms(String? crimeCategory) {
  final suggested = suggestedForms(crimeCategory).map((f) => f.id).toSet();
  return [for (final f in kIoForms) if (!suggested.contains(f.id)) f];
}
