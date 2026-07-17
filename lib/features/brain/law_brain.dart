/// The CRMS Brain — law knowledge base.
///
/// Maps every crime type in the entry dropdown to the sections that normally
/// apply (BNS 2023 for new cases; the old IPC equivalents for legacy records),
/// plus extra type-ahead synonyms — English, Marathi and Roman-typed Marathi —
/// so "khun", "खून" and "murder" all reach "Murder / खून".
///
/// ⚠ Mapping compiled from the standard BNS 2023 ↔ IPC correspondence tables.
/// Review before relying on it in charge sheets: the suggested section is a
/// STARTING POINT the officer confirms, never an automatic legal decision.
library;

import 'fuzzy.dart';

class OffenceInfo {
  const OffenceInfo({
    required this.type,
    this.bns = const [],
    this.ipc = const [],
    this.synonyms = const [],
    this.hint,
  });

  /// Canonical crime-type label — EXACTLY as in kCrimeTypes (bns_data.dart).
  final String type;

  /// Usual BNS 2023 sections, most specific first.
  final List<String> bns;

  /// Old IPC equivalents (for pre-2024 FIRs).
  final List<String> ipc;

  /// Extra ways officers type this offence (Roman-Marathi, slang, old section
  /// numbers). The English/Marathi words already inside [type] are matched
  /// automatically — only list what the label itself doesn't contain.
  final List<String> synonyms;

  /// Shown when the offence is mainly under a special act or procedure.
  final String? hint;
}

