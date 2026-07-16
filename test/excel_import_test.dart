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

  // --- Station crime-register format (7 columns) ---------------------------
  // गु.रं | पोलीस स्टेशन | वर्ष | कायदा | कलम | उघड/न उघड | दाखल तारीख

  Uint8List buildRegisterXlsx() {
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];

    const headers = [
      'गु.रं',
      'पोलीस स्टेशन',
      'वर्ष',
      'कायदा',
      'कलम',
      'उघड/न उघड',
      'दाखल तारीख',
    ];
    sheet.appendRow([for (final h in headers) TextCellValue(h)]);

    // Row exactly like the register: multi-section कलम with commas, न उघड.
    sheet.appendRow([
      IntCellValue(1),
      TextCellValue('एम.वाळूज'),
      IntCellValue(2026),
      TextCellValue('BNS'),
      TextCellValue('309(4),3(5)'),
      TextCellValue('न उघड'),
      TextCellValue('1/1/2026'),
    ]);
    // उघड row with a different act and a single section.
    sheet.appendRow([
      IntCellValue(2),
      TextCellValue('एम.वाळूज'),
      IntCellValue(2026),
      TextCellValue('मपोका'),
      TextCellValue('122'),
      TextCellValue('उघड'),
      TextCellValue('2/1/2026'),
    ]);
    // Long comma list with Marathi tail text — must be stored as-is.
    sheet.appendRow([
      IntCellValue(9),
      TextCellValue('एम.वाळूज'),
      IntCellValue(2026),
      TextCellValue('BNS'),
      TextCellValue('85,86,352,115(2) स.क.3,4,हंडा बंदि अधि.'),
      TextCellValue('उघड'),
      TextCellValue('3/1/2026'),
    ]);

    return Uint8List.fromList(excel.encode()!);
  }

  test('imports the 7-column station register format', () async {
    final result = await importer.import(buildRegisterXlsx());

    expect(result.imported, 3);
    expect(result.failed, 0);

    final list = await repo.watchCrimeList().first;
    expect(list, hasLength(3));

    final drafts = <String, dynamic>{};
    for (final item in list) {
      final d = (await repo.loadDraft(item.id))!;
      drafts[d.firNo] = d;
    }

    final one = drafts['1']!;
    expect(one.policeStation, 'एम.वाळूज');
    expect(one.year, 2026);
    // कायदा prefixed onto the comma-separated कलम, text kept as-is.
    expect(one.section, 'BNS 309(4),3(5)');
    expect(one.status, 'undetected', reason: 'न उघड');
    // d/M/yyyy register date -> date registered.
    expect(one.dateRegistered, DateTime(2026, 1, 1));

    final two = drafts['2']!;
    expect(two.section, 'मपोका 122');
    expect(two.status, 'detected', reason: 'उघड');
    expect(two.dateRegistered, DateTime(2026, 1, 2));

    final nine = drafts['9']!;
    expect(nine.section, 'BNS 85,86,352,115(2) स.क.3,4,हंडा बंदि अधि.');
    expect(nine.status, 'detected');
  });

  test('imports from EVERY sheet, not just the first', () async {
    final excel = Excel.createExcel();
    // Sheet 1 (default) — station एम.वाळूज.
    final s1 = excel[excel.getDefaultSheet()!];
    for (final r in [
      ['गु.रं', 'पोलीस स्टेशन', 'वर्ष', 'कायदा', 'कलम'],
      ['1', 'एम.वाळूज', '2026', 'BNS', '309(4)'],
      ['2', 'एम.वाळूज', '2026', 'BNS', '324'],
    ]) {
      s1.appendRow([for (final c in r) TextCellValue(c)]);
    }
    // Sheet 2 — station सिटीचौक. Must ALSO be imported.
    final s2 = excel['सिटीचौक'];
    for (final r in [
      ['गु.रं', 'पोलीस स्टेशन', 'वर्ष', 'कायदा', 'कलम'],
      ['131', 'सिटीचौक', '2026', 'BNS', '318(4)'],
      ['132', 'सिटीचौक', '2026', 'BNS', '303(2)'],
    ]) {
      s2.appendRow([for (final c in r) TextCellValue(c)]);
    }

    final result = await importer.import(Uint8List.fromList(excel.encode()!));
    expect(result.imported, 4, reason: 'both sheets, 2 rows each');

    final list = await repo.watchCrimeList().first;
    final stations = <String?>{};
    final sections = <String, String?>{};
    for (final item in list) {
      final d = (await repo.loadDraft(item.id))!;
      stations.add(d.policeStation);
      sections[d.firNo] = d.section;
    }
    // Second sheet's station came through — canonicalized to the app's
    // English spelling (सिटीचौक -> City Chowk); unknown names pass through.
    expect(stations, containsAll(['एम.वाळूज', 'City Chowk']));
    // Section = कायदा + कलम for a row from each sheet.
    expect(sections['131'], 'BNS 318(4)');
    expect(sections['1'], 'BNS 309(4)');
  });

  test('fuzzy header match: variant spellings still map', () async {
    final excel = Excel.createExcel();
    final s = excel[excel.getDefaultSheet()!];
    // Deliberately "off" headers that are NOT in the exact table, so the
    // keyword fallback must resolve them (separate कायदा + कलम columns).
    for (final r in [
      ['गुन्हा रजिस्टर नं', 'पो.ठाणे', 'कायदा प्रकार', 'कलमे', 'उघड अथवा न उघड'],
      ['50', 'सिटीचौक', 'BNS', '309(4),3(5)', 'न उघड'],
    ]) {
      s.appendRow([for (final c in r) TextCellValue(c)]);
    }
    final result = await importer.import(Uint8List.fromList(excel.encode()!));
    expect(result.imported, 1);
    final d = (await repo.loadDraft(
        (await repo.watchCrimeList().first).single.id))!;
    expect(d.firNo, '50');
    // Station canonicalized to the app's one spelling per station.
    expect(d.policeStation, 'City Chowk');
    expect(d.section, 'BNS 309(4),3(5)');
    expect(d.status, 'undetected');
  });

  test('old-format कलम (no कायदा column) is unchanged by the combiner',
      () async {
    await importer.import(buildXlsx());
    // buildXlsx has no कलम column at all -> section must stay null.
    final id = (await repo.watchCrimeList().first).single.id;
    final d = (await repo.loadDraft(id))!;
    expect(d.section, anyOf(isNull, isEmpty));
  });
}
