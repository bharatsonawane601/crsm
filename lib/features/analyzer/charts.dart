import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/crms.dart';

/// Categorical chart palette — a distinct, serious colour per crime / category.
const List<Color> kChartPalette = [
  AppColors.policeNavy,
  AppColors.successGreen,
  AppColors.warningAmber,
  AppColors.infoBlue,
  AppColors.dangerRed,
  AppColors.policeKhaki,
  Color(0xFF00838F), // teal
  Color(0xFF6A1B9A), // purple
  Color(0xFFAD1457), // magenta
  Color(0xFF283593), // indigo
  Color(0xFF4E342E), // brown
  Color(0xFF827717), // olive
];

/// A KPI tile: khaki top accent, caption label, large display number.
class KpiCard extends StatelessWidget {
  const KpiCard({super.key, required this.label, required this.value, this.color});

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 180,
      child: CrmsCard(
        elevated: true,
        accent: true,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(),
                style: AppType.caption.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.04 * 12,
                )),
            const SizedBox(height: 8),
            Text(value,
                style: AppType.display.copyWith(
                  fontSize: 28,
                  color: color ?? AppColors.policeNavy,
                )),
          ],
        ),
      ),
    );
  }
}

/// Card wrapper giving every chart a title and consistent height.
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.height = 240,
  });

  final String title;
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) {
    return CrmsCard(
      title: title,
      child: SizedBox(height: height, child: child),
    );
  }
}

/// The shapes a metric can be drawn as. The officer picks per card.
enum ChartType { bar, columns, line, area, pie }

extension _ChartTypeMeta on ChartType {
  IconData get icon => switch (this) {
        ChartType.bar => Icons.bar_chart,
        ChartType.columns => Icons.equalizer,
        ChartType.line => Icons.show_chart,
        ChartType.area => Icons.area_chart,
        ChartType.pie => Icons.pie_chart,
      };
  String get labelKey => 'analyzer.chartType.$name';
}

/// A chart card whose chart **type is chosen by the user** (bar / columns /
/// line / area / pie) from a small menu in the corner. The same labelled-count
/// data ([entries]) is redrawn in the selected shape — so an officer can view
/// any metric the way they prefer.
class ConfigurableChartCard extends StatefulWidget {
  const ConfigurableChartCard({
    super.key,
    required this.title,
    required this.entries,
    this.initialType = ChartType.bar,
    this.types = const [
      ChartType.bar,
      ChartType.columns,
      ChartType.line,
      ChartType.area,
      ChartType.pie,
    ],
    this.height = 240,
    this.emptyLabel = '—',
  });

  final String title;
  final List<MapEntry<String, int>> entries;
  final ChartType initialType;
  final List<ChartType> types;
  final double height;
  final String emptyLabel;

  @override
  State<ConfigurableChartCard> createState() => _ConfigurableChartCardState();
}

class _ConfigurableChartCardState extends State<ConfigurableChartCard> {
  late ChartType _type = widget.initialType;

