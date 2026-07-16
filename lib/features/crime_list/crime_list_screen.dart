import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/typography.dart';
import '../../shared/widgets/crms.dart';
import '../crime_entry/crime_entry_screen.dart';
import '../crime_entry/crime_repository.dart';
import '../portal/central_upload_controller.dart';
import '../reports/report_generate_sheet.dart';
import 'crime_detail_screen.dart';
import 'crime_list_provider.dart';
import 'models/crime_list_item.dart';

final _dateFmt = DateFormat('dd-MM-yyyy');

const _statuses = ['detected', 'undetected'];
const _perPageOptions = [50, 100, 200];

/// Crime Records — sortable, paginated data table with filter chips. Post-login
/// "Crime Records" section of the shell. Search is driven by the top bar.
class CrimeListScreen extends ConsumerStatefulWidget {
  const CrimeListScreen({super.key});

  @override
  ConsumerState<CrimeListScreen> createState() => _CrimeListScreenState();
}

class _CrimeListScreenState extends ConsumerState<CrimeListScreen> {
  String? _status; // null = all
  DateTime? _from;
  DateTime? _to;
  int _page = 0;
  int _perPage = 50;

  // Which fields free-text search targets. Empty = search every field.
  final Set<CrimeSearchField> _searchFields = {};

  // Sort state — default newest crime first (the Date column, descending).
  int _sortCol = 1;
  bool _sortAsc = false;

  void _resetPage() => _page = 0;

  /// Best available date for an item: registration date, else offence date,
  /// else Jan 1 of the record's year — so imported records that only carry a
  /// year still sort and filter into the right period.
  static DateTime _effectiveDate(CrimeListItem item) {
    final c = item.crime;
    return c.dateRegistered ?? c.dateOccurred ?? DateTime(c.year);
  }

  List<CrimeListItem> _apply(List<CrimeListItem> items, String search) {
    final filtered = items.where((item) {
      if (!item.matches(search, fields: _searchFields)) return false;
      if (_status != null && item.crime.status != _status) return false;
      final reg = _effectiveDate(item);
      if (_from != null && reg.isBefore(_from!)) return false;
      if (_to != null) {
        // Inclusive of the whole "to" day: [to 00:00, to+1day 00:00).
        final end = DateTime(_to!.year, _to!.month, _to!.day)
            .add(const Duration(days: 1));
        if (!reg.isBefore(end)) return false;
      }
      return true;
    }).toList();
    _sort(filtered);
    return filtered;
  }

  void _sort(List<CrimeListItem> items) {
    final col = _columns[_sortCol];
    final getter = col.sortValue;
    if (getter == null) return;
    items.sort((a, b) {
      final va = getter(a);
      final vb = getter(b);
      // Nulls always sort last, regardless of direction.
      if (va == null && vb == null) return 0;
      if (va == null) return 1;
      if (vb == null) return -1;
      final cmp = va.compareTo(vb);
      return _sortAsc ? cmp : -cmp;
    });
  }

  void _onSort(int columnIndex) {
    setState(() {
      if (_sortCol == columnIndex) {
        _sortAsc = !_sortAsc;
      } else {
        _sortCol = columnIndex;
        _sortAsc = true;
      }
      _resetPage();
    });
  }

