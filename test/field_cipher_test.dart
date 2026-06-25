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
}
