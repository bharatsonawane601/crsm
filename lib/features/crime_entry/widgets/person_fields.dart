import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../crime_repository.dart' show BrainPersonIntel;
import '../models/crime_draft.dart';
import 'form_fields.dart';
import 'validators.dart';

/// Shared identity fields for a [PersonDraft] — used by the complainant tab
/// and inside each accused card. [notify] rebuilds the form when a dropdown
/// changes; text fields mutate the draft directly without a rebuild.
class PersonFields extends StatelessWidget {
  const PersonFields({
    super.key,
    required this.person,
    required this.notify,
    this.nameRequired = false,
    this.multiMobile = false,
    this.repeatLookup,
    this.mobileLookup,
  });

  final PersonDraft person;
  final VoidCallback notify;
  final bool nameRequired;
  // When true (complainant), allow several phone numbers instead of one.
  final bool multiMobile;

  /// Brain: intel on a typed name — other FIRs naming this person (by name or
  /// alias) and where they are WANTED. When set (accused cards), hints appear
  /// under the name field.
  final Future<BrainPersonIntel> Function(String name)? repeatLookup;

  /// Brain: how many OTHER FIRs mention a typed mobile number.
  final Future<int> Function(String mobile)? mobileLookup;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (repeatLookup == null)
          AppTextField(
            label: 'crime.person.name'.tr(),
            initialValue: person.name,
            onChanged: (v) => person.name = v,
            validator: nameRequired ? V.required : null,
          )
        else
          _NameWithRepeatHint(
            person: person,
            nameRequired: nameRequired,
            lookup: repeatLookup!,
          ),
        FieldRow(children: [
          AppDropdownField<String>(
            label: 'crime.person.gender'.tr(),
            value: person.gender,
            items: [
              DropdownMenuItem(
                  value: 'male', child: Text('crime.gender.male'.tr())),
              DropdownMenuItem(
                  value: 'female', child: Text('crime.gender.female'.tr())),
              DropdownMenuItem(
                  value: 'other', child: Text('crime.gender.other'.tr())),
            ],
            onChanged: (v) {
              person.gender = v;
              notify();
            },
          ),
          AppTextField(
            label: 'crime.person.age'.tr(),
            initialValue: person.ageText ?? person.age?.toString(),
            helperText: 'crime.person.ageHint'.tr(),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            nativeEditor: false,
            validator: V.optAge,
            onChanged: (v) {
              final t = v.trim();
              person.ageText = t.isEmpty ? null : t;
              // Keep the integer (years) part for analytics/aggregation.
              person.age = int.tryParse(t.split('.').first);
            },
          ),
        ]),
        AppTextField(
          label: 'crime.person.address'.tr(),
          initialValue: person.address,
          maxLines: 2,
          onChanged: (v) => person.address = v,
        ),
        if (multiMobile) ...[
          MultiMobileField(person: person),
          AppTextField(
            label: 'crime.person.email'.tr(),
            initialValue: person.email,
            keyboardType: TextInputType.emailAddress,
            validator: V.optEmail,
            onChanged: (v) => person.email = v,
          ),
        ] else
          FieldRow(children: [
            if (mobileLookup == null)
              AppTextField(
                label: 'crime.person.mobile'.tr(),
                initialValue: person.mobile,
                keyboardType: TextInputType.phone,
                validator: V.optMobile,
                onChanged: (v) => person.mobile = v,
              )
            else
              _MobileWithLinkHint(person: person, lookup: mobileLookup!),
            AppTextField(
              label: 'crime.person.email'.tr(),
              initialValue: person.email,
              keyboardType: TextInputType.emailAddress,
              validator: V.optEmail,
              onChanged: (v) => person.email = v,
            ),
          ]),
        FieldRow(children: [
          AppTextField(
            label: 'crime.person.aadhaar'.tr(),
            initialValue: person.aadhaar,
            keyboardType: TextInputType.number,
            validator: V.optAadhaar,
            helperText: 'crime.person.encryptedHint'.tr(),
            onChanged: (v) => person.aadhaar = v,
          ),
          AppTextField(
            label: 'crime.person.pan'.tr(),
            initialValue: person.pan,
            helperText: 'crime.person.encryptedHint'.tr(),
            onChanged: (v) => person.pan = v,
          ),
        ]),
        AppTextField(
          label: 'crime.person.passport'.tr(),
          initialValue: person.passport,
          onChanged: (v) => person.passport = v,
        ),
      ],
    );
  }
}

/// Name field + brain hints: 600ms after the officer stops typing, the brain
/// checks whether the same (or nearly-same) name/alias appears as an accused
/// in other FIRs — and whether that person is WANTED anywhere. Purely hints —
/// nothing is changed or blocked.
class _NameWithRepeatHint extends StatefulWidget {
  const _NameWithRepeatHint({
    required this.person,
    required this.nameRequired,
    required this.lookup,
  });

  final PersonDraft person;
  final bool nameRequired;
  final Future<BrainPersonIntel> Function(String name) lookup;

