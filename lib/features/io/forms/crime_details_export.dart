import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import 'crime_details_model.dart';
import 'crime_details_view.dart';

/// Renders the four-page Crime Details form to a PDF by rasterising each page's
/// exact widget (so Marathi shapes correctly) and embedding it. Each page widget
/// is already A4-proportioned, so the image fills the sheet exactly (no border /
/// letterboxing). [mapImage] is placed in the item-9 Map box; [gpsLabel] shows
/// the scene coordinates.
Future<Uint8List> renderCrimeDetailsPdf(
    Map<String, String> values, List<CdVictim> victims,
    {Uint8List? mapImage, String? gpsLabel}) async {
  final doc = pw.Document();
  for (final page in [1, 2, 3, 4]) {
    final png = await ScreenshotController().captureFromWidget(
      Directionality(
        textDirection: ui.TextDirection.ltr,
        child: Material(
          color: Colors.white,
          child: CrimeDetailsView(
              values: values,
              victims: victims,
              width: 780,
              only: page,
              mapImage: mapImage,
              gpsLabel: gpsLabel),
        ),
      ),
      pixelRatio: 2.2,
      delay: const Duration(milliseconds: 90),
    );
    final image = pw.MemoryImage(png);
    doc.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (_) => pw.Image(image, fit: pw.BoxFit.fill),
    ));
  }
  return doc.save();
}

// ---------------------------------------------------------------------------
// Word (.docx) — editable Marathi equivalent.
// ---------------------------------------------------------------------------
Uint8List renderCrimeDetailsDocx(
    Map<String, String> values, List<CdVictim> victims) {
  final document = _documentXml(values, victims);
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

String _documentXml(Map<String, String> vv, List<CdVictim> victims) {
  String v(String id) => vv[id] ?? '';
  final b = StringBuffer()
    ..writeln('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
    ..writeln('<w:document xmlns:w="$_w"><w:body>')
    ..writeln(_p('CRIME DETAILS FORM', bold: true, center: true, sz: 30))
    ..writeln(_p('गुन्ह्याचा तपशीलाचा नमुना', bold: true, center: true, sz: 26))
    ..writeln(_kv('1) District / P.S. / Year / FIR / Date',
        '${v('district')} / ${v('policeStation')} / ${v('year')} / ${v('firNo')} / ${v('firDate')}'))
    ..writeln(_kv('2) Act and Section', v('actSection')))
    ..writeln(_kv('3) Place shown by',
        '${v('placeByName')}  (पिता/पती: ${v('placeByFather')})  ${v('placeByAddress')}'))
    ..writeln(_p('4) TYPE OF CRIME', bold: true))
    ..writeln(_kv('   Major / Minor Head', '${v('majorHead')} / ${v('minorHead')}'))
    ..writeln(_kv('   Method(s)',
        '${v('method1')}; ${v('method2')}; ${v('method3')}'))
    ..writeln(_kv('   Conveyances used', v('conveyances')))
    ..writeln(_kv('   Character assumed', v('character')))
    ..writeln(_kv('   Language / slang', v('language')))
    ..writeln(_kv('   Special features',
        '${v('feature1')}; ${v('feature2')}; ${v('feature3')}'))
    ..writeln(_kv('   Type of place', v('placeType')))
    ..writeln(_kv('   Property types',
        '${v('property1')}, ${v('property2')}, ${v('property3')}, ${v('property4')}'))
    ..writeln(_p('5) Particulars of victims', bold: true))
    ..writeln(_victimsTable(victims))
    ..writeln(_kv('6) Motive of Crime', v('motive')))
    ..writeln(_kv('7) Properties stolen/involved', v('propertiesInvolved')))
    ..writeln(_kv('8) Description of place of occurrence', v('sceneDescription')))
    ..writeln(_kv('   (Cont.)', v('sceneDescriptionCont')))
    ..writeln(_kv('10) Physical evidence', v('physicalEvidence')))
    ..writeln(_kv('Date & Time of panchanama',
        '${v('panchnamaDate')}  ${v('panchnamaTime')}'))
    ..writeln(_kv('पंच १', '${v('panch1Name')}  ${v('panch1Address')}'))
    ..writeln(_kv('पंच २', '${v('panch2Name')}  ${v('panch2Address')}'))
    ..writeln(_kv('तपासी अंमलदार — नाव / पदनाम / बक्कल',
        '${v('ioName')} / ${v('ioRank')} / ${v('ioBuckle')}'))
    ..writeln('<w:sectPr/>')
    ..writeln('</w:body></w:document>');
  return b.toString();
}

String _victimsTable(List<CdVictim> victims) {
  const heads = ['Sr', 'Name', 'DOB', 'Sex', 'Nat.', 'Rel.', 'SC/ST', 'Occ.', 'Address', 'Injury', 'Means'];
  final b = StringBuffer()
    ..writeln('<w:tbl><w:tblPr><w:tblW w:w="0" w:type="auto"/><w:tblBorders>'
        '${_bd('top')}${_bd('left')}${_bd('bottom')}${_bd('right')}'
        '${_bd('insideH')}${_bd('insideV')}</w:tblBorders></w:tblPr>')
    ..writeln(_tr(heads, bold: true));
  for (var i = 0; i < victims.length; i++) {
    b.writeln(_tr(['${i + 1}', ...victims[i].cells]));
  }
  b.writeln('</w:tbl>');
  return b.toString();
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

String _tr(List<String> cells, {bool bold = false}) {
  final buf = StringBuffer('<w:tr>');
  for (final c in cells) {
    buf
      ..write('<w:tc><w:tcPr><w:tcW w:w="0" w:type="auto"/></w:tcPr>')
      ..write('<w:p><w:r><w:rPr>${bold ? '<w:b/>' : ''}${_rFonts()}</w:rPr>')
      ..write('<w:t xml:space="preserve">${_esc(c)}</w:t></w:r></w:p></w:tc>');
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
