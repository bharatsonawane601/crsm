import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'recovered_report_model.dart';
import 'station_report_model.dart';

/// Persisted theft-type mapping for the three explicit columns (इतर is derived).
final recoveredMappingProvider =
    NotifierProvider<RecoveredMappingNotifier, RecoveredMapping>(
        RecoveredMappingNotifier.new);

class RecoveredMappingNotifier extends Notifier<RecoveredMapping> {
  static const _key = 'recovered_mapping_v1';
  bool _loaded = false;

  @override
  RecoveredMapping build() {
    if (!_loaded) _load();
    return defaultRecoveredMapping();
  }

  Future<void> _load() async {
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      Set<String> set(String k) =>
          {for (final v in (m[k] as List? ?? [])) v.toString()};
      state = RecoveredMapping(
        twoWheeler: set('twoWheeler'),
        fourWheeler: set('fourWheeler'),
        jewellery: set('jewellery'),
      );
    } catch (_) {/* keep defaults */}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key,
        jsonEncode({
          'twoWheeler': state.twoWheeler.toList(),
          'fourWheeler': state.fourWheeler.toList(),
          'jewellery': state.jewellery.toList(),
        }));
  }

  void setCol(RecoveredCol col, Set<String> types) {
    state = RecoveredMapping(
      twoWheeler: col == RecoveredCol.twoWheeler ? types : state.twoWheeler,
      fourWheeler: col == RecoveredCol.fourWheeler ? types : state.fourWheeler,
      jewellery: col == RecoveredCol.jewellery ? types : state.jewellery,
    );
    _save();
  }

  void reset() {
    state = defaultRecoveredMapping();
    _save();
  }
}

/// The selected month/year + window for the recovered report (own copy so it is
/// independent of the other reports). Defaults to current month, cumulative.
final recoveredPeriodProvider =
    NotifierProvider<RecoveredPeriodNotifier, StationReportPeriod>(
        RecoveredPeriodNotifier.new);

class RecoveredPeriodNotifier extends Notifier<StationReportPeriod> {
  @override
  StationReportPeriod build() {
    final now = DateTime.now();
    return StationReportPeriod(month: now.month, year: now.year);
  }

  void setMonth(int m) =>
      state = StationReportPeriod(month: m, year: state.year, mode: state.mode);
  void setYear(int y) =>
      state = StationReportPeriod(month: state.month, year: y, mode: state.mode);
  void setMode(StationPeriodMode mode) => state =
      StationReportPeriod(month: state.month, year: state.year, mode: mode);
}

/// Manual per-cell overrides, keyed "signature|station|colIndex|field". Kept for
/// the session so दागिने (which has no auto source) and any corrections persist
/// while switching month/year.
final recoveredOverridesProvider =
    NotifierProvider<RecoveredOverridesNotifier, Map<String, num>>(
        RecoveredOverridesNotifier.new);

class RecoveredOverridesNotifier extends Notifier<Map<String, num>> {
  @override
  Map<String, num> build() => {};

  void setValue(String sig, String station, int colIndex, String field, num? v) {
    final k = '$sig|$station|$colIndex|$field';
    final m = Map<String, num>.of(state);
    if (v == null) {
      m.remove(k);
    } else {
      m[k] = v;
    }
    state = m;
  }
}

/// Overrides for one period, re-keyed to "station|colIndex|field" for compute.
Map<String, num> recoveredOverridesForPeriod(
    Map<String, num> all, StationReportPeriod period) {
  final prefix = '${period.signature}|';
  return {
    for (final e in all.entries)
      if (e.key.startsWith(prefix)) e.key.substring(prefix.length): e.value
  };
}
