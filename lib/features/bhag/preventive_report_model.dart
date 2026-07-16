import '../analyzer/analytics_model.dart';
import 'bhag_model.dart' show BhagPeriod;

/// Report id for the प्रतिबंधक कार्यवाही (preventive-action) report.
const String kPreventiveReportId = 'preventive';

/// The five editable base cells; घट/वाढ columns are derived from them.
const List<String> kPrevCells = ['mA', 'mB', 'yA', 'yB', 'sA'];

/// One provision row. A FIR counts into the row when its (free-text) preventive
/// action contains ANY of [patterns] (digits/spacing/case normalised).
class PreventiveRow {
  const PreventiveRow(
      {required this.id, required this.label, required this.patterns});
  final String id;
  final String label;
  final List<String> patterns;

  Map<String, dynamic> toJson() =>
      {'id': id, 'label': label, 'patterns': patterns};

  factory PreventiveRow.fromJson(Map<String, dynamic> j) => PreventiveRow(
        id: (j['id'] ?? '').toString(),
        label: (j['label'] ?? '').toString(),
        patterns: [for (final p in (j['patterns'] as List? ?? [])) p.toString()],
      );
}

/// Computed counts for one row (or the total).
class PreventiveRowResult {
  PreventiveRowResult(this.cells);
  final Map<String, int> cells;

  int cell(String k) => cells[k] ?? 0;
  int get gvMonth => cell('mA') - cell('mB'); // घट/वाढ (month) = A − B
  int get gvYtd => cell('yA') - cell('yB'); // घट/वाढ (पावेतो) = A − B
}

/// The whole table: a result per provision row + the एकूण total.
class PreventiveTableData {
  PreventiveTableData({required this.rows, required this.total});
  final List<(PreventiveRow, PreventiveRowResult)> rows;
  final PreventiveRowResult total;
}

/// The default eight provisions from the sheet, with match patterns.
List<PreventiveRow> defaultPreventiveRows() => const [
      PreventiveRow(id: 'p126', label: '१२६ भा.ना.सु.सं.', patterns: ['126']),
      PreventiveRow(id: 'p128', label: '१२८ भा.ना.सु.सं.', patterns: ['128']),
      PreventiveRow(id: 'p129', label: '१२९ भा.ना.सु.सं.', patterns: ['129']),
      PreventiveRow(id: 'p5557', label: '५५/५७ मुं.पो.का.', patterns: ['55/57', '5557']),
      PreventiveRow(id: 'p124', label: '१२४ मुं.पो.का.', patterns: ['124']),
      PreventiveRow(id: 'p142', label: '१४२ मुं.पो.का.', patterns: ['142']),
      PreventiveRow(id: 'p93', label: '९३ मुं.दा.का.', patterns: ['93']),
      PreventiveRow(id: 'pmpda', label: 'एम.पी.डी.ए.', patterns: ['mpda', 'एमपीडीए', 'पीडीए']),
    ];

const _devToLatin = {
  '०': '0', '१': '1', '२': '2', '३': '3', '४': '4',
  '५': '5', '६': '6', '७': '7', '८': '8', '९': '9',
};

/// Lower-case, strip spaces/dots, and convert Devanagari digits to Latin so a
/// pattern like "126" matches "१२६", "126 BNSS", "कलम 126" alike.
String _norm(String s) {
  final b = StringBuffer();
  for (final ch in s.toLowerCase().split('')) {
    if (ch == ' ' || ch == '.' || ch == '-') continue;
    b.write(_devToLatin[ch] ?? ch);
  }
  return b.toString();
}

bool _matches(PreventiveRow row, String normText) {
  for (final p in row.patterns) {
    final np = _norm(p);
    if (np.isNotEmpty && normText.contains(np)) return true;
  }
  return false;
}

/// Builds the preventive-action table. A record is dated by its preventive date
/// (falling back to registration date). [overrides] replaces any base cell,
/// keyed "rowId|cell".
PreventiveTableData computePreventive({
  required List<AnalyticsRow> firs,
  required List<PreventiveRow> config,
  required BhagPeriod period,
  Map<String, int> overrides = const {},
}) {
  final counts = {for (final r in config) r.id: <String, int>{}};

  for (final f in firs) {
    final action = (f.preventiveAction ?? '').trim();
    if (action.isEmpty) continue;
    final d = f.preventiveDate ?? f.dateRegistered;
    if (d == null) continue;
    final normText = _norm(action);

    final inMonthA = d.year == period.yearA && d.month == period.month;
    final inMonthB = d.year == period.yearB && d.month == period.month;
    final inYtdA = d.year == period.yearA && d.month <= period.month;
    final inYtdB = d.year == period.yearB && d.month <= period.month;
    final inYearA = d.year == period.yearA;
    if (!(inMonthA || inMonthB || inYtdA || inYtdB || inYearA)) continue;

    for (final row in config) {
      if (!_matches(row, normText)) continue;
      final c = counts[row.id]!;
      void inc(String k, bool cond) {
        if (cond) c[k] = (c[k] ?? 0) + 1;
      }

      inc('mA', inMonthA);
      inc('mB', inMonthB);
      inc('yA', inYtdA);
      inc('yB', inYtdB);
      inc('sA', inYearA);
    }
  }

  PreventiveRowResult resultFor(PreventiveRow row) {
    final auto = counts[row.id] ?? const {};
    final cells = <String, int>{};
    for (final k in kPrevCells) {
      cells[k] = overrides['${row.id}|$k'] ?? (auto[k] ?? 0);
    }
    return PreventiveRowResult(cells);
  }

  final rows = [for (final r in config) (r, resultFor(r))];

  final totalCells = <String, int>{for (final k in kPrevCells) k: 0};
  for (final (_, res) in rows) {
    for (final k in kPrevCells) {
      totalCells[k] = totalCells[k]! + res.cell(k);
    }
  }

  return PreventiveTableData(
      rows: rows, total: PreventiveRowResult(totalCells));
}
