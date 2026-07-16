// The master field catalogue for an IO case — every piece of data the ~30
// government forms need, entered ONCE here and read by all the auto-filled
// forms. Pure Dart (no Flutter) so it is testable and shared.
//
//  - Case-level fields (FIR header extras, narrative, death/PM, medical, DNA,
//    juvenile, final report) → stored on IoCases.dataJson.
//  - Per-person deep fields (accused/deceased/complainant/witness/panch) →
//    stored on that party's IoParties.valuesJson, using roleFields(role).
//  - Per-item fields (exhibit / mobile) → stored on IoExhibits.valuesJson.

enum DType { text, multiline, number, date, time, dropdown, checkbox }

/// One data field.
class DField {
  const DField(this.id, this.mr, this.en,
      {this.type = DType.text, this.options = const []});
  final String id;
  final String mr;
  final String en;
  final DType type;
  final List<String> options;
}

/// A titled, collapsible group of fields.
class DSection {
  const DSection(this.id, this.mr, this.en, this.fields, {this.death = false});
  final String id;
  final String mr;
  final String en;
  final List<DField> fields;

  /// Sections that only make sense for a death case (shown when relevant).
  final bool death;
}

const _yesNo = ['होय / Yes', 'नाही / No'];

// ===========================================================================
// Case-level sections (stored on IoCases.dataJson).
// ===========================================================================
const List<DSection> kCaseDataSections = [
  DSection('header', 'एफआयआर तपशील (अतिरिक्त)', 'FIR details (extra)', [
    DField('camp', 'कॅंप', 'Camp'),
    DField('gdNo', 'ठाणे दैनंदिनी क्र.', 'Station Diary / GD No.'),
    DField('proceedingNo', 'कार्यवाही क्र.', 'Proceeding No.'),
    DField('adUdNo', 'आकस्मात/अकस्मात मृत्यू क्र.', 'AD / UD No.'),
    DField('courtName', 'न्यायालयाचे नाव', 'Court name (JMFC)'),
    DField('placeDetail', 'घटनास्थळ तपशील', 'Place of occurrence (detail)',
        type: DType.multiline),
  ]),
  DSection('narrative', 'हकीकत / वर्णन', 'Narrative', [
    DField('briefFacts', 'थोडक्यात हकीकत', 'Brief facts of the case',
        type: DType.multiline),
    DField('sceneDescription', 'घटनास्थळाचे वर्णन', 'Scene description',
        type: DType.multiline),
    DField('motive', 'गुन्ह्याचा हेतू', 'Motive of crime', type: DType.multiline),
    DField('propertiesInvolved', 'संबंधित मालमत्ता तपशील',
        'Properties stolen/involved', type: DType.multiline),
    DField('physicalEvidence', 'भौतिक पुराव्याचे वर्णन', 'Physical evidence',
        type: DType.multiline),
    DField('circumstances', 'जप्तीची परिस्थिती/कारणे',
        'Circumstances / grounds of seizure', type: DType.multiline),
  ]),
  DSection('mo', 'गुन्ह्याची पद्धत (मोडस ऑपरेंडी)', 'Modus Operandi', [
    DField('majorHead', 'प्रमुख शीर्ष', 'Major head'),
    DField('minorHead', 'गौण शीर्ष', 'Minor head'),
    DField('method', 'गुन्हा करण्याची रीत', 'Method'),
    DField('meansUsed', 'वापरलेले साधन', 'Instrument/means used'),
    DField('conveyance', 'वापरलेली वाहने', 'Conveyances used'),
    DField('character', 'धारण केलेले चारित्र्य', 'Character assumed'),
    DField('language', 'वापरलेली भाषा/बोली', 'Language / slang'),
    DField('specialFeature', 'विशेष वैशिष्ट्ये', 'Special features'),
    DField('associatesNote', 'साथीदार', 'Associates'),
  ]),
  DSection('death', 'मृत्यू / मरणोत्तर तपशील', 'Death / Inquest details', [
    DField('deathPlaceFound', 'प्रेत सापडल्याचे ठिकाण', 'Place body found'),
    DField('deathDateFound', 'सापडल्याची तारीख', 'Date found', type: DType.date),
    DField('deathTimeFound', 'सापडल्याची वेळ', 'Time found', type: DType.time),
    DField('deathDate', 'मृत्यूची तारीख', 'Date of death', type: DType.date),
    DField('deathTime', 'मृत्यूची वेळ', 'Time of death', type: DType.time),
    DField('bodyShownBy', 'प्रेत दाखविणारा', 'Body shown by'),
    DField('bodyIdentifiedBy', 'प्रेत ओळखणारा', 'Body identified by'),
    DField('deathCause', 'मृत्यूचे कारण', 'Cause',
        type: DType.dropdown,
        options: [
          'अपघात / Accident',
          'खून / Homicide',
          'आत्महत्या / Suicide',
          'नैसर्गिक / Natural',
          'विषबाधा / Poisoning',
          'जळून / Burn',
        ]),
    DField('deathWeapon', 'हत्यार/साधन', 'Weapon / means'),
    DField('bodyCoolWarm', 'प्रेत थंड/गरम', 'Body cool / warm'),
    DField('sentToPm', 'शवविच्छेदनासाठी पाठविले', 'Sent to post-mortem',
        type: DType.dropdown, options: _yesNo),
    DField('pmHospital', 'रुग्णालय', 'Hospital'),
    DField('pmEscort', 'सोबत पाठविणारा (नाव/बक्कल)', 'Escort officer'),
    DField('pmOpinion', 'पंच व पोलिसांचा अभिप्राय', 'Opinion about death',
        type: DType.multiline),
  ], death: true),
  DSection('deathExtra', 'मृत्यू - अधिक (१४ कलमी / पीएम)',
      'Death extra (14-point / PM)', [
    DField('illnessHistory', 'अलीकडील आजार', 'Recent illness',
        type: DType.multiline),
    DField('recentAccident', 'अलीकडील अपघात/दुखापत', 'Recent accident/injury',
        type: DType.multiline),
    DField('poisonSuspicion', 'विषबाधेचा संशय', 'Suspicion of poisoning',
        type: DType.multiline),
    DField('womanPregnancy', 'स्त्री असल्यास गर्भधारणा/प्रसूती',
        'Pregnancy/delivery (if woman)'),
    DField('smoking', 'धूम्रपान', 'Smoking', type: DType.dropdown, options: _yesNo),
    DField('alcohol', 'दारू', 'Alcohol', type: DType.dropdown, options: _yesNo),
    DField('tobacco', 'तंबाखू', 'Tobacco', type: DType.dropdown, options: _yesNo),
    DField('bodyClothes', 'प्रेतावरील कपडे', 'Clothes on body',
        type: DType.multiline),
    DField('bodyOrnaments', 'प्रेतावरील दागिने/वस्तू', 'Ornaments/items on body',
        type: DType.multiline),
    DField('bodyDisposal', 'प्रेताची विल्हेवाट', 'Disposal of body'),
  ], death: true),
  DSection('medical', 'वैद्यकीय / जखम प्रमाणपत्र', 'Medical / Injury', [
    DField('mlcNo', 'MLC क्र.', 'MLC No.'),
    DField('injuredName', 'जखमी व्यक्ती', 'Injured person'),
    DField('injuredAge', 'वय', 'Age', type: DType.number),
    DField('broughtBy', 'आणणारा (PC/HC नाव, बक्कल)', 'Brought by'),
    DField('hospital', 'रुग्णालय', 'Hospital'),
    DField('injuriesDetail', 'जखमांचे वर्णन', 'Injuries description',
        type: DType.multiline),
    DField('injuryNature', 'जखमांचे स्वरूप (साधी/गंभीर)', 'Simple / grievous'),
  ]),
  DSection('dna', 'DNA नमुना', 'DNA sample', [
    DField('dnaDonor', 'नमुना देणारा', 'Donor name'),
    DField('dnaGuardian', 'पालक (अल्पवयीन असल्यास)', 'Guardian (if minor)'),
    DField('dnaSampleDesc', 'नमुन्याचे वर्णन', 'Sample description'),
    DField('dnaCollectDate', 'संकलन तारीख', 'Collection date', type: DType.date),
    DField('dnaAbnormality', 'अनुवांशिक विकृती', 'Genetic abnormality'),
    DField('dnaForwardedBy', 'पाठविणारे न्यायालय/ठाणे', 'Forwarded by court/PS'),
  ]),
  DSection('juvenile', 'विधीसंघर्षग्रस्त बालक', 'Juvenile (child in conflict)', [
    DField('childName', 'बालकाचे नाव', 'Child name'),
    DField('childFather', 'वडील', 'Father'),
    DField('childDob', 'जन्म तारीख', 'Date of birth', type: DType.date),
    DField('childReligion', 'धर्म', 'Religion'),
    DField('cwpoName', 'बाल कल्याण पोलीस अधिकारी', 'Child Welfare Police Officer'),
    DField('childDisability', 'अपंगत्व (असल्यास)', 'Disability (if any)'),
    DField('childLeftSchool', 'शाळा सोडल्याचे कारण', 'Reason left school',
        type: DType.multiline),
    DField('childHabits', 'सवयी/व्यसन', 'Habits / addictions'),
    DField('childAbuse', 'छळ/अत्याचार (शाब्दिक/शारीरिक/लैंगिक)',
        'Abuse suffered', type: DType.multiline),
    DField('childRole', 'गुन्ह्यात बालकाची भूमिका', "Child's role in crime",
        type: DType.multiline),
    DField('cwpoSuggestion', 'बाल कल्याण अधिकारी सूचना', 'CWPO suggestions',
        type: DType.multiline),
  ]),
  DSection('finalReport', 'अंतिम अहवाल', 'Final report (s.193)', [
    DField('reportType', 'अहवालाचा प्रकार', 'Report type',
        type: DType.dropdown,
        options: [
          'दोषारोपपत्र / Charge-sheeted',
          'अ वर्ग / Summary A (true, undetected)',
          'ब वर्ग / Summary B (false)',
          'क वर्ग / Summary C (civil)',
        ]),
    DField('reportOrigSupp', 'मूळ / पुरवणी', 'Original / Supplementary'),
    DField('chargesheetNo', 'दोषारोपपत्र क्र.', 'Charge-sheet No.'),
    DField('chargesheetDate', 'दोषारोपपत्र तारीख', 'Charge-sheet date',
        type: DType.date),
    DField('labResult', 'प्रयोगशाळा निष्कर्ष', 'Lab analysis result'),
    DField('shoName', 'ठाणे अंमलदार (पाठविणारा) नाव', 'SHO (forwarding) name'),
    DField('shoRank', 'ठाणे अंमलदार पद', 'SHO rank'),
    DField('dispatchDate', 'रवाना तारीख', 'Dispatch date', type: DType.date),
  ]),
];

