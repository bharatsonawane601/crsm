import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crms/data/db/database.dart';
import 'package:crms/features/io/forms/seizure_form_model.dart';
import 'package:crms/features/io/forms/seizure_form_view.dart';

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

Future<void> _pump(WidgetTester tester, int? page) async {
  await tester.binding.setSurfaceSize(const Size(900, 5000));
  final values = buildSeizureValues(ioCase: _case());
  final rows = seizurePropertyRows(exhibits: [
    IoExhibit(id: 1, caseId: 1, description: 'मोबाईल सॅमसंग', value: 15000, sortOrder: 0),
  ]);
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: SingleChildScrollView(
        child: SeizureFormView(values: values, rows: rows, width: 780, only: page),
      ),
    ),
  ));
  await tester.pump();
  expect(tester.takeException(), isNull);
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final bytes =
        File('assets/fonts/NotoSansDevanagari-VF.ttf').readAsBytesSync();
    final loader = FontLoader('NotoSansDevanagari')
      ..addFont(Future.value(ByteData.view(Uint8List.fromList(bytes).buffer)));
    await loader.load();
  });

  testWidgets('page 1 renders with no overflow', (t) => _pump(t, 1));
  testWidgets('page 2 renders with no overflow', (t) => _pump(t, 2));
  testWidgets('both pages render with no overflow', (t) => _pump(t, null));
}
