import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../data/bns_data.dart';

/// Multi-select sections editor. The officer picks an Act (BNS, NDPS, etc.) on
/// the left and a section number on the right, then taps + to add as many as
/// needed (e.g. "BNS 103"). Sections can also be typed freely. Selected entries
/// are kept as removable chips and reported back to the draft as a
/// comma-separated string (so the existing single `section` column, reports and
/// search keep working unchanged).
class SectionsField extends StatefulWidget {
  const SectionsField({
    super.key,
    required this.initial,
    required this.onChanged,
    required this.options,
    required this.acts,
  });

  /// Comma-separated initial value from the draft.
  final String? initial;

  /// Called with the new comma-separated value whenever the set changes.
  final ValueChanged<String> onChanged;

  final List<String> options;

  /// Acts shown in the left dropdown.
  final List<ActOption> acts;

  @override
  State<SectionsField> createState() => _SectionsFieldState();
}

class _SectionsFieldState extends State<SectionsField> {
  late final List<String> _items = _parse(widget.initial);
  late ActOption _act = widget.acts.first;
  TextEditingController? _ctrl;

  List<String> _parse(String? s) => (s ?? '')
      .split(',')
      .map((e) => e.trim())
      .where((e) => e.isNotEmpty)
      .toList();

  void _emit() => widget.onChanged(_items.join(', '));

  void _add(String raw) {
    final v = raw.trim();
    if (v.isEmpty) return;
    // Prefix the chosen act's short code, e.g. "BNS 103" (skip for "Other").
    final entry = _act.code == 'Other' ? v : '${_act.code} $v';
    if (!_items.contains(entry)) {
      setState(() => _items.add(entry));
      _emit();
    }
    _ctrl?.clear();
  }

  void _remove(String v) {
    setState(() => _items.remove(v));
    _emit();
  }

  /// Opens a searchable list of all Acts (filter by name or short code). With
  /// 100+ Acts a plain dropdown is unusable, so the officer types to narrow down.
  Future<void> _pickAct() async {
    final picked = await showDialog<ActOption>(
      context: context,
      builder: (ctx) => _ActPickerDialog(acts: widget.acts, selected: _act),
    );
    if (picked != null) setState(() => _act = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('crime.info.sections'.tr(),
              style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          if (_items.isEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('crime.info.noSections'.tr(),
                  style: theme.textTheme.bodySmall),
            )
          else
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final s in _items)
                    InputChip(
                      label: Text(s),
                      onDeleted: () => _remove(s),
                      deleteIconColor: theme.colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Act selector (left half) — opens a searchable picker.
              Expanded(
                flex: 5,
                child: InkWell(
                  onTap: _pickAct,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'crime.info.act'.tr(),
                      border: const OutlineInputBorder(),
                      isDense: true,
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                    ),
                    child: Text(_act.code,
                        overflow: TextOverflow.ellipsis, maxLines: 1),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Section number (right half).
              Expanded(
                flex: 5,
                child: Autocomplete<String>(
                  optionsBuilder: (value) {
                    final q = value.text.trim().toLowerCase();
                    if (q.isEmpty) return const Iterable<String>.empty();
                    return widget.options
                        .where((o) => o.toLowerCase().contains(q));
                  },
                  onSelected: _add,
                  fieldViewBuilder:
                      (context, controller, focusNode, onSubmit) {
                    _ctrl = controller;
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      autocorrect: false,
                      enableSuggestions: false,
                      smartDashesType: SmartDashesType.disabled,
                      smartQuotesType: SmartQuotesType.disabled,
                      onSubmitted: (v) {
                        _add(v);
                        focusNode.requestFocus();
                      },
                      decoration: InputDecoration(
                        labelText: 'crime.info.section'.tr(),
                        hintText: 'e.g. 103',
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    );
                  },
                  optionsViewBuilder: (context, onSelected, opts) {
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 4,
                        borderRadius: BorderRadius.circular(8),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                              maxHeight: 280, maxWidth: 460),
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: opts.length,
                            itemBuilder: (context, i) {
                              final o = opts.elementAt(i);
                              return InkWell(
                                onTap: () => onSelected(o),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  child: Text(o),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              // The "+" button: adds whatever is currently typed.
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: IconButton.filled(
                  tooltip: 'crime.info.addSection'.tr(),
                  icon: const Icon(Icons.add),
                  onPressed: () => _add(_ctrl?.text ?? ''),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A searchable Act chooser: a search box over the full Acts list, filtering by
/// name or short code. Returns the chosen [ActOption] (or null if cancelled).
class _ActPickerDialog extends StatefulWidget {
  const _ActPickerDialog({required this.acts, required this.selected});

  final List<ActOption> acts;
  final ActOption selected;

  @override
  State<_ActPickerDialog> createState() => _ActPickerDialogState();
}

class _ActPickerDialogState extends State<_ActPickerDialog> {
  String _query = '';

  List<ActOption> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.acts;
    return widget.acts
        .where((a) =>
            a.name.toLowerCase().contains(q) ||
            a.code.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = _filtered;
    return AlertDialog(
      title: Text('crime.info.selectAct'.tr()),
      content: SizedBox(
        width: 460,
        height: 460,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              autocorrect: false,
              enableSuggestions: false,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'crime.info.searchAct'.tr(),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Text('crime.info.noActMatch'.tr(),
                          style: theme.textTheme.bodySmall))
                  : ListView.builder(
                      itemCount: results.length,
                      itemBuilder: (context, i) {
                        final a = results[i];
                        final isSel = a.code == widget.selected.code;
                        return ListTile(
                          dense: true,
                          selected: isSel,
                          leading: isSel
                              ? const Icon(Icons.check, size: 18)
                              : const SizedBox(width: 18),
                          title: Text(a.name),
                          subtitle: Text(a.code),
                          onTap: () => Navigator.pop(context, a),
                        );
                      },
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
      ],
    );
  }
}
