<?php
// The single endpoint the app calls on every launch. It records a pending
// request the first time it sees an email, then returns the current status and
// enforces the one-device (HWID) binding.
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');

// 1) Shared-key gate so random callers can't hit the API.
$appKey = $_SERVER['HTTP_X_APP_KEY'] ?? '';
if (!hash_equals(APP_KEY, $appKey)) {
    http_response_code(401);
    respond(['ok' => false, 'message' => 'access.error.server']);
}

// 2) Read JSON body.
$body = json_decode(file_get_contents('php://input'), true) ?? [];
$email = strtolower(trim($body['email'] ?? ''));
$hwid = trim($body['hwid'] ?? '');
$name = trim($body['name'] ?? '');
$idToken = trim($body['id_token'] ?? '');

// Security / audit context for this check-in.
$ip = clientIp();
$ua = substr(trim($_SERVER['HTTP_USER_AGENT'] ?? ''), 0, 255);
$platform = substr(strtolower(trim($body['platform'] ?? '')), 0, 20);  // windows | macos
$clientOs = substr(trim($body['os'] ?? ''), 0, 160);                   // e.g. "Windows 11 (10.0.26100)"
$device = substr(trim($body['device'] ?? ''), 0, 190);                 // computer name / model
$appVer = substr(trim($body['app_version'] ?? ''), 0, 40);

if ($email === '' || $hwid === '') {
    respond(['ok' => false, 'message' => 'access.error.server']);
}

// 3) Optionally verify the Google id_token (recommended once real OAuth is in).
if (VERIFY_GOOGLE_TOKEN) {
    $verifiedEmail = verifyGoogleToken($idToken);
    if ($verifiedEmail === null || strtolower($verifiedEmail) !== $email) {
        respond(['ok' => false, 'message' => 'access.error.server']);
    }
}

$pdo = db();

// 4) Look up (or create) the user.
$stmt = $pdo->prepare('SELECT * FROM access_users WHERE email = ?');
$stmt->execute([$email]);
$user = $stmt->fetch();

if (!$user) {
    $ins = $pdo->prepare(
        'INSERT INTO access_users
            (email, name, hwid, status, last_seen_at,
             last_ip, user_agent, client_platform, client_os, client_device, app_version)
         VALUES (?, ?, ?, "pending", NOW(), ?, ?, ?, ?, ?, ?)'
    );
    $ins->execute([$email, $name, $hwid, $ip, $ua, $platform, $clientOs, $device, $appVer]);
    respond(['ok' => true, 'status' => 'pending']);
}

// Touch last-seen and refresh the security/audit fields for this check-in.
$pdo->prepare(
    'UPDATE access_users
        SET last_seen_at = NOW(), last_ip = ?, user_agent = ?,
            client_platform = ?, client_os = ?, client_device = ?, app_version = ?
      WHERE id = ?'
)->execute([$ip, $ua, $platform, $clientOs, $device, $appVer, $user['id']]);

if ($user['status'] === 'denied') respond(['ok' => true, 'status' => 'denied']);
if ($user['status'] === 'pending') respond(['ok' => true, 'status' => 'pending']);

// status === approved → check the subscription window first.
if (!empty($user['expires_at']) && strtotime($user['expires_at']) < time()) {
    respond(['ok' => true, 'status' => 'expired']);
}

// then enforce device binding.
if (ONE_DEVICE_PER_EMAIL) {
    if (empty($user['hwid'])) {
        // First approved device — bind it now.
        $pdo->prepare('UPDATE access_users SET hwid = ? WHERE id = ?')
            ->execute([$hwid, $user['id']]);
    } elseif (!hash_equals($user['hwid'], $hwid)) {
        respond(['ok' => true, 'status' => 'device_mismatch']);
    }
}

// Tell the app which experience to load: a 'station' user gets the full
// data-entry app; an acp/dcp/cp gets the read-only officer portal. The scope
// labels are sent for display on the portal header.
$role = $user['role'] ?? 'station';
$scope = scopeLabels($pdo, $user);
respond([
    'ok' => true,
    'status' => 'approved',
    'role' => $role,
    'portal' => in_array($role, ['acp', 'dcp', 'cp'], true),
    'scope' => $scope,
]);

/// Human-readable scope labels (zone / division / station names) for the
/// portal header, based on the user's role + scope ids.
function scopeLabels(PDO $pdo, array $user): array
{
    $out = ['zone' => null, 'division' => null, 'station' => null];
    $name = function (string $table, $id) use ($pdo): ?string {
        if (empty($id)) return null;
        $q = $pdo->prepare("SELECT name FROM `$table` WHERE id = ?");
        $q->execute([$id]);
        $n = $q->fetchColumn();
        return $n !== false ? $n : null;
    };
    $out['zone'] = $name('org_zones', $user['scope_zone_id'] ?? null);
    $out['division'] = $name('org_divisions', $user['scope_division_id'] ?? null);
    $out['station'] = $name('org_stations', $user['scope_station_id'] ?? null);
    return $out;
}

/// Verifies a Google ID token via Google's tokeninfo endpoint and returns the
/// email if valid and issued for our client ID, else null.
function verifyGoogleToken(string $idToken): ?string
{
    if ($idToken === '') return null;
    $url = 'https://oauth2.googleapis.com/tokeninfo?id_token=' . urlencode($idToken);
    $resp = @file_get_contents($url);
    if ($resp === false) return null;
    $data = json_decode($resp, true);
    if (!is_array($data)) return null;
    if (($data['aud'] ?? '') !== GOOGLE_CLIENT_ID) return null;
    if (($data['email_verified'] ?? 'false') !== 'true' && ($data['email_verified'] ?? false) !== true) {
        return null;
    }
    return $data['email'] ?? null;
}
