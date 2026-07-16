import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crms/core/i18n/locale_config.dart';
import 'package:crms/features/analyzer/analytics_model.dart';
import 'package:crms/features/analyzer/dashboard_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues(const {}));

  testWidgets('dashboard chart grid lays out without overflow/assertions',
      (tester) async {
    await EasyLocalization.ensureInitialized();

    final rows = <AnalyticsRow>[
      AnalyticsRow(
        id: 1,
        status: 'undetected',
        dateRegistered: DateTime(2026, 3, 1),
        section: '379',
        crimeType: 'Theft / चोरी',
        officerName: 'PI A',
        courtType: 'sessions',
        caseStage: 'investigation',
      ),
      AnalyticsRow(
        id: 2,
        status: 'detected',
        dateRegistered: DateTime(2026, 2, 1),
        section: '420',
        crimeType: 'Cheating / फसवणूक',
        officerName: 'PI B',
        courtType: 'jmfc',
        caseStage: 'investigation,chargesheet',
      ),
    ];

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: LocaleConfig.supported,
        path: LocaleConfig.path,
        fallbackLocale: LocaleConfig.fallback,
        startLocale: LocaleConfig.english,
        child: ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: SizedBox(
                width: 1000,
                height: 800,
                child: AnalyticsDashboardBody(
                  allRows: rows,
                  showStatsButton: false,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // A few bounded pumps to let easy_localization + charts settle.
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }

    // No exception means the IntrinsicHeight row grid + charts laid out fine.
    expect(tester.takeException(), isNull);
    expect(find.byType(AnalyticsDashboardBody), findsOneWidget);
  });
}
