// In-memory, editable representation of a full crime/FIR record while the
// user fills the 7-tab entry form. Plain mutable Dart objects — the
// repository maps these to/from drift rows (encrypting Aadhaar/PAN on the way
// to the DB). Keeping the form model separate from drift rows means the UI
// never touches the ORM directly.

class PersonDraft {
  PersonDraft({
    this.id,
    this.name = '',
    this.gender,
    this.age,
    this.address,
    this.mobile,
    this.email,
    this.aadhaar, // plaintext in memory; encrypted before persistence
    this.pan,
    this.passport,
  });

  int? id;
  String name;
  String? gender;
  int? age;
  String? address;
  String? mobile;
  String? email;
  String? aadhaar;
  String? pan;
  String? passport;
}

class AccusedDraft extends PersonDraft {
  AccusedDraft({
    super.id,
    super.name,
    super.gender,
    super.age,
    super.address,
    super.mobile,
    super.email,
    super.aadhaar,
    super.pan,
    super.passport,
    this.arrestStatus,
    this.arrestDate,
    this.arrestTime,
    this.photoPath,
  });

  String? arrestStatus;
  DateTime? arrestDate;
  String? arrestTime;
  String? photoPath;
}

class StolenItemDraft {
  StolenItemDraft({this.id, this.type, this.description, this.value});

  int? id;
  String? type;
  String? description;
  double? value;
}

class RecoveredItemDraft {
  RecoveredItemDraft({this.id, this.description, this.value, this.recoveryDate});

  int? id;
  String? description;
  double? value;
  DateTime? recoveryDate;
}

class InvestigationDraft {
  InvestigationDraft({
    this.id,
    this.officerName,
    this.officerId,
    this.officerMobile,
    this.filedBy,
    this.preventiveAction,
    this.preventiveNo,
    this.preventiveDate,
    this.wantedAccused,
  });

  int? id;
  String? officerName;
  String? officerId;
  String? officerMobile;
  String? filedBy;
  String? preventiveAction;
  String? preventiveNo;
  DateTime? preventiveDate;
  String? wantedAccused;
}

class VerdictDraft {
  VerdictDraft({
    this.id,
    this.chargesheetNo,
    this.chargesheetDate,
    this.rccNo,
    this.finalOrder,
    this.foundGuilty,
    this.punishment,
  });

  int? id;
  String? chargesheetNo;
  DateTime? chargesheetDate;
  String? rccNo;
  String? finalOrder;
  bool? foundGuilty;
  String? punishment;
}

class AttachmentDraft {
  AttachmentDraft({this.id, this.filePath = '', this.fileType, this.description});

  int? id;
  String filePath;
  String? fileType;
  String? description;
}

/// The whole record being edited.
class CrimeDraft {
  CrimeDraft({
    this.id,
    this.firNo = '',
    this.year,
    this.section,
    this.subSection,
    this.stationId,
    this.district,
    this.policeStation,
    this.dateOccurred,
    this.timeOccurred,
    this.placeOccurred,
    this.dateRegistered,
    this.timeRegistered,
    this.crimeType,
    this.status = 'open',
    this.detailedDescription,
    PersonDraft? complainant,
    InvestigationDraft? investigation,
    VerdictDraft? verdict,
    List<AccusedDraft>? accused,
    List<StolenItemDraft>? stolen,
    List<RecoveredItemDraft>? recovered,
    List<AttachmentDraft>? attachments,
    Map<int, String?>? customValues,
  })  : complainant = complainant ?? PersonDraft(),
        investigation = investigation ?? InvestigationDraft(),
        verdict = verdict ?? VerdictDraft(),
        accused = accused ?? <AccusedDraft>[],
        stolen = stolen ?? <StolenItemDraft>[],
        recovered = recovered ?? <RecoveredItemDraft>[],
        attachments = attachments ?? <AttachmentDraft>[],
        customValues = customValues ?? <int, String?>{};

  int? id;

  // Tab 1 — Crime info
  String firNo;
  int? year;
  String? section;
  String? subSection;
  int? stationId;
  String? district;
  String? policeStation;
  DateTime? dateOccurred;
  String? timeOccurred;
  String? placeOccurred;
  DateTime? dateRegistered;
  String? timeRegistered;
  String? crimeType;
  String status;
  String? detailedDescription;

  // Tab 2 — Complainant
  PersonDraft complainant;

  // Tab 3 — Accused (multiple)
  List<AccusedDraft> accused;

  // Tab 4 — Property (multiple, stolen + recovered)
  List<StolenItemDraft> stolen;
  List<RecoveredItemDraft> recovered;

  // Tab 5 — Investigation
  InvestigationDraft investigation;

  // Tab 6 — Verdict
  VerdictDraft verdict;

  // Tab 7 — Attachments
  List<AttachmentDraft> attachments;

  /// Admin-defined custom field values, keyed by custom_fields.id.
  Map<int, String?> customValues;

  bool get isNew => id == null;
}
