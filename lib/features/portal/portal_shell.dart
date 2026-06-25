import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/branding.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../shared/widgets/crms.dart';
import '../access/access_client.dart';
import '../access/access_service.dart';
import '../analyzer/dashboard_screen.dart';
import '../auth/auth_service.dart';
import '../legal/legal_screen.dart';
import 'central_client.dart';
import 'portal_crime_detail.dart';
import 'portal_providers.dart';

/// Read-only shell for senior officers (CP / DCP / ACP). No data entry — just a
/// scope-filtered dashboard and crime/FIR search across their jurisdiction.
class PortalShell extends ConsumerStatefulWidget {
  const PortalShell({super.key});

  @override
  ConsumerState<PortalShell> createState() => _PortalShellState();
}

class _PortalShellState extends ConsumerState<PortalShell> {
  Timer? _autoRefresh;

  @override
  void initState() {
    super.initState();
    // Manual + auto sync: pull fresh central data every 90s so an officer sees
    // new FIRs / edits / deletions from stations without pressing anything.
    _autoRefresh =
        Timer.periodic(const Duration(seconds: 90), (_) => _refresh());
  }

  @override
  void dispose() {
    _autoRefresh?.cancel();
    super.dispose();
  }

  String _roleLabel(OfficerRole role) => switch (role) {
        OfficerRole.cp => 'CP',
        OfficerRole.dcp => 'DCP',
        OfficerRole.acp => 'ACP',
        OfficerRole.station => 'Officer',
      };

  void _refresh() {
    ref.invalidate(portalAnalyticsRowsProvider);
    ref.invalidate(portalSearchResultsProvider);
    ref.invalidate(portalScopeOptionsProvider);
  }

