import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../shared/widgets/crms.dart';
import 'analytics_model.dart';
import 'analytics_repository.dart';
import 'charts.dart';
import 'stats_screen.dart';

final _moneyFmt = NumberFormat('#,##0');
final _dateFmt = DateFormat('dd-MM-yyyy');

/// Live analytics dashboard: KPI cards + charts, all reacting to a shared
/// filter (date range / status / section).
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key, this.showStatsButton = true});

  /// The "Statistics" button opens a screen backed by the local database, so
  /// the read-only officer portal hides it (its data lives on the server).
  final bool showStatsButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rowsAsync = ref.watch(analyticsRowsProvider);
    return Scaffold(
      body: rowsAsync.when(
        loading: () => const CrmsListSkeleton(rows: 4),
        error: (_, _) => Center(child: Text('list.loadError'.tr())),
        data: (allRows) => AnalyticsDashboardBody(
          allRows: allRows,
          showStatsButton: showStatsButton,
        ),
      ),
    );
  }
}

/// The dashboard presentation (filter bar + KPIs + every chart) over a given
/// list of rows. Shared by [DashboardScreen] (local DB) and the officer portal
/// (central, scope-filtered data) so both show the identical chart suite.
class AnalyticsDashboardBody extends StatefulWidget {
  const AnalyticsDashboardBody({
    super.key,
    required this.allRows,
    this.showStatsButton = true,
  });

  final List<AnalyticsRow> allRows;
  final bool showStatsButton;

  @override
  State<AnalyticsDashboardBody> createState() => _AnalyticsDashboardBodyState();
}

class _AnalyticsDashboardBodyState extends State<AnalyticsDashboardBody> {
  AnalyticsFilter _filter = const AnalyticsFilter();

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _filter.from : _filter.to) ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() => _filter = isFrom
          ? _filter.copyWith(from: picked)
          : _filter.copyWith(to: picked));
    }
  }

  @override
  Widget build(BuildContext context) {
    final allRows = widget.allRows;
    if (allRows.isEmpty) {
      return CrmsEmptyState(
        icon: PhosphorIconsRegular.chartLineUp,
        title: 'analyzer.empty'.tr(),
      );
    }
    final crimeTypes = (allRows
            .map((r) => (r.crimeType ?? '').trim())
            .where((t) => t.isNotEmpty)
            .toSet()
            .toList())
      ..sort();
    final rows = allRows.where(_filter.matches).toList();
    final s = computeAnalytics(rows);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        if (widget.showStatsButton)
          Align(
            alignment: Alignment.centerRight,
            child: CrmsButton(
              label: 'stats.title'.tr(),
              variant: CrmsButtonVariant.secondary,
              icon: PhosphorIconsRegular.table,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<Object?>(
                    builder: (_) => const StatsScreen()),
              ),
            ),
          ),
        if (widget.showStatsButton) const SizedBox(height: 8),
        _FilterBar(
          filter: _filter,
          crimeTypes: crimeTypes,
          onStatus: (v) => setState(
              () => _filter = _filter.copyWith(status: v, clearStatus: v == null)),
          onTypes: (set) =>
              setState(() => _filter = _filter.copyWith(crimeTypes: set)),
          onFrom: () => _pickDate(isFrom: true),
          onTo: () => _pickDate(isFrom: false),
          onClear: () => setState(() => _filter = const AnalyticsFilter()),
        ),
        const SizedBox(height: 8),
        _kpis(context, s),
        const SizedBox(height: 8),
        _ChartGrid(summary: s),
      ],
    );
  }

  Widget _kpis(BuildContext context, AnalyticsSummary s) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        KpiCard(label: 'analyzer.kpi.total'.tr(), value: '${s.total}'),
        KpiCard(label: 'analyzer.kpi.today'.tr(), value: '${s.today}'),
        KpiCard(label: 'analyzer.kpi.week'.tr(), value: '${s.thisWeek}'),
        KpiCard(label: 'analyzer.kpi.month'.tr(), value: '${s.thisMonth}'),
        KpiCard(label: 'analyzer.kpi.year'.tr(), value: '${s.thisYear}'),
        KpiCard(
          label: 'crime.status.pending'.tr(),
          value: '${s.statusCounts['pending'] ?? 0}',
          color: Colors.orange,
        ),
        KpiCard(
          label: 'crime.status.solved'.tr(),
          value: '${s.statusCounts['solved'] ?? 0}',
          color: Colors.green,
        ),
        KpiCard(
          label: 'analyzer.kpi.arrested'.tr(),
          value: '${s.arrested}',
          color: Colors.green,
        ),
        KpiCard(
          label: 'analyzer.kpi.wanted'.tr(),
          value: '${s.wanted}',
          color: Colors.red,
        ),
        KpiCard(
          label: 'analyzer.kpi.recovered'.tr(),
          value: '₹${_moneyFmt.format(s.recoveredValue)}',
        ),
        KpiCard(
          label: 'analyzer.kpi.avgChargesheet'.tr(),
          value: s.avgDaysToChargesheet == null
              ? '—'
              : s.avgDaysToChargesheet!.toStringAsFixed(0),
        ),
      ],
    );
  }
}

