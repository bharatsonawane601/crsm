import 'package:drift/drift.dart';

/// Core fixed tables for a crime/FIR record. Mirrors the schema in PROJECT.md.
/// All access goes through drift DAOs — never raw SQL (PROJECT.md rule 5).

class Crimes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get firNo => text()();
  IntColumn get year => integer()();
  TextColumn get section => text().nullable()();
  TextColumn get subSection => text().nullable()();
  IntColumn get stationId => integer().nullable()();
  TextColumn get district => text().nullable()();
  // Police station name carried on each record (per-user-Drive model has no
  // shared station table). Added in schema v2.
  TextColumn get policeStation => text().nullable()();
  DateTimeColumn get dateOccurred => dateTime().nullable()();
  // End of the date-of-offence window ("from {dateOccurred} to {dateOccurredTo}").
  // Added in schema v6. Nullable — a single-day offence leaves this blank.
  DateTimeColumn get dateOccurredTo => dateTime().nullable()();
  TextColumn get timeOccurred => text().nullable()();
  // End of the time-of-offence window ("from {timeOccurred} to {timeOccurredTo}").
  // Added in schema v4. Nullable — a single point-in-time leaves this blank.
  TextColumn get timeOccurredTo => text().nullable()();
  TextColumn get placeOccurred => text().nullable()();
  DateTimeColumn get dateRegistered => dateTime().nullable()();
  TextColumn get timeRegistered => text().nullable()();
  TextColumn get crimeType => text().nullable()();
  // Stable, globally-unique id used as the record's identity on the central
  // server (upload / deletion / suppression matching). Generated once at
  // creation ("c_<random hex>") and never reused — unlike the autoincrement
  // [id], which can repeat after a DB reset/reinstall and collide with the
  // server's permanent deletion list. Added in v8; legacy rows are backfilled
  // with their numeric id so already-uploaded records keep their identity.
  TextColumn get remoteUid => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('undetected'))();
  // Court handling the case, drives the chargesheet deadline. Added in v5.
  //   'sessions' → 90 days, 'jmfc' → 60 days from the registration date.
  TextColumn get courtType => text().nullable()();
  // Where the FIR currently stands: investigation | chargesheet | both | court
  // | disposed. Independent of [status] (detected/undetected). Added in v7.
  TextColumn get caseStage =>
      text().withDefault(const Constant('investigation'))();
  TextColumn get detailedDescription => text().nullable()();

  // --- Extra NCRB IIF-1 FIR fields (added in v9, all nullable) ---------------
  // "Date and Time of FIR" — when the FIR was filed (distinct from when the
  // offence occurred and from the registration timestamp).
  DateTimeColumn get firDate => dateTime().nullable()();
  TextColumn get firTime => text().nullable()();
  // "Information received at P.S." date/time.
  DateTimeColumn get infoReceivedDate => dateTime().nullable()();
  TextColumn get infoReceivedTime => text().nullable()();
  // General Diary reference: date/time + entry number.
  DateTimeColumn get gdDate => dateTime().nullable()();
  TextColumn get gdTime => text().nullable()();
  TextColumn get gdEntryNo => text().nullable()();
  // "Day" descriptor for the occurrence (e.g. "between days" / मधले दिवस).
  TextColumn get occurrenceDay => text().nullable()();
  // Written / oral (लेखी / तोंडी).
  TextColumn get typeOfInformation => text().nullable()();
  TextColumn get beatNo => text().nullable()();
  // Direction & distance of the place of occurrence from the police station.
  TextColumn get directionDistance => text().nullable()();
  // When the offence falls outside this PS's limits.
  TextColumn get outsidePsName => text().nullable()();
  TextColumn get outsidePsDistrict => text().nullable()();
  // Reason for delay in reporting + inquest / UD case number.
  TextColumn get delayReason => text().nullable()();
  TextColumn get inquestUdNo => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class Complainants extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get crimeId =>
      integer().references(Crimes, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get gender => text().nullable()();
  IntColumn get age => integer().nullable()();
  // Free-form age like "19.4" (19 years 4 months). [age] keeps the integer
  // part for analytics. Added in v5.
  TextColumn get ageText => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get mobile => text().nullable()();
  TextColumn get email => text().nullable()();
  // Encrypted at rest (AES-GCM) — store ciphertext, never plaintext.
  TextColumn get aadhaarEnc => text().nullable()();
  TextColumn get panEnc => text().nullable()();
  TextColumn get passport => text().nullable()();
  // --- Extra NCRB FIR complainant fields (added in v9, all nullable) --------
  TextColumn get fatherHusbandName => text().nullable()();
  IntColumn get birthYear => integer().nullable()();
  TextColumn get nationality => text().nullable()();
  TextColumn get occupation => text().nullable()();
  // Permanent address (the [address] column holds the present address).
  TextColumn get permanentAddress => text().nullable()();
  // Generic ID from the FIR's ID table (type + number), beyond Aadhaar/PAN.
  TextColumn get idType => text().nullable()();
  TextColumn get idNumber => text().nullable()();
}

