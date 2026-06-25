import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/radii.dart';
import '../../core/theme/shadows.dart';
import '../../core/theme/spacing.dart';

/// Bordered content card (no shadow by default — separation via 1px border).
/// Set [elevated] for dashboard KPI cards (subtle shadow + khaki top accent).
class CrmsCard extends StatelessWidget {
  const CrmsCard({
    super.key,
    required this.child,
    this.title,
    this.trailing,
    this.padding = const EdgeInsets.all(AppSpacing.cardPadding),
    this.onTap,
    this.elevated = false,
    this.accent = false,
  });

  final Widget child;
  final String? title;
  final Widget? trailing;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  /// KPI-style card: adds a subtle shadow.
  final bool elevated;

  /// Adds a 4px khaki top accent bar (dashboard KPIs).
  final bool accent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = theme.dividerColor;
    final titleText = title;
    final trailingWidget = trailing;

    Widget body = Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (titleText != null) ...[
            Row(
              children: [
                Expanded(
                    child: Text(titleText, style: theme.textTheme.titleLarge)),
                ?trailingWidget,
              ],
            ),
            const SizedBox(height: AppSpacing.itemGap),
          ],
          child,
        ],
      ),
    );

    if (accent) {
      body = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4,
            decoration: const BoxDecoration(
              color: AppColors.policeKhaki,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(AppRadii.lg)),
            ),
          ),
          body,
        ],
      );
    }

    final decorated = DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadii.brLg,
        border: Border.all(color: border),
        boxShadow: elevated ? AppShadows.card : null,
      ),
      child: ClipRRect(borderRadius: AppRadii.brLg, child: body),
    );

    if (onTap == null) return decorated;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: AppRadii.brLg,
        onTap: onTap,
        child: decorated,
      ),
    );
  }
}
