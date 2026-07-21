import 'package:intl/intl.dart';

import '../crime_entry/data/bns_data.dart';
import '../crime_entry/models/crime_draft.dart';
import 'models/report_template.dart';

final _dateFmt = DateFormat('dd-MM-yyyy');

/// Builds the data context (snake_case keys matching template placeholders)
/// from a loaded, decrypted [CrimeDraft]. Optional [station] fills the
/// `{station.*}` placeholders; when absent those resolve to empty (station
/// management arrives in a later phase).
class ReportContext {
  static Map<String, dynamic> fromDraft(
    CrimeDraft d, {
    Map<String, String>? station,
  }) {
    return {
      'crime': {
        'fir_no': d.firNo,
        'year': d.year?.toString() ?? '',
        'section': d.section ?? '',
        'sub_section': d.subSection ?? '',
        'district': d.district ?? '',
        'police_station': d.policeStation ?? '',
        'crime_type': d.crimeType ?? '',
        'status': d.status,
        // Marathi status word for the 'ब' पत्रक (उघड / अनउघड).
        'status_label': _statusLabel(d.status),
        'date_occurred': _d(d.dateOccurred),
        'date_occurred_to': _d(d.dateOccurredTo),
        // "01-01-2026 ते 03-01-2026" when both ends are set, else the single
        // date — used by the 'ब' पत्रक "गुन्हा घडला" row.
        'date_occurred_range': _dateRange(d.dateOccurred, d.dateOccurredTo),
        'time_occurred': d.timeOccurred ?? '',
        'time_occurred_to': d.timeOccurredTo ?? '',
        // "1 PM ते 2 PM" when both ends are set, else whichever single time
        // was filled — used by the 'ब' पत्रक "गुन्हा घडला" row.
        'time_occurred_range': _timeRange(d.timeOccurred, d.timeOccurredTo),
        'place_occurred': d.placeOccurred ?? '',
        'date_registered': _d(d.dateRegistered),
        'time_registered': d.timeRegistered ?? '',
        'detailed_description': d.detailedDescription ?? '',
        'case_stage': d.caseStage,
        'court_type': d.courtType ?? '',
        // NCRB IIF-1 FIR fields.
        'fir_date': _d(d.firDate),
        'fir_time': d.firTime ?? '',
        'info_received_date': _d(d.infoReceivedDate),
        'info_received_time': d.infoReceivedTime ?? '',
        'gd_date': _d(d.gdDate),
        'gd_time': d.gdTime ?? '',
        'gd_entry_no': d.gdEntryNo ?? '',
        'occurrence_day': d.occurrenceDay ?? '',
        'type_of_information': d.typeOfInformation ?? '',
        'beat_no': d.beatNo ?? '',
        'direction_distance': d.directionDistance ?? '',
        'outside_ps_name': d.outsidePsName ?? '',
        'outside_ps_district': d.outsidePsDistrict ?? '',
        'delay_reason': d.delayReason ?? '',
        'inquest_ud_no': d.inquestUdNo ?? '',
      },
      'station': {
        // Pick whichever station name was filled (Marathi or English), falling
        // back to the per-crime police station, so the name always prints.
        // The 'ब' पत्रक title must read in Marathi. Whatever name was filled
        // (or the per-crime station, which is stored in English like "City
        // Chowk"), fold it to its Marathi spelling so the header never prints
        // English. Unknown names pass through unchanged.
        'name_marathi': _toMarathi(_pick([
          station?['name_marathi'],
          station?['name_english'],
          d.policeStation,
        ])),
        'name_english': _pick([
          station?['name_english'],
          station?['name_marathi'],
          d.policeStation,
        ]),
        'district': _pick([station?['district'], d.district]),
        'code': station?['code'] ?? '',
        'address': station?['address'] ?? '',
      },
      'complainant': _person(d.complainant),
      'investigation': {
        'officer_name': d.investigation.officerName ?? '',
        'officer_id': d.investigation.officerId ?? '',
        'officer_designation': d.investigation.officerDesignation ?? '',
        'officer_mobile': d.investigation.officerMobile ?? '',
        // Combined one-line officer detail for the 'ब' पत्रक तपास अधिकारी row:
        // name (designation), आय.डी. id, मो. mobile — skipping any blank part.
        'officer_full': _officerFull(d.investigation),
        'filed_by': d.investigation.filedBy ?? '',
        'preventive_action': d.investigation.preventiveAction ?? '',
        'preventive_no': d.investigation.preventiveNo ?? '',
        'preventive_date': _d(d.investigation.preventiveDate),
        'wanted_accused': d.investigation.wantedAccused ?? '',
        // NCRB registration / dispatch fields.
        'registering_officer_name': d.investigation.registeringOfficerName ?? '',
        'registering_officer_rank': d.investigation.registeringOfficerRank ?? '',
        'registering_officer_no': d.investigation.registeringOfficerNo ?? '',
        'action_taken': d.investigation.actionTaken ?? '',
        'court_dispatch_date': _d(d.investigation.courtDispatchDate),
        'court_dispatch_time': d.investigation.courtDispatchTime ?? '',
      },
      'verdict': {
        'chargesheet_no': d.verdict.chargesheetNo ?? '',
        'chargesheet_date': _d(d.verdict.chargesheetDate),
        'rcc_no': d.verdict.rccNo ?? '',
        'final_order': d.verdict.finalOrder ?? '',
        'punishment': d.verdict.punishment ?? '',
        // "होय"/"नाही" when recorded, '' when not — Marathi because the
        // official पत्रक output is Marathi.
        'found_guilty': d.verdict.foundGuilty == null
            ? ''
            : (d.verdict.foundGuilty! ? 'होय' : 'नाही'),
      },
      'accused': [
        for (final a in d.accused)
          {
            ..._person(a),
            'arrest_status': a.arrestStatus ?? '',
            'arrest_date': _d(a.arrestDate),
            'arrest_time': a.arrestTime ?? '',
            'alias': a.alias ?? '',
            'relative_name': a.relativeName ?? '',
            // One-line physical description ("बांधा: मजबूत, उंची: १७५ सेमी").
            'physical': a.physical == null
                ? ''
                : a.physical!.entries
                    .where((e) => e.value.trim().isNotEmpty)
                    .map((e) => '${e.key}: ${e.value.trim()}')
                    .join(', '),
          },
      ],
      'stolen_property': [
        for (final s in d.stolen)
          {
            'type': s.type ?? '',
            'description': s.description ?? '',
            'value': s.value?.toString() ?? '',
            // One-line summary used by the 'ब' पत्रक so the entry shows up even
            // when only the type or value (not the description) was filled.
            'summary': _propSummary(s.type, s.description, s.value),
          },
      ],
      // Total rupee value of all stolen property (formatted, e.g. "45,000"),
      // and a "(एकूण किंमत ...)" tail printed after the stolen-items list.
      'stolen_total': _money(_sumValues(d.stolen.map((s) => s.value))),
      'stolen_total_label': _totalLabel(d.stolen.map((s) => s.value)),
      'recovered_property': [
        for (final r in d.recovered)
          {
            'description': r.description ?? '',
            'value': r.value?.toString() ?? '',
            'recovery_date': _d(r.recoveryDate),
            'summary': _propSummary(null, r.description, r.value),
          },
      ],
      // Admin-defined custom fields, addressable as {custom.<fieldId>}.
      'custom': {
        for (final e in d.customValues.entries)
          e.key.toString(): e.value ?? '',
      },
    };
  }

