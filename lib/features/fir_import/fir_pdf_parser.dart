import '../crime_entry/models/crime_draft.dart';

/// Parses the raw text extracted from an NCRB IIF-1 FIR PDF into a [CrimeDraft].
///
/// The PDF's Marathi text layer uses a legacy/garbled encoding, but the
/// **English field labels** and all **Latin/numeric values** (FIR no, dates,
/// times, sections, vehicle reg, mobile, IDs, officer numbers) extract cleanly.
/// We anchor on the English labels and pull the value that sits **after the
/// colon on that same label line** — so a blank field stays blank instead of
/// bleeding into the next field. Marathi names/addresses are captured
/// best-effort (still readable Devanagari) for the officer to verify/fix.
///
/// Pure & deterministic so it can be unit-tested without a real PDF.
CrimeDraft parseFirText(String raw) {
  final text = raw.replaceAll('\r', '\n');
  final d = CrimeDraft(year: DateTime.now().year);

  String? grab(String pattern, {int group = 1}) {
    final m = RegExp(pattern, caseSensitive: false, dotAll: true).firstMatch(text);
    if (m == null) return null;
    final v = m.group(group)?.trim();
    return (v == null || v.isEmpty) ? null : v;
  }

  // dd/MM/yyyy -> DateTime.
  DateTime? date(String? s) {
    if (s == null) return null;
    final m = RegExp(r'(\d{1,2})/(\d{1,2})/(\d{4})').firstMatch(s);
    if (m == null) return null;
    final day = int.tryParse(m.group(1)!);
    final mon = int.tryParse(m.group(2)!);
    final yr = int.tryParse(m.group(3)!);
    if (day == null || mon == null || yr == null) return null;
    if (mon < 1 || mon > 12 || day < 1 || day > 31) return null;
    return DateTime(yr, mon, day);
  }

  // The value that sits AFTER the colon on the SAME line as an English label.
  //
  //   Label  (<garbled marathi>) :  <value up to end of line>
  //
  // The "(…)" parenthetical may itself wrap across one line (NCRB does this),
  // so `[^)]` (which also matches newlines) is bounded to 90 chars. Crucially,
  // the value `([^\\t-\\uFFFF\\n]…)` excludes newlines: if the field is empty,
  // there is nothing on the colon's line and the whole match fails -> null,
  // instead of greedily grabbing the next label's line.
  String? line(String label) =>
      grab('$label\\s*\\([^)]{0,90}\\)[ \\t]*:[ \\t]*([^\\n]+)');

  // Same as [line] but only keep a leading run of digits (for "Beat No.: 1.").
  String? lineDigits(String label) =>
      grab('$label\\s*\\([^)]{0,90}\\)[ \\t]*:[ \\t]*([0-9]+)');

  // A looser label anchor used for date/time/number tokens that often sit on
  // the NEXT line under the label. The token shape (date/time/digits) makes
  // crossing the newline safe — we are not grabbing "the rest of a line".
  String lbl(String english) => '$english[^):\\n]*\\)?\\s*:?\\s*';

  // --- FIR header ----------------------------------------------------------
  d.firNo = grab('${lbl("FIR No\\.")}([0-9]{1,8})') ?? d.firNo;
  final yr = grab('${lbl("Year")}((?:19|20)\\d{2})');
  if (yr != null) d.year = int.tryParse(yr);
  // District / Police station — value after the colon on the same line.
  d.district = line('District');
  d.policeStation = line('P\\.S\\.');

  final firDt = grab('Date and Time of FIR[^:\\n]*\\)?\\s*:?\\s*'
      '(\\d{1,2}/\\d{1,2}/\\d{4})');
  d.firDate = date(firDt);
  d.firTime = grab('Date and Time of FIR[^:\\n]*\\)?\\s*:?\\s*'
      '\\d{1,2}/\\d{1,2}/\\d{4}\\s*([0-9]{1,2}:[0-9]{2})');

  // Sections / Acts — the section number (e.g. 303(2)) is Latin & reliable.
  final sec = grab(r'\b(\d{2,3}\(\d+\)(?:\s*[, ]\s*\d{2,3}(?:\(\d+\))?)*)');
  if (sec != null) {
    // Tag with the Act short code when the Bharatiya Nyaya Sanhita is named.
    final isBns = RegExp(r'BNS|Bharatiya Nyaya|न्याय संहिता|Ûयाय संदहता',
            caseSensitive: false)
        .hasMatch(text);
    d.section = isBns ? 'BNS $sec' : sec;
  }

  // --- Occurrence ----------------------------------------------------------
  d.occurrenceDay = grab('${lbl("Day")}([^\\n]+?)\\s*Date');
  d.dateOccurred = date(grab('${lbl("Date from")}(\\d{1,2}/\\d{1,2}/\\d{4})'));
  d.dateOccurredTo = date(grab('${lbl("Date To")}(\\d{1,2}/\\d{1,2}/\\d{4})'));
  d.timeOccurred = grab('${lbl("Time From")}([0-9]{1,2}:[0-9]{2})');
  d.timeOccurredTo = grab('${lbl("Time To")}([0-9]{1,2}:[0-9]{2})');

  // Information received at P.S. (date then time).
  d.infoReceivedDate = date(grab(
      'Information received at P\\.S\\.[\\s\\S]{0,200}?(\\d{1,2}/\\d{1,2}/\\d{4})'));
  d.infoReceivedTime = grab(
      'Information received at P\\.S\\.[\\s\\S]{0,240}?([0-9]{1,2}:[0-9]{2})');

  // General Diary reference.
  d.gdDate = date(grab(
      'General Diary[\\s\\S]{0,200}?(\\d{1,2}/\\d{1,2}/\\d{4})'));
  d.gdTime = grab('General Diary[\\s\\S]{0,240}?([0-9]{1,2}:[0-9]{2})');
  d.gdEntryNo = grab('${lbl("Entry No\\.")}([0-9]+)');

  d.typeOfInformation = line('Type of Information');
  d.beatNo = lineDigits('Beat No\\.');
  d.directionDistance =
      grab('Direction and distance from P\\.S\\.[\\s\\S]{0,120}?:[ \\t]*([^\\n]+)');
  // Place of occurrence — the "(b) Address" line under item 5.
  d.placeOccurred = line(r'\(b\)\s*Address');

  // --- Complainant (item 6) ------------------------------------------------
  // "(a) Name" anchors the complainant, distinct from the I.O./registering
  // officer "Name" fields further down.
  d.complainant.name = line(r'\(a\)\s*Name') ?? d.complainant.name;
  d.complainant.fatherHusbandName = line(r"Father's/Husband's Name");
  final birth = grab('Date/Year of Birth[\\s\\S]{0,80}?((?:19|20)\\d{2})');
  if (birth != null) d.complainant.birthYear = int.tryParse(birth);
  d.complainant.nationality = line('Nationality');
  d.complainant.occupation = line('Occupation');
  final mobile = grab(r'Mobile[^):\n]*\)?\s*:?\s*([0-9][0-9\-+ ]{7,})');
  if (mobile != null) {
    // Keep the last 10 digits as the canonical mobile number.
    final digits = mobile.replaceAll(RegExp(r'\D'), '');
    d.complainant.mobile =
        digits.length >= 10 ? digits.substring(digits.length - 10) : digits;
  }
  // Present / permanent address rows from the item-6 address table
  // ("1 <type> पता <address>" / "2 <type> पता <address>"). Best-effort.
  d.complainant.address =
      grab(r'\n[ \t]*1\s+[^\n]*?पता[ \t]+([^\n]+)');
  d.complainant.permanentAddress =
      grab(r'\n[ \t]*2\s+[^\n]*?पता[ \t]+([^\n]+)');

  // --- Property ------------------------------------------------------------
  final total = grab(r'Total value of property[\s\S]{0,80}?([0-9][0-9,]*(?:\.\d+)?)');
  final vehicle = grab(r'\b([A-Z]{2}\s?\d{1,2}\s?[A-Z]{1,2}\s?\d{3,4})\b');
  if (total != null || vehicle != null) {
    d.stolen.add(StolenItemDraft(
      description: vehicle,
      value: total == null
          ? null
          : double.tryParse(total.replaceAll(',', '')),
    ));
  }

  // --- Investigation -------------------------------------------------------
  // Investigating officer — anchored to the "Directed (Name of I.O.)" block so
  // we don't accidentally pick up the FIR number or registering officer.
  d.investigation.officerName = grab(
      r'Directed\s*\(Name of I\.O\.\)[\s\S]{0,90}?\)[ \t]*:[ \t\n]*([A-Za-z][A-Za-z .]+)');
  d.investigation.officerId = grab(
      r'Directed[\s\S]{0,220}?No\.\s*\([^)]{0,40}\)\s*:[ \t\n]*([0-9]{2,6})');
  // Registering officer (item 14 "Registered by" block).
  d.investigation.registeringOfficerName = grab(
      r'Registered by[\s\S]{0,180}?Name\s*\([^)]{0,40}\)[ \t]*:[ \t\n]*([^\n]+)');
  d.investigation.registeringOfficerRank = grab(
      r'Registered by[\s\S]{0,260}?Rank\s*\([^)]{0,40}\)[ \t]*:[ \t\n]*([^\n]+)');
  d.investigation.registeringOfficerNo = grab(
      r'Registered by[\s\S]{0,340}?No\.\s*\([^)]{0,40}\)\s*:[ \t\n]*([0-9]{2,6})');

  // --- Narrative (item 12) -------------------------------------------------
  d.detailedDescription = grab(
      r'First Information contents[^):\n]*\)?\s*:?\s*([\s\S]{0,4000}?)'
      r'(?:Action taken|R\.O\.A\.C|Signature of Officer|Registered by)');

  return d;
}
