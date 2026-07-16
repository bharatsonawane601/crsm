import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../shared/widgets/native_edit_button.dart';
import '../analyzer/analytics_model.dart';
import '../analyzer/analytics_repository.dart';
import '../crime_entry/data/crime_types_data.dart';
import 'bhag_model.dart';
import 'bhag_pdf.dart';
import 'bhag_providers.dart';
import 'bhag_report_spec.dart';
import 'bhag_view.dart';

/// Station-app screen for a report (भाग १ ते ५, भाग ६, …).
class BhagScreen extends ConsumerWidget {
  const BhagScreen({super.key, required this.spec});
  final BhagReportSpec spec;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(spec.titleKey.tr())),
      body: BhagReport(spec: spec, firsAsync: ref.watch(analyticsRowsProvider)),
    );
  }
}

/// The full report body — controls, editable table, export. Reused by the
/// station screen and the officer portal (each feeds its own data source).
class BhagReport extends ConsumerStatefulWidget {
  const BhagReport({super.key, required this.spec, required this.firsAsync});
  final BhagReportSpec spec;
  final AsyncValue<List<AnalyticsRow>> firsAsync;

  @override
  ConsumerState<BhagReport> createState() => _BhagReportState();
}

class _BhagReportState extends ConsumerState<BhagReport> {
  @override
  void initState() {
    super.initState();
    // Seed this report's rows with its defaults the first time it opens.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(bhagConfigsProvider.notifier)
          .seedIfAbsent(widget.spec.id, widget.spec.defaults());
    });
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    final config = ref.watch(bhagConfigsProvider)[spec.id] ?? spec.defaults();
    final period = ref.watch(bhagPeriodProvider);
    final overridesAll = ref.watch(bhagOverridesProvider);

    return widget.firsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('portal.error'.tr())),
      data: (firs) {
        final data = computeBhag(
          firs: firs,
          config: config,
          period: period,
          overrides: overridesForPeriod(overridesAll, spec.id, period),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Controls(spec: spec, period: period),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: BhagTableView(
                    data: data,
                    period: period,
                    columns: spec.columns(period),
                    titleKey: spec.titleKey.tr(),
                    editable: true,
                    onEdit: (row) => _editRow(row, data, period),
                    onDelete: (row) => _deleteRow(row),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteRow(BhagRow row) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content:
            Text('bhag.deleteRow'.tr(namedArgs: {'name': rowLabel(row)})),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('common.cancel'.tr())),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('common.delete'.tr())),
        ],
      ),
    );
    if (ok == true) {
      ref.read(bhagConfigsProvider.notifier).removeRow(widget.spec.id, row.id);
    }
  }

  Future<void> _editRow(
      BhagRow row, BhagTableData data, BhagPeriod period) async {
    var result = BhagRowResult(row);
    for (final g in data.groups) {
      if (g.parentEditableRow?.id == row.id) result = g.parent;
      for (final s in g.subs) {
        if (s.row.id == row.id) result = s;
      }
    }
    await showDialog<void>(
      context: context,
      builder: (_) => _EditRowDialog(
          reportId: widget.spec.id, row: row, result: result, period: period),
    );
  }
}

