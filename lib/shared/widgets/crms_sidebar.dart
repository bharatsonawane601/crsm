import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
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
    final selected = widget.item.selected;
    final fg = selected
        ? AppColors.policeNavy
        : theme.colorScheme.onSurfaceVariant;
    final bg = selected
        ? AppColors.policeKhakiLight
        : (_hover ? theme.colorScheme.surfaceContainerHighest : Colors.transparent);

    final tile = Container(
      height: 40,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border(
          left: BorderSide(
            color: selected ? AppColors.policeKhaki : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
      child: Row(
        mainAxisAlignment:
            widget.collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Icon(widget.item.icon, size: 20, color: fg),
          if (!widget.collapsed) ...[
            const SizedBox(width: AppSpacing.s2),
            Expanded(
              child: Text(
                widget.item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppType.body.copyWith(
                  color: fg,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
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
