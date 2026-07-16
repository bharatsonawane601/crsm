import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../shared/widgets/native_edit_button.dart';
import '../../data/db/database.dart';
import '../../shared/widgets/crms.dart';
import '../auth/auth_service.dart';
import '../bhag/bhag_screen.dart' show showBhagCrimeTypePicker;
import '../crime_entry/data/crime_types_data.dart';
import '../legal/legal_screen.dart';
import 'io_case_screen.dart';
import 'io_repository.dart';

/// The Investigating-Officer portal. A field-first workspace (phone + PC) where
/// the IO builds a case at the scene and every applicable government form is
/// generated from that one dataset. Owns only the signed-in officer's cases.
class IoPortalShell extends ConsumerWidget {
  const IoPortalShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cases = ref.watch(ioCasesProvider);
    final email = ref.watch(authControllerProvider).value?.email;

    return Scaffold(
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
                  Text('io.title'.tr(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  Text('io.subtitle'.tr(),
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 12, color: AppColors.policeKhakiLight)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          _SyncButton(email: email),
          const DarkModeToggle(),
          const SizedBox(width: 4),
          const Center(child: LanguageToggle()),
          const SizedBox(width: 4),
          PopupMenuButton<String>(
            tooltip: 'common.more'.tr(),
            icon: const Icon(PhosphorIconsRegular.dotsThreeVertical),
            onSelected: (v) {
              switch (v) {
                case 'privacy':
                  openLegal(context, LegalDoc.privacy);
                case 'terms':
                  openLegal(context, LegalDoc.terms);
                case 'signout':
                  ref.read(authControllerProvider.notifier).signOut();
              }
            },
            itemBuilder: (_) => [
              PopupMenuItem(value: 'privacy', child: Text('legal.privacy'.tr())),
              PopupMenuItem(value: 'terms', child: Text('legal.terms'.tr())),
              const PopupMenuDivider(),
              PopupMenuItem(value: 'signout', child: Text('login.signOut'.tr())),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _newCase(context, ref, email),
        icon: const Icon(Icons.add),
        label: Text('io.newCase'.tr()),
      ),
      body: cases.when(
        loading: () => const CrmsListSkeleton(rows: 4),
        error: (e, _) => Center(child: Text('portal.error'.tr())),
        data: (list) {
          if (list.isEmpty) {
            return CrmsEmptyState(
              icon: PhosphorIconsRegular.folderOpen,
              title: 'io.empty.title'.tr(),
              message: 'io.empty.message'.tr(),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.s3),
            itemCount: list.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.s2),
            itemBuilder: (context, i) => _CaseCard(c: list[i]),
          );
        },
      ),
    );
  }

  Future<void> _newCase(
      BuildContext context, WidgetRef ref, String? email) async {
    final created = await showDialog<int>(
      context: context,
      builder: (_) => _NewCaseDialog(ownerEmail: email),
    );
    if (created != null && context.mounted) {
      Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => IoCaseScreen(caseId: created)));
    }
  }
}

/// The "Sync" action: pushes the IO's local cases to the central store and
/// pulls back anything newer (phone ↔ PC). Shows a spinner while running.
class _SyncButton extends ConsumerStatefulWidget {
  const _SyncButton({required this.email});
  final String? email;

  @override
  ConsumerState<_SyncButton> createState() => _SyncButtonState();
}

class _SyncButtonState extends ConsumerState<_SyncButton> {
  bool _busy = false;

  Future<void> _sync() async {
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    final outcome =
        await ref.read(ioRepositoryProvider).syncNow(widget.email);
    if (!mounted) return;
    setState(() => _busy = false);
    final key = switch (outcome) {
      IoSyncOutcome.ok => 'io.syncDone',
      IoSyncOutcome.failed => 'io.syncFailed',
      IoSyncOutcome.offline => 'io.syncOffline',
    };
    messenger.showSnackBar(
        SnackBar(content: Text(key.tr()), duration: const Duration(seconds: 2)));
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: _busy ? null : _sync,
      style: TextButton.styleFrom(foregroundColor: Colors.white),
      icon: _busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white))
          : const Icon(PhosphorIconsRegular.arrowsClockwise, size: 18),
      label: Text(_busy ? 'io.syncing'.tr() : 'io.sync'.tr(),
          style: const TextStyle(color: Colors.white)),
    );
  }
}

