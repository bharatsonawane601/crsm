import 'package:flutter/foundation.dart';

import 'crime_repository.dart';
import 'models/crime_draft.dart';

/// Holds the editable [CrimeDraft] for the 7-tab form and notifies the UI on
/// change. Framework-agnostic (a plain [ChangeNotifier]) so it's trivial to
/// unit-test; the screen creates one per entry session and saves through
/// [CrimeRepository].
class CrimeFormModel extends ChangeNotifier {
  CrimeFormModel(this._repo, {CrimeDraft? draft})
      : draft = draft ?? CrimeDraft(year: DateTime.now().year);

  final CrimeRepository _repo;

  CrimeDraft draft;
  bool _saving = false;
  bool get saving => _saving;

  /// Loads an existing crime for editing. Returns false if not found.
  Future<bool> load(int crimeId) async {
    final loaded = await _repo.loadDraft(crimeId);
    if (loaded == null) return false;
    draft = loaded;
    notifyListeners();
    return true;
  }

  /// Mutate the draft in place, then rebuild listeners.
  void edit(void Function(CrimeDraft d) mutate) {
    mutate(draft);
    notifyListeners();
  }

  /// Rebuild listeners after the draft was mutated directly (e.g. a dropdown).
  void refresh() => notifyListeners();

  // --- dynamic rows -------------------------------------------------------

  void addAccused() => edit((d) => d.accused.add(AccusedDraft()));
  void removeAccused(int i) => edit((d) => d.accused.removeAt(i));

  void addStolen() => edit((d) => d.stolen.add(StolenItemDraft()));
  void removeStolen(int i) => edit((d) => d.stolen.removeAt(i));

  void addRecovered() => edit((d) => d.recovered.add(RecoveredItemDraft()));
  void removeRecovered(int i) => edit((d) => d.recovered.removeAt(i));

  void addAttachment() => edit((d) => d.attachments.add(AttachmentDraft()));
  void removeAttachment(int i) => edit((d) => d.attachments.removeAt(i));

  // --- persistence --------------------------------------------------------

  /// Saves the draft and returns the crime id. Rethrows on failure.
  Future<int> save() async {
    _saving = true;
    notifyListeners();
    try {
      final id = await _repo.saveDraft(draft);
      draft.id = id;
      return id;
    } finally {
      _saving = false;
      notifyListeners();
    }
  }
}
