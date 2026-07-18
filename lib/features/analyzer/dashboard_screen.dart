import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:printing/printing.dart';

import '../../shared/widgets/crms.dart';
import '../crime_entry/data/crime_types_data.dart';
import 'analytics_model.dart';
import 'analytics_pdf.dart';
import 'analytics_repository.dart';
import 'charts.dart';
import 'duo_panels.dart';
import 'stats_screen.dart';

final _moneyFmt = NumberFormat('#,##0');
final _dateFmt = DateFormat('dd-MM-yyyy');

/// Which slice of the dashboard a screen shows: [overview] is the Dashboard
/// tab (KPIs + live pulse + status + caseload), [analytics] is the Analytics
/// tab (filters + brain insights + every pattern panel), [full] is both —
/// used by the officer portal, which has a single combined view.
enum DashboardMode { overview, analytics, full }

/// The Dashboard tab: at-a-glance overview of the station's data.
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
          mode: DashboardMode.overview,
        ),
      ),
    );
  }
}

/// The Analytics tab: shared filter + 🧠 insights + the table-and-chart
/// pattern panels (muddemal, trends, weekday/time loops, hot dates, league).
class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rowsAsync = ref.watch(analyticsRowsProvider);
    return Scaffold(
      body: rowsAsync.when(
        loading: () => const CrmsListSkeleton(rows: 4),
        error: (_, _) => Center(child: Text('list.loadError'.tr())),
        data: (allRows) => AnalyticsDashboardBody(
          allRows: allRows,
          showStatsButton: false,
          mode: DashboardMode.analytics,
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
    this.mode = DashboardMode.full,
  });

  final List<AnalyticsRow> allRows;
  final bool showStatsButton;
  final DashboardMode mode;

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
    // Offer categories (Murder / खून), not every leaf sub-type — matches how
    // the charts below now count, and keeps the list short.
    final crimeTypes = (allRows
            .map((r) {
              final raw = (r.crimeType ?? '').trim();
              return crimeCategoryOf(raw) ?? raw;
            })
            .where((t) => t.isNotEmpty)
            .toSet()
            .toList())
      ..sort();
    final mode = widget.mode;
    final overview = mode != DashboardMode.analytics;
    final analytics = mode != DashboardMode.overview;
    // The overview is the station's true totals; filters live on Analytics.
    final rows =
        analytics ? allRows.where(_filter.matches).toList() : allRows;
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
        if (analytics) ...[
          Row(
            children: [
              Expanded(
                child: _FilterBar(
                  filter: _filter,
                  crimeTypes: crimeTypes,
                  onStatus: (v) => setState(() => _filter =
                      _filter.copyWith(status: v, clearStatus: v == null)),
                  onTypes: (set) => setState(
                      () => _filter = _filter.copyWith(crimeTypes: set)),
                  onFrom: () => _pickDate(isFrom: true),
                  onTo: () => _pickDate(isFrom: false),
                  onClear: () =>
                      setState(() => _filter = const AnalyticsFilter()),
                ),
              ),
              const SizedBox(width: 8),
              CrmsButton(
                label: 'analyzer.pdf.export'.tr(),
                variant: CrmsButtonVariant.secondary,
                icon: PhosphorIconsRegular.filePdf,
                onPressed: () async {
                  // Prints/saves the filtered numbers currently on screen.
                  final bytes = await renderAnalyticsPdf(s);
                  await Printing.layoutPdf(
                      onLayout: (_) async => bytes, name: 'crms-analytics');
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
        if (overview && s.chargesheetDue.isNotEmpty) ...[
          _DueAlertsCard(cases: s.chargesheetDue),
          const SizedBox(height: 8),
        ],
        _kpis(context, s),
        const SizedBox(height: 8),
        if (overview) _OverviewDuos(summary: s),
        if (analytics) ...[
          if (s.insights.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                '🧠 ${'analyzer.ins.title'.tr()}',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            InsightsGrid(insights: s.insights),
            const SizedBox(height: 8),
          ],
          _DuoSuite(summary: s),
          _ChartGrid(summary: s),
          _DataQuality(summary: s),
        ],
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
          label: 'crime.status.undetected'.tr(),
          value:
              '${(s.statusCounts['undetected'] ?? 0) + (s.statusCounts['pending'] ?? 0) + (s.statusCounts['open'] ?? 0)}',
          color: Colors.orange,
        ),
        KpiCard(
          label: 'crime.status.detected'.tr(),
          value:
              '${(s.statusCounts['detected'] ?? 0) + (s.statusCounts['solved'] ?? 0) + (s.statusCounts['chargesheeted'] ?? 0)}',
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
        KpiCard(
          label: 'analyzer.kpi.chargesheetOverdue'.tr(),
          value:
              '${(s.chargesheetOverdue['60'] ?? 0) + (s.chargesheetOverdue['90'] ?? 0)}',
          color: Colors.red,
        ),
      ],
    );
  }
}

/// Deadline alerts: pending chargesheets that are overdue or due within
/// [kChargesheetDueSoonDays], named by FIR so officers can act on them.
class _DueAlertsCard extends StatelessWidget {
  const _DueAlertsCard({required this.cases});

  final List<ChargesheetDueCase> cases;

  static const _maxShown = 8;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final overdueCount = cases.where((c) => c.overdue).length;
    final accent = overdueCount > 0 ? Colors.red : Colors.orange;

    String badge(ChargesheetDueCase c) {
      if (c.daysLeft < 0) {
        return 'analyzer.due.overdueBy'
            .tr(namedArgs: {'days': '${-c.daysLeft}'});
      }
      if (c.daysLeft == 0) return 'analyzer.due.today'.tr();
      return 'analyzer.due.dueIn'.tr(namedArgs: {'days': '${c.daysLeft}'});
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: accent.withValues(alpha: 0.5)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(PhosphorIconsRegular.warningCircle,
                    size: 20, color: accent),
                const SizedBox(width: 8),
                Text(
                  'analyzer.due.title'
                      .tr(namedArgs: {'count': '${cases.length}'}),
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final c in cases.take(_maxShown))
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: (c.overdue ? Colors.red : Colors.orange)
                          .withValues(alpha: 0.08),
                      border: Border.all(
                        color: (c.overdue ? Colors.red : Colors.orange)
                            .withValues(alpha: 0.35),
                      ),
                    ),
                    child: Text(
                      '${c.label} · ${badge(c)} · ${_dateFmt.format(c.deadline)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                if (cases.length > _maxShown)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Text(
                      'analyzer.due.more'.tr(
                          namedArgs: {'count': '${cases.length - _maxShown}'}),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// The Dashboard tab's three overview panels, each a table + its chart:
/// activity in the last 14 days, the detected/undetected split, and (for
/// multi-station data) stations by caseload.
class _OverviewDuos extends StatelessWidget {
  const _OverviewDuos({required this.summary});
  final AnalyticsSummary summary;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    final empty = 'analyzer.noData'.tr();
    final panels = <Widget>[];
    void add(Widget w) => panels
      ..add(w)
      ..add(const SizedBox(height: 8));

    // Live pulse: last 14 days of registrations.
    add(DuoPanel(
      title: 'analyzer.duo.activityTitle'.tr(),
      subtitle: 'analyzer.duo.activitySub'.tr(),
      chartHeight: 260,
      table: MiniTable(
        headers: ['analyzer.duo.date'.tr(), 'analyzer.duo.cases'.tr()],
        rows: [
          for (final e in s.last14Days) [e.key, '${e.value}'],
        ],
      ),
      chart: s.last14Days.every((e) => e.value == 0)
          ? Center(
              child: Text(empty,
                  style: Theme.of(context).textTheme.bodySmall))
          : TrendLine(
              entries: s.last14Days, emptyLabel: empty, rawLabels: true),
    ));

    // Status split — the app's version of the panel's zone donut.
    if (s.total > 0) {
      final statusDisplay = {
        for (final e in s.statusCounts.entries)
          'crime.status.${e.key}'.tr(): e.value,
      };
      add(DuoPanel(
        title: 'analyzer.duo.statusTitle'.tr(),
        subtitle: 'analyzer.duo.statusSub'.tr(),
        chartHeight: 240,
        table: MiniTable(
          headers: [
            'analyzer.duo.status'.tr(),
            'analyzer.duo.cases'.tr(),
            'analyzer.duo.share'.tr(),
          ],
          rows: [
            for (final e in statusDisplay.entries)
              [
                e.key,
                '${e.value}',
                '${(e.value * 100 / s.total).round()}%',
              ],
          ],
        ),
        chart: CountPie(data: statusDisplay, emptyLabel: empty),
      ));
    }

    // Multi-station only (officer portal / HQ): caseload comparison.
    if (s.stationRows.length >= 2) {
      add(DuoPanel(
        title: 'analyzer.duo.caseload'.tr(),
        subtitle: 'analyzer.duo.caseloadSub'.tr(),
        table: MiniTable(
          headers: [
            'analyzer.duo.station'.tr(),
            'analyzer.kpi.total'.tr(),
            'crime.status.detected'.tr(),
            'analyzer.duo.rate'.tr(),
          ],
          rows: [
            for (final r in s.stationRows.take(25))
              [r.label, '${r.total}', '${r.detected}', '${r.pct}%'],
          ],
        ),
        chart: RankedBars(
          entries: [
            for (final r in s.stationRows) MapEntry(r.label, r.total),
          ],
          maxRows: 10,
          emptyLabel: empty,
        ),
      ));
    }

    return Column(children: panels);
  }
}

/// Data-quality counters at the foot of Analytics: fix these and every
/// report above becomes accurate.
class _DataQuality extends StatelessWidget {
  const _DataQuality({required this.summary});
  final AnalyticsSummary summary;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    if (s.missingFirNo == 0 && s.missingType == 0 && s.missingTime == 0) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            'analyzer.dq.title'.tr(),
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            if (s.missingFirNo > 0)
              KpiCard(
                label: 'analyzer.dq.noFirNo'.tr(),
                value: '${s.missingFirNo}',
                color: Colors.orange,
              ),
            if (s.missingType > 0)
              KpiCard(
                label: 'analyzer.dq.noType'.tr(),
                value: '${s.missingType}',
                color: Colors.orange,
              ),
            if (s.missingTime > 0)
              KpiCard(
                label: 'analyzer.dq.noTime'.tr(),
                value: '${s.missingTime}',
                color: Colors.orange,
              ),
          ],
        ),
      ],
    );
  }
}

