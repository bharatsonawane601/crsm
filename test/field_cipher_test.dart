import 'package:encrypt/encrypt.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:crms/core/crypto/field_cipher.dart';

void main() {
  // Fixed 32-byte key for deterministic tests.
  final cipher = FieldCipher.fromBytes(List<int>.generate(32, (i) => i));

  group('FieldCipher (AES-GCM)', () {
    test('round-trips an Aadhaar number', () {
      const aadhaar = '1234 5678 9012';
      final enc = cipher.encryptField(aadhaar);

      expect(enc, isNotNull);
      expect(enc, isNot(equals(aadhaar)), reason: 'must not be plaintext');
      expect(cipher.decryptField(enc), equals(aadhaar));
    });

    test('null/empty input yields null (optional fields stay empty)', () {
      expect(cipher.encryptField(null), isNull);
      expect(cipher.encryptField(''), isNull);
      expect(cipher.decryptField(null), isNull);
      expect(cipher.decryptField(''), isNull);
    });

    test('encrypting the same value twice gives different ciphertext (random IV)',
        () {
      final a = cipher.encryptField('ABCDE1234F');
      final b = cipher.encryptField('ABCDE1234F');
      expect(a, isNot(equals(b)));
      expect(cipher.decryptField(a), equals('ABCDE1234F'));
      expect(cipher.decryptField(b), equals('ABCDE1234F'));
    });

    test('rejects keys that are not 32 bytes', () {
      expect(() => FieldCipher.fromBytes([1, 2, 3]), throwsArgumentError);
    });

    test('a different key cannot decrypt the ciphertext', () {
      final enc = cipher.encryptField('secret-pan')!;
      final other = FieldCipher(Key.fromLength(32));
      expect(() => other.decryptField(enc), throwsA(isA<Object>()));
    });
  });

  group('FieldCipher legacy-key fallback (key rotation)', () {
    final oldKey = List<int>.generate(32, (i) => i);
    final newKey = List<int>.generate(32, (i) => 255 - i);
    final oldCipher = FieldCipher.fromBytes(oldKey);
    final rotated = FieldCipher.fromBytes(newKey, legacyKeyBytes: [oldKey]);

    test('decrypts data written with the legacy key', () {
      final enc = oldCipher.encryptField('1234 5678 9012');
      expect(rotated.decryptField(enc), equals('1234 5678 9012'));
    });

    test('encrypts NEW data with the primary key only', () {
      final enc = rotated.encryptField('ABCDE1234F');
      // The primary-only cipher must read it; the legacy-only one must not.
      expect(FieldCipher.fromBytes(newKey).decryptField(enc),
          equals('ABCDE1234F'));
      expect(() => oldCipher.decryptField(enc), throwsA(isA<Object>()));
    });

    test('legacy fallback also covers byte blobs (backups / sync files)', () {
      final blob = List<int>.generate(64, (i) => i * 3 % 256);
      final enc = oldCipher.encryptBytes(blob);
      expect(rotated.decryptBytes(enc), equals(blob));
    });

    test('still throws when no key matches', () {
      final enc = FieldCipher(Key.fromLength(32)).encryptField('x')!;
      expect(() => rotated.decryptField(enc), throwsA(isA<Object>()));
    });
  });
}
