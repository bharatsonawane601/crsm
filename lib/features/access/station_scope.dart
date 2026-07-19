import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../crime_entry/data/bns_data.dart';
import 'access_service.dart';

/// The police station this user is pinned to by the admin, or null when they
/// may see everything (Tester / CP / DCP / ACP, or a station user with no
/// station assigned).
///
/// When set, the user is confined to that one station: Crime Records, Dashboard
/// and Analytics all filter to it, and new entries are filed under it
/// (the entry field is pinned read-only in the crime form).
final assignedStationProvider = Provider<String?>((ref) {
  final station = ref.watch(accessControllerProvider).scope.station;
  if (station == null || station.trim().isEmpty) return null;
  return station;
});

/// A comparable key for a station name: folds English/Marathi spellings,
/// case, spacing, punctuation, Devanagari digits and "police station" tails
/// onto one value, so "City Chowk", "city chowk" and "सिटी चौक पोलीस स्टेशन"
/// all match. Null for a blank name.
String? stationKey(String? raw) {
  final canon = canonicalStationName(raw);
  if (canon == null || canon.trim().isEmpty) return null;
  return canon.toLowerCase().replaceAll(RegExp(r'[\s.\-_,()]+'), '');
}

/// Whether [recordStation] belongs to [assigned]. A null [assigned] means the
/// user is unrestricted, so everything matches. Records with no station are
/// hidden from a station-scoped user — they belong to no station, so showing
/// them would leak rows the admin didn't grant.
bool stationInScope(String? recordStation, String? assigned) {
  if (assigned == null) return true;
  final want = stationKey(assigned);
  if (want == null) return true;
  return stationKey(recordStation) == want;
}
