import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../access/access_client.dart';
import '../access/access_service.dart';
import '../auth/auth_service.dart';
import '../crime_entry/crime_entry_screen.dart';
import '../portal/central_client.dart';
import 'messages_client.dart';
import 'notifications_controller.dart';

/// Opens the Notification Center: command messages from senior officers +
/// the brain's pending-case alerts. Marks messages read on open.
Future<void> showNotificationCenter(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => const Dialog(
      alignment: Alignment.topRight,
      insetPadding: EdgeInsets.only(top: 56, right: 16, bottom: 24),
      child: SizedBox(width: 440, child: _NotificationCenter()),
    ),
  );
}

class _NotificationCenter extends ConsumerStatefulWidget {
  const _NotificationCenter();

  @override
  ConsumerState<_NotificationCenter> createState() =>
      _NotificationCenterState();
}

class _NotificationCenterState extends ConsumerState<_NotificationCenter> {
  /// Read-marker captured at open, so just-arrived messages stay highlighted
  /// while the panel is open (they're marked read for next time immediately).
  int _readAtOpen = 0;

  @override
  void initState() {
    super.initState();
    final n = ref.read(notificationsControllerProvider);
    _readAtOpen = n.lastReadId;
    ref.read(notificationsControllerProvider.notifier)
      ..refresh()
      ..markRead();
  }

  bool get _canSend {
    final role = ref.read(accessControllerProvider).role;
    return role == OfficerRole.cp ||
        role == OfficerRole.dcp ||
        role == OfficerRole.acp ||
        role == OfficerRole.hq;
  }

  @override
  Widget build(BuildContext context) {
    final n = ref.watch(notificationsControllerProvider);
    final theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: SizedBox(
        height: 560,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
              child: Row(
                children: [
                  Text('notif.title'.tr(),
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  if (_canSend)
                    FilledButton.tonalIcon(
                      icon: const Icon(PhosphorIconsRegular.paperPlaneTilt,
                          size: 16),
                      label: Text('notif.compose'.tr()),
                      onPressed: () => _openCompose(context),
                    ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            TabBar(tabs: [
              Tab(text: 'notif.messages'.tr()),
              Tab(
                  text:
                      '${'notif.alerts'.tr()}${n.alerts.isEmpty ? '' : ' (${n.alerts.length})'}'),
            ]),
            Expanded(
              child: TabBarView(children: [
                _MessagesList(state: n, readAtOpen: _readAtOpen),
                _AlertsList(alerts: n.alerts),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCompose(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) => const _ComposeDialog(),
    );
    if (mounted) ref.read(notificationsControllerProvider.notifier).refresh();
  }
}

class _MessagesList extends StatelessWidget {
  const _MessagesList({required this.state, required this.readAtOpen});
  final NotificationsState state;
  final int readAtOpen;

  static final _fmt = DateFormat('dd MMM yyyy, HH:mm');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (state.loading && state.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.messages.isEmpty) {
      return Center(
          child: Text('notif.empty'.tr(), style: theme.textTheme.bodySmall));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: state.messages.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, i) {
        final m = state.messages[i];
        final unread = m.id > readAtOpen;
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: unread
                ? theme.colorScheme.primaryContainer.withValues(alpha: 0.35)
                : theme.colorScheme.surfaceContainerHighest
                    .withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: unread
                    ? theme.colorScheme.primary.withValues(alpha: 0.4)
                    : theme.dividerColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(m.fromRole.toUpperCase(),
                      style: theme.textTheme.labelSmall
                          ?.copyWith(fontWeight: FontWeight.w700)),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    m.fromName.isEmpty ? m.from : m.fromName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(_fmt.format(m.at), style: theme.textTheme.labelSmall),
              ]),
              const SizedBox(height: 6),
              Text(m.body, style: theme.textTheme.bodyMedium),
              const SizedBox(height: 6),
              Text('→ ${m.target}',
                  style: theme.textTheme.labelSmall
                      ?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        );
      },
    );
  }
}

class _AlertsList extends StatelessWidget {
  const _AlertsList({required this.alerts});
  final List<CaseAlert> alerts;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (alerts.isEmpty) {
      return Center(
          child:
              Text('notif.emptyAlerts'.tr(), style: theme.textTheme.bodySmall));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: alerts.length,
      separatorBuilder: (_, _) => const SizedBox(height: 6),
      itemBuilder: (context, i) {
        final a = alerts[i];
        final (icon, color, text) = switch (a.kind) {
          'overdue' => (
              Icons.gavel,
              theme.colorScheme.error,
              'notif.overdue'
                  .tr(namedArgs: {'fir': a.fir, 'n': '${a.daysLeft}'}),
            ),
          'deadline' => (
              Icons.gavel_outlined,
              Colors.orange,
              'notif.deadline'
                  .tr(namedArgs: {'fir': a.fir, 'n': '${a.daysLeft}'}),
            ),
          _ => (
              Icons.hourglass_empty,
              theme.colorScheme.onSurfaceVariant,
              'notif.stale'
                  .tr(namedArgs: {'fir': a.fir, 'n': '${a.daysStale}'}),
            ),
        };
        return ListTile(
          dense: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: theme.dividerColor)),
          leading: Icon(icon, size: 20, color: color),
          title: Text(text, style: theme.textTheme.bodySmall),
          trailing: const Icon(Icons.chevron_right, size: 18),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(MaterialPageRoute<Object?>(
                builder: (_) => CrimeEntryScreen(crimeId: a.crimeId)));
          },
        );
      },
    );
  }
}

