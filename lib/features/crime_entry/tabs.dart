import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../access/access_service.dart';
import 'data/bns_data.dart';
import 'crime_form_controller.dart';
import 'models/crime_draft.dart';
import 'scan_crop_screen.dart';
import 'scanner_service.dart';
import 'widgets/crime_type_field.dart';
import 'widgets/form_fields.dart';
import 'widgets/person_fields.dart';
import 'widgets/sections_field.dart';
import 'widgets/stage_field.dart';
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

/// Maps any stored status (including legacy open/pending/solved/chargesheeted)
/// onto the current two-state model so the dropdown always has a valid value.
String _statusValue(String s) {
  switch (s) {
    case 'detected':
    case 'solved':
    case 'chargesheeted':
      return 'detected';
    default:
      return 'undetected';
  }
}


/// Read-only card showing the case timeline: offence → registration gap, and —
/// when a court is chosen — the chargesheet deadline with live days-remaining.
class CaseTimelineCard extends StatelessWidget {
  const CaseTimelineCard({super.key, required this.draft});
  final CrimeDraft draft;

  static final _fmt = DateFormat('dd-MM-yyyy');

  /// Chargesheet window in days for the selected court.
  int? get _windowDays => switch (draft.courtType) {
        'sessions' => 90,
        'jmfc' => 60,
        _ => null,
      };

  @override
  Widget build(BuildContext context) {
    final occurred = draft.dateOccurred;
    final registered = draft.dateRegistered;
    final today = DateTime.now();
    final rows = <Widget>[];

    // Age of case — between occurrence and registration.
    if (occurred != null && registered != null) {
      final gap = registered.difference(occurred).inDays;
      rows.add(_line(
        context,
        Icons.event_note_outlined,
        'crime.timeline.ageOfCase'.tr(namedArgs: {'n': '${gap.abs()}'}),
      ));
    }
    // Days since registration (how old the case is now).
    if (registered != null) {
      final since = today.difference(registered).inDays;
      if (since >= 0) {
        rows.add(_line(
          context,
          Icons.schedule_outlined,
          'crime.timeline.sinceRegistered'.tr(namedArgs: {'n': '$since'}),
        ));
      }
    }
    // Chargesheet deadline + days remaining.
    final window = _windowDays;
    if (window != null && registered != null) {
      final deadline = registered.add(Duration(days: window));
      final remaining = deadline.difference(DateTime(today.year, today.month, today.day)).inDays;
      final Color color;
      final String msg;
      if (remaining < 0) {
        color = Colors.red;
        msg = 'crime.timeline.overdue'.tr(namedArgs: {'n': '${-remaining}'});
      } else {
        color = remaining <= 15 ? Colors.orange : Colors.green;
        msg = 'crime.timeline.remaining'.tr(namedArgs: {'n': '$remaining'});
      }
      rows.add(_line(
        context,
        Icons.gavel_outlined,
        'crime.timeline.deadline'.tr(namedArgs: {
          'days': '$window',
          'date': _fmt.format(deadline),
        }),
      ));
      rows.add(_line(context, Icons.timelapse_outlined, msg, color: color));
    }

    if (rows.isEmpty) return const SizedBox.shrink();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: rows,
        ),
      ),
    );
  }

  Widget _line(BuildContext context, IconData icon, String text,
      {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text,
              style: TextStyle(
                  color: color, fontWeight: color == null ? null : FontWeight.w600)),
        ),
      ]),
    );
  }
}

