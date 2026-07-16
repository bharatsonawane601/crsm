import 'package:flutter/material.dart';

import 'seizure_form_model.dart';

const _font = 'NotoSansDevanagari';
const _fs = 11.5;

/// Pixel-exact rendering of the PROPERTY SEARCH & SEIZURE FORM. [only] selects a
/// single page for the two-page PDF; null renders both (screen preview).
class SeizureFormView extends StatelessWidget {
  const SeizureFormView({
    super.key,
    required this.values,
    required this.rows,
    this.width = 780,
    this.only,
  });

  final Map<String, String> values;
  final List<SeizurePropertyRow> rows;
  final double width;
  final int? only;

  String v(String id) => values[id] ?? '';

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: const TextStyle(
          fontFamily: _font, color: Colors.black, fontSize: _fs, height: 1.55),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (only == null || only == 1) _page(_page1()),
          if (only == null) const SizedBox(height: 24),
          if (only == null || only == 2) _page(_page2()),
        ],
      ),
    );
  }

  Widget _page(Widget child) => Container(
        width: width,
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(26, 20, 26, 20),
        child: child,
      );

  // ---- Page 1 -------------------------------------------------------------
  Widget _page1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Center(
          child: Text('PROPERTY SEACH & SEIZURE FORM',
              style: TextStyle(
                  fontFamily: 'Times New Roman',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ),
        const Center(
          child: Text('मालमत्ता शोध व जप्तीचा नमुना',
              style: TextStyle(
                  fontFamily: _font,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline)),
        ),
        const Center(
          child: Text('(Search/ Production/ Recovery u/s. 185 B.N.S.S)',
              style: TextStyle(
                  fontFamily: _font,
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold)),
        ),
        const Center(
          child: Text(
              '(कलम १८५ भारतीय नागरीक सुरक्षा संहिता २०२३ अन्वये झडती/हजर करणे/परत मिळविणे)',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: _font, fontSize: 10.5)),
        ),
        const _Dashed(),
        const SizedBox(height: 4),

        // 1) District / PS / Year, then FIR / date on the next line.
        _row([
          _t('१) *जिल्हा:'),
          _dash(v('district'), flex: 3),
          _t(' *पोलीस ठाणे:'),
          _dash(v('policeStation'), flex: 3),
          _t(' वर्षे:'),
          _dash(v('year'), flex: 2),
        ]),
        _row([
          _t('   *पहिली खबर क्र/कार्यवाही '),
          _dash(v('firNo'), flex: 3),
          _t(' *दि. '),
          _dash(v('firDate'), flex: 3),
          _t('/२०'),
          _dash('', flex: 1),
        ]),
        _gap(),
        _row([_t('२) अधिनियम व कलमे :'), _dash(v('actsSections'), flex: 5, maxLines: 2)]),
        _gap(),
        // 3) Exactly as printed — the nature options are the field itself.
        const Text(
            '३) *जप्त केलेले/मिळालेल्या मालमत्तेचे स्वरूप : चोरीला गेलेली/बेवारशी/बेकायदेशीर ताबा/अंतर्गत/मृत्यूपत्राशिवाय.',
            style: TextStyle(fontFamily: _font, fontSize: _fs)),
        _gap(),
        _row([
          _t('४) जप्त केलेली मालमत्ता : (अ) तारीख : '),
          _dash(v('seizureDate'), flex: 2),
          _t('/२०'),
          _dash('', flex: 1),
          _t('   (ब) वेळ : '),
          _dash(v('seizureTime'), flex: 2),
        ]),
        _gap(),
        _row([
          _t('(क) जेथून जप्त केली/परत मिळाली ती जागा : '),
          _dash(v('placeSeized'), flex: 4, maxLines: 2),
        ]),
        _gap(),
        _row([
          _t('(ड) जप्तीच्या/परत मिळवल्याची जागेचे वर्णन : '),
          _dash(v('placeDescription'), flex: 4, maxLines: 2),
        ]),
        _gap(),
        // 5) From whom seized.
        _row([_t('५) कोणकडून जप्त केली : '), _dash('', flex: 5)]),
        _row([
          _t('   *चोरीचा माल घेणारा धंदेवाईक : '),
          _t(v('receiverProfessional').isEmpty
              ? 'होय / नाही'
              : v('receiverProfessional')),
        ]),
        _person('receiver'),
        const _DashField(value: ''),
        _gap(),
        const Text('६) साक्षदार',
            style: TextStyle(fontFamily: _font, fontSize: _fs)),
        _personIndexed('(i)', 'w1'),
        const _DashField(value: ''),
        const SizedBox(height: 4),
        _personIndexed('(ii)', 'w2'),
        const _DashField(value: ''),
        _gap(),
        _row([
          _t('७) नाशवंत मालमत्तेच्या विल्हेवाटीसाठी केलेली शिफारस/केलेली कार्यवाही : '),
          _dash(v('perishableRec'), flex: 2, maxLines: 2),
        ]),
        _gap(),
        _row([
          _t('८) मौल्यवान मालमत्ता ठेवण्यासाठी केलेली शिफारस/केलेली कार्यवाही : '),
          _dash(v('valuableRec'), flex: 2, maxLines: 2),
        ]),
        _gap(),
        _row([
          _t('९) ओळख पटवावी लागली काय : '),
          _dash(v('identificationNeeded'), flex: 1),
          _t('   होय / नाही'),
        ]),
        _gap(),
        const Text(
            '१०) जप्त केलेल्या/परत मिळालेल्या मालाचे वर्णन (योग्य नमुन्यात माहिती भरा व जोडा )',
            style: TextStyle(fontFamily: _font, fontSize: _fs)),
        _gap(),
        _row([
          _t('११) जप्तीची परिस्थिती/कारणे : '),
          _dash(v('circumstances'), flex: 4, maxLines: 3)
        ]),
        const SizedBox(height: 16),
        const Align(
          alignment: Alignment.centerRight,
          child: Text('M.R.W', style: TextStyle(fontFamily: _font, fontSize: 9)),
        ),
      ],
    );
  }

  // ---- Page 2 -------------------------------------------------------------
  Widget _page2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
            '१२) वर नमुद करण्यात आलेली मालमत्ता पर्वंत साक्षीदारांच्या समक्ष कायदयातील तरतुदी नुसार जप्त करण्यात आली. आणि जप्तीच्या ज्ञापनाची ज्याच्याकडून मालमत्ता जप्त करण्यात आली. त्या इसमास/जागेत राहणाऱ्यास देण्यात आली.',
            style: TextStyle(fontFamily: _font, fontSize: _fs)),
        const SizedBox(height: 10),
        const Text(
            '१३) खालील मालमत्ता अविष्ठित आणि/किंवा मोहोरबंद करण्यात आली आणि त्यावर किंवा मालमत्तेवर पूर्वबत साक्षीदारांच्या सहया घेण्यात आल्या आहेत.',
            style: TextStyle(fontFamily: _font, fontSize: _fs)),
        const SizedBox(height: 8),
        _propertyTable(),
        const SizedBox(height: 18),
        const Align(
          alignment: Alignment.centerRight,
          child: Text('मोहोरेचा नमुना खाली देण्यात आली आहे.',
              style: TextStyle(fontFamily: _font, fontSize: _fs)),
        ),
        const SizedBox(height: 24),
        _signatures(),
        const SizedBox(height: 10),
        const Align(
          alignment: Alignment.centerRight,
          child: Text('M.R.W', style: TextStyle(fontFamily: _font, fontSize: 9)),
        ),
      ],
    );
  }

  Widget _propertyTable() {
    const border = BorderSide(color: Colors.black, width: 0.8);
    final display = [...rows];
    while (display.length < 8) {
      display.add(const SeizurePropertyRow('', ''));
    }
    Widget cell(String t, {bool bold = false, TextAlign align = TextAlign.left}) =>
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Text(t,
              textAlign: align,
              style: TextStyle(
                  fontFamily: _font,
                  fontSize: _fs,
                  fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        );
    return Table(
      border: const TableBorder(
        top: border,
        bottom: border,
        left: border,
        right: border,
        horizontalInside: border,
        verticalInside: border,
      ),
      columnWidths: const {
        0: FixedColumnWidth(56),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(2.2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(children: [
          cell('अ. क्र.\n(१)', bold: true, align: TextAlign.center),
          cell('मालमत्ता\n(२)', bold: true, align: TextAlign.center),
          cell('पुडक्यावर किंवा मालमत्तेवर सही घेण्यात आली.\n(३)',
              bold: true, align: TextAlign.center),
        ]),
        for (var i = 0; i < display.length; i++)
          TableRow(children: [
            cell(display[i].description.isEmpty ? '' : '${i + 1}',
                align: TextAlign.center),
            cell(display[i].description),
            cell(display[i].signedOn),
          ]),
      ],
    );
  }

  Widget _signatures() {
    Widget dashLabel(String label, String value) => Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(label, style: const TextStyle(fontFamily: _font, fontSize: _fs)),
              Expanded(child: _DashField(value: value)),
            ],
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Name of panchas:',
                      style: TextStyle(
                          fontFamily: _font,
                          fontSize: _fs,
                          fontWeight: FontWeight.bold)),
                  const Text('पंचाची नावे :',
                      style: TextStyle(fontFamily: _font, fontSize: _fs)),
                  const SizedBox(height: 4),
                  dashLabel('(1) ', v('panch1Name')),
                  dashLabel('     पत्ता : ', v('panch1Address')),
                  dashLabel('(2) ', v('panch2Name')),
                  dashLabel('     पत्ता : ', v('panch2Address')),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Signature of Panchas:',
                      style: TextStyle(
                          fontFamily: _font,
                          fontSize: _fs,
                          fontWeight: FontWeight.bold)),
                  const Text('पंचाच्या सह्या :',
                      style: TextStyle(fontFamily: _font, fontSize: _fs)),
                  const SizedBox(height: 4),
                  dashLabel('1) ', ''),
                  const SizedBox(height: 18),
                  dashLabel('2) ', ''),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  dashLabel('Date: ', v('formDate')),
                  const Text('दिनांक',
                      style: TextStyle(fontFamily: _font, fontSize: _fs)),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Name and Signature of Investigation Officer',
                      style: TextStyle(
                          fontFamily: _font,
                          fontSize: _fs,
                          fontWeight: FontWeight.bold)),
                  const Text('तपासी अंमलदाराची सही',
                      style: TextStyle(fontFamily: _font, fontSize: _fs)),
                  const SizedBox(height: 4),
                  dashLabel('Name / नांव : ', v('ioName')),
                  dashLabel('Rank / पदनाम : ', v('ioRank')),
                  dashLabel('B.No / बक्कल नंबर : ', v('ioBuckle')),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---- Shared field helpers ----------------------------------------------
  Widget _personIndexed(String idx, String prefix) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _row([
            _t('$idx नाव : '),
            _dash(v('${prefix}Name'), flex: 3),
            _t(' पित्याचे/पतीचे नाव : '),
            _dash(v('${prefix}Father'), flex: 3),
            _t(' लिंग : '),
            _dash(v('${prefix}Gender'), flex: 1),
          ]),
          _row([
            _t('     वय : '),
            _dash(v('${prefix}Age'), flex: 1),
            _t(' व्यवसाय : '),
            _dash(v('${prefix}Occupation'), flex: 2),
            _t(' पत्ता : '),
            _dash(v('${prefix}Address'), flex: 3),
          ]),
        ],
      );

  Widget _person(String prefix) => _Unindexed(this, prefix);

  Widget _row(List<Widget> children) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 1.5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: children),
      );

  Widget _gap() => const SizedBox(height: 6);

  Widget _t(String t) =>
      Text(t, style: const TextStyle(fontFamily: _font, fontSize: _fs));

  Widget _dash(String value, {int flex = 1, int maxLines = 1}) =>
      Expanded(flex: flex, child: _DashField(value: value, maxLines: maxLines));
}

