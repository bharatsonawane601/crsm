import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/native_edit_button.dart';
import '../crime_entry/widgets/form_fields.dart';
import '../reports/template_repository.dart';
import 'field_catalog.dart';
import 'template_draft.dart';

/// Create or edit a report template. Rows are reorderable; the value of each
/// row is composed by typing text and inserting fields from the catalog.
class TemplateEditorScreen extends ConsumerStatefulWidget {
  const TemplateEditorScreen({super.key, required this.draft});

  /// A new (id == null) or loaded draft to edit.
  final TemplateDraft draft;

  @override
  ConsumerState<TemplateEditorScreen> createState() =>
      _TemplateEditorScreenState();
}

class _TemplateEditorScreenState extends ConsumerState<TemplateEditorScreen> {
  late final TemplateDraft _draft = widget.draft;
  final _formKey = GlobalKey<FormState>();
  final Map<TemplateRowDraft, TextEditingController> _valueControllers = {};
  bool _saving = false;

  TextEditingController _controllerFor(TemplateRowDraft row) {
    return _valueControllers.putIfAbsent(row, () {
      final c = TextEditingController(text: row.value);
      c.addListener(() => row.value = c.text);
      return c;
    });
  }

  @override
  void dispose() {
    for (final c in _valueControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _addRow() => setState(() => _draft.rows.add(TemplateRowDraft()));

  void _removeRow(int index) {
    setState(() {
      final row = _draft.rows.removeAt(index);
      _valueControllers.remove(row)?.dispose();
    });
  }

  void _reorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final row = _draft.rows.removeAt(oldIndex);
      _draft.rows.insert(newIndex, row);
    });
  }

  Future<void> _insertField(TemplateRowDraft row) async {
    final option = await showModalBottomSheet<FieldOption>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => const _FieldPicker(),
    );
    if (option == null) return;
    final controller = _controllerFor(row);
    final sel = controller.selection;
    final text = controller.text;
    final start = sel.start < 0 ? text.length : sel.start;
    final end = sel.end < 0 ? text.length : sel.end;
    final newText = text.replaceRange(start, end, option.insert);
    controller.value = TextEditingValue(
      text: newText,
      selection:
          TextSelection.collapsed(offset: start + option.insert.length),
    );
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    try {
      final id = await ref.read(templateRepositoryProvider).upsert(
            id: _draft.id,
            name: _draft.name.trim(),
            templateJson: _draft.toJsonString(),
            outputFormat: _draft.outputFormat,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('templates.saved'.tr())));
      Navigator.of(context).pop(id);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          (_draft.isNew ? 'templates.newTitle' : 'templates.editTitle').tr(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _MetaFields(
              draft: _draft,
              onChanged: () => setState(() {}),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('templates.rows'.tr(),
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                buildDefaultDragHandles: false,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                itemCount: _draft.rows.length,
                onReorder: _reorder,
                itemBuilder: (context, i) {
                  final row = _draft.rows[i];
                  return _RowCard(
                    key: ObjectKey(row),
                    index: i,
                    row: row,
                    valueController: _controllerFor(row),
                    onInsert: () => _insertField(row),
                    onRemove:
                        _draft.rows.length > 1 ? () => _removeRow(i) : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _addRow,
                  icon: const Icon(Icons.add),
                  label: Text('templates.addRow'.tr()),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _saving ? null : _save,
                  icon: _saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text('common.save'.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaFields extends StatelessWidget {
  const _MetaFields({required this.draft, required this.onChanged});
  final TemplateDraft draft;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        children: [
          AppTextField(
            label: 'templates.name'.tr(),
            initialValue: draft.name,
            validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'validation.required'.tr() : null,
            onChanged: (v) => draft.name = v,
          ),
          AppTextField(
            label: 'templates.header'.tr(),
            initialValue: draft.header,
            onChanged: (v) => draft.header = v,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: draft.pageSize,
                  decoration: InputDecoration(
                    labelText: 'templates.pageSize'.tr(),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'A4', child: Text('A4')),
                    DropdownMenuItem(value: 'Letter', child: Text('Letter')),
                  ],
                  onChanged: (v) {
                    draft.pageSize = v ?? 'A4';
                    onChanged();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: draft.outputFormat,
                  decoration: InputDecoration(
                    labelText: 'templates.format'.tr(),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    DropdownMenuItem(
                        value: 'docx', child: Text('report.docx'.tr())),
                    DropdownMenuItem(
                        value: 'pdf', child: Text('report.pdf'.tr())),
                  ],
                  onChanged: (v) {
                    draft.outputFormat = v ?? 'docx';
                    onChanged();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RowCard extends StatelessWidget {
  const _RowCard({
    super.key,
    required this.index,
    required this.row,
    required this.valueController,
    required this.onInsert,
    required this.onRemove,
  });

  final int index;
  final TemplateRowDraft row;
  final TextEditingController valueController;
  final VoidCallback onInsert;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Column(
          children: [
            Row(
              children: [
                ReorderableDragStartListener(
                  index: index,
                  child: const Icon(Icons.drag_handle),
                ),
                const SizedBox(width: 8),
                Text('${index + 1}',
                    style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                IconButton(
                  tooltip: 'templates.insertField'.tr(),
                  icon: const Icon(Icons.data_object),
                  onPressed: onInsert,
                ),
                IconButton(
                  tooltip: 'common.remove'.tr(),
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemove,
                ),
              ],
            ),
            AppTextField(
              label: 'templates.rowLabel'.tr(),
              initialValue: row.label,
              onChanged: (v) => row.label = v,
            ),
            TextFormField(
              controller: valueController,
              maxLines: 2,
              autocorrect: false,
              enableSuggestions: false,
              smartDashesType: SmartDashesType.disabled,
              smartQuotesType: SmartQuotesType.disabled,
              decoration: InputDecoration(
                labelText: 'templates.rowValue'.tr(),
                helperText: 'templates.rowValueHint'.tr(),
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: NativeEditButton.maybe(valueController,
                    title: 'templates.rowValue'.tr()),
              ),
            ),
            const SizedBox(height: 8),
            AppTextField(
              label: 'templates.rowFallback'.tr(),
              initialValue: row.fallback,
              onChanged: (v) => row.fallback = v,
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldPicker extends ConsumerWidget {
  const _FieldPicker();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = context.locale;

    final groups = [
      ...kFieldCatalog,
    ];

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(16),
          children: [
            Text('templates.fieldPicker'.tr(),
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            for (final group in groups) ...[
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Text(group.title(locale),
                    style: Theme.of(context).textTheme.titleSmall),
              ),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final opt in group.options)
                    ActionChip(
                      label: Text(opt.label(locale)),
                      onPressed: () => Navigator.of(context).pop(opt),
                    ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }
}
