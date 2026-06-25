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
  TextColumn get timeOccurred => text().nullable()();
  TextColumn get placeOccurred => text().nullable()();
  DateTimeColumn get dateRegistered => dateTime().nullable()();
  TextColumn get timeRegistered => text().nullable()();
  TextColumn get crimeType => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('open'))();
  TextColumn get detailedDescription => text().nullable()();
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
  TextColumn get address => text().nullable()();
  TextColumn get mobile => text().nullable()();
  TextColumn get email => text().nullable()();
  // Encrypted at rest (AES-GCM) — store ciphertext, never plaintext.
  TextColumn get aadhaarEnc => text().nullable()();
  TextColumn get panEnc => text().nullable()();
  TextColumn get passport => text().nullable()();
}

class Accused extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get crimeId =>
      integer().references(Crimes, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get gender => text().nullable()();
  IntColumn get age => integer().nullable()();
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
}

class StolenProperty extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get crimeId =>
      integer().references(Crimes, #id, onDelete: KeyAction.cascade)();
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
  TextColumn get officerMobile => text().nullable()();
  TextColumn get filedBy => text().nullable()();
  TextColumn get preventiveAction => text().nullable()();
  TextColumn get preventiveNo => text().nullable()();
  DateTimeColumn get preventiveDate => dateTime().nullable()();
  TextColumn get wantedAccused => text().nullable()();
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
