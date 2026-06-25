import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'data/bns_data.dart';
import 'crime_form_controller.dart';
import 'models/crime_draft.dart';
import 'widgets/form_fields.dart';
import 'widgets/person_fields.dart';
import 'widgets/sections_field.dart';
import 'widgets/validators.dart';

/// Common scrollable padding wrapper for a tab body.
class _TabBody extends StatelessWidget {
  const _TabBody({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...children,
        const SizedBox(height: 80), // breathing room above the save bar
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 1 — Crime info
// ---------------------------------------------------------------------------
class CrimeInfoTab extends StatelessWidget {
  const CrimeInfoTab({super.key, required this.model});
  final CrimeFormModel model;

  @override
  Widget build(BuildContext context) {
    final d = model.draft;
    return _TabBody(children: [
      FieldRow(children: [
        AppTextField(
          label: 'crime.info.firNo'.tr(),
          initialValue: d.firNo,
          validator: V.required,
          onChanged: (v) => d.firNo = v,
        ),
        AppTextField(
          label: 'crime.info.year'.tr(),
          initialValue: d.year?.toString(),
          keyboardType: TextInputType.number,
          validator: V.required,
          onChanged: (v) => d.year = int.tryParse(v),
        ),
      ]),
      SectionsField(
        initial: d.section,
        options: kBnsSections,
        acts: kActs,
        onChanged: (v) => d.section = v,
      ),
      FieldRow(children: [
        AppTextField(
          label: 'crime.info.subSection'.tr(),
          initialValue: d.subSection,
          onChanged: (v) => d.subSection = v,
        ),
      ]),
      FieldRow(children: [
        AppAutocompleteField(
          label: 'crime.info.crimeType'.tr(),
          initialValue: d.crimeType,
          options: kCrimeTypes,
          onChanged: (v) => d.crimeType = v,
        ),
        AppDropdownField<String>(
          label: 'crime.info.status'.tr(),
          value: d.status,
          items: [
            DropdownMenuItem(
                value: 'open', child: Text('crime.status.open'.tr())),
            DropdownMenuItem(
                value: 'pending', child: Text('crime.status.pending'.tr())),
            DropdownMenuItem(
                value: 'solved', child: Text('crime.status.solved'.tr())),
            DropdownMenuItem(
                value: 'chargesheeted',
                child: Text('crime.status.chargesheeted'.tr())),
          ],
          onChanged: (v) {
            d.status = v ?? 'open';
            model.refresh();
          },
        ),
      ]),
      FieldRow(children: [
        AppTextField(
          label: 'crime.info.district'.tr(),
          initialValue: d.district,
          onChanged: (v) => d.district = v,
        ),
        AppAutocompleteField(
          label: 'crime.info.policeStation'.tr(),
          initialValue: d.policeStation,
          options: kPoliceStations,
          onChanged: (v) => d.policeStation = v,
        ),
      ]),
      const Divider(height: 32),
      FieldRow(children: [
        AppDateField(
          label: 'crime.info.dateOccurred'.tr(),
          value: d.dateOccurred,
          onChanged: (v) => model.edit((d) => d.dateOccurred = v),
        ),
        AppTextField(
          label: 'crime.info.timeOccurred'.tr(),
          initialValue: d.timeOccurred,
          onChanged: (v) => d.timeOccurred = v,
        ),
      ]),
      AppTextField(
        label: 'crime.info.placeOccurred'.tr(),
        initialValue: d.placeOccurred,
        maxLines: 2,
        onChanged: (v) => d.placeOccurred = v,
      ),
      FieldRow(children: [
        AppDateField(
          label: 'crime.info.dateRegistered'.tr(),
          value: d.dateRegistered,
          onChanged: (v) => model.edit((d) => d.dateRegistered = v),
        ),
        AppTextField(
          label: 'crime.info.timeRegistered'.tr(),
          initialValue: d.timeRegistered,
          onChanged: (v) => d.timeRegistered = v,
        ),
      ]),
      AppTextField(
        label: 'crime.info.detailedDescription'.tr(),
        initialValue: d.detailedDescription,
        maxLines: 5,
        onChanged: (v) => d.detailedDescription = v,
      ),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Tab 2 — Complainant
// ---------------------------------------------------------------------------
class ComplainantTab extends StatelessWidget {
  const ComplainantTab({super.key, required this.model});
  final CrimeFormModel model;

  @override
  Widget build(BuildContext context) {
    return _TabBody(children: [
      PersonFields(
        person: model.draft.complainant,
        notify: model.refresh,
        nameRequired: true,
      ),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Tab 3 — Accused (multiple)
// ---------------------------------------------------------------------------
class AccusedTab extends StatelessWidget {
  const AccusedTab({super.key, required this.model});
  final CrimeFormModel model;

  @override
  Widget build(BuildContext context) {
    final accused = model.draft.accused;
    return _TabBody(children: [
      if (accused.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(child: Text('crime.accused.empty'.tr())),
        ),
      for (var i = 0; i < accused.length; i++)
        RowCard(
          key: ObjectKey(accused[i]),
          title: 'crime.accused.title'.tr(namedArgs: {'n': '${i + 1}'}),
          onRemove: () => model.removeAccused(i),
          child: Column(children: [
            PersonFields(person: accused[i], notify: model.refresh),
            FieldRow(children: [
              AppDropdownField<String>(
                label: 'crime.accused.arrestStatus'.tr(),
                value: accused[i].arrestStatus,
                items: [
                  DropdownMenuItem(
                      value: 'arrested',
                      child: Text('crime.arrest.arrested'.tr())),
                  DropdownMenuItem(
                      value: 'wanted',
                      child: Text('crime.arrest.wanted'.tr())),
                  DropdownMenuItem(
                      value: 'absconding',
                      child: Text('crime.arrest.absconding'.tr())),
                  DropdownMenuItem(
                      value: 'onBail',
                      child: Text('crime.arrest.onBail'.tr())),
                ],
                onChanged: (v) {
                  accused[i].arrestStatus = v;
                  model.refresh();
                },
              ),
              AppDateField(
                label: 'crime.accused.arrestDate'.tr(),
                value: accused[i].arrestDate,
                onChanged: (v) =>
                    model.edit((_) => accused[i].arrestDate = v),
              ),
            ]),
            FieldRow(children: [
              AppTextField(
                label: 'crime.accused.arrestTime'.tr(),
                initialValue: accused[i].arrestTime,
                onChanged: (v) => accused[i].arrestTime = v,
              ),
              AppTextField(
                label: 'crime.accused.photoPath'.tr(),
                initialValue: accused[i].photoPath,
                onChanged: (v) => accused[i].photoPath = v,
              ),
            ]),
          ]),
        ),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.tonalIcon(
          onPressed: model.addAccused,
          icon: const Icon(Icons.person_add_alt),
          label: Text('crime.accused.addButton'.tr()),
        ),
      ),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Tab 4 — Property (stolen + recovered)
// ---------------------------------------------------------------------------
class PropertyTab extends StatelessWidget {
  const PropertyTab({super.key, required this.model});
  final CrimeFormModel model;

  @override
  Widget build(BuildContext context) {
    final stolen = model.draft.stolen;
    final recovered = model.draft.recovered;
    return _TabBody(children: [
      Text('crime.property.stolenTitle'.tr(),
          style: Theme.of(context).textTheme.titleLarge),
      if (stolen.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text('crime.property.emptyStolen'.tr()),
        ),
      for (var i = 0; i < stolen.length; i++)
        RowCard(
          key: ObjectKey(stolen[i]),
          title: 'crime.property.stolenItem'.tr(namedArgs: {'n': '${i + 1}'}),
          onRemove: () => model.removeStolen(i),
          child: Column(children: [
            AppTextField(
              label: 'crime.property.type'.tr(),
              initialValue: stolen[i].type,
              onChanged: (v) => stolen[i].type = v,
            ),
            AppTextField(
              label: 'crime.property.description'.tr(),
              initialValue: stolen[i].description,
              maxLines: 2,
              onChanged: (v) => stolen[i].description = v,
            ),
            AppTextField(
              label: 'crime.property.value'.tr(),
              initialValue: stolen[i].value?.toString(),
              keyboardType: TextInputType.number,
              validator: V.optNumber,
              onChanged: (v) => stolen[i].value = double.tryParse(v),
            ),
          ]),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.tonalIcon(
          onPressed: model.addStolen,
          icon: const Icon(Icons.add),
          label: Text('crime.property.addStolen'.tr()),
        ),
      ),
      const Divider(height: 40),
      Text('crime.property.recoveredTitle'.tr(),
          style: Theme.of(context).textTheme.titleLarge),
      if (recovered.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text('crime.property.emptyRecovered'.tr()),
        ),
      for (var i = 0; i < recovered.length; i++)
        RowCard(
          key: ObjectKey(recovered[i]),
          title:
              'crime.property.recoveredItem'.tr(namedArgs: {'n': '${i + 1}'}),
          onRemove: () => model.removeRecovered(i),
          child: Column(children: [
            AppTextField(
              label: 'crime.property.description'.tr(),
              initialValue: recovered[i].description,
              maxLines: 2,
              onChanged: (v) => recovered[i].description = v,
            ),
            FieldRow(children: [
              AppTextField(
                label: 'crime.property.value'.tr(),
                initialValue: recovered[i].value?.toString(),
                keyboardType: TextInputType.number,
                validator: V.optNumber,
                onChanged: (v) => recovered[i].value = double.tryParse(v),
              ),
              AppDateField(
                label: 'crime.property.recoveryDate'.tr(),
                value: recovered[i].recoveryDate,
                onChanged: (v) =>
                    model.edit((_) => recovered[i].recoveryDate = v),
              ),
            ]),
          ]),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.tonalIcon(
          onPressed: model.addRecovered,
          icon: const Icon(Icons.add),
          label: Text('crime.property.addRecovered'.tr()),
        ),
      ),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Tab 5 — Investigation
// ---------------------------------------------------------------------------
class InvestigationTab extends StatelessWidget {
  const InvestigationTab({super.key, required this.model});
  final CrimeFormModel model;

  @override
  Widget build(BuildContext context) {
    final inv = model.draft.investigation;
    return _TabBody(children: [
      AppTextField(
        label: 'crime.investigation.officerName'.tr(),
        initialValue: inv.officerName,
        onChanged: (v) => inv.officerName = v,
      ),
      FieldRow(children: [
        AppTextField(
          label: 'crime.investigation.officerId'.tr(),
          initialValue: inv.officerId,
          onChanged: (v) => inv.officerId = v,
        ),
        AppTextField(
          label: 'crime.investigation.officerMobile'.tr(),
          initialValue: inv.officerMobile,
          keyboardType: TextInputType.phone,
          validator: V.optMobile,
          onChanged: (v) => inv.officerMobile = v,
        ),
      ]),
      AppTextField(
        label: 'crime.investigation.filedBy'.tr(),
        initialValue: inv.filedBy,
        onChanged: (v) => inv.filedBy = v,
      ),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Tab — Preventive action (प्रतिबंधक)
// ---------------------------------------------------------------------------
class PreventiveTab extends StatelessWidget {
  const PreventiveTab({super.key, required this.model});
  final CrimeFormModel model;

  @override
  Widget build(BuildContext context) {
    final inv = model.draft.investigation;
    return _TabBody(children: [
      AppTextField(
        label: 'crime.investigation.preventiveAction'.tr(),
        initialValue: inv.preventiveAction,
        maxLines: 2,
        onChanged: (v) => inv.preventiveAction = v,
      ),
      FieldRow(children: [
        AppTextField(
          label: 'crime.investigation.preventiveNo'.tr(),
          initialValue: inv.preventiveNo,
          onChanged: (v) => inv.preventiveNo = v,
        ),
        AppDateField(
          label: 'crime.investigation.preventiveDate'.tr(),
          value: inv.preventiveDate,
          onChanged: (v) => model.edit((_) => inv.preventiveDate = v),
        ),
      ]),
      AppTextField(
        label: 'crime.investigation.wantedAccused'.tr(),
        initialValue: inv.wantedAccused,
        maxLines: 2,
        onChanged: (v) => inv.wantedAccused = v,
      ),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Tab 6 — Verdict
// ---------------------------------------------------------------------------
class VerdictTab extends StatelessWidget {
  const VerdictTab({super.key, required this.model});
  final CrimeFormModel model;

  @override
  Widget build(BuildContext context) {
    final v = model.draft.verdict;
    return _TabBody(children: [
      FieldRow(children: [
        AppTextField(
          label: 'crime.verdict.chargesheetNo'.tr(),
          initialValue: v.chargesheetNo,
          onChanged: (val) => v.chargesheetNo = val,
        ),
        AppDateField(
          label: 'crime.verdict.chargesheetDate'.tr(),
          value: v.chargesheetDate,
          onChanged: (val) => model.edit((_) => v.chargesheetDate = val),
        ),
      ]),
      AppTextField(
        label: 'crime.verdict.rccNo'.tr(),
        initialValue: v.rccNo,
        onChanged: (val) => v.rccNo = val,
      ),
      AppTextField(
        label: 'crime.verdict.finalOrder'.tr(),
        initialValue: v.finalOrder,
        maxLines: 3,
        onChanged: (val) => v.finalOrder = val,
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text('crime.verdict.foundGuilty'.tr()),
        value: v.foundGuilty ?? false,
        onChanged: (val) => model.edit((_) => v.foundGuilty = val),
      ),
      AppTextField(
        label: 'crime.verdict.punishment'.tr(),
        initialValue: v.punishment,
        maxLines: 2,
        onChanged: (val) => v.punishment = val,
      ),
    ]);
  }
}

// ---------------------------------------------------------------------------
// Tab 7 — Attachments
// ---------------------------------------------------------------------------
class AttachmentsTab extends StatelessWidget {
  const AttachmentsTab({super.key, required this.model});
  final CrimeFormModel model;

  @override
  Widget build(BuildContext context) {
    final items = model.draft.attachments;
    return _TabBody(children: [
      Card(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            const Icon(Icons.info_outline, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text('crime.attachments.note'.tr())),
          ]),
        ),
      ),
      if (items.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Center(child: Text('crime.attachments.empty'.tr())),
        ),
      for (var i = 0; i < items.length; i++)
        RowCard(
          key: ObjectKey(items[i]),
          title: 'crime.attachments.item'.tr(namedArgs: {'n': '${i + 1}'}),
          onRemove: () => model.removeAttachment(i),
          child: Column(children: [
            AppTextField(
              label: 'crime.attachments.filePath'.tr(),
              initialValue: items[i].filePath,
              onChanged: (v) => items[i].filePath = v,
            ),
            FieldRow(children: [
              AppTextField(
                label: 'crime.attachments.fileType'.tr(),
                initialValue: items[i].fileType,
                onChanged: (v) => items[i].fileType = v,
              ),
              AppTextField(
                label: 'crime.attachments.description'.tr(),
                initialValue: items[i].description,
                onChanged: (v) => items[i].description = v,
              ),
            ]),
          ]),
        ),
      const SizedBox(height: 8),
      Align(
        alignment: Alignment.centerLeft,
        child: FilledButton.tonalIcon(
          onPressed: () async {
            final picked = await FilePicker.pickFiles(withData: false);
            final file = picked?.files.single;
            final path = file?.path;
            if (path == null) return;
            model.edit((d) => d.attachments.add(AttachmentDraft(
                  filePath: path,
                  fileType: file?.extension,
                  description: file?.name,
                )));
          },
          icon: const Icon(Icons.attach_file),
          label: Text('crime.attachments.addButton'.tr()),
        ),
      ),
    ]);
  }
}
