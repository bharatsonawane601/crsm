import 'package:drift/drift.dart';

/// Users, stations, report templates and audit log.

class Stations extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get nameMarathi => text()();
  TextColumn get nameEnglish => text()();
  TextColumn get code => text().nullable()();
  TextColumn get district => text().nullable()();
  TextColumn get address => text().nullable()();
}

class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  // Google sign-in: email is the login identity.
  TextColumn get email => text().unique()();
  TextColumn get fullName => text().nullable()();
  // admin | station_head | officer | data_entry
  TextColumn get role => text().withDefault(const Constant('officer'))();
  IntColumn get stationId => integer().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('ReportTemplateRow')
class ReportTemplates extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get templateJson => text()();
  TextColumn get outputFormat =>
      text().withDefault(const Constant('docx'))(); // docx | pdf
  BoolColumn get isSystem => boolean().withDefault(const Constant(false))();
  TextColumn get createdBy => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt =>
      dateTime().withDefault(currentDateAndTime)();
}

class AuditLog extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().nullable()();
  TextColumn get action => text()();
  TextColumn get entityType => text().nullable()();
  IntColumn get entityId => integer().nullable()();
  TextColumn get changesJson => text().nullable()();
  DateTimeColumn get timestamp =>
      dateTime().withDefault(currentDateAndTime)();
}
