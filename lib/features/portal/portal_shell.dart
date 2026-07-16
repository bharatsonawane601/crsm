import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/branding.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../core/theme/text_scale.dart';
import '../../shared/widgets/crms.dart';
import '../access/access_client.dart';
import '../access/access_service.dart';
import '../analyzer/dashboard_screen.dart';
import '../auth/auth_service.dart';
import '../bhag/bhag_report_spec.dart';
import '../bhag/bhag_screen.dart';
import '../bhag/reports_hub.dart';
import '../bhag/preventive_report_model.dart';
import '../bhag/preventive_report_screen.dart';
import '../bhag/recovered_report_model.dart';
import '../bhag/recovered_report_screen.dart';
import '../bhag/station_report_model.dart';
import '../bhag/station_report_screen.dart';
import '../bhag/undetected_report_model.dart';
import '../bhag/undetected_report_screen.dart';
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
        OfficerRole.io => 'IO',
        OfficerRole.hq => 'HQ',
      };

  void _refresh() {
    ref.invalidate(portalAnalyticsRowsProvider);
    ref.invalidate(portalSearchResultsProvider);
    ref.invalidate(portalCompareResultsProvider);
    ref.invalidate(portalScopeTreeProvider);
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
      case 'account':
        _showAccount(context);
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

  /// The "Access & device" card (approval status, email, font size, re-check,
  /// sign out) — the same controls the station app shows in Settings, surfaced
  /// here because the read-only portal has no Settings screen.
  void _showAccount(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('settings.access'.tr()),
        content: const _PortalAccountCard(),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('common.close'.tr()),
          ),
        ],
      ),
    );
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
      length: 4,
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
                    value: 'account', child: Text('settings.access'.tr())),
                const PopupMenuDivider(),
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
                  isScrollable: true,
                  tabAlignment: TabAlignment.center,
                  tabs: [
                    Tab(
                        icon: const Icon(PhosphorIconsRegular.chartBar),
                        text: 'nav.dashboard'.tr()),
                    Tab(
                        icon: const Icon(PhosphorIconsRegular.magnifyingGlass),
                        text: 'portal.search'.tr()),
                    Tab(
                        icon: const Icon(PhosphorIconsRegular.scales),
                        text: 'portal.compare'.tr()),
                    Tab(
                        icon: const Icon(PhosphorIconsRegular.chartPieSlice),
                        text: 'reports.title'.tr()),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _PortalDashboard(),
            PortalSearchView(),
            _PortalCompare(),
            _PortalBhag(),
          ],
        ),
      ),
    );
  }
}

/// The jurisdiction drill-down: three independent, cascading dropdowns —
/// Zone → ACP → Police Station. Each defaults to "All …". A level only shows
/// when the officer has more than one choice at it (so an ACP mainly sees the
/// station picker, a DCP sees ACP + station, the CP sees all three). The
/// dashboard and search both narrow to the selection.
class _ScopeBar extends ConsumerWidget {
  const _ScopeBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treeAsync = ref.watch(portalScopeTreeProvider);
    final scope = ref.watch(portalScopeProvider);
    final notifier = ref.read(portalScopeProvider.notifier);

