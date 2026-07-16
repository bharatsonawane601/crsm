import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../analyzer/analytics_model.dart';
import '../crime_entry/data/crime_types_data.dart';
import 'bhag_model.dart' show kMonthsMr;
import 'recovered_report_model.dart';
import 'recovered_report_pdf.dart';
import 'recovered_report_providers.dart';
import 'recovered_report_view.dart';
import 'station_report_model.dart';

/// The station-wise recovered-property (मुद्देमाल) return. Fed by a data source
/// (the portal passes its scope-filtered rows) plus a [grouping] that assigns
/// stations to sub-divisions (सपोआ) for the subtotal rows.
class RecoveredReport extends ConsumerWidget {
  const RecoveredReport(
      {super.key, required this.firsAsync, required this.grouping});
  final AsyncValue<List<AnalyticsRow>> firsAsync;
  final RecoveredGrouping grouping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapping = ref.watch(recoveredMappingProvider);
    final period = ref.watch(recoveredPeriodProvider);
    final overridesAll = ref.watch(recoveredOverridesProvider);

    return firsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('portal.error'.tr())),
      data: (firs) {
        final data = computeRecoveredReport(
          firs: firs,
          mapping: mapping,
          grouping: grouping,
          period: period,
          overrides: recoveredOverridesForPeriod(overridesAll, period),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Controls(period: period, firs: firs, grouping: grouping),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: RecoveredReportView(
                    data: data,
                    period: period,
                    editable: true,
                    onEdit: (station) => _editStation(context, station, data, period),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editStation(BuildContext context, String station,
      RecoveredReportData data, StationReportPeriod period) {
    RecoveredStationRow? row;
    for (final g in data.groups) {
      for (final r in g.rows) {
        if (r.station == station) row = r;
      }
    }
    if (row == null) return;
    showDialog<void>(
      context: context,
      builder: (_) => _EditCellsDialog(row: row!, period: period),
    );
  }
}

class _Controls extends ConsumerWidget {
  const _Controls(
      {required this.period, required this.firs, required this.grouping});
  final StationReportPeriod period;
  final List<AnalyticsRow> firs;
  final RecoveredGrouping grouping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now().year;
    final years = [for (var y = now; y >= now - 8; y--) y];
    final p = ref.read(recoveredPeriodProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _labelled('bhag.month'.tr(),
              DropdownButton<int>(
                value: period.month,
                items: [
                  for (var m = 1; m <= 12; m++)
                    DropdownMenuItem(value: m, child: Text(kMonthsMr[m])),
                ],
                onChanged: (m) => m == null ? null : p.setMonth(m),
              )),
          _labelled('bhag.yearB'.tr(),
              DropdownButton<int>(
                value: years.contains(period.year) ? period.year : years.first,
                items: [
                  for (final y in years)
                    DropdownMenuItem(value: y, child: Text('$y')),
                ],
                onChanged: (y) => y == null ? null : p.setYear(y),
              )),
          SegmentedButton<StationPeriodMode>(
            segments: [
              ButtonSegment(
                  value: StationPeriodMode.cumulative,
                  label: Text('stationReport.cumulative'.tr())),
              ButtonSegment(
                  value: StationPeriodMode.month,
                  label: Text('stationReport.monthOnly'.tr())),
            ],
            selected: {period.mode},
            onSelectionChanged: (s) => p.setMode(s.first),
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.tune),
            label: Text('recovered.editColumns'.tr()),
            onPressed: () => showDialog<void>(
                context: context, builder: (_) => const _ColumnMappingDialog()),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: Text('bhag.exportPdf'.tr()),
            onPressed: () => _exportPdf(ref),
          ),
        ],
      ),
    );
  }

  Widget _labelled(String label, Widget child) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          child,
        ],
      );

  Future<void> _exportPdf(WidgetRef ref) async {
    final data = computeRecoveredReport(
      firs: firs,
      mapping: ref.read(recoveredMappingProvider),
      grouping: grouping,
      period: period,
      overrides: recoveredOverridesForPeriod(
          ref.read(recoveredOverridesProvider), period),
    );
    final bytes = await renderRecoveredReportPdf(data: data, period: period);
    await Printing.layoutPdf(onLayout: (_) async => bytes, name: kRecoveredReportId);
  }
}

