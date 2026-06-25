import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

/// The unified navy top bar used by the app shell: page [title] on the left,
/// an optional [center] slot (e.g. global search), and right-aligned [actions]
/// (toggles, sync, avatar). 56px tall with a dark bottom hairline.
class CrmsTopBar extends StatelessWidget implements PreferredSizeWidget {
  const CrmsTopBar({
    super.key,
    required this.title,
    this.center,
    this.actions = const [],
  });

  final String title;
  final Widget? center;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final center = this.center;
    return Material(
      color: AppColors.policeNavy,
      child: Container(
        height: 56,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.policeNavyDark)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s5),
        child: Row(
          children: [
            Text(
              title,
              style: AppType.h2.copyWith(color: Colors.white),
            ),
            if (center != null) ...[
              const SizedBox(width: AppSpacing.s8),
              Expanded(child: Center(child: center)),
              const SizedBox(width: AppSpacing.s8),
            ] else
              const Spacer(),
            for (final a in actions) ...[a, const SizedBox(width: AppSpacing.s1)],
          ],
        ),
      ),
    );
  }
}
