import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../core/theme/colors.dart';
import '../../shared/widgets/native_edit_button.dart';
import '../../data/db/database.dart';
import '../crime_entry/crime_repository.dart';
import '../crime_entry/data/crime_types_data.dart';
import 'io_case_fields.dart';
import 'io_repository.dart';

/// The single "Case data" page: every field the government forms need, entered
/// once. Auto-imports from the linked FIR, then every generated form reads from
/// here (case data + people + property).
class IoCaseDataScreen extends ConsumerStatefulWidget {
  const IoCaseDataScreen({super.key, required this.caseId});
  final int caseId;

  @override
  ConsumerState<IoCaseDataScreen> createState() => _IoCaseDataScreenState();
}

class _IoCaseDataScreenState extends ConsumerState<IoCaseDataScreen> {
  final _sectionKeys = <String, GlobalKey<_FieldsEditorState>>{};
  Map<String, dynamic> _data = {};
  bool _loading = true;
  bool _hasFir = false;
  int _rev = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(ioRepositoryProvider);
    final data = await repo.caseData(widget.caseId);
    final c = await repo.getCase(widget.caseId);
    if (!mounted) return;
    setState(() {
      _data = data;
      _hasFir = (c.firNo ?? '').isNotEmpty && c.year != null;
      _loading = false;
    });
  }

  Map<String, dynamic> _collect() {
    final out = Map<String, dynamic>.of(_data);
    for (final k in _sectionKeys.values) {
      out.addAll(k.currentState?.collect() ?? const {});
    }
    return out;
  }

  Future<void> _save() async {
    _data = _collect();
    await ref.read(ioRepositoryProvider).saveCaseData(widget.caseId, _data);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('io.saved'.tr()), duration: const Duration(seconds: 1)));
    }
  }

  Future<void> _importFromFir() async {
    final repo = ref.read(ioRepositoryProvider);
    final c = await repo.getCase(widget.caseId);
    if ((c.firNo ?? '').isEmpty || c.year == null) return;
    final crimeRepo = ref.read(crimeRepositoryProvider);
    final id = await crimeRepo.findCrimeIdByFir(c.firNo!, c.year!);
    if (id == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('io.data.noFir'.tr())));
      }
      return;
    }
    final fir = await crimeRepo.loadDraft(id);
    if (fir == null) return;

    // Keep anything already typed, then overlay FIR-derived values.
    final data = _collect();
    void put(String k, String? v) {
      if (v != null && v.trim().isNotEmpty) data[k] = v;
    }

    put('gdNo', fir.gdEntryNo);
    put('adUdNo', fir.inquestUdNo);
    put('placeDetail', fir.placeOccurred);
    put('briefFacts', fir.detailedDescription);
    put('sceneDescription', fir.detailedDescription);
    final type = fir.crimeType;
    if (type != null) {
      final cat = crimeCategoryOf(type);
      put('majorHead', cat != null ? crimeTypeMarathi(cat) : null);
      put('minorHead', crimeTypeMarathi(type));
    }
    put('chargesheetNo', fir.verdict.chargesheetNo);
    put('shoName', fir.investigation.registeringOfficerName);
    put('shoRank', fir.investigation.registeringOfficerRank);

    // Parties: complainant + accused.
    final existing = await repo.partiesOnce(widget.caseId);
    bool has(String role) => existing.any((p) => p.role == role);
    if (fir.complainant.name.trim().isNotEmpty && !has('complainant')) {
      final cp = fir.complainant;
      await repo.addParty(widget.caseId, 'complainant', cp.name, values: {
        'fatherHusband': cp.fatherHusbandName ?? '',
        'sex': cp.gender ?? '',
        'age': cp.ageText ?? (cp.age?.toString() ?? ''),
        'occupation': cp.occupation ?? '',
        'nationality': cp.nationality ?? '',
        'address': cp.address ?? '',
        'permanentAddress': cp.permanentAddress ?? '',
        'mobile': cp.mobile ?? '',
        'idType': cp.idType ?? '',
        'idNumber': cp.idNumber ?? '',
      });
    }
    if (!has('accused')) {
      for (final a in fir.accused) {
        await repo.addParty(widget.caseId, 'accused', a.name, values: {
          'alias1': a.alias ?? '',
          'fatherHusband': a.relativeName ?? '',
          'sex': a.gender ?? '',
          'dob': a.ageText ?? (a.age?.toString() ?? ''),
          'presentAddress': a.address ?? '',
          'mobile': a.mobile ?? '',
          'arrestDate': _d(a.arrestDate),
          'arrestTime': a.arrestTime ?? '',
          ...?a.physical,
        });
      }
    }

    // Exhibits: stolen + recovered.
    final exhibits = await repo.exhibitsOnce(widget.caseId);
    if (exhibits.isEmpty) {
      for (final s in fir.stolen) {
        await repo.addExhibit(
            widget.caseId, s.description ?? s.type ?? 'मालमत्ता',
            category: s.category, value: s.value);
      }
      for (final r in fir.recovered) {
        await repo.addExhibit(widget.caseId, r.description ?? 'मालमत्ता',
            value: r.value);
      }
    }

    await repo.saveCaseData(widget.caseId, data);
    if (!mounted) return;
    setState(() {
      _data = data;
      _rev++; // rebuild the section editors with the imported values
    });
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('io.data.imported'.tr())));
  }

  String _d(DateTime? d) => d == null ? '' : '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('io.data.title'.tr()),
        actions: [
          if (!_loading)
            IconButton(
                icon: const Icon(Icons.save),
                tooltip: 'common.save'.tr(),
                onPressed: _save),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 96),
              children: [
                if (_hasFir)
                  Card(
                    color: AppColors.policeNavy.withValues(alpha: 0.06),
                    child: ListTile(
                      leading: const Icon(PhosphorIconsRegular.downloadSimple),
                      title: Text('io.data.importTitle'.tr()),
                      subtitle: Text('io.data.importSub'.tr()),
                      trailing: FilledButton(
                          onPressed: _importFromFir,
                          child: Text('io.data.import'.tr())),
                    ),
                  ),
                for (final s in kCaseDataSections)
                  _CaseSection(
                    key: ValueKey('sec_${s.id}_$_rev'),
                    section: s,
                    editorKey: _sectionKeys.putIfAbsent(
                        '${s.id}_$_rev', () => GlobalKey<_FieldsEditorState>()),
                    data: _data,
                  ),
                const _PeopleSection(),
                const _PropertySection(),
              ],
            ),
    );
  }
}

