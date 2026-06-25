import 'package:intl/intl.dart';

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
        'date_occurred': _d(d.dateOccurred),
        'time_occurred': d.timeOccurred ?? '',
        'place_occurred': d.placeOccurred ?? '',
        'date_registered': _d(d.dateRegistered),
        'time_registered': d.timeRegistered ?? '',
        'detailed_description': d.detailedDescription ?? '',
      },
      'station': {
        // Pick whichever station name was filled (Marathi or English), falling
        // back to the per-crime police station, so the name always prints.
        'name_marathi': _pick([
          station?['name_marathi'],
          station?['name_english'],
          d.policeStation,
        ]),
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
        'officer_mobile': d.investigation.officerMobile ?? '',
        'filed_by': d.investigation.filedBy ?? '',
        'preventive_action': d.investigation.preventiveAction ?? '',
        'preventive_no': d.investigation.preventiveNo ?? '',
        'preventive_date': _d(d.investigation.preventiveDate),
        'wanted_accused': d.investigation.wantedAccused ?? '',
      },
      'verdict': {
        'chargesheet_no': d.verdict.chargesheetNo ?? '',
        'chargesheet_date': _d(d.verdict.chargesheetDate),
        'rcc_no': d.verdict.rccNo ?? '',
        'final_order': d.verdict.finalOrder ?? '',
        'punishment': d.verdict.punishment ?? '',
      },
      'accused': [
        for (final a in d.accused)
          {
            ..._person(a),
            'arrest_status': a.arrestStatus ?? '',
            'arrest_date': _d(a.arrestDate),
          },
      ],
      'stolen_property': [
        for (final s in d.stolen)
          {
            'type': s.type ?? '',
            'description': s.description ?? '',
            'value': s.value?.toString() ?? '',
          },
      ],
      'recovered_property': [
        for (final r in d.recovered)
          {
            'description': r.description ?? '',
            'value': r.value?.toString() ?? '',
            'recovery_date': _d(r.recoveryDate),
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
        'age': p.age?.toString() ?? '',
        'address': p.address ?? '',
        'mobile': p.mobile ?? '',
        'email': p.email ?? '',
        'aadhaar': p.aadhaar ?? '',
        'pan': p.pan ?? '',
        'passport': p.passport ?? '',
      };

  static String _d(DateTime? dt) => dt == null ? '' : _dateFmt.format(dt);

  /// First non-empty value from [vals], trimmed; '' if none.
  static String _pick(List<String?> vals) {
    for (final v in vals) {
      if (v != null && v.trim().isNotEmpty) return v.trim();
    }
    return '';
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
      for (final item in list) {
        final itemContext =
            item is Map ? Map<String, dynamic>.from(item) : <String, dynamic>{};
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