// ===========================================================================
// Per-person field sets (stored on the party's valuesJson).
// ===========================================================================
const List<DField> _complainant = [
  DField('fatherHusband', 'पित्याचे/पतीचे नाव', 'Father/Husband name'),
  DField('sex', 'लिंग', 'Sex'),
  DField('age', 'वय', 'Age', type: DType.number),
  DField('occupation', 'व्यवसाय', 'Occupation'),
  DField('nationality', 'राष्ट्रीयत्व', 'Nationality'),
  DField('religion', 'धर्म', 'Religion'),
  DField('scst', 'जाती/जमात (SC/ST)', 'SC/ST'),
  DField('address', 'पत्ता', 'Address', type: DType.multiline),
  DField('permanentAddress', 'कायमचा पत्ता', 'Permanent address',
      type: DType.multiline),
  DField('mobile', 'मोबाईल', 'Mobile'),
  DField('idType', 'ओळखपत्र प्रकार', 'ID type'),
  DField('idNumber', 'ओळखपत्र क्रमांक', 'ID number'),
];

const List<DField> _accused = [
  DField('alias1', 'टोपण नाव १', 'Alias 1'),
  DField('alias2', 'टोपण नाव २', 'Alias 2'),
  DField('fatherHusband', 'पित्याचे/पतीचे/पालकाचे नाव', 'Father/Husband/Guardian'),
  DField('sex', 'लिंग', 'Sex'),
  DField('dob', 'जन्म तारीख/वय', 'DOB / Age'),
  DField('nationality', 'राष्ट्रीयत्व', 'Nationality'),
  DField('religion', 'धर्म', 'Religion'),
  DField('caste', 'जात/जमात', 'Caste/Tribe'),
  DField('scstObc', 'SC/ST/OBC', 'SC/ST/OBC'),
  DField('occupation', 'व्यवसाय', 'Occupation'),
  DField('presentAddress', 'सध्याचा पत्ता', 'Present address', type: DType.multiline),
  DField('permanentAddress', 'कायमचा पत्ता', 'Permanent address',
      type: DType.multiline),
  DField('state', 'राज्य', 'State'),
  DField('dist', 'जिल्हा', 'District'),
  DField('ps', 'पोलीस ठाणे', 'P.S.'),
  DField('mobile', 'मोबाईल', 'Mobile'),
  DField('email', 'ईमेल', 'Email'),
  DField('aadhaar', 'आधार क्र.', 'Aadhaar'),
  DField('voterId', 'मतदार ओळखपत्र क्र.', 'Voter ID No.'),
  DField('passport', 'पारपत्र क्र.', 'Passport No.'),
  // Physical description
  DField('build', 'शरीर बांधा', 'Build'),
  DField('height', 'उंची (सें.मी.)', 'Height (cm)'),
  DField('complexion', 'वर्ण/रंग', 'Complexion'),
  DField('idMarks', 'ओळख चिन्ह', 'Identification marks'),
  DField('deformities', 'व्यंग/वैशिष्ट्ये', 'Deformities'),
  DField('teeth', 'दात', 'Teeth'),
  DField('hair', 'केस', 'Hair'),
  DField('eyes', 'डोळे', 'Eyes'),
  DField('moustache', 'मिशी', 'Moustache'),
  DField('nose', 'नाक', 'Nose'),
  DField('ear', 'कान', 'Ear'),
  DField('face', 'चेहरा', 'Face'),
  DField('tattoo', 'गोंदण', 'Tattoo'),
  DField('mole', 'तीळ', 'Mole'),
  DField('scar', 'व्रण', 'Scar'),
  DField('burnMark', 'भाजल्याच्या खुणा', 'Burn marks'),
  DField('language', 'भाषा/बोली', 'Languages'),
  DField('mainIdMark', 'मुख्य ओळख चिन्ह', 'Main identification mark'),
  // Arrest
  DField('arrestDate', 'अटक तारीख', 'Arrest date', type: DType.date),
  DField('arrestTime', 'अटक वेळ', 'Arrest time', type: DType.time),
  DField('arrestPlace', 'अटकेचे ठिकाण', 'Place of arrest'),
  DField('arrestGrounds', 'अटकेची कारणे', 'Grounds of arrest', type: DType.multiline),
  DField('articlesFound', 'अंगझडतीत सापडलेल्या वस्तू', 'Articles found on search',
      type: DType.multiline),
  DField('intimationName', 'खबर दिलेल्याचे नाव', 'Intimation given to'),
  DField('intimationRelation', 'नाते', 'Relation'),
  DField('health', 'आरोग्य/जखमा', 'Health / injuries'),
  DField('fingerPrint', 'बोटांचे ठसे घेतले', 'Finger print taken',
      type: DType.dropdown, options: _yesNo),
  // Socio-economic / criminal history
  DField('livingStatus', 'राहणीमान', 'Living status'),
  DField('education', 'शिक्षण', 'Education'),
  DField('incomeGroup', 'उत्पन्न गट', 'Income group'),
  DField('dangerous', 'धोकादायक?', 'Is dangerous?',
      type: DType.dropdown, options: _yesNo),
  DField('pastRecord', 'गुन्हेगारी पार्श्वभूमी?', 'Past criminal record?',
      type: DType.dropdown, options: _yesNo),
  DField('wantedOther', 'इतर प्रकरणात पाहिजे?', 'Wanted in other cases?'),
];

