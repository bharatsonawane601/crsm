import 'package:intl/intl.dart';

import '../../../data/db/database.dart';
import '../../brain/fuzzy.dart';

/// Fields the crime list free-text search can target. The user picks any
/// combination from a "Search in" multi-select; an empty selection means all.
enum CrimeSearchField { fir, crimeType, accused, victim, section, date }

final _searchDateFmt = DateFormat('dd-MM-yyyy');

/// A denormalized row for the crime list/search screen: the crime plus the
/// complainant name and accused names needed for display and free-text search.
class CrimeListItem {
  CrimeListItem({
    required this.crime,
    this.complainantName,
    this.accusedNames = const [],
  });

  final Crime crime;
  final String? complainantName;
  final List<String> accusedNames;

  int get id => crime.id;

  /// True if [query] is found in any of the selected [fields] (case-insensitive).
  /// An empty [fields] set searches every field. Text fields also match via the
  /// brain's transliteration key, so "chori" finds "चोरी" and "vahan cidco"
  /// typed either way still lands.
  bool matches(String query, {Set<CrimeSearchField> fields = const {}}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    final qk = brainKey(query);
    bool on(CrimeSearchField f) => fields.isEmpty || fields.contains(f);
    bool hit(String? s) {
      if (s == null || s.isEmpty) return false;
      if (s.toLowerCase().contains(q)) return true;
      return qk.length >= 2 && brainKey(s).contains(qk);
    }

    if (on(CrimeSearchField.fir) &&
        '${crime.firNo}/${crime.year}'.toLowerCase().contains(q)) {
      return true;
    }
    if (on(CrimeSearchField.crimeType) && hit(crime.crimeType)) return true;
    if (on(CrimeSearchField.victim) && hit(complainantName)) return true;
    if (on(CrimeSearchField.section) &&
        (crime.section ?? '').toLowerCase().contains(q)) {
      return true;
    }
    if (on(CrimeSearchField.accused) && accusedNames.any(hit)) {
      return true;
    }
    if (on(CrimeSearchField.date) && _dateMatches(q)) return true;
    return false;
  }

  bool _dateMatches(String q) {
    final candidates = <String>[
      if (crime.dateRegistered != null)
        _searchDateFmt.format(crime.dateRegistered!),
      if (crime.dateOccurred != null)
        _searchDateFmt.format(crime.dateOccurred!),
      '${crime.year}',
    ];
    return candidates.any((c) => c.toLowerCase().contains(q));
  }
}
