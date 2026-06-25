import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:printing/printing.dart';

import '../../core/theme/spacing.dart';
import 'central_client.dart';
import 'portal_pdf.dart';

/// Opens a read-only detail view of a crime/FIR for the officer portal, with
/// Print and Save-PDF actions. No edit/delete — officers can only view & export.
Future<void> showPortalCrimeDetail(BuildContext context, PortalCrime c) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _PortalCrimeDetail(crime: c),
  );
}

class _PortalCrimeDetail extends StatelessWidget {
  const _PortalCrimeDetail({required this.crime});
  final PortalCrime crime;

  /// The detail rows (label, value), built from the uploaded record blob.
  List<(String, String)> _rows() {
    final d = crime.data;
    String v(String key, String? fallback) {
      final x = d[key];
      if (x == null || x.toString().trim().isEmpty) return fallback ?? '—';
      if (x is List) return x.join(', ');
      return x.toString();
    }

    return [
      ('${'crime.info.firNo'.tr()} / ${'crime.info.year'.tr()}',
          '${v('fir_no', crime.firNo)} / ${v('year', crime.year?.toString())}'),
      ('crime.info.policeStation'.tr(), v('police_station', crime.stationName)),
      ('crime.info.sections'.tr(), v('section', crime.section)),
      ('crime.info.crimeType'.tr(), v('crime_type', crime.crimeType)),
      ('crime.info.status'.tr(), v('status', crime.status)),
      ('crime.info.district'.tr(), v('district', null)),
      ('crime.info.dateOccurred'.tr(), v('date_occurred', null)),
      ('crime.info.placeOccurred'.tr(), v('place_occurred', null)),
      ('crime.info.dateRegistered'.tr(), v('date_registered', null)),
      ('portal.complainant'.tr(), v('complainant_name', null)),
      ('portal.mobile'.tr(), v('complainant_mobile', null)),
      ('portal.accused'.tr(), v('accused_names', null)),
      ('portal.io'.tr(), v('investigating_officer', null)),
      ('portal.finalOrder'.tr(), v('final_order', null)),
      ('portal.punishment'.tr(), v('punishment', null)),
      ('crime.info.detailedDescription'.tr(), v('description', null)),
    ];
  }

  String get _title =>
      '${'crime.info.firNo'.tr()} ${crime.firNo ?? '—'}/${crime.year ?? ''}';

  /// A filesystem-safe name. The FIR number contains "/" (e.g. 1320/2025),
  /// which is illegal in Windows file paths, so replace any illegal char.
  String get _fileName {
    final safe = _title.replaceAll(RegExp(r'[\\/:*?"<>|]'), '-').trim();
    return '${safe.isEmpty ? 'FIR' : safe}.pdf';
  }

  Future<void> _print() => Printing.layoutPdf(
        onLayout: (_) => renderPortalCrimePdf(title: _title, rows: _rows()),
        name: _fileName,
      );

  Future<void> _savePdf() async {
    final bytes = await renderPortalCrimePdf(title: _title, rows: _rows());
    await Printing.sharePdf(bytes: bytes, filename: _fileName);
  }

  @override
  Widget build(BuildContext context) {
    final rows = _rows();
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      builder: (context, controller) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.s4, 0, AppSpacing.s4, AppSpacing.s2),
            child: Row(
              children: [
                Expanded(
                  child: Text(_title,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                IconButton(
                  tooltip: 'report.print'.tr(),
                  icon: const Icon(PhosphorIconsRegular.printer),
                  onPressed: _print,
                ),
                IconButton(
                  tooltip: 'report.save'.tr(),
                  icon: const Icon(PhosphorIconsRegular.filePdf),
                  onPressed: _savePdf,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              controller: controller,
              padding: const EdgeInsets.all(AppSpacing.s4),
              itemCount: rows.length,
              separatorBuilder: (_, _) => const Divider(height: 16),
              itemBuilder: (context, i) {
                final r = rows[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r.$1,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Theme.of(context).hintColor)),
                    const SizedBox(height: 2),
                    Text(r.$2, style: Theme.of(context).textTheme.bodyLarge),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
