# CRMS - Windows release build.
#
# ALWAYS build the Windows release with this script. It reads every secret from
# crms.env and passes ALL of them to flutter as --dart-define, so a build can
# never silently ship with a missing define. Hand-typing the flutter command is
# what once produced an exe with the demo login (missing CRMS_GOOGLE_CLIENT_ID)
# and no app key (missing CRMS_APP_KEY) - don't do that.
#
# Usage (from repo root):   powershell -File installer\build_windows.ps1
# Then compile the installer:  & "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe" installer\crms.iss
#
# Required in crms.env: CRMS_APP_KEY, CRMS_GOOGLE_CLIENT_ID,
#   CRMS_GOOGLE_CLIENT_SECRET, CRMS_API_BASE_URL. CRMS_FIELD_KEY optional.

$ErrorActionPreference = 'Stop'
$repo = Split-Path -Parent $PSScriptRoot
$envFile = Join-Path $repo 'crms.env'
if (-not (Test-Path $envFile)) { throw "crms.env not found at $envFile" }

# Parse KEY=VALUE lines (ignore blanks / comments).
$vars = @{}
foreach ($line in Get-Content $envFile) {
  $t = $line.Trim()
  if ($t -eq '' -or $t.StartsWith('#')) { continue }
  $i = $t.IndexOf('=')
  if ($i -lt 1) { continue }
  $vars[$t.Substring(0, $i).Trim()] = $t.Substring($i + 1).Trim()
}

# Every define that MUST be present, or the app silently degrades:
#  - CRMS_API_BASE_URL missing:  talks to the wrong/backup server
#  - CRMS_APP_KEY missing:       access gate open + can't auth to server
#  - CRMS_GOOGLE_CLIENT_ID miss: falls back to the demo auto-login stub
#  - CRMS_GOOGLE_CLIENT_SECRET:  Google OAuth token exchange fails
$required = @('CRMS_API_BASE_URL','CRMS_APP_KEY','CRMS_GOOGLE_CLIENT_ID','CRMS_GOOGLE_CLIENT_SECRET')
$missing = $required | Where-Object { -not $vars.ContainsKey($_) -or $vars[$_] -eq '' }
if ($missing) { throw "crms.env is missing required keys: $($missing -join ', ')" }

$defines = @()
foreach ($k in $required) { $defines += @('--dart-define', "$k=$($vars[$k])") }
if ($vars.ContainsKey('CRMS_FIELD_KEY') -and $vars['CRMS_FIELD_KEY'] -ne '') {
  $defines += @('--dart-define', "CRMS_FIELD_KEY=$($vars['CRMS_FIELD_KEY'])")
}

$flutter = 'C:\flutter\bin\flutter.bat'
if (-not (Test-Path $flutter)) { $flutter = 'flutter' }

Write-Host "Building Windows release with $($required.Count) defines from crms.env..." -ForegroundColor Cyan
Push-Location $repo
try {
  & $flutter build windows --release @defines
  if ($LASTEXITCODE -ne 0) { throw "flutter build failed ($LASTEXITCODE)" }
} finally { Pop-Location }

# Self-check: the built AOT snapshot must contain the office host and NOT the
# old Hostinger one. Catches a bad build before it ever reaches a station.
$so = Join-Path $repo 'build\windows\x64\runner\Release\data\app.so'
$text = [System.Text.Encoding]::ASCII.GetString([System.IO.File]::ReadAllBytes($so))
$hostRefs = ([regex]::Matches($text, 'tailcbd550')).Count
$badRefs  = ([regex]::Matches($text, 'hostingersite')).Count
Write-Host "app.so check -> office-host refs: $hostRefs, hostinger refs: $badRefs" -ForegroundColor Yellow
if ($hostRefs -lt 1) { throw "Built app.so does NOT contain the office server URL - aborting." }
if ($badRefs  -gt 0) { throw "Built app.so still references Hostinger - aborting." }
Write-Host "Build OK: build\windows\x64\runner\Release\crms.exe" -ForegroundColor Green
