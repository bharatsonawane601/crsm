import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import '../reports/pdf_renderer.dart';
import 'analytics_model.dart';
import 'duo_panels.dart';

/// Renders the Analytics dashboard's numbers to a paginated A4 PDF for CP
/// meetings. Same capture trick as the भाग reports: Flutter draws the document
/// (so Marathi shapes correctly), the PNG is sliced into page strips.
Future<Uint8List> renderAnalyticsPdf(AnalyticsSummary s) async {
  const width = 900.0;

  // Rough content height so the capture canvas fits everything; spare white
  // space is dropped by the slicer.
  double table(int rows) => 34 + 26 + rows * 24.0 + 14;
  final height = 120 + // header
      table(9) + // summary
      s.insights.length * 46.0 +
      table(s.yearRows.length) +
      table(s.monthRows.length) +
      table(7) + // weekdays
      table(8) + // time bands
      table(s.typeRows.length.clamp(0, 15)) +
      table(s.stationRows.length.clamp(0, 15)) +
      table(s.hotDates.length.clamp(0, 10)) +
      200; // safety buffer

  final png = await ScreenshotController().captureFromWidget(
    _AnalyticsDocument(s: s),
    pixelRatio: 2.0,
    targetSize: Size(width, height),
    delay: const Duration(milliseconds: 80),
  );

  const fmt = PdfPageFormat.a4;
  final doc = pw.Document();
  for (final strip in sliceCapturedImage(png, fmt)) {
    final image = pw.MemoryImage(strip);
    doc.addPage(
      pw.Page(
        pageFormat: fmt,
        margin: const pw.EdgeInsets.all(24),
        build: (_) => pw.Align(
          alignment: pw.Alignment.topCenter,
          child: pw.Image(image, fit: pw.BoxFit.fitWidth),
        ),
      ),
    );
  }
  return doc.save();
}

/// The printable page: plain black-on-white tables of every Analytics panel.
class _AnalyticsDocument extends StatelessWidget {
  const _AnalyticsDocument({required this.s});
  final AnalyticsSummary s;

  static const _ink = Color(0xFF000000);
  static const _dim = Color(0xFF444444);
  static const _border = BorderSide(color: _ink, width: 0.7);
  static const _dowKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  TextStyle _st({double size = 13, bool bold = false, Color color = _ink}) =>
      TextStyle(
        fontFamily: 'NotoSansDevanagari',
        fontSize: size,
        fontWeight: bold ? FontWeight.bold : FontWeight.normal,
        color: color,
      );

  Widget _section(String title, List<List<String>> header,
      List<List<String>> rows) {
    Widget cell(String t, {bool head = false, bool first = false}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Text(t,
              style: _st(size: 12.5, bold: head),
              textAlign: first ? TextAlign.left : TextAlign.right),
        );
    TableRow tr(List<String> cells, {bool head = false}) => TableRow(
          decoration:
              head ? const BoxDecoration(color: Color(0xFFEDEDED)) : null,
          children: [
            for (var i = 0; i < cells.length; i++)
              cell(cells[i], head: head, first: i == 0),
          ],
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 14),
        Text(title, style: _st(size: 15, bold: true)),
        const SizedBox(height: 6),
        Table(
          border: const TableBorder(
            top: _border,
            bottom: _border,
            left: _border,
            right: _border,
            horizontalInside: _border,
            verticalInside: _border,
          ),
          columnWidths: const {0: FlexColumnWidth(3)},
          children: [
            for (final h in header) tr(h, head: true),
            for (final r in rows) tr(r),
          ],
        ),
      ],
    );
  }

  List<List<String>> _rateRows(List<RateRow> rows,
      {String Function(String)? label}) =>
      [
        for (final r in rows)
          [
            (label != null ? label(r.label) : r.label) +
                (r.sub != null ? ' (${r.sub})' : ''),
            '${r.total}',
            '${r.detected}',
            '${r.pct}%',
          ],
      ];

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final detected = s.statusCounts['detected'] ?? 0;
    final undetected = s.total - detected;
    final pct = s.total == 0 ? 0 : (detected * 100 / s.total).round();
    final rateHead = [
      ['', 'analyzer.pdf.total'.tr(), 'analyzer.pdf.detected'.tr(), '%'],
    ];

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text('analyzer.pdf.title'.tr(),
                  style: _st(size: 20, bold: true)),
            ),
            Center(
              child: Text(
                'analyzer.pdf.printed'.tr(namedArgs: {
                  'when': '${now.day.toString().padLeft(2, '0')}-'
                      '${now.month.toString().padLeft(2, '0')}-${now.year}',
                }),
                style: _st(size: 11.5, color: _dim),
              ),
            ),
            _section('analyzer.pdf.summary'.tr(), const [], [
              ['analyzer.kpi.total'.tr(), '${s.total}'],
              ['analyzer.pdf.thisYear'.tr(), '${s.thisYear}'],
              ['analyzer.pdf.detected'.tr(), '$detected'],
              ['analyzer.pdf.undetected'.tr(), '$undetected'],
              ['analyzer.pdf.detectionRate'.tr(), '$pct%'],
              ['analyzer.kpi.arrested'.tr(), '${s.arrested}'],
              ['analyzer.kpi.wanted'.tr(), '${s.wanted}'],
              ['analyzer.pdf.lost'.tr(), inrFull(s.lostValue)],
              ['analyzer.pdf.recovered'.tr(), inrFull(s.recoveredValue)],
            ]),
            if (s.insights.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text('analyzer.pdf.insights'.tr(),
                  style: _st(size: 15, bold: true)),
              const SizedBox(height: 4),
              for (final ins in s.insights)
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    '${ins.icon} '
                    '${'analyzer.ins.${ins.key}Body'.tr(namedArgs: {
                          ...ins.args,
                          if (ins.dow != null)
                            'day':
                                'analyzer.dowFull.${_dowKeys[ins.dow!]}'.tr(),
                        })}',
                    style: _st(size: 12),
                  ),
                ),
            ],
            _section('analyzer.pdf.byYear'.tr(), rateHead,
                _rateRows(s.yearRows)),
            _section('analyzer.pdf.byMonth'.tr(), rateHead,
                _rateRows(s.monthRows)),
            _section(
              'analyzer.pdf.byWeekday'.tr(),
              rateHead,
              _rateRows(s.weekdayRows,
                  label: (k) => 'analyzer.dowFull.$k'.tr()),
            ),
            _section('analyzer.pdf.byTime'.tr(), const [], [
              for (var i = 0; i < kHourBandLabels.length; i++)
                [
                  kHourBandLabels[i],
                  '${s.hourBandCounts[i]}',
                  s.timedTotal == 0
                      ? '—'
                      : '${(s.hourBandCounts[i] * 100 / s.timedTotal).round()}%',
                ],
            ]),
            _section('analyzer.pdf.byType'.tr(), rateHead,
                _rateRows(s.typeRows.take(15).toList())),
            if (s.stationRows.length > 1)
              _section('analyzer.pdf.byStation'.tr(), rateHead,
                  _rateRows(s.stationRows.take(15).toList())),
            if (s.hotDates.isNotEmpty)
              _section('analyzer.pdf.hotDates'.tr(), const [], [
                for (final e in s.hotDates.take(10)) [e.key, '${e.value}'],
              ]),
          ],
        ),
      ),
    );
  }
}
