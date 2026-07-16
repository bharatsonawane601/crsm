import 'package:flutter/material.dart';

import 'bhag_model.dart' show kMonthsMr;
import 'station_report_model.dart';

/// The परिमंडळ station-wise दाखल/उघड sheet: two tables side by side — property
/// (मालमत्तेविरुद्ध) on the left and body (शारीरिकविरुद्ध) on the right. Each row
/// is a police station, sorted by दाखल desc, with an एकूण total row. Used both on
/// screen and captured to PNG for the PDF, so it stays self-contained.
class StationReportView extends StatelessWidget {
  const StationReportView({
    super.key,
    required this.data,
    required this.period,
    required this.title,
    this.forCapture = false,
  });

  final StationReportData data;
  final StationReportPeriod period;
  final String title;
  final bool forCapture;

  static const _b = BorderSide(color: Color(0xFF6B7280), width: 0.7);

  String get _periodLabel {
    final base = '${kMonthsMr[period.month]}-${period.year}';
    return period.mode == StationPeriodMode.cumulative ? '$base अखेर पावेतो' : base;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'NotoSansDevanagari',
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Color(0xFF7A1F1F),
              )),
          const SizedBox(height: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _side(
                heading: 'मालमत्तेविरुध्द',
                banner: const Color(0xFFEDE1CC),
                table: data.property,
              ),
              const SizedBox(width: 18),
              _side(
                heading: 'शरीराविरुध्द',
                banner: const Color(0xFFD3E4EC),
                table: data.body,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Column widths for one side.
  static const _wSr = 34.0;
  static const _wName = 138.0;
  static const _wNum = 54.0;
  double get _sideWidth => _wSr + _wName + _wNum * 2;

  Widget _side({
    required String heading,
    required Color banner,
    required StationSideTable table,
  }) {
    return Container(
      decoration: const BoxDecoration(border: Border(top: _b, left: _b)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Two-line coloured banner: title + दाखल उघड गुन्हे.
          Container(
            width: _sideWidth,
            color: banner,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            decoration: BoxDecoration(color: banner, border: const Border(right: _b, bottom: _b)),
            child: Column(
              children: [
                Text('$heading   $_periodLabel',
                    textAlign: TextAlign.center, style: _txt(header: true, size: 12)),
                const SizedBox(height: 2),
                Text('दाखल उघड गुन्हे',
                    textAlign: TextAlign.center, style: _txt(header: true, size: 12)),
              ],
            ),
          ),
          _header(),
          for (var i = 0; i < table.rows.length; i++)
            _dataRow(i + 1, table.rows[i]),
          _totalRow(table),
        ],
      ),
    );
  }

  /// Two-tier header: अ.क्र. / विवरण span both tiers; एकूण spans दाखल + उघड.
  Widget _header() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _cell(_wSr, 'अ.क्र.', header: true),
          _cell(_wName, 'विवरण', header: true),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _cell(_wNum * 2, 'एकूण', header: true),
              Row(children: [
                _cell(_wNum, 'दाखल', header: true),
                _cell(_wNum, 'उघड', header: true),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dataRow(int serial, StationTally r) {
    return Row(
      children: [
        _cell(_wSr, '$serial'),
        _cell(_wName, r.station, align: TextAlign.left),
        _cell(_wNum, '${r.registered}'),
        _cell(_wNum, '${r.detected}'),
      ],
    );
  }

  Widget _totalRow(StationSideTable t) {
    const bg = Color(0xFFF3F0E6);
    return Row(
      children: [
        _cell(_wSr, '', bg: bg, header: true),
        _cell(_wName, 'एकूण', align: TextAlign.left, bg: bg, header: true),
        _cell(_wNum, '${t.totalRegistered}', bg: bg, header: true),
        _cell(_wNum, '${t.totalDetected}', bg: bg, header: true),
      ],
    );
  }

  Widget _cell(double w, String text,
      {bool header = false, TextAlign align = TextAlign.center, Color? bg}) {
    return Container(
      width: w,
      constraints: const BoxConstraints(minHeight: 22),
      alignment:
          align == TextAlign.left ? Alignment.centerLeft : Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration:
          BoxDecoration(color: bg, border: const Border(right: _b, bottom: _b)),
      child: Text(text, textAlign: align, style: _txt(header: header)),
    );
  }

  TextStyle _txt({bool header = false, double? size, Color? color}) => TextStyle(
        fontFamily: 'NotoSansDevanagari',
        fontSize: size ?? (header ? 11 : 11.5),
        fontWeight: header ? FontWeight.bold : FontWeight.normal,
        color: color ?? const Color(0xFF111111),
      );
}
