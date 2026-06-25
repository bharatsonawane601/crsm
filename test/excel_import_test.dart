import 'dart:typed_data';

import 'package:drift/native.dart';
import 'package:excel/excel.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crms/core/crypto/field_cipher.dart';
import 'package:crms/data/db/database.dart';
import 'package:crms/features/crime_entry/crime_repository.dart';
import 'package:crms/features/import_excel/excel_importer.dart';

void main() {
  late AppDatabase db;
  late CrimeRepository repo;
  late ExcelImporter importer;
  final cipher = FieldCipher.fromBytes(List<int>.generate(32, (i) => i));

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = CrimeRepository(db, cipher);
    importer = ExcelImporter(repo);
  });
  tearDown(() => db.close());

  Uint8List buildXlsx() {
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];

    const headers = [
      'जिल्हा/शहर',
      'पोलीस स्टेशन नाव',
      'गुन्हा नोंद क्रमांक',
      'वर्ष',
      'फिर्यादी नाव',
      'फिर्यादी लिंग',
      'फिर्यादी आधार',
      'गुन्हा दाखल तारीख',
      'आरोपी नाव',
      'आरोपी दोषी',
    ];
    sheet.appendRow([for (final h in headers) TextCellValue(h)]);

    // Devanagari digits in year + aadhaar; a date string; Marathi gender/bool.
    sheet.appendRow([
      TextCellValue('पुणे'),
      TextCellValue('कोथरूड'),
      TextCellValue('123/2026'),
      TextCellValue('२०२६'),
      TextCellValue('रमेश पाटील'),
      TextCellValue('पुरुष'),
      TextCellValue('१२३४५६७८९०१२'),
      TextCellValue('15-03-2026'),
      TextCellValue('सुरेश'),
      TextCellValue('होय'),
    ]);

    // A blank-ish row (no FIR / complainant) should be skipped.
    sheet.appendRow([TextCellValue('पुणे'), TextCellValue('')]);

    final bytes = excel.encode();
    return Uint8List.fromList(bytes!);
  }

  test('imports an .xlsx, mapping headers and normalizing values', () async {
    final result = await importer.import(buildXlsx());

    expect(result.imported, 1);
    expect(result.skipped, 1, reason: 'blank row has no FIR/complainant');
    expect(result.failed, 0);

    final list = await repo.watchCrimeList().first;
    expect(list, hasLength(1));

    final draft = await repo.loadDraft(list.single.id);
    expect(draft, isNotNull);
    expect(draft!.firNo, '123/2026');
    expect(draft.district, 'पुणे');
    expect(draft.policeStation, 'कोथरूड');
    // Devanagari digits normalized to ASCII.
    expect(draft.year, 2026);
    expect(draft.complainant.name, 'रमेश पाटील');
    expect(draft.complainant.gender, 'male');
    expect(draft.complainant.aadhaar, '123456789012');
    // Date string parsed.
    expect(draft.dateRegistered, DateTime(2026, 3, 15));
    // Accused mapped.
    expect(draft.accused.single.name, 'सुरेश');
    // Marathi "होय" -> true.
    expect(draft.verdict.foundGuilty, isTrue);
  });

  test('Aadhaar from Excel is stored encrypted', () async {
    await importer.import(buildXlsx());
    final id = (await repo.watchCrimeList().first).single.id;
    final row = await (db.select(db.complainants)
          ..where((t) => t.crimeId.equals(id)))
        .getSingle();
    expect(row.aadhaarEnc, isNot(contains('123456789012')));
    expect(cipher.decryptField(row.aadhaarEnc), '123456789012');
  });
}