  /// Manual "Sync data" press: re-pull everything and confirm with a snackbar.
  void _manualSync() {
    _refresh();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('sync.server.syncing'.tr()),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _onMenu(BuildContext context, String value) {
    switch (value) {
      case 'privacy':
        openLegal(context, LegalDoc.privacy);
      case 'terms':
        openLegal(context, LegalDoc.terms);
      case 'about':
        _showAbout(context);
      case 'signout':
        ref.read(authControllerProvider.notifier).signOut();
    }
  }

  void _showAbout(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CrmsLogo(size: 72),
            const SizedBox(height: AppSpacing.s3),
            Text('app.title'.tr(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.s2),
            const PoweredByStrip(),
            const SizedBox(height: 4),
            Text(Branding.websiteLabel,
                style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('common.ok'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final access = ref.watch(accessControllerProvider);
    final scopeLabel = access.scope.labelOr('portal.allCity'.tr());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.policeNavy,
          foregroundColor: Colors.white,
          titleSpacing: AppSpacing.s4,
          title: Row(
            children: [
              const CrmsLogo(size: 34, onCard: false),
              const SizedBox(width: AppSpacing.s3),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('portal.title'.tr(),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700)),
                    Text('${_roleLabel(access.role)} · $scopeLabel',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.policeKhakiLight)),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton.icon(
              onPressed: _manualSync,
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              icon: const Icon(PhosphorIconsRegular.arrowsClockwise, size: 18),
              label: Text('common.syncData'.tr(),
                  style: const TextStyle(color: Colors.white)),
            ),
            const DarkModeToggle(),
            const SizedBox(width: 4),
            const Center(child: LanguageToggle()),
            const SizedBox(width: 4),
            PopupMenuButton<String>(
              tooltip: 'common.more'.tr(),
              icon: const Icon(PhosphorIconsRegular.dotsThreeVertical),
              onSelected: (v) => _onMenu(context, v),
              itemBuilder: (_) => [
                PopupMenuItem(
                    value: 'privacy', child: Text('legal.privacy'.tr())),
                PopupMenuItem(value: 'terms', child: Text('legal.terms'.tr())),
                PopupMenuItem(value: 'about', child: Text('settings.about'.tr())),
                const PopupMenuDivider(),
                PopupMenuItem(
                    value: 'signout', child: Text('login.signOut'.tr())),
              ],
            ),
            const SizedBox(width: 4),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(104),
            child: Column(
              children: [
                const _ScopeBar(),
                TabBar(
                  indicatorColor: AppColors.policeKhaki,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.policeKhakiLight,
                  tabs: [
                    Tab(
                        icon: const Icon(PhosphorIconsRegular.chartBar),
                        text: 'nav.dashboard'.tr()),
                    Tab(
                        icon: const Icon(PhosphorIconsRegular.magnifyingGlass),
                        text: 'portal.search'.tr()),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [_PortalDashboard(), _PortalSearch()],
        ),
      ),
    );
  }
}

/// The jurisdiction drill-down: CP picks a zone, DCP a division, ACP a station
/// (or the "All …" default). Both the dashboard and search react to it.
class _ScopeBar extends ConsumerWidget {
  const _ScopeBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final optionsAsync = ref.watch(portalScopeOptionsProvider);
    final selected = ref.watch(selectedScopeProvider);

    return Container(
      width: double.infinity,
      color: AppColors.policeNavy,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s4, 0, AppSpacing.s4, AppSpacing.s2),
      child: optionsAsync.maybeWhen(
        data: (options) {
          if (options.isEmpty) return const SizedBox(height: 8);
          // The effective current value: the selected one, else the first.
          final current = options.contains(selected) ? selected : options.first;
          return Row(
            children: [
              const Icon(PhosphorIconsRegular.funnel,
                  size: 16, color: AppColors.policeKhakiLight),
              const SizedBox(width: AppSpacing.s2),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<PortalScopeOption>(
                    isExpanded: true,
                    value: current,
                    dropdownColor: AppColors.policeNavy,
                    iconEnabledColor: Colors.white,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    items: [
                      for (final o in options)
                        DropdownMenuItem(
                          value: o,
                          child: Text(o.label,
                              style: const TextStyle(color: Colors.white)),
                        ),
                    ],
                    onChanged: (o) =>
                        ref.read(selectedScopeProvider.notifier).select(o),
                  ),
                ),
              ),
            ],
          );
        },
        orElse: () => const SizedBox(height: 8),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dashboard — reuses the full analytics dashboard body (KPIs + every chart),
// fed by the central, scope-filtered data instead of the local database.
// ---------------------------------------------------------------------------
class _PortalDashboard extends ConsumerWidget {
  const _PortalDashboard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(portalAnalyticsRowsProvider);
    return rows.when(
      loading: () => const CrmsListSkeleton(rows: 4),
      error: (e, _) => _ErrorView(
          message: 'portal.error'.tr(),
          onRetry: () => ref.invalidate(portalAnalyticsRowsProvider)),
      data: (list) => RefreshIndicator(
        onRefresh: () async => ref.invalidate(portalAnalyticsRowsProvider),
        child: AnalyticsDashboardBody(allRows: list, showStatsButton: false),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Search
// ---------------------------------------------------------------------------
class _PortalSearch extends ConsumerStatefulWidget {
  const _PortalSearch();

  @override
  ConsumerState<_PortalSearch> createState() => _PortalSearchState();
}

class _PortalSearchState extends ConsumerState<_PortalSearch> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _apply({String? status}) {
    final q = ref.read(portalSearchQueryProvider);
    ref.read(portalSearchQueryProvider.notifier).update(
          q.copyWith(text: _ctrl.text.trim(), status: status, page: 1),
        );
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(portalSearchResultsProvider);
    final query = ref.watch(portalSearchQueryProvider);
    const statuses = ['open', 'pending', 'solved', 'chargesheeted'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.s4, AppSpacing.s4, AppSpacing.s4, AppSpacing.s2),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _ctrl,
                  autocorrect: false,
                  enableSuggestions: false,
                  textInputAction: TextInputAction.search,
                  onSubmitted: (_) => _apply(status: query.status),
                  decoration: InputDecoration(
                    hintText: 'portal.searchHint'.tr(),
                    prefixIcon: const Icon(PhosphorIconsRegular.magnifyingGlass),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s3),
              FilledButton(
                  onPressed: () => _apply(status: query.status),
                  child: Text('portal.search'.tr())),
            ],
          ),
        ),
        // Status filter chips.
        Align(
          alignment: Alignment.centerLeft,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
            child: Row(
              children: [
                ChoiceChip(
                  label: Text('list.allStatuses'.tr()),
                  selected: query.status == null,
                  onSelected: (_) => _apply(status: null),
                ),
                const SizedBox(width: 6),
                for (final st in statuses) ...[
                  ChoiceChip(
                    label: Text('crime.status.$st'.tr()),
                    selected: query.status == st,
                    onSelected: (_) => _apply(status: st),
                  ),
                  const SizedBox(width: 6),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.s2),
        Expanded(
          child: results.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => _ErrorView(
                message: 'portal.error'.tr(),
                onRetry: () => ref.invalidate(portalSearchResultsProvider)),
            data: (r) {
              if (r.rows.isEmpty) {
                return Center(child: Text('portal.noResults'.tr()));
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s4, vertical: 4),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('portal.resultCount'.tr(args: ['${r.total}']),
                          style: Theme.of(context).textTheme.bodySmall),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      padding:
                          const EdgeInsets.symmetric(horizontal: AppSpacing.s4),
                      itemCount: r.rows.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final c = r.rows[i];
                        return ListTile(
                          leading: const Icon(PhosphorIconsRegular.fileText),
                          title: Text(
                              '${'crime.info.firNo'.tr()} ${c.firNo ?? '—'}/${c.year ?? ''} · ${c.crimeType ?? ''}'),
                          subtitle: Text(
                              '${c.stationName ?? ''} · ${c.section ?? ''} · ${c.status ?? ''}'),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () => showPortalCrimeDetail(context, c),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(PhosphorIconsRegular.warning, size: 40),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: onRetry, child: Text('common.retry'.tr())),
        ],
      ),
    );
  }
}
