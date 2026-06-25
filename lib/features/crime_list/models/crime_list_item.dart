import 'package:intl/intl.dart';

import '../../../data/db/database.dart';

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
  /// An empty [fields] set searches every field.
  bool matches(String query, {Set<CrimeSearchField> fields = const {}}) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    bool on(CrimeSearchField f) => fields.isEmpty || fields.contains(f);

    if (on(CrimeSearchField.fir) &&
        '${crime.firNo}/${crime.year}'.toLowerCase().contains(q)) {
      return true;
    }
    if (on(CrimeSearchField.crimeType) &&
        (crime.crimeType ?? '').toLowerCase().contains(q)) {
      return true;
    }
    if (on(CrimeSearchField.victim) &&
        (complainantName ?? '').toLowerCase().contains(q)) {
      return true;
    }
    if (on(CrimeSearchField.section) &&
        (crime.section ?? '').toLowerCase().contains(q)) {
      return true;
    }
    if (on(CrimeSearchField.accused) &&
        accusedNames.any((n) => n.toLowerCase().contains(q))) {
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
