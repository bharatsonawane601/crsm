import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../access/station_scope.dart';
import '../crime_entry/crime_repository.dart';
import 'models/crime_list_item.dart';

/// Live stream of all crimes for the list/search screen. Filtering and search
/// are applied in-memory in the screen (station-scale data) so the underlying
/// stream stays simple and reactive.
///
/// A user pinned to one police station only ever sees that station's records —
/// the same rule the Dashboard and Analytics use, so all three agree.
final crimeListProvider = StreamProvider<List<CrimeListItem>>((ref) {
  final assigned = ref.watch(assignedStationProvider);
  final stream = ref.watch(crimeRepositoryProvider).watchCrimeList();
  if (assigned == null) return stream;
  return stream.map((items) => [
        for (final item in items)
          if (stationInScope(item.crime.policeStation, assigned)) item,
      ]);
});

/// Global crime search query — driven by the top-bar search field, read by the
/// crime list. Lives in a provider so the shell top bar and the section can
/// share it.
class CrimeSearchController extends Notifier<String> {
  @override
  String build() => '';
  void set(String value) => state = value;
}

final crimeSearchProvider =
    NotifierProvider<CrimeSearchController, String>(CrimeSearchController.new);
