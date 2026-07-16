/// An Act/law a section belongs to. [code] is the short form stored alongside
/// the section number (e.g. "BNS 103"); [name] is shown in the dropdown.
class ActOption {
  const ActOption(this.name, this.code);
  final String name;
  final String code;
}

/// Acts available in the section picker, grouped by area of law. The picker is
/// searchable, so this can stay long without hurting usability — officers type
/// to filter by name or short code.
const List<ActOption> kActs = [
  // --- Core criminal laws (IPC first for legacy/old cases, then the BNS regime)
  ActOption('Indian Penal Code, 1860 (IPC)', 'IPC'),
  ActOption('Bharatiya Nyaya Sanhita, 2023 (BNS)', 'BNS'),
  ActOption('Bharatiya Nagarik Suraksha Sanhita, 2023 (BNSS)', 'BNSS'),
  ActOption('Bharatiya Sakshya Adhiniyam, 2023 (BSA)', 'BSA'),
  ActOption('Code of Criminal Procedure, 1973 (CrPC)', 'CrPC'),
  ActOption('Indian Evidence Act, 1872', 'Evidence Act'),

  // --- Maharashtra criminal Acts
  ActOption('Maharashtra Police Act, 1951', 'Mah. Police Act'),
  ActOption(
    'Maharashtra Control of Organised Crime Act, 1999 (MCOCA)',
    'MCOCA',
  ),
  ActOption(
    'Maharashtra Prevention of Dangerous Activities Act, 1981 (MPDA)',
    'MPDA',
  ),
  ActOption(
    'Maharashtra Prevention of Gambling Act, 1887',
    'Mah. Gambling Act 1887',
  ),
  ActOption(
    'Maharashtra Gambling Prevention Act, 1949 / महाराष्ट्र जुगार प्रतिबंधक अधिनियम, 1949',
    'Mah. Gambling Act',
  ),
  ActOption(
    'Maharashtra Prohibition Act, 1949 / महाराष्ट्र दारूबंदी अधिनियम, 1949',
    'Mah. Prohibition Act',
  ),
  ActOption(
    'Maharashtra Prevention of Defacement of Property Act, 1995',
    'Defacement of Property Act',
  ),
  ActOption(
    'Maharashtra Prevention of Human Sacrifice and Black Magic Act, 2013 (Anti-Superstition)',
    'Anti-Superstition Act',
  ),
  ActOption(
    'Maharashtra Social Boycott (Prevention, Prohibition and Redressal) Act, 2016',
    'Social Boycott Act',
  ),
  ActOption(
    'Maharashtra Protection of Interest of Depositors Act, 1999 (MPID)',
    'MPID Act',
  ),
  ActOption(
    'Maharashtra Money-Lending (Regulation) Act, 2014',
    'Mah. Money-Lending Act',
  ),
  ActOption(
    'Maharashtra Animal Preservation Act, 1976',
    'Mah. Animal Preservation Act',
  ),
  ActOption(
    'Maharashtra Devadasi System (Abolition) Act, 2005',
    'Devadasi Abolition Act',
  ),
  ActOption('Bombay Prevention of Begging Act, 1959', 'Begging Prevention Act'),
  ActOption(
    'Maharashtra Beggars Prevention Act, 1887 / महाराष्ट्र भिक्षुक प्रतिबंधक अधिनियम, 1887',
    'Mah. Beggars Act',
  ),
  ActOption('Maharashtra Land Revenue Code, 1966', 'MLRC'),
  ActOption('Maharashtra Rent Control Act, 1999', 'Mah. Rent Control Act'),
  ActOption('Maharashtra Regional and Town Planning Act, 1966', 'MRTP Act'),

  // --- Crimes against women & children
  ActOption(
    'Protection of Children from Sexual Offences Act, 2012',
    'POCSO Act',
  ),
  ActOption(
    'Prohibition of Child Marriage Act, 2006 / बाल विवाह प्रतिबंधक अधिनियम, 2006',
    'PCM Act',
  ),
  ActOption('Dowry Prohibition Act, 1961', 'Dowry Prohibition Act'),
  ActOption('Protection of Women from Domestic Violence Act, 2005', 'DV Act'),
  ActOption('Immoral Traffic (Prevention) Act, 1956', 'ITP Act'),
  ActOption(
    'Indecent Representation of Women (Prohibition) Act, 1986',
    'IRW Act',
  ),
  ActOption('Medical Termination of Pregnancy Act, 1971', 'MTP Act'),
  ActOption(
    'Pre-Conception and Pre-Natal Diagnostic Techniques Act, 1994',
    'PCPNDT Act',
  ),
  ActOption(
    'Sexual Harassment of Women at Workplace Act, 2013 (POSH)',
    'POSH Act',
  ),

  // --- Narcotics, liquor & tobacco
  ActOption('Narcotic Drugs and Psychotropic Substances Act, 1985', 'NDPS Act'),
  ActOption('Cigarettes and Other Tobacco Products Act, 2003 (COTPA)', 'COTPA'),

  // --- Cyber & technology
  ActOption('Information Technology Act, 2000', 'IT Act'),
  ActOption('Digital Personal Data Protection Act, 2023', 'DPDP Act'),
  ActOption('Aadhaar Act, 2016', 'Aadhaar Act'),
  ActOption('Indian Telegraph Act, 1885', 'Telegraph Act'),
  ActOption('Telecommunications Act, 2023', 'Telecom Act'),

  // --- Corruption & financial crimes
  ActOption('Prevention of Corruption Act, 1988', 'PC Act'),
  ActOption('Prevention of Money Laundering Act, 2002 (PMLA)', 'PMLA'),
  ActOption('Benami Transactions (Prohibition) Act, 1988', 'Benami Act'),
  ActOption('Fugitive Economic Offenders Act, 2018', 'FEO Act'),
  ActOption(
    'Banning of Unregulated Deposit Schemes Act, 2019 (BUDS)',
    'BUDS Act',
  ),
  ActOption(
    'Prize Chits and Money Circulation Schemes (Banning) Act, 1978',
    'Prize Chits Act',
  ),
  ActOption(
    'Black Money (Undisclosed Foreign Income and Assets) Act, 2015',
    'Black Money Act',
  ),

  // --- Organised crime & national security
  ActOption('Unlawful Activities (Prevention) Act, 1967 (UAPA)', 'UAPA'),
  ActOption('National Security Act, 1980', 'NSA'),
  ActOption('Official Secrets Act, 1923', 'Official Secrets Act'),
  ActOption('National Investigation Agency Act, 2008', 'NIA Act'),
  ActOption('Armed Forces (Special Powers) Act, 1958 (AFSPA)', 'AFSPA'),

  // --- Explosives & weapons
  ActOption('Arms Act, 1959', 'Arms Act'),
  ActOption('Arms Rules, 2016', 'Arms Rules'),
  ActOption('Explosives Act, 1884 / स्फोटके अधिनियम, 1884', 'Explosives Act'),
  ActOption('Explosive Substances Act, 1908', 'Explosive Substances Act'),

  // --- Property & public safety
  ActOption('Prevention of Damage to Public Property Act, 1984', 'PDPP Act'),
  ActOption('Public Gambling Act, 1867', 'Public Gambling Act'),
  ActOption(
    'Ancient Monuments and Archaeological Sites and Remains Act, 1958',
    'AMASR Act',
  ),
  ActOption('Antiquities and Art Treasures Act, 1972', 'Antiquities Act'),
  ActOption(
    'Places of Worship (Special Provisions) Act, 1991',
    'Places of Worship Act',
  ),

  // --- SC/ST protection
  ActOption(
    'Scheduled Castes and Scheduled Tribes (Prevention of Atrocities) Act, 1989',
    'SC/ST Atrocities Act',
  ),

  // --- Environment & wildlife
  ActOption('Wildlife (Protection) Act, 1972', 'Wildlife Act'),
  ActOption('Forest (Conservation) Act, 1980', 'Forest Conservation Act'),
  ActOption('Indian Forest Act, 1927', 'Indian Forest Act'),
  ActOption('Environment (Protection) Act, 1986', 'EP Act'),
  ActOption(
    'Water (Prevention and Control of Pollution) Act, 1974',
    'Water Act',
  ),
  ActOption('Air (Prevention and Control of Pollution) Act, 1981', 'Air Act'),
  ActOption('Biological Diversity Act, 2002', 'Biodiversity Act'),
  ActOption('Public Liability Insurance Act, 1991', 'PLI Act'),

  // --- Motor vehicle & transport
  ActOption('Motor Vehicles Act, 1988', 'MV Act'),
  ActOption('Central Motor Vehicles Rules, 1989', 'CMV Rules'),
  ActOption('Railways Act, 1989', 'Railways Act'),
  ActOption('Railway Property (Unlawful Possession) Act, 1966', 'RPUP Act'),
  ActOption('Aircraft Act, 1934', 'Aircraft Act'),
  ActOption(
    'Suppression of Unlawful Acts Against Safety of Civil Aviation Act, 1982',
    'Aviation Safety Act',
  ),
  ActOption('Merchant Shipping Act, 1958', 'Merchant Shipping Act'),
  ActOption('Inland Vessels Act, 2021', 'Inland Vessels Act'),

  // --- Food, drugs & health
  ActOption('Food Safety and Standards Act, 2006', 'FSS Act'),
  ActOption('Drugs and Cosmetics Act, 1940', 'Drugs and Cosmetics Act'),
  ActOption(
    'Drugs and Magic Remedies (Objectionable Advertisements) Act, 1954',
    'DMR Act',
  ),
  ActOption('Pharmacy Act, 1948', 'Pharmacy Act'),
  ActOption('Mental Healthcare Act, 2017', 'Mental Healthcare Act'),
  ActOption('Transplantation of Human Organs and Tissues Act, 1994', 'THOTA'),

  // --- Essential commodities & economic offences
  ActOption('Essential Commodities Act, 1955', 'EC Act'),
  ActOption('Legal Metrology Act, 2009', 'Legal Metrology Act'),

  // --- Banking, securities & corporate
  ActOption('Reserve Bank of India Act, 1934', 'RBI Act'),
  ActOption('Banking Regulation Act, 1949', 'Banking Regulation Act'),
  ActOption('Negotiable Instruments Act, 1881', 'NI Act'),
  ActOption('SARFAESI Act, 2002', 'SARFAESI Act'),
  ActOption('Companies Act, 2013', 'Companies Act'),
  ActOption('Limited Liability Partnership Act, 2008', 'LLP Act'),
  ActOption('Insolvency and Bankruptcy Code, 2016', 'IBC'),
  ActOption('Securities Contracts (Regulation) Act, 1956', 'SCRA'),
  ActOption('Securities and Exchange Board of India Act, 1992', 'SEBI Act'),
  ActOption('Depositories Act, 1996', 'Depositories Act'),
  ActOption('Chit Funds Act, 1982', 'Chit Funds Act'),
  ActOption('Competition Act, 2002', 'Competition Act'),

  // --- Tax & revenue
  ActOption('Income-tax Act, 1961', 'Income-tax Act'),
  ActOption('Central Goods and Services Tax Act, 2017', 'CGST Act'),
  ActOption('Customs Act, 1962', 'Customs Act'),
  ActOption('Central Excise Act, 1944', 'Central Excise Act'),

  // --- Intellectual property
  ActOption('Copyright Act, 1957', 'Copyright Act'),
  ActOption('Trade Marks Act, 1999', 'Trade Marks Act'),
  ActOption('Patents Act, 1970', 'Patents Act'),
  ActOption('Designs Act, 2000', 'Designs Act'),
  ActOption('Geographical Indications of Goods Act, 1999', 'GI Act'),
  ActOption(
    'Semiconductor Integrated Circuits Layout-Design Act, 2000',
    'SICLD Act',
  ),

  // --- Consumer & standards
  ActOption('Consumer Protection Act, 2019', 'CP Act'),
  ActOption('Bureau of Indian Standards Act, 2016', 'BIS Act'),

  // --- Labour & human rights
  ActOption('Code on Wages, 2019', 'Code on Wages'),
  ActOption('Industrial Relations Code, 2020', 'IR Code'),
  ActOption("Employees' Provident Funds Act, 1952", 'EPF Act'),
  ActOption('Bonded Labour System (Abolition) Act, 1976', 'Bonded Labour Act'),
  ActOption(
    'Child and Adolescent Labour (Prohibition and Regulation) Act, 1986',
    'Child Labour Act',
  ),
  ActOption('Inter-State Migrant Workmen Act, 1979', 'ISMW Act'),
  ActOption('Rights of Persons with Disabilities Act, 2016', 'RPwD Act'),
  ActOption(
    'Maintenance and Welfare of Parents and Senior Citizens Act, 2007',
    'Sr. Citizens Act',
  ),

  // --- Public order & emergencies
  ActOption('Disaster Management Act, 2005', 'Disaster Management Act'),
  ActOption('Epidemic Diseases Act, 1897', 'Epidemic Diseases Act'),

  // --- Election
  ActOption('Representation of the People Act, 1950', 'RP Act 1950'),
  ActOption('Representation of the People Act, 1951', 'RP Act 1951'),

  // --- Family & personal law
  ActOption('Hindu Marriage Act, 1955', 'Hindu Marriage Act'),
  ActOption('Hindu Succession Act, 1956', 'Hindu Succession Act'),
  ActOption('Special Marriage Act, 1954', 'Special Marriage Act'),
  ActOption(
    'Muslim Personal Law (Shariat) Application Act, 1937',
    'Shariat Act',
  ),

  // --- Property & land
  ActOption('Transfer of Property Act, 1882', 'TP Act'),
  ActOption('Registration Act, 1908', 'Registration Act'),
  ActOption('Indian Easements Act, 1882', 'Easements Act'),
  ActOption(
    'Public Premises (Eviction of Unauthorised Occupants) Act, 1971',
    'Public Premises Act',
  ),

  // --- Education
  ActOption('Right to Education Act, 2009', 'RTE Act'),
  ActOption('University Grants Commission Act, 1956', 'UGC Act'),

  // --- Governance & miscellaneous
  ActOption('Right to Information Act, 2005', 'RTI Act'),
  ActOption('Whistle Blowers Protection Act, 2014', 'Whistle Blowers Act'),
  ActOption(
    'Emblems and Names (Prevention of Improper Use) Act, 1950',
    'Emblems and Names Act',
  ),
  ActOption('Young Persons (Harmful Publications) Act, 1956', 'YPHP Act'),
  ActOption('Official Languages Act, 1963', 'Official Languages Act'),

  // Catch-all
  ActOption('Other / इतर', 'Other'),
];

