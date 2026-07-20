import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/radii.dart';
import '../../core/theme/shadows.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

/// A single sidebar navigation entry.
class CrmsNavItem {
  const CrmsNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool selected;
}

/// Left navigation rail. 240px expanded, 64px collapsed (icon-only). White
/// surface, 1px right border. Active item: khaki-light bg, navy text, 3px khaki
/// left indicator. Hover: subtle bg.
class CrmsSidebar extends StatelessWidget {
  const CrmsSidebar({
    super.key,
    required this.items,
    this.collapsed = false,
    this.header,
    this.footer,
  });

  final List<CrmsNavItem> items;
  final bool collapsed;
  final Widget? header;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: collapsed ? 64 : 240,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(right: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        children: [
          ?header,
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.s2, vertical: AppSpacing.s2),
              children: [
                for (final item in items)
                  _NavTile(item: item, collapsed: collapsed),
              ],
            ),
          ),
          ?footer,
        ],
      ),
    );
  }
}

class _NavTile extends StatefulWidget {
  const _NavTile({required this.item, required this.collapsed});
  final CrmsNavItem item;
  final bool collapsed;

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = theme.brightness == Brightness.dark;
    final selected = widget.item.selected;
    // Selected reads as a solid navy pill — the strongest single cue in the
    // chrome, so the current section is obvious at a glance instead of being a
    // pale tint you have to hunt for.
    final fg = selected
        ? Colors.white
        : (_hover
            ? (dark ? AppColors.darkInk : AppColors.ink900)
            : theme.colorScheme.onSurfaceVariant);

    final tile = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      height: 42,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        gradient: selected
            ? const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [AppColors.policeNavy, AppColors.policeNavyDark],
              )
            : null,
        color: selected
            ? null
            : (_hover
                ? AppColors.tint(AppColors.policeNavy, dark ? 0.16 : 0.06)
                : Colors.transparent),
        borderRadius: BorderRadius.circular(AppRadii.md),
        boxShadow: selected ? AppShadows.card : null,
      ),
      padding: EdgeInsets.symmetric(
          horizontal: widget.collapsed ? 0 : AppSpacing.s3),
      child: Row(
        mainAxisAlignment:
            widget.collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          // Khaki bead on the active item: the uniform accent still marks the
          // selection, but as a detail on the pill rather than a stray edge.
          if (!widget.collapsed)
            AnimatedContainer(
              duration: const Duration(milliseconds: 120),
              width: 3,
              height: selected ? 18 : 0,
              decoration: BoxDecoration(
                color: AppColors.policeKhaki,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (!widget.collapsed) const SizedBox(width: AppSpacing.s2),
          Icon(widget.item.icon, size: 19, color: fg),
          if (!widget.collapsed) ...[
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: Text(
                widget.item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.body.copyWith(
                  color: fg,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.item.onTap,
        child: widget.collapsed
            ? Tooltip(message: widget.item.label, child: tile)
            : tile,
      ),
    );
  }
}
