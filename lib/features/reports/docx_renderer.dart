import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

import 'models/report_template.dart';

/// Renders a [RenderedReport] to a Word (.docx) file. A .docx is an OOXML
/// package (a zip of XML parts); we build it by hand so there's no heavy
/// dependency. Word shapes Devanagari correctly on open, so this is the
/// recommended path for official Marathi output.
Uint8List renderReportDocx(RenderedReport report) {
  final document = _documentXml(report);

  final archive = Archive();
  void addText(String name, String content) {
    final bytes = utf8.encode(content);
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  }

  addText('[Content_Types].xml', _contentTypes);
  addText('_rels/.rels', _rootRels);
  addText('word/document.xml', document);

  final zipped = ZipEncoder().encode(archive);
  if (zipped == null) {
    throw StateError('Failed to encode DOCX archive');
  }
  return Uint8List.fromList(zipped);
}

const _contentTypes = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
</Types>''';

const _rootRels = '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/>
</Relationships>''';

const _w = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main';

String _documentXml(RenderedReport report) {
  final buffer = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    ..writeln('<w:document xmlns:w="$_w"><w:body>')
    ..writeln(_heading(report.header))
    ..writeln(_table(report.rows))
    ..writeln('<w:sectPr/>')
    ..writeln('</w:body></w:document>');
  return buffer.toString();
}

String _heading(String text) {
  // Each line of the header becomes its own centered, bold paragraph.
  final lines = text.split('\n').where((l) => l.trim().isNotEmpty);
  return [
    for (final line in lines)
      '<w:p><w:pPr><w:jc w:val="center"/></w:pPr>'
          '<w:r><w:rPr><w:b/><w:sz w:val="30"/>${_rFonts()}</w:rPr>'
          '<w:t xml:space="preserve">${_esc(line)}</w:t></w:r></w:p>',
  ].join();
}

String _table(List<RenderedRow> rows) {
  final buffer = StringBuffer()
    ..writeln('<w:tbl>')
    ..writeln('<w:tblPr><w:tblW w:w="0" w:type="auto"/>'
        '<w:tblBorders>'
        '${_border('top')}${_border('left')}${_border('bottom')}'
        '${_border('right')}${_border('insideH')}${_border('insideV')}'
        '</w:tblBorders></w:tblPr>')
    ..writeln(_row(['अ.क्र.', 'विवरण', 'गुन्हयाची माहिती'], bold: true));
  for (final r in rows) {
    buffer.writeln(_row([r.sr?.toString() ?? '', r.label, r.value]));
  }
  buffer.writeln('</w:tbl>');
  return buffer.toString();
}

String _row(List<String> cells, {bool bold = false}) {
  final widths = [600, 3000, 5400]; // twips per column
  final buffer = StringBuffer('<w:tr>');
  for (var i = 0; i < cells.length; i++) {
    buffer
      ..write('<w:tc><w:tcPr><w:tcW w:w="${widths[i]}" w:type="dxa"/></w:tcPr>')
      ..write('<w:p><w:r><w:rPr>${bold ? '<w:b/>' : ''}${_rFonts()}</w:rPr>')
      ..write('<w:t xml:space="preserve">${_esc(cells[i])}</w:t>')
      ..write('</w:r></w:p></w:tc>');
  }
  buffer.write('</w:tr>');
  return buffer.toString();
}

/// Use Nirmala UI for complex-script (Devanagari) so Word renders Marathi well.
String _rFonts() => '<w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" '
    'w:cs="Nirmala UI"/><w:lang w:bidi="mr-IN"/>';

String _border(String side) =>
    '<w:$side w:val="single" w:sz="4" w:space="0" w:color="000000"/>';

String _esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