// ---------------------------------------------------------------------------
// Tab 1 — Crime info
// ---------------------------------------------------------------------------
class CrimeInfoTab extends ConsumerWidget {
  const CrimeInfoTab({super.key, required this.model});
  final CrimeFormModel model;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = model.draft;
    // Admin-assigned station (access scope): entries are always filed under it,
    // so the field is pinned and read-only for station-scoped users.
    final assignedStation = ref.watch(accessControllerProvider).scope.station;
    if (assignedStation != null &&
        assignedStation.isNotEmpty &&
        d.policeStation != assignedStation) {
      d.policeStation = assignedStation;
    }
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
        CrimeTypeField(
          value: d.crimeType,
          onChanged: (v) => model.edit((_) => d.crimeType = v),
        ),
        AppDropdownField<String>(
          label: 'crime.info.status'.tr(),
          value: _statusValue(d.status),
          items: [
            DropdownMenuItem(
                value: 'detected', child: Text('crime.status.detected'.tr())),
            DropdownMenuItem(
                value: 'undetected',
                child: Text('crime.status.undetected'.tr())),
          ],
          onChanged: (v) {
            d.status = v ?? 'undetected';
            model.refresh();
          },
        ),
      ]),
      // Case stage — where the FIR currently stands. Multiple may apply at once
      // (e.g. chargesheet filed + further investigation). Independent of status.
      StageMultiField(
        value: d.caseStage,
        onChanged: (v) => model.edit((_) => d.caseStage = v),
      ),
      FieldRow(children: [
        AppTextField(
          label: 'crime.info.district'.tr(),
          initialValue: d.district,
          onChanged: (v) => d.district = v,
        ),
        if (assignedStation != null && assignedStation.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: TextFormField(
              key: ValueKey('locked-station-$assignedStation'),
              initialValue: assignedStation,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'crime.info.policeStation'.tr(),
                helperText: 'crime.info.stationLocked'.tr(),
                border: const OutlineInputBorder(),
                isDense: true,
                suffixIcon: const Icon(Icons.lock_outline, size: 18),
              ),
            ),
          )
        else
          AppAutocompleteField(
            label: 'crime.info.policeStation'.tr(),
            initialValue: d.policeStation,
            options: kPoliceStations,
            onChanged: (v) => d.policeStation = v,
          ),
      ]),
      const Divider(height: 32),
      // Date of offence as a window: "from" → "to" (offence spanning days).
      FieldRow(children: [
        AppDateField(
          label: 'crime.info.dateOccurredFrom'.tr(),
          value: d.dateOccurred,
          onChanged: (v) => model.edit((d) => d.dateOccurred = v),
        ),
        AppDateField(
          label: 'crime.info.dateOccurredTo'.tr(),
          value: d.dateOccurredTo,
          onChanged: (v) => model.edit((d) => d.dateOccurredTo = v),
        ),
      ]),
      // Time of offence as a window, picked from a clock (e.g. 1 PM to 2 PM).
      FieldRow(children: [
        AppTimeField(
          label: 'crime.info.timeOccurredFrom'.tr(),
          value: d.timeOccurred,
          onChanged: (v) => model.edit((_) => d.timeOccurred = v),
        ),
        AppTimeField(
          label: 'crime.info.timeOccurredTo'.tr(),
          value: d.timeOccurredTo,
          onChanged: (v) => model.edit((_) => d.timeOccurredTo = v),
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
      // Court → chargesheet deadline (Sessions 90 days / JMFC 60 days).
      FieldRow(children: [
        AppDropdownField<String?>(
          label: 'crime.info.courtType'.tr(),
          value: d.courtType,
          items: [
            DropdownMenuItem(value: null, child: Text('crime.court.none'.tr())),
            DropdownMenuItem(
                value: 'sessions', child: Text('crime.court.sessions'.tr())),
            DropdownMenuItem(
                value: 'jmfc', child: Text('crime.court.jmfc'.tr())),
          ],
          onChanged: (v) {
            d.courtType = v;
            model.refresh();
          },
        ),
        const SizedBox.shrink(),
      ]),
      CaseTimelineCard(draft: d),
      AppTextField(
        label: 'crime.info.detailedDescription'.tr(),
        initialValue: d.detailedDescription,
        maxLines: 5,
        onChanged: (v) => d.detailedDescription = v,
      ),
      const Divider(height: 40),
      Text('crime.firDetails.title'.tr(),
          style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      FieldRow(children: [
        AppDateField(
          label: 'crime.firDetails.firDate'.tr(),
          value: d.firDate,
          onChanged: (v) => model.edit((_) => d.firDate = v),
        ),
        AppTimeField(
          label: 'crime.firDetails.firTime'.tr(),
          value: d.firTime,
          onChanged: (v) => model.edit((_) => d.firTime = v),
        ),
      ]),
      FieldRow(children: [
        AppDateField(
          label: 'crime.firDetails.infoReceivedDate'.tr(),
          value: d.infoReceivedDate,
          onChanged: (v) => model.edit((_) => d.infoReceivedDate = v),
        ),
        AppTimeField(
          label: 'crime.firDetails.infoReceivedTime'.tr(),
          value: d.infoReceivedTime,
          onChanged: (v) => model.edit((_) => d.infoReceivedTime = v),
        ),
      ]),
      FieldRow(children: [
        AppDateField(
          label: 'crime.firDetails.gdDate'.tr(),
          value: d.gdDate,
          onChanged: (v) => model.edit((_) => d.gdDate = v),
        ),
        AppTimeField(
          label: 'crime.firDetails.gdTime'.tr(),
          value: d.gdTime,
          onChanged: (v) => model.edit((_) => d.gdTime = v),
        ),
      ]),
      FieldRow(children: [
        AppTextField(
          label: 'crime.firDetails.gdEntryNo'.tr(),
          initialValue: d.gdEntryNo,
          onChanged: (v) => d.gdEntryNo = v,
        ),
        AppTextField(
          label: 'crime.firDetails.occurrenceDay'.tr(),
          initialValue: d.occurrenceDay,
          onChanged: (v) => d.occurrenceDay = v,
        ),
      ]),
      FieldRow(children: [
        AppTextField(
          label: 'crime.firDetails.typeOfInformation'.tr(),
          initialValue: d.typeOfInformation,
          onChanged: (v) => d.typeOfInformation = v,
        ),
        AppTextField(
          label: 'crime.firDetails.beatNo'.tr(),
          initialValue: d.beatNo,
          onChanged: (v) => d.beatNo = v,
        ),
      ]),
      AppTextField(
        label: 'crime.firDetails.directionDistance'.tr(),
        initialValue: d.directionDistance,
        onChanged: (v) => d.directionDistance = v,
      ),
      FieldRow(children: [
        AppTextField(
          label: 'crime.firDetails.outsidePsName'.tr(),
          initialValue: d.outsidePsName,
          onChanged: (v) => d.outsidePsName = v,
        ),
        AppTextField(
          label: 'crime.firDetails.outsidePsDistrict'.tr(),
          initialValue: d.outsidePsDistrict,
          onChanged: (v) => d.outsidePsDistrict = v,
        ),
      ]),
      AppTextField(
        label: 'crime.firDetails.delayReason'.tr(),
        initialValue: d.delayReason,
        maxLines: 2,
        onChanged: (v) => d.delayReason = v,
      ),
      AppTextField(
        label: 'crime.firDetails.inquestUdNo'.tr(),
        initialValue: d.inquestUdNo,
        onChanged: (v) => d.inquestUdNo = v,
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
    final c = model.draft.complainant;
    return _TabBody(children: [
      PersonFields(
        person: c,
        notify: model.refresh,
        nameRequired: true,
        multiMobile: true,
      ),
      FieldRow(children: [
        AppTextField(
          label: 'crime.person.fatherHusbandName'.tr(),
          initialValue: c.fatherHusbandName,
          onChanged: (v) => c.fatherHusbandName = v,
        ),
        AppTextField(
          label: 'crime.person.birthYear'.tr(),
          initialValue: c.birthYear?.toString(),
          keyboardType: TextInputType.number,
          nativeEditor: false,
          onChanged: (v) => c.birthYear = int.tryParse(v),
        ),
      ]),
      FieldRow(children: [
        AppTextField(
          label: 'crime.person.nationality'.tr(),
          initialValue: c.nationality,
          onChanged: (v) => c.nationality = v,
        ),
        AppTextField(
          label: 'crime.person.occupation'.tr(),
          initialValue: c.occupation,
          onChanged: (v) => c.occupation = v,
        ),
      ]),
      AppTextField(
        label: 'crime.person.permanentAddress'.tr(),
        initialValue: c.permanentAddress,
        maxLines: 2,
        onChanged: (v) => c.permanentAddress = v,
      ),
      FieldRow(children: [
        AppTextField(
          label: 'crime.person.idType'.tr(),
          initialValue: c.idType,
          onChanged: (v) => c.idType = v,
        ),
        AppTextField(
          label: 'crime.person.idNumber'.tr(),
          initialValue: c.idNumber,
          onChanged: (v) => c.idNumber = v,
        ),
      ]),
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
              AppTextField(
                label: 'crime.accused.alias'.tr(),
                initialValue: accused[i].alias,
                onChanged: (v) => accused[i].alias = v,
              ),
              AppTextField(
                label: 'crime.accused.relativeName'.tr(),
                initialValue: accused[i].relativeName,
                onChanged: (v) => accused[i].relativeName = v,
              ),
            ]),
            _PhysicalFields(accused: accused[i]),
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

/// Compact physical-description editor for an accused (IIF-1 item 7 attachment).
/// Writes into the accused's [physical] map; keys: build, height, complexion,
/// marks, language, other.
class _PhysicalFields extends StatelessWidget {
  const _PhysicalFields({required this.accused});
  final AccusedDraft accused;

  void _set(String key, String v) {
    final m = accused.physical ??= <String, String>{};
    m[key] = v;
  }

  @override
  Widget build(BuildContext context) {
    final p = accused.physical;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        Text('crime.accused.physicalTitle'.tr(),
            style: Theme.of(context).textTheme.labelLarge),
        FieldRow(children: [
          AppTextField(
            label: 'crime.accused.build'.tr(),
            initialValue: p?['build'],
            onChanged: (v) => _set('build', v),
          ),
          AppTextField(
            label: 'crime.accused.height'.tr(),
            initialValue: p?['height'],
            onChanged: (v) => _set('height', v),
          ),
        ]),
        FieldRow(children: [
          AppTextField(
            label: 'crime.accused.complexion'.tr(),
            initialValue: p?['complexion'],
            onChanged: (v) => _set('complexion', v),
          ),
          AppTextField(
            label: 'crime.accused.language'.tr(),
            initialValue: p?['language'],
            onChanged: (v) => _set('language', v),
          ),
        ]),
        AppTextField(
          label: 'crime.accused.marks'.tr(),
          initialValue: p?['marks'],
          onChanged: (v) => _set('marks', v),
        ),
        AppTextField(
          label: 'crime.accused.otherFeatures'.tr(),
          initialValue: p?['other'],
          maxLines: 2,
          onChanged: (v) => _set('other', v),
        ),
      ],
    );
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
            FieldRow(children: [
              AppTextField(
                label: 'crime.property.category'.tr(),
                initialValue: stolen[i].category,
                onChanged: (v) => stolen[i].category = v,
              ),
              AppTextField(
                label: 'crime.property.type'.tr(),
                initialValue: stolen[i].type,
                onChanged: (v) => stolen[i].type = v,
              ),
            ]),
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
          label: 'crime.investigation.officerDesignation'.tr(),
          initialValue: inv.officerDesignation,
          onChanged: (v) => inv.officerDesignation = v,
        ),
      ]),
      AppTextField(
        label: 'crime.investigation.officerMobile'.tr(),
        initialValue: inv.officerMobile,
        keyboardType: TextInputType.phone,
        validator: V.optMobile,
        onChanged: (v) => inv.officerMobile = v,
      ),
      AppTextField(
        label: 'crime.investigation.filedBy'.tr(),
        initialValue: inv.filedBy,
        onChanged: (v) => inv.filedBy = v,
      ),
      const Divider(height: 40),
      Text('crime.investigation.registeringTitle'.tr(),
          style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      AppTextField(
        label: 'crime.investigation.registeringOfficerName'.tr(),
        initialValue: inv.registeringOfficerName,
        onChanged: (v) => inv.registeringOfficerName = v,
      ),
      FieldRow(children: [
        AppTextField(
          label: 'crime.investigation.registeringOfficerRank'.tr(),
          initialValue: inv.registeringOfficerRank,
          onChanged: (v) => inv.registeringOfficerRank = v,
        ),
        AppTextField(
          label: 'crime.investigation.registeringOfficerNo'.tr(),
          initialValue: inv.registeringOfficerNo,
          onChanged: (v) => inv.registeringOfficerNo = v,
        ),
      ]),
      AppTextField(
        label: 'crime.investigation.actionTaken'.tr(),
        initialValue: inv.actionTaken,
        maxLines: 2,
        onChanged: (v) => inv.actionTaken = v,
      ),
      FieldRow(children: [
        AppDateField(
          label: 'crime.investigation.courtDispatchDate'.tr(),
          value: inv.courtDispatchDate,
          onChanged: (v) => model.edit((_) => inv.courtDispatchDate = v),
        ),
        AppTimeField(
          label: 'crime.investigation.courtDispatchTime'.tr(),
          value: inv.courtDispatchTime,
          onChanged: (v) => model.edit((_) => inv.courtDispatchTime = v),
        ),
      ]),
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
      Wrap(
        spacing: 12,
        runSpacing: 8,
        children: [
          FilledButton.tonalIcon(
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
          if (ScannerService.isSupported)
            FilledButton.tonalIcon(
              onPressed: () => _scanAttachment(context, model),
              icon: const Icon(Icons.scanner_outlined),
              label: Text('crime.attachments.scanButton'.tr()),
            ),
        ],
      ),
    ]);
  }

  /// Scans a page from the connected scanner, lets the user crop it, then adds
  /// the cropped image as an attachment.
  Future<void> _scanAttachment(
      BuildContext context, CrimeFormModel model) async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    // Brief "scanning…" notice — the WIA/SANE dialog opens next.
    messenger.showSnackBar(SnackBar(
      content: Text('crime.attachments.scanning'.tr()),
      duration: const Duration(seconds: 2),
    ));
    String? scannedPath;
    try {
      scannedPath = await const ScannerService().scanToFile();
    } on ScannerException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      return;
    } catch (_) {
      messenger.showSnackBar(
          SnackBar(content: Text('crime.attachments.scanFailed'.tr())));
      return;
    }
    if (scannedPath == null) return; // cancelled
    final croppedPath = await navigator.push<String>(
      MaterialPageRoute<String>(
        builder: (_) => ScanCropScreen(imagePath: scannedPath!),
      ),
    );
    if (croppedPath == null) return; // backed out of cropper
    model.edit((d) => d.attachments.add(AttachmentDraft(
          filePath: croppedPath,
          fileType: 'png',
          description: 'crime.attachments.scannedDoc'.tr(),
        )));
  }
}
