import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/widgets/language_toggle.dart';
import '../crime_entry/crime_entry_screen.dart';
import '../crime_entry/crime_repository.dart';
import '../crime_entry/models/crime_draft.dart';
import '../portal/central_upload_controller.dart';
import '../reports/report_generate_sheet.dart';

final _dateFmt = DateFormat('dd-MM-yyyy');

/// Read-only full view of a single crime, with edit and delete actions.
class CrimeDetailScreen extends ConsumerStatefulWidget {
  const CrimeDetailScreen({super.key, required this.crimeId});

  final int crimeId;

  @override
  ConsumerState<CrimeDetailScreen> createState() => _CrimeDetailScreenState();
}

class _CrimeDetailScreenState extends ConsumerState<CrimeDetailScreen> {
  late Future<CrimeDraft?> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _future = ref.read(crimeRepositoryProvider).loadDraft(widget.crimeId);
  }

  Future<void> _edit() async {
    final result = await Navigator.of(context).push<Object?>(
      MaterialPageRoute(
        builder: (_) => CrimeEntryScreen(crimeId: widget.crimeId),
      ),
    );
    if (!mounted) return;
    if (result == 'deleted') {
      Navigator.of(context).pop('deleted');
    } else {
      setState(_reload);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('crime.deleteTitle'.tr()),
        content: Text('crime.deleteBody'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('common.cancel'.tr()),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('common.delete'.tr()),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final deleted =
        await ref.read(crimeRepositoryProvider).deleteCrime(widget.crimeId);
    if (deleted != null) {
      ref.read(centralUploadControllerProvider.notifier).reportDeletion(deleted);
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('detail.deleted'.tr())));
    Navigator.of(context).pop('deleted');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('detail.title'.tr()),
        actions: [
          const Center(child: LanguageToggle()),
          IconButton(
            tooltip: 'report.generate'.tr(),
            icon: const Icon(Icons.picture_as_pdf_outlined),
            onPressed: () => showReportSheet(context, widget.crimeId),
          ),
          IconButton(
            tooltip: 'common.edit'.tr(),
            icon: const Icon(Icons.edit_outlined),
            onPressed: _edit,
          ),
          IconButton(
            tooltip: 'common.delete'.tr(),
            icon: const Icon(Icons.delete_outline),
            onPressed: _delete,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: FutureBuilder<CrimeDraft?>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final d = snap.data;
          if (d == null) {
            return Center(child: Text('detail.noData'.tr()));
          }
          return _DetailBody(draft: d);
        },
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.draft});
  final CrimeDraft draft;

  @override
  Widget build(BuildContext context) {
    final d = draft;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '${d.firNo} / ${d.year}',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        _Section(title: 'crime.tabs.info'.tr(), rows: [
          _Row('crime.info.section'.tr(), d.section),
          _Row('crime.info.subSection'.tr(), d.subSection),
          _Row('crime.info.crimeType'.tr(), d.crimeType),
          _Row('crime.info.status'.tr(), 'crime.status.${d.status}'.tr()),
          _Row('crime.info.district'.tr(), d.district),
          _Row('crime.info.policeStation'.tr(), d.policeStation),
          _Row('crime.info.dateOccurred'.tr(), _fmtDate(d.dateOccurred)),
          _Row('crime.info.timeOccurred'.tr(), d.timeOccurred),
          _Row('crime.info.placeOccurred'.tr(), d.placeOccurred),
          _Row('crime.info.dateRegistered'.tr(), _fmtDate(d.dateRegistered)),
          _Row('crime.info.timeRegistered'.tr(), d.timeRegistered),
          _Row('crime.info.detailedDescription'.tr(), d.detailedDescription),
        ]),
        _Section(title: 'crime.tabs.complainant'.tr(), rows: [
          ..._personRows(d.complainant),
        ]),
        _ListSection(
          title: 'crime.tabs.accused'.tr(),
          empty: d.accused.isEmpty,
          children: [
            for (var i = 0; i < d.accused.length; i++)
              _MiniCard(
                title: 'crime.accused.title'.tr(namedArgs: {'n': '${i + 1}'}),
                rows: [
                  ..._personRows(d.accused[i]),
                  _Row('crime.accused.arrestStatus'.tr(),
                      d.accused[i].arrestStatus),
                  _Row('crime.accused.arrestDate'.tr(),
                      _fmtDate(d.accused[i].arrestDate)),
                ],
              ),
          ],
        ),
        _ListSection(
          title: 'crime.property.stolenTitle'.tr(),
          empty: d.stolen.isEmpty,
          children: [
            for (final s in d.stolen)
              _MiniCard(title: s.type ?? '—', rows: [
                _Row('crime.property.description'.tr(), s.description),
                _Row('crime.property.value'.tr(), s.value?.toString()),
              ]),
          ],
        ),
        _ListSection(
          title: 'crime.property.recoveredTitle'.tr(),
          empty: d.recovered.isEmpty,
          children: [
            for (final r in d.recovered)
              _MiniCard(title: r.description ?? '—', rows: [
                _Row('crime.property.value'.tr(), r.value?.toString()),
                _Row('crime.property.recoveryDate'.tr(),
                    _fmtDate(r.recoveryDate)),
              ]),
          ],
        ),
        _Section(title: 'crime.tabs.investigation'.tr(), rows: [
          _Row('crime.investigation.officerName'.tr(),
              d.investigation.officerName),
          _Row('crime.investigation.officerId'.tr(),
              d.investigation.officerId),
          _Row('crime.investigation.officerMobile'.tr(),
              d.investigation.officerMobile),
          _Row('crime.investigation.filedBy'.tr(), d.investigation.filedBy),
          _Row('crime.investigation.preventiveAction'.tr(),
              d.investigation.preventiveAction),
          _Row('crime.investigation.wantedAccused'.tr(),
              d.investigation.wantedAccused),
        ]),
        _Section(title: 'crime.tabs.verdict'.tr(), rows: [
          _Row('crime.verdict.chargesheetNo'.tr(), d.verdict.chargesheetNo),
          _Row('crime.verdict.chargesheetDate'.tr(),
              _fmtDate(d.verdict.chargesheetDate)),
          _Row('crime.verdict.rccNo'.tr(), d.verdict.rccNo),
          _Row('crime.verdict.finalOrder'.tr(), d.verdict.finalOrder),
          _Row(
            'crime.verdict.foundGuilty'.tr(),
            d.verdict.foundGuilty == null
                ? null
                : (d.verdict.foundGuilty! ? 'common.yes'.tr() : 'common.no'.tr()),
          ),
          _Row('crime.verdict.punishment'.tr(), d.verdict.punishment),
        ]),
        _ListSection(
          title: 'crime.tabs.attachments'.tr(),
          empty: d.attachments.isEmpty,
          children: [
            for (final a in d.attachments)
              _MiniCard(title: a.fileType ?? '—', rows: [
                _Row('crime.attachments.filePath'.tr(), a.filePath),
                _Row('crime.attachments.description'.tr(), a.description),
              ]),
          ],
        ),
      ],
    );
  }

  static String? _fmtDate(DateTime? d) => d == null ? null : _dateFmt.format(d);

  List<_Row> _personRows(PersonDraft p) => [
        _Row('crime.person.name'.tr(), p.name),
        _Row(
          'crime.person.gender'.tr(),
          p.gender == null ? null : 'crime.gender.${p.gender}'.tr(),
        ),
        _Row('crime.person.age'.tr(), p.age?.toString()),
        _Row('crime.person.address'.tr(), p.address),
        _Row('crime.person.mobile'.tr(), p.mobile),
        _Row('crime.person.email'.tr(), p.email),
        _Row('crime.person.aadhaar'.tr(), p.aadhaar),
        _Row('crime.person.pan'.tr(), p.pan),
        _Row('crime.person.passport'.tr(), p.passport),
      ];
}