/// Case-stage codes — where the FIR currently stands. Multiple can apply at
/// once (e.g. chargesheet filed + further investigation), so they are stored as
/// a comma-separated list in the `case_stage` column. Labels: `crime.stage.*`.
///   investigation → under investigation
///   chargesheet   → chargesheet filed
///   court         → trial in court
///   disposed      → disposed / closed
/// ('both' is a legacy single value kept only for displaying older records.)
const List<String> kCaseStages = [
  'investigation',
  'chargesheet',
  'court',
  'disposed',
];

/// Reference lists for the crime-entry dropdowns.
///
/// [kBnsSections] is just the section *numbers* (Bharatiya Nyaya Sanhita, 2023)
/// — no offence names — so officers pick/add bare sections like "103", "307".
/// It is NOT the full code; the section field stays free-text, so any section or
/// combination not listed can still be typed and added.
const List<String> kBnsSections = [
  '3(5)',
  '61',
  '62',
  '64',
  '65',
  '66',
  '70',
  '74',
  '75',
  '76',
  '77',
  '78',
  '79',
  '80',
  '84',
  '85',
  '103',
  '105',
  '106',
  '108',
  '109',
  '110',
  '111',
  '112',
  '113',
  '115',
  '117',
  '118',
  '120',
  '121',
  '124',
  '125',
  '126',
  '127',
  '131',
  '137',
  '140',
  '143',
  '147',
  '152',
  '189',
  '190',
  '191',
  '193',
  '196',
  '296',
  '303',
  '304',
  '305',
  '306',
  '309',
  '310',
  '314',
  '316',
  '318',
  '319',
  '320',
  '324',
  '326',
  '329',
  '331',
  '336',
  '338',
  '340',
  '351',
  '352',
  '356',
];

