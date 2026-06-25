import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/radii.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';

/// Column definition for [CrmsTable].
class CrmsColumn<T> {
  const CrmsColumn({
    required this.label,
    required this.cell,
    this.width,
    this.flex = 1,
    this.numeric = false,
    this.sortValue,
  });

  final String label;
  final Widget Function(T row) cell;

  /// Fixed width; if null the column flexes by [flex].
  final double? width;
  final int flex;
  final bool numeric;

  /// When non-null the header is clickable and the table reports sort requests
  /// for this column via [CrmsTable.onSort]. Returns the comparable used to
  /// order rows; nulls always sort last regardless of direction.
  final Comparable<Object>? Function(T row)? sortValue;
}

/// CRMS data table: uppercase caption header on a subtle bg, 56px rows with
/// alternating backgrounds, hover + selection highlight (2px khaki indicator),
/// 1px row separators, sticky header. Wrap in a sized parent (it `Expanded`s
/// its body) or set [shrinkWrap] to size to content.
class CrmsTable<T> extends StatelessWidget {
  const CrmsTable({
    super.key,
    required this.columns,
    required this.items,
    this.onRowTap,
    this.isSelected,
    this.shrinkWrap = false,
    this.rowHeight = 56,
    this.sortColumnIndex,
    this.sortAscending = true,
    this.onSort,
  });

  final List<CrmsColumn<T>> columns;
  final List<T> items;
  final void Function(T row)? onRowTap;
  final bool Function(T row)? isSelected;
  final bool shrinkWrap;
  final double rowHeight;

  /// Index of the currently sorted column (shows a direction caret).
  final int? sortColumnIndex;
  final bool sortAscending;

  /// Called with the tapped column's index when a sortable header is clicked.
  final void Function(int columnIndex)? onSort;

  Widget _layout(List<Widget> cells) {
    return Row(
      children: [
        for (var i = 0; i < columns.length; i++)
          columns[i].width != null
              ? SizedBox(width: columns[i].width, child: cells[i])
              : Expanded(flex: columns[i].flex, child: cells[i]),
      ],
    );
  }

  Widget _header(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s4, vertical: AppSpacing.s3),
      child: _layout([
        for (var i = 0; i < columns.length; i++)
          Align(
            alignment: columns[i].numeric
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: _headerLabel(theme, columns[i], i),
          ),
      ]),
    );
  }

  Widget _headerLabel(ThemeData theme, CrmsColumn<T> c, int index) {
    final sortable = c.sortValue != null && onSort != null;
    final active = index == sortColumnIndex;
    final text = Text(
      c.label.toUpperCase(),
      style: AppType.caption.copyWith(
        color: active
            ? theme.colorScheme.onSurface
            : theme.colorScheme.onSurfaceVariant,
        letterSpacing: 0.04 * 12,
        fontWeight: active ? FontWeight.w600 : null,
      ),
    );
    if (!sortable) return text;
    return InkWell(
      onTap: () => onSort!(index),
      borderRadius: AppRadii.brSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(child: text),
            const SizedBox(width: 2),
            Icon(
              active
                  ? (sortAscending ? Icons.arrow_upward : Icons.arrow_downward)
                  : Icons.unfold_more,
              size: 13,
              color: active
                  ? AppColors.policeKhaki
                  : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final list = ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: shrinkWrap ? const NeverScrollableScrollPhysics() : null,
      itemCount: items.length,
      separatorBuilder: (_, _) => Divider(height: 1, color: theme.dividerColor),
      itemBuilder: (context, index) {
        final row = items[index];
        final selected = isSelected?.call(row) ?? false;
        final zebra = index.isOdd;
        return _Row(
          height: rowHeight,
          selected: selected,
          zebra: zebra,
          onTap: onRowTap == null ? null : () => onRowTap!(row),
          child: _layout([
            for (final c in columns)
              Align(
                alignment:
                    c.numeric ? Alignment.centerRight : Alignment.centerLeft,
                child: DefaultTextStyle.merge(
                  style: theme.textTheme.bodyMedium!,
                  child: c.cell(row),
                ),
              ),
          ]),
        );
      },
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: AppRadii.brLg,
      ),
      child: ClipRRect(
        borderRadius: AppRadii.brLg,
        child: Column(
          mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
          children: [
            _header(context),
            Divider(height: 1, color: theme.dividerColor),
            if (shrinkWrap) list else Expanded(child: list),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatefulWidget {
  const _Row({
    required this.child,
    required this.height,
    required this.selected,
    required this.zebra,
    this.onTap,
  });

  final Widget child;
  final double height;
  final bool selected;
  final bool zebra;
  final VoidCallback? onTap;

  @override
  State<_Row> createState() => _RowState();
}

class _RowState extends State<_Row> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color bg;
    if (widget.selected) {
      bg = AppColors.policeKhakiLight;
    } else if (_hover) {
      bg = AppColors.policeKhakiLight.withValues(alpha: 0.4);
    } else if (widget.zebra) {
      bg = theme.scaffoldBackgroundColor;
    } else {
      bg = theme.colorScheme.surface;
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      cursor: widget.onTap == null
          ? MouseCursor.defer
          : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          height: widget.height,
          decoration: BoxDecoration(
            color: bg,
            border: Border(
              left: BorderSide(
                color: widget.selected
                    ? AppColors.policeKhaki
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
          alignment: Alignment.centerLeft,
          child: widget.child,
        ),
      ),
    );
  }
}
