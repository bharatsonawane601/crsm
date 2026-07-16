import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/analyzer/analytics_model.dart';
import 'package:crms/features/bhag/station_report_model.dart';

AnalyticsRow _row(String station, String crimeType, String status, DateTime d) =>
    AnalyticsRow(
        id: 0,
        status: status,
        station: station,
        crimeType: crimeType,
        dateRegistered: d);

void main() {
  final body = defaultBodyCategories().toSet();
  final property = defaultPropertyCategories().toSet();

  test('splits stations into property vs body, sorted by दाखल desc', () {
    final firs = [
      // Property crimes (Theft category via sub-type + category label).
      _row('Kranti Chowk', 'Vehicle Theft / वाहन चोरी', 'detected', DateTime(2025, 12, 3)),
      _row('Kranti Chowk', 'Theft / चोरी', 'undetected', DateTime(2025, 12, 4)),
      _row('City Chowk', 'Robbery / जबरी चोरी', 'undetected', DateTime(2025, 12, 5)),
      // Body crimes.
      _row('Kranti Chowk', 'Murder / खून', 'detected', DateTime(2025, 12, 6)),
      _row('City Chowk', 'Simple Hurt / साधी दुखापत', 'detected', DateTime(2025, 12, 7)),
      _row('City Chowk', 'Grievous Hurt / गंभीर दुखापत', 'undetected', DateTime(2025, 12, 8)),
    ];

    final data = computeStationReport(
      firs: firs,
      bodyCategories: body,
      propertyCategories: property,
      period: const StationReportPeriod(month: 12, year: 2025),
    );

    // Property: Kranti Chowk 2 (1 detected), City Chowk 1 (0). Sorted desc.
    expect(data.property.rows.map((r) => r.station).toList(),
        ['Kranti Chowk', 'City Chowk']);
    expect(data.property.rows.first.registered, 2);
    expect(data.property.rows.first.detected, 1);
    expect(data.property.totalRegistered, 3);
    expect(data.property.totalDetected, 1);

    // Body: City Chowk 2 (1 detected), Kranti Chowk 1 (1). Sorted desc.
    expect(data.body.rows.first.station, 'City Chowk');
    expect(data.body.rows.first.registered, 2);
    expect(data.body.totalRegistered, 3);
    expect(data.body.totalDetected, 2);
  });

  test('cumulative window includes earlier months of the same year', () {
    final firs = [
      _row('A', 'Theft / चोरी', 'detected', DateTime(2025, 3, 1)),
      _row('A', 'Theft / चोरी', 'detected', DateTime(2025, 12, 1)),
      _row('A', 'Theft / चोरी', 'detected', DateTime(2024, 12, 1)), // other year
    ];

    final cumulative = computeStationReport(
      firs: firs,
      bodyCategories: body,
      propertyCategories: property,
      period: const StationReportPeriod(
          month: 12, year: 2025, mode: StationPeriodMode.cumulative),
    );
    expect(cumulative.property.totalRegistered, 2); // Mar + Dec 2025

    final monthOnly = computeStationReport(
      firs: firs,
      bodyCategories: body,
      propertyCategories: property,
      period: const StationReportPeriod(
          month: 12, year: 2025, mode: StationPeriodMode.month),
    );
    expect(monthOnly.property.totalRegistered, 1); // only Dec 2025
  });

  test('editable mapping moves a category between sides', () {
    final firs = [
      _row('A', 'Gambling / जुगार', 'detected', DateTime(2025, 12, 1)),
    ];
    // Gambling is in neither default set -> excluded from both.
    final base = computeStationReport(
      firs: firs,
      bodyCategories: body,
      propertyCategories: property,
      period: const StationReportPeriod(month: 12, year: 2025),
    );
    expect(base.property.rows, isEmpty);
    expect(base.body.rows, isEmpty);

    // Officer adds Gambling to the property side.
    final edited = computeStationReport(
      firs: firs,
      bodyCategories: body,
      propertyCategories: {...property, 'Gambling / जुगार'},
      period: const StationReportPeriod(month: 12, year: 2025),
    );
    expect(edited.property.totalRegistered, 1);
  });
}
