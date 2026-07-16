import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'field_cipher.dart';

/// Provides the [FieldCipher] used to encrypt sensitive fields (Aadhaar, PAN)
/// before they are written to the DB / uploaded to Drive.
///
/// Key management: the production key is injected at build time (same pattern
/// as CRMS_APP_KEY — from crms.env via install.sh / CI secrets) so it never
/// lives in source control:
///
///   `flutter build --release --dart-define=CRMS_FIELD_KEY=<64 hex chars>`
///
/// All official builds must use the SAME key, because the Drive-folder sync
/// model shares encrypted DB files across a user's devices.
///
/// With no define (development, tests) the historical dev key is used, and it
/// is also kept as a decrypt-only LEGACY key in production builds so data and
/// backups written before the key was externalized remain readable — old
/// records are transparently re-encrypted with the new key next time they are
/// saved.
const String _envKeyHex = String.fromEnvironment('CRMS_FIELD_KEY');

/// Historical dev key (v1.x builds). Decrypt-only once CRMS_FIELD_KEY is set.
const List<int> _devKey = <int>[
  0x9f, 0x4a, 0x1c, 0x77, 0x2e, 0xb3, 0x55, 0x08,
  0xc1, 0x6d, 0x90, 0x3f, 0xa8, 0x12, 0x7b, 0xe4,
  0x4d, 0x88, 0x21, 0x5a, 0xf0, 0x6c, 0x39, 0x97,
  0xb5, 0x02, 0xde, 0x71, 0x83, 0x44, 0x1e, 0xca,
];

/// Parses a 64-char hex string into 32 key bytes, or null if absent/invalid.
List<int>? _parseHexKey(String hex) {
  final cleaned = hex.trim();
  if (cleaned.length != 64) return null;
  final bytes = <int>[];
  for (var i = 0; i < 64; i += 2) {
    final b = int.tryParse(cleaned.substring(i, i + 2), radix: 16);
    if (b == null) return null;
    bytes.add(b);
  }
  return bytes;
}

/// True when a real (non-dev) field key was injected at build time.
final bool isFieldKeyConfigured = _parseHexKey(_envKeyHex) != null;

/// Builds the field cipher outside of Riverpod (e.g. in main() bootstrap,
/// before providers exist). Uses the same key as [cipherProvider].
FieldCipher defaultFieldCipher() {
  final envKey = _parseHexKey(_envKeyHex);
  if (envKey != null) {
    // Production: encrypt with the injected key; still decrypt legacy data.
    return FieldCipher.fromBytes(envKey, legacyKeyBytes: const [_devKey]);
  }
  return FieldCipher.fromBytes(_devKey);
}

final cipherProvider = Provider<FieldCipher>(
  (ref) => defaultFieldCipher(),
);