    return Container(
      width: double.infinity,
      color: AppColors.policeNavy,
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.s4, 0, AppSpacing.s4, AppSpacing.s2),
      child: treeAsync.maybeWhen(
        data: (tree) {
          if (tree.stations.isEmpty && tree.divisions.isEmpty) {
            return const SizedBox(height: 8);
          }
          // Cascade: ACP list narrows to the chosen zone; station list narrows
          // to the chosen ACP, else the chosen zone.
          final divisions = scope.zoneId == null
              ? tree.divisions
              : tree.divisions.where((d) => d.zoneId == scope.zoneId).toList();
          final stations = scope.divisionId != null
              ? tree.stations
                  .where((s) => s.divisionId == scope.divisionId)
                  .toList()
              : scope.zoneId != null
                  ? tree.stations
                      .where((s) => s.zoneId == scope.zoneId)
                      .toList()
                  : tree.stations;

          final showZone = tree.zones.length > 1;
          final showAcp = tree.divisions.length > 1;

          return Row(
            children: [
              const Icon(PhosphorIconsRegular.funnel,
                  size: 16, color: AppColors.policeKhakiLight),
              const SizedBox(width: AppSpacing.s2),
              if (showZone) ...[
                Expanded(
                  child: _ScopeDropdown(
                    allLabel: 'portal.allZones'.tr(),
                    value: scope.zoneId,
                    items: [for (final z in tree.zones) (z.id, z.name)],
                    onChanged: notifier.setZone,
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
              ],
              if (showAcp) ...[
                Expanded(
                  child: _ScopeDropdown(
                    allLabel: 'portal.allAcps'.tr(),
                    value: scope.divisionId,
                    items: [for (final d in divisions) (d.id, d.name)],
                    onChanged: notifier.setDivision,
                  ),
                ),
                const SizedBox(width: AppSpacing.s2),
              ],
              Expanded(
                child: _ScopeDropdown(
                  allLabel: 'portal.allStations'.tr(),
                  value: scope.stationId,
                  items: [for (final s in stations) (s.id, s.name)],
                  onChanged: notifier.setStation,
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

/// One white-on-navy scope dropdown with an "All …" default (value = null).
class _ScopeDropdown extends StatelessWidget {
  const _ScopeDropdown({
    required this.allLabel,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String allLabel;
  final int? value;
  final List<(int, String)> items;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    // Guard: keep the selected value valid for the (possibly cascaded) list.
    final validValue = items.any((e) => e.$1 == value) ? value : null;
    return DropdownButtonHideUnderline(
      child: DropdownButton<int?>(
        isExpanded: true,
        isDense: true,
        value: validValue,
        dropdownColor: AppColors.policeNavy,
        iconEnabledColor: Colors.white,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        items: [
          DropdownMenuItem<int?>(
            value: null,
            child: Text(allLabel,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white)),
          ),
          for (final (id, name) in items)
            DropdownMenuItem<int?>(
              value: id,
              child: Text(name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white)),
            ),
        ],
        onChanged: onChanged,
      ),
    );
  }
}

/// "Access & device" card for the portal: approval status, signed-in email, an
/// app-wide font-size selector (Mini → Extra large, applied everywhere), and the
/// re-check / sign-out actions.
class _PortalAccountCard extends ConsumerWidget {
  const _PortalAccountCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accessControllerProvider);
    final user = ref.watch(authControllerProvider).value;
    final scale = ref.watch(textScaleProvider);
    final theme = Theme.of(context);

    final (color, statusText) = switch (state.gate) {
      AccessGate.approved => (Colors.green, 'settings.accessApproved'.tr()),
      AccessGate.pending => (Colors.orange, 'settings.accessPending'.tr()),
      AccessGate.checking => (Colors.grey, 'settings.accessChecking'.tr()),
      AccessGate.blocked =>
        (theme.colorScheme.error, 'settings.accessBlocked'.tr()),
    };

    return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.circle, size: 12, color: color),
              const SizedBox(width: 8),
              Expanded(child: Text(statusText, style: theme.textTheme.bodyMedium)),
            ],
          ),
          if (user != null) ...[
            const SizedBox(height: 6),
            Text(user.email, style: theme.textTheme.bodySmall),
          ],
          const Divider(height: 24),
          Text('settings.display'.tr(),
              style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final s in AppTextScale.values)
                ChoiceChip(
                  label: Text(s.labelKey.tr()),
                  selected: scale == s,
                  onSelected: (_) =>
                      ref.read(textScaleProvider.notifier).set(s),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () =>
                    ref.read(accessControllerProvider.notifier).recheck(),
                icon: const Icon(Icons.refresh),
                label: Text('access.checkNow'.tr()),
              ),
              OutlinedButton.icon(
                onPressed: () =>
                    ref.read(authControllerProvider.notifier).signOut(),
                icon: const Icon(Icons.logout),
                label: Text('access.signOut'.tr()),
              ),
            ],
          ),
        ],
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
/// The central FIR search (text + status chips + paged results + detail).
/// Used by the officer portal's Search tab and, scoped to a single station,
/// by the station app's "Station FIRs" screen.
class PortalSearchView extends ConsumerStatefulWidget {
  const PortalSearchView({super.key});

  @override
  ConsumerState<PortalSearchView> createState() => _PortalSearchViewState();
}

class _PortalSearchViewState extends ConsumerState<PortalSearchView> {
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
    const statuses = ['detected', 'undetected'];

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

// ---------------------------------------------------------------------------
// Compare — a separate section where the officer picks several police stations
// (or several ACPs) and sees their KPIs side by side.
// ---------------------------------------------------------------------------
class _PortalCompare extends ConsumerWidget {
  const _PortalCompare();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final by = ref.watch(compareByProvider);
    final treeAsync = ref.watch(portalScopeTreeProvider);
    final selection = ref.watch(compareSelectionProvider);
    final results = ref.watch(portalCompareResultsProvider);
    final theme = Theme.of(context);

    return treeAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => _ErrorView(
          message: 'portal.error'.tr(),
          onRetry: () => ref.invalidate(portalScopeTreeProvider)),
      data: (tree) {
        final entities = switch (by) {
          'zone' => [for (final z in tree.zones) (z.id, z.name)],
          'division' => [for (final d in tree.divisions) (d.id, d.name)],
          _ => [for (final s in tree.stations) (s.id, s.name)],
        };
        // Comparing zones only makes sense when the officer spans >1 zone (CP).
        final showZoneMode = tree.zones.length > 1;

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.s4),
          children: [
            // Compare-by mode.
            Wrap(
              spacing: 8,
              children: [
                if (showZoneMode)
                  ChoiceChip(
                    label: Text('portal.byZone'.tr()),
                    selected: by == 'zone',
                    onSelected: (_) =>
                        ref.read(compareByProvider.notifier).set('zone'),
                  ),
                ChoiceChip(
                  label: Text('portal.byAcp'.tr()),
                  selected: by == 'division',
                  onSelected: (_) =>
                      ref.read(compareByProvider.notifier).set('division'),
                ),
                ChoiceChip(
                  label: Text('portal.byStation'.tr()),
                  selected: by == 'station',
                  onSelected: (_) =>
                      ref.read(compareByProvider.notifier).set('station'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s3),
            Text('portal.comparePick'.tr(), style: theme.textTheme.bodySmall),
            const SizedBox(height: AppSpacing.s2),
            if (entities.isEmpty)
              Text('portal.noResults'.tr())
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (id, name) in entities)
                    FilterChip(
                      label: Text(name),
                      selected: selection.contains(id),
                      onSelected: (_) => ref
                          .read(compareSelectionProvider.notifier)
                          .toggle(id),
                    ),
                ],
              ),
            if (selection.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () =>
                      ref.read(compareSelectionProvider.notifier).clear(),
                  icon: const Icon(Icons.clear, size: 16),
                  label: Text('portal.clear'.tr()),
                ),
              ),
            const Divider(height: 24),
            results.when(
              loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator())),
              error: (e, _) => _ErrorView(
                  message: 'portal.error'.tr(),
                  onRetry: () => ref.invalidate(portalCompareResultsProvider)),
              data: (rows) {
                if (rows.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text('portal.compareEmpty'.tr(),
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium),
                    ),
                  );
                }
                return _ComparisonTable(rows: rows);
              },
            ),
          ],
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Bhag 1–5 — the same comparison report as the station app, fed by the
// scope-filtered central data (so a CP/DCP/ACP sees it for their jurisdiction).
// ---------------------------------------------------------------------------
class _PortalBhag extends ConsumerWidget {
  const _PortalBhag();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ReportsList(
      isPortal: true,
      onOpen: (context, id) {
        if (id == kStationReportId) {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const _PortalStationReportScreen()));
          return;
        }
        if (id == kRecoveredReportId) {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const _PortalRecoveredReportScreen()));
          return;
        }
        if (id == kPreventiveReportId) {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const _PortalPreventiveReportScreen()));
          return;
        }
        if (id == kUndetectedReportId) {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const _PortalUndetectedReportScreen()));
          return;
        }
        final spec = kBhagSpecs[id];
        if (spec == null) return;
        Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => _PortalReportScreen(spec: spec)));
      },
    );
  }
}

