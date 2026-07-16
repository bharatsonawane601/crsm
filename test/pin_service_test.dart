import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crms/features/auth/pin_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const email = 'officer@example.com';
  const pin = '123456';

  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('PinService v2 (PBKDF2 + lockout)', () {
    test('set + verify round-trip; stored value is salted JSON, not the PIN',
        () async {
      final svc = PinService();
      await svc.setPin(email, pin);

      expect(await svc.hasPinFor(email), isTrue);
      expect(await svc.verify(email, pin), isTrue);

      final stored =
          (await SharedPreferences.getInstance()).getString('pin_hash')!;
      expect(stored, isNot(contains(pin)));
      final map = jsonDecode(stored) as Map<String, dynamic>;
      expect(map['v'], 2);
      expect(map['salt'], isNotEmpty);
      expect((map['iter'] as num).toInt(), greaterThanOrEqualTo(10000));
    });

    test('same PIN hashes differently per set (random salt)', () async {
      final svc = PinService();
      await svc.setPin(email, pin);
      final first =
          (await SharedPreferences.getInstance()).getString('pin_hash');
      await svc.setPin(email, pin);
      final second =
          (await SharedPreferences.getInstance()).getString('pin_hash');
      expect(first, isNot(equals(second)));
    });

    test('wrong PIN fails; 5 straight failures lock entry out', () async {
      final svc = PinService();
      await svc.setPin(email, pin);

      for (var i = 0; i < 5; i++) {
        expect(await svc.verify(email, '000000'), isFalse);
      }
      final left = await svc.remainingLockout();
      expect(left, greaterThan(Duration.zero));
      // Even the CORRECT pin is refused while locked out.
      expect(await svc.verify(email, pin), isFalse);
    });

    test('successful verify clears the failure counter', () async {
      final svc = PinService();
      await svc.setPin(email, pin);
      await svc.verify(email, '000000'); // one failure
      expect(await svc.verify(email, pin), isTrue);
      expect(await svc.remainingLockout(), Duration.zero);
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('pin_fail_count'), isNull);
    });

    test('legacy v1 hash still verifies and upgrades to v2', () async {
      // Seed the store exactly as the old PinService wrote it.
      final legacy =
          sha256.convert(utf8.encode('crms|$email|$pin')).toString();
      SharedPreferences.setMockInitialValues({
        'pin_hash': legacy,
        'pin_email': email,
      });

      final svc = PinService();
      expect(await svc.verify(email, pin), isTrue);
      // The stored hash must now be the v2 JSON format.
      final stored =
          (await SharedPreferences.getInstance()).getString('pin_hash')!;
      expect(stored, startsWith('{'));
      expect((jsonDecode(stored) as Map)['v'], 2);
      // And it still verifies after the upgrade.
      expect(await svc.verify(email, pin), isTrue);
      expect(await svc.verify(email, '999999'), isFalse);
    });

    test('clear removes hash and lockout state', () async {
      final svc = PinService();
      await svc.setPin(email, pin);
      await svc.verify(email, '000000');
      await svc.clear();
      expect(await svc.hasPinFor(email), isFalse);
      expect(await svc.remainingLockout(), Duration.zero);
    });
  });
}
