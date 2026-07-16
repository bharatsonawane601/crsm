// Hierarchical, bilingual (English / Marathi) crime-type catalogue used by the
// crime-type picker. Officers drill into a category (Murder, Theft, Cyber
// Crime, …) and pick a specific sub-type (Contract Killing, ATM Robbery, …).
//
// The picker stores the chosen sub-type as a single "English / Marathi" string
// (see CrimeSubType.label) into the existing free-text `crimeType` column, so
// reports, search and the dashboard keep working unchanged. The field still
// accepts custom free text for anything not listed.

/// A leaf crime sub-type with both language labels.
class CrimeSubType {
  const CrimeSubType(this.en, this.mr);
  final String en;
  final String mr;

  /// Stored / displayed value, e.g. "Contract Killing / सुपारी हत्या".
  String get label => '$en / $mr';
}

/// A top-level crime category grouping many [subtypes].
class CrimeCategory {
  const CrimeCategory(this.en, this.mr, this.subtypes);
  final String en;
  final String mr;
  final List<CrimeSubType> subtypes;

  String get label => '$en / $mr';
}

/// The full category → sub-type tree shown in the crime-type picker.
const List<CrimeCategory> kCrimeCategories = [
  CrimeCategory('Murder', 'खून', [
    CrimeSubType('Contract Killing (Supari)', 'सुपारी हत्या'),
    CrimeSubType('Revenge Murder', 'सूड हत्या'),
    CrimeSubType('Personal Enmity Murder', 'वैयक्तिक वैरातून खून'),
    CrimeSubType('Love Affair Murder', 'प्रेमप्रकरणातून खून'),
    CrimeSubType('Honour Killing', 'इभ्रतीसाठी हत्या'),
    CrimeSubType('Dowry Murder', 'हुंडाबळी हत्या'),
    CrimeSubType('Property Dispute Murder', 'मालमत्ता वादातून खून'),
    CrimeSubType('Family Dispute Murder', 'कौटुंबिक वादातून खून'),
    CrimeSubType('Political Rivalry Murder', 'राजकीय वैरातून खून'),
    CrimeSubType('Business Rivalry Murder', 'व्यावसायिक वैरातून खून'),
    CrimeSubType('Caste-related Murder', 'जातीय हत्या'),
    CrimeSubType('Religious Hatred Murder', 'धार्मिक द्वेषातून खून'),
    CrimeSubType('Human Sacrifice', 'नरबळी'),
    CrimeSubType('Witchcraft-related Murder', 'जादूटोण्यातून खून'),
    CrimeSubType('Mob Lynching', 'जमावाकडून हत्या'),
    CrimeSubType('Road Rage Murder', 'रस्ता वादातून खून'),
    CrimeSubType('Robbery with Murder', 'जबरी चोरीसह खून'),
    CrimeSubType('Dacoity with Murder', 'दरोड्यासह खून'),
    CrimeSubType('Kidnapping followed by Murder', 'अपहरणानंतर खून'),
    CrimeSubType('Rape followed by Murder', 'बलात्कारानंतर खून'),
    CrimeSubType('Terrorist Murder', 'दहशतवादी हत्या'),
    CrimeSubType('Gang Rivalry Murder', 'टोळी वैरातून खून'),
    CrimeSubType('Organized Crime Murder', 'संघटित गुन्ह्यातून खून'),
    CrimeSubType('Poisoning Murder', 'विषप्रयोगाने खून'),
    CrimeSubType('Burning Murder', 'जाळून खून'),
    CrimeSubType('Strangulation', 'गळा दाबून खून'),
    CrimeSubType('Stabbing', 'भोसकून खून'),
    CrimeSubType('Shooting', 'गोळी झाडून खून'),
    CrimeSubType('Blunt Weapon Murder', 'बोथट शस्त्राने खून'),
    CrimeSubType('Acid Attack causing Death', 'अॅसिड हल्ल्याने मृत्यू'),
    CrimeSubType('Electrocution Murder', 'विजेचा धक्का देऊन खून'),
    CrimeSubType('Suffocation', 'गुदमरवून खून'),
    CrimeSubType('Drowning Murder', 'बुडवून खून'),
    CrimeSubType('Other Murder', 'इतर खून'),
  ]),
  CrimeCategory('Attempt to Murder', 'खुनाचा प्रयत्न', [
    CrimeSubType('Attempt by Shooting', 'गोळीबाराने प्रयत्न'),
    CrimeSubType('Attempt by Stabbing', 'भोसकून प्रयत्न'),
    CrimeSubType('Attempt by Poisoning', 'विषप्रयोगाने प्रयत्न'),
    CrimeSubType('Attempt by Assault', 'मारहाणीने प्रयत्न'),
    CrimeSubType('Attempt by Vehicle', 'वाहनाने चिरडण्याचा प्रयत्न'),
    CrimeSubType('Other Attempt to Murder', 'खुनाचा इतर प्रयत्न'),
  ]),
  CrimeCategory('Culpable Homicide', 'सदोष मनुष्यवध', [
    CrimeSubType('Death by Negligence', 'निष्काळजीपणाने मृत्यू'),
    CrimeSubType('Medical Negligence causing Death', 'वैद्यकीय हलगर्जीने मृत्यू'),
    CrimeSubType('Death in Sudden Fight', 'अचानक भांडणात मृत्यू'),
    CrimeSubType('Death by Rash Act', 'हयगयीच्या कृतीने मृत्यू'),
    CrimeSubType('Other Culpable Homicide', 'इतर सदोष मनुष्यवध'),
  ]),
  CrimeCategory('Kidnapping & Abduction', 'अपहरण व पळवून नेणे', [
    CrimeSubType('Kidnapping for Ransom', 'खंडणीसाठी अपहरण'),
    CrimeSubType('Child Kidnapping', 'बालकाचे अपहरण'),
    CrimeSubType('Abduction of Woman', 'स्त्रीचे अपहरण'),
    CrimeSubType('Forced Marriage', 'सक्तीचा विवाह'),
    CrimeSubType('Illegal Adoption', 'बेकायदा दत्तक'),
    CrimeSubType('Custodial Kidnapping', 'ताब्यातून अपहरण'),
    CrimeSubType('Missing Child (Suspected Kidnap)', 'बेपत्ता बालक (अपहरण संशय)'),
    CrimeSubType('Other Kidnapping', 'इतर अपहरण'),
  ]),
  CrimeCategory('Human Trafficking', 'मानवी तस्करी', [
    CrimeSubType('Trafficking for Prostitution', 'देहविक्रीसाठी तस्करी'),
    CrimeSubType('Child Trafficking', 'बाल तस्करी'),
    CrimeSubType('Labour Trafficking', 'मजुरीसाठी तस्करी'),
    CrimeSubType('Organ Trafficking', 'अवयव तस्करी'),
    CrimeSubType('Bonded Labour', 'वेठबिगारी'),
    CrimeSubType('Other Trafficking', 'इतर तस्करी'),
  ]),
  CrimeCategory('Robbery', 'जबरी चोरी', [
    CrimeSubType('Highway Robbery', 'महामार्ग जबरी चोरी'),
    CrimeSubType('House Robbery', 'घरात जबरी चोरी'),
    CrimeSubType('ATM Robbery', 'एटीएम जबरी चोरी'),
    CrimeSubType('Bank Robbery', 'बँक जबरी चोरी'),
    CrimeSubType('Jewellery Shop Robbery', 'सराफा दुकान जबरी चोरी'),
    CrimeSubType('Cash Van Robbery', 'रोकड व्हॅन जबरी चोरी'),
    CrimeSubType('Armed Robbery', 'सशस्त्र जबरी चोरी'),
    CrimeSubType('Mobile Snatching', 'मोबाईल हिसकावणे'),
    CrimeSubType('Chain Snatching', 'सोनसाखळी हिसकावणे'),
    CrimeSubType('Other Robbery', 'इतर जबरी चोरी'),
  ]),
  CrimeCategory('Dacoity', 'दरोडा', [
    CrimeSubType('House Dacoity', 'घर दरोडा'),
    CrimeSubType('Highway Dacoity', 'महामार्ग दरोडा'),
    CrimeSubType('Bank Dacoity', 'बँक दरोडा'),
    CrimeSubType('Preparation/Assembly for Dacoity', 'दरोड्याची तयारी/जमाव'),
    CrimeSubType('Other Dacoity', 'इतर दरोडा'),
  ]),
  CrimeCategory('Theft', 'चोरी', [
    CrimeSubType('Vehicle Theft', 'वाहन चोरी'),
    CrimeSubType('Two-Wheeler Theft', 'दुचाकी चोरी'),
    CrimeSubType('Four-Wheeler Theft', 'चारचाकी चोरी'),
    CrimeSubType('Mobile Theft', 'मोबाईल चोरी'),
    CrimeSubType('Laptop Theft', 'लॅपटॉप चोरी'),
    CrimeSubType('House Theft', 'घर चोरी'),
    CrimeSubType('Shop Theft', 'दुकान चोरी'),
    CrimeSubType('Office Theft', 'कार्यालय चोरी'),
    CrimeSubType('Pickpocketing', 'खिसा कापणे'),
    CrimeSubType('Electricity Theft', 'वीज चोरी'),
    CrimeSubType('Cable/Wire Theft', 'केबल/तार चोरी'),
    CrimeSubType('Agricultural Theft', 'शेती चोरी'),
    CrimeSubType('Livestock Theft', 'जनावरे चोरी'),
    CrimeSubType('Temple Theft', 'मंदिर चोरी'),
    CrimeSubType('Crop Theft', 'पीक चोरी'),
    CrimeSubType('Metal/Scrap Theft', 'धातू/भंगार चोरी'),
    CrimeSubType('Sand/Mineral Theft', 'वाळू/खनिज चोरी'),
    CrimeSubType('Other Theft', 'इतर चोरी'),
  ]),
  CrimeCategory('Burglary / House-breaking', 'घरफोडी', [
    CrimeSubType('Day House-breaking', 'दिवसा घरफोडी'),
    CrimeSubType('Night House-breaking', 'रात्री घरफोडी'),
    CrimeSubType('Lock-breaking Theft', 'कुलूप तोडून चोरी'),
    CrimeSubType('Shutter-breaking Theft', 'शटर तोडून चोरी'),
    CrimeSubType('Wall-breaking Theft', 'भिंत फोडून चोरी'),
    CrimeSubType('Other Burglary', 'इतर घरफोडी'),
  ]),
  CrimeCategory('Extortion', 'खंडणी', [
    CrimeSubType('Threat for Money', 'पैशासाठी धमकी'),
    CrimeSubType('Protection Money', 'खंडणी वसुली'),
    CrimeSubType('Online/Phone Extortion', 'ऑनलाईन/फोन खंडणी'),
    CrimeSubType('Extortion by Gang', 'टोळीकडून खंडणी'),
    CrimeSubType('Other Extortion', 'इतर खंडणी'),
  ]),
  CrimeCategory('Cheating & Fraud', 'फसवणूक', [
    CrimeSubType('Cheating', 'फसवणूक'),
    CrimeSubType('Online Fraud', 'ऑनलाईन फसवणूक'),
    CrimeSubType('Job Fraud', 'नोकरी फसवणूक'),
    CrimeSubType('Marriage Fraud', 'विवाह फसवणूक'),
    CrimeSubType('Land/Property Fraud', 'जमीन/मालमत्ता फसवणूक'),
    CrimeSubType('Investment Scam', 'गुंतवणूक घोटाळा'),
    CrimeSubType('Chit Fund Fraud', 'चिटफंड फसवणूक'),
    CrimeSubType('Insurance Fraud', 'विमा फसवणूक'),
    CrimeSubType('Loan Fraud', 'कर्ज फसवणूक'),
    CrimeSubType('Bank Fraud', 'बँक फसवणूक'),
    CrimeSubType('GST/Tax Fraud', 'जीएसटी/कर फसवणूक'),
    CrimeSubType('Fake Document Fraud', 'बनावट कागदपत्र फसवणूक'),
    CrimeSubType('Impersonation Fraud', 'तोतयागिरी फसवणूक'),
    CrimeSubType('Other Cheating', 'इतर फसवणूक'),
  ]),
  CrimeCategory('Criminal Breach of Trust', 'विश्वासघात', [
    CrimeSubType('Misappropriation of Funds', 'निधी अपहार'),
    CrimeSubType('Breach of Trust by Employee', 'कर्मचाऱ्याकडून विश्वासघात'),
    CrimeSubType('Breach of Trust by Agent', 'प्रतिनिधीकडून विश्वासघात'),
    CrimeSubType('Other Breach of Trust', 'इतर विश्वासघात'),
  ]),
  CrimeCategory('Forgery & Counterfeiting', 'बनावटगिरी', [
    CrimeSubType('Document Forgery', 'कागदपत्र बनावट'),
    CrimeSubType('Signature Forgery', 'सही बनावट'),
    CrimeSubType('Fake Currency', 'बनावट चलन'),
    CrimeSubType('Fake Stamp/Seal', 'बनावट शिक्का/मुद्रा'),
    CrimeSubType('Fake Certificates', 'बनावट प्रमाणपत्रे'),
    CrimeSubType('Counterfeit Goods', 'बनावट माल'),
    CrimeSubType('Other Forgery', 'इतर बनावटगिरी'),
  ]),
  CrimeCategory('Cyber Crime', 'सायबर गुन्हा', [
    CrimeSubType('Online Fraud', 'ऑनलाईन फसवणूक'),
    CrimeSubType('UPI Fraud', 'यूपीआय फसवणूक'),
    CrimeSubType('Credit/Debit Card Fraud', 'क्रेडिट/डेबिट कार्ड फसवणूक'),
    CrimeSubType('OTP Fraud', 'ओटीपी फसवणूक'),
    CrimeSubType('Phishing', 'फिशिंग'),
    CrimeSubType('Identity Theft', 'ओळख चोरी'),
    CrimeSubType('Hacking', 'हॅकिंग'),
    CrimeSubType('Data Theft', 'डेटा चोरी'),
    CrimeSubType('Social Media Fraud', 'सोशल मीडिया फसवणूक'),
    CrimeSubType('Fake Website', 'बनावट संकेतस्थळ'),
    CrimeSubType('Malware Attack', 'मालवेअर हल्ला'),
    CrimeSubType('Ransomware', 'रॅन्समवेअर'),
    CrimeSubType('Crypto Scam', 'क्रिप्टो घोटाळा'),
    CrimeSubType('Sextortion', 'सेक्सटॉर्शन'),
    CrimeSubType('SIM Swap Fraud', 'सिम स्वॅप फसवणूक'),
    CrimeSubType('Cyber Stalking', 'सायबर पाठलाग'),
    CrimeSubType('Cyber Bullying', 'सायबर छळ'),
    CrimeSubType('Online Defamation', 'ऑनलाईन बदनामी'),
    CrimeSubType('Fake Profile', 'बनावट प्रोफाइल'),
    CrimeSubType('Job/Loan App Fraud', 'नोकरी/कर्ज अॅप फसवणूक'),
    CrimeSubType('Matrimonial Fraud', 'विवाह संकेतस्थळ फसवणूक'),
    CrimeSubType('Child Pornography (Online)', 'बाल अश्लीलता (ऑनलाईन)'),
    CrimeSubType('Other Cyber Crime', 'इतर सायबर गुन्हा'),
  ]),
  CrimeCategory('Sexual Offences', 'लैंगिक गुन्हे', [
    CrimeSubType('Rape', 'बलात्कार'),
    CrimeSubType('Gang Rape', 'सामूहिक बलात्कार'),
    CrimeSubType('Attempt to Rape', 'बलात्काराचा प्रयत्न'),
    CrimeSubType('Sexual Harassment', 'लैंगिक छळ'),
    CrimeSubType('Outraging Modesty (Molestation)', 'विनयभंग'),
    CrimeSubType('Stalking', 'पाठलाग'),
    CrimeSubType('Voyeurism', 'छुपी चित्रण'),
    CrimeSubType('Sexual Assault', 'लैंगिक अत्याचार'),
    CrimeSubType('Workplace Sexual Harassment', 'कामाच्या ठिकाणी लैंगिक छळ'),
    CrimeSubType('Unnatural Offence', 'अनैसर्गिक कृत्य'),
    CrimeSubType('Other Sexual Offence', 'इतर लैंगिक गुन्हा'),
  ]),
  CrimeCategory('Crimes against Children (POCSO)', 'बाल अत्याचार (पोक्सो)', [
    CrimeSubType('Child Sexual Abuse', 'बाल लैंगिक अत्याचार'),
    CrimeSubType('Penetrative Sexual Assault', 'भेदक लैंगिक अत्याचार'),
    CrimeSubType('Aggravated Sexual Assault', 'गंभीर लैंगिक अत्याचार'),
    CrimeSubType('Child Pornography', 'बाल अश्लीलता'),
    CrimeSubType('Sexual Harassment of Child', 'बालकाचा लैंगिक छळ'),
    CrimeSubType('Child Labour', 'बाल मजुरी'),
    CrimeSubType('Child Marriage', 'बाल विवाह'),
    CrimeSubType('Child Begging', 'बाल भीक मागणे'),
    CrimeSubType('Other Child Crime', 'इतर बाल गुन्हा'),
  ]),
  CrimeCategory('Domestic Violence & Dowry', 'कौटुंबिक हिंसा व हुंडा', [
    CrimeSubType('Cruelty by Husband/Relatives (498A)', 'पती/नातेवाईकांकडून छळ (४९८अ)'),
    CrimeSubType('Dowry Harassment', 'हुंडा छळ'),
    CrimeSubType('Dowry Death', 'हुंडाबळी'),
    CrimeSubType('Physical Abuse', 'शारीरिक छळ'),
    CrimeSubType('Mental Abuse', 'मानसिक छळ'),
    CrimeSubType('Economic Abuse', 'आर्थिक छळ'),
    CrimeSubType('Verbal Abuse', 'शाब्दिक छळ'),
    CrimeSubType('Desertion', 'त्याग/सोडून देणे'),
    CrimeSubType('Other Domestic Violence', 'इतर कौटुंबिक हिंसा'),
  ]),
  CrimeCategory('Assault & Hurt', 'हल्ला व दुखापत', [
    CrimeSubType('Simple Hurt', 'साधी दुखापत'),
    CrimeSubType('Grievous Hurt', 'गंभीर दुखापत'),
    CrimeSubType('Hurt by Dangerous Weapon', 'घातक शस्त्राने दुखापत'),
    CrimeSubType('Acid Attack', 'अॅसिड हल्ला'),
    CrimeSubType('Criminal Force', 'गुन्हेगारी बळ'),
    CrimeSubType('Assault on Public Servant', 'शासकीय सेवकावर हल्ला'),
    CrimeSubType('Assault on Police', 'पोलिसांवर हल्ला'),
    CrimeSubType('Assault on Woman', 'महिलेवर हल्ला'),
    CrimeSubType('Assault on Child', 'बालकावर हल्ला'),
    CrimeSubType('Group Assault', 'सामूहिक हल्ला'),
    CrimeSubType('Other Assault', 'इतर हल्ला'),
  ]),
  CrimeCategory('Property / Mischief / Arson', 'मालमत्ता गुन्हे', [
    CrimeSubType('Criminal Trespass', 'गुन्हेगारी अतिक्रमण'),
    CrimeSubType('House Trespass', 'घरात अतिक्रमण'),
    CrimeSubType('Mischief', 'नुकसान'),
    CrimeSubType('Arson', 'जाळपोळ'),
    CrimeSubType('Damage to Public Property', 'सार्वजनिक मालमत्तेचे नुकसान'),
    CrimeSubType('Encroachment', 'अतिक्रमण'),
    CrimeSubType('Land Grabbing', 'जमीन बळकावणे'),
    CrimeSubType('Defacement of Property', 'मालमत्ता विद्रुपीकरण'),
    CrimeSubType('Other Property Crime', 'इतर मालमत्ता गुन्हा'),
  ]),
  CrimeCategory('Public Order / Riot', 'सार्वजनिक सुव्यवस्था / दंगल', [
    CrimeSubType('Riot', 'दंगल'),
    CrimeSubType('Unlawful Assembly', 'बेकायदा जमाव'),
    CrimeSubType('Communal Clash', 'जातीय/धार्मिक संघर्ष'),
    CrimeSubType('Affray', 'सार्वजनिक मारामारी'),
    CrimeSubType('Obstruction of Public Servant', 'शासकीय सेवकाला अडथळा'),
    CrimeSubType('Breach of Peace', 'शांतता भंग'),
    CrimeSubType('Promoting Enmity between Groups', 'गटांत वैमनस्य पसरवणे'),
    CrimeSubType('Other Public Order Offence', 'इतर सार्वजनिक सुव्यवस्था गुन्हा'),
  ]),
  CrimeCategory('Organized Crime', 'संघटित गुन्हा', [
    CrimeSubType('Extortion Racket', 'खंडणी रॅकेट'),
    CrimeSubType('Gang Activity', 'टोळी कारवाया'),
    CrimeSubType('Illegal Arms Trade', 'बेकायदा शस्त्र व्यापार'),
    CrimeSubType('Drug Trafficking', 'अंमली पदार्थ तस्करी'),
    CrimeSubType('Human Trafficking Racket', 'मानवी तस्करी रॅकेट'),
    CrimeSubType('Counterfeit Currency Racket', 'बनावट चलन रॅकेट'),
    CrimeSubType('Money Laundering', 'मनी लाँडरिंग'),
    CrimeSubType('Terror Funding', 'दहशतवाद निधी'),
    CrimeSubType('Contract Killing Racket', 'सुपारी हत्या रॅकेट'),
    CrimeSubType('Other Organized Crime', 'इतर संघटित गुन्हा'),
  ]),
  CrimeCategory('Economic Offences', 'आर्थिक गुन्हे', [
    CrimeSubType('Bank Fraud', 'बँक फसवणूक'),
    CrimeSubType('Ponzi/MLM Scheme', 'पोन्झी/एमएलएम योजना'),
    CrimeSubType('Chit Fund Scam', 'चिटफंड घोटाळा'),
    CrimeSubType('Investment Scam', 'गुंतवणूक घोटाळा'),
    CrimeSubType('Cooperative Society Fraud', 'सहकारी संस्था फसवणूक'),
    CrimeSubType('Loan Default Fraud', 'कर्ज बुडवणूक फसवणूक'),
    CrimeSubType('Tax Evasion', 'कर चुकवेगिरी'),
    CrimeSubType('Hawala Transaction', 'हवाला व्यवहार'),
    CrimeSubType('Counterfeiting', 'बनावटगिरी'),
    CrimeSubType('Other Economic Offence', 'इतर आर्थिक गुन्हा'),
  ]),
  CrimeCategory('Narcotics (NDPS)', 'अंमली पदार्थ (एनडीपीएस)', [
    CrimeSubType('Drug Possession', 'अंमली पदार्थ बाळगणे'),
    CrimeSubType('Drug Peddling/Sale', 'अंमली पदार्थ विक्री'),
    CrimeSubType('Drug Trafficking', 'अंमली पदार्थ तस्करी'),
    CrimeSubType('Drug Manufacturing', 'अंमली पदार्थ निर्मिती'),
    CrimeSubType('Ganja/Cannabis', 'गांजा'),
    CrimeSubType('MD/Mephedrone', 'एमडी/मेफेड्रोन'),
    CrimeSubType('Brown Sugar/Heroin', 'ब्राऊन शुगर/हेरॉईन'),
    CrimeSubType('Cultivation of Narcotics', 'अंमली पिकांची लागवड'),
    CrimeSubType('Other NDPS Offence', 'इतर एनडीपीएस गुन्हा'),
  ]),
  CrimeCategory('Excise / Prohibition', 'दारूबंदी / उत्पादन शुल्क', [
    CrimeSubType('Illicit Liquor', 'अवैध दारू'),
    CrimeSubType('Country Liquor', 'गावठी दारू'),
    CrimeSubType('Hooch/Spurious Liquor', 'विषारी/बनावट दारू'),
    CrimeSubType('Liquor Smuggling', 'दारू तस्करी'),
    CrimeSubType('Illegal Sale of Liquor', 'अवैध दारू विक्री'),
    CrimeSubType('Drunk in Public', 'सार्वजनिक ठिकाणी मद्यपान'),
    CrimeSubType('Other Excise Offence', 'इतर उत्पादन शुल्क गुन्हा'),
  ]),
  CrimeCategory('Gambling', 'जुगार', [
    CrimeSubType('Matka/Satta', 'मटका/सट्टा'),
    CrimeSubType('Card Gambling', 'पत्ते जुगार'),
    CrimeSubType('Online Betting', 'ऑनलाईन सट्टेबाजी'),
    CrimeSubType('Cricket Betting', 'क्रिकेट सट्टा'),
    CrimeSubType('Casino/Gaming House', 'जुगार अड्डा'),
    CrimeSubType('Other Gambling', 'इतर जुगार'),
  ]),
  CrimeCategory('Arms & Explosives', 'शस्त्र व स्फोटके', [
    CrimeSubType('Illegal Firearm Possession', 'अवैध शस्त्र बाळगणे'),
    CrimeSubType('Country-made Pistol', 'गावठी कट्टा'),
    CrimeSubType('Arms Smuggling', 'शस्त्र तस्करी'),
    CrimeSubType('Possession of Explosives', 'स्फोटके बाळगणे'),
    CrimeSubType('Bomb/IED', 'बॉम्ब/आयईडी'),
    CrimeSubType('Illegal Sword/Knife', 'अवैध तलवार/सुरा'),
    CrimeSubType('Other Arms Offence', 'इतर शस्त्र गुन्हा'),
  ]),
  CrimeCategory('Traffic / Motor Vehicle', 'वाहतूक / मोटार वाहन', [
    CrimeSubType('Hit and Run', 'धडक देऊन पळून जाणे'),
    CrimeSubType('Rash & Negligent Driving', 'बेदरकार वाहन चालवणे'),
    CrimeSubType('Drunken Driving', 'मद्यपान करून वाहन चालवणे'),
    CrimeSubType('Driving without License', 'विनापरवाना वाहन चालवणे'),
    CrimeSubType('Overspeeding', 'अतिवेग'),
    CrimeSubType('Fatal Road Accident', 'प्राणांतिक अपघात'),
    CrimeSubType('Non-fatal Road Accident', 'किरकोळ अपघात'),
    CrimeSubType('Vehicle without Documents', 'विनाकागदपत्र वाहन'),
    CrimeSubType('Other Traffic Offence', 'इतर वाहतूक गुन्हा'),
  ]),
  CrimeCategory('Missing Person', 'बेपत्ता व्यक्ती', [
    CrimeSubType('Missing Man', 'बेपत्ता पुरुष'),
    CrimeSubType('Missing Woman', 'बेपत्ता महिला'),
    CrimeSubType('Missing Child', 'बेपत्ता बालक'),
    CrimeSubType('Missing Senior Citizen', 'बेपत्ता ज्येष्ठ नागरिक'),
    CrimeSubType('Missing Mentally Unstable Person', 'बेपत्ता मनोरुग्ण व्यक्ती'),
    CrimeSubType('Other Missing Person', 'इतर बेपत्ता व्यक्ती'),
  ]),
  CrimeCategory('Accidental / Unnatural Death', 'अपघाती / अनैसर्गिक मृत्यू', [
    CrimeSubType('Suicide', 'आत्महत्या'),
    CrimeSubType('Abetment of Suicide', 'आत्महत्येस प्रवृत्त करणे'),
    CrimeSubType('Accidental Death', 'अपघाती मृत्यू'),
    CrimeSubType('Drowning', 'बुडून मृत्यू'),
    CrimeSubType('Burns/Fire Death', 'भाजून/आगीत मृत्यू'),
    CrimeSubType('Electrocution', 'विजेच्या धक्क्याने मृत्यू'),
    CrimeSubType('Snake Bite', 'सर्पदंश मृत्यू'),
    CrimeSubType('Fall from Height', 'उंचावरून पडून मृत्यू'),
    CrimeSubType('Unidentified Dead Body', 'बेवारस मृतदेह'),
    CrimeSubType('Other Unnatural Death', 'इतर अनैसर्गिक मृत्यू'),
  ]),
  CrimeCategory('Environment / Wildlife / Forest', 'पर्यावरण / वन्यजीव / वन', [
    CrimeSubType('Illegal Tree Felling', 'अवैध वृक्षतोड'),
    CrimeSubType('Wildlife Hunting/Poaching', 'वन्यजीव शिकार'),
    CrimeSubType('Wildlife Smuggling', 'वन्यजीव तस्करी'),
    CrimeSubType('Forest Encroachment', 'वन अतिक्रमण'),
    CrimeSubType('Illegal Sand Mining', 'अवैध वाळू उपसा'),
    CrimeSubType('Pollution Offence', 'प्रदूषण गुन्हा'),
    CrimeSubType('Illegal Quarrying', 'अवैध उत्खनन'),
    CrimeSubType('Other Environmental Offence', 'इतर पर्यावरण गुन्हा'),
  ]),
  CrimeCategory('Corruption', 'भ्रष्टाचार', [
    CrimeSubType('Bribery', 'लाचखोरी'),
    CrimeSubType('Disproportionate Assets', 'बेहिशेबी मालमत्ता'),
    CrimeSubType('Criminal Misconduct', 'गुन्हेगारी गैरवर्तन'),
    CrimeSubType('Abuse of Official Position', 'पदाचा गैरवापर'),
    CrimeSubType('Other Corruption', 'इतर भ्रष्टाचार'),
  ]),
  CrimeCategory('Atrocities (SC/ST)', 'अत्याचार (अनुसूचित जाती/जमाती)', [
    CrimeSubType('Caste-based Insult', 'जातीय अपमान'),
    CrimeSubType('Caste-based Assault', 'जातीय हल्ला'),
    CrimeSubType('Social Boycott', 'सामाजिक बहिष्कार'),
    CrimeSubType('Denial of Rights', 'हक्क नाकारणे'),
    CrimeSubType('Other Atrocity', 'इतर अत्याचार'),
  ]),
  CrimeCategory('Defamation & Intimidation', 'बदनामी व धमकी', [
    CrimeSubType('Defamation', 'बदनामी'),
    CrimeSubType('Criminal Intimidation', 'गुन्हेगारी धमकी'),
    CrimeSubType('Threat to Life', 'जीवे मारण्याची धमकी'),
    CrimeSubType('Blackmail', 'ब्लॅकमेल'),
    CrimeSubType('Insult/Provocation', 'अपमान/चिथावणी'),
    CrimeSubType('Other Intimidation', 'इतर धमकी'),
  ]),
  CrimeCategory('Miscellaneous', 'इतर', [
    CrimeSubType('Negligent Act', 'निष्काळजी कृत्य'),
    CrimeSubType('Public Nuisance', 'सार्वजनिक उपद्रव'),
    CrimeSubType('Food Adulteration', 'अन्न भेसळ'),
    CrimeSubType('Black Marketing/Hoarding', 'काळाबाजार/साठेबाजी'),
    CrimeSubType('Animal Cruelty', 'प्राण्यांवर अत्याचार'),
    CrimeSubType('Beggary', 'भीक मागणे'),
    CrimeSubType('Superstition/Black Magic', 'अंधश्रद्धा/जादूटोणा'),
    CrimeSubType('Election Offence', 'निवडणूक गुन्हा'),
    CrimeSubType('Other', 'इतर'),
  ]),
];

