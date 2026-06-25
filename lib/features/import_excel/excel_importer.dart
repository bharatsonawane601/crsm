import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../crime_entry/crime_repository.dart';
import '../crime_entry/models/crime_draft.dart';

/// Outcome of an Excel import run.
class ImportResult {
  ImportResult({
    required this.imported,
    required this.skipped,
    required this.failed,
    required this.errors,
  });

  final int imported;
  final int skipped;
  final int failed;
  final List<String> errors;
}

/// Imports old crime records from an .xlsx file. The first row is treated as
/// the header; columns are auto-mapped by their Marathi header text. Aadhaar /
/// PAN are encrypted on save (the repository handles that). Each data row
/// becomes a new crime record.
class ExcelImporter {
  ExcelImporter(this._repo);

  final CrimeRepository _repo;

  Future<ImportResult> import(Uint8List bytes) async {
    final Excel excel = Excel.decodeBytes(bytes);
    if (excel.tables.isEmpty) {
      return ImportResult(imported: 0, skipped: 0, failed: 0, errors: const []);
    }
    final sheet = excel.tables[excel.tables.keys.first]!;
    final rows = sheet.rows;
    if (rows.length < 2) {
      return ImportResult(imported: 0, skipped: 0, failed: 0, errors: const []);
    }

    // Map each column index to a setter by matching its header.
    final header = rows.first;
    final setters = <int, _Setter>{};
    for (var c = 0; c < header.length; c++) {
      final name = _norm(_string(header[c]?.value));
      final setter = _columnSetters[name];
      if (setter != null) setters[c] = setter;
    }

    var imported = 0;
    var skipped = 0;
    var failed = 0;
    final errors = <String>[];

    for (var r = 1; r < rows.length; r++) {
      final row = rows[r];
      if (_isBlankRow(row)) continue;

      try {
        final ctx = _RowCtx();
        for (final entry in setters.entries) {
          if (entry.key >= row.length) continue;
          entry.value(ctx, row[entry.key]?.value);
        }
        final draft = ctx.finalize();
        if (draft == null) {
          skipped++;
          continue;
        }
        await _repo.saveDraft(draft);
        imported++;
      } catch (e) {
        failed++;
        if (errors.length < 20) errors.add('Row ${r + 1}: $e');
      }
    }

    return ImportResult(
      imported: imported,
      skipped: skipped,
      failed: failed,
      errors: errors,
    );
  }

  static bool _isBlankRow(List<Data?> row) =>
      row.every((c) => _string(c?.value) == null);
}

typedef _Setter = void Function(_RowCtx ctx, CellValue? value);

/// Accumulates one spreadsheet row into a [CrimeDraft] plus its single
/// accused / stolen / recovered children.
class _RowCtx {
  final CrimeDraft draft = CrimeDraft(status: 'open');
  final AccusedDraft acc = AccusedDraft();
  final StolenItemDraft stolen = StolenItemDraft();
  final RecoveredItemDraft recovered = RecoveredItemDraft();

  CrimeDraft? finalize() {
    final hasCore = draft.firNo.trim().isNotEmpty ||
        draft.complainant.name.trim().isNotEmpty;
    if (!hasCore) return null;

    if (acc.name.trim().isNotEmpty ||
        (acc.aadhaar ?? '').isNotEmpty ||
        (acc.photoPath ?? '').isNotEmpty) {
      draft.accused.add(acc);
    }
    if ((stolen.type ?? '').isNotEmpty || (stolen.description ?? '').isNotEmpty) {
      draft.stolen.add(stolen);
    }
    if ((recovered.description ?? '').isNotEmpty) {
      draft.recovered.add(recovered);
    }
    return draft;
  }
}

// --- column → setter table -------------------------------------------------

