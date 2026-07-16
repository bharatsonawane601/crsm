import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'crime_details_model.dart';

const _font = 'NotoSansDevanagari';
const _fs = 11.0;

/// A4 aspect ratio (height / width) used to make each captured page an exact
/// full page (so the PDF fills the sheet with no letterboxing).
const double _a4Ratio = 297 / 210;

/// Pixel-exact rendering of the CRIME DETAILS FORM (2-A / 2-B / 2-C + map page).
/// [only] selects a single page for the multi-page PDF; null renders all four.
class CrimeDetailsView extends StatelessWidget {
  const CrimeDetailsView({
    super.key,
    required this.values,
    required this.victims,
    this.width = 780,
    this.only,
    this.mapImage,
    this.gpsLabel,
  });

  final Map<String, String> values;
  final List<CdVictim> victims;
  final double width;
  final int? only;

  /// A scene map PNG (built from the captured GPS) shown in the item-9 Map box.
  final Uint8List? mapImage;

  /// "lat, lng" label shown under the map / when no map could be fetched.
  final String? gpsLabel;

  String v(String id) => values[id] ?? '';

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[];
    void addPage(int n, Widget child) {
      if (only == null || only == n) pages.add(_page(child));
    }

    addPage(1, _pageA());
    addPage(2, _pageB());
    addPage(3, _pageC());
    addPage(4, _pageD());

