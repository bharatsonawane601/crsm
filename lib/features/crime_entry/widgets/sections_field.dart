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
              // Act selector (left half).
              Expanded(
                flex: 5,
                child: DropdownButtonFormField<ActOption>(
                  initialValue: _act,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'crime.info.act'.tr(),
                    border: const OutlineInputBorder(),
                    isDense: true,
                  ),
                  items: [
                    for (final a in widget.acts)
                      DropdownMenuItem(
                        value: a,
                        child: Text(a.name,
                            overflow: TextOverflow.ellipsis, maxLines: 1),
                      ),
                  ],
                  // Show the short code when collapsed (full name in the list).
                  selectedItemBuilder: (context) => [
                    for (final a in widget.acts)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(a.code,
                            overflow: TextOverflow.ellipsis, maxLines: 1),
                      ),
                  ],
                  onChanged: (a) =>
                      setState(() => _act = a ?? widget.acts.first),
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
