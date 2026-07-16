import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../shared/widgets/native_edit_button.dart';
import '../analyzer/analytics_model.dart';
import '../analyzer/analytics_repository.dart';
import 'bhag_model.dart' show BhagPeriod, kMonthsMr;
import 'bhag_providers.dart' show bhagPeriodProvider;
import 'preventive_report_model.dart';
import 'preventive_report_pdf.dart';
import 'preventive_report_providers.dart';
import 'preventive_report_view.dart';

/// Station-app screen for the preventive-action report (fed by the local DB).
class PreventiveStationScreen extends ConsumerWidget {
  const PreventiveStationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('preventive.title'.tr())),
      body: PreventiveReport(firsAsync: ref.watch(analyticsRowsProvider)),
    );
  }
}

/// The प्रतिबंधक कार्यवाही (preventive-action) report. Fed by a data source (the
/// station app passes its own rows; the portal passes scope-filtered rows).
class PreventiveReport extends ConsumerWidget {
  const PreventiveReport({super.key, required this.firsAsync});
  final AsyncValue<List<AnalyticsRow>> firsAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(preventiveConfigProvider);
    final period = ref.watch(bhagPeriodProvider);
    final overridesAll = ref.watch(preventiveOverridesProvider);

    return firsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('portal.error'.tr())),
      data: (firs) {
        final data = computePreventive(
          firs: firs,
          config: config,
          period: period,
          overrides: preventiveOverridesForPeriod(overridesAll, period),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Controls(period: period, firs: firs),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: PreventiveTableView(
                    data: data,
                    period: period,
                    editable: true,
                    onEdit: (row) => _editRow(context, row, data, period),
                    onDelete: (row) => _deleteRow(context, ref, row),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _editRow(BuildContext context, PreventiveRow row,
      PreventiveTableData data, BhagPeriod period) {
    final res = data.rows
        .firstWhere((e) => e.$1.id == row.id,
            orElse: () => (row, PreventiveRowResult({})))
        .$2;
    showDialog<void>(
      context: context,
      builder: (_) => _EditCellsDialog(row: row, result: res, period: period),
    );
  }

  Future<void> _deleteRow(
      BuildContext context, WidgetRef ref, PreventiveRow row) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        content: Text('bhag.deleteRow'.tr(namedArgs: {'name': row.label})),
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
      ref.read(preventiveConfigProvider.notifier).removeRow(row.id);
    }
  }
}

class _Controls extends ConsumerWidget {
  const _Controls({required this.period, required this.firs});
  final BhagPeriod period;
  final List<AnalyticsRow> firs;

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
                value: years.contains(period.yearB) ? period.yearB : years.first,
                items: [
                  for (final y in years)
                    DropdownMenuItem(value: y, child: Text('$y')),
                ],
                onChanged: (y) => y == null ? null : p.setYearB(y),
              )),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: Text('preventive.addRow'.tr()),
            onPressed: () async {
              final res = await showDialog<(String, List<String>)>(
                  context: context, builder: (_) => const _AddRowDialog());
              if (res != null && res.$1.trim().isNotEmpty) {
                ref
                    .read(preventiveConfigProvider.notifier)
                    .addRow(res.$1.trim(), res.$2);
              }
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.restart_alt),
            label: Text('bhag.resetRows'.tr()),
            onPressed: () =>
                ref.read(preventiveConfigProvider.notifier).resetToDefault(),
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
    final data = computePreventive(
      firs: firs,
      config: ref.read(preventiveConfigProvider),
      period: period,
      overrides: preventiveOverridesForPeriod(
          ref.read(preventiveOverridesProvider), period),
    );
    final bytes = await renderPreventivePdf(data: data, period: period);
    await Printing.layoutPdf(
        onLayout: (_) async => bytes, name: kPreventiveReportId);
  }
}

/// Add a custom provision row: a label + optional match keywords.
class _AddRowDialog extends StatefulWidget {
  const _AddRowDialog();
  @override
  State<_AddRowDialog> createState() => _AddRowDialogState();
}

class _AddRowDialogState extends State<_AddRowDialog> {
  final _label = TextEditingController();
  final _patterns = TextEditingController();

  @override
  void dispose() {
    _label.dispose();
    _patterns.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('preventive.addRow'.tr()),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _label,
              decoration: InputDecoration(
                labelText: 'preventive.rowLabel'.tr(),
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: NativeEditButton.maybe(_label,
                    title: 'preventive.rowLabel'.tr()),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _patterns,
              decoration: InputDecoration(
                labelText: 'preventive.rowPatterns'.tr(),
                helperText: 'preventive.rowPatternsHint'.tr(),
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: NativeEditButton.maybe(_patterns,
                    title: 'preventive.rowPatterns'.tr()),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr())),
        FilledButton(
          onPressed: () {
            final patterns = _patterns.text
                .split(',')
                .map((e) => e.trim())
                .where((e) => e.isNotEmpty)
                .toList();
            Navigator.pop(context, (_label.text, patterns));
          },
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }
}

/// Per-row override: edit the five base cells (घट/वाढ recomputes from them).
class _EditCellsDialog extends ConsumerStatefulWidget {
  const _EditCellsDialog(
      {required this.row, required this.result, required this.period});
  final PreventiveRow row;
  final PreventiveRowResult result;
  final BhagPeriod period;

  @override
  ConsumerState<_EditCellsDialog> createState() => _EditCellsDialogState();
}

class _EditCellsDialogState extends ConsumerState<_EditCellsDialog> {
  late final Map<String, TextEditingController> _c = {
    for (final k in kPrevCells)
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
        width: 150,
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
      title: Text(widget.row.label),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _num('mA', '$mon $a (माहे)'),
            _num('mB', '$mon $b (माहे)'),
            _num('yA', '$mon $a पावेतो'),
            _num('yB', '$mon $b पावेतो'),
            _num('sA', 'सन $a'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final n = ref.read(preventiveOverridesProvider.notifier);
            for (final k in kPrevCells) {
              n.setValue(widget.period.signature, widget.row.id, k, null);
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
            final n = ref.read(preventiveOverridesProvider.notifier);
            for (final k in kPrevCells) {
              n.setValue(widget.period.signature, widget.row.id, k,
                  int.tryParse(_c[k]!.text.trim()) ?? 0);
            }
            Navigator.pop(context);
          },
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }
}
