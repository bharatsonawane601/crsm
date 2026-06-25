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
  });

  final PersonDraft person;
  final VoidCallback notify;
  final bool nameRequired;

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
            initialValue: person.age?.toString(),
            keyboardType: TextInputType.number,
            validator: V.optInt,
            onChanged: (v) => person.age = int.tryParse(v),
          ),
        ]),
        AppTextField(
          label: 'crime.person.address'.tr(),
          initialValue: person.address,
          maxLines: 2,
          onChanged: (v) => person.address = v,
        ),
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