const List<OffenceInfo> kOffences = [
  OffenceInfo(
    type: 'Murder / खून',
    bns: ['103(1)'],
    ipc: ['302'],
    synonyms: ['khun', 'hatya', 'हत्या', 'murdar', '302', '103'],
  ),
  OffenceInfo(
    type: 'Attempt to murder / खुनाचा प्रयत्न',
    bns: ['109'],
    ipc: ['307'],
    synonyms: ['khunacha prayatna', 'attempt murder', '307'],
  ),
  OffenceInfo(
    type: 'Culpable homicide / सदोष मनुष्यवध',
    bns: ['105'],
    ipc: ['304'],
    synonyms: ['sadosh manushyavadh', '304'],
  ),
  OffenceInfo(
    type: 'Death by negligence / निष्काळजीपणाने मृत्यू',
    bns: ['106(1)'],
    ipc: ['304A'],
    synonyms: ['nishkalji mrutyu', '304a', 'negligence death'],
  ),
  OffenceInfo(
    type: 'Hurt / दुखापत',
    bns: ['115(2)'],
    ipc: ['323'],
    synonyms: ['dukhapat', 'marhan', 'मारहाण', 'simple hurt', '323'],
  ),
  OffenceInfo(
    type: 'Grievous hurt / गंभीर दुखापत',
    bns: ['117(2)', '118'],
    ipc: ['325', '326'],
    synonyms: ['gambhir dukhapat', '325'],
  ),
  OffenceInfo(
    type: 'Assault / हल्ला',
    bns: ['131'],
    ipc: ['352'],
    synonyms: ['halla', 'marhan', '352'],
  ),
  OffenceInfo(
    type: 'Acid attack / अॅसिड हल्ला',
    bns: ['124(1)'],
    ipc: ['326A'],
    synonyms: ['acid halla', '326a'],
  ),
  OffenceInfo(
    type: 'Theft / चोरी',
    bns: ['303(2)'],
    ipc: ['379'],
    synonyms: ['chori', '379', '303'],
  ),
  OffenceInfo(
    type: 'House-breaking theft / घरफोडी चोरी',
    bns: ['331(4)', '305(a)'],
    ipc: ['457', '380'],
    synonyms: ['gharfodi chori', 'house break', '457', '380'],
  ),
  OffenceInfo(
    type: 'Vehicle theft / वाहन चोरी',
    bns: ['303(2)', '305(c)'],
    ipc: ['379'],
    synonyms: ['vahan chori', 'gadi chori', 'गाडी चोरी', 'bike chori', 'two wheeler theft'],
  ),
  OffenceInfo(
    type: 'Snatching / हिसकावणे',
    bns: ['304(2)'],
    ipc: ['379', '356'],
    synonyms: ['hiskavane', 'chain snatching', 'sonsakhli', 'सोनसाखळी', '304'],
  ),
  OffenceInfo(
    type: 'Robbery / जबरी चोरी',
    bns: ['309(4)'],
    ipc: ['392'],
    synonyms: ['jabari chori', 'lut', 'लूट', '392'],
  ),
  OffenceInfo(
    type: 'Dacoity / दरोडा',
    bns: ['310(2)'],
    ipc: ['395'],
    synonyms: ['daroda', '395'],
  ),
  OffenceInfo(
    type: 'Burglary / घरफोडी',
    bns: ['331(4)'],
    ipc: ['457', '454'],
    synonyms: ['gharfodi', '457'],
  ),
  OffenceInfo(
    type: 'Cheating / फसवणूक',
    bns: ['318(4)'],
    ipc: ['420'],
    synonyms: ['fasavnuk', 'fraud', '420', '318'],
  ),
  OffenceInfo(
    type: 'Criminal breach of trust / विश्वासघात',
    bns: ['316(2)'],
    ipc: ['406'],
    synonyms: ['vishwasghat', '406'],
  ),
  OffenceInfo(
    type: 'Forgery / बनावट दस्तऐवज',
    bns: ['336(2)', '338', '340(2)'],
    ipc: ['465', '467', '468', '471'],
    synonyms: ['banavat kagadpatre', 'khota dastavej', '465', '467', '468'],
  ),
  OffenceInfo(
    type: 'Mischief / नुकसान',
    bns: ['324(2)'],
    ipc: ['427'],
    synonyms: ['nuksan', 'todfod', 'तोडफोड', '427'],
  ),
  OffenceInfo(
    type: 'Criminal trespass / अनधिकृत प्रवेश',
    bns: ['329(3)'],
    ipc: ['447'],
    synonyms: ['anadhikrut pravesh', 'trespass', '447'],
  ),
  OffenceInfo(
    type: 'Kidnapping / अपहरण',
    bns: ['137(2)', '140'],
    ipc: ['363', '364A'],
    synonyms: ['apaharan', 'palvun nene', '363'],
  ),
  OffenceInfo(
    type: 'Human trafficking / मानवी तस्करी',
    bns: ['143'],
    ipc: ['370'],
    synonyms: ['manavi taskari', '370'],
  ),
  OffenceInfo(
    type: 'Rape / बलात्कार',
    bns: ['64'],
    ipc: ['376'],
    synonyms: ['balatkar', '376', '64'],
  ),
  OffenceInfo(
    type: 'Sexual harassment / लैंगिक छळ',
    bns: ['75'],
    ipc: ['354A'],
    synonyms: ['laingik chhal', '354a'],
  ),
  OffenceInfo(
    type: 'Outraging modesty / विनयभंग',
    bns: ['74'],
    ipc: ['354'],
    synonyms: ['vinaybhang', '354', 'chhedchhad', 'छेडछाड'],
  ),
  OffenceInfo(
    type: 'Stalking / पाठलाग',
    bns: ['78'],
    ipc: ['354D'],
    synonyms: ['pathlag', '354d'],
  ),
  OffenceInfo(
    type: 'Domestic violence / कौटुंबिक हिंसा',
    bns: ['85'],
    ipc: ['498A'],
    synonyms: ['kautumbik hinsa', 'gharguti bhandan', '498'],
    hint: 'Also see Protection of Women from DV Act, 2005 (civil remedies).',
  ),
  OffenceInfo(
    type: 'Dowry death / हुंडाबळी',
    bns: ['80(2)'],
    ipc: ['304B'],
    synonyms: ['hundabali', 'hunda bali', '304b'],
  ),
  OffenceInfo(
    type: 'Cruelty by husband (498A) / पतीकडून छळ',
    bns: ['85'],
    ipc: ['498A'],
    synonyms: ['patikadun chhal', '498a', 'sasurvas', 'सासुरवास'],
  ),
  OffenceInfo(
    type: 'Criminal intimidation / धमकी',
    bns: ['351(2)', '351(3)'],
    ipc: ['506'],
    synonyms: ['dhamki', '506', '351'],
  ),
  OffenceInfo(
    type: 'Defamation / बदनामी',
    bns: ['356(2)'],
    ipc: ['500'],
    synonyms: ['badnami', '500'],
  ),
  OffenceInfo(
    type: 'Riot / दंगल',
    bns: ['191(2)'],
    ipc: ['147'],
    synonyms: ['dangal', 'danga', 'दंगा', '147'],
  ),
  OffenceInfo(
    type: 'Unlawful assembly / बेकायदा जमाव',
    bns: ['189(2)'],
    ipc: ['143'],
    synonyms: ['bekayada jamav', '143', '189'],
  ),
  OffenceInfo(
    type: 'Cyber crime / सायबर गुन्हा',
    bns: ['318(4)', '319(2)'],
    ipc: ['420', '419'],
    synonyms: ['cyber gunha', 'online gunha', 'hacking'],
    hint: 'IT Act sections (66C/66D etc.) usually apply too — special act.',
  ),
  OffenceInfo(
    type: 'Online fraud / ऑनलाइन फसवणूक',
    bns: ['318(4)', '319(2)'],
    ipc: ['420', '419'],
    synonyms: ['online fasavnuk', 'upi fraud', 'otp fraud', 'phone fraud'],
    hint: 'IT Act 66C/66D usually added — special act.',
  ),
  OffenceInfo(
    type: 'NDPS / अंमली पदार्थ',
    synonyms: ['amli padarth', 'drugs', 'ganja', 'गांजा', 'charas'],
    hint: 'Special act: NDPS Act 1985 (e.g. 8(c) r/w 20/21/22) — outside BNS/IPC.',
  ),
  OffenceInfo(
    type: 'Excise / उत्पादन शुल्क',
    synonyms: ['utpadan shulk', 'gavthi daru', 'गावठी दारू', 'hatbhatti'],
    hint: 'Special act: Maharashtra Prohibition Act, 1949 — outside BNS/IPC.',
  ),
  OffenceInfo(
    type: 'Gambling / जुगार',
    synonyms: ['jugar', 'matka', 'मटका', 'betting'],
    hint: 'Special act: Maharashtra Prevention of Gambling Act, 1887.',
  ),
  OffenceInfo(
    type: 'Prohibition / दारूबंदी',
    synonyms: ['darubandi', 'daru', 'दारू'],
    hint: 'Special act: Maharashtra Prohibition Act, 1949 (e.g. 65(e), 68, 85).',
  ),
  OffenceInfo(
    type: 'Arms Act / शस्त्र कायदा',
    synonyms: ['shastra kayda', 'pistol', 'katta', 'कट्टा', 'talwar', 'तलवार'],
    hint: 'Special act: Arms Act, 1959 (e.g. 3 r/w 25) — outside BNS/IPC.',
  ),
  OffenceInfo(
    type: 'Accident / अपघात',
    bns: ['281', '125(a)', '106(1)'],
    ipc: ['279', '337', '338', '304A'],
    synonyms: ['apghat', 'road accident', '279', 'hit and run'],
  ),
  OffenceInfo(
    type: 'Missing person / बेपत्ता व्यक्ती',
    synonyms: ['bepatta', 'missing', 'harvlela'],
    hint: 'Register entry, no offence section. If foul play suspected: BNS 137 (kidnapping).',
  ),
  OffenceInfo(
    type: 'Suicide / आत्महत्या',
    synonyms: ['atmahatya', 'gala favun', 'suiside'],
    hint: 'Accidental Death (AD) — BNSS 194 inquiry (old CrPC 174), no offence section.',
  ),
  OffenceInfo(
    type: 'Abetment of suicide / आत्महत्येस प्रवृत्त',
    bns: ['108'],
    ipc: ['306'],
    synonyms: ['atmahatyes pravrutta', '306'],
  ),
  OffenceInfo(
    type: 'Organised crime / संघटित गुन्हा',
    bns: ['111'],
    synonyms: ['sanghatit gunha', 'toli', 'टोळी', 'gang', 'mcoca'],
    hint: 'MCOCA, 1999 may also apply (special act, needs approval).',
  ),
  OffenceInfo(
    type: 'Terrorist act / दहशतवादी कृत्य',
    bns: ['113'],
    synonyms: ['dahshatvad', 'terrorism'],
    hint: 'UAPA, 1967 usually applies (special act, central sanction).',
  ),
  OffenceInfo(
    type: 'Other / इतर',
    synonyms: ['itar'],
  ),
];

