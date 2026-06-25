import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../shared/widgets/crms.dart';
import 'analytics_repository.dart';
import 'stats_excel.dart';
import 'stats_report.dart';

/// Monthly + yearly crime statistics: crime-type rows × months (solved /
/// unsolved) + year and previous-year totals. Scrollable on screen, exportable
/// to Excel.
class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key});

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  int _year = DateTime.now().year;

  List<String> _monthLabels() =>
      [for (var m = 1; m <= 12; m++) 'stats.month.m$m'.tr()];

  Future<void> _export(StatsReport report) async {
    final messenger = ScaffoldMessenger.of(context);
    final dir = await FilePicker.getDirectoryPath();
    if (dir == null) return;
    try {
      final bytes = buildStatsExcel(
        report,
        typeHeader: 'crime.info.crimeType'.tr(),
        totalLabel: 'stats.total'.tr(),
        monthLabels: _monthLabels(),
        solvedShort: 'stats.solvedShort'.tr(),
        unsolvedShort: 'stats.unsolvedShort'.tr(),
      );
      final file = File(p.join(dir, 'crms-stats-$_year.xlsx'));
      await file.writeAsBytes(bytes);
      messenger.showSnackBar(SnackBar(
          content: Text('stats.exported'.tr(namedArgs: {'path': file.path}))));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text('stats.exportFailed'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final rowsAsync = ref.watch(analyticsRowsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('stats.title'.tr()),
        actions: const [Center(child: LanguageToggle()), SizedBox(width: 12)],
      ),
      body: rowsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text('list.loadError'.tr())),
        data: (allRows) {
          final report = computeStatsReport(allRows, _year);
          return Column(
            children: [
              _Toolbar(
                year: _year,
                onPrev: () => setState(() => _year--),
                onNext: () => setState(() => _year++),
                onExport: () => _export(report),
              ),
              const Divider(height: 1),
              Expanded(
                child: report.rows.isEmpty
                    ? CrmsEmptyState(
                        icon: PhosphorIconsRegular.chartBar,
                        title: 'stats.empty'.tr(),
                      )
                    : _StatsTable(report: report, monthLabels: _monthLabels()),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _Toolbar extends StatelessWidget {
  const _Toolbar({
    required this.year,
    required this.onPrev,
    required this.onNext,
    required this.onExport,
  });

  final int year;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onExport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          IconButton(
              onPressed: onPrev, icon: const Icon(Icons.chevron_left)),
          Text('$year', style: Theme.of(context).textTheme.titleLarge),
          IconButton(
              onPressed: onNext, icon: const Icon(Icons.chevron_right)),
          const Spacer(),
          Text('${'stats.solvedShort'.tr()} = ${'stats.solved'.tr()}   '
              '${'stats.unsolvedShort'.tr()} = ${'stats.unsolved'.tr()}',
              style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(width: 12),
          FilledButton.icon(
            onPressed: onExport,
            icon: const Icon(Icons.table_view),
            label: Text('stats.exportExcel'.tr()),
          ),
        ],
      ),
    );
  }
}

class _StatsTable extends StatelessWidget {
  const _StatsTable({required this.report, required this.monthLabels});

  final StatsReport report;
  final List<String> monthLabels;

  @override
  Widget build(BuildContext context) {
    final s = 'stats.solvedShort'.tr();
    final u = 'stats.unsolvedShort'.tr();

    final columns = <DataColumn>[
      DataColumn(label: Text('crime.info.crimeType'.tr())),
      for (final m in monthLabels) ...[
        DataColumn(label: Text('$m\n$s'), numeric: true),
        DataColumn(label: Text('$m\n$u'), numeric: true),
      ],
      DataColumn(label: Text('${report.year}\n$s'), numeric: true),
      DataColumn(label: Text('${report.year}\n$u'), numeric: true),
      DataColumn(label: Text('${report.year - 1}\n$s'), numeric: true),
      DataColumn(label: Text('${report.year - 1}\n$u'), numeric: true),
    ];

    List<DataCell> cellsFor(CrimeTypeStat st, String label, {bool bold = false}) {
      final style = bold ? const TextStyle(fontWeight: FontWeight.bold) : null;
      Widget n(int v) => Text('$v', style: style);
      return [
        DataCell(Text(label, style: style)),
        for (final c in st.months) ...[DataCell(n(c.solved)), DataCell(n(c.unsolved))],
        DataCell(n(st.yearTotal.solved)),
        DataCell(n(st.yearTotal.unsolved)),
        DataCell(n(st.prevYearTotal.solved)),
        DataCell(n(st.prevYearTotal.unsolved)),
      ];
    }

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 48,
          columnSpacing: 18,
          columns: columns,
          rows: [
            for (final st in report.rows)
              DataRow(cells: cellsFor(st, st.type)),
            DataRow(
              color: WidgetStatePropertyAll(
                  Theme.of(context).colorScheme.surfaceContainerHighest),
              cells: cellsFor(report.totalRow, 'stats.total'.tr(), bold: true),
            ),
          ],
        ),
      ),
    );
  }
}