const List<DField> _deceased = [
  DField('address', 'पत्ता', 'Address', type: DType.multiline),
  DField('age', 'वय', 'Age'),
  DField('sex', 'लिंग', 'Sex'),
  DField('marital', 'विवाहित/अविवाहित/विधवा', 'Married/Unmarried/Widow'),
  DField('religion', 'धर्म', 'Religion'),
  DField('occupation', 'व्यवसाय', 'Occupation'),
  DField('motherName', 'आईचे नाव व पत्ता', "Mother's name & address"),
  DField('fatherName', 'वडिलांचे नाव व पत्ता', "Father's name & address"),
  DField('identifierRelation', 'ओळखणाऱ्याचे नाते', 'Identifier relation'),
  // Injuries by body part
  DField('injHead', 'डोके', 'Head'),
  DField('injFace', 'चेहरा', 'Face'),
  DField('injNeck', 'मान', 'Neck'),
  DField('injChest', 'छाती', 'Chest'),
  DField('injStomach', 'पोट', 'Stomach'),
  DField('injRightHand', 'उजवा हात', 'Right hand'),
  DField('injLeftHand', 'डावा हात', 'Left hand'),
  DField('injRightLeg', 'उजवा पाय', 'Right leg'),
  DField('injLeftLeg', 'डावा पाय', 'Left leg'),
  DField('injPrivate', 'गुप्त भाग', 'Private part'),
  DField('injBack', 'पाठ', 'Back'),
];