  Widget _chart() {
    switch (_type) {
      case ChartType.bar:
        return RankedBars(entries: widget.entries, emptyLabel: widget.emptyLabel);
      case ChartType.columns:
        return ColumnChart(entries: widget.entries, emptyLabel: widget.emptyLabel);
      case ChartType.line:
        return TrendLine(entries: widget.entries, emptyLabel: widget.emptyLabel);
      case ChartType.area:
        return AreaTrend(entries: widget.entries, emptyLabel: widget.emptyLabel);
      case ChartType.pie:
        return CountPie(
          data: {for (final e in widget.entries) e.key: e.value},
          emptyLabel: widget.emptyLabel,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CrmsCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(widget.title,
                    style: Theme.of(context).textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis),
              ),
              PopupMenuButton<ChartType>(
                tooltip: 'analyzer.chartType.choose'.tr(),
                initialValue: _type,
                icon: Icon(_type.icon, size: 20),
                onSelected: (t) => setState(() => _type = t),
                itemBuilder: (_) => [
                  for (final t in widget.types)
                    PopupMenuItem(
                      value: t,
                      child: Row(
                        children: [
                          Icon(t.icon, size: 18),
                          const SizedBox(width: 8),
                          Text(t.labelKey.tr()),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s2),
          SizedBox(height: widget.height, child: _chart()),
        ],
      ),
    );
  }
}

class EmptyChart extends StatelessWidget {
  const EmptyChart({super.key, required this.label});
  final String label;

  @override
  Widget build(BuildContext context) =>
      Center(child: Text(label, style: Theme.of(context).textTheme.bodySmall));
}

/// Left axis showing only whole numbers (no 0.2 / 0.4 fractional ticks).
AxisTitles _intLeftTitles(int maxY) {
  final interval = (maxY / 4).ceil().clamp(1, 1 << 30).toDouble();
  return AxisTitles(
    sideTitles: SideTitles(
      showTitles: true,
      reservedSize: 28,
      interval: interval,
      getTitlesWidget: (value, meta) {
        if (value % interval != 0) return const SizedBox.shrink();
        return Text('${value.toInt()}', style: const TextStyle(fontSize: 10));
      },
    ),
  );
}

/// Ranked horizontal bars for labeled categories (sections, officers, types).
/// Cleaner than an axis-labeled bar chart for long Marathi labels.
class RankedBars extends StatelessWidget {
  const RankedBars({
    super.key,
    required this.entries,
    this.maxRows = 6,
    this.emptyLabel = '—',
  });

  final List<MapEntry<String, int>> entries;
  final int maxRows;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return EmptyChart(label: emptyLabel);
    final theme = Theme.of(context);
    final shown = entries.take(maxRows).toList();
    final max = shown.first.value.clamp(1, 1 << 30);
    // Single brand color for all bars — bar length encodes the value, not hue.
    final rail = theme.colorScheme.surfaceContainerHighest;
    return ListView(
      children: [
        for (var i = 0; i < shown.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(shown[i].key,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.bodySm
                              .copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ),
                    Text('${shown[i].value}',
                        style: AppType.bodySm.copyWith(
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: shown[i].value / max,
                    minHeight: 8,
                    backgroundColor: rail,
                    color: kChartPalette[i % kChartPalette.length],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// Pie chart for a small set of labeled counts, with a legend.
class CountPie extends StatelessWidget {
  const CountPie({super.key, required this.data, required this.emptyLabel});

  final Map<String, int> data;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    final entries = data.entries.where((e) => e.value > 0).toList();
    if (entries.isEmpty) return EmptyChart(label: emptyLabel);

    return Row(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 28,
              sections: [
                for (var i = 0; i < entries.length; i++)
                  PieChartSectionData(
                    value: entries[i].value.toDouble(),
                    title: '${entries[i].value}',
                    radius: 56,
                    color: kChartPalette[i % kChartPalette.length],
                    titleStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < entries.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: kChartPalette[i % kChartPalette.length],
                              borderRadius: BorderRadius.circular(2),
                            )),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text('${entries[i].key} (${entries[i].value})',
                              maxLines: 1, overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Line chart of a monthly trend ("yyyy-MM" -> count).
class TrendLine extends StatelessWidget {
  const TrendLine({super.key, required this.entries, required this.emptyLabel});

  final List<MapEntry<String, int>> entries;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return EmptyChart(label: emptyLabel);
    if (entries.length < 2) {
      return EmptyChart(label: 'analyzer.chart.trendNeedsData'.tr());
    }
    final spots = [
      for (var i = 0; i < entries.length; i++)
        FlSpot(i.toDouble(), entries[i].value.toDouble()),
    ];
    final maxY = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: (maxY + 1).toDouble(),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: _intLeftTitles(maxY),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: (entries.length / 4).ceilToDouble().clamp(1, 1000),
              getTitlesWidget: (value, meta) {
                final i = value.round();
                if (i < 0 || i >= entries.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(entries[i].key.substring(2),
                      style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: kChartPalette.first,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}

/// Bar chart of day-of-week counts (Mon..Sun).
class DayOfWeekBars extends StatelessWidget {
  const DayOfWeekBars({super.key, required this.counts, required this.labels});

  final List<int> counts; // length 7, Mon..Sun
  final List<String> labels; // length 7

  @override
  Widget build(BuildContext context) {
    final maxY = (counts.isEmpty ? 0 : counts.reduce((a, b) => a > b ? a : b));
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: (maxY + 1).toDouble(),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: _intLeftTitles(maxY),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 24,
              getTitlesWidget: (value, meta) {
                final i = value.round();
                if (i < 0 || i >= labels.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child:
                      Text(labels[i], style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < counts.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: counts[i].toDouble(),
                  color: kChartPalette[i % kChartPalette.length],
                  width: 16,
                  borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(4)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// A small colour swatch + label chip, used for index legends below charts
/// whose x-axis shows numbers (long Marathi labels never fit on the axis).
class _LegendChip extends StatelessWidget {
  const _LegendChip({required this.color, required this.text});
  final Color color;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(2)),
        ),
        const SizedBox(width: 4),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 150),
          child: Text(text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 10)),
        ),
      ],
    );
  }
}

/// Wrapped legend mapping "1, 2, 3…" axis indices to category names.
class _IndexLegend extends StatelessWidget {
  const _IndexLegend({required this.labels});
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 4,
      children: [
        for (var i = 0; i < labels.length; i++)
          _LegendChip(
            color: kChartPalette[i % kChartPalette.length],
            text: '${i + 1}. ${labels[i]}',
          ),
      ],
    );
  }
}

/// Simple Mon..Sun / numbered x-axis title widget builder for index charts.
AxisTitles _indexBottomTitles(int count) => AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: 20,
        getTitlesWidget: (value, meta) {
          final i = value.round();
          if (i < 0 || i >= count || value != i.toDouble()) {
            return const SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text('${i + 1}', style: const TextStyle(fontSize: 10)),
          );
        },
      ),
    );

/// Filled area chart of a monthly trend ("yyyy-MM" -> count).
class AreaTrend extends StatelessWidget {
  const AreaTrend({super.key, required this.entries, required this.emptyLabel});

  final List<MapEntry<String, int>> entries;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return EmptyChart(label: emptyLabel);
    if (entries.length < 2) {
      return EmptyChart(label: 'analyzer.chart.trendNeedsData'.tr());
    }
    final spots = [
      for (var i = 0; i < entries.length; i++)
        FlSpot(i.toDouble(), entries[i].value.toDouble()),
    ];
    final maxY = entries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: (maxY + 1).toDouble(),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: _intLeftTitles(maxY),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: (entries.length / 4).ceilToDouble().clamp(1, 1000),
              getTitlesWidget: (value, meta) {
                final i = value.round();
                if (i < 0 || i >= entries.length) return const SizedBox();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(entries[i].key.substring(2),
                      style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: AppColors.infoBlue,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.infoBlue.withValues(alpha: 0.35),
                  AppColors.infoBlue.withValues(alpha: 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Vertical column chart of labeled counts (one colour per category), with a
/// numbered x-axis and a legend underneath.
class ColumnChart extends StatelessWidget {
  const ColumnChart({
    super.key,
    required this.entries,
    this.maxBars = 8,
    this.emptyLabel = '—',
  });

  final List<MapEntry<String, int>> entries;
  final int maxBars;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return EmptyChart(label: emptyLabel);
    final shown = entries.take(maxBars).toList();
    final maxY = shown.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (maxY + 1).toDouble(),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: _intLeftTitles(maxY),
                bottomTitles: _indexBottomTitles(shown.length),
              ),
              barGroups: [
                for (var i = 0; i < shown.length; i++)
                  BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: shown[i].value.toDouble(),
                        color: kChartPalette[i % kChartPalette.length],
                        width: 16,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(4)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _IndexLegend(labels: [for (final e in shown) e.key]),
      ],
    );
  }
}

/// Stacked column per crime type: solved (green) atop open (red).
class StackedColumn extends StatelessWidget {
  const StackedColumn({
    super.key,
    required this.types,
    required this.solvedByType,
    required this.openByType,
    required this.solvedLabel,
    required this.openLabel,
    this.maxBars = 8,
    this.emptyLabel = '—',
  });

  final List<String> types;
  final Map<String, int> solvedByType;
  final Map<String, int> openByType;
  final String solvedLabel;
  final String openLabel;
  final int maxBars;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (types.isEmpty) return EmptyChart(label: emptyLabel);
    final shown = types.take(maxBars).toList();
    var maxY = 0;
    for (final t in shown) {
      final tot = (solvedByType[t] ?? 0) + (openByType[t] ?? 0);
      if (tot > maxY) maxY = tot;
    }

    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (maxY + 1).toDouble(),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: _intLeftTitles(maxY),
                bottomTitles: _indexBottomTitles(shown.length),
              ),
              barGroups: [
                for (var i = 0; i < shown.length; i++)
                  () {
                    final solved = (solvedByType[shown[i]] ?? 0).toDouble();
                    final open = (openByType[shown[i]] ?? 0).toDouble();
                    return BarChartGroupData(
                      x: i,
                      barRods: [
                        BarChartRodData(
                          toY: solved + open,
                          width: 16,
                          borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(4)),
                          rodStackItems: [
                            BarChartRodStackItem(
                                0, solved, AppColors.successGreen),
                            BarChartRodStackItem(
                                solved, solved + open, AppColors.dangerRed),
                          ],
                        ),
                      ],
                    );
                  }(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            _LegendChip(color: AppColors.successGreen, text: solvedLabel),
            _LegendChip(color: AppColors.dangerRed, text: openLabel),
          ],
        ),
        const SizedBox(height: 4),
        _IndexLegend(labels: shown),
      ],
    );
  }
}

/// Grouped (side-by-side) columns comparing solved vs open per crime type.
class ComparisonColumns extends StatelessWidget {
  const ComparisonColumns({
    super.key,
    required this.types,
    required this.solvedByType,
    required this.openByType,
    required this.solvedLabel,
    required this.openLabel,
    this.maxBars = 6,
    this.emptyLabel = '—',
  });

  final List<String> types;
  final Map<String, int> solvedByType;
  final Map<String, int> openByType;
  final String solvedLabel;
  final String openLabel;
  final int maxBars;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (types.isEmpty) return EmptyChart(label: emptyLabel);
    final shown = types.take(maxBars).toList();
    var maxY = 0;
    for (final t in shown) {
      maxY = math.max(maxY, math.max(solvedByType[t] ?? 0, openByType[t] ?? 0));
    }

    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: (maxY + 1).toDouble(),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: _intLeftTitles(maxY),
                bottomTitles: _indexBottomTitles(shown.length),
              ),
              barGroups: [
                for (var i = 0; i < shown.length; i++)
                  BarChartGroupData(
                    x: i,
                    barsSpace: 4,
                    barRods: [
                      BarChartRodData(
                        toY: (solvedByType[shown[i]] ?? 0).toDouble(),
                        color: AppColors.successGreen,
                        width: 10,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(3)),
                      ),
                      BarChartRodData(
                        toY: (openByType[shown[i]] ?? 0).toDouble(),
                        color: AppColors.dangerRed,
                        width: 10,
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(3)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            _LegendChip(color: AppColors.successGreen, text: solvedLabel),
            _LegendChip(color: AppColors.dangerRed, text: openLabel),
          ],
        ),
        const SizedBox(height: 4),
        _IndexLegend(labels: shown),
      ],
    );
  }
}

