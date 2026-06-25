import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// This device's platform / OS / name / app version, sent to the server so it
/// can record the source of every access check-in, FIR upload and deletion for
/// security auditing in the admin panel. Best-effort: any failure just omits
/// that field rather than blocking the request.
Future<Map<String, String>> clientDeviceMeta() async {
  final out = <String, String>{
    'platform': Platform.isMacOS
        ? 'macos'
        : Platform.isLinux
            ? 'linux'
            : 'windows',
  };
  try {
    final plugin = DeviceInfoPlugin();
    if (Platform.isMacOS) {
      final m = await plugin.macOsInfo;
      out['os'] =
          'macOS ${m.majorVersion}.${m.minorVersion}.${m.patchVersion}';
      out['device'] = m.computerName.isNotEmpty ? m.computerName : m.model;
    } else if (Platform.isLinux) {
      final l = await plugin.linuxInfo;
      out['os'] = l.prettyName.isNotEmpty ? l.prettyName : l.name;
      final machineId = l.machineId ?? '';
      out['device'] = machineId.isNotEmpty ? machineId : l.name;
    } else {
      final w = await plugin.windowsInfo;
      out['os'] =
          '${w.productName} (${w.majorVersion}.${w.minorVersion}.${w.buildNumber})';
      out['device'] = w.computerName;
    }
  } catch (_) {
    // Leave os/device unset if device_info is unavailable.
  }
  try {
    out['app_version'] = (await PackageInfo.fromPlatform()).version;
  } catch (_) {/* omit */}
  return out;
}
