import '../analyzer/analytics_model.dart';
import '../crime_entry/data/crime_types_data.dart';
import 'station_report_model.dart' show StationReportPeriod;

/// Report id for the station-wise recovered-property (मुद्देमाल) return.
const String kRecoveredReportId = 'recovered';

/// The theft category label all tracked crimes belong to.
const String kTheftCategory = 'Theft / चोरी';

/// The four fixed property columns of the recovered-property report. Each shows
/// a संख्या (count) and किमंत (value) pair.
enum RecoveredCol { twoWheeler, fourWheeler, jewellery, other }

const List<RecoveredCol> kRecoveredCols = RecoveredCol.values;

/// Marathi header for a column.
String recoveredColMr(RecoveredCol c) => switch (c) {
      RecoveredCol.twoWheeler => 'दोन चाकी वाहने',
      RecoveredCol.fourWheeler => 'चार चाकी वाहने',
      RecoveredCol.jewellery => 'दागिने',
      RecoveredCol.other => 'इतर',
    };

/// The editable theft-type sets for the three explicit columns. इतर is derived
/// as "every other theft crime", so it needs no set.
class RecoveredMapping {
  const RecoveredMapping({
    required this.twoWheeler,
    required this.fourWheeler,
    required this.jewellery,
  });

  final Set<String> twoWheeler;
  final Set<String> fourWheeler;
  final Set<String> jewellery;

  Set<String> forCol(RecoveredCol c) => switch (c) {
        RecoveredCol.twoWheeler => twoWheeler,
        RecoveredCol.fourWheeler => fourWheeler,
        RecoveredCol.jewellery => jewellery,
        RecoveredCol.other => const {},
      };
}

/// Default theft-type mapping. Jewellery has no theft sub-type in the catalogue,
/// so it starts empty (filled manually / via overrides).
RecoveredMapping defaultRecoveredMapping() => const RecoveredMapping(
      twoWheeler: {'Two-Wheeler Theft / दुचाकी चोरी'},
      fourWheeler: {'Four-Wheeler Theft / चारचाकी चोरी'},
      jewellery: {},
    );

/// How stations are grouped into sub-divisions (सपोआ) for the subtotal rows.
/// Built by the portal from the scoped org tree so the report stays data-source
/// agnostic. Empty grouping => a single flat group with no subtotals.
class RecoveredGrouping {
  const RecoveredGrouping({
    this.divisionOrder = const [],
    this.stationDivision = const {},
    this.stationSort = const {},
  });

  /// Sub-division names in display order (e.g. ['सपोआ शहर', 'सपोआ छावणी']).
  final List<String> divisionOrder;

  /// Station name -> its sub-division name.
  final Map<String, String> stationDivision;

  /// Station name -> sort index within its sub-division.
  final Map<String, int> stationSort;

  bool get isEmpty => divisionOrder.isEmpty && stationDivision.isEmpty;
}

/// One संख्या/किमंत pair for a column.
class RecoveredCell {
  const RecoveredCell(this.count, this.value);
  final int count;
  final double value;

  RecoveredCell operator +(RecoveredCell o) =>
      RecoveredCell(count + o.count, value + o.value);

  static const zero = RecoveredCell(0, 0);
}

/// One police-station line with all four column pairs.
class RecoveredStationRow {
  RecoveredStationRow({required this.station, required this.cells});
  final String station;
  final Map<RecoveredCol, RecoveredCell> cells;

  RecoveredCell cell(RecoveredCol c) => cells[c] ?? RecoveredCell.zero;
}

/// A sub-division group (सपोआ …) with its stations and a subtotal.
class RecoveredGroup {
  RecoveredGroup({required this.name, required this.rows});
  final String name;
  final List<RecoveredStationRow> rows;

  RecoveredCell subtotal(RecoveredCol c) =>
      rows.fold(RecoveredCell.zero, (s, r) => s + r.cell(c));
}

/// The whole report: sub-division groups + the grand total.
class RecoveredReportData {
  RecoveredReportData({required this.groups});
  final List<RecoveredGroup> groups;

