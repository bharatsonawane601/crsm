import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../data/bns_data.dart';

/// Multi-select case-stage editor. A FIR can be at several stages at once
/// (e.g. chargesheet filed **and** under further investigation), so the officer
/// ticks every stage that applies. The selection is stored back as a
/// comma-separated string of stage codes (e.g. "investigation,chargesheet").
class StageMultiField extends StatefulWidget {
  const StageMultiField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  /// Comma-separated stage codes from the draft.
  final String? value;
  final ValueChanged<String> onChanged;

  @override
  State<StageMultiField> createState() => _StageMultiFieldState();
}

class _StageMultiFieldState extends State<StageMultiField> {
  late final Set<String> _selected = _parse(widget.value);

  Set<String> _parse(String? s) {
    final parts = (s ?? '')
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toSet();
    // Expand the legacy 'both' value into its two stages.
    if (parts.remove('both')) {
      parts
        ..add('investigation')
        ..add('chargesheet');
    }
    // Keep only known stages; default to investigation if nothing valid.
    parts.retainWhere(kCaseStages.contains);
    if (parts.isEmpty) parts.add('investigation');
    return parts;
  }

  void _toggle(String code, bool on) {
    setState(() {
      if (on) {
        _selected.add(code);
      } else if (_selected.length > 1) {
        // Always keep at least one stage selected.
        _selected.remove(code);
      }
    });
    // Emit in canonical kCaseStages order.
    widget.onChanged(kCaseStages.where(_selected.contains).join(','));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('crime.info.caseStage'.tr(), style: theme.textTheme.labelLarge),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final s in kCaseStages)
                FilterChip(
                  label: Text('crime.stage.$s'.tr()),
                  selected: _selected.contains(s),
                  onSelected: (on) => _toggle(s, on),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