/// Radar / spider chart of the top crime types by count.
class RadarCrime extends StatelessWidget {
  const RadarCrime({
    super.key,
    required this.entries,
    this.maxAxes = 6,
    this.emptyLabel = '—',
  });

  final List<MapEntry<String, int>> entries;
  final int maxAxes;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    // RadarChart needs at least 3 axes to render a polygon.
    final shown = entries.take(maxAxes).toList();
    if (shown.length < 3) return EmptyChart(label: emptyLabel);

    return Column(
      children: [
        Expanded(
          child: RadarChart(
            RadarChartData(
              radarShape: RadarShape.polygon,
              tickCount: 4,
              ticksTextStyle:
                  const TextStyle(color: Colors.transparent, fontSize: 8),
              radarBorderData:
                  const BorderSide(color: Colors.transparent),
              gridBorderData:
                  BorderSide(color: Colors.grey.shade300, width: 1),
              tickBorderData:
                  BorderSide(color: Colors.grey.shade300, width: 1),
              titlePositionPercentageOffset: 0.12,
              getTitle: (index, angle) =>
                  RadarChartTitle(text: '${index + 1}'),
              dataSets: [
                RadarDataSet(
                  fillColor: AppColors.policeNavy.withValues(alpha: 0.25),
                  borderColor: AppColors.policeNavy,
                  borderWidth: 2,
                  entryRadius: 3,
                  dataEntries: [
                    for (final e in shown) RadarEntry(value: e.value.toDouble()),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _IndexLegend(labels: [for (final e in shown) e.key]),
      ],
    );
  }
}

/// Bubble chart: each crime type is a bubble whose area scales with its count.
class BubbleCrime extends StatelessWidget {
  const BubbleCrime({
    super.key,
    required this.entries,
    this.maxBubbles = 8,
    this.emptyLabel = '—',
  });

  final List<MapEntry<String, int>> entries;
  final int maxBubbles;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return EmptyChart(label: emptyLabel);
    final shown = entries.take(maxBubbles).toList();
    final maxV = shown.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Expanded(
          child: ScatterChart(
            ScatterChartData(
              minX: -0.5,
              maxX: shown.length - 0.5,
              minY: 0,
              maxY: (maxV + 1).toDouble(),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: _intLeftTitles(maxV),
                bottomTitles: _indexBottomTitles(shown.length),
              ),
              scatterSpots: [
                for (var i = 0; i < shown.length; i++)
                  ScatterSpot(
                    i.toDouble(),
                    shown[i].value.toDouble(),
                    dotPainter: FlDotCirclePainter(
                      color: kChartPalette[i % kChartPalette.length]
                          .withValues(alpha: 0.7),
                      radius: 8 + 22 * (shown[i].value / maxV),
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _IndexLegend(labels: [for (final e in shown) e.key]),
      ],
    );
  }
}

/// Scatter plot of crime type counts (one point per type).
class ScatterCrime extends StatelessWidget {
  const ScatterCrime({
    super.key,
    required this.entries,
    this.maxPoints = 10,
    this.emptyLabel = '—',
  });

  final List<MapEntry<String, int>> entries;
  final int maxPoints;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (entries.isEmpty) return EmptyChart(label: emptyLabel);
    final shown = entries.take(maxPoints).toList();
    final maxV = shown.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Column(
      children: [
        Expanded(
          child: ScatterChart(
            ScatterChartData(
              minX: -0.5,
              maxX: shown.length - 0.5,
              minY: 0,
              maxY: (maxV + 1).toDouble(),
              gridData: const FlGridData(show: true),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false)),
                leftTitles: _intLeftTitles(maxV),
                bottomTitles: _indexBottomTitles(shown.length),
              ),
              scatterSpots: [
                for (var i = 0; i < shown.length; i++)
                  ScatterSpot(
                    i.toDouble(),
                    shown[i].value.toDouble(),
                    dotPainter: FlDotCirclePainter(
                      color: kChartPalette[i % kChartPalette.length],
                      radius: 6,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        _IndexLegend(labels: [for (final e in shown) e.key]),
      ],
    );
  }
}

/// Semicircular gauge showing a percentage (e.g. solved rate).
class GaugeChart extends StatelessWidget {
  const GaugeChart({
    super.key,
    required this.percent,
    required this.label,
    this.color = AppColors.successGreen,
  });

  /// 0..100.
  final double percent;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pct = percent.clamp(0, 100).toDouble();
    return LayoutBuilder(
      builder: (context, c) {
        return CustomPaint(
          painter: _GaugePainter(
            percent: pct,
            color: color,
            track: theme.colorScheme.surfaceContainerHighest,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                Text('${pct.toStringAsFixed(0)}%',
                    style: AppType.display
                        .copyWith(fontSize: 32, color: color)),
                const SizedBox(height: 2),
                Text(label,
                    textAlign: TextAlign.center,
                    style: AppType.caption.copyWith(
                        color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter(
      {required this.percent, required this.color, required this.track});

  final double percent;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    const stroke = 18.0;
    final radius = math.min(size.width / 2, size.height) - stroke;
    final center = Offset(size.width / 2, size.height * 0.85);
    final rect = Rect.fromCircle(center: center, radius: radius);

    final base = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = track;
    final fill = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round
      ..color = color;

    // Half circle from 180° to 360°.
    canvas.drawArc(rect, math.pi, math.pi, false, base);
    canvas.drawArc(rect, math.pi, math.pi * (percent / 100), false, fill);
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.percent != percent || old.color != color || old.track != track;
}
