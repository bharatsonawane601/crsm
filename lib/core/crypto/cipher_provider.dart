import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'field_cipher.dart';

/// Provides the [FieldCipher] used to encrypt sensitive fields (Aadhaar, PAN)
/// before they are written to the DB / uploaded to Drive.
///
/// !!! TEMPORARY DEV KEY !!!
/// TODO (Phase 1/8 hardening): this 32-byte key MUST NOT ship hard-coded.
/// Replace with a key that is either:
///   - derived from the signed-in user via PBKDF2 over a passphrase, or
///   - generated once and stored in the OS keychain (flutter_secure_storage).
/// The rest of the app depends only on [cipherProvider], so swapping the key
/// source here changes nothing at the call sites.
const List<int> _devKey = <int>[
  0x9f, 0x4a, 0x1c, 0x77, 0x2e, 0xb3, 0x55, 0x08,
  0xc1, 0x6d, 0x90, 0x3f, 0xa8, 0x12, 0x7b, 0xe4,
  0x4d, 0x88, 0x21, 0x5a, 0xf0, 0x6c, 0x39, 0x97,
  0xb5, 0x02, 0xde, 0x71, 0x83, 0x44, 0x1e, 0xca,
];

/// Builds the field cipher outside of Riverpod (e.g. in main() bootstrap,
/// before providers exist). Uses the same key as [cipherProvider].
FieldCipher defaultFieldCipher() => FieldCipher.fromBytes(_devKey);

final cipherProvider = Provider<FieldCipher>(
  (ref) => defaultFieldCipher(),
);