/// The name/father/gender + age/occupation/address block without an index (the
/// "seized from" person). Reuses [SeizureFormView]'s helpers.
class _Unindexed extends StatelessWidget {
  const _Unindexed(this.view, this.prefix);
  final SeizureFormView view;
  final String prefix;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          view._row([
            view._t('नाव : '),
            view._dash(view.v('${prefix}Name'), flex: 3),
            view._t(' पित्याचे/पतीचे नाव : '),
            view._dash(view.v('${prefix}Father'), flex: 3),
            view._t(' लिंग : '),
            view._dash(view.v('${prefix}Gender'), flex: 1),
          ]),
          view._row([
            view._t('वय : '),
            view._dash(view.v('${prefix}Age'), flex: 1),
            view._t(' व्यवसाय : '),
            view._dash(view.v('${prefix}Occupation'), flex: 2),
            view._t(' पत्ता : '),
            view._dash(view.v('${prefix}Address'), flex: 3),
          ]),
        ],
      );
}

/// A value sitting on a dashed fill-line (matches the printed blanks).
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

/// A thin dashed horizontal rule (the header separator on the printed form).
class _Dashed extends StatelessWidget {
  const _Dashed();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: SizedBox(
        height: 1,
        width: double.infinity,
        child: CustomPaint(painter: _DashPainter()),
      ),
    );
  }
}
