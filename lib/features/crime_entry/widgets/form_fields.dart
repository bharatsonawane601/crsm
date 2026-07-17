import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/text/native_text_editor.dart';
import '../../brain/fuzzy.dart';

final _dateFmt = DateFormat('dd-MM-yyyy');

/// Labeled text field. [onChanged] mutates the draft directly; it does NOT
/// trigger a rebuild (the value is read again at save time), so typing stays
/// smooth and the cursor never jumps.
///
/// On Windows a small "अ" button opens a native OS text box for reliable
/// Marathi typing (any keyboard/IME). Set [nativeEditor] false (or use a number
/// keyboard) to hide it.
class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.helperText,
    this.nativeEditor = true,
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? helperText;
  final bool nativeEditor;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Offer the native editor for free-text fields (not numbers) on Windows.
  bool get _showNative =>
      widget.nativeEditor &&
      NativeTextEditor.isSupported &&
      widget.keyboardType != TextInputType.number;

  Future<void> _openNative() async {
    final edited = await NativeTextEditor.edit(
      initial: _controller.text,
      title: widget.label,
    );
    if (edited == null) return; // cancelled
    _controller.value = TextEditingValue(
      text: edited,
      selection: TextSelection.collapsed(offset: edited.length),
    );
    widget.onChanged(edited);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: _controller,
        onChanged: widget.onChanged,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        autocorrect: false,
        enableSuggestions: false,
        smartDashesType: SmartDashesType.disabled,
        smartQuotesType: SmartQuotesType.disabled,
        decoration: InputDecoration(
          labelText: widget.label,
          helperText: widget.helperText,
          border: const OutlineInputBorder(),
          isDense: true,
          suffixIcon: _showNative
              ? IconButton(
                  tooltip: 'common.typeMarathi'.tr(),
                  icon: const Text('अ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  onPressed: _openNative,
                )
              : null,
        ),
      ),
    );
  }
}

/// A text field with a searchable dropdown of [options] (e.g. BNS sections,
/// crime types). Like [AppTextField] it mutates the draft directly via
/// [onChanged] and stays free-text — picking a suggestion is optional, so
/// values not in the list (combined sections, rare offences) are never lost.
class AppAutocompleteField extends StatelessWidget {
  const AppAutocompleteField({
    super.key,
    required this.label,
    required this.initialValue,
    required this.onChanged,
    required this.options,
    this.validator,
    this.helperText,
  });

  final String label;
  final String? initialValue;
  final ValueChanged<String> onChanged;
  final List<String> options;
  final String? Function(String?)? validator;
  final String? helperText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Autocomplete<String>(
        initialValue: TextEditingValue(text: initialValue ?? ''),
        optionsBuilder: (value) {
          final raw = value.text.trim();
          if (raw.isEmpty) return options;
          final q = raw.toLowerCase();
          // 1) Plain substring matches first (exactly what was typed).
          final out = options
              .where((o) => o.toLowerCase().contains(q))
              .toList();
          // 2) Brain matches: transliteration ("cidco"→"सिडको") and prefixes.
          final qk = brainKey(raw);
          if (qk.length >= 2) {
            for (final o in options) {
              if (!out.contains(o) && brainKey(o).contains(qk)) out.add(o);
            }
          }
          // 3) Typo tolerance: nothing matched — closest suggestions instead
          //    of an empty dropdown ("Dolatabad" → "Daulatabad").
          if (out.isEmpty) {
            for (final m in brainMatches(raw, options, limit: 5)) {
              out.add(m.value);
            }
          }
          return out;
        },
        onSelected: onChanged,
        fieldViewBuilder: (context, controller, focusNode, onSubmit) {
          return TextFormField(
            controller: controller,
            focusNode: focusNode,
            validator: validator,
            onChanged: onChanged,
            autocorrect: false,
            enableSuggestions: false,
            smartDashesType: SmartDashesType.disabled,
            smartQuotesType: SmartQuotesType.disabled,
            decoration: InputDecoration(
              labelText: label,
              helperText: helperText,
              border: const OutlineInputBorder(),
              isDense: true,
              suffixIcon: const Icon(Icons.arrow_drop_down),
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
                constraints: const BoxConstraints(maxHeight: 280, maxWidth: 460),
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
    );
  }
}

/// Date field rendered as a tappable box opening the native date picker.
class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: value ?? now,
      firstDate: DateTime(now.year - 30),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null) onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _pick(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            isDense: true,
            suffixIcon: value == null
                ? const Icon(Icons.calendar_today, size: 18)
                : IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => onChanged(null),
                  ),
          ),
          child: Text(
            value == null ? 'common.pickDate'.tr() : _dateFmt.format(value!),
            style: value == null
                ? TextStyle(color: Theme.of(context).hintColor)
                : null,
          ),
        ),
      ),
    );
  }
}