/// The top control bar: month + two year pickers, add rows, reset, export.
class _Controls extends ConsumerWidget {
  const _Controls({required this.spec, required this.period});
  final BhagReportSpec spec;
  final BhagPeriod period;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now().year;
    final years = [for (var y = now; y >= now - 8; y--) y];
    final p = ref.read(bhagPeriodProvider.notifier);

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
          _labelled('bhag.yearA'.tr(),
              DropdownButton<int>(
                value: years.contains(period.yearA) ? period.yearA : years.last,
                items: [
                  for (final y in years)
                    DropdownMenuItem(value: y, child: Text('$y')),
                ],
                onChanged: (y) => y == null ? null : p.setYearA(y),
              )),
          _labelled('bhag.yearB'.tr(),
              DropdownButton<int>(
                value:
                    years.contains(period.yearB) ? period.yearB : years.first,
                items: [
                  for (final y in years)
                    DropdownMenuItem(value: y, child: Text('$y')),
                ],
                onChanged: (y) => y == null ? null : p.setYearB(y),
              )),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: Text('bhag.addRow'.tr()),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final t = await showBhagCrimeTypePicker(context);
              if (t != null && t.isNotEmpty) {
                final added =
                    ref.read(bhagConfigsProvider.notifier).addSingle(spec.id, t);
                if (!added) {
                  messenger.showSnackBar(SnackBar(
                      content: Text('bhag.alreadyAdded'
                          .tr(namedArgs: {'name': crimeTypeMarathi(t)}))));
                }
              }
            },
          ),
          OutlinedButton.icon(
            icon: const Icon(Icons.playlist_add),
            label: Text('bhag.addCombined'.tr()),
            onPressed: () async {
              final res = await showCombinedRowDialog(context);
              if (res != null && res.$2.isNotEmpty) {
                ref
                    .read(bhagConfigsProvider.notifier)
                    .addCombined(spec.id, res.$1, res.$2);
              }
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.restart_alt),
            label: Text('bhag.resetRows'.tr()),
            onPressed: () => ref
                .read(bhagConfigsProvider.notifier)
                .resetToDefault(spec.id, spec.defaults()),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.picture_as_pdf),
            label: Text('bhag.exportPdf'.tr()),
            onPressed: () => _exportPdf(context, ref),
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

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    final firs = ref.read(analyticsRowsProvider).value ?? const [];
    final data = computeBhag(
      firs: firs,
      config: ref.read(bhagConfigsProvider)[spec.id] ?? spec.defaults(),
      period: period,
      overrides:
          overridesForPeriod(ref.read(bhagOverridesProvider), spec.id, period),
    );
    final bytes = await renderBhagPdf(
      data: data,
      period: period,
      columns: spec.columns(period),
      title: spec.titleKey.tr(),
    );
    await Printing.layoutPdf(onLayout: (_) async => bytes, name: spec.id);
  }
}

/// Per-row edit dialog: override any of the ten value cells, or reset to auto.
class _EditRowDialog extends ConsumerStatefulWidget {
  const _EditRowDialog(
      {required this.reportId,
      required this.row,
      required this.result,
      required this.period});
  final String reportId;
  final BhagRow row;
  final BhagRowResult result;
  final BhagPeriod period;

  @override
  ConsumerState<_EditRowDialog> createState() => _EditRowDialogState();
}

