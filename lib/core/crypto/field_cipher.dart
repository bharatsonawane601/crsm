import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart';

/// AES-GCM encryption for sensitive fields (Aadhaar, PAN) per PROJECT.md
/// rule 8 and the Google Drive sync model: these values must be encrypted
/// at rest and BEFORE they are ever uploaded to Drive.
///
/// Storage format: base64( iv (12 bytes) || ciphertext+tag ).
///
/// Key management lives in cipher_provider.dart: the key comes from the
/// CRMS_FIELD_KEY build define; [legacyKeys] lets decryption fall back to
/// older keys (e.g. the historical dev key) so data written before a key
/// rotation stays readable. Everything new is encrypted with the primary key.
class FieldCipher {
  FieldCipher(Key key, {List<Key> legacyKeys = const []})
      : _encrypter = Encrypter(AES(key, mode: AESMode.gcm)),
        _legacy = [
          for (final k in legacyKeys) Encrypter(AES(k, mode: AESMode.gcm)),
        ];

  final Encrypter _encrypter;

  /// Older encrypters tried (in order) when the primary fails to decrypt.
  final List<Encrypter> _legacy;

  /// Build a cipher from a 32-byte (256-bit) key, with optional legacy keys
  /// accepted for decryption only.
  factory FieldCipher.fromBytes(List<int> keyBytes,
      {List<List<int>> legacyKeyBytes = const []}) {
    for (final k in [keyBytes, ...legacyKeyBytes]) {
      if (k.length != 32) {
        throw ArgumentError('AES-256 key must be exactly 32 bytes');
      }
    }
    return FieldCipher(
      Key(Uint8List.fromList(keyBytes)),
      legacyKeys: [for (final k in legacyKeyBytes) Key(Uint8List.fromList(k))],
    );
  }

  /// Encrypts [plaintext]; returns null for null/empty input so optional
  /// fields stay empty rather than storing an encrypted empty string.
  String? encryptField(String? plaintext) {
    if (plaintext == null || plaintext.isEmpty) return null;
    final iv = IV.fromSecureRandom(12);
    final encrypted = _encrypter.encrypt(plaintext, iv: iv);
    return base64.encode(iv.bytes + encrypted.bytes);
  }

  /// Reverses [encryptField]. Returns null for null/empty input. Tries the
  /// primary key first, then any legacy keys (GCM authentication fails cleanly
  /// on a wrong key, so a fallback attempt is safe).
  String? decryptField(String? stored) {
    if (stored == null || stored.isEmpty) return null;
    final raw = base64.decode(stored);
    final iv = IV(raw.sublist(0, 12));
    final encrypted = Encrypted(raw.sublist(12));
    try {
      return _encrypter.decrypt(encrypted, iv: iv);
    } catch (_) {
      for (final legacy in _legacy) {
        try {
          return legacy.decrypt(encrypted, iv: iv);
        } catch (_) {/* try next */}
      }
      rethrow;
    }
  }

  /// Encrypts arbitrary bytes (used for encrypted DB backups).
  /// Output layout: iv (12 bytes) || ciphertext+tag.
  Uint8List encryptBytes(List<int> data) {
    final iv = IV.fromSecureRandom(12);
    final encrypted = _encrypter.encryptBytes(data, iv: iv);
    return Uint8List.fromList(iv.bytes + encrypted.bytes);
  }

  /// Reverses [encryptBytes]. Falls back to legacy keys like [decryptField]
  /// so old backups / sync files survive a key rotation.
  Uint8List decryptBytes(Uint8List stored) {
    final iv = IV(stored.sublist(0, 12));
    final encrypted = Encrypted(stored.sublist(12));
    try {
      return Uint8List.fromList(_encrypter.decryptBytes(encrypted, iv: iv));
    } catch (_) {
      for (final legacy in _legacy) {
        try {
          return Uint8List.fromList(legacy.decryptBytes(encrypted, iv: iv));
        } catch (_) {/* try next */}
      }
      rethrow;
    }
  }
}
