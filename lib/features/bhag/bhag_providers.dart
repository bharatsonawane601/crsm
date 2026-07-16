import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bhag_model.dart';

/// Every report's editable row setup, keyed by report id, persisted. A report
/// with no saved rows falls back to its spec defaults until first edited.
final bhagConfigsProvider =
    NotifierProvider<BhagConfigsNotifier, Map<String, List<BhagRow>>>(
        BhagConfigsNotifier.new);

class BhagConfigsNotifier extends Notifier<Map<String, List<BhagRow>>> {
  static const _key = 'bhag_configs_v1';
  bool _loaded = false;

  @override
  Map<String, List<BhagRow>> build() {
    if (!_loaded) _load();
    return {};
  }

  Future<void> _load() async {
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      state = {
        for (final e in m.entries)
          e.key: [
            for (final r in (e.value as List))
              BhagRow.fromJson((r as Map).cast<String, dynamic>())
          ]
      };
    } catch (_) {/* keep empty */}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        _key,
        jsonEncode({
          for (final e in state.entries)
            e.key: [for (final r in e.value) r.toJson()]
        }));
  }

  String _newId() => 'r${DateTime.now().microsecondsSinceEpoch}';
  List<BhagRow> _rows(String rid) => state[rid] ?? const [];
  void _set(String rid, List<BhagRow> rows) {
    state = {...state, rid: rows};
    _save();
  }

  /// Seed a report with its defaults the first time it is opened.
  void seedIfAbsent(String rid, List<BhagRow> defaults) {
    if (!state.containsKey(rid)) _set(rid, defaults);
  }

  /// Adds a single crime-type row. Returns false (and does nothing) when that
  /// type is already present, so the same crime can't be added twice.
  bool addSingle(String rid, String crimeType) {
    final rows = _rows(rid);
    final exists = rows.any((r) => r.isSingle && r.primary == crimeType);
    if (exists) return false;
    _set(rid, [...rows, BhagRow(id: _newId(), crimeTypes: [crimeType])]);
    return true;
  }

  void addCombined(String rid, String label, List<String> crimeTypes) => _set(
      rid, [..._rows(rid), BhagRow(id: _newId(), crimeTypes: crimeTypes, label: label)]);

  void removeRow(String rid, String id) =>
      _set(rid, [for (final r in _rows(rid)) if (r.id != id) r]);

  void resetToDefault(String rid, List<BhagRow> defaults) =>
      _set(rid, defaults);
}

/// The selected month + the two years being compared, shared across reports.
/// Defaults to the current month, previous year (A) vs current year (B).
final bhagPeriodProvider =
    NotifierProvider<BhagPeriodNotifier, BhagPeriod>(BhagPeriodNotifier.new);

class BhagPeriodNotifier extends Notifier<BhagPeriod> {
  @override
  BhagPeriod build() {
    final now = DateTime.now();
    return BhagPeriod(month: now.month, yearA: now.year - 1, yearB: now.year);
  }

  void setMonth(int m) =>
      state = BhagPeriod(month: m, yearA: state.yearA, yearB: state.yearB);
  void setYearA(int y) =>
      state = BhagPeriod(month: state.month, yearA: y, yearB: state.yearB);
  void setYearB(int y) =>
      state = BhagPeriod(month: state.month, yearA: state.yearA, yearB: y);
}

/// Manual cell overrides, keyed "reportId|signature|rowId|cell". Kept for the
/// session so switching month/year (or reports) preserves edits.
final bhagOverridesProvider =
    NotifierProvider<BhagOverridesNotifier, Map<String, int>>(
        BhagOverridesNotifier.new);

class BhagOverridesNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => {};

  void setValue(String rid, String sig, String rowId, String cell, int? value) {
    final k = '$rid|$sig|$rowId|$cell';
    final m = Map<String, int>.of(state);
    if (value == null) {
      m.remove(k);
    } else {
      m[k] = value;
    }
    state = m;
  }
}

/// The overrides for one report+period, re-keyed to "rowId|cell" for the compute.
Map<String, int> overridesForPeriod(
    Map<String, int> all, String rid, BhagPeriod period) {
  final prefix = '$rid|${period.signature}|';
  return {
    for (final e in all.entries)
      if (e.key.startsWith(prefix)) e.key.substring(prefix.length): e.value
  };
}