/// The theft sub-type labels — the only crime types offered for the 3 columns.
List<String> _theftTypes() => [
      for (final c in kCrimeCategories)
        if (c.label == kTheftCategory)
          for (final s in c.subtypes) s.label,
    ];

/// Tabs to pick which theft types feed each explicit column (इतर = remainder).
class _ColumnMappingDialog extends ConsumerStatefulWidget {
  const _ColumnMappingDialog();
  @override
  ConsumerState<_ColumnMappingDialog> createState() =>
      _ColumnMappingDialogState();
}

class _ColumnMappingDialogState extends ConsumerState<_ColumnMappingDialog> {
  late Map<RecoveredCol, Set<String>> _sets;
  static const _cols = [
    RecoveredCol.twoWheeler,
    RecoveredCol.fourWheeler,
    RecoveredCol.jewellery,
  ];

  @override
  void initState() {
    super.initState();
    final m = ref.read(recoveredMappingProvider);
    _sets = {for (final c in _cols) c: {...m.forCol(c)}};
  }

  Widget _list(RecoveredCol col) {
    final selected = _sets[col]!;
    return ListView(
      children: [
        for (final t in _theftTypes())
          CheckboxListTile(
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
            value: selected.contains(t),
            title: Text(t),
            onChanged: (v) => setState(() {
              if (v == true) {
                selected.add(t);
              } else {
                selected.remove(t);
              }
            }),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _cols.length,
      child: AlertDialog(
        title: Text('recovered.editColumns'.tr()),
        content: SizedBox(
          width: 480,
          height: 560,
          child: Column(
            children: [
              TabBar(
                isScrollable: true,
                tabs: [for (final c in _cols) Tab(text: recoveredColMr(c))],
              ),
              Expanded(
                child: TabBarView(children: [for (final c in _cols) _list(c)]),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(recoveredMappingProvider.notifier).reset();
              Navigator.pop(context);
            },
            child: Text('bhag.resetRows'.tr()),
          ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('common.cancel'.tr())),
          FilledButton(
            onPressed: () {
              final n = ref.read(recoveredMappingProvider.notifier);
              for (final c in _cols) {
                n.setCol(c, _sets[c]!);
              }
              Navigator.pop(context);
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }
}

/// Per-station override dialog: edit the संख्या + किमंत of all four columns.
class _EditCellsDialog extends ConsumerStatefulWidget {
  const _EditCellsDialog({required this.row, required this.period});
  final RecoveredStationRow row;
  final StationReportPeriod period;

  @override
  ConsumerState<_EditCellsDialog> createState() => _EditCellsDialogState();
}

class _EditCellsDialogState extends ConsumerState<_EditCellsDialog> {
  late final Map<String, TextEditingController> _c = {
    for (final col in kRecoveredCols) ...{
      '${col.index}|c': TextEditingController(text: '${widget.row.cell(col).count}'),
      '${col.index}|v':
          TextEditingController(text: '${widget.row.cell(col).value.round()}'),
    }
  };

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.row.station),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final col in kRecoveredCols)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    SizedBox(
                        width: 120,
                        child: Text(recoveredColMr(col),
                            style: const TextStyle(fontWeight: FontWeight.w600))),
                    Expanded(child: _num('${col.index}|c', 'संख्या')),
                    const SizedBox(width: 8),
                    Expanded(child: _num('${col.index}|v', 'किमंत')),
                  ],
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final n = ref.read(recoveredOverridesProvider.notifier);
            for (final col in kRecoveredCols) {
              n.setValue(widget.period.signature, widget.row.station, col.index, 'c', null);
              n.setValue(widget.period.signature, widget.row.station, col.index, 'v', null);
            }
            Navigator.pop(context);
          },
          child: Text('bhag.resetAuto'.tr()),
        ),
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr())),
        FilledButton(
          onPressed: () {
            final n = ref.read(recoveredOverridesProvider.notifier);
            for (final col in kRecoveredCols) {
              n.setValue(widget.period.signature, widget.row.station, col.index,
                  'c', int.tryParse(_c['${col.index}|c']!.text.trim()) ?? 0);
              n.setValue(widget.period.signature, widget.row.station, col.index,
                  'v', num.tryParse(_c['${col.index}|v']!.text.trim()) ?? 0);
            }
            Navigator.pop(context);
          },
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }

  Widget _num(String key, String label) => TextField(
        controller: _c[key],
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: label, isDense: true),
      );
}
