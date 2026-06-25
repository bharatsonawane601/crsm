import 'dart:convert';

/// Editable in-memory model for the template builder. Serializes to / from the
/// same JSON shape the report engine consumes (`name`, `header`, `page_size`,
/// `rows[{sr,label,value,fallback}]`). `sr` is assigned by row position on save.
class TemplateRowDraft {
  TemplateRowDraft({this.label = '', this.value = '', this.fallback = ''});

  String label;
  String value;
  String fallback;
}

class TemplateDraft {
  TemplateDraft({
    this.id,
    this.name = '',
    this.header = '',
    this.pageSize = 'A4',
    this.outputFormat = 'docx',
    List<TemplateRowDraft>? rows,
  }) : rows = rows ?? [TemplateRowDraft()];

  int? id;
  String name;
  String header;
  String pageSize;
  String outputFormat;
  List<TemplateRowDraft> rows;

  bool get isNew => id == null;

  Map<String, dynamic> toJson() => {
        'name': name,
        'type': 'table',
        'header': header.trim().isEmpty ? name : header,
        'page_size': pageSize,
        'rows': [
          for (var i = 0; i < rows.length; i++)
            {
              'sr': i + 1,
              'label': rows[i].label,
              'value': rows[i].value,
              if (rows[i].fallback.trim().isNotEmpty)
                'fallback': rows[i].fallback,
            },
        ],
      };

  String toJsonString() => jsonEncode(toJson());

  /// A ready-to-edit starter laid out like a ब पत्रक: each line is its own
  /// labelled row (so the generated report is a proper multi-row table, not a
  /// single box). The user edits/adds/removes rows from here.
  factory TemplateDraft.starter() => TemplateDraft(
        name: '',
        header: 'अहवाल',
        rows: [
          TemplateRowDraft(
              label: 'पोलीस ठाणे',
              value: '{station.name_marathi} {station.district}'),
          TemplateRowDraft(
              label: 'गु.र.नं. व कलम',
              value: '{crime.fir_no}/{crime.year} कलम {crime.section}'),
          TemplateRowDraft(
              label: 'फिर्यादी',
              value: '{complainant.name} वय-{complainant.age}',
              fallback: '—'),
          TemplateRowDraft(
              label: 'गुन्ह्याचा प्रकार', value: '{crime.crime_type}'),
          TemplateRowDraft(
              label: 'आरोपी',
              value: '{#accused}{name}{/accused}',
              fallback: 'अनोळखी'),
          TemplateRowDraft(
              label: 'सविस्तर खुलासा', value: '{crime.detailed_description}'),
        ],
      );

  /// Build a draft from a stored template JSON string. [id] sets the DB id (or
  /// null when duplicating into a new template).
  factory TemplateDraft.fromJsonString(String source, {int? id}) {
    final map = jsonDecode(source) as Map<String, dynamic>;
    final rawRows = (map['rows'] as List<dynamic>? ?? const []);
    return TemplateDraft(
      id: id,
      name: map['name'] as String? ?? '',
      header: map['header'] as String? ?? '',
      pageSize: map['page_size'] as String? ?? 'A4',
      rows: rawRows.isEmpty
          ? [TemplateRowDraft()]
          : [
              for (final r in rawRows)
                TemplateRowDraft(
                  label: (r as Map<String, dynamic>)['label'] as String? ?? '',
                  value: r['value'] as String? ?? '',
                  fallback: r['fallback'] as String? ?? '',
                ),
            ],
    );
  }
}