/// The "table + its chart, side by side" suite: muddemal money trail, year /
/// month trends, day-of-week, time-of-day, week-of-month, hottest dates, top
/// crime types and the station league — same layout as the admin panel.
class _DuoSuite extends StatelessWidget {
  const _DuoSuite({required this.summary});
  final AnalyticsSummary summary;

  @override
  Widget build(BuildContext context) {
    final s = summary;
    final empty = 'analyzer.noData'.tr();
    final panels = <Widget>[];
    void add(Widget w) => panels
      ..add(w)
      ..add(const SizedBox(height: 8));

    String rate(RateRow r) => '${r.pct}%';
    final dowShort = [
      for (final k in ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'])
        'analyzer.dow.$k'.tr(),
    ];

    // 💰 Muddemal money trail.
    if (s.lostValue > 0 || s.recoveredValue > 0) {
      final remaining =
          (s.lostValue - s.recoveredValue).clamp(0, double.infinity).toDouble();
      add(DuoPanel(
        title: '💰 ${'analyzer.duo.muddemal'.tr()}',
        subtitle: 'analyzer.duo.muddemalSub'.tr(),
        chartHeight: 240,
        table: MiniTable(
          headers: ['analyzer.duo.measure'.tr(), 'analyzer.duo.amount'.tr()],
          rows: [
            ['analyzer.duo.lost'.tr(), inrFull(s.lostValue)],
            ['analyzer.duo.recovered'.tr(), inrFull(s.recoveredValue)],
            ['analyzer.duo.remaining'.tr(), inrFull(remaining)],
          ],
        ),
        chart: s.lostValue > 0
            ? MoneyDonut(lost: s.lostValue, recovered: s.recoveredValue)
            : Center(
                child: Text('analyzer.duo.needLost'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall),
              ),
      ));
    }

    // Year-wise trend.
    if (s.yearRows.length >= 2) {
      add(DuoPanel(
        title: 'analyzer.duo.yearTitle'.tr(),
        subtitle: 'analyzer.duo.yearSub'.tr(),
        table: MiniTable(
          headers: [
            'analyzer.duo.year'.tr(),
            'analyzer.kpi.total'.tr(),
            'crime.status.detected'.tr(),
            'analyzer.duo.rate'.tr(),
          ],
          rows: [
            for (final r in s.yearRows)
              [r.label, '${r.total}', '${r.detected}', rate(r)],
          ],
        ),
        chart: TrendLine(
          entries: [
            for (final r in s.yearRows.reversed) MapEntry(r.label, r.total),
          ],
          emptyLabel: empty,
        ),
      ));
    }

    // Month-wise trend (last 24 months).
    if (s.monthRows.length >= 2) {
      add(DuoPanel(
        title: 'analyzer.duo.monthTitle'.tr(),
        subtitle: 'analyzer.duo.monthSub'.tr(),
        table: MiniTable(
          headers: [
            'analyzer.duo.month'.tr(),
            'analyzer.kpi.total'.tr(),
            'crime.status.detected'.tr(),
            'analyzer.duo.rate'.tr(),
          ],
          rows: [
            for (final r in s.monthRows.reversed)
              [r.label, '${r.total}', '${r.detected}', rate(r)],
          ],
        ),
        chart: AreaTrend(
          entries: [for (final r in s.monthRows) MapEntry(r.label, r.total)],
          emptyLabel: empty,
        ),
      ));
    }

    // 📅 Day of the week (by occurrence date).
    final datedTotal =
        s.weekdayRows.fold(0, (a, r) => a + r.total);
    if (datedTotal > 0) {
      add(DuoPanel(
        title: '📅 ${'analyzer.duo.dayTitle'.tr()}',
        subtitle: 'analyzer.duo.daySub'.tr(),
        table: MiniTable(
          headers: [
            'analyzer.duo.day'.tr(),
            'analyzer.kpi.total'.tr(),
            'crime.status.detected'.tr(),
            'analyzer.duo.rate'.tr(),
          ],
          rows: [
            for (final r in s.weekdayRows)
              [
                'analyzer.dowFull.${r.label}'.tr(),
                '${r.total}',
                '${r.detected}',
                rate(r),
              ],
          ],
        ),
        chart: DayOfWeekBars(
          counts: [for (final r in s.weekdayRows) r.total],
          labels: dowShort,
        ),
      ));
    }

    // 🕘 Time of day (parsed occurrence times).
    if (s.timedTotal > 0) {
      add(DuoPanel(
        title: '🕘 ${'analyzer.duo.timeTitle'.tr()}',
        subtitle: 'analyzer.duo.timeSub'
            .tr(namedArgs: {'n': '${s.timedTotal}'}),
        table: MiniTable(
          headers: [
            'analyzer.duo.timeWindow'.tr(),
            'analyzer.duo.cases'.tr(),
            'analyzer.duo.share'.tr(),
          ],
          rows: [
            for (var i = 0; i < 8; i++)
              [
                kHourBandLabels[i],
                '${s.hourBandCounts[i]}',
                '${(s.hourBandCounts[i] * 100 / s.timedTotal).round()}%',
              ],
          ],
        ),
        chart: ColumnChart(
          entries: [
            for (var i = 0; i < 8; i++)
              MapEntry(kHourBandLabels[i], s.hourBandCounts[i]),
          ],
          emptyLabel: empty,
        ),
      ));
    }

    // 📆 Week of the month.
    if (datedTotal > 0) {
      add(DuoPanel(
        title: '📆 ${'analyzer.duo.weekTitle'.tr()}',
        subtitle: 'analyzer.duo.weekSub'.tr(),
        table: MiniTable(
          headers: [
            'analyzer.duo.week'.tr(),
            'analyzer.kpi.total'.tr(),
            'crime.status.detected'.tr(),
            'analyzer.duo.rate'.tr(),
          ],
          rows: [
            for (final r in s.weekOfMonthRows)
              [
                'analyzer.duo.weekN'.tr(namedArgs: {'n': r.label}),
                '${r.total}',
                '${r.detected}',
                rate(r),
              ],
          ],
        ),
        chart: ColumnChart(
          entries: [
            for (final r in s.weekOfMonthRows)
              MapEntry('W${r.label}', r.total),
          ],
          emptyLabel: empty,
        ),
      ));
    }

    // 📌 Hottest single dates.
    if (s.hotDates.isNotEmpty && s.hotDates.first.value >= 2) {
      add(DuoPanel(
        title: '📌 ${'analyzer.duo.hotDates'.tr()}',
        subtitle: 'analyzer.duo.hotDatesSub'.tr(),
        table: MiniTable(
          headers: ['analyzer.duo.date'.tr(), 'analyzer.duo.cases'.tr()],
          rows: [
            for (final e in s.hotDates) [e.key, '${e.value}'],
          ],
        ),
        chart: RankedBars(entries: s.hotDates, maxRows: 10, emptyLabel: empty),
      ));
    }

    // Top crime types with detection rate.
    if (s.typeRows.isNotEmpty) {
      add(DuoPanel(
        title: 'analyzer.duo.topTypes'.tr(),
        subtitle: 'analyzer.duo.topTypesSub'.tr(),
        table: MiniTable(
          headers: [
            'analyzer.duo.type'.tr(),
            'analyzer.kpi.total'.tr(),
            'crime.status.detected'.tr(),
            'analyzer.duo.rate'.tr(),
          ],
          rows: [
            for (final r in s.typeRows.take(15))
              [r.label, '${r.total}', '${r.detected}', rate(r)],
          ],
        ),
        chart: RankedBars(
          entries: [
            for (final r in s.typeRows) MapEntry(r.label, r.total),
          ],
          maxRows: 10,
          emptyLabel: empty,
        ),
      ));
    }

    // Multi-station only (officer portal): the detection league.
    if (s.stationRows.length >= 2) {
      add(DuoPanel(
        title: '🏆 ${'analyzer.duo.league'.tr()}',
        subtitle: 'analyzer.duo.leagueSub'.tr(),
        table: MiniTable(
          headers: [
            'analyzer.duo.station'.tr(),
            'analyzer.kpi.total'.tr(),
            'crime.status.detected'.tr(),
            'analyzer.duo.rate'.tr(),
          ],
          rows: [
            for (final r in s.leagueRows.take(25))
              [r.label, '${r.total}', '${r.detected}', rate(r)],
          ],
        ),
        chart: RankedBars(
          entries: [
            for (final r in s.leagueRows) MapEntry(r.label, r.pct),
          ],
          maxRows: 10,
          emptyLabel: empty,
        ),
      ));
    }

    return Column(children: panels);
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
    final arrestData = {
      'analyzer.kpi.arrested'.tr(): summary.arrested,
      'analyzer.kpi.wanted'.tr(): summary.wanted,
    };

    final crimeRanked = _sorted(summary.crimeTypeCounts);
    final crimeTypeLabels = [for (final e in crimeRanked) e.key];
    final solvedLabel = 'crime.status.detected'.tr();
    final openLabel = 'crime.status.undetected'.tr();
    final solvedTotal = (summary.statusCounts['detected'] ?? 0) +
        (summary.statusCounts['solved'] ?? 0) +
        (summary.statusCounts['chargesheeted'] ?? 0);
    final solvedRate =
        summary.total == 0 ? 0.0 : solvedTotal * 100 / summary.total;

    // Datasets the officer can plug into a custom chart (pick metric + type).
    final stageDisplay = [
      for (final e in (summary.stageCounts.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value))))
        MapEntry('crime.stage.${e.key}'.tr(), e.value),
    ];
    final datasets = <String, List<MapEntry<String, int>>>{
      'analyzer.chart.crimeType'.tr(): crimeRanked,
      'analyzer.chart.status'.tr(): statusDisplay.entries.toList(),
      'analyzer.chart.stage'.tr(): stageDisplay,
      'analyzer.chart.topSections'.tr(): summary.topSections,
      'analyzer.chart.officer'.tr(): _sorted(summary.officerCounts),
      'analyzer.chart.trend'.tr(): summary.monthlyTrend,
      if (summary.stationCounts.length >= 2)
        'analyzer.chart.station'.tr(): _sorted(summary.stationCounts),
    };

