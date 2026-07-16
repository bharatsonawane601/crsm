import 'package:flutter/widgets.dart';

/// One insertable placeholder option shown in the builder's field picker.
class FieldOption {
  const FieldOption({
    required this.labelMr,
    required this.labelEn,
    required this.insert,
  });

  final String labelMr;
  final String labelEn;

  /// Text inserted into the row's value, e.g. "{crime.fir_no}" or a loop block.
  final String insert;

  String label(Locale locale) => locale.languageCode == 'mr' ? labelMr : labelEn;
}

class FieldGroup {
  const FieldGroup({
    required this.titleMr,
    required this.titleEn,
    required this.options,
  });

  final String titleMr;
  final String titleEn;
  final List<FieldOption> options;

  String title(Locale locale) => locale.languageCode == 'mr' ? titleMr : titleEn;
}

/// Catalog of every placeholder the engine understands, grouped by section.
/// Loop fields insert a single-field loop block (the common case); users can
/// hand-edit the value text for combined/multi-field loops.
const List<FieldGroup> kFieldCatalog = [
  FieldGroup(
    titleMr: 'गुन्हा',
    titleEn: 'Crime',
    options: [
      FieldOption(labelMr: 'गु.र.नं.', labelEn: 'FIR no', insert: '{crime.fir_no}'),
      FieldOption(labelMr: 'वर्ष', labelEn: 'Year', insert: '{crime.year}'),
      FieldOption(labelMr: 'कलम', labelEn: 'Section', insert: '{crime.section}'),
      FieldOption(labelMr: 'उपकलम', labelEn: 'Sub-section', insert: '{crime.sub_section}'),
      FieldOption(labelMr: 'जिल्हा', labelEn: 'District', insert: '{crime.district}'),
      FieldOption(labelMr: 'प्रकार', labelEn: 'Crime type', insert: '{crime.crime_type}'),
      FieldOption(labelMr: 'स्थिती', labelEn: 'Status', insert: '{crime.status}'),
      FieldOption(labelMr: 'घडल्याची तारीख', labelEn: 'Date occurred', insert: '{crime.date_occurred}'),
      FieldOption(labelMr: 'घडल्याची वेळ', labelEn: 'Time occurred', insert: '{crime.time_occurred}'),
      FieldOption(labelMr: 'ठिकाण', labelEn: 'Place', insert: '{crime.place_occurred}'),
      FieldOption(labelMr: 'नोंदणी तारीख', labelEn: 'Date registered', insert: '{crime.date_registered}'),
      FieldOption(labelMr: 'नोंदणी वेळ', labelEn: 'Time registered', insert: '{crime.time_registered}'),
      FieldOption(labelMr: 'सविस्तर खुलासा', labelEn: 'Description', insert: '{crime.detailed_description}'),
      FieldOption(labelMr: 'केस टप्पा', labelEn: 'Case stage', insert: '{crime.case_stage}'),
    ],
  ),
  FieldGroup(
    titleMr: 'एफ.आय.आर. (NCRB)',
    titleEn: 'FIR details (NCRB)',
    options: [
      FieldOption(labelMr: 'एफ.आय.आर. तारीख', labelEn: 'FIR date', insert: '{crime.fir_date}'),
      FieldOption(labelMr: 'एफ.आय.आर. वेळ', labelEn: 'FIR time', insert: '{crime.fir_time}'),
      FieldOption(labelMr: 'माहिती मिळाल्याची तारीख', labelEn: 'Info received date', insert: '{crime.info_received_date}'),
      FieldOption(labelMr: 'माहिती मिळाल्याची वेळ', labelEn: 'Info received time', insert: '{crime.info_received_time}'),
      FieldOption(labelMr: 'स्टे.डा. तारीख', labelEn: 'GD date', insert: '{crime.gd_date}'),
      FieldOption(labelMr: 'स्टे.डा. वेळ', labelEn: 'GD time', insert: '{crime.gd_time}'),
      FieldOption(labelMr: 'स्टे.डा. नोंद क्र.', labelEn: 'GD entry no', insert: '{crime.gd_entry_no}'),
      FieldOption(labelMr: 'घडल्याचा वार', labelEn: 'Occurrence day', insert: '{crime.occurrence_day}'),
      FieldOption(labelMr: 'माहितीचा प्रकार', labelEn: 'Type of information', insert: '{crime.type_of_information}'),
      FieldOption(labelMr: 'बीट क्र.', labelEn: 'Beat no', insert: '{crime.beat_no}'),
      FieldOption(labelMr: 'दिशा व अंतर', labelEn: 'Direction & distance', insert: '{crime.direction_distance}'),
      FieldOption(labelMr: 'बाहेरील ठाणे', labelEn: 'Outside PS name', insert: '{crime.outside_ps_name}'),
      FieldOption(labelMr: 'बाहेरील जिल्हा', labelEn: 'Outside PS district', insert: '{crime.outside_ps_district}'),
      FieldOption(labelMr: 'विलंबाचे कारण', labelEn: 'Delay reason', insert: '{crime.delay_reason}'),
      FieldOption(labelMr: 'इन्क्वेस्ट/यू.डी. क्र.', labelEn: 'Inquest/UD no', insert: '{crime.inquest_ud_no}'),
    ],
  ),
  FieldGroup(
    titleMr: 'पोलीस ठाणे',
    titleEn: 'Station',
    options: [
      FieldOption(labelMr: 'ठाणे (मराठी)', labelEn: 'Name (Marathi)', insert: '{station.name_marathi}'),
      FieldOption(labelMr: 'ठाणे (इंग्रजी)', labelEn: 'Name (English)', insert: '{station.name_english}'),
      FieldOption(labelMr: 'जिल्हा', labelEn: 'District', insert: '{station.district}'),
      FieldOption(labelMr: 'कोड', labelEn: 'Code', insert: '{station.code}'),
      FieldOption(labelMr: 'पत्ता', labelEn: 'Address', insert: '{station.address}'),
    ],
  ),
  FieldGroup(
    titleMr: 'फिर्यादी',
    titleEn: 'Complainant',
    options: [
      FieldOption(labelMr: 'नाव', labelEn: 'Name', insert: '{complainant.name}'),
      FieldOption(labelMr: 'वय', labelEn: 'Age', insert: '{complainant.age}'),
      FieldOption(labelMr: 'लिंग', labelEn: 'Gender', insert: '{complainant.gender}'),
      FieldOption(labelMr: 'पत्ता', labelEn: 'Address', insert: '{complainant.address}'),
      FieldOption(labelMr: 'कायमचा पत्ता', labelEn: 'Permanent address', insert: '{complainant.permanent_address}'),
      FieldOption(labelMr: 'मोबाइल', labelEn: 'Mobile', insert: '{complainant.mobile}'),
      FieldOption(labelMr: 'वडील/पतीचे नाव', labelEn: "Father/husband's name", insert: '{complainant.father_husband_name}'),
      FieldOption(labelMr: 'जन्म वर्ष', labelEn: 'Birth year', insert: '{complainant.birth_year}'),
      FieldOption(labelMr: 'राष्ट्रीयत्व', labelEn: 'Nationality', insert: '{complainant.nationality}'),
      FieldOption(labelMr: 'व्यवसाय', labelEn: 'Occupation', insert: '{complainant.occupation}'),
      FieldOption(labelMr: 'ओळखपत्र प्रकार', labelEn: 'ID type', insert: '{complainant.id_type}'),
      FieldOption(labelMr: 'ओळखपत्र क्र.', labelEn: 'ID number', insert: '{complainant.id_number}'),
    ],
  ),
  FieldGroup(
    titleMr: 'आरोपी (यादी)',
    titleEn: 'Accused (loop)',
    options: [
      FieldOption(labelMr: 'सर्व नावे', labelEn: 'All names', insert: '{#accused}{name}{/accused}'),
      FieldOption(labelMr: 'नाव व वय', labelEn: 'Name & age', insert: '{#accused}{name} वय-{age}{/accused}'),
      FieldOption(labelMr: 'नाव व टोपणनाव', labelEn: 'Name & alias', insert: '{#accused}{name} ऊर्फ {alias}{/accused}'),
      FieldOption(labelMr: 'नाव व पत्ता', labelEn: 'Name & address', insert: '{#accused}{name} रा.{address}{/accused}'),
      FieldOption(labelMr: 'अटक स्थिती', labelEn: 'Arrest status', insert: '{#accused}{name} - {arrest_status}{/accused}'),
      FieldOption(labelMr: 'अटक तारीख/वेळ', labelEn: 'Arrest date & time', insert: '{#accused}{name} दि.{arrest_date} {arrest_time}{/accused}'),
      FieldOption(labelMr: 'वर्णन', labelEn: 'Physical description', insert: '{#accused}{name}: {physical}{/accused}'),
      FieldOption(labelMr: 'नातेवाईकाचे नाव', labelEn: "Relative's name", insert: '{#accused}{relative_name}{/accused}'),
    ],
  ),
  FieldGroup(
    titleMr: 'मालमत्ता (यादी)',
    titleEn: 'Property (loop)',
    options: [
      FieldOption(labelMr: 'गेला माल', labelEn: 'Stolen items', insert: '{#stolen_property}{description}{/stolen_property}'),
      FieldOption(labelMr: 'गेला माल (किंमतीसह)', labelEn: 'Stolen items with value', insert: '{#stolen_property}{summary}{/stolen_property} {stolen_total_label}'),
      FieldOption(labelMr: 'गेल्या मालाची एकूण किंमत', labelEn: 'Stolen total value', insert: '{stolen_total}'),
      FieldOption(labelMr: 'हस्तगत माल', labelEn: 'Recovered items', insert: '{#recovered_property}{description}{/recovered_property}'),
      FieldOption(labelMr: 'हस्तगत माल (तारखेसह)', labelEn: 'Recovered with date', insert: '{#recovered_property}{summary} दि.{recovery_date}{/recovered_property}'),
    ],
  ),
  FieldGroup(
    titleMr: 'तपास',
    titleEn: 'Investigation',
    options: [
      FieldOption(labelMr: 'तपास अधिकारी', labelEn: 'Officer', insert: '{investigation.officer_name}'),
      FieldOption(labelMr: 'अधिकारी (संपूर्ण)', labelEn: 'Officer (full line)', insert: '{investigation.officer_full}'),
      FieldOption(labelMr: 'हुद्दा', labelEn: 'Designation', insert: '{investigation.officer_designation}'),
      FieldOption(labelMr: 'अधिकारी मोबाइल', labelEn: 'Officer mobile', insert: '{investigation.officer_mobile}'),
      FieldOption(labelMr: 'दाखल करणार', labelEn: 'Filed by', insert: '{investigation.filed_by}'),
      FieldOption(labelMr: 'प्रतिबंधक कार्यवाही', labelEn: 'Preventive action', insert: '{investigation.preventive_action}'),
      FieldOption(labelMr: 'पाहिजे आरोपी', labelEn: 'Wanted accused', insert: '{investigation.wanted_accused}'),
      FieldOption(labelMr: 'नोंदणी अधिकारी', labelEn: 'Registering officer', insert: '{investigation.registering_officer_name}'),
      FieldOption(labelMr: 'केलेली कार्यवाही', labelEn: 'Action taken', insert: '{investigation.action_taken}'),
      FieldOption(labelMr: 'कोर्ट रवानगी तारीख', labelEn: 'Court dispatch date', insert: '{investigation.court_dispatch_date}'),
    ],
  ),
  FieldGroup(
    titleMr: 'निकाल',
    titleEn: 'Verdict',
    options: [
      FieldOption(labelMr: 'दोषारोपपत्र क्र.', labelEn: 'Chargesheet no', insert: '{verdict.chargesheet_no}'),
      FieldOption(labelMr: 'दोषारोपपत्र तारीख', labelEn: 'Chargesheet date', insert: '{verdict.chargesheet_date}'),
      FieldOption(labelMr: 'आर.सी.सी. क्र.', labelEn: 'RCC no', insert: '{verdict.rcc_no}'),
      FieldOption(labelMr: 'अंतिम आदेश', labelEn: 'Final order', insert: '{verdict.final_order}'),
      FieldOption(labelMr: 'दोषी', labelEn: 'Found guilty', insert: '{verdict.found_guilty}'),
      FieldOption(labelMr: 'शिक्षा', labelEn: 'Punishment', insert: '{verdict.punishment}'),
    ],
  ),
];
