import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
  });

  final PersonDraft person;
  final VoidCallback notify;
  final bool nameRequired;
  // When true (complainant), allow several phone numbers instead of one.
  final bool multiMobile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTextField(
          label: 'crime.person.name'.tr(),
          initialValue: person.name,
          onChanged: (v) => person.name = v,
          validator: nameRequired ? V.required : null,
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
            AppTextField(
              label: 'crime.person.mobile'.tr(),
              initialValue: person.mobile,
              keyboardType: TextInputType.phone,
              validator: V.optMobile,
              onChanged: (v) => person.mobile = v,
            ),
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