class _ChartGrid extends StatelessWidget {
  const _ChartGrid({required this.summary});
  final AnalyticsSummary summary;

  @override
  Widget build(BuildContext context) {
    final empty = 'analyzer.noData'.tr();
    final statusDisplay = {
      for (final e in summary.statusCounts.entries)
        'crime.status.${e.key}'.tr(): e.value,
    };
    final dow = [
      for (final k in ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'])
        'analyzer.dow.$k'.tr(),
    ];

    final arrestData = {
      'analyzer.kpi.arrested'.tr(): summary.arrested,
      'analyzer.kpi.wanted'.tr(): summary.wanted,
    };

    final crimeRanked = _sorted(summary.crimeTypeCounts);
    final crimeTypeLabels = [for (final e in crimeRanked) e.key];
    final solvedLabel = 'crime.status.solved'.tr();
    final openLabel = 'crime.status.open'.tr();
    final solvedTotal = (summary.statusCounts['solved'] ?? 0) +
        (summary.statusCounts['chargesheeted'] ?? 0);
    final solvedRate =
        summary.total == 0 ? 0.0 : solvedTotal * 100 / summary.total;

    final cards = <Widget>[
      // Station comparison — only meaningful across multiple stations (the
      // officer portal), so hidden on a single-station install.
      if (summary.stationCounts.length >= 2)
        ConfigurableChartCard(
          title: 'analyzer.chart.station'.tr(),
          entries: _sorted(summary.stationCounts),
          emptyLabel: empty,
        ),
      ConfigurableChartCard(
        title: 'analyzer.chart.trend'.tr(),
        entries: summary.monthlyTrend,
        initialType: ChartType.line,
        emptyLabel: empty,
      ),
      ConfigurableChartCard(
        title: 'analyzer.chart.crimeType'.tr(),
        entries: _sorted(summary.crimeTypeCounts),
        initialType: ChartType.pie,
        emptyLabel: empty,
      ),
      ConfigurableChartCard(
        title: 'analyzer.chart.status'.tr(),
        entries: statusDisplay.entries.toList(),
        initialType: ChartType.pie,
        emptyLabel: empty,
      ),
      ConfigurableChartCard(
        title: 'analyzer.chart.topSections'.tr(),
        entries: summary.topSections,
        emptyLabel: empty,
      ),
      ConfigurableChartCard(
        title: 'analyzer.chart.officer'.tr(),
        entries: _sorted(summary.officerCounts),
        emptyLabel: empty,
      ),
      ChartCard(
        title: 'analyzer.chart.dow'.tr(),
        child: DayOfWeekBars(counts: summary.dayOfWeekCounts, labels: dow),
      ),
      ChartCard(
        title: 'analyzer.chart.arrest'.tr(),
        child: CountPie(data: arrestData, emptyLabel: empty),
      ),
      ChartCard(
        title: 'analyzer.chart.solvedGauge'.tr(),
        child: GaugeChart(
          percent: solvedRate,
          label: 'analyzer.chart.solvedRate'.tr(),
        ),
      ),
      ChartCard(
        title: 'analyzer.chart.area'.tr(),
        child: AreaTrend(entries: summary.monthlyTrend, emptyLabel: empty),
      ),
      ChartCard(
        title: 'analyzer.chart.column'.tr(),
        height: 320,
        child: ColumnChart(entries: crimeRanked, emptyLabel: empty),
      ),
      ChartCard(
        title: 'analyzer.chart.stacked'.tr(),
        height: 340,
        child: StackedColumn(
          types: crimeTypeLabels,
          solvedByType: summary.solvedByType,
          openByType: summary.openByType,
          solvedLabel: solvedLabel,
          openLabel: openLabel,
          emptyLabel: empty,
        ),
      ),
      ChartCard(
        title: 'analyzer.chart.comparison'.tr(),
        height: 340,
        child: ComparisonColumns(
          types: crimeTypeLabels,
          solvedByType: summary.solvedByType,
          openByType: summary.openByType,
          solvedLabel: solvedLabel,
          openLabel: openLabel,
          emptyLabel: empty,
        ),
      ),
      ChartCard(
        title: 'analyzer.chart.radar'.tr(),
        height: 340,
        child: RadarCrime(entries: crimeRanked, emptyLabel: empty),
      ),
      ChartCard(
        title: 'analyzer.chart.bubble'.tr(),
        height: 320,
        child: BubbleCrime(entries: crimeRanked, emptyLabel: empty),
      ),
      ChartCard(
        title: 'analyzer.chart.scatter'.tr(),
        height: 320,
        child: ScatterCrime(entries: crimeRanked, emptyLabel: empty),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final twoCol = constraints.maxWidth > 720;
        final width =
            twoCol ? (constraints.maxWidth - 8) / 2 : constraints.maxWidth;
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in cards) SizedBox(width: width, child: c),
          ],
        );
      },
    );
  }

  List<MapEntry<String, int>> _sorted(Map<String, int> m) =>
      m.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
}

