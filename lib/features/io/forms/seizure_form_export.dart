import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import 'seizure_form_model.dart';
import 'seizure_form_view.dart';

/// Renders the two-page Property Search & Seizure form to a PDF by rasterising
/// each page's exact widget (so Marathi shapes correctly) and embedding it.
Future<Uint8List> renderSeizurePdf(
    Map<String, String> values, List<SeizurePropertyRow> rows) async {
  final doc = pw.Document();
  for (final page in [1, 2]) {
    final png = await ScreenshotController().captureFromWidget(
      Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Material(
          color: Colors.white,
          child: SeizureFormView(values: values, rows: rows, width: 780, only: page),
        ),
      ),
      pixelRatio: 2.2,
      delay: const Duration(milliseconds: 90),
    );
    final image = pw.MemoryImage(png);
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(16),
      build: (_) => pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain)),
    ));
  }
  return doc.save();
}

// ---------------------------------------------------------------------------
// Word (.docx) — an editable Marathi equivalent (Word shapes Devanagari).
// ---------------------------------------------------------------------------
Uint8List renderSeizureDocx(
    Map<String, String> values, List<SeizurePropertyRow> rows) {
  final document = _documentXml(values, rows);
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

String _documentXml(Map<String, String> v, List<SeizurePropertyRow> rows) {
  String val(String id) => v[id] ?? '';
  final b = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    ..writeln('<w:document xmlns:w="$_w"><w:body>')
    ..writeln(_p('PROPERTY SEARCH & SEIZURE FORM', bold: true, center: true, sz: 30))
    ..writeln(_p('मालमत्ता शोध व जप्तीचा नमुना', bold: true, center: true, sz: 26))
    ..writeln(_p('(Search/ Production/ Recovery u/s. 185 B.N.S.S)', center: true))
    ..writeln(_kv('१) जिल्हा / पोलीस ठाणे / वर्ष',
        '${val('district')} / ${val('policeStation')} / ${val('year')}'))
    ..writeln(_kv('   पहिली खबर क्र./कार्यवाही / दि.',
        '${val('firNo')}  ${val('firDate')}'))
    ..writeln(_kv('२) अधिनियम व कलमे', val('actsSections')))
    ..writeln(_kv('३) मालमत्तेचे स्वरूप', val('natureOfProperty')))
    ..writeln(_kv('४) जप्तीची तारीख / वेळ',
        '${val('seizureDate')}  ${val('seizureTime')}'))
    ..writeln(_kv('(क) जेथून जप्त/परत मिळाली ती जागा', val('placeSeized')))
    ..writeln(_kv('(ड) जागेचे वर्णन', val('placeDescription')))
    ..writeln(_kv('५) चोरीचा माल घेणारा धंदेवाईक', val('receiverProfessional')))
    ..writeln(_person('कोणाकडून जप्त', v, 'receiver'))
    ..writeln(_p('६) साक्षदार', bold: true))
    ..writeln(_person('(i)', v, 'w1'))
    ..writeln(_person('(ii)', v, 'w2'))
    ..writeln(_kv('७) नाशवंत मालमत्ता शिफारस/कार्यवाही', val('perishableRec')))
    ..writeln(_kv('८) मौल्यवान मालमत्ता शिफारस/कार्यवाही', val('valuableRec')))
    ..writeln(_kv('९) ओळख पटवावी लागली काय', val('identificationNeeded')))
    ..writeln(_kv('११) जप्तीची परिस्थिती/कारणे', val('circumstances')))
    ..writeln(_p(
        '१२) वर नमुद मालमत्ता साक्षीदारांच्या समक्ष कायद्यातील तरतुदींनुसार जप्त करण्यात आली.'))
    ..writeln(_p('१३) जप्त मालमत्ता :', bold: true))
    ..writeln(_table(rows))
    ..writeln(_kv('पंच १', '${val('panch1Name')}  ${val('panch1Address')}'))
    ..writeln(_kv('पंच २', '${val('panch2Name')}  ${val('panch2Address')}'))
    ..writeln(_kv('दिनांक', val('formDate')))
    ..writeln(_kv('तपासी अंमलदार — नाव / पदनाम / बक्कल नंबर',
        '${val('ioName')} / ${val('ioRank')} / ${val('ioBuckle')}'))
    ..writeln('<w:sectPr/>')
    ..writeln('</w:body></w:document>');
  return b.toString();
}

String _person(String label, Map<String, String> v, String prefix) {
  String val(String id) => v['$prefix$id'] ?? '';
  return _kv(label,
      'नाव: ${val('Name')}  पिता/पती: ${val('Father')}  लिंग: ${val('Gender')}  वय: ${val('Age')}  व्यवसाय: ${val('Occupation')}  पत्ता: ${val('Address')}');
}

const _w = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main';

String _p(String text, {bool bold = false, bool center = false, int sz = 22}) =>
    '<w:p>${center ? '<w:pPr><w:jc w:val="center"/></w:pPr>' : ''}'
    '<w:r><w:rPr>${bold ? '<w:b/>' : ''}<w:sz w:val="$sz"/>${_rFonts()}</w:rPr>'
    '<w:t xml:space="preserve">${_esc(text)}</w:t></w:r></w:p>';

String _kv(String label, String value) =>
    '<w:p><w:r><w:rPr><w:b/>${_rFonts()}</w:rPr>'
    '<w:t xml:space="preserve">${_esc(label)}: </w:t></w:r>'
    '<w:r><w:rPr>${_rFonts()}</w:rPr>'
    '<w:t xml:space="preserve">${_esc(value)}</w:t></w:r></w:p>';

String _table(List<SeizurePropertyRow> rows) {
  final b = StringBuffer()
    ..writeln('<w:tbl>')
    ..writeln('<w:tblPr><w:tblW w:w="0" w:type="auto"/><w:tblBorders>'
        '${_bd('top')}${_bd('left')}${_bd('bottom')}${_bd('right')}'
        '${_bd('insideH')}${_bd('insideV')}</w:tblBorders></w:tblPr>')
    ..writeln(_row('अ.क्र.', 'मालमत्ता', 'सही', bold: true));
  for (var i = 0; i < rows.length; i++) {
    b.writeln(_row('${i + 1}', rows[i].description, rows[i].signedOn));
  }
  b.writeln('</w:tbl>');
  return b.toString();
}

String _row(String a, String b, String c, {bool bold = false}) {
  const widths = [700, 5200, 2600];
  final cells = [a, b, c];
  final buf = StringBuffer('<w:tr>');
  for (var i = 0; i < cells.length; i++) {
    buf
      ..write('<w:tc><w:tcPr><w:tcW w:w="${widths[i]}" w:type="dxa"/></w:tcPr>')
      ..write('<w:p><w:r><w:rPr>${bold ? '<w:b/>' : ''}${_rFonts()}</w:rPr>')
      ..write('<w:t xml:space="preserve">${_esc(cells[i])}</w:t>')
      ..write('</w:r></w:p></w:tc>');
  }
  buf.write('</w:tr>');
  return buf.toString();
}

String _rFonts() => '<w:rFonts w:ascii="Calibri" w:hAnsi="Calibri" '
    'w:cs="Nirmala UI"/><w:lang w:bidi="mr-IN"/>';
String _bd(String s) =>
    '<w:$s w:val="single" w:sz="4" w:space="0" w:color="000000"/>';
String _esc(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

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