/// Compose: pick reach (all / zone / division / station / one user) and send.
/// The server re-checks the sender's rank; this UI only offers what the rank
/// can legally target.
class _ComposeDialog extends ConsumerStatefulWidget {
  const _ComposeDialog();

  @override
  ConsumerState<_ComposeDialog> createState() => _ComposeDialogState();
}

class _ComposeDialogState extends ConsumerState<_ComposeDialog> {
  final _body = TextEditingController();
  String _targetType = 'all';
  int? _targetId;
  String? _targetEmail;
  PortalScopeTree _tree = PortalScopeTree.empty;
  List<MessageUser> _users = const [];
  bool _loading = true;
  bool _sending = false;

  String? get _email => ref.read(authControllerProvider).value?.email;

  List<String> get _types {
    final role = ref.read(accessControllerProvider).role;
    return switch (role) {
      OfficerRole.cp || OfficerRole.hq => const [
          'all', 'zone', 'division', 'station', 'user'],
      OfficerRole.dcp => const ['zone', 'division', 'station', 'user'],
      OfficerRole.acp => const ['division', 'station', 'user'],
      _ => const [],
    };
  }

  @override
  void initState() {
    super.initState();
    _targetType = _types.isEmpty ? 'all' : _types.first;
    _load();
  }

  Future<void> _load() async {
    final email = _email;
    if (email == null) return;
    final central = CentralClient();
    final tree = await central.scopeTree(email: email);
    central.dispose();
    final users = await ref
        .read(notificationsControllerProvider.notifier)
        .client
        .users(email: email);
    if (!mounted) return;
    setState(() {
      _tree = tree;
      _users = users;
      _loading = false;
    });
  }

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final email = _email;
    final text = _body.text.trim();
    if (email == null || text.isEmpty) return;
    if (_targetType != 'all' && _targetId == null && _targetEmail == null) {
      return;
    }
    setState(() => _sending = true);
    final target = await ref
        .read(notificationsControllerProvider.notifier)
        .client
        .send(
          email: email,
          targetType: _targetType,
          targetId: _targetType == 'user' ? null : _targetId,
          targetEmail: _targetType == 'user' ? _targetEmail : null,
          body: text,
        );
    if (!mounted) return;
    setState(() => _sending = false);
    final messenger = ScaffoldMessenger.of(context);
    if (target != null) {
      Navigator.pop(context);
      messenger.showSnackBar(
          SnackBar(content: Text('notif.sent'.tr(namedArgs: {'to': target}))));
    } else {
      messenger
          .showSnackBar(SnackBar(content: Text('notif.sendFailed'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('notif.composeTitle'.tr()),
      content: SizedBox(
        width: 460,
        child: _loading
            ? const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<String>(
                    initialValue: _targetType,
                    decoration: InputDecoration(
                      labelText: 'notif.target'.tr(),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      for (final t in _types)
                        DropdownMenuItem(
                            value: t, child: Text('notif.target_$t'.tr())),
                    ],
                    onChanged: (v) => setState(() {
                      _targetType = v ?? 'all';
                      _targetId = null;
                      _targetEmail = null;
                    }),
                  ),
                  const SizedBox(height: 10),
                  if (_targetType == 'zone')
                    _pickerInt(
                        [for (final z in _tree.zones) (z.id, z.name)]),
                  if (_targetType == 'division')
                    _pickerInt(
                        [for (final d in _tree.divisions) (d.id, d.name)]),
                  if (_targetType == 'station')
                    _pickerInt(
                        [for (final s in _tree.stations) (s.id, s.name)]),
                  if (_targetType == 'user')
                    DropdownButtonFormField<String>(
                      initialValue: _targetEmail,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'notif.pick'.tr(),
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                      items: [
                        for (final u in _users)
                          DropdownMenuItem(
                            value: u.email,
                            child: Text(
                              u.name.isEmpty
                                  ? u.email
                                  : '${u.name} — ${u.email}'
                                      '${u.scope.isEmpty ? '' : ' (${u.scope})'}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (v) => setState(() => _targetEmail = v),
                    ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _body,
                    maxLines: 5,
                    maxLength: 4000,
                    autocorrect: false,
                    enableSuggestions: false,
                    decoration: InputDecoration(
                      labelText: 'notif.message'.tr(),
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton.icon(
          onPressed: _sending ? null : _send,
          icon: _sending
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(PhosphorIconsRegular.paperPlaneTilt, size: 16),
          label: Text('notif.send'.tr()),
        ),
      ],
    );
  }

  Widget _pickerInt(List<(int, String)> options) {
    return DropdownButtonFormField<int>(
      initialValue: _targetId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'notif.pick'.tr(),
        border: const OutlineInputBorder(),
        isDense: true,
      ),
      items: [
        for (final (id, name) in options)
          DropdownMenuItem(value: id, child: Text(name)),
      ],
      onChanged: (v) => setState(() => _targetId = v),
    );
  }
}