class _FilterBar extends StatelessWidget {
  const _FilterBar({
    required this.filter,
    required this.crimeTypes,
    required this.onStatus,
    required this.onTypes,
    required this.onFrom,
    required this.onTo,
    required this.onClear,
  });

  final AnalyticsFilter filter;
  final List<String> crimeTypes;
  final ValueChanged<String?> onStatus;
  final ValueChanged<Set<String>> onTypes;
  final VoidCallback onFrom;
  final VoidCallback onTo;
  final VoidCallback onClear;

  Future<void> _pickTypes(BuildContext context) async {
    final selected = {...filter.crimeTypes};
    final result = await showDialog<Set<String>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text('crime.info.crimeType'.tr()),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => setLocal(selected.clear),
                      child: Text('list.clearFilters'.tr()),
                    ),
                  ],
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (final t in crimeTypes)
                        CheckboxListTile(
                          dense: true,
                          value: selected.contains(t),
                          title: Text(t),
                          onChanged: (v) => setLocal(() =>
                              v == true ? selected.add(t) : selected.remove(t)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('common.cancel'.tr()),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, selected),
              child: Text('common.ok'.tr()),
            ),
          ],
        ),
      ),
    );
    if (result != null) onTypes(result);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            DropdownMenu<String?>(
              initialSelection: filter.status,
              label: Text('list.filterStatus'.tr()),
              onSelected: onStatus,
              dropdownMenuEntries: [
                DropdownMenuEntry(value: null, label: 'list.statusAll'.tr()),
                for (final st in ['open', 'pending', 'solved', 'chargesheeted'])
                  DropdownMenuEntry(value: st, label: 'crime.status.$st'.tr()),
              ],
            ),
            if (crimeTypes.isNotEmpty)
              OutlinedButton.icon(
                icon: const Icon(Icons.checklist, size: 16),
                label: Text(filter.crimeTypes.isEmpty
                    ? 'analyzer.allTypes'.tr()
                    : 'analyzer.typesSelected'
                        .tr(namedArgs: {'n': '${filter.crimeTypes.length}'})),
                onPressed: () => _pickTypes(context),
              ),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 16),
              label: Text(filter.from == null
                  ? 'list.dateFrom'.tr()
                  : _dateFmt.format(filter.from!)),
              onPressed: onFrom,
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.calendar_today, size: 16),
              label: Text(filter.to == null
                  ? 'list.dateTo'.tr()
                  : _dateFmt.format(filter.to!)),
              onPressed: onTo,
            ),
            if (!filter.isEmpty)
              TextButton.icon(
                icon: const Icon(Icons.clear, size: 16),
                label: Text('list.clearFilters'.tr()),
                onPressed: onClear,
              ),
          ],
        ),
      ),
    );
  }
}
