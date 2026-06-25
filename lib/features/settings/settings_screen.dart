import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/company_logo.dart';
import '../../shared/widgets/language_toggle.dart';
import '../access/access_service.dart';
import '../audit/audit_log_screen.dart';
import '../auth/auth_service.dart';
import '../crime_entry/data/bns_data.dart';
import '../../core/branding.dart';
import '../legal/legal_screen.dart';
import '../reports/template_catalog.dart';
import '../sync/sync_controller.dart';
import '../update/update_controller.dart';
import '../update/update_models.dart';
import '../update/update_screen.dart';
import '../update/update_service.dart';
import 'backup_service.dart';
import 'settings_repository.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key, this.embedded = false});

  /// When true, omits the Scaffold app bar (the shell provides the top bar).
  final bool embedded;

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  AppSettings? _draft;
  bool _busy = false;

  Future<void> _save() async {
    final draft = _draft;
    if (draft == null) return;
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(settingsRepositoryProvider).save(draft);
      ref.invalidate(settingsProvider);
      messenger.showSnackBar(SnackBar(content: Text('settings.saved'.tr())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _backup() async {
    final messenger = ScaffoldMessenger.of(context);
    final dir = await FilePicker.getDirectoryPath();
    if (dir == null) return;
    try {
      final path = await ref.read(backupServiceProvider).backup(dir);
      messenger.showSnackBar(
        SnackBar(content: Text('settings.backupDone'.tr(namedArgs: {'path': path}))),
      );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text('settings.backupFailed'.tr())));
    }
  }

  Future<void> _restore() async {
    final messenger = ScaffoldMessenger.of(context);
    final picked = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['crmsbak'],
    );
    final path = picked?.files.single.path;
    if (path == null) return;
    if (!mounted) return;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('settings.restoreConfirmTitle'.tr()),
        content: Text('settings.restoreConfirmBody'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('common.ok'.tr()),
          ),
        ],
      ),
    );
    if (ok != true) return;

    try {
      await ref.read(backupServiceProvider).stageRestore(path);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('settings.restoreStagedTitle'.tr()),
          content: Text('settings.restoreStagedBody'.tr()),
          actions: [
            FilledButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('common.ok'.tr()),
            ),
          ],
        ),
      );
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text('settings.restoreFailed'.tr())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(settingsProvider);
    final choices = ref.watch(templateChoicesProvider);

    return Scaffold(
      appBar: widget.embedded
          ? null
          : AppBar(
              title: Text('settings.title'.tr()),
              actions: const [
                Center(child: LanguageToggle()),
                SizedBox(width: 12),
              ],
            ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(child: Text('list.loadError'.tr())),
        data: (loaded) {
          final s = _draft ??= loaded;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionCard(
                title: 'settings.station'.tr(),
                children: [
                  _field('settings.stationNameMr'.tr(), s.stationNameMarathi,
                      (v) => _draft = s.copyWith(stationNameMarathi: v)),
                  _stationPicker(s.stationNameEnglish,
                      (v) => _draft = s.copyWith(stationNameEnglish: v)),
                  _field('crime.info.district'.tr(), s.district,
                      (v) => _draft = s.copyWith(district: v)),
                  _field('settings.stationCode'.tr(), s.code,
                      (v) => _draft = s.copyWith(code: v)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String?>(
                    initialValue: choices.any((c) => c.key == s.defaultTemplateKey)
                        ? s.defaultTemplateKey
                        : null,
                    decoration: InputDecoration(
                      labelText: 'settings.defaultTemplate'.tr(),
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text('settings.none'.tr())),
                      for (final c in choices)
                        DropdownMenuItem(value: c.key, child: Text(c.displayName)),
                    ],
                    onChanged: (v) => setState(
                        () => _draft = s.copyWith(defaultTemplateKey: v)),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.icon(
                      onPressed: _busy ? null : _save,
                      icon: const Icon(Icons.save),
                      label: Text('common.save'.tr()),
                    ),
                  ),
                ],
              ),
              _SectionCard(
                title: 'settings.backup'.tr(),
                children: [
                  Text('settings.backupHint'.tr(),
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _backup,
                        icon: const Icon(Icons.backup_outlined),
                        label: Text('settings.backupNow'.tr()),
                      ),
                      OutlinedButton.icon(
                        onPressed: _restore,
                        icon: const Icon(Icons.restore),
                        label: Text('settings.restore'.tr()),
                      ),
                    ],
                  ),
                ],
              ),
              _SectionCard(
                title: 'settings.driveSync'.tr(),
                children: [
                  Text('settings.driveSyncHint'.tr(),
                      style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 12),
                  _DriveSyncControls(),
                ],
              ),
              _SectionCard(
                title: 'settings.access'.tr(),
                children: const [_AccessControls()],
              ),
              _SectionCard(
                title: 'update.settingsTitle'.tr(),
                children: const [_UpdateControls()],
              ),
              _SectionCard(
                title: 'legal.title'.tr(),
                children: const [_LegalControls()],
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.history),
                  title: Text('audit.title'.tr()),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<Object?>(
                        builder: (_) => const AuditLogScreen()),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Station name in English — an autocomplete over the official station list
  /// so it matches the server exactly (this name tags the station's records for
  /// the officer portal). Free text is still allowed for any unlisted station.
  Widget _stationPicker(String value, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Autocomplete<String>(
        initialValue: TextEditingValue(text: value),
        optionsBuilder: (v) {
          final q = v.text.trim().toLowerCase();
          if (q.isEmpty) return kPoliceStations;
          return kPoliceStations.where((o) => o.toLowerCase().contains(q));
        },
        onSelected: onChanged,
        fieldViewBuilder: (context, controller, focusNode, onSubmit) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            autocorrect: false,
            enableSuggestions: false,
            onChanged: onChanged,
            decoration: InputDecoration(
              labelText: 'settings.stationNameEn'.tr(),
              helperText: 'settings.stationNameEnHint'.tr(),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          );
        },
      ),
    );
  }

  Widget _field(String label, String value, ValueChanged<String> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        initialValue: value,
        autocorrect: false,
        enableSuggestions: false,
        smartDashesType: SmartDashesType.disabled,
        smartQuotesType: SmartQuotesType.disabled,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        onChanged: onChanged,
      ),
    );
  }
}

