import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/radii.dart';
import '../../core/theme/spacing.dart';

enum CrmsModalSize { small, medium, large }

/// A centered modal with a header (title + close X), scrollable body, and a
/// right-aligned footer separated by a 1px top border. Backdrop is dimmed +
/// blurred via the theme/dialog defaults.
class CrmsModal extends StatelessWidget {
  const CrmsModal({
    super.key,
    required this.title,
    required this.body,
    this.actions = const [],
    this.size = CrmsModalSize.medium,
  });

  final String title;
  final Widget body;
  final List<Widget> actions;
  final CrmsModalSize size;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget body,
    List<Widget> actions = const [],
    CrmsModalSize size = CrmsModalSize.medium,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: AppColors.ink900.withValues(alpha: 0.4),
      builder: (_) =>
          CrmsModal(title: title, body: body, actions: actions, size: size),
    );
  }

  double get _maxWidth => switch (size) {
        CrmsModalSize.small => 560,
        CrmsModalSize.medium => 720,
        CrmsModalSize.large => 960,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.brXl),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: _maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s6),
              child: Row(
                children: [
                  Expanded(
                      child: Text(title, style: theme.textTheme.titleLarge)),
                  IconButton(
                    tooltip: 'common.cancel'.tr(),
                    icon: const Icon(PhosphorIconsRegular.x, size: 20),
                    onPressed: () => Navigator.of(context).pop(),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.s6, 0, AppSpacing.s6, AppSpacing.s6),
                child: body,
              ),
            ),
            // Footer
            if (actions.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.s4),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: theme.dividerColor)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(width: AppSpacing.s3),
                      actions[i],
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
