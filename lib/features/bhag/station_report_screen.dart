import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../analyzer/analytics_model.dart';
import '../crime_entry/data/crime_types_data.dart';
import 'bhag_model.dart' show kMonthsMr;
import 'station_report_model.dart';
import 'station_report_pdf.dart';
import 'station_report_providers.dart';
import 'station_report_view.dart';

/// The division station-wise दाखल/उघड report (परिमंडळ ... report). Fed by a data
/// source (the officer portal passes its scope-filtered central rows), so the
/// per-station tables reflect the officer's jurisdiction.
class StationReport extends ConsumerWidget {
  const StationReport({super.key, required this.firsAsync});
  final AsyncValue<List<AnalyticsRow>> firsAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapping = ref.watch(stationReportMappingProvider);
    final period = ref.watch(stationReportPeriodProvider);

    return firsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('portal.error'.tr())),
      data: (firs) {
        final data = computeStationReport(
          firs: firs,
          bodyCategories: mapping.body,
          propertyCategories: mapping.property,
          period: period,
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
                  child: StationReportView(
                    data: data,
                    period: period,
                    title: 'stationReport.title'.tr(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Controls extends ConsumerWidget {
  const _Controls({required this.period, required this.firs});
  final StationReportPeriod period;
  final List<AnalyticsRow> firs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now().year;
    final years = [for (var y = now; y >= now - 8; y--) y];
    final p = ref.read(stationReportPeriodProvider.notifier);

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
            label: Text('stationReport.editCategories'.tr()),
            onPressed: () => showDialog<void>(
                context: context, builder: (_) => const _CategoryMappingDialog()),
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
    final mapping = ref.read(stationReportMappingProvider);
    final data = computeStationReport(
      firs: firs,
      bodyCategories: mapping.body,
      propertyCategories: mapping.property,
      period: period,
    );
    final bytes = await renderStationReportPdf(
      data: data,
      period: period,
      title: 'stationReport.title'.tr(),
    );
    await Printing.layoutPdf(onLayout: (_) async => bytes, name: kStationReportId);
  }
}

/// Two-tab dialog to tick which crime categories count as property vs body.
class _CategoryMappingDialog extends ConsumerStatefulWidget {
  const _CategoryMappingDialog();
  @override
  ConsumerState<_CategoryMappingDialog> createState() =>
      _CategoryMappingDialogState();
}

class _CategoryMappingDialogState
    extends ConsumerState<_CategoryMappingDialog> {
  late Set<String> _property;
  late Set<String> _body;

  @override
  void initState() {
    super.initState();
    final m = ref.read(stationReportMappingProvider);
    _property = {...m.property};
    _body = {...m.body};
  }

  Widget _list(Set<String> selected) {
    return ListView(
      children: [
        for (final c in kCrimeCategories)
          CheckboxListTile(
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
            value: selected.contains(c.label),
            title: Text(c.label),
            onChanged: (v) => setState(() {
              if (v == true) {
                selected.add(c.label);
              } else {
                selected.remove(c.label);
              }
            }),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: AlertDialog(
        title: Text('stationReport.editCategories'.tr()),
        content: SizedBox(
          width: 460,
          height: 560,
          child: Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'stationReport.property'.tr()),
                  Tab(text: 'stationReport.body'.tr()),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [_list(_property), _list(_body)],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(stationReportMappingProvider.notifier).reset();
              Navigator.pop(context);
            },
            child: Text('bhag.resetRows'.tr()),
          ),
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('common.cancel'.tr())),
          FilledButton(
            onPressed: () {
              final n = ref.read(stationReportMappingProvider.notifier);
              n.setProperty(_property);
              n.setBody(_body);
              Navigator.pop(context);
            },
            child: Text('common.save'.tr()),
          ),
        ],
      ),
    );
  }
}
