import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/colors.dart';
import '../../shared/widgets/language_toggle.dart';
import '../portal/central_upload_controller.dart';
import 'crime_form_controller.dart';
import 'crime_repository.dart';
import 'tabs.dart';

/// The 7-tab crime entry form. Pass [crimeId] to edit an existing record, or
/// leave it null for a new entry. Returns the saved crime id (or the string
/// 'deleted') via [Navigator.pop].
class CrimeEntryScreen extends ConsumerStatefulWidget {
  const CrimeEntryScreen({super.key, this.crimeId});

  final int? crimeId;

  @override
  ConsumerState<CrimeEntryScreen> createState() => _CrimeEntryScreenState();
}

class _CrimeEntryScreenState extends ConsumerState<CrimeEntryScreen>
    with SingleTickerProviderStateMixin {
  static const _tabCount = 8;

  final _formKey = GlobalKey<FormState>();
  late final TabController _tabController;
  late final CrimeFormModel _model;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabCount, vsync: this)
      ..addListener(() => setState(() {})); // rebuild IndexedStack on tab change
    _model = CrimeFormModel(ref.read(crimeRepositoryProvider));

    if (widget.crimeId != null) {
      _loading = true;
      _model.load(widget.crimeId!).whenComplete(() {
        if (mounted) setState(() => _loading = false);
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    if (!(_formKey.currentState?.validate() ?? false)) {
      messenger.showSnackBar(
        SnackBar(content: Text('crime.fixErrors'.tr())),
      );
      return;
    }
    try {
      final id = await _model.save();
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('crime.saved'.tr())));
      Navigator.of(context).pop(id);
    } catch (_) {
      messenger.showSnackBar(
        SnackBar(content: Text('crime.saveFailed'.tr())),
      );
    }
  }

  Future<void> _delete() async {
    final id = widget.crimeId;
    if (id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('crime.deleteTitle'.tr()),
        content: Text('crime.deleteBody'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final deleted = await ref.read(crimeRepositoryProvider).deleteCrime(id);
    if (deleted != null) {
      ref.read(centralUploadControllerProvider.notifier).reportDeletion(deleted);
    }
    if (!mounted) return;
    Navigator.of(context).pop('deleted');
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.crimeId != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          (isEditing ? 'crime.editTitle' : 'crime.newTitle').tr(),
        ),
        actions: [
          const Center(child: LanguageToggle()),
          if (isEditing)
            IconButton(
              tooltip: 'common.delete'.tr(),
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          const SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: AppColors.policeKhaki,
          tabs: [
            Tab(text: 'crime.tabs.info'.tr()),
            Tab(text: 'crime.tabs.complainant'.tr()),
            Tab(text: 'crime.tabs.accused'.tr()),
            Tab(text: 'crime.tabs.property'.tr()),
            Tab(text: 'crime.tabs.investigation'.tr()),
            Tab(text: 'crime.tabs.preventive'.tr()),
            Tab(text: 'crime.tabs.verdict'.tr()),
            Tab(text: 'crime.tabs.attachments'.tr()),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListenableBuilder(
                listenable: _model,
                builder: (context, _) {
                  // IndexedStack keeps every tab mounted so a single
                  // Form.validate() covers fields on all tabs at once.
                  return IndexedStack(
                    index: _tabController.index,
                    children: [
                      CrimeInfoTab(model: _model),
                      ComplainantTab(model: _model),
                      AccusedTab(model: _model),
                      PropertyTab(model: _model),
                      InvestigationTab(model: _model),
                      PreventiveTab(model: _model),
                      VerdictTab(model: _model),
                      AttachmentsTab(model: _model),
                    ],
                  );
                },
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ListenableBuilder(
            listenable: _model,
            builder: (context, _) => FilledButton.icon(
              onPressed: _model.saving ? null : _save,
              icon: _model.saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text('common.save'.tr()),
            ),
          ),
        ),
      ),
    );
  }
}
