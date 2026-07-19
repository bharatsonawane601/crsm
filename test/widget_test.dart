import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crms/app.dart';
import 'package:crms/core/i18n/locale_config.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    // easy_localization persists the chosen locale via shared_preferences.
    SharedPreferences.setMockInitialValues(const {});
  });

  testWidgets('Welcome screen leads to the ID/password sign-in screen',
      (tester) async {
    await EasyLocalization.ensureInitialized();

    await tester.pumpWidget(
      EasyLocalization(
        supportedLocales: LocaleConfig.supported,
        path: LocaleConfig.path,
        fallbackLocale: LocaleConfig.fallback,
        startLocale: LocaleConfig.english,
        child: const ProviderScope(child: CrmsApp()),
      ),
    );

    // Bounded pumps instead of pumpAndSettle (the splash has an infinite
    // spinner, so pumpAndSettle would hang). Pump past the ~1.5s launch splash
    // until the welcome page's "Get Started" button appears.
    final getStarted = find.text('Get Started');
    for (var i = 0; i < 30 && getStarted.evaluate().isEmpty; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }
    expect(getStarted, findsOneWidget);

    // Continue to the login screen.
    await tester.tap(getStarted);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 200));
    }

    // The new sign-in screen: a Sign in button plus the Request-access button.
    expect(find.byType(FilledButton), findsWidgets);
    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Request ID & password'), findsOneWidget);
  });
}
