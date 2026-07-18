import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';

import 'models/report_template.dart';

/// Print/PDF text size. Because the report is captured as an image and fit to
/// the page width, a *larger* font is achieved by capturing on a *narrower*
/// canvas (so it scales up more on the page), and vice-versa.
enum ReportFontSize { small, normal, large }

/// Print/PDF page + sizing options chosen by the user before printing/saving.
class ReportPdfOptions {
  const ReportPdfOptions({
    this.fontSize = ReportFontSize.normal,
    this.pageSize, // 'A4' | 'Letter' | 'Legal'; null = template default
    this.landscape = false,
  });

  final ReportFontSize fontSize;
  final String? pageSize;
  final bool landscape;

  double get _captureScale => switch (fontSize) {
        ReportFontSize.small => 0.88,
        ReportFontSize.normal => 1.0,
        ReportFontSize.large => 1.18,
      };
}

PdfPageFormat _pageFormat(String size, bool landscape) {
  final base = switch (size.toLowerCase()) {
    'letter' => PdfPageFormat.letter,
    'legal' => PdfPageFormat.legal,
    _ => PdfPageFormat.a4,
  };
  return landscape ? base.landscape : base;
}

/// Renders a [RenderedReport] to PDF with **correct Marathi**.
///
/// The pure-Dart `pdf` package can't shape Devanagari (matras render in the
/// wrong order). So instead we render the report with Flutter's own text engine
/// — which shapes Devanagari correctly — capture it to a PNG, and embed that
/// image as the PDF page.
Future<Uint8List> renderReportPdf(
  RenderedReport report, {
  ReportPdfOptions options = const ReportPdfOptions(),
}) async {
  // Narrower canvas for a larger on-page font, wider for a smaller one.
  final width = 820.0 / options._captureScale;
  // Size the capture canvas to the actual content so a long row (e.g. a big
  // stolen-property list) never overflows/clips. We over-estimate slightly;
  // any spare space is just trimmed white that the slicer drops.
  final contentColW = width - 48; // _ReportDocument padding all(24)
  final flexAvail = contentColW - 44; // minus the fixed अ.क्र. column
  final labelColW = flexAvail * 2 / 6;
  final valueColW = flexAvail * 4 / 6;
  var bodyHeight = 0.0;
  for (final r in report.rows) {
    bodyHeight += _estimateRowHeight(
        r.label, r.value, labelColW, valueColW);
  }
  // title + spacing + header row + paddings + safety buffer.
  final height = 60.0 + 18.0 + 42.0 + bodyHeight + 48.0 + 80.0;

  final png = await ScreenshotController().captureFromWidget(
    _ReportDocument(report: report),
    pixelRatio: 2.0,
    targetSize: Size(width, height),
    delay: const Duration(milliseconds: 60),
  );

  final pageFormat =
      _pageFormat(options.pageSize ?? report.pageSize, options.landscape);
  final doc = pw.Document();

  for (final strip in _sliceToPages(png, pageFormat)) {
    final image = pw.MemoryImage(strip);
    doc.addPage(
      pw.Page(
        pageFormat: pageFormat,
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

/// Estimates a row's rendered height (in logical px) from the longest of its
/// label/value text, so the capture canvas is tall enough to hold everything.
/// Deliberately over-estimates (wide char width) to guarantee no overflow.
double _estimateRowHeight(
    String label, String value, double labelW, double valueW) {
  int lines(String text, double colW) {
    final perLine = ((colW - 16) / 9).floor();
    final cap = perLine < 1 ? 1 : perLine;
    var total = 0;
    for (final seg in text.split('\n')) {
      total += seg.isEmpty ? 1 : (seg.length / cap).ceil();
    }
    return total < 1 ? 1 : total;
  }

  final l = lines(label, labelW);
  final v = lines(value, valueW);
  final maxLines = l > v ? l : v;
  return maxLines * 22.0 + 14.0; // line height + cell padding
}

/// Slices a tall captured report image into page-sized PNG strips so the PDF
/// paginates instead of cramming everything onto one page. Cuts are snapped to
/// a whitespace gap so a line of text is never sliced through.
/// Test hook for [_sliceToPages] (the PDF capture path can't run headless).
@visibleForTesting
List<Uint8List> sliceReportImageForTest(Uint8List png, PdfPageFormat fmt) =>
    _sliceToPages(png, fmt);

/// Public slicer for other capture-based PDFs (e.g. the Analytics export):
/// same whitespace-snapped pagination as the report renderer.
List<Uint8List> sliceCapturedImage(Uint8List png, PdfPageFormat fmt) =>
    _sliceToPages(png, fmt);

List<Uint8List> _sliceToPages(Uint8List png, PdfPageFormat fmt) {
  final full = img.decodePng(png);
  if (full == null) return [png];

  // Pixels of image height that fit on one page once the image is fit to the
  // page's printable width (page minus the 24pt margins on each side).
  final availW = fmt.width - 48;
  final availH = fmt.height - 48;
  final pagePx = (full.width * (availH / availW)).floor();
  if (pagePx <= 0 || full.height <= pagePx) return [png];

  final strips = <Uint8List>[];
  var y = 0;
  while (y < full.height) {
    var end = y + pagePx;
    if (end >= full.height) {
      end = full.height;
    } else {
      // Snap the cut up to the nearest whitespace gap (no glyphs sliced).
      end = _snapToWhitespace(full, end, y + (pagePx * 0.55).floor());
    }
    final h = end - y;
    final strip = img.copyCrop(full, x: 0, y: y, width: full.width, height: h);
    if (!_isBlank(strip)) strips.add(img.encodePng(strip));
    y = end;
  }
  return strips.isEmpty ? [png] : strips;
}

/// Finds a mostly-white horizontal line at or above [target] (down to [minY])
/// to cut on, so text lines aren't split across pages. Vertical table borders
/// are ignored (they're dark on every row). Falls back to [target].
int _snapToWhitespace(img.Image im, int target, int minY) {
  final floor = minY < 0 ? 0 : minY;
  for (var y = target; y > floor; y--) {
    if (_isLightRow(im, y)) return y;
  }
  return target;
}

bool _isLightRow(img.Image im, int y) {
  var dark = 0;
  var samples = 0;
  for (var x = 0; x < im.width; x += 4) {
    final px = im.getPixel(x, y);
    final lum = (px.r + px.g + px.b) / 3;
    if (lum < 170) dark++;
    samples++;
  }
  // Allow a few dark hits for the thin vertical column borders.
  return samples == 0 || dark / samples < 0.06;
}

bool _isBlank(img.Image im) {
  var dark = 0;
  var samples = 0;
  for (var y = 0; y < im.height; y += 6) {
    for (var x = 0; x < im.width; x += 6) {
      final px = im.getPixel(x, y);
      final lum = (px.r + px.g + px.b) / 3;
      if (lum < 170) dark++;
      samples++;
    }
  }
  return samples == 0 || dark / samples < 0.004;
}

/// The on-page report, rendered by Flutter (so Marathi shapes correctly).
class _ReportDocument extends StatelessWidget {
  const _ReportDocument({required this.report});
  final RenderedReport report;

  static const _border = BorderSide(color: Color(0xFF000000), width: 0.7);

  TableRow _row(String sr, String label, String value, {bool header = false}) {
    final style = TextStyle(
      fontFamily: 'NotoSansDevanagari',
      fontSize: 14,
      color: const Color(0xFF000000),
      fontWeight: header ? FontWeight.bold : FontWeight.normal,
    );
    Widget cell(String t, {TextAlign align = TextAlign.left}) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Text(t, style: style, textAlign: align),
        );
    return TableRow(
      decoration: header
          ? const BoxDecoration(color: Color(0xFFE8EEF6))
          : null,
      children: [
        cell(sr, align: TextAlign.center),
        cell(label),
        cell(value),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                report.header,
                style: const TextStyle(
                  fontFamily: 'NotoSansDevanagari',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Table(
              border: const TableBorder(
                top: _border,
                bottom: _border,
                left: _border,
                right: _border,
                horizontalInside: _border,
                verticalInside: _border,
              ),
              columnWidths: const {
                0: FixedColumnWidth(44),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(4),
              },
              children: [
                _row('अ.क्र.', 'विवरण', 'गुन्हयाची माहिती', header: true),
                for (final r in report.rows)
                  _row(r.sr?.toString() ?? '', r.label, r.value),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