const List<DField> _witness = [
  DField('fatherHusband', 'पित्याचे/पतीचे नाव', 'Father/Husband name'),
  DField('age', 'वय', 'Age', type: DType.number),
  DField('occupation', 'व्यवसाय', 'Occupation'),
  DField('address', 'पत्ता', 'Address', type: DType.multiline),
  DField('sex', 'लिंग', 'Sex'),
  DField('evidenceType', 'पुराव्याचा प्रकार', 'Type of evidence'),
];

const List<DField> _panch = [
  DField('address', 'पूर्ण पत्ता', 'Full address', type: DType.multiline),
];

/// Deep fields for a party of [role] (beyond the common name field).
List<DField> roleFields(String role) => switch (role) {
      'complainant' => _complainant,
      'accused' => _accused,
      'deceased' => _deceased,
      'witness' => _witness,
      'panch' => _panch,
      _ => const [],
    };

// ===========================================================================
// Exhibit / muddemaal fields (stored on IoExhibits.valuesJson; core columns
// description/category/value/seizedFrom stay on the table).
// ===========================================================================
const List<String> kExhibitCategories = [
  'दोन चाकी वाहन / Two-wheeler',
  'चार चाकी वाहन / Four-wheeler',
  'दागिने / Jewellery',
  'मोबाईल / Mobile',
  'रोख / Cash',
  'इतर / Other',
];

const List<DField> kExhibitFields = [
  DField('place', 'जप्तीचे ठिकाण', 'Place of seizure'),
  DField('registerNo', 'मालमत्ता नोंदवही क्र.', 'PS property register No.'),
  DField('disposal', 'विल्हेवाट', 'Disposal'),
  DField('sealNo', 'सील क्रमांक', 'Seal No.'),
  DField('sealDate', 'सील तारीख', 'Seal date', type: DType.date),
  DField('exhibitNo', 'एक्झिबिट क्र.', 'Exhibit No.'),
  // Mobile / electronic
  DField('make', 'कंपनी/मॉडेल', 'Make / Model'),
  DField('imei1', 'IMEI 1', 'IMEI 1'),
  DField('imei2', 'IMEI 2', 'IMEI 2'),
  DField('serialNo', 'सिरीयल क्र.', 'Serial No.'),
  DField('password', 'पासवर्ड/पॅटर्न/पिन', 'Password/Pattern/PIN'),
  DField('simInfo', 'सिम माहिती', 'SIM info'),
  DField('memoryInfo', 'मेमरी कार्ड माहिती', 'Memory card info'),
];