/// Police stations of Chhatrapati Sambhaji Nagar shown in the station picker.
/// The field stays free-text (autocomplete), so any station not listed — and
/// existing values on old records — can still be typed and kept.
const List<String> kPoliceStations = [
  'City Chowk',
  'Kranti Chowk',
  'Vedant Nagar',
  'Begumpura',
  'Chhavani',
  'Waluj',
  'MIDC Waluj',
  'Daulatabad',
  'Jinsi',
  'CIDCO',
  'MIDC CIDCO',
  'Harsul',
  'Jawahar Nagar',
  'Usmanpura',
  'Pundlik Nagar',
  'Mukundwadi',
  'Satara',
  'Cyber Police Station',
];

/// Marathi spellings of [kPoliceStations], used to canonicalize imported
/// register data — so "दौलताबाद" and "Daulatabad" are ONE station everywhere
/// (dashboard charts, officer portal, exports). Mirrors ORG_STATIONS_MR on the
/// server (db.php); keep the two in sync.
const Map<String, String> kPoliceStationsMr = {
  'City Chowk': 'सिटी चौक',
  'Kranti Chowk': 'क्रांती चौक',
  'Vedant Nagar': 'वेदांत नगर',
  'Begumpura': 'बेगमपुरा',
  'Chhavani': 'छावणी',
  'Waluj': 'वाळूज',
  'MIDC Waluj': 'एमआयडीसी वाळूज',
  'Daulatabad': 'दौलताबाद',
  'Jinsi': 'जिन्सी',
  'CIDCO': 'सिडको',
  'MIDC CIDCO': 'एमआयडीसी सिडको',
  'Harsul': 'हर्सूल',
  'Jawahar Nagar': 'जवाहर नगर',
  'Usmanpura': 'उस्मानपुरा',
  'Pundlik Nagar': 'पुंडलिक नगर',
  'Mukundwadi': 'मुकुंदवाडी',
  'Satara': 'सातारा',
  'Cyber Police Station': 'सायबर पोलीस स्टेशन',
};