/// Time field rendered as a tappable box opening the native clock picker.
/// Stores the chosen time as a display string (e.g. "1:30 PM").
class AppTimeField extends StatelessWidget {
  const AppTimeField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.helperText,
  });

  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;
  final String? helperText;

  /// Best-effort parse of a stored time string back to a [TimeOfDay] so the
  /// picker re-opens on the previously chosen time.
  static TimeOfDay? _parse(String? s) {
    if (s == null || s.trim().isEmpty) return null;
    final m = RegExp(r'(\d{1,2}):(\d{2})\s*([AaPp][Mm])?').firstMatch(s);
    if (m == null) return null;
    var h = int.tryParse(m.group(1)!) ?? 0;
    final min = int.tryParse(m.group(2)!) ?? 0;
    final ap = m.group(3)?.toUpperCase();
    if (ap == 'PM' && h < 12) h += 12;
    if (ap == 'AM' && h == 12) h = 0;
    return TimeOfDay(hour: h % 24, minute: min % 60);
  }

  Future<void> _pick(BuildContext context) async {
    // Capture the formatter before the await so we don't touch context after.
    final l10n = MaterialLocalizations.of(context);
    final picked = await showTimePicker(
      context: context,
      initialTime: _parse(value) ?? TimeOfDay.now(),
      // Police records use a 24-hour clock — force the dial into 24h mode and
      // start on the dial (officers can still switch to keyboard entry).
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
    );
    if (picked != null) {
      onChanged(l10n.formatTimeOfDay(picked, alwaysUse24HourFormat: true));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _pick(context),
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: label,
            helperText: helperText,
            border: const OutlineInputBorder(),
            isDense: true,
            suffixIcon: (value == null || value!.isEmpty)
                ? const Icon(Icons.access_time, size: 18)
                : IconButton(
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () => onChanged(null),
                  ),
          ),
          child: Text(
            (value == null || value!.isEmpty)
                ? 'common.pickTime'.tr()
                : value!,
            style: (value == null || value!.isEmpty)
                ? TextStyle(color: Theme.of(context).hintColor)
                : null,
          ),
        ),
      ),
    );
  }
}

/// Generic dropdown field.
class AppDropdownField<T> extends StatelessWidget {
  const AppDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<T>(
        initialValue: value,
        items: items,
        onChanged: onChanged,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );
  }
}

/// Two fields side by side on wide screens, stacked on narrow ones.
class FieldRow extends StatelessWidget {
  const FieldRow({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) {
          return Column(children: children);
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var i = 0; i < children.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              Expanded(child: children[i]),
            ],
          ],
        );
      },
    );
  }
}

/// A removable card wrapper for dynamic rows (accused, property, attachments).
class RowCard extends StatelessWidget {
  const RowCard({
    super.key,
    required this.title,
    required this.onRemove,
    required this.child,
  });

  final String title;
  final VoidCallback onRemove;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  tooltip: 'common.remove'.tr(),
                  icon: const Icon(Icons.delete_outline),
                  onPressed: onRemove,
                ),
              ],
            ),
            child,
          ],
        ),
      ),
    );
  }
}