/// Flat list of every sub-type label (e.g. "ATM Robbery / एटीएम जबरी चोरी"),
/// kept for backward-compatible autocomplete / free-text fallbacks.
List<String> get kCrimeTypeLabels => [
      for (final c in kCrimeCategories)
        for (final s in c.subtypes) s.label,
    ];

/// Every top-level category label (e.g. "Murder / खून").
List<String> get kCrimeCategoryLabels =>
    [for (final c in kCrimeCategories) c.label];

/// sub-type label -> its category label, built once.
final Map<String, String> _categoryBySubtype = {
  for (final c in kCrimeCategories)
    for (final s in c.subtypes) s.label: c.label,
};
final Set<String> _categoryLabelSet = {
  for (final c in kCrimeCategories) c.label,
};

/// True when [label] is a top-level category (not a specific sub-type).
bool isCrimeCategoryLabel(String label) => _categoryLabelSet.contains(label);

/// The category a stored `crimeType` value belongs to (itself if it is already
/// a category; the parent category if it is a sub-type; null for custom text).
String? crimeCategoryOf(String? crimeType) {
  if (crimeType == null || crimeType.isEmpty) return null;
  if (_categoryLabelSet.contains(crimeType)) return crimeType;
  return _categoryBySubtype[crimeType];
}

/// The Marathi-only label for a catalogue value (for compact report rows), e.g.
/// "Murder / खून" -> "खून". Returns the value unchanged for custom text.
String crimeTypeMarathi(String label) {
  for (final c in kCrimeCategories) {
    if (c.label == label) return c.mr;
    for (final s in c.subtypes) {
      if (s.label == label) return s.mr;
    }
  }
  return label;
}
