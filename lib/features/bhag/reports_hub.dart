import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'bhag_report_spec.dart';
import 'bhag_screen.dart';
import 'preventive_report_model.dart';
import 'preventive_report_screen.dart';
import 'recovered_report_model.dart';
import 'station_report_model.dart';
import 'undetected_report_model.dart';

/// One report shown in the Reports section. Add a new [BhagReportSpec] in
/// bhag_report_spec.dart and a tile here, and the hub picks it up.
class ReportTileDef {
  const ReportTileDef({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    this.portalOnly = false,
  });
  final String id;
  final String titleKey;
  final String subtitleKey;
  final IconData icon;

  /// Reports that need multi-station (division) data only make sense in the
  /// officer portal; the single-station app hides them.
  final bool portalOnly;
}

const List<ReportTileDef> kReports = [
  ReportTileDef(
    id: 'bhag15',
    titleKey: 'bhag.title',
    subtitleKey: 'reports.bhagSubtitle',
    icon: PhosphorIconsRegular.table,
  ),
  ReportTileDef(
    id: 'bhag6',
    titleKey: 'bhag6.title',
    subtitleKey: 'reports.bhag6Subtitle',
    icon: PhosphorIconsRegular.table,
  ),
  ReportTileDef(
    id: kStationReportId,
    titleKey: 'stationReport.title',
    subtitleKey: 'reports.stationSubtitle',
    icon: PhosphorIconsRegular.buildings,
    portalOnly: true,
  ),
  ReportTileDef(
    id: kRecoveredReportId,
    titleKey: 'recovered.title',
    subtitleKey: 'reports.recoveredSubtitle',
    icon: PhosphorIconsRegular.package,
    portalOnly: true,
  ),
  ReportTileDef(
    id: kPreventiveReportId,
    titleKey: 'preventive.title',
    subtitleKey: 'reports.preventiveSubtitle',
    icon: PhosphorIconsRegular.shieldCheck,
  ),
  ReportTileDef(
    id: kUndetectedReportId,
    titleKey: 'undetected.title',
    subtitleKey: 'reports.undetectedSubtitle',
    icon: PhosphorIconsRegular.magnifyingGlass,
    portalOnly: true,
  ),
  // Future reports go here — one tile + one spec each.
];

/// The shared list of report tiles. [onOpen] gets the report id so the station
/// app and the officer portal can open it with their own data source.
/// [isPortal] shows the portal-only reports (per-station division tables).
class ReportsList extends StatelessWidget {
  const ReportsList({super.key, required this.onOpen, this.isPortal = false});
  final void Function(BuildContext context, String reportId) onOpen;
  final bool isPortal;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final r in kReports)
          if (isPortal || !r.portalOnly)
          Card(
            child: ListTile(
              leading: Icon(r.icon, size: 28),
              title: Text(r.titleKey.tr(),
                  style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(r.subtitleKey.tr()),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => onOpen(context, r.id),
            ),
          ),
      ],
    );
  }
}

/// The Reports hub for the station app (embedded in the shell — no app bar).
/// Tapping a report opens it as a full page.
class ReportsHubScreen extends StatelessWidget {
  const ReportsHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReportsList(
      onOpen: (context, id) {
        if (id == kPreventiveReportId) {
          Navigator.of(context).push(MaterialPageRoute<void>(
              builder: (_) => const PreventiveStationScreen()));
          return;
        }
        final spec = kBhagSpecs[id];
        if (spec == null) return;
        Navigator.of(context).push(
          MaterialPageRoute<void>(builder: (_) => BhagScreen(spec: spec)),
        );
      },
    );
  }
}
