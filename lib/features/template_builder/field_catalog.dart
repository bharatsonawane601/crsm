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
    ],
  ),
  FieldGroup(
    titleMr: 'पोलीस ठाणे',
    titleEn: 'Station',
    options: [
      FieldOption(labelMr: 'ठाणे (मराठी)', labelEn: 'Name (Marathi)', insert: '{station.name_marathi}'),
      FieldOption(labelMr: 'जिल्हा', labelEn: 'District', insert: '{station.district}'),
      FieldOption(labelMr: 'कोड', labelEn: 'Code', insert: '{station.code}'),
    ],
  ),
  FieldGroup(
    titleMr: 'फिर्यादी',
    titleEn: 'Complainant',
    options: [
      FieldOption(labelMr: 'नाव', labelEn: 'Name', insert: '{complainant.name}'),
      FieldOption(labelMr: 'वय', labelEn: 'Age', insert: '{complainant.age}'),
      FieldOption(labelMr: 'पत्ता', labelEn: 'Address', insert: '{complainant.address}'),
      FieldOption(labelMr: 'मोबाइल', labelEn: 'Mobile', insert: '{complainant.mobile}'),
    ],
  ),
  FieldGroup(
    titleMr: 'आरोपी (यादी)',
    titleEn: 'Accused (loop)',
    options: [
      FieldOption(labelMr: 'सर्व नावे', labelEn: 'All names', insert: '{#accused}{name}{/accused}'),
      FieldOption(labelMr: 'नाव व वय', labelEn: 'Name & age', insert: '{#accused}{name} वय-{age}{/accused}'),
    ],
  ),
  FieldGroup(
    titleMr: 'मालमत्ता (यादी)',
    titleEn: 'Property (loop)',
    options: [
      FieldOption(labelMr: 'गेला माल', labelEn: 'Stolen items', insert: '{#stolen_property}{description}{/stolen_property}'),
      FieldOption(labelMr: 'हस्तगत माल', labelEn: 'Recovered items', insert: '{#recovered_property}{description}{/recovered_property}'),
    ],
  ),
  FieldGroup(
    titleMr: 'तपास व निकाल',
    titleEn: 'Investigation & verdict',
    options: [
      FieldOption(labelMr: 'तपास अधिकारी', labelEn: 'Officer', insert: '{investigation.officer_name}'),
      FieldOption(labelMr: 'दोषारोपपत्र क्र.', labelEn: 'Chargesheet no', insert: '{verdict.chargesheet_no}'),
      FieldOption(labelMr: 'शिक्षा', labelEn: 'Punishment', insert: '{verdict.punishment}'),
    ],
  ),
];