/// The division station-wise report opened from the portal hub, fed by the
/// scope-filtered central data.
class _PortalStationReportScreen extends ConsumerWidget {
  const _PortalStationReportScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('stationReport.title'.tr())),
      body: StationReport(firsAsync: ref.watch(portalAnalyticsRowsProvider)),
    );
  }
}

/// The undetected भाग-1-5 review opened from the portal hub. Station columns come
/// from the scoped org tree (in order); data is scope-filtered.
class _PortalUndetectedReportScreen extends ConsumerWidget {
  const _PortalUndetectedReportScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tree =
        ref.watch(portalScopeTreeProvider).value ?? PortalScopeTree.empty;
    final stations = [for (final s in tree.stations) s.name];
    return Scaffold(
      appBar: AppBar(title: Text('undetected.title'.tr())),
      body: UndetectedReport(
        firsAsync: ref.watch(portalAnalyticsRowsProvider),
        stations: stations,
      ),
    );
  }
}

/// The प्रतिबंधक कार्यवाही report opened from the portal hub, fed by scope-filtered
/// central data.
class _PortalPreventiveReportScreen extends ConsumerWidget {
  const _PortalPreventiveReportScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('preventive.title'.tr())),
      body: PreventiveReport(firsAsync: ref.watch(portalAnalyticsRowsProvider)),
    );
  }
}

