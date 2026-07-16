import 'package:drift/drift.dart';

/// Tables for the Investigating-Officer (IO) portal — a separate, field-first
/// workflow where the IO builds a "case" at the scene (घटनास्थळ), captures parties,
/// exhibits (मुद्देमाल) and media, and from that one dataset auto-generates the
/// crime-specific government forms (BNSS/BNS/BSA-2023 kit).
///
/// Design notes:
///  - Kept deliberately separate from the [Crimes] FIR schema. A case may LINK to
///    an existing FIR (via [IoCases.linkedCrimeUid]) or start fresh.
///  - Per-form field values are stored as a JSON map ([IoForms.valuesJson]) so the
///    ~30 pixel-exact forms can each carry their own field set without a column
///    explosion. Reusable, structured data (parties, exhibits) get real tables so
///    they can flow into MANY forms at once.
///  - Sensitive identifiers (Aadhaar/PAN) must be encrypted via FieldCipher before
///    being placed in any JSON blob here — never store them in cleartext.

/// One investigation case owned by an IO. The root all forms/parties hang off.
class IoCases extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Stable, globally-unique case id (`io_<random hex>`) used as the identity on
  /// the central server for phone↔PC sync. Generated once, never reused.
  TextColumn get remoteUid => text()();

  /// Display title (e.g. "गुन्हा रजि.नं 123/2026 — चोरी"). Optional; derived when blank.
  TextColumn get title => text().nullable()();

  /// Crime classification driving which forms apply. [crimeType] is the full
  /// "English / Marathi" label; [crimeCategory] is its parent category label.
  TextColumn get crimeType => text().nullable()();
  TextColumn get crimeCategory => text().nullable()();

  /// FIR identity (when known). A fresh case may leave these blank until filed.
  TextColumn get firNo => text().nullable()();
  IntColumn get year => integer().nullable()();
  TextColumn get district => text().nullable()();
  TextColumn get policeStation => text().nullable()();

  /// When the case was opened from an existing central FIR, its remote_uid — so
  /// the two stay associated. Null for a fresh (scene-first) case.
  TextColumn get linkedCrimeUid => text().nullable()();

  /// The IO who owns the case (Google account email). Used for "own cases only".
  TextColumn get ownerEmail => text().nullable()();

  /// active | closed.
  TextColumn get status => text().withDefault(const Constant('active'))();

  /// Case-level shared data (a JSON map) — every field the government forms need
  /// that isn't per-person / per-exhibit: FIR header extras, death/PM details,
  /// medical, DNA, juvenile, final-report, modus-operandi, etc. Entered once and
  /// read by all the auto-filled forms. Per-person deep fields live on the
  /// party's valuesJson; per-item fields on the exhibit's valuesJson.
  TextColumn get dataJson => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// A person tied to a case — entered ONCE and reused across every form that needs
/// them (panch/complainant/accused repeat on almost every page of the kit).
class IoParties extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get caseId =>
      integer().references(IoCases, #id, onDelete: KeyAction.cascade)();

  /// panch | complainant | accused | deceased | witness | io.
  TextColumn get role => text()();
  TextColumn get name => text()();

  /// Extra structured fields (father/husband, age, address, mobile, occupation,
  /// idType/idNumber, thumbPhotoPath, encrypted id blobs, …) as a JSON map.
  TextColumn get valuesJson => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// A seized item (मुद्देमाल). Entered once → feeds the seizure panchnama, property
/// receipt, mobile-seal label and the chargesheet property table.
class IoExhibits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get caseId =>
      integer().references(IoCases, #id, onDelete: KeyAction.cascade)();

  TextColumn get description => text()();

  /// Category (two-wheeler / four-wheeler / jewellery / mobile / cash / other) to
  /// drive specialised labels (e.g. mobile-seal form) and report bucketing.
  TextColumn get category => text().nullable()();
  TextColumn get seizedFrom => text().nullable()();
  TextColumn get exhibitNo => text().nullable()();
  RealColumn get value => real().nullable()();

  /// Extra fields (make/model, IMEI, colour, marks, sealNo, …) as a JSON map.
  TextColumn get valuesJson => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

/// One filled instance of a government form within a case. The auto-generated
/// pixel-exact output reads its data from [valuesJson] merged with the case's
/// parties/exhibits.
class IoForms extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get caseId =>
      integer().references(IoCases, #id, onDelete: KeyAction.cascade)();

  /// The form spec id (see io_forms_catalog.dart), e.g. 'scene_panchnama'.
  TextColumn get formId => text()();
  TextColumn get title => text().nullable()();

  /// field-id → value map for this form instance.
  TextColumn get valuesJson => text().nullable()();

  /// draft | complete.
  TextColumn get status => text().withDefault(const Constant('draft'))();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Captured media (photo / on-screen signature / voice note) with the scene
/// context (GPS + timestamp) that legal panchnamas require. Files live on disk;
/// only the path + metadata are stored (PROJECT.md rule 7).
class IoMedia extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get caseId =>
      integer().references(IoCases, #id, onDelete: KeyAction.cascade)();

  /// Optional form the media belongs to (null = case-level scene gallery).
  TextColumn get formId => text().nullable()();

  /// photo | signature | audio | video.
  TextColumn get kind => text()();
  TextColumn get filePath => text()();
  TextColumn get caption => text().nullable()();

  /// Scene GPS at capture time (from the device), for the panchnama's location.
  RealColumn get lat => real().nullable()();
  RealColumn get lng => real().nullable()();

  DateTimeColumn get capturedAt => dateTime().withDefault(currentDateAndTime)();
}