final Map<String, String> _canonicalStationByNorm = () {
  final m = <String, String>{};
  for (final s in kPoliceStations) {
    m[_normStation(s)] = s;
    final mr = kPoliceStationsMr[s];
    if (mr != null) m[_normStation(mr)] = s;
  }
  return m;
}();

/// The canonical station name for [raw]: matches the English or Marathi
/// spelling ignoring case, spacing, punctuation, Devanagari-vs-ASCII digits
/// and "पोलीस स्टेशन / police station" tails. Unknown names are returned
/// unchanged (the field stays free-text). Null/blank stays null.
String? canonicalStationName(String? raw) {
  final t = raw?.trim();
  if (t == null || t.isEmpty) return null;
  return _canonicalStationByNorm[_normStation(t)] ?? t;
}

String _normStation(String s) {
  const dev = ['०', '१', '२', '३', '४', '५', '६', '७', '८', '९'];
  var v = s.toLowerCase();
  for (var i = 0; i < 10; i++) {
    v = v.replaceAll(dev[i], '$i');
  }
  v = v
      .replaceAll(RegExp(r'(पोलीस|पोलिस)\s*(स्टेशन|ठाणे|स्टे)\.?'), '')
      .replaceAll(RegExp(r'police\s*station'), '')
      .replaceAll(RegExp(r'पो\.?\s*(स्टे|ठाणे)\.?'), '');
  return v.replaceAll(RegExp(r'[\s.\-_,()]+'), '');
}

