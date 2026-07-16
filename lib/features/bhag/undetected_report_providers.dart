import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'undetected_report_model.dart';

/// The editable row set for the undetected report, persisted. Falls back to the
/// sheet defaults until first edited.
final undetConfigProvider =
    NotifierProvider<UndetConfigNotifier, List<UndetRow>>(
        UndetConfigNotifier.new);

class UndetConfigNotifier extends Notifier<List<UndetRow>> {
  static const _key = 'undetected_rows_v1';
  bool _loaded = false;

  @override
  List<UndetRow> build() {
    if (!_loaded) _load();
    return defaultUndetRows();
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
          UndetRow.fromJson((r as Map).cast<String, dynamic>())
      ];
    } catch (_) {/* keep defaults */}
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode([for (final r in state) r.toJson()]));
  }

  void _set(List<UndetRow> rows) {
    state = rows;
    _save();
  }

  /// Add a custom head. [categories]/[types] are the crime categories / exact
  /// crime-types it should match. Returns false (no-op) when a head already
  /// covers the same category/type, so a head can't be added twice.
  bool addRow(String label, Set<String> categories, Set<String> types) {
    final covered = state.any((r) =>
        r.categories.intersection(categories).isNotEmpty ||
        r.types.intersection(types).isNotEmpty);
    if (covered) return false;
    final id = 'u${DateTime.now().microsecondsSinceEpoch}';
    // Keep the इतर remainder row last so it always sweeps what's left.
    final remainder = [for (final r in state) if (r.isRemainder) r];
    final rest = [for (final r in state) if (!r.isRemainder) r];
    _set([
      ...rest,
      UndetRow(id: id, label: label, categories: categories, types: types),
      ...remainder,
    ]);
    return true;
  }

  void removeRow(String id) => _set([for (final r in state) if (r.id != id) r]);

  void resetToDefault() => _set(defaultUndetRows());
}

/// The date range covered, persisted for the session. Defaults to the current
/// calendar year (1 Jan – 31 Dec).
final undetRangeProvider =
    NotifierProvider<UndetRangeNotifier, UndetRange>(UndetRangeNotifier.new);

class UndetRangeNotifier extends Notifier<UndetRange> {
  @override
  UndetRange build() {
    final y = DateTime.now().year;
    return UndetRange(from: DateTime(y, 1, 1), to: DateTime(y, 12, 31));
  }

  void setFrom(DateTime d) => state = UndetRange(from: d, to: state.to);
  void setTo(DateTime d) => state = UndetRange(from: state.from, to: d);
}

/// Manual per-cell overrides, keyed "signature|rowId|station". Session-scoped so
/// switching the date range keeps each range's edits.
final undetOverridesProvider =
    NotifierProvider<UndetOverridesNotifier, Map<String, int>>(
        UndetOverridesNotifier.new);

class UndetOverridesNotifier extends Notifier<Map<String, int>> {
  @override
  Map<String, int> build() => {};

  void setValue(String sig, String rowId, String station, int? v) {
    final k = '$sig|$rowId|$station';
    final m = Map<String, int>.of(state);
    if (v == null) {
      m.remove(k);
    } else {
      m[k] = v;
    }
    state = m;
  }
}

/// Overrides for one range, re-keyed to "rowId|station" for the compute.
Map<String, int> undetOverridesForRange(
    Map<String, int> all, UndetRange range) {
  final prefix = '${range.signature}|';
  return {
    for (final e in all.entries)
      if (e.key.startsWith(prefix)) e.key.substring(prefix.length): e.value
  };
}