/// The recovered-property (मुद्देमाल) return opened from the portal hub. Builds the
/// station -> sub-division grouping from the scoped org tree so the सपोआ subtotal
/// rows match the officer's jurisdiction.
class _PortalRecoveredReportScreen extends ConsumerWidget {
  const _PortalRecoveredReportScreen();

  RecoveredGrouping _grouping(PortalScopeTree tree) {
    final divisionName = {for (final d in tree.divisions) d.id: d.name};
    final stationDivision = <String, String>{};
    final stationSort = <String, int>{};
    var i = 0;
    for (final s in tree.stations) {
      final div = s.divisionId != null ? divisionName[s.divisionId] : null;
      if (div != null) stationDivision[s.name] = div;
      stationSort[s.name] = i++;
    }
    return RecoveredGrouping(
      divisionOrder: [for (final d in tree.divisions) d.name],
      stationDivision: stationDivision,
      stationSort: stationSort,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tree = ref.watch(portalScopeTreeProvider).value ?? PortalScopeTree.empty;
    return Scaffold(
      appBar: AppBar(title: Text('recovered.title'.tr())),
      body: RecoveredReport(
        firsAsync: ref.watch(portalAnalyticsRowsProvider),
        grouping: _grouping(tree),
      ),
    );
  }
}

/// A single report opened from the portal hub, fed by the scope-filtered
/// central data (so it respects the officer's jurisdiction).
class _PortalReportScreen extends ConsumerWidget {
  const _PortalReportScreen({required this.spec});
  final BhagReportSpec spec;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(spec.titleKey.tr())),
      body: BhagReport(
          spec: spec, firsAsync: ref.watch(portalAnalyticsRowsProvider)),
    );
  }
}

/// The side-by-side KPI table: one column per selected station/ACP, one row per
/// metric.
class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable({required this.rows});
  final List<PortalCompareRow> rows;

  @override
  Widget build(BuildContext context) {
    String money(num v) => '₹${v.toStringAsFixed(0)}';
    final metrics = <(String, String Function(PortalCompareRow))>[
      ('portal.metric.total', (r) => '${r.total}'),
      ('portal.metric.detected', (r) => '${r.detected}'),
      ('portal.metric.undetected', (r) => '${r.undetected}'),
      ('portal.metric.detectedPct', (r) => '${r.detectedPct.toStringAsFixed(0)}%'),
      ('portal.metric.arrested', (r) => '${r.arrested}'),
      ('portal.metric.wanted', (r) => '${r.wanted}'),
      ('portal.metric.chargesheeted', (r) => '${r.chargesheeted}'),
      ('portal.metric.recovered', (r) => money(r.recovered)),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStatePropertyAll(
            AppColors.policeNavy.withValues(alpha: 0.06)),
        columns: [
          DataColumn(
              label: Text('portal.metric.metric'.tr(),
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          for (final r in rows)
            DataColumn(
                label: Text(r.label,
                    style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          for (final (key, fn) in metrics)
            DataRow(cells: [
              DataCell(Text(key.tr())),
              for (final r in rows) DataCell(Text(fn(r))),
            ]),
        ],
      ),
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