/// Folder picker + manual sync + live status for Google Drive folder sync.
class _DriveSyncControls extends ConsumerWidget {
  static final _ts = DateFormat('dd-MM-yyyy HH:mm');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sync = ref.watch(syncControllerProvider);
    return ListenableBuilder(
      listenable: sync,
      builder: (context, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.folder_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    sync.folder ?? 'settings.notSet'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '${'sync.status.${sync.status.name}'.tr()}'
              '${sync.lastSyncedAt != null ? ' • ${'sync.lastSynced'.tr()} ${_ts.format(sync.lastSyncedAt!.toLocal())}' : ''}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.create_new_folder_outlined),
                  label: Text('settings.chooseFolder'.tr()),
                  onPressed: () async {
                    final dir = await FilePicker.getDirectoryPath();
                    if (dir != null) await sync.setFolder(dir);
                  },
                ),
                FilledButton.icon(
                  icon: const Icon(Icons.sync),
                  label: Text('settings.syncNow'.tr()),
                  onPressed:
                      sync.folder == null ? null : () => sync.syncNow(),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Access status (approved / pending / blocked) + re-check + sign out.
class _AccessControls extends ConsumerWidget {
  const _AccessControls();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accessControllerProvider);
    final user = ref.watch(authControllerProvider).value;
    final theme = Theme.of(context);

    final (color, statusText) = switch (state.gate) {
      AccessGate.approved => (Colors.green, 'settings.accessApproved'.tr()),
      AccessGate.pending => (Colors.orange, 'settings.accessPending'.tr()),
      AccessGate.checking => (Colors.grey, 'settings.accessChecking'.tr()),
      AccessGate.blocked => (theme.colorScheme.error, 'settings.accessBlocked'.tr()),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.circle, size: 12, color: color),
            const SizedBox(width: 8),
            Text(statusText, style: theme.textTheme.bodyMedium),
          ],
        ),
        if (user != null) ...[
          const SizedBox(height: 6),
          Text(user.email, style: theme.textTheme.bodySmall),
        ],
        const SizedBox(height: 12),
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
    );
  }
}

/// Current version + a manual "Check for update" button. The app also checks
/// silently on launch; this is the on-demand path.
class _UpdateControls extends ConsumerStatefulWidget {
  const _UpdateControls();

  @override
  ConsumerState<_UpdateControls> createState() => _UpdateControlsState();
}

class _UpdateControlsState extends ConsumerState<_UpdateControls> {
  final _service = UpdateService();

  Future<void> _check() async {
    final messenger = ScaffoldMessenger.of(context);
    await ref.read(updateControllerProvider.notifier).check();
    if (!mounted) return;
    final state = ref.read(updateControllerProvider);
    switch (state.phase) {
      case UpdatePhase.available:
      case UpdatePhase.mandatory:
        showUpdateDialog(context);
      case UpdatePhase.upToDate:
        messenger.showSnackBar(
            SnackBar(content: Text('update.upToDate'.tr())));
      case UpdatePhase.failed:
        messenger.showSnackBar(SnackBar(
            content: Text((state.error ?? 'update.error.network').tr())));
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(updateControllerProvider);
    final checking = state.phase == UpdatePhase.checking;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('update.settingsHint'.tr(), style: theme.textTheme.bodySmall),
        const SizedBox(height: 8),
        FutureBuilder<String>(
          future: _service.currentVersion(),
          builder: (context, snap) {
            final v = snap.data ?? '';
            if (v.isEmpty) return const SizedBox.shrink();
            return Text('update.currentVersion'.tr(namedArgs: {'v': v}),
                style: theme.textTheme.bodyMedium);
          },
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: checking ? null : _check,
          icon: checking
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.system_update_alt),
          label: Text(checking
              ? 'update.checking'.tr()
              : 'update.checkForUpdate'.tr()),
        ),
        // On macOS the update is a .dmg the user installs manually (Windows
        // installs the .exe silently), so add a short note about the flow.
        if (Platform.isMacOS) ...[
          const SizedBox(height: 8),
          Text('update.macHint'.tr(), style: theme.textTheme.bodySmall),
        ],
      ],
    );
  }
}

/// Privacy Policy / Terms & Licence / Copyright links + vendor "about" line.
class _LegalControls extends StatelessWidget {
  const _LegalControls();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget tile(IconData icon, String label, LegalDoc doc) => ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(icon, size: 20),
          title: Text(label),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => openLegal(context, doc),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        tile(Icons.privacy_tip_outlined, 'legal.privacy'.tr(), LegalDoc.privacy),
        tile(Icons.description_outlined, 'legal.terms'.tr(), LegalDoc.terms),
        tile(Icons.copyright_outlined, 'legal.copyright'.tr(),
            LegalDoc.copyright),
        const SizedBox(height: 12),
        const PoweredByStrip(center: false),
        const SizedBox(height: 2),
        Text(Branding.websiteLabel, style: theme.textTheme.bodySmall),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}
