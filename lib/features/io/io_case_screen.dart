import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/spacing.dart';
import '../../shared/widgets/native_edit_button.dart';
import '../../data/db/database.dart';
import '../crime_entry/data/crime_types_data.dart';
import 'forms/crime_details_model.dart';
import 'forms/crime_details_screen.dart';
import 'io_case_data_screen.dart';
import 'forms/mo_form_e_model.dart';
import 'forms/mo_form_e_screen.dart';
import 'forms/seizure_form_model.dart';
import 'forms/seizure_form_screen.dart';
import 'io_form_screen.dart';
import 'io_forms_catalog.dart';
import 'io_repository.dart';
import 'io_scene_tab.dart';

/// Opens the right screen for a form: forms with a dedicated pixel-exact screen
/// route there; everything else uses the generic fillable form screen.
void openIoForm(BuildContext context, int caseId, String formId) {
  Navigator.of(context).push(MaterialPageRoute<void>(
    builder: (_) => switch (formId) {
      kCrimeDetailsId => CrimeDetailsScreen(caseId: caseId),
      kMoFormEId => MoFormEScreen(caseId: caseId),
      kSeizureFormId => SeizureFormScreen(caseId: caseId),
      _ => IoFormScreen(caseId: caseId, formId: formId),
    },
  ));
}

/// A single case: its applicable forms, the people involved, and the seized
/// property. Everything the IO enters here flows into the generated forms.
class IoCaseScreen extends ConsumerWidget {
  const IoCaseScreen({super.key, required this.caseId});
  final int caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseAsync = ref.watch(ioCaseProvider(caseId));

    return caseAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('portal.error'.tr()))),
      data: (c) {
        if (c == null) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(child: Text('io.caseMissing'.tr())),
          );
        }
        final title = (c.title != null && c.title!.isNotEmpty)
            ? c.title!
            : (c.crimeType != null
                ? crimeTypeMarathi(c.crimeType!)
                : 'io.untitled'.tr());
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.policeNavy,
              foregroundColor: Colors.white,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w700)),
                  if (c.crimeType != null)
                    Text(crimeCategoryOf(c.crimeType!) ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.policeKhakiLight)),
                ],
              ),
              actions: [
                IconButton(
                  tooltip: 'io.data.title'.tr(),
                  icon: const Icon(PhosphorIconsRegular.notePencil),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => IoCaseDataScreen(caseId: caseId))),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(PhosphorIconsRegular.dotsThreeVertical),
                  onSelected: (v) => _onMenu(context, ref, c, v),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: 'toggle',
                        child: Text(c.status == 'closed'
                            ? 'io.reopen'.tr()
                            : 'io.closeCase'.tr())),
                    const PopupMenuDivider(),
                    PopupMenuItem(
                        value: 'delete', child: Text('common.delete'.tr())),
                  ],
                ),
              ],
              bottom: TabBar(
                indicatorColor: AppColors.policeKhaki,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.policeKhakiLight,
                isScrollable: true,
                tabAlignment: TabAlignment.center,
                tabs: [
                  Tab(text: 'io.tab.forms'.tr()),
                  Tab(text: 'io.tab.scene'.tr()),
                  Tab(text: 'io.tab.people'.tr()),
                  Tab(text: 'io.tab.property'.tr()),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                _FormsTab(c: c),
                IoSceneTab(caseId: caseId),
                _PeopleTab(caseId: caseId),
                _PropertyTab(caseId: caseId),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _onMenu(
      BuildContext context, WidgetRef ref, IoCase c, String v) async {
    final repo = ref.read(ioRepositoryProvider);
    if (v == 'toggle') {
      await repo.setCaseStatus(c.id, c.status == 'closed' ? 'active' : 'closed');
    } else if (v == 'delete') {
      final ok = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          content: Text('io.deleteCaseConfirm'.tr()),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('common.cancel'.tr())),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('common.delete'.tr())),
          ],
        ),
      );
      if (ok == true) {
        await repo.deleteCase(c.id);
        if (context.mounted) Navigator.pop(context);
      }
    }
  }
}

// ---------------------------------------------------------------------------
// Forms tab
// ---------------------------------------------------------------------------
class _FormsTab extends ConsumerWidget {
  const _FormsTab({required this.c});
  final IoCase c;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formsAsync = ref.watch(ioFormsProvider(c.id));
    final category = c.crimeType != null ? crimeCategoryOf(c.crimeType!) : null;
    final suggested = suggestedForms(category);

    return formsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('portal.error'.tr())),
      data: (instances) {
        final byId = {for (final f in instances) f.formId: f};
        // Group the suggested forms by their kit section.
        final groups = <IoFormGroup, List<IoFormSpec>>{};
        for (final f in suggested) {
          groups.putIfAbsent(f.group, () => []).add(f);
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.s3),
          children: [
            for (final entry in groups.entries) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, AppSpacing.s3, 4, 4),
                child: Text(_groupLabel(entry.key),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppColors.policeNavy,
                        fontWeight: FontWeight.w700)),
              ),
              for (final spec in entry.value)
                _FormTile(caseId: c.id, spec: spec, instance: byId[spec.id]),
            ],
            const SizedBox(height: AppSpacing.s4),
            OutlinedButton.icon(
              icon: const Icon(Icons.add),
              label: Text('io.addAnotherForm'.tr()),
              onPressed: () => _addAnother(context, ref, category),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addAnother(
      BuildContext context, WidgetRef ref, String? category) async {
    final others = otherForms(category);
    final picked = await showModalBottomSheet<IoFormSpec>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppSpacing.s4),
              child: Text('io.addAnotherForm'.tr(),
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            for (final f in others)
              ListTile(
                leading: const Icon(PhosphorIconsRegular.filePlus),
                title: Text(f.mr),
                subtitle: Text(f.en),
                onTap: () => Navigator.pop(context, f),
              ),
          ],
        ),
      ),
    );
    if (picked != null && context.mounted) {
      _open(context, ref, picked);
    }
  }

  void _open(BuildContext context, WidgetRef ref, IoFormSpec spec) {
    openIoForm(context, c.id, spec.id);
  }

  String _groupLabel(IoFormGroup g) => switch (g) {
        IoFormGroup.scene => 'io.group.scene'.tr(),
        IoFormGroup.seizure => 'io.group.seizure'.tr(),
        IoFormGroup.arrest => 'io.group.arrest'.tr(),
        IoFormGroup.death => 'io.group.death'.tr(),
        IoFormGroup.medical => 'io.group.medical'.tr(),
        IoFormGroup.notice => 'io.group.notice'.tr(),
        IoFormGroup.closure => 'io.group.closure'.tr(),
        IoFormGroup.other => 'io.group.other'.tr(),
      };
}