final Map<String, _Setter> _columnSetters = {
  'जिल्हा/शहर': (c, v) => c.draft.district = _string(v),
  'पोलीस स्टेशन नाव': (c, v) => c.draft.policeStation = _string(v),
  'गुन्हयाचा प्रकार': (c, v) => c.draft.crimeType = _string(v),
  'गुन्हा नोंद क्रमांक': (c, v) => c.draft.firNo = _string(v) ?? '',
  'वर्ष': (c, v) => c.draft.year = _int(v),
  'कलम': (c, v) => c.draft.section = _string(v),
  'सहकलम': (c, v) => c.draft.subSection = _string(v),

  'फिर्यादी नाव': (c, v) => c.draft.complainant.name = _string(v) ?? '',
  'फिर्यादी लिंग': (c, v) => c.draft.complainant.gender = _gender(v),
  'फिर्यादी वय': (c, v) => c.draft.complainant.age = _int(v),
  'फिर्यादी पत्ता': (c, v) => c.draft.complainant.address = _string(v),
  'फिर्यादी मोबाईल': (c, v) => c.draft.complainant.mobile = _string(v),
  'फिर्यादी ईमेल': (c, v) => c.draft.complainant.email = _string(v),
  'फिर्यादी आधार': (c, v) => c.draft.complainant.aadhaar = _digits(_string(v)),
  'फिर्यादी पॅन': (c, v) => c.draft.complainant.pan = _string(v),
  'फिर्यादी पासपोर्ट': (c, v) => c.draft.complainant.passport = _string(v),

  'गुन्हा घडल्याची तारीख': (c, v) => c.draft.dateOccurred = _date(v),
  'गुन्हा घडला वेळ': (c, v) => c.draft.timeOccurred = _string(v),
  'गुन्हा ठिकाण': (c, v) => c.draft.placeOccurred = _string(v),
  'गुन्हा दाखल तारीख': (c, v) => c.draft.dateRegistered = _date(v),
  'गुन्हा दाखल तारिख': (c, v) => c.draft.dateRegistered = _date(v),
  'गुन्हा दाखल वेळ': (c, v) => c.draft.timeRegistered = _string(v),

  'तपास अधिकारी': (c, v) => c.draft.investigation.officerName = _string(v),
  'तपास अधिकारी क्र.': (c, v) => c.draft.investigation.officerId = _string(v),
  'तपास अधिकारी मोबाईल': (c, v) =>
      c.draft.investigation.officerMobile = _string(v),

  'चोरीस गेलेली मालमत्ता प्रकार': (c, v) => c.stolen.type = _string(v),
  'चोरी मालमत्ता': (c, v) => c.stolen.description = _string(v),

  'आरोपी नाव': (c, v) => c.acc.name = _string(v) ?? '',
  'आरोपी लिंग': (c, v) => c.acc.gender = _gender(v),
  'आरोपी वय': (c, v) => c.acc.age = _int(v),
  'आरोपी पत्ता': (c, v) => c.acc.address = _string(v),
  'आरोपी मोबाईल': (c, v) => c.acc.mobile = _string(v),
  'आरोपी ईमेल': (c, v) => c.acc.email = _string(v),
  'आरोपी आधार': (c, v) => c.acc.aadhaar = _digits(_string(v)),
  'आरोपी पॅन': (c, v) => c.acc.pan = _string(v),
  'आरोपी पासपोर्ट': (c, v) => c.acc.passport = _string(v),
  'आरोपी अटक केली अथवा नोटीस': (c, v) => c.acc.arrestStatus = _arrest(v),
  'आरोपी अटक तारीख': (c, v) => c.acc.arrestDate = _date(v),
  'आरोपी अटक वेळ': (c, v) => c.acc.arrestTime = _string(v),

  'जप्त मालमत्ता': (c, v) => c.recovered.description = _string(v),

  'प्रतिबंधक कारवाई': (c, v) =>
      c.draft.investigation.preventiveAction = _string(v),
  'प्रतिबंधक क्रमांक': (c, v) =>
      c.draft.investigation.preventiveNo = _string(v),
  'प्रतिबंधक तारीख': (c, v) =>
      c.draft.investigation.preventiveDate = _date(v),
  'पाहिजे आरोपी': (c, v) => c.draft.investigation.wantedAccused = _string(v),

  'चार्जशीट क्रमांक': (c, v) => c.draft.verdict.chargesheetNo = _string(v),
  'अंतिम आदेश': (c, v) => c.draft.verdict.finalOrder = _string(v),
  'चार्जशीट तारीख': (c, v) => c.draft.verdict.chargesheetDate = _date(v),
  'RCC क्रमांक': (c, v) => c.draft.verdict.rccNo = _string(v),
  'आरोपी दोषी': (c, v) => c.draft.verdict.foundGuilty = _bool(v),
  'शिक्षा': (c, v) => c.draft.verdict.punishment = _string(v),
  'आरोपी फोटो / Accused Photo': (c, v) => c.acc.photoPath = _string(v),
  'आरोपी फोटो': (c, v) => c.acc.photoPath = _string(v),
};

// --- value helpers ---------------------------------------------------------

String _norm(String? s) => (s ?? '').trim().replaceAll(RegExp(r'\s+'), ' ');