    return DefaultTextStyle(
      style: const TextStyle(
          fontFamily: _font, color: Colors.black, fontSize: _fs, height: 1.5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < pages.length; i++) ...[
            if (i > 0) const SizedBox(height: 24),
            pages[i],
          ],
        ],
      ),
    );
  }

  Widget _page(Widget child) => Container(
        width: width,
        height: width * _a4Ratio,
        decoration: const BoxDecoration(color: Colors.white),
        padding: const EdgeInsets.fromLTRB(26, 18, 26, 18),
        clipBehavior: Clip.hardEdge,
        alignment: Alignment.topLeft,
        child: child,
      );

  Widget _formTag(String tag) => Align(
        alignment: Alignment.centerRight,
        child: Text(tag,
            style: const TextStyle(
                fontFamily: 'Times New Roman',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic)),
      );

  // ---- Page 2-A -----------------------------------------------------------
  Widget _pageA() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _formTag('Form: 2-A'),
        const Center(
          child: Text('CRIME DETAILS FORM',
              style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline)),
        ),
        const Center(
          child: Text('गुन्ह्याचा तपशीलाचा नमुना',
              style: TextStyle(
                  fontFamily: _font, fontSize: 12.5, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        _row([
          _t('1) District: '),
          _dash(v('district'), flex: 2),
          _t(' P.S.: '),
          _dash(v('policeStation'), flex: 2),
          _t(' Year: '),
          _dash(v('year'), flex: 1),
          _t(' FIR No: '),
          _dash(v('firNo'), flex: 2),
          _t(' Date: '),
          _dash(v('firDate'), flex: 2),
        ]),
        _hint('   जिल्हा / पोलीस ठाणा / वर्ष / पोली खबर क्र. / तारीख'),
        _gap(),
        _row([_t('2) Act and Section: '), _dash(v('actSection'), flex: 5, maxLines: 2)]),
        _hint('   अधिनियम व कलम'),
        _gap(),
        const Text('3) The Place of Occurrence shown by:',
            style: TextStyle(fontFamily: _font, fontSize: _fs)),
        _row([
          _t('Name: '),
          _dash(v('placeByName'), flex: 3),
          _t(" Father's/Husband's Name: "),
          _dash(v('placeByFather'), flex: 3),
        ]),
        _row([_t('Address: '), _dash(v('placeByAddress'), flex: 5, maxLines: 2)]),
        _hint('   नाव / पित्याचे/पतीचे नाव / पत्ता'),
        _gap(),
        const Text('4) TYPE OF CRIME (All including M.O. Crime):',
            style: TextStyle(fontFamily: _font, fontSize: _fs, fontWeight: FontWeight.bold)),
        _row([
          _t('  (i) *Major Head: '),
          _dash(v('majorHead'), flex: 3),
          _t(' (ii) *Minor Head: '),
          _dash(v('minorHead'), flex: 3),
        ]),
        _row([_t('  (iii) *Method (s): ')]),
        _row([_t('     (१) '), _dash(v('method1'), flex: 5)]),
        _row([_t('     (२) '), _dash(v('method2'), flex: 5)]),
        _row([_t('     (३) '), _dash(v('method3'), flex: 5)]),
        _row([_t('  (iv) Conveyances used: '), _dash(v('conveyances'), flex: 4)]),
        _row([_t('  (v) *Character Assumed: '), _dash(v('character'), flex: 4)]),
        _row([_t('  (vi) *Language/ slang used: '), _dash(v('language'), flex: 3)]),
        _row([_t('  (vii) *Special Feature-1: '), _dash(v('feature1'), flex: 3)]),
        _row([_t('           *Special Feature-2: '), _dash(v('feature2'), flex: 3)]),
        _row([_t('           *Special Feature-3: '), _dash(v('feature3'), flex: 3)]),
        _row([_t('  (viii) Type of Place of Occurrence: '), _dash(v('placeType'), flex: 3)]),
        _row([_t('  (ix) Type of Property Involved (4 Types):')]),
        _row([
          _t('     (१) '),
          _dash(v('property1'), flex: 3),
          _t('  (२) '),
          _dash(v('property2'), flex: 3),
        ]),
        _row([
          _t('     (३) '),
          _dash(v('property3'), flex: 3),
          _t('  (४) '),
          _dash(v('property4'), flex: 3),
        ]),
        const SizedBox(height: 12),
        _mrw(),
      ],
    );
  }

  // ---- Page 2-B -----------------------------------------------------------
  Widget _pageB() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _formTag('Form: 2-B'),
        const Text('5) Particulars of the victims (Attach separate sheet, if required)',
            style: TextStyle(fontFamily: _font, fontSize: _fs, fontWeight: FontWeight.bold)),
        _hint('   बळींचा तपशील (आवश्यक असल्यास स्वतंत्र कागद जोडा)'),
        const SizedBox(height: 4),
        _victimsTable(),
        _gap(),
        _row([_t('6) Motive of Crime: '), _dash(v('motive'), flex: 4, maxLines: 2)]),
        _hint('   गुन्ह्याचा हेतू'),
        _gap(),
        const Text('7) Details of properties Stolen/Involved: (Use prescribed forms & attach)',
            style: TextStyle(fontFamily: _font, fontSize: _fs)),
        _hint('   चोरीला/संबंधीत मालमत्तेचा तपशील'),
        _multiline(v('propertiesInvolved'), 4),
        _gap(),
        const Text('8) Description of the place of occurrence:',
            style: TextStyle(fontFamily: _font, fontSize: _fs)),
        _hint('   घटनेच्या जागेचे वर्णन'),
        _multiline(v('sceneDescription'), 6),
        const SizedBox(height: 10),
        _mrw(),
      ],
    );
  }

  // ---- Page 2-C -----------------------------------------------------------
  Widget _pageC() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _formTag('Form: 2-C'),
        const Text('Description of the place of occurrence (Cont.):',
            style: TextStyle(fontFamily: _font, fontSize: _fs, fontWeight: FontWeight.bold)),
        _hint('   घटनेच्या जागेचे वर्णन (पुढे)'),
        const SizedBox(height: 6),
        _multiline(v('sceneDescriptionCont'), 34),
        const SizedBox(height: 10),
        _mrw(),
      ],
    );
  }

  // ---- Page 4 (Map + physical evidence + signatures) ----------------------
  Widget _pageD() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text('(9) Map: नकाशा',
                style: TextStyle(
                    fontFamily: _font, fontSize: _fs, fontWeight: FontWeight.bold)),
            if (gpsLabel != null)
              Text(gpsLabel!,
                  style: const TextStyle(
                      fontFamily: _font, fontSize: 8.5, color: Colors.black54)),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          height: 250,
          decoration:
              BoxDecoration(border: Border.all(color: Colors.black, width: 0.8)),
          clipBehavior: Clip.hardEdge,
          alignment: Alignment.center,
          child: mapImage != null
              ? Image.memory(mapImage!, fit: BoxFit.cover)
              : Text(
                  gpsLabel == null
                      ? 'घटनास्थळी GPS फोटो घेतल्यास नकाशा येथे येईल'
                      : 'नकाशा उपलब्ध नाही ($gpsLabel)',
                  style: const TextStyle(
                      fontFamily: _font, fontSize: 9.5, color: Colors.black45)),
        ),
        const SizedBox(height: 12),
        const Text(
            '(10) Description of physical evidence from the scene of crime for the property recovered / seized for the purpose of investigation:',
            style: TextStyle(fontFamily: _font, fontSize: _fs, fontWeight: FontWeight.bold)),
        _hint('   तपासाच्या उद्देशाने प्राप्त/जप्त घटनास्थळावरील भौतिक पुराव्याचे वर्णन'),
        _multiline(v('physicalEvidence'), 6),
        const SizedBox(height: 12),
        _row([
          _t('Date and Time of panchanama: '),
          _dash(v('panchnamaDate'), flex: 2),
          _t('  Time: '),
          _dash(v('panchnamaTime'), flex: 2),
        ]),
        _hint('   पंचनामा दिनांक व वेळ'),
        const SizedBox(height: 14),
        _signatures(),
        const SizedBox(height: 8),
        _mrw(),
      ],
    );
  }

  Widget _victimsTable() {
    const border = BorderSide(color: Colors.black, width: 0.7);
    final display = [...victims];
    while (display.length < 5) {
      display.add(const CdVictim());
    }
    const headsEn = [
      'Sr.\nNo.', 'Full Name', 'Date/Year\nof Birth', 'Sex', 'Nationality',
      'Religion', 'SC/ST', 'Occupation', 'Address', 'Injury', 'Means'
    ];
    Widget cell(String t, {bool bold = false}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 5),
          child: Text(t,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: _font,
                  fontSize: 8.5,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        );
    return Table(
      border: const TableBorder(
        top: border, bottom: border, left: border, right: border,
        horizontalInside: border, verticalInside: border,
      ),
      columnWidths: const {
        0: FixedColumnWidth(26),
        1: FlexColumnWidth(2.2),
        2: FlexColumnWidth(1.2),
        3: FixedColumnWidth(30),
        4: FlexColumnWidth(1.1),
        5: FlexColumnWidth(1),
        6: FixedColumnWidth(34),
        7: FlexColumnWidth(1.2),
        8: FlexColumnWidth(1.8),
        9: FlexColumnWidth(1.1),
        10: FlexColumnWidth(1.1),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(children: [for (final h in headsEn) cell(h, bold: true)]),
        for (var i = 0; i < display.length; i++)
          TableRow(children: [
            cell(display[i].fullName.isEmpty ? '' : '${i + 1}'),
            for (final c in display[i].cells) cell(c),
          ]),
      ],
    );
  }

  Widget _signatures() {
    Widget dashLabel(String label, String value) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(label, style: const TextStyle(fontFamily: _font, fontSize: _fs)),
            Expanded(child: _DashField(value: value)),
          ]),
        );
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Name of panchas: / पंचाची नावे :',
                style: TextStyle(fontFamily: _font, fontSize: _fs, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            dashLabel('(1) ', v('panch1Name')),
            dashLabel('     पत्ता : ', v('panch1Address')),
            dashLabel('(2) ', v('panch2Name')),
            dashLabel('     पत्ता : ', v('panch2Address')),
            const SizedBox(height: 8),
            dashLabel('Date / दिनांक : ', v('ioDate')),
          ]),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Signature of Panchas: / पंचाच्या सह्या :',
                style: TextStyle(fontFamily: _font, fontSize: _fs, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            dashLabel('1) ', ''),
            const SizedBox(height: 14),
            dashLabel('2) ', ''),
            const SizedBox(height: 8),
            const Text('Name and Signature of Investigation Officer',
                style: TextStyle(fontFamily: _font, fontSize: 10, fontWeight: FontWeight.bold)),
            const Text('तपासी अंमलदाराची सही',
                style: TextStyle(fontFamily: _font, fontSize: _fs)),
            dashLabel('Name / नाव : ', v('ioName')),
            dashLabel('Rank / पदनाम : ', v('ioRank')),
            dashLabel('B.No / बक्कल नंबर : ', v('ioBuckle')),
          ]),
        ),
      ],
    );
  }

  // ---- Shared helpers -----------------------------------------------------
  Widget _multiline(String value, int lines) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (value.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(value,
                  style: const TextStyle(fontFamily: _font, fontSize: _fs)),
            ),
          for (var i = 0; i < lines; i++)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: SizedBox(
                  height: 1,
                  width: double.infinity,
                  child: CustomPaint(painter: _DashPainter())),
            ),
        ],
      );

  Widget _row(List<Widget> children) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: children),
      );

  Widget _gap() => const SizedBox(height: 6);
  Widget _t(String t) =>
      Text(t, style: const TextStyle(fontFamily: _font, fontSize: _fs));
  Widget _hint(String t) => Text(t,
      style: const TextStyle(
          fontFamily: _font, fontSize: 8.5, color: Colors.black54));
  Widget _dash(String value, {int flex = 1, int maxLines = 1}) =>
      Expanded(flex: flex, child: _DashField(value: value, maxLines: maxLines));
  Widget _mrw() => const Align(
      alignment: Alignment.centerRight,
      child: Text('M.R.W', style: TextStyle(fontFamily: _font, fontSize: 9)));
}

/// A value sitting on a dashed fill-line.
class _DashField extends StatelessWidget {
  const _DashField({required this.value, this.maxLines = 1});
  final String value;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(value,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontFamily: _font, fontSize: _fs)),
        const SizedBox(height: 1),
        const SizedBox(
          height: 1,
          width: double.infinity,
          child: CustomPaint(painter: _DashPainter()),
        ),
      ],
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter();
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 0.8;
    const dash = 3.0, gap = 2.0;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dash, 0), paint);
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(_DashPainter oldDelegate) => false;
}