  RecoveredCell total(RecoveredCol c) =>
      groups.fold(RecoveredCell.zero, (s, g) => s + g.subtotal(c));
}

/// Which of the four columns a theft crime belongs to (इतर = the remainder).
RecoveredCol _colFor(String crimeType, RecoveredMapping m) {
  if (m.twoWheeler.contains(crimeType)) return RecoveredCol.twoWheeler;
  if (m.fourWheeler.contains(crimeType)) return RecoveredCol.fourWheeler;
  if (m.jewellery.contains(crimeType)) return RecoveredCol.jewellery;
  return RecoveredCol.other;
}

/// Builds the recovered-property report from the scope-filtered FIRs. Only theft
/// crimes with recovered value count; संख्या = number of such crimes, किमंत = sum
/// of recovered value. [overrides] replaces any auto cell, keyed
/// "station|colIndex|c" (count) or "station|colIndex|v" (value).
RecoveredReportData computeRecoveredReport({
  required List<AnalyticsRow> firs,
  required RecoveredMapping mapping,
  required RecoveredGrouping grouping,
  required StationReportPeriod period,
  Map<String, num> overrides = const {},
}) {
  // station -> col -> [count, value]
  final acc = <String, Map<RecoveredCol, List<num>>>{};

  for (final r in firs) {
    if (!period.includes(r.dateRegistered)) continue;
    if (crimeCategoryOf(r.crimeType) != kTheftCategory) continue;
    if (r.recoveredValue <= 0) continue; // nothing returned
    final station = (r.station ?? '').trim();
    if (station.isEmpty) continue;
    final col = _colFor(r.crimeType ?? '', mapping);
    final byCol = acc.putIfAbsent(station, () => {});
    final e = byCol.putIfAbsent(col, () => [0, 0.0]);
    e[0] = (e[0] as int) + 1;
    e[1] = e[1] + r.recoveredValue;
  }

  // Every station that has data or an override, so manual-only rows still show.
  final stations = <String>{...acc.keys};
  for (final k in overrides.keys) {
    final station = k.split('|').first;
    if (station.isNotEmpty) stations.add(station);
  }

  RecoveredStationRow rowFor(String station) {
    final byCol = acc[station] ?? const {};
    final cells = <RecoveredCol, RecoveredCell>{};
    for (final c in kRecoveredCols) {
      final raw = byCol[c];
      var count = raw != null ? raw[0].toInt() : 0;
      var value = raw != null ? raw[1].toDouble() : 0.0;
      final oc = overrides['$station|${c.index}|c'];
      final ov = overrides['$station|${c.index}|v'];
      if (oc != null) count = oc.toInt();
      if (ov != null) value = ov.toDouble();
      cells[c] = RecoveredCell(count, value);
    }
    return RecoveredStationRow(station: station, cells: cells);
  }

  // Group by sub-division; keep org order for groups and stations.
  final groups = <RecoveredGroup>[];
  if (grouping.isEmpty) {
    final rows = [
      for (final s in (stations.toList()..sort())) rowFor(s),
    ];
    groups.add(RecoveredGroup(name: '', rows: rows));
    return RecoveredReportData(groups: groups);
  }

  final order = [
    ...grouping.divisionOrder,
    // Any division referenced but not listed, plus the ungrouped bucket.
    ...{
      for (final s in stations)
        grouping.stationDivision[s] ?? 'अवर्गीकृत',
    }.where((d) => !grouping.divisionOrder.contains(d)),
  ];

  for (final div in order) {
    final members = [
      for (final s in stations)
        if ((grouping.stationDivision[s] ?? 'अवर्गीकृत') == div) s,
    ]..sort((a, b) => (grouping.stationSort[a] ?? 1 << 20)
        .compareTo(grouping.stationSort[b] ?? 1 << 20));
    if (members.isEmpty) continue;
    groups.add(RecoveredGroup(name: div, rows: [for (final s in members) rowFor(s)]));
  }

  return RecoveredReportData(groups: groups);
}