  @override
  State<_NameWithRepeatHint> createState() => _NameWithRepeatHintState();
}

class _NameWithRepeatHintState extends State<_NameWithRepeatHint> {
  Timer? _debounce;
  BrainPersonIntel _intel = const BrainPersonIntel(0, []);
  String _checked = '';

  @override
  void initState() {
    super.initState();
    final existing = widget.person.name;
    if (existing.trim().length >= 3) _check(existing);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String v) {
    widget.person.name = v;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () => _check(v));
  }

  Future<void> _check(String name) async {
    final t = name.trim();
    if (t.length < 3) {
      if (mounted && _intel.otherFirs != 0) {
        setState(() => _intel = const BrainPersonIntel(0, []));
      }
      return;
    }
    final intel = await widget.lookup(t);
    if (!mounted) return;
    setState(() {
      _intel = intel;
      _checked = t;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'crime.person.name'.tr(),
          initialValue: widget.person.name,
          onChanged: _onChanged,
          validator: widget.nameRequired ? V.required : null,
        ),
        // WANTED radar — the loudest alert the brain has.
        if (_intel.wantedIn.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(children: [
                Icon(Icons.gpp_maybe,
                    size: 18, color: theme.colorScheme.onErrorContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'brain.wantedAlert'.tr(namedArgs: {
                      'name': _checked,
                      'firs': _intel.wantedIn.join(', '),
                    }),
                    style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ]),
            ),
          ),
        if (_intel.otherFirs > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(children: [
              Icon(Icons.history,
                  size: 16, color: theme.colorScheme.tertiary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'brain.repeatOffender'.tr(namedArgs: {
                    'name': _checked,
                    'n': '${_intel.otherFirs}',
                  }),
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ),
      ],
    );
  }
}

/// Mobile field + brain hint: shows when the typed number already appears in
/// other FIRs (accused or complainant) — phones catch aliases names can't.
class _MobileWithLinkHint extends StatefulWidget {
  const _MobileWithLinkHint({required this.person, required this.lookup});

  final PersonDraft person;
  final Future<int> Function(String mobile) lookup;

  @override
  State<_MobileWithLinkHint> createState() => _MobileWithLinkHintState();
}

class _MobileWithLinkHintState extends State<_MobileWithLinkHint> {
  Timer? _debounce;
  int _count = 0;

  @override
  void initState() {
    super.initState();
    final existing = widget.person.mobile ?? '';
    if (existing.trim().isNotEmpty) _check(existing);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onChanged(String v) {
    widget.person.mobile = v;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () => _check(v));
  }

  Future<void> _check(String mobile) async {
    final n = await widget.lookup(mobile);
    if (!mounted) return;
    setState(() => _count = n);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          label: 'crime.person.mobile'.tr(),
          initialValue: widget.person.mobile,
          keyboardType: TextInputType.phone,
          validator: V.optMobile,
          onChanged: _onChanged,
        ),
        if (_count > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(children: [
              Icon(Icons.phonelink_ring,
                  size: 16, color: theme.colorScheme.tertiary),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'brain.mobileLinked'.tr(namedArgs: {'n': '$_count'}),
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ]),
          ),
      ],
    );
  }
}

/// Lets a complainant have several phone numbers. The numbers are stored
/// comma-separated in [PersonDraft.mobile] (so reports/exports need no change);
/// this widget splits them out for editing and joins them back on every edit.
class MultiMobileField extends StatefulWidget {
  const MultiMobileField({super.key, required this.person});
  final PersonDraft person;

  @override
  State<MultiMobileField> createState() => _MultiMobileFieldState();
}

class _MultiMobileFieldState extends State<MultiMobileField> {
  late List<String> _numbers;

  @override
  void initState() {
    super.initState();
    final existing = (widget.person.mobile ?? '')
        .split(RegExp(r'[,\n]'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
    _numbers = existing.isEmpty ? [''] : existing;
  }

  void _sync() {
    widget.person.mobile =
        _numbers.map((e) => e.trim()).where((e) => e.isNotEmpty).join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < _numbers.length; i++)
          Row(children: [
            Expanded(
              child: AppTextField(
                // ValueKey so each row keeps its own controller when one is removed.
                key: ValueKey('mobile_${i}_${_numbers.length}'),
                label: 'crime.person.mobileN'
                    .tr(namedArgs: {'n': '${i + 1}'}),
                initialValue: _numbers[i],
                keyboardType: TextInputType.phone,
                nativeEditor: false,
                validator: V.optMobile,
                onChanged: (v) {
                  _numbers[i] = v;
                  _sync();
                },
              ),
            ),
            if (_numbers.length > 1)
              IconButton(
                tooltip: 'common.remove'.tr(),
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  setState(() => _numbers.removeAt(i));
                  _sync();
                },
              ),
          ]),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => setState(() => _numbers.add('')),
            icon: const Icon(Icons.add, size: 18),
            label: Text('crime.person.addMobile'.tr()),
          ),
        ),
      ],
    );
  }
}