  static Map<String, dynamic> _person(PersonDraft p) => {
        'name': p.name,
        'gender': p.gender ?? '',
        'age': (p.ageText != null && p.ageText!.trim().isNotEmpty)
            ? p.ageText!.trim()
            : (p.age?.toString() ?? ''),
        'address': p.address ?? '',
        'mobile': p.mobile ?? '',
        'email': p.email ?? '',
        'aadhaar': p.aadhaar ?? '',
        'pan': p.pan ?? '',
        'passport': p.passport ?? '',
        // NCRB person fields.
        'father_husband_name': p.fatherHusbandName ?? '',
        'birth_year': p.birthYear?.toString() ?? '',
        'nationality': p.nationality ?? '',
        'occupation': p.occupation ?? '',
        'permanent_address': p.permanentAddress ?? '',
        'id_type': p.idType ?? '',
        'id_number': p.idNumber ?? '',
      };

  static String _d(DateTime? dt) => dt == null ? '' : _dateFmt.format(dt);

  /// Marathi word for a crime status (handles legacy values too).
  static String _statusLabel(String status) {
    switch (status) {
      case 'detected':
      case 'solved':
      case 'chargesheeted':
        return 'उघड';
      default:
        return 'अनउघड';
    }
  }

  /// Builds a readable one-line property entry from its parts, skipping blanks,
  /// e.g. "मोबाईल - सॅमसंग A52 (किं. 15000/-)". Returns '' when nothing is set.
  static String _propSummary(String? type, String? desc, double? value) {
    final head = [type, desc]
        .where((e) => e != null && e.trim().isNotEmpty)
        .map((e) => e!.trim())
        .join(' - ');
    final amount =
        (value != null && value > 0) ? 'किं. ${_money(value)}/-' : '';
    if (head.isEmpty) return amount;
    return amount.isEmpty ? head : '$head ($amount)';
  }

