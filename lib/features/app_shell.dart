import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../core/theme/colors.dart';
import '../core/theme/spacing.dart';
import '../core/theme/typography.dart';
import '../shared/widgets/crms.dart';
import 'analyzer/dashboard_screen.dart';
import 'audit/audit_log_screen.dart';
import 'bhag/reports_hub.dart';
import 'auth/auth_service.dart';
import 'crime_entry/crime_entry_screen.dart';
import 'crime_list/crime_list_provider.dart';
import 'crime_list/crime_list_screen.dart';
import 'import_excel/import_screen.dart';
import 'access/access_client.dart';
import 'access/access_service.dart';
import 'io/io_portal_shell.dart';
import 'notifications/notification_center.dart';
import 'notifications/notifications_controller.dart';
import 'portal/central_upload_controller.dart';
import 'portal/portal_shell.dart';
import 'portal/station_firs_screen.dart';
import 'settings/backup_service.dart';
import 'settings/settings_screen.dart';
import 'sync/sync_controller.dart';
import 'template_builder/template_list_screen.dart';

/// Persistent application shell: a labelled left sidebar + the active section.
/// Sections are kept alive in an [IndexedStack] so their state (filters, etc.)
/// survives switching. Action items (New Crime, Import, Sync) run inline.
class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _section = 1; // default: Crime Records
  bool _collapsed = false;
  Timer? _syncTimer;
  bool _massDeleteDialogOpen = false;

  @override
  void initState() {
    super.initState();
    // On launch: push this station's records up AND pull down any server-side
    // deletions (so admin-deleted FIRs are removed from this device too).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(centralUploadControllerProvider.notifier).uploadNow();
      // Daily automatic backup (encrypted). No-op if one ran in the last 24h.
      ref.read(backupServiceProvider).autoBackupIfDue();
    });
    // Then keep checking for server-side deletions while the app is open, so an
    // admin deletion clears from this device within a minute or two (near
    // real-time) without waiting for a restart.
    _syncTimer = Timer.periodic(const Duration(seconds: 90), (_) {
      ref.read(centralUploadControllerProvider.notifier).pullServerDeletions();
      // Refresh the bell: new command messages + pending-case alerts.
      ref.read(notificationsControllerProvider.notifier).refresh();
    });
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    super.dispose();
  }

  static const _titleKeys = [
    'nav.dashboard',
    'list.title',
    'templates.title',
    'reports.title',
    'audit.title',
    'settings.title',
    'nav.analytics',
  ];

  // Sections are built lazily — only when first opened — so heavy streams
  // (e.g. the dashboard analytics over thousands of records) don't run while
  // you're on another section. Visited sections stay alive afterwards.
  final Set<int> _visited = {1};

  void _go(int section) => setState(() {
        _section = section;
        _visited.add(section);
      });

  /// Returns the real section widget once visited, otherwise an empty
  /// placeholder (so its providers/streams don't run until first opened).
  Widget _lazy(int index, Widget child) =>
      _visited.contains(index) ? child : const SizedBox.shrink();

  Future<void> _newCrime() => Navigator.of(context).push(
        MaterialPageRoute<Object?>(builder: (_) => const CrimeEntryScreen()),
      );

  Future<void> _sync() async {
    await ref.read(syncControllerProvider).syncNow();
    if (mounted && ref.read(syncControllerProvider).folder != null) {
      CrmsToast.show(context, title: 'sync.status.synced'.tr());
    }
  }

  /// The mass-delete fuse tripped: the server asked this device to erase a
  /// large number of local records (typical after a server wipe/reset while
  /// old delete-markers linger). Nothing is deleted until the user says so.
  Future<void> _confirmServerMassDelete(int n) async {
    if (_massDeleteDialogOpen || !mounted) return;
    _massDeleteDialogOpen = true;
    try {
      final args = {'n': '$n'};
      final wipe = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          icon: const Icon(PhosphorIconsRegular.warningCircle,
              color: AppColors.dangerRed, size: 36),
          title: Text('sync.server.massTitle'.tr(namedArgs: args)),
          content: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Text('sync.server.massBody'.tr(namedArgs: args)),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text('sync.server.massKeep'.tr()),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: AppColors.dangerRed),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('sync.server.massDelete'.tr(namedArgs: args)),
            ),
          ],
        ),
      );
      if (!mounted) return;
      final controller = ref.read(centralUploadControllerProvider.notifier);
      if (wipe == true) {
        await controller.uploadNow(allowMassDelete: true);
      } else {
        controller.dismissBlocked();
        CrmsToast.show(context, title: 'sync.server.kept'.tr());
      }
    } finally {
      _massDeleteDialogOpen = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Server-side mass deletion needs the user's explicit yes — from any sync
    // path (launch upload, 90s background pull, or the manual button).
    ref.listen(centralUploadControllerProvider, (prev, next) {
      if (next.phase == UploadPhase.blocked && next.pendingServerDeletes > 0) {
        _confirmServerMassDelete(next.pendingServerDeletes);
      }
    });

    // Admin-assigned station: unlocks the read-only "Station FIRs" view of the
    // whole station's central records (all users, not just this device).
    // HQ role instead gets the full officer portal (all stations) + free entry.
    final access = ref.watch(accessControllerProvider);
    final assignedStation = access.scope.station;
    final isHq = access.role == OfficerRole.hq;
    final items = <CrmsNavItem>[
      CrmsNavItem(
          icon: PhosphorIconsRegular.chartBar,
          label: 'nav.dashboard'.tr(),
          selected: _section == 0,
          onTap: () => _go(0)),
      CrmsNavItem(
          icon: PhosphorIconsRegular.chartLineUp,
          label: 'nav.analytics'.tr(),
          selected: _section == 6,
          onTap: () => _go(6)),
      CrmsNavItem(
          icon: PhosphorIconsRegular.fileText,
          label: 'nav.crimeRecords'.tr(),
          selected: _section == 1,
          onTap: () => _go(1)),
      if (assignedStation != null && assignedStation.isNotEmpty)
        CrmsNavItem(
            icon: PhosphorIconsRegular.buildings,
            label: 'nav.stationFirs'.tr(),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => const StationFirsScreen()))),
      if (isHq)
        CrmsNavItem(
            icon: PhosphorIconsRegular.buildings,
            label: 'nav.officerPortal'.tr(),
            onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) => const PortalShell()))),
      CrmsNavItem(
          icon: PhosphorIconsRegular.plusCircle,
          label: 'nav.newCrime'.tr(),
          onTap: _newCrime),
      CrmsNavItem(
          icon: PhosphorIconsRegular.stack,
          label: 'nav.templates'.tr(),
          selected: _section == 2,
          onTap: () => _go(2)),
      CrmsNavItem(
          icon: PhosphorIconsRegular.chartPieSlice,
          label: 'reports.title'.tr(),
          selected: _section == 3,
          onTap: () => _go(3)),
      CrmsNavItem(
          icon: PhosphorIconsRegular.identificationCard,
          label: 'io.title'.tr(),
          onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const IoPortalShell()))),
      CrmsNavItem(
          icon: PhosphorIconsRegular.uploadSimple,
          label: 'nav.import'.tr(),
          onTap: () => runExcelImport(context, ref)),
      CrmsNavItem(
          icon: PhosphorIconsRegular.cloudArrowUp,
          label: 'nav.sync'.tr(),
          onTap: _sync),
      CrmsNavItem(
          icon: PhosphorIconsRegular.clockCounterClockwise,
          label: 'nav.audit'.tr(),
          selected: _section == 4,
          onTap: () => _go(4)),
      CrmsNavItem(
          icon: PhosphorIconsRegular.gearSix,
          label: 'nav.settings'.tr(),
          selected: _section == 5,
          onTap: () => _go(5)),
    ];

    return Scaffold(
      body: Row(
        children: [
          CrmsSidebar(
            items: items,
            collapsed: _collapsed,
            header: _SidebarHeader(collapsed: _collapsed),
            footer: _SidebarFooter(
              collapsed: _collapsed,
              onToggleCollapse: () =>
                  setState(() => _collapsed = !_collapsed),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                CrmsTopBar(
                  title: _titleKeys[_section].tr(),
                  center: _section == 1 ? const _TopSearch() : null,
                  actions: [
                    const _CentralSyncButton(),
                    const SizedBox(width: 4),
                    const _ShellSyncIndicator(),
                    const DarkModeToggle(),
                    const SizedBox(width: 4),
                    const Center(child: LanguageToggle()),
                    const SizedBox(width: 8),
                    const _NotificationBell(),
                    const _ShellAvatar(),
                    const SizedBox(width: 4),
                  ],
                ),
                Expanded(
                  child: IndexedStack(
                    index: _section,
                    children: [
                      _lazy(0, const DashboardScreen()),
                      _lazy(1, const CrimeListScreen()),
                      _lazy(2, const TemplateListScreen()),
                      _lazy(3, const ReportsHubScreen()),
                      _lazy(4, const AuditLogScreen(embedded: true)),
                      _lazy(5, const SettingsScreen(embedded: true)),
                      _lazy(6, const AnalyticsScreen()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Global crime search field in the top bar (Crime Records section only).
class _TopSearch extends ConsumerStatefulWidget {
  const _TopSearch();

  @override
  ConsumerState<_TopSearch> createState() => _TopSearchState();
}

class _TopSearchState extends ConsumerState<_TopSearch> {
  late final TextEditingController _c =
      TextEditingController(text: ref.read(crimeSearchProvider));

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: SizedBox(
        height: 36,
        child: TextField(
          controller: _c,
          onChanged: (v) => ref.read(crimeSearchProvider.notifier).set(v),
          style: AppType.bodySm.copyWith(color: Colors.white),
          cursorColor: Colors.white,
          autocorrect: false,
          enableSuggestions: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.10),
            hintText: 'list.searchHint'.tr(),
            hintStyle:
                AppType.bodySm.copyWith(color: Colors.white.withValues(alpha: 0.7)),
            prefixIcon: Icon(PhosphorIconsRegular.magnifyingGlass,
                size: 18, color: Colors.white.withValues(alpha: 0.7)),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide:
                  BorderSide(color: Colors.white.withValues(alpha: 0.4)),
            ),
          ),
        ),
      ),
    );
  }
}

/// Top-bar bell: opens the Notification Center; badge = unread command
/// messages + urgent case alerts (overdue / due-soon chargesheets).
class _NotificationBell extends ConsumerWidget {
  const _NotificationBell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final badge = ref.watch(
        notificationsControllerProvider.select((s) => s.badge));
    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          tooltip: 'nav.notifications'.tr(),
          color: Colors.white,
          icon: const Icon(PhosphorIconsRegular.bell, size: 20),
          onPressed: () => showNotificationCenter(context),
        ),
        if (badge > 0)
          Positioned(
            right: 4,
            top: 4,
            child: IgnorePointer(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: AppColors.dangerRed,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(minWidth: 16),
                child: Text(
                  badge > 99 ? '99+' : '$badge',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Compact avatar in the top bar; shows the signed-in email on hover.
class _ShellAvatar extends ConsumerWidget {
  const _ShellAvatar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    return Tooltip(
      message: user?.email ?? '',
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: CircleAvatar(
          radius: 14,
          backgroundColor: AppColors.policeKhaki,
          child: Icon(PhosphorIconsRegular.user, size: 16, color: Colors.white),
        ),
      ),
    );
  }
}

/// Top-bar Google Drive sync status; tap to sync now or open Settings.
class _ShellSyncIndicator extends ConsumerWidget {
  const _ShellSyncIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(syncControllerProvider);
    return ListenableBuilder(
      listenable: sync,
      builder: (context, _) {
        final (icon, color) = switch (sync.status) {
          SyncStatus.notConfigured =>
            (PhosphorIconsRegular.cloudSlash, Colors.white70),
          SyncStatus.synced =>
            (PhosphorIconsRegular.cloudCheck, AppColors.policeKhakiLight),
          SyncStatus.pending =>
            (PhosphorIconsRegular.cloudArrowUp, Colors.white),
          SyncStatus.syncing => (PhosphorIconsRegular.cloud, Colors.white),
          SyncStatus.error =>
            (PhosphorIconsRegular.cloudSlash, AppColors.dangerRed),
        };
        return IconButton(
          tooltip: 'sync.status.${sync.status.name}'.tr(),
          icon: Icon(icon, color: color, size: 20),
          onPressed: () => sync.syncNow(),
        );
      },
    );
  }
}

/// Top-bar "Sync data" button — the manual half of the central-server sync.
/// Pressing it pulls down any admin-side deletions and pushes this station's
/// records up to the shared portal store in one go. The background 90s timer in
/// the shell already auto-pulls deletions, so this gives the user an instant,
/// explicit "sync now" on top of the automatic refresh.
class _CentralSyncButton extends ConsumerWidget {
  const _CentralSyncButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(centralUploadControllerProvider);
    final syncing = state.phase == UploadPhase.uploading;
    return TextButton.icon(
      onPressed: syncing
          ? null
          : () async {
              await ref
                  .read(centralUploadControllerProvider.notifier)
                  .uploadNow();
              if (!context.mounted) return;
              final s = ref.read(centralUploadControllerProvider);
              // A blocked sync opens the mass-delete dialog instead of a toast.
              if (s.phase == UploadPhase.blocked) return;
              CrmsToast.show(
                context,
                title: s.phase == UploadPhase.failed
                    ? 'sync.server.failed'.tr()
                    : 'sync.server.done'.tr(),
              );
            },
      style: TextButton.styleFrom(foregroundColor: Colors.white),
      icon: syncing
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            )
          : const Icon(PhosphorIconsRegular.arrowsClockwise,
              size: 18, color: Colors.white),
      label: Text(
        syncing ? 'sync.server.syncing'.tr() : 'common.syncData'.tr(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader({required this.collapsed});
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(
          horizontal: collapsed ? 0 : AppSpacing.s4),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor)),
      ),
      child: Row(
        mainAxisAlignment:
            collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/crms_logo.png',
            height: 32,
            width: 32,
            fit: BoxFit.contain,
            errorBuilder: (_, _, _) => const Icon(
                PhosphorIconsRegular.shieldCheck,
                color: AppColors.policeNavy,
                size: 28),
          ),
          if (!collapsed) ...[
            const SizedBox(width: AppSpacing.s3),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('CRMS',
                      style: AppType.h3.copyWith(color: AppColors.policeNavy)),
                  Text('app.subtitle'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppType.caption
                          .copyWith(color: AppColors.ink500)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SidebarFooter extends ConsumerWidget {
  const _SidebarFooter({required this.collapsed, required this.onToggleCollapse});
  final bool collapsed;
  final VoidCallback onToggleCollapse;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Divider(height: 1, color: theme.dividerColor),
        if (!collapsed)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s3),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.policeKhakiLight,
                  child: Icon(PhosphorIconsRegular.user,
                      size: 18, color: AppColors.policeNavy),
                ),
                const SizedBox(width: AppSpacing.s3),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user?.displayName ?? user?.email ?? '—',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.bodySm
                              .copyWith(fontWeight: FontWeight.w600)),
                      Text(user?.email ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppType.caption
                              .copyWith(color: AppColors.ink500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        _FooterAction(
          icon: PhosphorIconsRegular.signOut,
          label: 'login.signOut'.tr(),
          collapsed: collapsed,
          onTap: () => ref.read(authControllerProvider.notifier).signOut(),
        ),
        _FooterAction(
          icon: collapsed
              ? PhosphorIconsRegular.caretDoubleRight
              : PhosphorIconsRegular.caretDoubleLeft,
          label: 'nav.collapse'.tr(),
          collapsed: collapsed,
          onTap: onToggleCollapse,
        ),
        if (!collapsed) ...[
          Divider(height: 1, color: theme.dividerColor),
          const Padding(
            padding: EdgeInsets.symmetric(
                vertical: AppSpacing.s3, horizontal: AppSpacing.s3),
            child: PoweredByStrip(logoSize: 18),
          ),
        ],
        const SizedBox(height: AppSpacing.s2),
      ],
    );
  }
}

class _FooterAction extends StatelessWidget {
  const _FooterAction({
    required this.icon,
    required this.label,
    required this.collapsed,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool collapsed;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Tooltip(
        message: collapsed ? label : '',
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s3),
          child: Row(
            mainAxisAlignment:
                collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
              if (!collapsed) ...[
                const SizedBox(width: AppSpacing.s2),
                Text(label,
                    style: AppType.body
                        .copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
