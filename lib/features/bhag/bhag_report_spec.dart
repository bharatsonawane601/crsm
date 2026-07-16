import 'package:flutter/material.dart';

import 'bhag_model.dart';

/// One value column in a report table (everything after अ.क्र. + विवरण).
class BhagValueColumn {
  const BhagValueColumn({
    required this.header,
    required this.value,
    this.color,
    this.width = 46,
  });

  final String header; // may contain '\n' for stacked labels
  final String Function(BhagRowResult r) value;
  final Color? Function(BhagRowResult r)? color;
  final double width;
}

/// Describes a report shown in the Reports section: its title, its default
/// rows, and its columns (which depend on the chosen period).
class BhagReportSpec {
  const BhagReportSpec({
    required this.id,
    required this.titleKey,
    required this.defaults,
    required this.columns,
  });

  final String id;
  final String titleKey;
  final List<BhagRow> Function() defaults;
  final List<BhagValueColumn> Function(BhagPeriod period) columns;
}

const _rose = Color(0xFFB00020); // crime rose
const _green = Color(0xFF1E7E34); // crime fell

/// Detection percentage उघड ÷ दाखल (— when nothing registered).
String _pct(int d, int u) => d == 0 ? '—' : '${(u / d * 100).round()}%';

// ---------------------------------------------------------------------------
// भाग १ ते ५ — month(A) vs month(B), YTD(A) vs YTD(B), + सन(A). घट/वाढ = A − B
// (negative ⇒ crime rose). No percentage columns.
// ---------------------------------------------------------------------------
List<BhagValueColumn> bhag15Columns(BhagPeriod p) {
  final mon = kMonthsMr[p.month];
  final a = p.yearA, b = p.yearB;
  Color? gv(BhagRowResult r, int v) => v < 0 ? _rose : (v > 0 ? _green : null);
  return [
    BhagValueColumn(header: '$mon $a\nदाखल', value: (r) => '${r.cell('mAd')}'),
    BhagValueColumn(header: '$mon $a\nउघड', value: (r) => '${r.cell('mAu')}'),
    BhagValueColumn(header: '$mon $b\nदाखल', value: (r) => '${r.cell('mBd')}'),
    BhagValueColumn(header: '$mon $b\nउघड', value: (r) => '${r.cell('mBu')}'),
    BhagValueColumn(
        header: 'घट/वाढ',
        value: (r) => '${r.cell('mAd') - r.cell('mBd')}',
        color: (r) => gv(r, r.cell('mAd') - r.cell('mBd'))),
    BhagValueColumn(header: '$a पावेतो\nदाखल', value: (r) => '${r.cell('yAd')}'),
    BhagValueColumn(header: '$a पावेतो\nउघड', value: (r) => '${r.cell('yAu')}'),
    BhagValueColumn(header: '$b पावेतो\nदाखल', value: (r) => '${r.cell('yBd')}'),
    BhagValueColumn(header: '$b पावेतो\nउघड', value: (r) => '${r.cell('yBu')}'),
    BhagValueColumn(
        header: 'घट/वाढ',
        value: (r) => '${r.cell('yAd') - r.cell('yBd')}',
        color: (r) => gv(r, r.cell('yAd') - r.cell('yBd'))),
    BhagValueColumn(header: 'सन $a\nदाखल', value: (r) => '${r.cell('sAd')}'),
    BhagValueColumn(header: 'सन $a\nउघड', value: (r) => '${r.cell('sAu')}'),
  ];
}

// ---------------------------------------------------------------------------
// भाग ६ — previous-year vs current-year (month + YTD), with a टक्केवारी column
// after each दाखल/उघड pair. घट/वाढ = current − previous (positive ⇒ crime rose).
// No सन column.
// ---------------------------------------------------------------------------
List<BhagValueColumn> bhag6Columns(BhagPeriod p) {
  final a = p.yearA, b = p.yearB; // A = previous (मागील), B = current (चालु)
  // For भाग ६, a rise (positive) is shown rose, a fall (negative) green.
  Color? gv(int v) => v > 0 ? _rose : (v < 0 ? _green : null);
  return [
    BhagValueColumn(header: 'मागील वर्ष $a\nचालु महिना\nदाखल', width: 52, value: (r) => '${r.cell('mAd')}'),
    BhagValueColumn(header: 'उघड', value: (r) => '${r.cell('mAu')}'),
    BhagValueColumn(header: 'टक्के\nवारी', value: (r) => _pct(r.cell('mAd'), r.cell('mAu'))),
    BhagValueColumn(header: 'चालु वर्ष $b\nचालु महिना\nदाखल', width: 52, value: (r) => '${r.cell('mBd')}'),
    BhagValueColumn(header: 'उघड', value: (r) => '${r.cell('mBu')}'),
    BhagValueColumn(header: 'टक्के\nवारी', value: (r) => _pct(r.cell('mBd'), r.cell('mBu'))),
    BhagValueColumn(
        header: 'घट/\nवाढ',
        value: (r) => '${r.cell('mBd') - r.cell('mAd')}',
        color: (r) => gv(r.cell('mBd') - r.cell('mAd'))),
    BhagValueColumn(header: 'मागील वर्ष $a\nआतापावेतो\nदाखल', width: 52, value: (r) => '${r.cell('yAd')}'),
    BhagValueColumn(header: 'उघड', value: (r) => '${r.cell('yAu')}'),
    BhagValueColumn(header: 'टक्के\nवारी', value: (r) => _pct(r.cell('yAd'), r.cell('yAu'))),
    BhagValueColumn(header: 'चालु वर्ष $b\nआतापावेतो\nदाखल', width: 52, value: (r) => '${r.cell('yBd')}'),
    BhagValueColumn(header: 'उघड', value: (r) => '${r.cell('yBu')}'),
    BhagValueColumn(header: 'टक्के\nवारी', value: (r) => _pct(r.cell('yBd'), r.cell('yBu'))),
    BhagValueColumn(
        header: 'घट/\nवाढ',
        value: (r) => '${r.cell('yBd') - r.cell('yAd')}',
        color: (r) => gv(r.cell('yBd') - r.cell('yAd'))),
  ];
}

final BhagReportSpec bhag15Spec = BhagReportSpec(
  id: 'bhag15',
  titleKey: 'bhag.title',
  defaults: defaultBhagRows,
  columns: bhag15Columns,
);

final BhagReportSpec bhag6Spec = BhagReportSpec(
  id: 'bhag6',
  titleKey: 'bhag6.title',
  defaults: emptyBhagRows,
  columns: bhag6Columns,
);

final Map<String, BhagReportSpec> kBhagSpecs = {
  bhag15Spec.id: bhag15Spec,
  bhag6Spec.id: bhag6Spec,
};
