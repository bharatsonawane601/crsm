import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import 'mo_form_e_model.dart';
import 'mo_form_e_view.dart';

/// Renders Form "E" to a portrait-A4 PDF by rasterising the exact widget (so
/// Marathi shapes correctly) and embedding it.
Future<Uint8List> renderMoFormEPdf(Map<String, String> values) async {
  final png = await ScreenshotController().captureFromWidget(
    Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Material(
        color: Colors.white,
        child: MoFormEView(values: values, width: 760),
      ),
    ),
    pixelRatio: 2.4,
    delay: const Duration(milliseconds: 90),
  );

  final doc = pw.Document();
  final image = pw.MemoryImage(png);
  doc.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(18),
      build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
    ),
  );
  return doc.save();
}

// ---------------------------------------------------------------------------
// Word (.docx). A .docx is an OOXML zip; we build it by hand (no dependency).
// Word shapes Devanagari on open, so this is the true editable Marathi output.
// ---------------------------------------------------------------------------
Uint8List renderMoFormEDocx(Map<String, String> values) {
  final document = _documentXml(values);
  final archive = Archive();
  void add(String name, String content) {
    final bytes = utf8.encode(content);
    archive.addFile(ArchiveFile(name, bytes.length, bytes));
  }

  add('[Content_Types].xml', _contentTypes);
  add('_rels/.rels', _rootRels);
  add('word/document.xml', document);

  final zipped = ZipEncoder().encode(archive);
  if (zipped == null) throw StateError('Failed to encode DOCX');
  return Uint8List.fromList(zipped);
}

const _contentTypes =
    '''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
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

String _documentXml(Map<String, String> values) {
  final b = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    ..writeln('<w:document xmlns:w="$_w"><w:body>')
    ..writeln(_heading('FORM "E"'))
    ..writeln(_heading('मोडस ऑपरेंडी ब्युरोला पुरविण्यात यावयाची माहिती'))
    ..writeln(_table(values))
    ..writeln('<w:sectPr/>')
    ..writeln('</w:body></w:document>');
  return b.toString();
}

String _heading(String text) =>
    '<w:p><w:pPr><w:jc w:val="center"/></w:pPr>'
    '<w:r><w:rPr><w:b/><w:sz w:val="30"/>${_rFonts()}</w:rPr>'
    '<w:t xml:space="preserve">${_esc(text)}</w:t></w:r></w:p>';

String _table(Map<String, String> values) {
  final b = StringBuffer()
    ..writeln('<w:tbl>')
    ..writeln('<w:tblPr><w:tblW w:w="0" w:type="auto"/>'
        '<w:tblBorders>'
        '${_bd('top')}${_bd('left')}${_bd('bottom')}'
        '${_bd('right')}${_bd('insideH')}${_bd('insideV')}'
        '</w:tblBorders></w:tblPr>');
  for (final r in kMoFormERows) {
    b.writeln(_row('${r.number}.', r.mr, values[r.id] ?? ''));
  }
  b.writeln('</w:tbl>');
  return b.toString();
}

String _row(String num, String label, String value) {
  const widths = [600, 3600, 4800]; // twips per column
  final cells = [num, label, value];
  final b = StringBuffer('<w:tr>');
  for (var i = 0; i < cells.length; i++) {
    b
      ..write('<w:tc><w:tcPr><w:tcW w:w="${widths[i]}" w:type="dxa"/></w:tcPr>')
      ..write('<w:p><w:r><w:rPr>${i == 0 ? '<w:b/>' : ''}${_rFonts()}</w:rPr>')
      ..write('<w:t xml:space="preserve">${_esc(cells[i])}</w:t>')
      ..write('</w:r></w:p></w:tc>');
  }
  b.write('</w:tr>');
  return b.toString();
}

String _rFonts() => '<w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" '
    'w:cs="Nirmala UI"/><w:lang w:bidi="mr-IN"/>';

String _bd(String side) =>
    '<w:$side w:val="single" w:sz="4" w:space="0" w:color="000000"/>';

String _esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');
