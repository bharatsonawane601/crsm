import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analyzer/analytics_model.dart';
import '../auth/auth_service.dart';
import 'central_client.dart';

/// The signed-in officer's email (used to authorise every portal call).
final _officerEmailProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).value?.email;
});

/// The scoped org tree (zones / divisions / stations) this officer may see. It
/// feeds the three cascading dropdowns and the comparison picker.
final portalScopeTreeProvider =
    FutureProvider<PortalScopeTree>((ref) async {
  final email = ref.watch(_officerEmailProvider);
  if (email == null) return PortalScopeTree.empty;
  final client = CentralClient();
  ref.onDispose(client.dispose);
  return client.scopeTree(email: email);
});

/// The current single-select scope from the three dropdowns. Dashboard + search
/// both narrow to this. Selecting a broader level clears the narrower ones.
final portalScopeProvider =
    NotifierProvider<PortalScopeNotifier, PortalScope>(PortalScopeNotifier.new);

class PortalScopeNotifier extends Notifier<PortalScope> {
  @override
  PortalScope build() => const PortalScope();

  /// Pick a zone (or null = all zones). Clears the ACP + station below it.
  void setZone(int? zoneId) => state = PortalScope(zoneId: zoneId);

  /// Pick an ACP division (or null). Clears the station below it; keeps zone.
  void setDivision(int? divisionId) =>
      state = PortalScope(zoneId: state.zoneId, divisionId: divisionId);

  /// Pick a police station (or null). Keeps the zone + ACP above it.
  void setStation(int? stationId) => state = PortalScope(
      zoneId: state.zoneId,
      divisionId: state.divisionId,
      stationId: stationId);
}

// --- Comparison (separate section): pick multiple stations or ACPs -----------

/// Whether the comparison picks stations or ACP divisions ('station'|'division').
final compareByProvider =
    NotifierProvider<CompareByNotifier, String>(CompareByNotifier.new);

class CompareByNotifier extends Notifier<String> {
  @override
  String build() => 'station';
  void set(String by) => state = by;
}

/// The set of entity ids selected for comparison.
final compareSelectionProvider =
    NotifierProvider<CompareSelectionNotifier, Set<int>>(
        CompareSelectionNotifier.new);

class CompareSelectionNotifier extends Notifier<Set<int>> {
  @override
  Set<int> build() {
    // Reset the selection whenever the compare-by mode flips.
    ref.watch(compareByProvider);
    return <int>{};
  }

  void toggle(int id) {
    final next = {...state};
    if (!next.remove(id)) next.add(id);
    state = next;
  }

  void clear() => state = <int>{};
}

/// Runs the side-by-side comparison for the current selection.
final portalCompareResultsProvider =
    FutureProvider.autoDispose<List<PortalCompareRow>>((ref) async {
  final email = ref.watch(_officerEmailProvider);
  final by = ref.watch(compareByProvider);
  final ids = ref.watch(compareSelectionProvider).toList()..sort();
  if (email == null || ids.isEmpty) return const [];
  final client = CentralClient();
  ref.onDispose(client.dispose);
  return client.compare(email: email, by: by, ids: ids);
});

/// Filters driving the portal crime search.
class PortalSearchQuery {
  const PortalSearchQuery({
    this.text = '',
    this.year,
    this.status,
    this.crimeType,
    this.page = 1,
  });

  final String text;
  final int? year;
  final String? status;
  final String? crimeType;
  final int page;

  PortalSearchQuery copyWith({
    String? text,
    Object? year = _keep,
    Object? status = _keep,
    Object? crimeType = _keep,
    int? page,
  }) =>
      PortalSearchQuery(
        text: text ?? this.text,
        year: year == _keep ? this.year : year as int?,
        status: status == _keep ? this.status : status as String?,
        crimeType: crimeType == _keep ? this.crimeType : crimeType as String?,
        page: page ?? this.page,
      );

  static const _keep = Object();
}

/// Current search filters; the results provider watches this.
final portalSearchQueryProvider =
    NotifierProvider<PortalSearchQueryNotifier, PortalSearchQuery>(
        PortalSearchQueryNotifier.new);

class PortalSearchQueryNotifier extends Notifier<PortalSearchQuery> {
  @override
  PortalSearchQuery build() => const PortalSearchQuery();

  void update(PortalSearchQuery q) => state = q;
}

/// Runs the scope-filtered search for the current filters.
final portalSearchResultsProvider =
    FutureProvider.autoDispose<PortalSearchResult>((ref) async {
  final email = ref.watch(_officerEmailProvider);
  if (email == null) {
    return PortalSearchResult(total: 0, page: 1, rows: const []);
  }
  final q = ref.watch(portalSearchQueryProvider);
  final scope = ref.watch(portalScopeProvider);
  final client = CentralClient();
  ref.onDispose(client.dispose);
  return client.search(
    email: email,
    query: q.text,
    year: q.year,
    status: q.status,
    crimeType: q.crimeType,
    scope: scope,
    page: q.page,
  );
});

/// Loads all scope-filtered crime rows and maps them into the shared analytics
/// model, so the full dashboard (KPIs + every chart) works in the portal.
final portalAnalyticsRowsProvider =
    FutureProvider.autoDispose<List<AnalyticsRow>>((ref) async {
  final email = ref.watch(_officerEmailProvider);
  if (email == null) return const [];
  final scope = ref.watch(portalScopeProvider);
  final client = CentralClient();
  ref.onDispose(client.dispose);
  final raw = await client.rows(email: email, scope: scope);
  return [for (final r in raw) _toAnalyticsRow(r)];
});

DateTime? _parseDate(Object? v) =>
    (v is String && v.isNotEmpty) ? DateTime.tryParse(v) : null;

AnalyticsRow _toAnalyticsRow(Map<String, dynamic> r) {
  final data = (r['data'] as Map?)?.cast<String, dynamic>() ?? const {};
  final year = (r['year'] as num?)?.toInt();
  num asNum(Object? v) => v is num ? v : 0;
  return AnalyticsRow(
    id: (r['id'] as num?)?.toInt() ?? 0,
    status: (r['status'] as String?) ?? 'undetected',
    dateRegistered: _parseDate(r['date_registered']) ??
        _parseDate(r['date_occurred']) ??
        (year != null && year > 1900 ? DateTime(year) : null),
    section: r['section'] as String?,
    crimeType: r['crime_type'] as String?,
    officerName: data['officer_name'] as String?,
    station: r['station_name'] as String?,
    chargesheetDate: _parseDate(data['chargesheet_date']),
    recoveredValue: asNum(data['recovered_value']).toDouble(),
    accusedCount: asNum(data['accused_count']).toInt(),
    arrestedCount: asNum(data['arrested_count']).toInt(),
    wantedCount: asNum(data['wanted_count']).toInt(),
    preventiveAction: data['preventive_action'] as String?,
    preventiveDate: _parseDate(data['preventive_date']),
    dateOccurred: _parseDate(r['date_occurred']),
    timeOccurred: data['time_occurred'] as String?,
    stolenValue: asNum(data['stolen_value']).toDouble(),
  );
}