/// A collapsible case-level section wrapping a [_FieldsEditor].
class _CaseSection extends StatelessWidget {
  const _CaseSection(
      {super.key,
      required this.section,
      required this.editorKey,
      required this.data});
  final DSection section;
  final GlobalKey<_FieldsEditorState> editorKey;
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        title: Text('${section.mr}  ·  ${section.en}',
            style: const TextStyle(fontWeight: FontWeight.w600)),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        children: [
          _FieldsEditor(key: editorKey, fields: section.fields, initial: data),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// People
// ---------------------------------------------------------------------------
class _PeopleSection extends ConsumerWidget {
  const _PeopleSection();
  static const _roles = [
    'complainant',
    'accused',
    'deceased',
    'witness',
    'panch'
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Find the caseId via the nearest state (passed through InheritedWidget-free
    // approach): read from the route args isn't available, so we look it up from
    // the enclosing screen using a Builder that reads the provider family. We
    // instead accept it via context — simpler: use the provider family with the
    // caseId stored on the State. To keep this widget const, read it from the
    // ancestor State.
    final caseId = context
        .findAncestorStateOfType<_IoCaseDataScreenState>()!
        .widget
        .caseId;
    final async = ref.watch(ioPartiesProvider(caseId));
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text('io.data.people'.tr(),
            style: const TextStyle(fontWeight: FontWeight.w600)),
        childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        children: [
          async.when(
            loading: () => const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator())),
            error: (e, _) => Text('portal.error'.tr()),
            data: (list) => Column(
              children: [
                for (final p in list)
                  ListTile(
                    dense: true,
                    leading: const Icon(PhosphorIconsRegular.user),
                    title: Text(p.name),
                    subtitle: Text('io.role.${p.role}'.tr()),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            ref.read(ioRepositoryProvider).deleteParty(p.id)),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => _PersonEditScreen(party: p))),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.person_add),
                    label: Text('io.data.addPerson'.tr()),
                    onPressed: () => _add(context, ref, caseId),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref, int caseId) async {
    final name = TextEditingController();
    var role = _roles.first;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('io.data.addPerson'.tr()),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            DropdownButtonFormField<String>(
              initialValue: role,
              decoration: InputDecoration(labelText: 'io.roleLabel'.tr()),
              items: [
                for (final r in _roles)
                  DropdownMenuItem(value: r, child: Text('io.role.$r'.tr())),
              ],
              onChanged: (v) => setState(() => role = v ?? role),
            ),
            const SizedBox(height: 8),
            TextField(
                controller: name,
                decoration: InputDecoration(labelText: 'io.name'.tr())),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('common.cancel'.tr())),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text('common.add'.tr())),
          ],
        ),
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty) {
      final id = await ref
          .read(ioRepositoryProvider)
          .addParty(caseId, role, name.text.trim());
      final party = (await ref.read(ioRepositoryProvider).partiesOnce(caseId))
          .firstWhere((p) => p.id == id);
      if (context.mounted) {
        Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => _PersonEditScreen(party: party)));
      }
    }
    name.dispose();
  }
}