    // The duo suite above already shows trends, crime types, day-of-week,
    // stations, etc. as table+chart pairs — nothing here repeats those
    // datasets (the CP's rule: never show the same thing twice).
    final cards = <Widget>[
      // Two build-your-own charts: choose the data and the chart shape, then
      // tap to enlarge. Officers can compare any metric in any chart type.
      CustomChartCard(datasets: datasets),
      CustomChartCard(datasets: datasets, initialType: ChartType.pie),
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
        title: 'analyzer.chart.chargesheetWindow'.tr(),
        height: 300,
        child: ChargesheetWindowChart(
          within: summary.chargesheetWithin,
          overdue: summary.chargesheetOverdue,
          filed: summary.chargesheetFiled,
          withinLabel: 'analyzer.chargesheet.within'.tr(),
          overdueLabel: 'analyzer.chargesheet.overdue'.tr(),
          filedLabel: 'analyzer.chargesheet.filed'.tr(),
          emptyLabel: empty,
        ),
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
    ];

    // Lay cards out as fixed rows (2 columns on wide screens, 1 on narrow) with
    // IntrinsicHeight so both cards in a row share the taller one's height —
    // this keeps the grid evenly aligned instead of the ragged "staircase" a
    // Wrap produces when cards differ in height.
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth > 720 ? 2 : 1;
        const gap = 8.0;
        final rows = <Widget>[];
        for (var i = 0; i < cards.length; i += columns) {
          final rowChildren = <Widget>[];
          for (var j = 0; j < columns; j++) {
            if (j > 0) rowChildren.add(const SizedBox(width: gap));
            final index = i + j;
            rowChildren.add(Expanded(
              child: index < cards.length ? cards[index] : const SizedBox(),
            ));
          }
          rows.add(Padding(
            padding: const EdgeInsets.only(bottom: gap),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: rowChildren,
              ),
            ),
          ));
        }
        return Column(children: rows);
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
                for (final st in ['detected', 'undetected'])
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
