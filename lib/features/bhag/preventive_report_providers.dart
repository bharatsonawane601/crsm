import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bhag_model.dart' show BhagPeriod;
import 'preventive_report_model.dart';

/// The editable provision rows, persisted. Falls back to the sheet defaults
/// until first edited.
final preventiveConfigProvider =
    NotifierProvider<PreventiveConfigNotifier, List<PreventiveRow>>(
        PreventiveConfigNotifier.new);

class PreventiveConfigNotifier extends Notifier<List<PreventiveRow>> {
  static const _key = 'preventive_rows_v1';
  bool _loaded = false;

  @override
  List<PreventiveRow> build() {
    if (!_loaded) _load();
    return defaultPreventiveRows();
  }

  Future<void> _load() async {
    _loaded = true;
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return;
    try {
      final list = jsonDecode(raw) as List;
      state = [
        for (final r in list)
          PreventiveRow.fromJson((r as Map).cast<String, dynamic>())
      ];
    } catch (_) {/* keep defaults */}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode([for (final r in state) r.toJson()]));
  }

  void _set(List<PreventiveRow> rows) {
    state = rows;
    _save();
  }

  void addRow(String label, List<String> patterns) {
    final id = 'p${DateTime.now().microsecondsSinceEpoch}';
    _set([
      ...state,
      PreventiveRow(
          id: id,
          label: label,
          // Fall back to the label itself as a match pattern when none given.
          patterns: patterns.isEmpty ? [label] : patterns),
    ]);
  }

  void removeRow(String id) => _set([for (final r in state) if (r.id != id) r]);

  void resetToDefault() => _set(defaultPreventiveRows());
}

/// Manual per-cell overrides, keyed "signature|rowId|cell". Session-scoped so
/// switching month/years keeps each period's edits.
final preventiveOverridesProvider =
    NotifierProvider<PreventiveOverridesNotifier, Map<String, int>>(
        PreventiveOverridesNotifier.new);

class PreventiveOverridesNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => {};

  void setValue(String sig, String rowId, String cell, int? v) {
    final k = '$sig|$rowId|$cell';
    final m = Map<String, int>.of(state);
    if (v == null) {
      m.remove(k);
    } else {
      m[k] = v;
    }
    state = m;
  }
}

/// Overrides for one period, re-keyed to "rowId|cell" for the compute.
Map<String, int> preventiveOverridesForPeriod(
    Map<String, int> all, BhagPeriod period) {
  final prefix = '${period.signature}|';
  return {
    for (final e in all.entries)
      if (e.key.startsWith(prefix)) e.key.substring(prefix.length): e.value
  };
}