  Future<void> _pickDate({required bool isFrom}) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: (isFrom ? _from : _to) ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) {
      setState(() {
        isFrom ? _from = picked : _to = picked;
        _resetPage();
      });
    }
  }

  void _clear() => setState(() {
        _status = null;
        _from = null;
        _to = null;
        _resetPage();
      });

  static String _fieldLabel(CrimeSearchField f) => switch (f) {
        CrimeSearchField.fir => 'list.col.fir'.tr(),
        CrimeSearchField.crimeType => 'crime.info.crimeType'.tr(),
        CrimeSearchField.accused => 'list.col.accused'.tr(),
        CrimeSearchField.victim => 'list.col.complainant'.tr(),
        CrimeSearchField.section => 'list.col.sections'.tr(),
        CrimeSearchField.date => 'list.col.date'.tr(),
      };

  Future<void> _pickSearchFields() async {
    final selected = {..._searchFields};
    final result = await showDialog<Set<CrimeSearchField>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text('list.searchIn'.tr()),
          content: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => setLocal(selected.clear),
                    child: Text('list.searchAllFields'.tr()),
                  ),
                ),
                for (final f in CrimeSearchField.values)
                  CheckboxListTile(
                    dense: true,
                    value: selected.contains(f),
                    title: Text(_fieldLabel(f)),
                    onChanged: (v) => setLocal(() =>
                        v == true ? selected.add(f) : selected.remove(f)),
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
    if (result != null) {
      setState(() {
        _searchFields
          ..clear()
          ..addAll(result);
        _resetPage();
      });
    }
  }

  Future<void> _delete(int id) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('crime.deleteTitle'.tr()),
        content: Text('crime.deleteBody'.tr()),
        actions: [
          CrmsButton(
            label: 'common.cancel'.tr(),
            variant: CrmsButtonVariant.ghost,
            onPressed: () => Navigator.pop(ctx, false),
          ),
          CrmsButton(
            label: 'common.delete'.tr(),
            variant: CrmsButtonVariant.danger,
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
    if (ok == true) {
      final deleted = await ref.read(crimeRepositoryProvider).deleteCrime(id);
      if (deleted != null) {
        // Report to the central store so the deletion is logged & the central
        // copy removed. Fire-and-forget — never blocks the UI.
        ref.read(centralUploadControllerProvider.notifier).reportDeletion(deleted);
      }
    }
  }

  void _open(int id) => Navigator.of(context).push(
        MaterialPageRoute<Object?>(
            builder: (_) => CrimeDetailScreen(crimeId: id)),
      );

  void _edit(int id) => Navigator.of(context).push(
        MaterialPageRoute<Object?>(
            builder: (_) => CrimeEntryScreen(crimeId: id)),
      );

  @override
  Widget build(BuildContext context) {
    final asyncList = ref.watch(crimeListProvider);
    final search = ref.watch(crimeSearchProvider);

    return Scaffold(
      body: asyncList.when(
        loading: () => const CrmsTableSkeleton(),
        error: (e, _) => Center(child: Text('list.loadError'.tr())),
        data: (items) {
          if (items.isEmpty) {
            return CrmsEmptyState(
              icon: PhosphorIconsRegular.folderOpen,
              title: 'list.empty'.tr(),
              action: CrmsButton(
                label: 'home.newCrime'.tr(),
                icon: PhosphorIconsRegular.plus,
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<Object?>(
                      builder: (_) => const CrimeEntryScreen()),
                ),
              ),
            );
          }
          final filtered = _apply(items, search);
          final pageCount = (filtered.length / _perPage).ceil().clamp(1, 1 << 30);
          if (_page >= pageCount) _page = pageCount - 1;
          final start = _page * _perPage;
          final end = (start + _perPage).clamp(0, filtered.length);
          final pageItems =
              filtered.isEmpty ? <CrimeListItem>[] : filtered.sublist(start, end);

          return Padding(
            padding: const EdgeInsets.all(AppSpacing.s5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _FilterChips(
                  status: _status,
                  from: _from,
                  to: _to,
                  searchFieldsLabel: _searchFields.isEmpty
                      ? 'list.searchAllFields'.tr()
                      : _searchFields.map(_fieldLabel).join(', '),
                  onPickSearchFields: _pickSearchFields,
                  onStatus: (s) => setState(() {
                    _status = s;
                    _resetPage();
                  }),
                  onPickFrom: () => _pickDate(isFrom: true),
                  onPickTo: () => _pickDate(isFrom: false),
                  onClear: _clear,
                ),
                const SizedBox(height: AppSpacing.s3),
                Expanded(
                  child: filtered.isEmpty
                      ? CrmsEmptyState(
                          icon: PhosphorIconsRegular.magnifyingGlass,
                          title: 'list.noMatches'.tr(),
                        )
                      : _table(pageItems),
                ),
                const SizedBox(height: AppSpacing.s3),
                _Pagination(
                  total: filtered.length,
                  start: start,
                  end: end,
                  page: _page,
                  pageCount: pageCount,
                  perPage: _perPage,
                  onPerPage: (v) => setState(() {
                    _perPage = v;
                    _resetPage();
                  }),
                  onPrev: _page > 0 ? () => setState(() => _page--) : null,
                  onNext:
                      _page < pageCount - 1 ? () => setState(() => _page++) : null,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  static Widget _txt(String s) =>
      Text(s, maxLines: 1, overflow: TextOverflow.ellipsis);

  /// Date shown in the list: registration date, else offence date, else the
  /// record's year — never a bare dash for records that at least carry a year.
  static String _dateLabel(CrimeListItem r) {
    final c = r.crime;
    if (c.dateRegistered != null) return _dateFmt.format(c.dateRegistered!);
    if (c.dateOccurred != null) return _dateFmt.format(c.dateOccurred!);
    return '${c.year}';
  }

  List<CrmsColumn<CrimeListItem>> get _columns => [
        CrmsColumn(
          label: 'list.col.fir'.tr(),
          flex: 2,
          cell: (r) => Text('${r.crime.firNo}/${r.crime.year}',
              style: AppType.monoStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          sortValue: (r) => r.crime.year,
        ),
        CrmsColumn(
          label: 'list.col.date'.tr(),
          flex: 2,
          cell: (r) => _txt(_dateLabel(r)),
          sortValue: (r) => _effectiveDate(r).millisecondsSinceEpoch,
        ),
        CrmsColumn(
          label: 'list.col.sections'.tr(),
          flex: 2,
          cell: (r) =>
              _txt((r.crime.section ?? '').isEmpty ? '—' : r.crime.section!),
          sortValue: (r) => (r.crime.section ?? '').toLowerCase(),
        ),
        CrmsColumn(
          label: 'list.col.complainant'.tr(),
          flex: 3,
          cell: (r) => _txt(r.complainantName ?? '—'),
          sortValue: (r) => (r.complainantName ?? '').toLowerCase(),
        ),
        CrmsColumn(
          label: 'list.col.place'.tr(),
          flex: 3,
          cell: (r) => _txt(
              (r.crime.placeOccurred ?? '').isEmpty ? '—' : r.crime.placeOccurred!),
          sortValue: (r) => (r.crime.placeOccurred ?? '').toLowerCase(),
        ),
        CrmsColumn(
          label: 'list.col.status'.tr(),
          width: 132,
          cell: (r) => Align(
              alignment: Alignment.centerLeft,
              child: CrmsBadge.status(r.crime.status)),
          sortValue: (r) => r.crime.status,
        ),
        CrmsColumn(
          label: 'list.col.chargesheet'.tr(),
          width: 124,
          cell: (r) {
            final badge = ChargesheetBadge.maybe(
              status: r.crime.status,
              courtType: r.crime.courtType,
              dateRegistered: r.crime.dateRegistered,
            );
            return Align(
              alignment: Alignment.centerLeft,
              child: badge ?? const Text('—'),
            );
          },
          sortValue: (r) =>
              chargesheetDaysRemaining(
                courtType: r.crime.courtType,
                dateRegistered: r.crime.dateRegistered,
              ) ??
              1 << 30,
        ),
        CrmsColumn(
          label: 'list.col.stage'.tr(),
          width: 180,
          cell: (r) => Align(
              alignment: Alignment.centerLeft,
              child: StageBadges(r.crime.caseStage)),
          sortValue: (r) => r.crime.caseStage,
        ),
        CrmsColumn(
          label: 'list.col.accused'.tr(),
          width: 80,
          numeric: true,
          cell: (r) => Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(PhosphorIconsRegular.user,
                  size: 16, color: AppColors.ink500),
              const SizedBox(width: 4),
              Text('${r.accusedNames.length}'),
            ],
          ),
          sortValue: (r) => r.accusedNames.length,
        ),
        CrmsColumn(
          label: '',
          width: 52,
          cell: (r) => _RowMenu(
            onView: () => _open(r.id),
            onEdit: () => _edit(r.id),
            onReport: () => showReportSheet(context, r.id),
            onDelete: () => _delete(r.id),
          ),
        ),
      ];

  Widget _table(List<CrimeListItem> rows) {
    return CrmsTable<CrimeListItem>(
      items: rows,
      onRowTap: (r) => _open(r.id),
      sortColumnIndex: _sortCol,
      sortAscending: _sortAsc,
      onSort: _onSort,
      columns: _columns,
    );
  }
}

class _FilterChips extends StatelessWidget {
  const _FilterChips({
    required this.status,
    required this.from,
    required this.to,
    required this.searchFieldsLabel,
    required this.onPickSearchFields,
    required this.onStatus,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onClear,
  });

  final String? status;
  final DateTime? from;
  final DateTime? to;
  final String searchFieldsLabel;
  final VoidCallback onPickSearchFields;
  final ValueChanged<String?> onStatus;
  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasFilters = status != null || from != null || to != null;
    return Wrap(
      spacing: AppSpacing.s2,
      runSpacing: AppSpacing.s2,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        OutlinedButton.icon(
          icon: const Icon(PhosphorIconsRegular.magnifyingGlass, size: 16),
          label: Text('list.searchInLabel'.tr(
              namedArgs: {'fields': searchFieldsLabel})),
          onPressed: onPickSearchFields,
        ),
        ChoiceChip(
          label: Text('list.statusAll'.tr()),
          selected: status == null,
          onSelected: (_) => onStatus(null),
        ),
        for (final s in _statuses)
          ChoiceChip(
            label: Text('crime.status.$s'.tr()),
            selected: status == s,
            onSelected: (_) => onStatus(s),
          ),
        const SizedBox(width: AppSpacing.s2),
        OutlinedButton.icon(
          icon: const Icon(PhosphorIconsRegular.calendarBlank, size: 16),
          label: Text(from == null ? 'list.dateFrom'.tr() : _dateFmt.format(from!)),
          onPressed: onPickFrom,
        ),
        OutlinedButton.icon(
          icon: const Icon(PhosphorIconsRegular.calendarBlank, size: 16),
          label: Text(to == null ? 'list.dateTo'.tr() : _dateFmt.format(to!)),
          onPressed: onPickTo,
        ),
        if (hasFilters)
          TextButton.icon(
            icon: const Icon(PhosphorIconsRegular.x, size: 16),
            label: Text('list.clearFilters'.tr()),
            onPressed: onClear,
          ),
      ],
    );
  }
}

class _Pagination extends StatelessWidget {
  const _Pagination({
    required this.total,
    required this.start,
    required this.end,
    required this.page,
    required this.pageCount,
    required this.perPage,
    required this.onPerPage,
    required this.onPrev,
    required this.onNext,
  });

  final int total;
  final int start;
  final int end;
  final int page;
  final int pageCount;
  final int perPage;
  final ValueChanged<int> onPerPage;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Text(
          'list.showing'.tr(namedArgs: {
            'from': total == 0 ? '0' : '${start + 1}',
            'to': '$end',
            'total': '$total',
          }),
          style: theme.textTheme.bodySmall,
        ),
        const Spacer(),
        Text('list.perPage'.tr(), style: theme.textTheme.bodySmall),
        const SizedBox(width: AppSpacing.s2),
        DropdownButton<int>(
          value: perPage,
          underline: const SizedBox.shrink(),
          items: [
            for (final n in _perPageOptions)
              DropdownMenuItem(value: n, child: Text('$n')),
          ],
          onChanged: (v) => v == null ? null : onPerPage(v),
        ),
        const SizedBox(width: AppSpacing.s4),
        IconButton(
          tooltip: 'list.prevPage'.tr(),
          icon: const Icon(PhosphorIconsRegular.caretLeft, size: 18),
          onPressed: onPrev,
        ),
        Text('${page + 1} / $pageCount', style: theme.textTheme.bodySmall),
        IconButton(
          tooltip: 'list.nextPage'.tr(),
          icon: const Icon(PhosphorIconsRegular.caretRight, size: 18),
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _RowMenu extends StatelessWidget {
  const _RowMenu({
    required this.onView,
    required this.onEdit,
    required this.onReport,
    required this.onDelete,
  });

  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onReport;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'common.actions'.tr(),
      icon: const Icon(PhosphorIconsRegular.dotsThreeVertical, size: 20),
      onSelected: (v) {
        switch (v) {
          case 'view':
            onView();
          case 'edit':
            onEdit();
          case 'report':
            onReport();
          case 'delete':
            onDelete();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 'view', child: Text('common.view'.tr())),
        PopupMenuItem(value: 'edit', child: Text('common.edit'.tr())),
        PopupMenuItem(value: 'report', child: Text('report.generate'.tr())),
        PopupMenuItem(value: 'delete', child: Text('common.delete'.tr())),
      ],
    );
  }
}
