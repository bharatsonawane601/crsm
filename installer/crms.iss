; ===========================================================================
; CRMS — Inno Setup installer script
; Builds the auto-updatable Windows installer (crms-setup-<version>.exe).
;
; HOW TO BUILD A RELEASE
;   1. Bump the version in pubspec.yaml, e.g.  version: 1.1.0+1
;      (only the part before "+" matters — the updater derives ordering from it;
;       just make it higher than the previous release.)
;   2. flutter build windows --release
;   3. Update #define MyAppVersion below to match (e.g. 1.1.0).
;   4. Open this file in Inno Setup Compiler and click Build (or run:
;        iscc installer\crms.iss   )
;   5. The installer is written to  installer\output\crms-setup-1.1.0.exe
;   6. Upload that file in the admin panel (App Updates). The version is detected
;      automatically from the file name; just add notes / tick "Mandatory".
;
; Per-user install (no admin / UAC) so silent auto-updates apply smoothly on
; locked-down police PCs.
; ===========================================================================

#define MyAppName "CRMS - Crime Records Management System"
#define MyAppShortName "CRMS"
#define MyAppVersion "1.15.9"
#define MyAppPublisher "DB Square Technology"
#define MyAppURL "https://dbsquaretechnology.com"
#define MyAppExeName "crms.exe"
; Path to the Flutter release build output (relative to this .iss file).
#define BuildDir "..\build\windows\x64\runner\Release"

[Setup]
; Keep this AppId STABLE across all versions so updates replace in place.
; Plain text (no braces) so editors can't mangle it on save.
AppId=CRMS-CrimeRecords-DBSquareTechnology
AppName={#MyAppName}
AppVersion={#MyAppVersion}
VersionInfoVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
DefaultDirName={localappdata}\Programs\{#MyAppShortName}
DisableProgramGroupPage=yes
DisableDirPage=yes
UninstallDisplayIcon={app}\{#MyAppExeName}
OutputDir=output
OutputBaseFilename=crms-setup-{#MyAppVersion}
Compression=lzma2
SolidCompression=yes
WizardStyle=modern
; Per-user: no admin prompt, so silent updates don't trigger UAC.
PrivilegesRequired=lowest
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
; Close the running app (via the Restart Manager) so locked files can be replaced.
CloseApplications=yes
RestartApplications=no

; --- Code signing (fixes the SmartScreen "Windows protected your PC" warning) ---
; The "don't run, it's harmful / unknown publisher" screen appears because the
; installer is UNSIGNED. The only real fix is to sign it with a code-signing
; certificate (this cannot be removed in code). Once you have a cert:
;   1. Inno Setup IDE -> Tools -> Configure Sign Tools... -> Add:
;        Name:    signtool
;        Command: "C:\Program Files (x86)\Windows Kits\10\bin\x64\signtool.exe" sign /fd sha256 /tr http://timestamp.digicert.com /td sha256 /a $f
;      (or /f "cert.pfx" /p PASSWORD instead of /a for a .pfx file)
;   2. Uncomment the two lines below and rebuild. This signs BOTH the bundled
;      crms.exe and the installer, so SmartScreen + antivirus trust them.
;   - OV certificate (~Rs 15-30k/yr): clears "unknown publisher"; SmartScreen
;     reputation builds up over downloads (warning fades after a while).
;   - EV certificate (USB token): SmartScreen trusts it INSTANTLY, no warning.
;SignTool=signtool
;SignedUninstaller=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"

[Files]
Source: "{#BuildDir}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#BuildDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
; Visual C++ runtime, shipped app-local (next to crms.exe) so the app launches on
; clean Windows 10 PCs that don't have the VC++ Redistributable installed — fixes
; the "msvcp140.dll / vcruntime140.dll is missing" error. No admin rights needed.
Source: "redist\msvcp140.dll";     DestDir: "{app}"; Flags: ignoreversion
Source: "redist\msvcp140_1.dll";   DestDir: "{app}"; Flags: ignoreversion
Source: "redist\msvcp140_2.dll";   DestDir: "{app}"; Flags: ignoreversion
Source: "redist\vcruntime140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "redist\vcruntime140_1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "redist\concrt140.dll";    DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppShortName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppShortName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
; Relaunch after install — runs in both interactive and silent (auto-update) mode.
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#MyAppShortName}}"; Flags: nowait postinstall