class _FormTile extends StatelessWidget {
  const _FormTile({required this.caseId, required this.spec, this.instance});
  final int caseId;
  final IoFormSpec spec;
  final IoForm? instance;

  @override
  Widget build(BuildContext context) {
    final started = instance != null;
    final complete = instance?.status == 'complete';
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: ListTile(
        leading: Icon(
          complete
              ? PhosphorIconsFill.checkCircle
              : (started
                  ? PhosphorIconsRegular.pencilSimpleLine
                  : PhosphorIconsRegular.fileDashed),
          color: complete ? Colors.green : AppColors.policeNavy,
        ),
        title: Text(spec.mr),
        subtitle: Text(spec.en),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => openIoForm(context, caseId, spec.id),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// People tab (reusable parties)
// ---------------------------------------------------------------------------
class _PeopleTab extends ConsumerWidget {
  const _PeopleTab({required this.caseId});
  final int caseId;

  static const _roles = ['complainant', 'accused', 'panch', 'deceased', 'witness'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(ioPartiesProvider(caseId));
    return Scaffold(
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('portal.error'.tr())),
        data: (list) {
          if (list.isEmpty) {
            return Center(child: Text('io.noPeople'.tr()));
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.s3),
            children: [
              for (final p in list)
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.user),
                  title: Text(p.name),
                  subtitle: Text('io.role.${p.role}'.tr()),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        ref.read(ioRepositoryProvider).deleteParty(p.id),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add(context, ref),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final name = TextEditingController();
    var role = _roles.first;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('io.addPerson'.tr()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                initialValue: role,
                decoration: InputDecoration(labelText: 'io.roleLabel'.tr()),
                items: [
                  for (final r in _roles)
                    DropdownMenuItem(value: r, child: Text('io.role.$r'.tr())),
                ],
                onChanged: (v) => setState(() => role = v ?? role),
              ),
              const SizedBox(height: AppSpacing.s2),
              TextField(
                controller: name,
                decoration: InputDecoration(
                    labelText: 'io.name'.tr(),
                    suffixIcon:
                        NativeEditButton.maybe(name, title: 'io.name'.tr())),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('common.cancel'.tr())),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('common.add'.tr())),
          ],
        ),
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty) {
      await ref
          .read(ioRepositoryProvider)
          .addParty(caseId, role, name.text.trim());
    }
    name.dispose();
  }
}

// ---------------------------------------------------------------------------
// Property tab (seized exhibits / मुद्देमाल)
// ---------------------------------------------------------------------------
class _PropertyTab extends ConsumerWidget {
  const _PropertyTab({required this.caseId});
  final int caseId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(ioExhibitsProvider(caseId));
    return Scaffold(
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('portal.error'.tr())),
        data: (list) {
          if (list.isEmpty) {
            return Center(child: Text('io.noProperty'.tr()));
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.s3),
            children: [
              for (final x in list)
                ListTile(
                  leading: const Icon(PhosphorIconsRegular.package),
                  title: Text(x.description),
                  subtitle: Text([
                    if (x.category != null) x.category!,
                    if (x.seizedFrom != null)
                      '${'io.seizedFrom'.tr()}: ${x.seizedFrom}',
                    if (x.value != null) '₹${x.value!.toStringAsFixed(0)}',
                  ].join(' · ')),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        ref.read(ioRepositoryProvider).deleteExhibit(x.id),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final desc = TextEditingController();
    final from = TextEditingController();
    final value = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('io.addProperty'.tr()),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: desc,
                  decoration: InputDecoration(
                      labelText: 'io.description'.tr(),
                      suffixIcon: NativeEditButton.maybe(desc,
                          title: 'io.description'.tr()))),
              const SizedBox(height: AppSpacing.s2),
              TextField(
                  controller: from,
                  decoration: InputDecoration(
                      labelText: 'io.seizedFrom'.tr(),
                      suffixIcon: NativeEditButton.maybe(from,
                          title: 'io.seizedFrom'.tr()))),
              const SizedBox(height: AppSpacing.s2),
              TextField(
                  controller: value,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'io.value'.tr())),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('common.cancel'.tr())),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('common.add'.tr())),
        ],
      ),
    );
    if (ok == true && desc.text.trim().isNotEmpty) {
      await ref.read(ioRepositoryProvider).addExhibit(
            caseId,
            desc.text.trim(),
            seizedFrom: from.text.trim().isEmpty ? null : from.text.trim(),
            value: double.tryParse(value.text.trim()),
          );
    }
    desc.dispose();
    from.dispose();
    value.dispose();
  }
}
