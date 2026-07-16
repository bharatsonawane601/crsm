import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../analyzer/analytics_model.dart';
import '../crime_entry/data/crime_types_data.dart';
import 'bhag_screen.dart' show showBhagCrimeTypePicker;
import 'undetected_report_model.dart';
import 'undetected_report_pdf.dart';
import 'undetected_report_providers.dart';
import 'undetected_report_view.dart';

/// The "उघडकीस न आलेल्या भाग १ ते ५" review. Fed by a data source and the ordered
/// [stations] that form the columns (the portal passes its scope's stations).
class UndetectedReport extends ConsumerWidget {
  const UndetectedReport(
      {super.key, required this.firsAsync, required this.stations});
  final AsyncValue<List<AnalyticsRow>> firsAsync;
  final List<String> stations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(undetConfigProvider);
    final range = ref.watch(undetRangeProvider);
    final overridesAll = ref.watch(undetOverridesProvider);

    return firsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('portal.error'.tr())),
      data: (firs) {
        final data = computeUndetected(
          firs: firs,
          config: config,
          universe: defaultUniverse(),
          stations: stations,
          range: range,
          overrides: undetOverridesForRange(overridesAll, range),
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Controls(range: range, firs: firs, stations: stations),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: UndetectedTableView(
                    data: data,
                    range: range,
                    editable: true,
                    onEdit: (row) => _editRow(context, row, data, range),
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

  void _editRow(BuildContext context, UndetRow row, UndetData data,
      UndetRange range) {
    final rr = data.rows.firstWhere((e) => e.row.id == row.id,
        orElse: () => UndetRowResult(row: row, byStation: {}));
    showDialog<void>(
      context: context,
      builder: (_) =>
          _EditRowDialog(result: rr, stations: data.stations, range: range),
    );
  }

  Future<void> _deleteRow(
      BuildContext context, WidgetRef ref, UndetRow row) async {
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
    if (ok == true) ref.read(undetConfigProvider.notifier).removeRow(row.id);
  }
}

class _Controls extends ConsumerWidget {
  const _Controls(
      {required this.range, required this.firs, required this.stations});
  final UndetRange range;
  final List<AnalyticsRow> firs;
  final List<String> stations;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.read(undetRangeProvider.notifier);
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Wrap(
        spacing: 12,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _dateChip(context, 'undetected.from'.tr(), range.from,
              (d) => n.setFrom(d)),
          _dateChip(context, 'undetected.to'.tr(), range.to, (d) => n.setTo(d)),
          OutlinedButton.icon(
            icon: const Icon(Icons.add),
            label: Text('undetected.addHead'.tr()),
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final t = await showBhagCrimeTypePicker(context);
              if (t == null || t.isEmpty) return;
              final isCat = isCrimeCategoryLabel(t);
              final added = ref.read(undetConfigProvider.notifier).addRow(
                    crimeTypeMarathi(t),
                    isCat ? {t} : <String>{},
                    isCat ? <String>{} : {t},
                  );
              if (!added) {
                messenger.showSnackBar(SnackBar(
                    content: Text('bhag.alreadyAdded'
                        .tr(namedArgs: {'name': crimeTypeMarathi(t)}))));
              }
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.restart_alt),
            label: Text('bhag.resetRows'.tr()),
            onPressed: () =>
                ref.read(undetConfigProvider.notifier).resetToDefault(),
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

  Widget _dateChip(BuildContext context, String label, DateTime value,
      void Function(DateTime) onPick) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
        OutlinedButton(
          onPressed: () async {
            final d = await showDatePicker(
              context: context,
              initialDate: value,
              firstDate: DateTime(2015),
              lastDate: DateTime(DateTime.now().year + 1, 12, 31),
            );
            if (d != null) onPick(d);
          },
          child: Text('${value.day}/${value.month}/${value.year}'),
        ),
      ],
    );
  }

  Future<void> _exportPdf(WidgetRef ref) async {
    final data = computeUndetected(
      firs: firs,
      config: ref.read(undetConfigProvider),
      universe: defaultUniverse(),
      stations: stations,
      range: range,
      overrides: undetOverridesForRange(ref.read(undetOverridesProvider), range),
    );
    final bytes = await renderUndetectedPdf(data: data, range: range);
    await Printing.layoutPdf(
        onLayout: (_) async => bytes, name: kUndetectedReportId);
  }
}

/// Per-row override: one field per station column.
class _EditRowDialog extends ConsumerStatefulWidget {
  const _EditRowDialog(
      {required this.result, required this.stations, required this.range});
  final UndetRowResult result;
  final List<String> stations;
  final UndetRange range;

  @override
  ConsumerState<_EditRowDialog> createState() => _EditRowDialogState();
}

class _EditRowDialogState extends ConsumerState<_EditRowDialog> {
  late final Map<String, TextEditingController> _c = {
    for (final s in widget.stations)
      s: TextEditingController(text: '${widget.result.at(s)}'),
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
      title: Text(widget.result.row.label),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final s in widget.stations)
                SizedBox(
                  width: 130,
                  child: TextField(
                    controller: _c[s],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: s, isDense: true),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            final nn = ref.read(undetOverridesProvider.notifier);
            for (final s in widget.stations) {
              nn.setValue(widget.range.signature, widget.result.row.id, s, null);
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
            final nn = ref.read(undetOverridesProvider.notifier);
            for (final s in widget.stations) {
              nn.setValue(widget.range.signature, widget.result.row.id, s,
                  int.tryParse(_c[s]!.text.trim()) ?? 0);
            }
            Navigator.pop(context);
          },
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }
}