/// A label/value pair; renders nothing when the value is empty.
class _Row {
  const _Row(this.label, this.value);
  final String label;
  final String? value;
  bool get isEmpty => (value ?? '').trim().isEmpty;
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});
  final String title;
  final List<_Row> rows;

  @override
  Widget build(BuildContext context) {
    final visible = rows.where((r) => !r.isEmpty).toList();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            if (visible.isEmpty)
              Text('detail.noneAdded'.tr())
            else
              for (final r in visible) _RowTile(row: r),
          ],
        ),
      ),
    );
  }
}

class _ListSection extends StatelessWidget {
  const _ListSection({
    required this.title,
    required this.empty,
    required this.children,
  });
  final String title;
  final bool empty;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            if (empty) Text('detail.noneAdded'.tr()) else ...children,
          ],
        ),
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.title, required this.rows});
  final String title;
  final List<_Row> rows;

  @override
  Widget build(BuildContext context) {
    final visible = rows.where((r) => !r.isEmpty).toList();
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          for (final r in visible) _RowTile(row: r),
        ],
      ),
    );
  }
}

class _RowTile extends StatelessWidget {
  const _RowTile({required this.row});
  final _Row row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              row.label,
              style: TextStyle(color: Theme.of(context).hintColor),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(row.value ?? '')),
        ],
      ),
    );
  }
}