/// BNS 2023 section → short offence name (English / Marathi). Covers every
/// number in kBnsSections plus those the brain suggests.
const Map<String, String> kBnsSectionNames = {
  '3(5)': 'Common intention / समान उद्देश',
  '61': 'Criminal conspiracy / कट',
  '62': 'Attempt to commit offence / प्रयत्न',
  '64': 'Rape / बलात्कार',
  '65': 'Rape of minor / अल्पवयीन बलात्कार',
  '66': 'Rape causing death / मृत्यूस कारण बलात्कार',
  '70': 'Gang rape / सामूहिक बलात्कार',
  '74': 'Outraging modesty / विनयभंग',
  '75': 'Sexual harassment / लैंगिक छळ',
  '76': 'Disrobing a woman / वस्त्रहरण',
  '77': 'Voyeurism / चोरून पाहणे',
  '78': 'Stalking / पाठलाग',
  '79': 'Insulting modesty / विनयभंग (शब्द/हावभाव)',
  '80': 'Dowry death / हुंडाबळी',
  '80(2)': 'Dowry death / हुंडाबळी',
  '84': 'Enticing a married woman / विवाहित स्त्रीस फूस',
  '85': 'Cruelty by husband/relatives / पतीकडून छळ',
  '103': 'Murder / खून',
  '103(1)': 'Murder / खून',
  '105': 'Culpable homicide / सदोष मनुष्यवध',
  '106': 'Death by negligence / निष्काळजी मृत्यू',
  '106(1)': 'Death by negligence / निष्काळजी मृत्यू',
  '108': 'Abetment of suicide / आत्महत्येस प्रवृत्त',
  '109': 'Attempt to murder / खुनाचा प्रयत्न',
  '110': 'Attempt culpable homicide / मनुष्यवधाचा प्रयत्न',
  '111': 'Organised crime / संघटित गुन्हा',
  '112': 'Petty organised crime / लहान संघटित गुन्हा',
  '113': 'Terrorist act / दहशतवादी कृत्य',
  '115': 'Voluntarily causing hurt / दुखापत',
  '115(2)': 'Voluntarily causing hurt / दुखापत',
  '117': 'Grievous hurt / गंभीर दुखापत',
  '117(2)': 'Grievous hurt / गंभीर दुखापत',
  '118': 'Hurt by dangerous weapon / घातक शस्त्राने दुखापत',
  '120': 'Hurt to extort confession / कबुलीसाठी दुखापत',
  '121': 'Hurt to deter public servant / लोकसेवकास दुखापत',
  '124': 'Acid attack / अॅसिड हल्ला',
  '124(1)': 'Acid attack / अॅसिड हल्ला',
  '125': 'Act endangering life / जीव धोक्यात',
  '125(a)': 'Rash act endangering life / जीव धोक्यात (हलगर्जी)',
  '126': 'Wrongful restraint / चुकीचा अडथळा',
  '127': 'Wrongful confinement / डांबून ठेवणे',
  '131': 'Assault / criminal force / हल्ला',
  '137': 'Kidnapping / अपहरण',
  '137(2)': 'Kidnapping / अपहरण',
  '140': 'Kidnapping for ransom / खंडणीसाठी अपहरण',
  '143': 'Human trafficking / मानवी तस्करी',
  '147': 'Waging war against Govt / देशाविरुद्ध युद्ध',
  '152': 'Act endangering sovereignty / सार्वभौमत्वास धोका',
  '189': 'Unlawful assembly / बेकायदा जमाव',
  '189(2)': 'Unlawful assembly / बेकायदा जमाव',
  '190': 'Member of unlawful assembly / जमावाचा सदस्य',
  '191': 'Rioting / दंगल',
  '191(2)': 'Rioting / दंगल',
  '193': 'Harbouring rioters / दंगेखोरांना आश्रय',
  '196': 'Promoting enmity / द्वेष पसरवणे',
  '281': 'Rash driving / निष्काळजी वाहन चालवणे',
  '296': 'Obscene acts / अश्लील कृत्य',
  '303': 'Theft / चोरी',
  '303(2)': 'Theft / चोरी',
  '304': 'Snatching / हिसकावणे',
  '304(2)': 'Snatching / हिसकावणे',
  '305': 'Theft in dwelling/vehicle / घरातील-वाहनातील चोरी',
  '305(a)': 'Theft in dwelling house / घरातील चोरी',
  '305(c)': 'Theft of/from vehicle / वाहन चोरी',
  '306': 'Theft by clerk or servant / नोकराकडून चोरी',
  '309': 'Robbery / जबरी चोरी',
  '309(4)': 'Robbery / जबरी चोरी',
  '310': 'Dacoity / दरोडा',
  '310(2)': 'Dacoity / दरोडा',
  '314': 'Dishonest misappropriation / अपहार',
  '316': 'Criminal breach of trust / विश्वासघात',
  '316(2)': 'Criminal breach of trust / विश्वासघात',
  '318': 'Cheating / फसवणूक',
  '318(4)': 'Cheating / फसवणूक',
  '319': 'Cheating by personation / तोतयागिरी',
  '319(2)': 'Cheating by personation / तोतयागिरी',
  '320': 'Fraudulent removal of property / मालमत्ता लपवणे',
  '324': 'Mischief / नुकसान',
  '324(2)': 'Mischief / नुकसान',
  '326': 'Mischief (fire/water/etc.) / आगीने नुकसान',
  '329': 'Criminal trespass / अनधिकृत प्रवेश',
  '329(3)': 'Criminal trespass / अनधिकृत प्रवेश',
  '331': 'House-breaking / घरफोडी',
  '331(4)': 'House-breaking by night / रात्री घरफोडी',
  '336': 'Forgery / बनावट दस्तऐवज',
  '336(2)': 'Forgery / बनावट दस्तऐवज',
  '338': 'Forgery of valuable security / मौल्यवान दस्त बनावट',
  '340': 'Using forged document / बनावट दस्त वापर',
  '340(2)': 'Using forged document / बनावट दस्त वापर',
  '351': 'Criminal intimidation / धमकी',
  '351(2)': 'Criminal intimidation / धमकी',
  '351(3)': 'Criminal intimidation (grave) / गंभीर धमकी',
  '352': 'Intentional insult / अपमान',
  '356': 'Defamation / बदनामी',
  '356(2)': 'Defamation / बदनामी',
};

