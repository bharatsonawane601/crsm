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
    this.ageText,
    this.address,
    this.mobile,
    this.email,
    this.aadhaar, // plaintext in memory; encrypted before persistence
    this.pan,
    this.passport,
    this.fatherHusbandName,
    this.birthYear,
    this.nationality,
    this.occupation,
    this.permanentAddress,
    this.idType,
    this.idNumber,
  });

  int? id;
  String name;
  String? gender;
  int? age;
  // Free-form age like "19.4" (19 years 4 months). [age] holds the integer part.
  String? ageText;
  String? address;
  String? mobile;
  String? email;
  String? aadhaar;
  String? pan;
  String? passport;
  // Extra NCRB FIR complainant fields.
  String? fatherHusbandName;
  int? birthYear;
  String? nationality;
  String? occupation;
  String? permanentAddress;
  String? idType;
  String? idNumber;
}

class AccusedDraft extends PersonDraft {
  AccusedDraft({
    super.id,
    super.name,
    super.gender,
    super.age,
    super.ageText,
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
    this.alias,
    this.relativeName,
    this.physical,
  });

  String? arrestStatus;
  DateTime? arrestDate;
  String? arrestTime;
  String? photoPath;
  // Extra NCRB FIR accused fields.
  String? alias;
  String? relativeName;
  // Physical-description block (build, height, complexion, ID marks, …),
  // persisted as a JSON object in accused.physical_json.
  Map<String, String>? physical;
}

class StolenItemDraft {
  StolenItemDraft(
      {this.id, this.category, this.type, this.description, this.value});

  int? id;
  String? category;
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
    this.officerDesignation,
    this.officerMobile,
    this.filedBy,
    this.preventiveAction,
    this.preventiveNo,
    this.preventiveDate,
    this.wantedAccused,
    this.registeringOfficerName,
    this.registeringOfficerRank,
    this.registeringOfficerNo,
    this.actionTaken,
    this.courtDispatchDate,
    this.courtDispatchTime,
  });

  int? id;
  String? officerName;
  String? officerId;
  String? officerDesignation;
  String? officerMobile;
  String? filedBy;
  String? preventiveAction;
  String? preventiveNo;
  DateTime? preventiveDate;
  String? wantedAccused;
  // Extra NCRB FIR registration / dispatch fields.
  String? registeringOfficerName;
  String? registeringOfficerRank;
  String? registeringOfficerNo;
  String? actionTaken;
  DateTime? courtDispatchDate;
  String? courtDispatchTime;
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
    this.investigationOutcome,
    this.statusDate,
    this.submittedDate,
    this.courtDate,
    this.approvalDate,
    this.remarks,
  });

  int? id;
  String? chargesheetNo;
  DateTime? chargesheetDate;
  String? rccNo;
  String? finalOrder;
  bool? foundGuilty;
  String? punishment;

  // Investigation outcome / final disposition of the case. One of the codes in
  // kInvestigationOutcomes (chargesheet, aFinal, bFinal, cFinal, hcFinal,
  // abated, pending) — null until the officer records the outcome.
  String? investigationOutcome;
  DateTime? statusDate;
  DateTime? submittedDate;
  DateTime? courtDate;
  DateTime? approvalDate;
  String? remarks;
}

/// The final-disposition statuses a case can be closed/marked with. Code →
/// label is localized (crime.verdict.outcomes.<code>). Order matches the paper
/// register: chargesheet, then the A/B/C/HC finals, abated, pending.
const List<String> kInvestigationOutcomes = [
  'chargesheet',
  'aFinal',
  'bFinal',
  'cFinal',
  'hcFinal',
  'abated',
  'pending',
];

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
    this.remoteUid,
    this.firNo = '',
    this.year,
    this.section,
    this.subSection,
    this.stationId,
    this.district,
    this.policeStation,
    this.dateOccurred,
    this.dateOccurredTo,
    this.timeOccurred,
    this.timeOccurredTo,
    this.placeOccurred,
    this.dateRegistered,
    this.timeRegistered,
    this.crimeType,
    this.status = 'undetected',
    this.courtType,
    this.caseStage = 'investigation',
    this.detailedDescription,
    this.firDate,
    this.firTime,
    this.infoReceivedDate,
    this.infoReceivedTime,
    this.gdDate,
    this.gdTime,
    this.gdEntryNo,
    this.occurrenceDay,
    this.typeOfInformation,
    this.beatNo,
    this.directionDistance,
    this.outsidePsName,
    this.outsidePsDistrict,
    this.delayReason,
    this.inquestUdNo,
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

  /// Stable central-server identity (see Crimes.remoteUid). Null for a brand-new
  /// draft; assigned once on first save.
  String? remoteUid;

  // Tab 1 — Crime info
  String firNo;
  int? year;
  String? section;
  String? subSection;
  int? stationId;
  String? district;
  String? policeStation;
  DateTime? dateOccurred;
  DateTime? dateOccurredTo;
  String? timeOccurred;
  String? timeOccurredTo;
  String? placeOccurred;
  DateTime? dateRegistered;
  String? timeRegistered;
  String? crimeType;
  String status;
  // 'sessions' (90-day chargesheet) | 'jmfc' (60-day) | null.
  String? courtType;
  // Where the FIR stands: investigation | chargesheet | both | court | disposed.
  String caseStage;
  String? detailedDescription;

  // Extra NCRB IIF-1 FIR fields.
  DateTime? firDate;
  String? firTime;
  DateTime? infoReceivedDate;
  String? infoReceivedTime;
  DateTime? gdDate;
  String? gdTime;
  String? gdEntryNo;
  String? occurrenceDay;
  String? typeOfInformation;
  String? beatNo;
  String? directionDistance;
  String? outsidePsName;
  String? outsidePsDistrict;
  String? delayReason;
  String? inquestUdNo;

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