const _devToAsciiDigits = {
  '०': '0', '१': '1', '२': '2', '३': '3', '४': '4',
  '५': '5', '६': '6', '७': '7', '८': '8', '९': '9',
};

String? _digits(String? s) {
  if (s == null) return null;
  final b = StringBuffer();
  for (final ch in s.split('')) {
    b.write(_devToAsciiDigits[ch] ?? ch);
  }
  return b.toString();
}

String? _string(CellValue? v) {
  String? out;
  switch (v) {
    case null:
      out = null;
    case TextCellValue():
      out = v.value.text;
    case IntCellValue():
      out = v.value.toString();
    case DoubleCellValue():
      final d = v.value;
      out = d == d.roundToDouble() ? d.toInt().toString() : d.toString();
    case BoolCellValue():
      out = v.value ? 'true' : 'false';
    case DateCellValue():
      out = '${_two(v.day)}-${_two(v.month)}-${v.year}';
    case DateTimeCellValue():
      out = '${_two(v.day)}-${_two(v.month)}-${v.year}';
    case TimeCellValue():
      out = '${_two(v.hour)}:${_two(v.minute)}';
    case FormulaCellValue():
      out = v.formula;
  }
  final trimmed = out?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}

int? _int(CellValue? v) {
  if (v is IntCellValue) return v.value;
  if (v is DoubleCellValue) return v.value.toInt();
  final s = _digits(_string(v));
  if (s == null) return null;
  return int.tryParse(s.replaceAll(RegExp(r'[^0-9-]'), ''));
}

DateTime? _date(CellValue? v) {
  if (v is DateCellValue) return DateTime(v.year, v.month, v.day);
  if (v is DateTimeCellValue) {
    return DateTime(v.year, v.month, v.day, v.hour, v.minute);
  }
  if (v is IntCellValue) return _excelSerialDate(v.value.toDouble());
  if (v is DoubleCellValue) return _excelSerialDate(v.value);
  return _parseDateString(_digits(_string(v)));
}

DateTime _excelSerialDate(double serial) =>
    DateTime(1899, 12, 30).add(Duration(days: serial.round()));

DateTime? _parseDateString(String? s) {
  if (s == null) return null;
  final parts = s.split(RegExp(r'[-/.\s]+')).where((p) => p.isNotEmpty).toList();
  if (parts.length < 3) return null;
  try {
    int y, m, d;
    if (parts[0].length == 4) {
      y = int.parse(parts[0]);
      m = int.parse(parts[1]);
      d = int.parse(parts[2]);
    } else {
      d = int.parse(parts[0]);
      m = int.parse(parts[1]);
      y = int.parse(parts[2]);
      if (y < 100) y += 2000;
    }
    if (m < 1 || m > 12 || d < 1 || d > 31) return null;
    return DateTime(y, m, d);
  } catch (_) {
    return null;
  }
}

/// Maps free-text gender to the app's stored codes; unknown -> null so the
/// form's gender dropdown stays valid.
String? _gender(CellValue? v) {
  final s = _string(v)?.toLowerCase();
  if (s == null) return null;
  if (s.contains('पुरुष') || s.contains('male') || s == 'पु' || s == 'm') {
    return 'male';
  }
  if (s.contains('स्त्री') || s.contains('महिला') || s.contains('female') ||
      s == 'f') {
    return 'female';
  }
  return 'other';
}

/// Maps free-text arrest status to the app's codes; unknown -> null.
String? _arrest(CellValue? v) {
  final s = _string(v);
  if (s == null) return null;
  if (s.contains('अटक')) return 'arrested';
  if (s.contains('फरार') || s.contains('पसार')) return 'absconding';
  if (s.contains('जामीन') || s.contains('जामिन')) return 'onBail';
  return null;
}

bool? _bool(CellValue? v) {
  if (v is BoolCellValue) return v.value;
  final s = _string(v)?.toLowerCase();
  if (s == null) return null;
  if (s.contains('होय') ||
      s == 'हो' ||
      s == 'yes' ||
      s == 'true' ||
      s == '1' ||
      (s.contains('दोषी') && !s.contains('निर्दोष'))) {
    return true;
  }
  if (s.contains('नाही') || s.contains('निर्दोष') || s == 'no' ||
      s == 'false' || s == '0') {
    return false;
  }
  return null;
}

String _two(int n) => n.toString().padLeft(2, '0');

final excelImporterProvider = Provider<ExcelImporter>(
  (ref) => ExcelImporter(ref.watch(crimeRepositoryProvider)),
);
