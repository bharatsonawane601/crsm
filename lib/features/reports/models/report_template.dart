/// Parsed representation of a report template (the JSON format documented in
/// PROJECT.md). Field labels and value placeholders both live in the template
/// — the engine never hard-codes labels (PROJECT.md rule 4).
class ReportTemplate {
  ReportTemplate({
    required this.name,
    required this.type,
    required this.header,
    required this.pageSize,
    required this.rows,
  });

  /// Display name, e.g. "ब पत्रक".
  final String name;

  /// Layout type — currently "table".
  final String type;

  /// Heading printed at the top of the document.
  final String header;

  /// "A4" / "Letter".
  final String pageSize;

  final List<TemplateRow> rows;

  factory ReportTemplate.fromJson(Map<String, dynamic> json) {
    final rawRows = (json['rows'] as List<dynamic>? ?? const []);
    return ReportTemplate(
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ?? 'table',
      header: json['header'] as String? ?? (json['name'] as String? ?? ''),
      pageSize: json['page_size'] as String? ?? 'A4',
      rows: rawRows
          .map((e) => TemplateRow.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class TemplateRow {
  TemplateRow({
    this.sr,
    required this.label,
    required this.value,
    this.fallback,
  });

  /// Serial number column (optional).
  final int? sr;

  /// Row label (e.g. "फिर्यादी").
  final String label;

  /// Value template with placeholders/loops (e.g. "{complainant.name} ...").
  final String value;

  /// Text to use when the rendered value is empty (e.g. "दोन अनोळखी").
  final String? fallback;

  factory TemplateRow.fromJson(Map<String, dynamic> json) {
    return TemplateRow(
      sr: json['sr'] as int?,
      label: json['label'] as String? ?? '',
      value: json['value'] as String? ?? '',
      fallback: json['fallback'] as String?,
    );
  }
}

/// A template row after its placeholders have been resolved against a crime.
class RenderedRow {
  RenderedRow({this.sr, required this.label, required this.value});

  final int? sr;
  final String label;
  final String value;
}

/// A fully rendered report ready to hand to a PDF/DOCX renderer.
class RenderedReport {
  RenderedReport({
    required this.name,
    required this.header,
    required this.pageSize,
    required this.rows,
  });

  final String name;
  final String header;
  final String pageSize;
  final List<RenderedRow> rows;
}