class _PersonEditScreen extends ConsumerStatefulWidget {
  const _PersonEditScreen({required this.party});
  final IoParty party;

  @override
  ConsumerState<_PersonEditScreen> createState() => _PersonEditScreenState();
}

class _PersonEditScreenState extends ConsumerState<_PersonEditScreen> {
  final _editorKey = GlobalKey<_FieldsEditorState>();
  late final TextEditingController _name =
      TextEditingController(text: widget.party.name);

  Map<String, dynamic> get _initial {
    if (widget.party.valuesJson == null) return {};
    try {
      return (jsonDecode(widget.party.valuesJson!) as Map).cast<String, dynamic>();
    } catch (_) {
      return {};
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(ioRepositoryProvider).updateParty(widget.party.id,
        name: _name.text.trim(), values: _editorKey.currentState?.collect());
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('io.role.${widget.party.role}'.tr()),
        actions: [
          IconButton(icon: const Icon(Icons.save), onPressed: _save),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          TextField(
            controller: _name,
            decoration: InputDecoration(
                labelText: 'io.name'.tr(), border: const OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          _FieldsEditor(
            key: _editorKey,
            fields: roleFields(widget.party.role),
            initial: _initial,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Property / exhibits
// ---------------------------------------------------------------------------
class _PropertySection extends ConsumerWidget {
  const _PropertySection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final caseId = context
        .findAncestorStateOfType<_IoCaseDataScreenState>()!
        .widget
        .caseId;
    final async = ref.watch(ioExhibitsProvider(caseId));
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text('io.data.property'.tr(),
            style: const TextStyle(fontWeight: FontWeight.w600)),
        childrenPadding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
        children: [
          async.when(
            loading: () => const Padding(
                padding: EdgeInsets.all(12),
                child: Center(child: CircularProgressIndicator())),
            error: (e, _) => Text('portal.error'.tr()),
            data: (list) => Column(
              children: [
                for (final x in list)
                  ListTile(
                    dense: true,
                    leading: const Icon(PhosphorIconsRegular.package),
                    title: Text(x.description),
                    subtitle: Text([
                      if (x.category != null) x.category!,
                      if (x.value != null) '₹${x.value!.toStringAsFixed(0)}',
                    ].join(' · ')),
                    trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            ref.read(ioRepositoryProvider).deleteExhibit(x.id)),
                    onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (_) => _ExhibitEditScreen(exhibit: x))),
                  ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    icon: const Icon(Icons.add),
                    label: Text('io.data.addProperty'.tr()),
                    onPressed: () async {
                      final id = await ref
                          .read(ioRepositoryProvider)
                          .addExhibit(caseId, 'नवीन मुद्देमाल');
                      final x = (await ref
                              .read(ioRepositoryProvider)
                              .exhibitsOnce(caseId))
                          .firstWhere((e) => e.id == id);
                      if (context.mounted) {
                        Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (_) => _ExhibitEditScreen(exhibit: x)));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExhibitEditScreen extends ConsumerStatefulWidget {
  const _ExhibitEditScreen({required this.exhibit});
  final IoExhibit exhibit;

  @override
  ConsumerState<_ExhibitEditScreen> createState() => _ExhibitEditScreenState();
}

class _ExhibitEditScreenState extends ConsumerState<_ExhibitEditScreen> {
  final _editorKey = GlobalKey<_FieldsEditorState>();
  late final _desc = TextEditingController(text: widget.exhibit.description);
  late final _from = TextEditingController(text: widget.exhibit.seizedFrom ?? '');
  late final _value = TextEditingController(
      text: widget.exhibit.value == null
          ? ''
          : widget.exhibit.value!.toStringAsFixed(0));
  late String? _category = widget.exhibit.category;

  Map<String, dynamic> get _initial {
    if (widget.exhibit.valuesJson == null) return {};
    try {
      return (jsonDecode(widget.exhibit.valuesJson!) as Map)
          .cast<String, dynamic>();
    } catch (_) {
      return {};
    }
  }

  @override
  void dispose() {
    _desc.dispose();
    _from.dispose();
    _value.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(ioRepositoryProvider).updateExhibit(widget.exhibit.id,
        description: _desc.text.trim().isEmpty ? 'मुद्देमाल' : _desc.text.trim(),
        category: _category,
        seizedFrom: _from.text.trim().isEmpty ? null : _from.text.trim(),
        value: double.tryParse(_value.text.trim()),
        values: _editorKey.currentState?.collect());
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('io.data.property'.tr()), actions: [
        IconButton(icon: const Icon(Icons.save), onPressed: _save),
      ]),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
        children: [
          TextField(
              controller: _desc,
              maxLines: 2,
              decoration: InputDecoration(
                  labelText: 'io.description'.tr(),
                  border: const OutlineInputBorder())),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            initialValue: kExhibitCategories.contains(_category) ? _category : null,
            isExpanded: true,
            decoration: InputDecoration(
                labelText: 'io.data.category'.tr(),
                border: const OutlineInputBorder()),
            items: [
              for (final c in kExhibitCategories)
                DropdownMenuItem(value: c, child: Text(c, overflow: TextOverflow.ellipsis)),
            ],
            onChanged: (v) => setState(() => _category = v),
          ),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(
                child: TextField(
                    controller: _from,
                    decoration: InputDecoration(
                        labelText: 'io.seizedFrom'.tr(),
                        border: const OutlineInputBorder()))),
            const SizedBox(width: 10),
            SizedBox(
                width: 130,
                child: TextField(
                    controller: _value,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        labelText: 'io.value'.tr(),
                        border: const OutlineInputBorder()))),
          ]),
          const SizedBox(height: 12),
          _FieldsEditor(
              key: _editorKey, fields: kExhibitFields, initial: _initial),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable generic fields editor
// ---------------------------------------------------------------------------
class _FieldsEditor extends StatefulWidget {
  const _FieldsEditor({super.key, required this.fields, required this.initial});
  final List<DField> fields;
  final Map<String, dynamic> initial;

  @override
  State<_FieldsEditor> createState() => _FieldsEditorState();
}

class _FieldsEditorState extends State<_FieldsEditor> {
  final _text = <String, TextEditingController>{};
  final _values = <String, String>{};

  bool _isText(DType t) =>
      t == DType.text || t == DType.multiline || t == DType.number;

  @override
  void initState() {
    super.initState();
    for (final f in widget.fields) {
      final v = widget.initial[f.id]?.toString() ?? '';
      if (_isText(f.type)) {
        _text[f.id] = TextEditingController(text: v);
      } else {
        _values[f.id] = v;
      }
    }
  }

  @override
  void dispose() {
    for (final c in _text.values) {
      c.dispose();
    }
    super.dispose();
  }

  /// Current values for all fields (text + pickers), non-empty only.
  Map<String, String> collect() {
    final out = <String, String>{};
    for (final f in widget.fields) {
      final v = _isText(f.type)
          ? _text[f.id]!.text.trim()
          : (_values[f.id] ?? '');
      if (v.isNotEmpty) out[f.id] = v;
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final f in widget.fields)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _field(f),
          ),
      ],
    );
  }

  Widget _field(DField f) {
    switch (f.type) {
      case DType.multiline:
        return TextField(
            controller: _text[f.id],
            maxLines: 3,
            decoration: _dec(f).copyWith(
                suffixIcon: NativeEditButton.maybe(_text[f.id]!, title: f.mr)));
      case DType.number:
        return TextField(
            controller: _text[f.id],
            keyboardType: TextInputType.number,
            decoration: _dec(f));
      case DType.text:
        return TextField(
            controller: _text[f.id],
            decoration: _dec(f).copyWith(
                suffixIcon: NativeEditButton.maybe(_text[f.id]!, title: f.mr)));
      case DType.date:
        return _picker(f, () => _pickDate(f));
      case DType.time:
        return _picker(f, () => _pickTime(f));
      case DType.dropdown:
        return DropdownButtonFormField<String>(
          initialValue: f.options.contains(_values[f.id]) ? _values[f.id] : null,
          isExpanded: true,
          decoration: _dec(f),
          items: [
            for (final o in f.options)
              DropdownMenuItem(value: o, child: Text(o, overflow: TextOverflow.ellipsis)),
          ],
          onChanged: (v) => setState(() => _values[f.id] = v ?? ''),
        );
      case DType.checkbox:
        return SwitchListTile(
          contentPadding: EdgeInsets.zero,
          value: _values[f.id] == 'true',
          title: Text('${f.mr} / ${f.en}'),
          onChanged: (v) => setState(() => _values[f.id] = v ? 'true' : ''),
        );
    }
  }

  InputDecoration _dec(DField f) => InputDecoration(
        labelText: f.mr,
        helperText: f.en,
        border: const OutlineInputBorder(),
        isDense: true,
      );

  Widget _picker(DField f, VoidCallback onTap) {
    return InputDecorator(
      decoration: _dec(f),
      child: InkWell(
        onTap: onTap,
        child: Row(children: [
          Expanded(child: Text(_values[f.id]?.isNotEmpty == true ? _values[f.id]! : '—')),
          const Icon(Icons.event, size: 18),
        ]),
      ),
    );
  }

  Future<void> _pickDate(DField f) async {
    final d = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(DateTime.now().year + 1, 12, 31),
    );
    if (d != null) setState(() => _values[f.id] = '${d.day}/${d.month}/${d.year}');
  }

  Future<void> _pickTime(DField f) async {
    final t = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null && mounted) setState(() => _values[f.id] = t.format(context));
  }
}
