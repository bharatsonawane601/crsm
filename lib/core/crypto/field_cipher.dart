import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

/// AES-GCM encryption for sensitive fields (Aadhaar, PAN) per PROJECT.md
/// rule 8 and the Google Drive sync model: these values must be encrypted
/// at rest and BEFORE they are ever uploaded to Drive.
///
/// Storage format: base64( iv (12 bytes) || ciphertext+tag ).
///
/// TODO (Phase 1 hardening): the AES key must NOT be hard-coded. Derive it
/// from the signed-in user (PBKDF2 over a passphrase) or store it in the OS
/// keychain. The constructor takes the key so key management can be swapped
/// in without touching call sites.
class FieldCipher {
  FieldCipher(Key key) : _encrypter = Encrypter(AES(key, mode: AESMode.gcm));

  final Encrypter _encrypter;

  /// Build a cipher from a 32-byte (256-bit) key.
  factory FieldCipher.fromBytes(List<int> keyBytes) {
    if (keyBytes.length != 32) {
      throw ArgumentError('AES-256 key must be exactly 32 bytes');
    }
    return FieldCipher(Key(Uint8List.fromList(keyBytes)));
  }

  /// Encrypts [plaintext]; returns null for null/empty input so optional
  /// fields stay empty rather than storing an encrypted empty string.
  String? encryptField(String? plaintext) {
    if (plaintext == null || plaintext.isEmpty) return null;
    final iv = IV.fromSecureRandom(12);
    final encrypted = _encrypter.encrypt(plaintext, iv: iv);
    return base64.encode(iv.bytes + encrypted.bytes);
  }

  /// Reverses [encryptField]. Returns null for null/empty input.
  String? decryptField(String? stored) {
    if (stored == null || stored.isEmpty) return null;
    final raw = base64.decode(stored);
    final iv = IV(raw.sublist(0, 12));
    final cipherBytes = raw.sublist(12);
    return _encrypter.decrypt(Encrypted(cipherBytes), iv: iv);
  }

  /// Encrypts arbitrary bytes (used for encrypted DB backups).
  /// Output layout: iv (12 bytes) || ciphertext+tag.
  Uint8List encryptBytes(List<int> data) {
    final iv = IV.fromSecureRandom(12);
    final encrypted = _encrypter.encryptBytes(data, iv: iv);
    return Uint8List.fromList(iv.bytes + encrypted.bytes);
  }

  /// Reverses [encryptBytes].
  Uint8List decryptBytes(Uint8List stored) {
    final iv = IV(stored.sublist(0, 12));
    final cipherBytes = stored.sublist(12);
    return Uint8List.fromList(
      _encrypter.decryptBytes(Encrypted(cipherBytes), iv: iv),
    );
  }
}
