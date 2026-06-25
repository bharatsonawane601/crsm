import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local 6-digit launch lock. After the account is approved the user sets a
/// PIN; it is then required every time the app starts. Only a salted SHA-256
/// hash is stored (never the PIN itself), bound to the signed-in email so a
/// different account sets its own PIN.
class PinService {
  static const _kHash = 'pin_hash';
  static const _kEmail = 'pin_email';
  static const int pinLength = 6;

  /// True when a PIN has already been set for [email].
  Future<bool> hasPinFor(String email) async {
    final p = await SharedPreferences.getInstance();
    final h = p.getString(_kHash);
    final e = p.getString(_kEmail);
    return h != null && h.isNotEmpty && e == email;
  }

  Future<void> setPin(String email, String pin) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_kHash, _hash(email, pin));
    await p.setString(_kEmail, email);
  }

  Future<bool> verify(String email, String pin) async {
    final p = await SharedPreferences.getInstance();
    return p.getString(_kHash) == _hash(email, pin);
  }

  /// Removes the stored PIN (called on sign-out so the next account is clean).
  Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_kHash);
    await p.remove(_kEmail);
  }

  String _hash(String email, String pin) =>
      sha256.convert(utf8.encode('crms|$email|$pin')).toString();
}