class Accused extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get crimeId =>
      integer().references(Crimes, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get gender => text().nullable()();
  IntColumn get age => integer().nullable()();
  // Free-form age like "19.4" (19 years 4 months); see Complainants.ageText.
  TextColumn get ageText => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get mobile => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get aadhaarEnc => text().nullable()();
  TextColumn get panEnc => text().nullable()();
  TextColumn get passport => text().nullable()();
  TextColumn get arrestStatus => text().nullable()();
  DateTimeColumn get arrestDate => dateTime().nullable()();
  TextColumn get arrestTime => text().nullable()();
  // Photos stored as file paths, not blobs (PROJECT.md rule 7).
  TextColumn get photoPath => text().nullable()();
  // --- Extra NCRB FIR accused fields (added in v9, all nullable) ------------
  TextColumn get alias => text().nullable()();
  TextColumn get relativeName => text().nullable()();
  // Physical-description block (IIF-1 attachment to item 7): build, height,
  // complexion, identification marks, deformities, teeth, hair, eye, language,
  // etc. Stored as one JSON object to avoid ~20 sparse columns.
  TextColumn get physicalJson => text().nullable()();
}

class StolenProperty extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get crimeId =>
      integer().references(Crimes, #id, onDelete: KeyAction.cascade)();
  // Property category (वाहने आणि इतर / दागिने ...) — added in v9.
  TextColumn get category => text().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get description => text().nullable()();
  RealColumn get value => real().nullable()();
}

class RecoveredProperty extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get crimeId =>
      integer().references(Crimes, #id, onDelete: KeyAction.cascade)();
  TextColumn get description => text().nullable()();
  RealColumn get value => real().nullable()();
  DateTimeColumn get recoveryDate => dateTime().nullable()();
}

class Investigation extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get crimeId =>
      integer().references(Crimes, #id, onDelete: KeyAction.cascade)();
  TextColumn get officerName => text().nullable()();
  TextColumn get officerId => text().nullable()();
  TextColumn get officerDesignation => text().nullable()();
  TextColumn get officerMobile => text().nullable()();
  TextColumn get filedBy => text().nullable()();
  TextColumn get preventiveAction => text().nullable()();
  TextColumn get preventiveNo => text().nullable()();
  DateTimeColumn get preventiveDate => dateTime().nullable()();
  TextColumn get wantedAccused => text().nullable()();
  // --- Extra NCRB FIR registration/dispatch fields (added in v9) ------------
  // "Registered by" officer (distinct from the investigating officer above).
  TextColumn get registeringOfficerName => text().nullable()();
  TextColumn get registeringOfficerRank => text().nullable()();
  TextColumn get registeringOfficerNo => text().nullable()();
  // Action taken (item 13) + dispatch to court (item 15).
  TextColumn get actionTaken => text().nullable()();
  DateTimeColumn get courtDispatchDate => dateTime().nullable()();
  TextColumn get courtDispatchTime => text().nullable()();
}

class Verdict extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get crimeId =>
      integer().references(Crimes, #id, onDelete: KeyAction.cascade)();
  TextColumn get chargesheetNo => text().nullable()();
  DateTimeColumn get chargesheetDate => dateTime().nullable()();
  TextColumn get rccNo => text().nullable()();
  TextColumn get finalOrder => text().nullable()();
  BoolColumn get foundGuilty => boolean().nullable()();
  TextColumn get punishment => text().nullable()();
}

class Attachments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get crimeId =>
      integer().references(Crimes, #id, onDelete: KeyAction.cascade)();
  TextColumn get filePath => text()();
  TextColumn get fileType => text().nullable()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get uploadedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Extensibility (EAV pattern) — admin-added custom fields.
class CustomFields extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fieldNameMarathi => text()();
  TextColumn get fieldNameEnglish => text()();
  TextColumn get fieldType => text()(); // text, number, date, dropdown, ...
  TextColumn get section => text()();
  BoolColumn get isRequired => boolean().withDefault(const Constant(false))();
  TextColumn get dropdownOptionsJson => text().nullable()();
  IntColumn get displayOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class CustomFieldValues extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get crimeId =>
      integer().references(Crimes, #id, onDelete: KeyAction.cascade)();
  IntColumn get customFieldId =>
      integer().references(CustomFields, #id, onDelete: KeyAction.cascade)();
  TextColumn get value => text().nullable()();
}
