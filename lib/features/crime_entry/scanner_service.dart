import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Acquires a page from a connected document scanner.
///
/// - **Windows**: uses the built-in WIA (Windows Image Acquisition) stack via a
///   short PowerShell script. WIA shows the OS scan dialog (device picker +
///   preview), so any TWAIN/WIA scanner the user has installed works with no
///   extra drivers. The page is saved as JPEG.
/// - **Linux**: uses SANE's `scanimage` (install with `sudo apt install
///   sane-utils`). The first detected scanner is used.
///
/// Returns the path to the scanned JPEG, or `null` if the user cancelled.
/// Throws [ScannerException] when no scanner / tooling is available so the UI
/// can show a clear message.
class ScannerService {
  const ScannerService();

  static bool get isSupported => Platform.isWindows || Platform.isLinux;

  Future<String?> scanToFile() async {
    final dir = await getTemporaryDirectory();
    final outPath = p.join(
        dir.path, 'crms_scan_${DateTime.now().millisecondsSinceEpoch}.jpg');

    if (Platform.isWindows) {
      return _scanWindows(dir, outPath);
    }
    if (Platform.isLinux) {
      return _scanLinux(outPath);
    }
    throw const ScannerException('Scanning is only supported on Windows/Linux.');
  }

  // --- Windows (WIA via PowerShell) ----------------------------------------
  Future<String?> _scanWindows(Directory dir, String outPath) async {
    // JPEG format GUID for WIA's ShowAcquireImage.
    const jpegFormat = '{B96B3CAE-0728-11D3-9D7B-0000F81EF32E}';
    final script = '''
param([string]\$OutPath)
\$ErrorActionPreference = 'Stop'
try { \$cd = New-Object -ComObject WIA.CommonDialog }
catch { Write-Error 'WIA-UNAVAILABLE'; exit 2 }
# ShowAcquireImage(DeviceType=Scanner, Intent=Unspecified, Bias=MaxQuality,
#                  FormatID=JPEG, AlwaysSelectDevice, UseCommonUI, CancelError)
\$img = \$cd.ShowAcquireImage(1, 0, 131072, '$jpegFormat', \$false, \$true, \$false)
if (\$null -eq \$img) { exit 3 }   # user cancelled
if (Test-Path -LiteralPath \$OutPath) { Remove-Item -LiteralPath \$OutPath -Force }
\$img.SaveFile(\$OutPath)
exit 0
''';
    final scriptFile = File(p.join(dir.path, 'crms_wia_scan.ps1'));
    await scriptFile.writeAsString(script);

    final result = await Process.run(
      'powershell',
      [
        '-NoProfile',
        '-NonInteractive',
        '-ExecutionPolicy',
        'Bypass',
        '-File',
        scriptFile.path,
        outPath,
      ],
    );
    if (result.exitCode == 3) return null; // cancelled
    if (result.exitCode == 2) {
      throw const ScannerException(
          'Windows scanning (WIA) is not available on this PC.');
    }
    if (result.exitCode != 0 || !File(outPath).existsSync()) {
      final err = result.stderr.toString().trim();
      throw ScannerException(
          err.contains('WIA-UNAVAILABLE') || err.isEmpty
              ? 'No scanner found. Connect a scanner and try again.'
              : err);
    }
    return outPath;
  }

  // --- Linux (SANE scanimage) ----------------------------------------------
  Future<String?> _scanLinux(String outPath) async {
    ProcessResult result;
    try {
      result = await Process.run(
        'scanimage',
        ['--format=jpeg', '--output-file', outPath],
      );
    } on ProcessException {
      throw const ScannerException(
          'scanimage not found. Install it with: sudo apt install sane-utils');
    }
    if (result.exitCode != 0 || !File(outPath).existsSync()) {
      final err = result.stderr.toString().trim();
      throw ScannerException(
          err.isEmpty ? 'No scanner found or scan failed.' : err);
    }
    return outPath;
  }
}

/// Thrown when scanning can't proceed (no scanner, missing tooling, error).
class ScannerException implements Exception {
  const ScannerException(this.message);
  final String message;
  @override
  String toString() => message;
}
