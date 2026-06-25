import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';

/// Centered empty state: line icon, heading, description, optional action.
class CrmsEmptyState extends StatelessWidget {
  const CrmsEmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = PhosphorIconsRegular.tray,
    this.action,
  });

  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = this.message;
    final action = this.action;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.s8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.ink300),
            const SizedBox(height: AppSpacing.itemGap),
            Text(title,
                style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.s2),
              Text(
                message,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: AppSpacing.s6),
              action,
            ],
          ],
        ),
      ),
    );
  }
}
