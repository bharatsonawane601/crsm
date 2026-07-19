import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Small wrapper over the OS secure store (Windows DPAPI, macOS Keychain).
///
/// Holds the two secrets that must survive a restart but never sit readable on
/// disk: the device-bound session token (so an officer types their password
/// once, not every launch) and — later — the local database encryption key.
/// DPAPI ties the ciphertext to the Windows user account, so copying the files
/// to another machine or user yields nothing usable.
class SecureStore {
  SecureStore([FlutterSecureStorage? storage])
      : _s = storage ??
            const FlutterSecureStorage(
              // Bind to the local machine/user; never roam or sync.
              wOptions: WindowsOptions(),
            );

  final FlutterSecureStorage _s;

  static const _kToken = 'crms_session_token';
  static const _kDbKey = 'crms_db_key';

  Future<String?> readToken() => _read(_kToken);
  Future<void> writeToken(String token) => _write(_kToken, token);
  Future<void> clearToken() => _delete(_kToken);

  Future<String?> readDbKey() => _read(_kDbKey);
  Future<void> writeDbKey(String key) => _write(_kDbKey, key);

  Future<String?> _read(String k) async {
    try {
      return await _s.read(key: k);
    } catch (_) {
      return null;
    }
  }

  Future<void> _write(String k, String v) async {
    try {
      await _s.write(key: k, value: v);
    } catch (_) {
      // A secure-store failure must not crash the app; the user just has to
      // sign in again next launch.
    }
  }

  Future<void> _delete(String k) async {
    try {
      await _s.delete(key: k);
    } catch (_) {}
  }
}