/// Common crime-type names (English / Marathi) for the crime-type dropdown.
/// The crime-type field is what the dashboard groups by, so keeping these
/// consistent gives cleaner analytics — but it stays free-text too.
const List<String> kCrimeTypes = [
  'Murder / खून',
  'Attempt to murder / खुनाचा प्रयत्न',
  'Culpable homicide / सदोष मनुष्यवध',
  'Death by negligence / निष्काळजीपणाने मृत्यू',
  'Hurt / दुखापत',
  'Grievous hurt / गंभीर दुखापत',
  'Assault / हल्ला',
  'Acid attack / अॅसिड हल्ला',
  'Theft / चोरी',
  'House-breaking theft / घरफोडी चोरी',
  'Vehicle theft / वाहन चोरी',
  'Snatching / हिसकावणे',
  'Robbery / जबरी चोरी',
  'Dacoity / दरोडा',
  'Burglary / घरफोडी',
  'Cheating / फसवणूक',
  'Criminal breach of trust / विश्वासघात',
  'Forgery / बनावट दस्तऐवज',
  'Mischief / नुकसान',
  'Criminal trespass / अनधिकृत प्रवेश',
  'Kidnapping / अपहरण',
  'Human trafficking / मानवी तस्करी',
  'Rape / बलात्कार',
  'Sexual harassment / लैंगिक छळ',
  'Outraging modesty / विनयभंग',
  'Stalking / पाठलाग',
  'Domestic violence / कौटुंबिक हिंसा',
  'Dowry death / हुंडाबळी',
  'Cruelty by husband (498A) / पतीकडून छळ',
  'Criminal intimidation / धमकी',
  'Defamation / बदनामी',
  'Riot / दंगल',
  'Unlawful assembly / बेकायदा जमाव',
  'Cyber crime / सायबर गुन्हा',
  'Online fraud / ऑनलाइन फसवणूक',
  'NDPS / अंमली पदार्थ',
  'Excise / उत्पादन शुल्क',
  'Gambling / जुगार',
  'Prohibition / दारूबंदी',
  'Arms Act / शस्त्र कायदा',
  'Accident / अपघात',
  'Missing person / बेपत्ता व्यक्ती',
  'Suicide / आत्महत्या',
  'Abetment of suicide / आत्महत्येस प्रवृत्त',
  'Organised crime / संघटित गुन्हा',
  'Terrorist act / दहशतवादी कृत्य',
  'Other / इतर',
];
