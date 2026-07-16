import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local 6-digit launch lock. After the account is approved the user sets a
/// PIN; it is then required every time the app starts.
///
/// Hardening (v2 format):
///   - PBKDF2-HMAC-SHA256 with a random per-PIN salt (a 6-digit PIN has only
///     1M combinations, so a bare hash is brute-forceable in milliseconds;
///     PBKDF2 makes each guess cost tens of thousands of hashes).
///   - Attempt lockout: 5 straight failures locks entry for 30s, doubling for
///     every further failure (capped at 15 minutes). Survives restarts.
///   - Legacy v1 hashes (single SHA-256) still verify and are upgraded to v2
///     transparently on the next successful unlock.
/// Only the salted hash is stored (never the PIN), bound to the signed-in
/// email so a different account sets its own PIN.
class PinService {
  static const _kHash = 'pin_hash';
  static const _kEmail = 'pin_email';
  static const _kFails = 'pin_fail_count';
  static const _kFailAt = 'pin_fail_at_millis';
  static const int pinLength = 6;

  /// PBKDF2 cost. ~50–150ms of pure-Dart hashing on desktop hardware — free
  /// at unlock time, expensive for an offline brute force of 1M PINs.
  static const int _iterations = 30000;

  static const int _lockThreshold = 5;
  static const Duration _lockBase = Duration(seconds: 30);
  static const Duration _lockMax = Duration(minutes: 15);

  /// True when a PIN has already been set for [email].
  Future<bool> hasPinFor(String email) async {
    final p = await SharedPreferences.getInstance();
    final h = p.getString(_kHash);
    final e = p.getString(_kEmail);
    return h != null && h.isNotEmpty && e == email;
  }

  Future<void> setPin(String email, String pin) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kHash, _encodeV2(email, pin));
    await p.setString(_kEmail, email);
    await p.remove(_kFails);
    await p.remove(_kFailAt);
  }

  /// How much longer PIN entry is locked out, or [Duration.zero] when open.
  Future<Duration> remainingLockout() async {
    final p = await SharedPreferences.getInstance();
    final fails = p.getInt(_kFails) ?? 0;
    if (fails < _lockThreshold) return Duration.zero;
    final at = p.getInt(_kFailAt);
    if (at == null) return Duration.zero;
    final lockedFor = _lockDuration(fails);
    final until =
        DateTime.fromMillisecondsSinceEpoch(at).add(lockedFor);
    final left = until.difference(DateTime.now());
    return left.isNegative ? Duration.zero : left;
  }

  /// Verifies [pin]. Returns false (without checking) while locked out;
  /// callers should show [remainingLockout] to the user. Wrong attempts are
  /// counted persistently; a correct one clears the counter and upgrades any
  /// legacy stored hash to the v2 format.
  Future<bool> verify(String email, String pin) async {
    if ((await remainingLockout()) > Duration.zero) return false;
    final p = await SharedPreferences.getInstance();
    final stored = p.getString(_kHash);
    if (stored == null || stored.isEmpty) return false;

    final ok = _matches(stored, email, pin);
    if (ok) {
      await p.remove(_kFails);
      await p.remove(_kFailAt);
      if (!stored.startsWith('{')) {
        // Transparent upgrade of a legacy v1 hash.
        await p.setString(_kHash, _encodeV2(email, pin));
      }
    } else {
      await p.setInt(_kFails, (p.getInt(_kFails) ?? 0) + 1);
      await p.setInt(_kFailAt, DateTime.now().millisecondsSinceEpoch);
    }
    return ok;
  }

  /// Removes the stored PIN (called on sign-out so the next account is clean).
  Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kHash);
    await p.remove(_kEmail);
    await p.remove(_kFails);
    await p.remove(_kFailAt);
  }

  static Duration _lockDuration(int fails) {
    final extra = fails - _lockThreshold; // 0 on the 5th failure
    var d = _lockBase * (1 << extra.clamp(0, 10));
    if (d > _lockMax) d = _lockMax;
    return d;
  }

  bool _matches(String stored, String email, String pin) {
    if (stored.startsWith('{')) {
      try {
        final map = jsonDecode(stored) as Map<String, dynamic>;
        final salt = base64.decode(map['salt'] as String);
        final iter = (map['iter'] as num).toInt();
        final expected = base64.decode(map['hash'] as String);
        final actual = _pbkdf2('$email|$pin', salt, iter, expected.length);
        return _constantTimeEquals(expected, actual);
      } catch (_) {
        return false;
      }
    }
    // Legacy v1: hex sha256('crms|email|pin').
    return stored == _legacyHash(email, pin);
  }

  String _encodeV2(String email, String pin) {
    final salt = _randomBytes(16);
    final hash = _pbkdf2('$email|$pin', salt, _iterations, 32);
    return jsonEncode({
      'v': 2,
      'salt': base64.encode(salt),
      'iter': _iterations,
      'hash': base64.encode(hash),
    });
  }

  static Uint8List _randomBytes(int n) {
    final rng = Random.secure();
    return Uint8List.fromList(List.generate(n, (_) => rng.nextInt(256)));
  }

  /// PBKDF2-HMAC-SHA256 (RFC 2898). [length] must be <= 32 (single block).
  static Uint8List _pbkdf2(
      String password, List<int> salt, int iterations, int length) {
    assert(length <= 32);
    final mac = Hmac(sha256, utf8.encode(password));
    // Block 1: U1 = HMAC(P, S || INT(1)); Un = HMAC(P, Un-1); T = U1^...^Un.
    var u = Uint8List.fromList(mac.convert([...salt, 0, 0, 0, 1]).bytes);
    final t = Uint8List.fromList(u);
    for (var i = 1; i < iterations; i++) {
      u = Uint8List.fromList(mac.convert(u).bytes);
      for (var j = 0; j < t.length; j++) {
        t[j] ^= u[j];
      }
    }
    return Uint8List.sublistView(t, 0, length);
  }

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }

  static String _legacyHash(String email, String pin) =>
      sha256.convert(utf8.encode('crms|$email|$pin')).toString();
}
