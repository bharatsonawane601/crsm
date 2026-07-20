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

/// Every normalised key the assigned station answers to (English, Marathi and
/// the admin's alias/code, as sent by the server), or null when the user is
/// unrestricted.
///
/// Matching MUST use the server's alias list, not just the app's built-in
/// station names: an admin can name a station anything and add their own
/// aliases, and records are filed under whichever spelling was typed. Relying
/// on the built-in list alone hid a station's own records — e.g. FIRs filed as
/// "एम.वाळूज" were invisible to the user assigned "MIDC Waluj".
/// The server sends one flat alias list covering EVERY station the account may
/// see — one station for a station user, all of a zone's stations for zone
/// office staff — so this single filter serves both roles unchanged.
final assignedStationKeysProvider = Provider<Set<String>?>((ref) {
  final scope = ref.watch(accessControllerProvider).scope;
  final names = <String>[
    ...scope.stationAliases,
    if (scope.station != null) scope.station!,
  ];
  final keys = <String>{
    for (final alias in names)
      if (stationKey(alias) != null) stationKey(alias)!,
  };
  return keys.isEmpty ? null : keys;
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

/// Whether [recordStation] belongs to the assigned station. A null [keys] means
/// the user is unrestricted, so everything matches.
///
/// A record with NO station is shown to a station-scoped user: an unfiled
/// record is work-in-progress on their own machine, and the server stamps it
/// with their station on upload anyway — hiding it would make their own
/// half-entered FIRs vanish.
bool stationInScope(String? recordStation, Set<String>? keys) {
  if (keys == null || keys.isEmpty) return true;
  final key = stationKey(recordStation);
  if (key == null) return true; // unfiled record — belongs to whoever holds it
  return keys.contains(key);
}
