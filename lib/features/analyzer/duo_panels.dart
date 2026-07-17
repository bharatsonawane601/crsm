import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/typography.dart';
import 'analytics_model.dart';

/// Indian digit grouping: 8,42,00,000.
String inrFull(double v) {
  final neg = v < 0;
  var s = v.abs().round().toString();
  if (s.length > 3) {
    final tail = s.substring(s.length - 3);
    var head = s.substring(0, s.length - 3);
    final parts = <String>[];
    while (head.length > 2) {
      parts.insert(0, head.substring(head.length - 2));
      head = head.substring(0, head.length - 2);
    }
    if (head.isNotEmpty) parts.insert(0, head);
    s = '${parts.join(',')},$tail';
  }
  return '${neg ? '-' : ''}₹$s';
}

/// Compact ₹ for chart centers: ₹8.42 Cr / ₹1.94 L.
String inrShort(double v) {
  final a = v.abs();
  if (a >= 1e7) return '₹${(v / 1e7).toStringAsFixed(2)} Cr';
  if (a >= 1e5) return '₹${(v / 1e5).toStringAsFixed(2)} L';
  return inrFull(v);
}

/// A dashboard panel that shows the same data twice, the way the CP asked:
/// the table on the left and its chart on the right, simultaneously.
/// Stacks vertically on narrow screens.
class DuoPanel extends StatelessWidget {
  const DuoPanel({
    super.key,
    required this.title,
    this.subtitle,
    required this.table,
    required this.chart,
    this.chartHeight = 300,
  });

  final String title;
  final String? subtitle;
  final Widget table;
  final Widget chart;
  final double chartHeight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final header = Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700)),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle!,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ],
      ),
    );
    final scrollTable = ConstrainedBox(
      constraints: BoxConstraints(maxHeight: chartHeight + 40),
      child: SingleChildScrollView(child: table),
    );
    final sizedChart = SizedBox(
      height: chartHeight,
      child: Padding(padding: const EdgeInsets.all(16), child: chart),
    );

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header,
          const Divider(height: 1),
          LayoutBuilder(
            builder: (context, c) {
              if (c.maxWidth < 760) {
                return Column(
                  children: [scrollTable, const Divider(height: 1), sizedChart],
                );
              }
              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(flex: 5, child: scrollTable),
                    const VerticalDivider(width: 1),
                    Expanded(flex: 7, child: Center(child: sizedChart)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

/// Compact data table for the left half of a [DuoPanel]. A cell may contain
/// '\n'; lines after the first render small and dim (e.g. a Marathi subtitle).
/// Columns from [numericFrom] onward are right-aligned.
class MiniTable extends StatelessWidget {
  const MiniTable({
    super.key,
    required this.headers,
    required this.rows,
    this.numericFrom = 1,
  });

  final List<String> headers;
  final List<List<String>> rows;
  final int numericFrom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final line = theme.colorScheme.outlineVariant.withValues(alpha: 0.5);

    Widget cell(String text, {required bool head, required bool numeric}) {
      final lines = text.split('\n');
      final style = head
          ? AppType.bodySm.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: 11.5,
              letterSpacing: 0.4,
              color: theme.colorScheme.onSurfaceVariant,
            )
          : AppType.bodySm.copyWith(
              color: theme.colorScheme.onSurface,
              fontFeatures: const [FontFeature.tabularFigures()],
            );
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        child: Column(
          crossAxisAlignment:
              numeric ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(lines.first, style: style),
            for (final l in lines.skip(1))
              Text(l,
                  style: AppType.bodySm.copyWith(
                      fontSize: 11,
                      color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      );
    }

    return Table(
      columnWidths: {
        0: const FlexColumnWidth(2.2),
        for (var i = 1; i < headers.length; i++) i: const FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest
                .withValues(alpha: 0.6),
            border: Border(bottom: BorderSide(color: line)),
          ),
          children: [
            for (var i = 0; i < headers.length; i++)
              cell(headers[i].toUpperCase(),
                  head: true, numeric: i >= numericFrom),
          ],
        ),
        for (final r in rows)
          TableRow(
            decoration:
                BoxDecoration(border: Border(bottom: BorderSide(color: line))),
            children: [
              for (var i = 0; i < r.length; i++)
                cell(r[i], head: false, numeric: i >= numericFrom),
            ],
          ),
      ],
    );
  }
}

/// The muddemal donut: recovered (green) vs still missing (orange) with the
/// total in the middle. Green/orange, not green/red, so it survives
/// colorblindness — same pair as the admin panel.
class MoneyDonut extends StatelessWidget {
  const MoneyDonut({super.key, required this.lost, required this.recovered});

  final double lost;
  final double recovered;

  static const _recoveredColor = Color(0xFF199E70);
  static const _missingColor = Color(0xFFD95926);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = (lost - recovered).clamp(0, double.infinity).toDouble();

    Widget legend(Color c, String label, String value) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                    color: c, borderRadius: BorderRadius.circular(3)),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text('$label — $value',
                    style: AppType.bodySm
                        .copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ),
            ],
          ),
        );

    return Row(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              PieChart(
                PieChartData(
                  sectionsSpace: 2,
                  centerSpaceRadius: 52,
                  sections: [
                    PieChartSectionData(
                      value: recovered <= 0 ? 0.0001 : recovered,
                      color: _recoveredColor,
                      showTitle: false,
                      radius: 26,
                    ),
                    PieChartSectionData(
                      value: remaining <= 0 ? 0.0001 : remaining,
                      color: _missingColor,
                      showTitle: false,
                      radius: 26,
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(inrShort(lost),
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w800)),
                  Text('analyzer.duo.totalInvolved'.tr(),
                      style: AppType.bodySm.copyWith(
                          fontSize: 11,
                          color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              legend(_recoveredColor, 'analyzer.duo.recovered'.tr(),
                  inrShort(recovered)),
              legend(_missingColor, 'analyzer.duo.remaining'.tr(),
                  inrShort(remaining)),
            ],
          ),
        ),
      ],
    );
  }
}

/// The 🧠 insight cards — automatic findings above the charts.
class InsightsGrid extends StatelessWidget {
  const InsightsGrid({super.key, required this.insights});

  final List<BrainInsight> insights;

  static const _dowKeys = ['mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun'];

  Color _tone(String tone) => switch (tone) {
        'ok' => AppColors.successGreen,
        'warn' => AppColors.warningAmber,
        'bad' => AppColors.dangerRed,
        _ => AppColors.infoBlue,
      };

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);

    Widget card(BrainInsight ins) {
      final args = {...ins.args};
      if (ins.dow != null) {
        args['day'] = 'analyzer.dowFull.${_dowKeys[ins.dow!]}'.tr();
      }
      final accent = _tone(ins.tone);
      return Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border(
            left: BorderSide(color: accent, width: 4),
            top: BorderSide(color: theme.colorScheme.outlineVariant),
            right: BorderSide(color: theme.colorScheme.outlineVariant),
            bottom: BorderSide(color: theme.colorScheme.outlineVariant),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(ins.icon, style: const TextStyle(fontSize: 16)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'analyzer.ins.${ins.key}Title'.tr(namedArgs: args),
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'analyzer.ins.${ins.key}Body'.tr(namedArgs: args),
              style: AppType.bodySm
                  .copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, c) {
        final columns = c.maxWidth > 1080 ? 3 : (c.maxWidth > 720 ? 2 : 1);
        const gap = 8.0;
        final w = (c.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final ins in insights) SizedBox(width: w, child: card(ins)),
          ],
        );
      },
    );
  }
}
