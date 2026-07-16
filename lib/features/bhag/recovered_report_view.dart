import 'package:flutter/material.dart';

import 'bhag_model.dart' show kMonthsMr;
import 'recovered_report_model.dart';
import 'station_report_model.dart';

/// The परिमंडळ station-wise recovered-property (मुद्देमाल) return: for each police
/// station, संख्या + किमंत across four property columns (2-wheeler, 4-wheeler,
/// jewellery, other), grouped by sub-division (सपोआ) with *** subtotal rows and a
/// grand एकूण. Rendered on screen and captured to PNG for the PDF.
class RecoveredReportView extends StatelessWidget {
  const RecoveredReportView({
    super.key,
    required this.data,
    required this.period,
    this.editable = false,
    this.onEdit,
    this.forCapture = false,
  });

  final RecoveredReportData data;
  final StationReportPeriod period;
  final bool editable;
  final void Function(String station)? onEdit;
  final bool forCapture;

  static const _b = BorderSide(color: Color(0xFF6B7280), width: 0.7);
  static const _wSr = 34.0;
  static const _wName = 120.0;
  static const _wNum = 68.0;
  static const _wEdit = 40.0;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'परिमंडळ मध्ये माहे $_periodLabel पोलीस स्टेशन निहाय परत केलेल्या मुद्देमालाची माहिती.',
            style: const TextStyle(
              fontFamily: 'NotoSansDevanagari',
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xFF7A1F1F),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: const BoxDecoration(border: Border(top: _b, left: _b)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(),
                ..._bodyRows(),
                _totalRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Three-tier header: title over 4 category names over संख्या/किमंत pairs.
  Widget _header() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _cell(_wSr, 'अ.क्रं.', header: true, bg: _headBg),
          _cell(_wName, 'पोलीस स्टेशन', header: true, bg: _headBg),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _cell(_wNum * 8, 'परत केलेल्या मुद्देमालाची संख्या व किमंत',
                  header: true, bg: _headBg),
              Row(
                children: [
                  for (final c in kRecoveredCols)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _cell(_wNum * 2, recoveredColMr(c),
                            header: true, bg: _headBg),
                        Row(children: [
                          _cell(_wNum, 'संख्या', header: true, bg: _headBg),
                          _cell(_wNum, 'किमंत', header: true, bg: _headBg),
                        ]),
                      ],
                    ),
                ],
              ),
            ],
          ),
          if (editable) _cell(_wEdit, '', header: true, bg: _headBg),
        ],
      ),
    );
  }

  static const _headBg = Color(0xFFEDE7D6);
  static const _subBg = Color(0xFFF3F0E6);

  List<Widget> _bodyRows() {
    final rows = <Widget>[];
    var serial = 0;
    for (final g in data.groups) {
      for (final r in g.rows) {
        serial++;
        rows.add(_dataRow(serial, r));
      }
      if (g.name.isNotEmpty) rows.add(_subtotalRow(g));
    }
    return rows;
  }

  Widget _dataRow(int serial, RecoveredStationRow r) {
    return Row(
      children: [
        _cell(_wSr, '$serial'),
        _cell(_wName, r.station, align: TextAlign.left),
        for (final c in kRecoveredCols) ...[
          _cell(_wNum, '${r.cell(c).count}'),
          _cell(_wNum, _money(r.cell(c).value)),
        ],
        if (editable)
          SizedBox(
            width: _wEdit,
            child: IconButton(
              tooltip: 'Edit',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.edit, size: 16),
              onPressed: onEdit == null ? null : () => onEdit!(r.station),
            ),
          ),
      ],
    );
  }

  Widget _subtotalRow(RecoveredGroup g) {
    return Row(
      children: [
        _cell(_wSr, '***', header: true, bg: _subBg),
        _cell(_wName, g.name, align: TextAlign.left, header: true, bg: _subBg),
        for (final c in kRecoveredCols) ...[
          _cell(_wNum, '${g.subtotal(c).count}', header: true, bg: _subBg),
          _cell(_wNum, _money(g.subtotal(c).value), header: true, bg: _subBg),
        ],
        if (editable) _cell(_wEdit, '', header: true, bg: _subBg),
      ],
    );
  }

  Widget _totalRow() {
    return Row(
      children: [
        _cell(_wSr, '', header: true, bg: _headBg),
        _cell(_wName, 'एकूण', align: TextAlign.left, header: true, bg: _headBg),
        for (final c in kRecoveredCols) ...[
          _cell(_wNum, '${data.total(c).count}', header: true, bg: _headBg),
          _cell(_wNum, _money(data.total(c).value), header: true, bg: _headBg),
        ],
        if (editable) _cell(_wEdit, '', header: true, bg: _headBg),
      ],
    );
  }

  String _money(double v) => v == 0 ? '0' : v.round().toString();

  Widget _cell(double w, String text,
      {bool header = false, TextAlign align = TextAlign.center, Color? bg}) {
    return Container(
      width: w,
      constraints: const BoxConstraints(minHeight: 22),
      alignment:
          align == TextAlign.left ? Alignment.centerLeft : Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      decoration:
          BoxDecoration(color: bg, border: const Border(right: _b, bottom: _b)),
      child: Text(text,
          textAlign: align,
          style: TextStyle(
            fontFamily: 'NotoSansDevanagari',
            fontSize: header ? 10 : 10.5,
            fontWeight: header ? FontWeight.bold : FontWeight.normal,
            color: const Color(0xFF111111),
          )),
    );
  }
}
