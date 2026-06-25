/// An Act/law a section belongs to. [code] is the short form stored alongside
/// the section number (e.g. "BNS 103"); [name] is shown in the dropdown.
class ActOption {
  const ActOption(this.name, this.code);
  final String name;
  final String code;
}

/// Acts available in the section picker, grouped by area of law.
const List<ActOption> kActs = [
  // Criminal (IPC first for legacy/old cases, then the new BNS regime)
  ActOption('Indian Penal Code, 1860 (IPC)', 'IPC'),
  ActOption('Bharatiya Nyaya Sanhita, 2023 (BNS)', 'BNS'),
  ActOption('Bharatiya Nagarik Suraksha Sanhita, 2023 (BNSS)', 'BNSS'),
  ActOption('Bharatiya Sakshya Adhiniyam, 2023 (BSA)', 'BSA'),
  ActOption('Narcotic Drugs and Psychotropic Substances Act, 1985', 'NDPS Act'),
  ActOption('Prevention of Corruption Act, 1988', 'PC Act'),
  ActOption('Arms Act, 1959', 'Arms Act'),
  ActOption('Explosive Substances Act, 1908', 'Explosive Substances Act'),
  // Cyber & Technology
  ActOption('Information Technology Act, 2000', 'IT Act'),
  ActOption('Digital Personal Data Protection Act, 2023', 'DPDP Act'),
  // Motor Vehicle & Transport
  ActOption('Motor Vehicles Act, 1988', 'MV Act'),
  ActOption('Central Motor Vehicles Rules, 1989', 'CMV Rules'),
  // Police & Public Order
  ActOption('Maharashtra Police Act, 1951', 'Mah. Police Act'),
  ActOption('National Security Act, 1980', 'NSA'),
  // Labour & Employment
  ActOption('Code on Wages, 2019', 'Code on Wages'),
  ActOption('Industrial Relations Code, 2020', 'IR Code'),
  ActOption("Employees' Provident Funds Act, 1952", 'EPF Act'),
  // Family
  ActOption('Hindu Marriage Act, 1955', 'Hindu Marriage Act'),
  ActOption('Hindu Succession Act, 1956', 'Hindu Succession Act'),
  ActOption('Special Marriage Act, 1954', 'Special Marriage Act'),
  ActOption('Muslim Personal Law (Shariat) Application Act, 1937', 'Shariat Act'),
  // Property & Land
  ActOption('Transfer of Property Act, 1882', 'TP Act'),
  ActOption('Registration Act, 1908', 'Registration Act'),
  ActOption('Indian Easements Act, 1882', 'Easements Act'),
  // Company & Business
  ActOption('Companies Act, 2013', 'Companies Act'),
  ActOption('Limited Liability Partnership Act, 2008', 'LLP Act'),
  ActOption('Competition Act, 2002', 'Competition Act'),
  // Banking & Finance
  ActOption('Reserve Bank of India Act, 1934', 'RBI Act'),
  ActOption('Banking Regulation Act, 1949', 'Banking Regulation Act'),
  ActOption('SARFAESI Act, 2002', 'SARFAESI Act'),
  // Tax
  ActOption('Income-tax Act, 1961', 'Income-tax Act'),
  ActOption('Central Goods and Services Tax Act, 2017', 'CGST Act'),
  // Environment
  ActOption('Environment (Protection) Act, 1986', 'EP Act'),
  ActOption('Water (Prevention and Control of Pollution) Act, 1974', 'Water Act'),
  ActOption('Air (Prevention and Control of Pollution) Act, 1981', 'Air Act'),
  // Consumer
  ActOption('Consumer Protection Act, 2019', 'CP Act'),
  ActOption('Legal Metrology Act, 2009', 'Legal Metrology Act'),
  // Education
  ActOption('Right to Education Act, 2009', 'RTE Act'),
  ActOption('University Grants Commission Act, 1956', 'UGC Act'),
  // Women & Child Protection
  ActOption('Protection of Women from Domestic Violence Act, 2005', 'DV Act'),
  ActOption('Protection of Children from Sexual Offences Act, 2012', 'POCSO Act'),
  ActOption('Dowry Prohibition Act, 1961', 'Dowry Prohibition Act'),
  // Social Welfare
  ActOption('Rights of Persons with Disabilities Act, 2016', 'RPwD Act'),
  ActOption('Maintenance and Welfare of Parents and Senior Citizens Act, 2007',
      'Sr. Citizens Act'),
  // Election
  ActOption('Representation of the People Act, 1950', 'RP Act 1950'),
  ActOption('Representation of the People Act, 1951', 'RP Act 1951'),
  // Maharashtra-specific
  ActOption('Maharashtra Land Revenue Code, 1966', 'MLRC'),
  ActOption('Maharashtra Rent Control Act, 1999', 'Mah. Rent Control Act'),
  ActOption('Maharashtra Regional and Town Planning Act, 1966', 'MRTP Act'),
  // Catch-all
  ActOption('Other / इतर', 'Other'),
];

/// Reference lists for the crime-entry dropdowns.
///
/// [kBnsSections] is just the section *numbers* (Bharatiya Nyaya Sanhita, 2023)
/// — no offence names — so officers pick/add bare sections like "103", "307".
/// It is NOT the full code; the section field stays free-text, so any section or
/// combination not listed can still be typed and added.
const List<String> kBnsSections = [
  '3(5)', '61', '62', '64', '65', '66', '70', '74', '75', '76', '77', '78',
  '79', '80', '84', '85', '103', '105', '106', '108', '109', '110', '111',
  '112', '113', '115', '117', '118', '120', '121', '124', '125', '126', '127',
  '131', '137', '140', '143', '147', '152', '189', '190', '191', '193', '196',
  '296', '303', '304', '305', '306', '309', '310', '314', '316', '318', '319',
  '320', '324', '326', '329', '331', '336', '338', '340', '351', '352', '356',
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
