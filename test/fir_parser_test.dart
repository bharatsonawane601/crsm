import 'package:flutter_test/flutter_test.dart';

import 'package:crms/features/fir_import/fir_pdf_parser.dart';

void main() {
  // A FAITHFUL reproduction of the real NCRB IIF-1 text layer (IIF1.pdf),
  // including the garbled legacy-font Marathi and stray backslashes exactly as
  // syncfusion's PdfTextExtractor returns them. We assert that every reliable
  // field is extracted cleanly and — critically — that BLANK fields (e.g.
  // Father's Name) stay blank instead of swallowing the next label.
  const sample = r'''
1. P.S. (पोलीस ठाणे): बेगमपूरा
FIR No. (Ĥम खबर Đ.): 0078 Date and Time of FIR (Ĥ. ख. दिनांक आणण वेळ):
30/03/2026 19:02 वाजता
District (णजãहा): छğपती संभाजीनगर
शहर
Year (वष[): 2026
2. S.No. (\.Đ.) Acts (\धधधनयम) Sections (कलम)
1 भारतीय Ûयाय संदहता (बी fन
fस), 2023
303(2)
FIRST INFORMATION REPORT
 (Under Section 173 B.N.S.S)
3. (a) Occurrence of offence(गुÛƻाची घटना):
(b) Information received at P.S. (पोलीस
ठाÖयावर मादहती धमळाãयाचा):
Date (दिनांक):
30/03/2026
Time (वेळ):
18:50 तास
(c) General Diary Reference (ठाणे िैनंदिनी
संिभ[):
Date and Time
(दिनांक आणण
वेळ):
30/03/2026
18:50 तास
Entry No. (नɉि Đ.):
040
Day (दिवस): मधले दिवस Date from (दिनांक पासून):
17/03/2026
Date To (दिनांक पयɍत):
18/03/2026
Time Period (कालावधी): Time From (वेळेपासून):
21:00 तास
Time To (वेळेपयɍत):
08:00 तास
4. Type of Information (मादहतीचा Ĥकार): लेखी
5. Place of Occurrence (घटनाèळ):
Beat No. (बीट Đ.): 1. (a) Direction and distance from P.S. (पोधलस ठाÖया पासून दिशा
आणण \ंतर): पूव[, 1 दक.मी.
(b) Address (पƣा): घाटȣ िवाखाना , \पघात ǒवभागासमोरÍया पादकɍ गम, घाटȣ
िवाखानाछğपती संभाजीनगर ,
(c) In case, outside the limit of this Police Station, then  Name of P.S. (पोलीस ठाÖयाÍया हƧȣ बाहेर \सãयास):
District (State) (णजãहा (राÏय)):
6. Complainant / Informant (तĐारिार / मादहती िेणारा):
(a) Name (नाव): सागर कडु बाळ बनसोडे
(b) Father's/Husband's Name (वदडलांचे/पतीचे नाव):
(c) Date/Year of Birth (जÛमतारȣख / वष[):
1997
(d) Nationality (राç Ěȣय× व): भारत
(h) Occupation (åयवसाय):
(i) Address (पƣा):
S.No. (\.Đ.) Address Type (पƣा Ĥकार) Address (पƣा)::
1 वत[मान पता बकवालनगर नायगाव पोèट वाळुज, ता गंगापुर णज छञपती संभाजीनगर , वाळुंज
2 èायी पता बकवालनगर नायगाव पोèट वाळुज, ता गंगापुर णज छञपती संभाजीनगर , वाळुंज
(j) Phone number (फोन नं.): Mobile (मोबाइल Đ.): 91-9146477105
1 वाहने आणण इतर fच.fफ. दडलÈस Đ. MH 20 EQ 4580 माँडल 2017 Þलँक Þलु रंगाची 15,000.00
10. Total value of property (In Rs/-) मालमƣेचे fकू ण मुãय (ǽ. मÚये) : 15,000.00
12. First Information contents (Ĥम खबर हदकगत):
 जबाब दि.30/03/2026
 मी, सागर कडु बाळ बनसोडे माझी मोटर सा_कल MH 20 EQ 4580 चोरȣस गेली आहे.
Action taken: Since the above information reveals commission of offence(s).
(2) Directed (Name of I.O.) (तपास \अधधका-याचे नाव):
MANGAL AURAN SONAWNE
Rank (हुƧा): पोलीस हवालिार
No. (Đ.): 1947 to take up the Investigation
Registered by (नɉिणी \अधधकारȣ)
Signature of Officer in charge, Police Station (ठाणे Ĥभारȣ \अधधका-याची èवा¢रȣ)
Name (नाव): narendra bhimrao padalkar
Rank (हुƧा): I (Inspector)
No. (Đ.): 50686
''';

  test('extracts every reliable field from the real IIF-1 text layer', () {
    final d = parseFirText(sample);

    // Header.
    expect(d.firNo, '0078');
    expect(d.year, 2026);
    expect(d.firDate, DateTime(2026, 3, 30));
    expect(d.firTime, '19:02');
    expect(d.section, 'BNS 303(2)');
    expect(d.policeStation, 'बेगमपूरा');
    expect(d.district, 'छğपती संभाजीनगर');

    // Occurrence — exact from/to dates AND times.
    expect(d.dateOccurred, DateTime(2026, 3, 17));
    expect(d.dateOccurredTo, DateTime(2026, 3, 18));
    expect(d.timeOccurred, '21:00');
    expect(d.timeOccurredTo, '08:00');
    expect(d.occurrenceDay, 'मधले दिवस');

    // Info received / General Diary / beat.
    expect(d.infoReceivedDate, DateTime(2026, 3, 30));
    expect(d.infoReceivedTime, '18:50');
    expect(d.gdEntryNo, '040');
    expect(d.beatNo, '1');
    expect(d.directionDistance, contains('पूव'));
    expect(d.typeOfInformation, 'लेखी');

    // Complainant (item 6) — exact name; blank father stays blank.
    expect(d.complainant.name, 'सागर कडु बाळ बनसोडे');
    expect(d.complainant.fatherHusbandName, isNull,
        reason: 'father field is empty in the FIR — must NOT grab the next label');
    expect(d.complainant.birthYear, 1997);
    expect(d.complainant.nationality, 'भारत');
    expect(d.complainant.mobile, '9146477105');
    expect(d.complainant.address, contains('बकवालनगर'));

    // Property.
    expect(d.stolen, isNotEmpty);
    expect(d.stolen.first.value, 15000.0);
    expect(d.stolen.first.description, contains('MH 20 EQ 4580'));

    // Officers — anchored, NOT the FIR number.
    expect(d.investigation.officerName, 'MANGAL AURAN SONAWNE');
    expect(d.investigation.officerId, '1947');
    expect(d.investigation.registeringOfficerName, 'narendra bhimrao padalkar');
    expect(d.investigation.registeringOfficerNo, '50686');

    // Narrative.
    expect(d.detailedDescription, isNotNull);
    expect(d.detailedDescription, contains('MH 20 EQ 4580'));
  });

  test('empty / junk text yields a usable blank draft (no crash)', () {
    final d = parseFirText('not a fir');
    expect(d.firNo, '');
    expect(d.stolen, isEmpty);
    expect(d.complainant.fatherHusbandName, isNull);
  });
}