/// Old IPC → new BNS equivalents, so searching/typing an old number still
/// reaches the right offence in new-law records.
const Map<String, String> kIpcToBns = {
  '302': '103(1)', '307': '109', '304': '105', '304A': '106(1)',
  '304B': '80(2)', '306': '108', '323': '115(2)', '325': '117(2)',
  '326': '118', '326A': '124(1)', '352': '131', '354': '74',
  '354A': '75', '354B': '76', '354C': '77', '354D': '78',
  '363': '137(2)', '364A': '140', '370': '143', '376': '64',
  '379': '303(2)', '380': '305(a)', '392': '309(4)', '395': '310(2)',
  '406': '316(2)', '420': '318(4)', '419': '319(2)', '427': '324(2)',
  '447': '329(3)', '454': '331', '457': '331(4)', '465': '336(2)',
  '467': '338', '468': '338', '471': '340(2)', '498A': '85',
  '500': '356(2)', '506': '351(2)', '143': '189(2)', '147': '191(2)',
  '279': '281', '337': '125(a)', '338': '125(b)', '174': 'BNSS 194',
};

OffenceInfo? offenceForType(String crimeType) {
  final t = crimeType.trim();
  if (t.isEmpty) return null;
  for (final o in kOffences) {
    if (o.type == t) return o;
  }
  // Fuzzy fallback: stored records may carry only one half of the label or a
  // typo — match against the full labels + synonyms.
  final best = brainBest(t, kOffences.map((o) => o.type),
      threshold: 0.75, exactIsNull: false);
  if (best != null) {
    for (final o in kOffences) {
      if (o.type == best.value) return o;
    }
  }
  for (final o in kOffences) {
    for (final syn in o.synonyms) {
      if (brainSimilarity(t, syn) >= 0.85) return o;
    }
  }
  return null;
}

/// "103" / "103(1)" → "103(1) — Murder / खून" (null if unknown).
String? bnsSectionLabel(String section) {
  final s = section.trim();
  final name = kBnsSectionNames[s] ?? kBnsSectionNames[s.split('(').first];
  if (name == null) return null;
  return '$s — $name';
}

/// Whether [sections] (the FIR's comma/space-separated section text) already
/// contains one of the sections usual for [o]. Loose contains-match on the
/// bare number so "103(1)" satisfies "103".
bool sectionsCoverOffence(String sections, OffenceInfo o) {
  if (o.bns.isEmpty && o.ipc.isEmpty) return true;
  final have = sections.toLowerCase();
  bool hit(List<String> list) {
    for (final s in list) {
      final bare = s.split('(').first.toLowerCase();
      if (bare.isNotEmpty && have.contains(bare)) return true;
    }
    return false;
  }
  return hit(o.bns) || hit(o.ipc);
}