/// One case row in the list.
class _CaseCard extends StatelessWidget {
  const _CaseCard({required this.c});
  final IoCase c;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final title = (c.title != null && c.title!.isNotEmpty)
        ? c.title!
        : (c.crimeType != null
            ? crimeTypeMarathi(c.crimeType!)
            : 'io.untitled'.tr());
    final fir = c.firNo != null && c.firNo!.isNotEmpty
        ? '${'crime.info.firNo'.tr()} ${c.firNo}/${c.year ?? ''}'
        : 'io.freshCase'.tr();
    return CrmsCard(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: CircleAvatar(
          backgroundColor: AppColors.policeNavy.withValues(alpha: 0.1),
          child: const Icon(PhosphorIconsRegular.folder,
              color: AppColors.policeNavy),
        ),
        title: Text(title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall),
        subtitle: Text(
            '$fir · ${c.policeStation ?? ''}${c.status == 'closed' ? ' · ${'io.closed'.tr()}' : ''}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => IoCaseScreen(caseId: c.id))),
      ),
    );
  }
}

/// Dialog to open a new case: pick the crime type (drives which forms apply),
/// plus optional FIR identity. Fresh (scene-first) cases leave FIR blank.
class _NewCaseDialog extends ConsumerStatefulWidget {
  const _NewCaseDialog({required this.ownerEmail});
  final String? ownerEmail;

  @override
  ConsumerState<_NewCaseDialog> createState() => _NewCaseDialogState();
}

class _NewCaseDialogState extends ConsumerState<_NewCaseDialog> {
  String? _crimeType;
  final _firNo = TextEditingController();
  final _year = TextEditingController(text: '${DateTime.now().year}');
  final _district = TextEditingController();
  final _station = TextEditingController();
  final _title = TextEditingController();

  @override
  void dispose() {
    _firNo.dispose();
    _year.dispose();
    _district.dispose();
    _station.dispose();
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final crimeLabel = _crimeType == null
        ? 'io.pickCrime'.tr()
        : crimeTypeMarathi(_crimeType!);
    return AlertDialog(
      title: Text('io.newCase'.tr()),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                icon: const Icon(PhosphorIconsRegular.listMagnifyingGlass),
                label: Text(crimeLabel, overflow: TextOverflow.ellipsis),
                onPressed: () async {
                  final t = await showBhagCrimeTypePicker(context);
                  if (t != null && t.isNotEmpty) {
                    setState(() => _crimeType = t);
                  }
                },
              ),
              const SizedBox(height: AppSpacing.s2),
              Row(
                children: [
                  Expanded(
                      child: _field(_firNo, 'crime.info.firNo'.tr())),
                  const SizedBox(width: AppSpacing.s2),
                  SizedBox(
                      width: 90,
                      child: _field(_year, 'crime.info.year'.tr(),
                          number: true)),
                ],
              ),
              const SizedBox(height: AppSpacing.s2),
              _field(_district, 'io.district'.tr()),
              const SizedBox(height: AppSpacing.s2),
              _field(_station, 'io.policeStation'.tr()),
              const SizedBox(height: AppSpacing.s2),
              _field(_title, 'io.caseTitle'.tr()),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common.cancel'.tr())),
        FilledButton(
          onPressed: _crimeType == null ? null : _create,
          child: Text('common.create'.tr()),
        ),
      ],
    );
  }

  Widget _field(TextEditingController c, String label, {bool number = false}) {
    return TextField(
      controller: c,
      keyboardType: number ? TextInputType.number : null,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        suffixIcon: number ? null : NativeEditButton.maybe(c, title: label),
      ),
    );
  }

  Future<void> _create() async {
    final repo = ref.read(ioRepositoryProvider);
    final id = await repo.createCase(
      title: _title.text.trim().isEmpty ? null : _title.text.trim(),
      crimeType: _crimeType,
      crimeCategory: crimeCategoryOf(_crimeType),
      firNo: _firNo.text.trim().isEmpty ? null : _firNo.text.trim(),
      year: int.tryParse(_year.text.trim()),
      district: _district.text.trim().isEmpty ? null : _district.text.trim(),
      policeStation:
          _station.text.trim().isEmpty ? null : _station.text.trim(),
      ownerEmail: widget.ownerEmail,
    );
    if (mounted) Navigator.pop(context, id);
  }
}