  /// Formats a money value without a trailing ".0" for whole numbers.
  static String _money(double v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  /// Sum of the non-null property values in [vals].
  static double _sumValues(Iterable<double?> vals) =>
      vals.fold<double>(0, (sum, v) => sum + (v ?? 0));

  /// "(एकूण किंमत 45000/-)" tail for the stolen-items row; '' when nothing
  /// has a value, so an empty row still falls back to "निरंक".
  static String _totalLabel(Iterable<double?> vals) {
    final total = _sumValues(vals);
    if (total <= 0) return '';
    return '(एकूण किंमत ${_money(total)}/-)';
  }

  /// Joins a from/to time window: "1 PM ते 2 PM", or just whichever single
  /// time was filled. '' when neither is set.
  static String _timeRange(String? from, String? to) {
    final f = (from ?? '').trim();
    final t = (to ?? '').trim();
    if (f.isNotEmpty && t.isNotEmpty) return '$f ते $t';
    return f.isNotEmpty ? f : t;
  }

  /// Joins a from/to date window: "01-01-2026 ते 03-01-2026", or the single
  /// date when only one end is set. '' when neither is set.
  static String _dateRange(DateTime? from, DateTime? to) {
    final f = _d(from);
    final t = _d(to);
    if (f.isNotEmpty && t.isNotEmpty && f != t) return '$f ते $t';
    return f.isNotEmpty ? f : t;
  }

  /// One-line investigating-officer detail (name, designation, ID, mobile),
  /// skipping any blank part — used for the 'ब' पत्रक तपास अधिकारी row.
  static String _officerFull(InvestigationDraft inv) {
    final name = (inv.officerName ?? '').trim();
    final desig = (inv.officerDesignation ?? '').trim();
    final id = (inv.officerId ?? '').trim();
    final mobile = (inv.officerMobile ?? '').trim();
    final parts = <String>[];
    if (name.isNotEmpty) {
      parts.add(desig.isNotEmpty ? '$name ($desig)' : name);
    } else if (desig.isNotEmpty) {
      parts.add(desig);
    }
    if (id.isNotEmpty) parts.add('आय.डी. $id');
    if (mobile.isNotEmpty) parts.add('मो. $mobile');
    return parts.join(' ');
  }

  /// First non-empty value from [vals], trimmed; '' if none.
  static String _pick(List<String?> vals) {
    for (final v in vals) {
      if (v != null && v.trim().isNotEmpty) return v.trim();
    }
    return '';
  }

  /// The Marathi spelling of a station name. Canonicalises any spelling to its
  /// English key, then looks up the Marathi name; an unknown name (or one
  /// already in Marathi) is returned unchanged, so nothing is ever blanked.
  static String _toMarathi(String name) {
    if (name.isEmpty) return name;
    final canon = canonicalStationName(name);
    if (canon == null) return name;
    return kPoliceStationsMr[canon] ?? name;
  }
}

/// Renders template strings against a data context. Supports:
///   - simple/combined placeholders: `{crime.fir_no}`, literal text mixed in
///   - loops: `{#accused}{name}{/accused}` (joins items with ", ")
///   - fallback: a row's `fallback` is used when its rendered value is empty
class TemplateEngine {
  const TemplateEngine();

  static final _loopRe = RegExp(r'\{#(\w+)\}(.*?)\{/\1\}', dotAll: true);
  static final _placeholderRe = RegExp(r'\{([\w.]+)\}');

  /// Render a single value template.
  String renderValue(String template, Map<String, dynamic> context) {
    final withLoops = _renderLoops(template, context);
    return _renderPlaceholders(withLoops, context).trim();
  }

  /// Render a whole template into a [RenderedReport].
  RenderedReport render(ReportTemplate template, Map<String, dynamic> context) {
    final rows = <RenderedRow>[];
    for (final row in template.rows) {
      var value = renderValue(row.value, context);
      if (value.isEmpty && row.fallback != null) {
        value = row.fallback!;
      }
      rows.add(RenderedRow(sr: row.sr, label: row.label, value: value));
    }
    return RenderedReport(
      name: template.name,
      // Header also supports placeholders (e.g. {station.name_marathi}) and
      // multiple lines separated by \n.
      header: renderValue(template.header, context),
      pageSize: template.pageSize,
      rows: rows,
    );
  }

  String _renderLoops(String template, Map<String, dynamic> context) {
    return template.replaceAllMapped(_loopRe, (m) {
      final key = m.group(1)!;
      final inner = m.group(2)!;
      final list = context[key];
      if (list is! List || list.isEmpty) return '';
      final parts = <String>[];
      var n = 0;
      for (final item in list) {
        n++;
        final itemContext =
            item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{};
        // 1-based position within the loop, so a template can number its items
        // (the 'ब' पत्रक prints "{sn}) {name}" to count the accused).
        itemContext['sn'] = '$n';
        final rendered = _renderPlaceholders(inner, itemContext).trim();
        if (rendered.isNotEmpty) parts.add(rendered);
      }
      return parts.join(', ');
    });
  }

  String _renderPlaceholders(String template, Map<String, dynamic> data) {
    return template.replaceAllMapped(
      _placeholderRe,
      (m) => _resolve(m.group(1)!, data),
    );
  }

  String _resolve(String path, Map<String, dynamic> data) {
    dynamic current = data;
    for (final part in path.split('.')) {
      if (current is Map && current.containsKey(part)) {
        current = current[part];
      } else {
        return '';
      }
    }
    return current?.toString() ?? '';
  }
}
