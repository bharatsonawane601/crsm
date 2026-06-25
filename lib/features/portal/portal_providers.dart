import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analyzer/analytics_model.dart';
import '../auth/auth_service.dart';
import 'central_client.dart';

/// The signed-in officer's email (used to authorise every portal call).
final _officerEmailProvider = Provider<String?>((ref) {
  return ref.watch(authControllerProvider).value?.email;
});

/// The scope options this officer can drill into (All city / zone / division /
/// station depending on rank). The first option is the default (widest).
final portalScopeOptionsProvider =
    FutureProvider<List<PortalScopeOption>>((ref) async {
  final email = ref.watch(_officerEmailProvider);
  if (email == null) return const [];
  final client = CentralClient();
  ref.onDispose(client.dispose);
  return client.scopeOptions(email: email);
});

/// The currently selected scope (null = the default/widest). Search + dashboard
/// both narrow to this.
final selectedScopeProvider =
    NotifierProvider<SelectedScopeNotifier, PortalScopeOption?>(
        SelectedScopeNotifier.new);

class SelectedScopeNotifier extends Notifier<PortalScopeOption?> {
  @override
  PortalScopeOption? build() => null;
  void select(PortalScopeOption? s) => state = s;
}

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
  final scope = ref.watch(selectedScopeProvider);
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
  final scope = ref.watch(selectedScopeProvider);
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
    status: (r['status'] as String?) ?? 'open',
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
  );
}
