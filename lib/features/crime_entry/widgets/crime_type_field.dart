import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../brain/fuzzy.dart';
import '../data/crime_types_data.dart';

/// Crime-type field rendered as a tappable box that opens a hierarchical,
/// searchable picker: top-level categories (Murder, Theft, Cyber Crime, …)
/// expand to show bilingual sub-types. Officers can also type to search across
/// all categories/sub-types in either language, or keep a custom typed value.
///
/// The chosen value is stored verbatim into the draft's `crimeType` (a single
/// "English / Marathi" string), so reports/search/dashboard are unaffected.
class CrimeTypeField extends StatefulWidget {
  const CrimeTypeField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  State<CrimeTypeField> createState() => _CrimeTypeFieldState();
}

class _CrimeTypeFieldState extends State<CrimeTypeField> {
  Future<void> _pick() async {
    final picked = await showDialog<String>(
      context: context,
      builder: (_) => _CrimeTypePickerDialog(current: widget.value),
    );
    if (picked != null) widget.onChanged(picked.isEmpty ? null : picked);
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.value;
    final empty = v == null || v.isEmpty;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: _pick,
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'crime.info.crimeType'.tr(),
            border: const OutlineInputBorder(),
            isDense: true,
            suffixIcon: empty
                ? const Icon(Icons.arrow_drop_down)
                : IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => widget.onChanged(null),
                  ),
          ),
          child: Text(
            empty ? 'crime.info.crimeTypePick'.tr() : v,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: empty ? TextStyle(color: Theme.of(context).hintColor) : null,
          ),
        ),
      ),
    );
  }
}

/// The picker dialog: a search box over the whole tree plus expandable
/// categories. Returns the chosen sub-type label, a custom typed value, or null.
class _CrimeTypePickerDialog extends StatefulWidget {
  const _CrimeTypePickerDialog({this.current});
  final String? current;

  @override
  State<_CrimeTypePickerDialog> createState() => _CrimeTypePickerDialogState();
}

class _CrimeTypePickerDialogState extends State<_CrimeTypePickerDialog> {
  String _query = '';

  /// Brain matching: plain substring in either language, PLUS transliterated
  /// containment so "chori" finds "चोरी", "khun" finds "खून", and small typos
  /// still land ("murdar" → Murder handled by the did-you-mean fallback).
  bool _matches(String s) {
    final q = _query.trim();
    if (q.isEmpty) return true;
    if (s.toLowerCase().contains(q.toLowerCase())) return true;
    final qk = brainKey(q);
    return qk.length >= 2 && brainKey(s).contains(qk);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = _query.trim();
    final searching = q.isNotEmpty;

    // When searching, flatten all matching sub-types (match on either language
    // or the category name) into a single list.
    final List<({String category, CrimeSubType sub})> flat = [];
    if (searching) {
      for (final c in kCrimeCategories) {
        final catHit = _matches(c.en) || _matches(c.mr);
        for (final s in c.subtypes) {
          if (catHit || _matches(s.en) || _matches(s.mr)) {
            flat.add((category: c.label, sub: s));
          }
        }
      }
    }

    return AlertDialog(
      title: Text('crime.info.crimeTypeSelect'.tr()),
      content: SizedBox(
        width: 480,
        height: 520,
        child: Column(
          children: [
            TextField(
              autofocus: true,
              autocorrect: false,
              enableSuggestions: false,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'crime.info.crimeTypeSearch'.tr(),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                isDense: true,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: searching
                  ? _buildSearchResults(theme, flat, q)
                  : _buildCategoryTree(),
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

  Widget _buildSearchResults(
    ThemeData theme,
    List<({String category, CrimeSubType sub})> flat,
    String q,
  ) {
    if (flat.isEmpty) {
      // Nothing matched exactly — the brain suggests the closest types
      // ("murdar" → Murder) before offering to keep the custom text.
      final all = <String>[
        for (final c in kCrimeCategories)
          for (final s in c.subtypes) s.label,
      ];
      final didYouMean =
          brainMatches(q, all, limit: 6, threshold: 0.55);
      return Column(
        children: [
          if (didYouMean.isNotEmpty) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text('brain.didYouMean'.tr(),
                    style: theme.textTheme.labelMedium
                        ?.copyWith(color: theme.colorScheme.primary)),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  for (final m in didYouMean)
                    ListTile(
                      dense: true,
                      leading: const Text('🧠'),
                      title: Text(m.value),
                      onTap: () => Navigator.pop(context, m.value),
                    ),
                ],
              ),
            ),
          ] else
            Expanded(
              child: Center(
                child: Text('crime.info.crimeTypeNoMatch'.tr(),
                    style: theme.textTheme.bodySmall),
              ),
            ),
          const SizedBox(height: 8),
          FilledButton.icon(
            icon: const Icon(Icons.add),
            label: Text(
                'crime.info.crimeTypeUseCustom'.tr(namedArgs: {'text': q})),
            onPressed: () => Navigator.pop(context, q),
          ),
        ],
      );
    }
    return ListView.builder(
      itemCount: flat.length,
      itemBuilder: (context, i) {
        final row = flat[i];
        final isSel = row.sub.label == widget.current;
        return ListTile(
          dense: true,
          selected: isSel,
          leading: isSel
              ? const Icon(Icons.check, size: 18)
              : const SizedBox(width: 18),
          title: Text(row.sub.label),
          subtitle: Text(row.category, style: const TextStyle(fontSize: 11)),
          onTap: () => Navigator.pop(context, row.sub.label),
        );
      },
    );
  }

  Widget _buildCategoryTree() {
    return ListView.builder(
      itemCount: kCrimeCategories.length,
      itemBuilder: (context, i) {
        final c = kCrimeCategories[i];
        // Auto-expand the category that holds the current selection.
        final hasCurrent = c.subtypes.any((s) => s.label == widget.current);
        return ExpansionTile(
          key: PageStorageKey(c.en),
          initiallyExpanded: hasCurrent,
          tilePadding: const EdgeInsets.symmetric(horizontal: 8),
          childrenPadding: const EdgeInsets.only(left: 16),
          title: Text(c.label,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          children: [
            for (final s in c.subtypes)
              ListTile(
                dense: true,
                selected: s.label == widget.current,
                leading: s.label == widget.current
                    ? const Icon(Icons.check, size: 18)
                    : const SizedBox(width: 18),
                title: Text(s.label),
                onTap: () => Navigator.pop(context, s.label),
              ),
          ],
        );
      },
    );
  }
}
