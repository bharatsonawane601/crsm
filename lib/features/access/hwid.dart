import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Computes a stable hardware fingerprint for this device. We hash a per-machine
/// id + machine name with SHA-256, giving a 64-char id that stays the same
/// across reboots/app updates but changes if the OS is reinstalled. The access
/// server binds an approved email to this value so the login works on one
/// device only.
///
/// - Windows: MachineGuid (`deviceId`) + computer name.
/// - macOS:   IOPlatformUUID (`systemGUID`) + computer name. All Apple Silicon
///            (M1–M5) and Intel Macs expose this, so a single build covers them.
Future<String> computeHwid() async {
  final plugin = DeviceInfoPlugin();
  String raw;
  if (Platform.isMacOS) {
    final info = await plugin.macOsInfo;
    raw = '${info.systemGUID ?? info.model}|${info.computerName}';
  } else {
    final info = await plugin.windowsInfo;
    raw = '${info.deviceId}|${info.computerName}';
  }
  return sha256.convert(utf8.encode(raw)).toString();
}
