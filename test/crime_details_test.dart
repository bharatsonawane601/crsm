import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crms/data/db/database.dart';
import 'package:crms/features/crime_entry/models/crime_draft.dart';
import 'package:crms/features/io/forms/crime_details_model.dart';
import 'package:crms/features/io/forms/crime_details_view.dart';

IoCase _case() => IoCase(
      id: 1,
      remoteUid: 'io_x',
      status: 'active',
      firNo: '77',
      year: 2026,
      district: 'छत्रपती संभाजीनगर',
      policeStation: 'CIDCO',
      createdAt: DateTime(2026, 1, 1),
      updatedAt: DateTime(2026, 1, 1),
    );

CrimeDraft _fir() => CrimeDraft(
      firNo: '77',
      year: 2026,
      district: 'छत्रपती संभाजीनगर',
      policeStation: 'CIDCO',
      section: '303(2) BNS',
      crimeType: 'Theft / चोरी',
      dateRegistered: DateTime(2026, 6, 1),
      detailedDescription: 'घटनास्थळाचे वर्णन येथे.',
      complainant: PersonDraft(
          name: 'राम', fatherHusbandName: 'गोपाळ', address: 'एन-७', gender: 'पुरुष'),
      stolen: [StolenItemDraft(category: 'दागिने', description: 'सोन्याची चेन', value: 40000)],
    );

void main() {
  test('auto-fills header, major/minor head and scene from the FIR', () {
    final v = buildCrimeDetailsValues(ioCase: _case(), fir: _fir());
    expect(v['district'], 'छत्रपती संभाजीनगर');
    expect(v['firNo'], '77');
    expect(v['actSection'], '303(2) BNS');
    expect(v['placeByName'], 'राम');
    expect(v['placeByFather'], 'गोपाळ');
    expect(v['majorHead'], 'चोरी'); // category Marathi
    expect(v['minorHead'], 'चोरी'); // sub-type Marathi
    expect(v['property1'], 'दागिने');
    expect(v['propertiesInvolved'], contains('सोन्याची चेन'));
    expect(v['sceneDescription'], 'घटनास्थळाचे वर्णन येथे.');
  });

  test('victim row 1 comes from the complainant', () {
    final victims = buildCrimeDetailsVictims(fir: _fir());
    expect(victims.length, 1);
    expect(victims.first.fullName, 'राम');
    expect(victims.first.sex, 'पुरुष');
  });

  group('renders without overflow', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      final bytes =
          File('assets/fonts/NotoSansDevanagari-VF.ttf').readAsBytesSync();
      final loader = FontLoader('NotoSansDevanagari')
        ..addFont(Future.value(ByteData.view(Uint8List.fromList(bytes).buffer)));
      await loader.load();
    });

    Future<void> pump(WidgetTester t, int? page) async {
      await t.binding.setSurfaceSize(const Size(900, 6000));
      await t.pumpWidget(MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: CrimeDetailsView(
              values: buildCrimeDetailsValues(ioCase: _case(), fir: _fir()),
              victims: buildCrimeDetailsVictims(fir: _fir()),
              width: 780,
              only: page,
            ),
          ),
        ),
      ));
      await t.pump();
      expect(t.takeException(), isNull);
    }

    testWidgets('2-A', (t) => pump(t, 1));
    testWidgets('2-B', (t) => pump(t, 2));
    testWidgets('2-C', (t) => pump(t, 3));
    testWidgets('map/evidence page', (t) => pump(t, 4));
  });
}