class _EditRowDialogState extends ConsumerState<_EditRowDialog> {
  late final Map<String, TextEditingController> _c = {
    for (final k in kBhagCellKeys)
      k: TextEditingController(text: '${widget.result.cell(k)}'),
  };

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Widget _num(String key, String label) => SizedBox(
        width: 120,
        child: TextField(
          controller: _c[key],
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: label, isDense: true),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final mon = kMonthsMr[widget.period.month];
    final a = widget.period.yearA, b = widget.period.yearB;
    return AlertDialog(
      title: Text(rowLabel(widget.row)),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _num('mAd', '$mon $a दाखल'),
            _num('mAu', '$mon $a उघड'),
            _num('mBd', '$mon $b दाखल'),
            _num('mBu', '$mon $b उघड'),
            _num('yAd', '$a पावेतो दाखल'),
            _num('yAu', '$a पावेतो उघड'),
            _num('yBd', '$b पावेतो दाखल'),
            _num('yBu', '$b पावेतो उघड'),
            _num('sAd', 'सन $a दाखल'),
            _num('sAu', 'सन $a उघड'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final n = ref.read(bhagOverridesProvider.notifier);
            for (final k in kBhagCellKeys) {
              n.setValue(widget.reportId, widget.period.signature,
                  widget.row.id, k, null);
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
            final n = ref.read(bhagOverridesProvider.notifier);
            for (final k in kBhagCellKeys) {
              n.setValue(widget.reportId, widget.period.signature,
                  widget.row.id, k, int.tryParse(_c[k]!.text.trim()) ?? 0);
            }
            Navigator.pop(context);
          },
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }
}

/// Single-type picker: choose a whole category or a specific sub-type.
Future<String?> showBhagCrimeTypePicker(BuildContext context) {
  return showDialog<String>(
      context: context, builder: (_) => const _BhagTypePicker());
}

class _BhagTypePicker extends StatefulWidget {
  const _BhagTypePicker();
  @override
  State<_BhagTypePicker> createState() => _BhagTypePickerState();
}

class _BhagTypePickerState extends State<_BhagTypePicker> {
  String _q = '';
  bool _m(String s) => s.toLowerCase().contains(_q.trim().toLowerCase());

  @override
  Widget build(BuildContext context) {
    final searching = _q.trim().isNotEmpty;
    return AlertDialog(
      title: Text('bhag.pickType'.tr()),
      content: SizedBox(
        width: 480,
        height: 520,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: 'crime.info.crimeTypeSearch'.tr(),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  for (final c in kCrimeCategories)
                    if (!searching ||
                        _m(c.en) ||
                        _m(c.mr) ||
                        c.subtypes.any((s) => _m(s.en) || _m(s.mr)))
                      ExpansionTile(
                        key: PageStorageKey(c.en),
                        initiallyExpanded: searching,
                        title: Text(c.label,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        trailing: TextButton(
                          onPressed: () => Navigator.pop(context, c.label),
                          child: Text('bhag.wholeGroup'.tr()),
                        ),
                        children: [
                          for (final s in c.subtypes)
                            if (!searching ||
                                _m(c.en) ||
                                _m(c.mr) ||
                                _m(s.en) ||
                                _m(s.mr))
                              ListTile(
                                dense: true,
                                title: Text(s.label),
                                onTap: () => Navigator.pop(context, s.label),
                              ),
                        ],
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr())),
      ],
    );
  }
}

/// Combined-row builder for an "इतर"-style row: a name + several crime types.
/// Returns (name, selectedCrimeTypes) or null.
Future<(String, List<String>)?> showCombinedRowDialog(BuildContext context) {
  return showDialog<(String, List<String>)>(
      context: context, builder: (_) => const _CombinedRowDialog());
}

class _CombinedRowDialog extends StatefulWidget {
  const _CombinedRowDialog();
  @override
  State<_CombinedRowDialog> createState() => _CombinedRowDialogState();
}

class _CombinedRowDialogState extends State<_CombinedRowDialog> {
  final _name = TextEditingController();
  final _selected = <String>{};
  String _q = '';
  bool _m(String s) => s.toLowerCase().contains(_q.trim().toLowerCase());

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('bhag.addCombined'.tr()),
      content: SizedBox(
        width: 480,
        height: 560,
        child: Column(
          children: [
            TextField(
              controller: _name,
              decoration: InputDecoration(
                labelText: 'bhag.combinedName'.tr(),
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: NativeEditButton.maybe(_name,
                    title: 'bhag.combinedName'.tr()),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              onChanged: (v) => setState(() => _q = v),
              decoration: InputDecoration(
                hintText: 'crime.info.crimeTypeSearch'.tr(),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: [
                  for (final c in kCrimeCategories)
                    if (_q.isEmpty || _m(c.en) || _m(c.mr))
                      CheckboxListTile(
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        value: _selected.contains(c.label),
                        title: Text(c.label),
                        onChanged: (v) => setState(() {
                          if (v == true) {
                            _selected.add(c.label);
                          } else {
                            _selected.remove(c.label);
                          }
                        }),
                      ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('bhag.combinedCount'
                  .tr(namedArgs: {'n': '${_selected.length}'})),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr())),
        FilledButton(
          onPressed: _selected.isEmpty
              ? null
              : () {
                  final name = _name.text.trim();
                  Navigator.pop(context, (name, _selected.toList()));
                },
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }
}
