import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'station_report_model.dart';

/// The editable Property / Body category mapping for the station-wise report.
class StationReportMapping {
  const StationReportMapping({required this.property, required this.body});
  final Set<String> property;
  final Set<String> body;
}

/// Persisted mapping of which crime categories count as property vs body. Seeded
/// from the defaults on first use, then whatever the officer ticks.
final stationReportMappingProvider =
    NotifierProvider<StationReportMappingNotifier, StationReportMapping>(
        StationReportMappingNotifier.new);

class StationReportMappingNotifier extends Notifier<StationReportMapping> {
  static const _key = 'station_report_mapping_v1';
  bool _loaded = false;

  @override
  StationReportMapping build() {
    if (!_loaded) _load();
    return StationReportMapping(
      property: defaultPropertyCategories().toSet(),
      body: defaultBodyCategories().toSet(),
    );
  }

  Future<void> _load() async {
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      state = StationReportMapping(
        property: {for (final c in (m['property'] as List? ?? [])) c.toString()},
        body: {for (final c in (m['body'] as List? ?? [])) c.toString()},
      );
    } catch (_) {/* keep defaults */}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key,
        jsonEncode({
          'property': state.property.toList(),
          'body': state.body.toList(),
        }));
  }

  void setProperty(Set<String> categories) {
    state = StationReportMapping(property: categories, body: state.body);
    _save();
  }

  void setBody(Set<String> categories) {
    state = StationReportMapping(property: state.property, body: categories);
    _save();
  }

  void reset() {
    state = StationReportMapping(
      property: defaultPropertyCategories().toSet(),
      body: defaultBodyCategories().toSet(),
    );
    _save();
  }
}

/// The selected month/year + window for the station-wise report. Defaults to the
/// current month/year, cumulative (…अखेर पावेतो).
final stationReportPeriodProvider =
    NotifierProvider<StationReportPeriodNotifier, StationReportPeriod>(
        StationReportPeriodNotifier.new);

class StationReportPeriodNotifier extends Notifier<StationReportPeriod> {
  @override
  StationReportPeriod build() {
    final now = DateTime.now();
    return StationReportPeriod(month: now.month, year: now.year);
  }

  void setMonth(int m) => state = StationReportPeriod(
      month: m, year: state.year, mode: state.mode);
  void setYear(int y) => state = StationReportPeriod(
      month: state.month, year: y, mode: state.mode);
  void setMode(StationPeriodMode mode) => state = StationReportPeriod(
      month: state.month, year: state.year, mode: mode);
}
