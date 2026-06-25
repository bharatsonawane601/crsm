<?php
// Station app -> central store: report a FIR deletion. Logs the deletion to
// central_deletions (who / what / which device / when) and removes the central
// copy so the officer portal no longer shows it. Best-effort from the app's
// side; safe to call even if the record was never uploaded.
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');
requireAppKey();

$body = jsonBody();
$email = strtolower(trim($body['email'] ?? ''));
$uid = trim((string) ($body['uid'] ?? ''));
if ($email === '') {
    respond(['ok' => false, 'message' => 'access.error.server']);
}

// Source device/IP of the deletion.
$srcIp = clientIp();
$srcPlatform = substr(strtolower(trim($body['platform'] ?? '')), 0, 20);
$srcOs = substr(trim($body['os'] ?? ''), 0, 160);
$srcDevice = substr(trim($body['device'] ?? ''), 0, 190);

$pdo = db();
$user = requireApprovedUser($pdo, $email);

$norm = function ($v): ?string {
    $v = trim((string) ($v ?? ''));
    return $v === '' ? null : $v;
};

// Prefer the details from the central copy (authoritative), fall back to what
// the app sent in case the record was never uploaded.
$firNo = $norm($body['fir_no'] ?? null);
$year = isset($body['year']) && is_numeric($body['year']) ? (int) $body['year'] : null;
$station = $norm($body['police_station'] ?? null);

if ($uid !== '') {
    $q = $pdo->prepare(
        'SELECT fir_no, year, station_name FROM central_crimes
         WHERE owner_email = ? AND remote_uid = ?'
    );
    $q->execute([$email, $uid]);
    if ($existing = $q->fetch()) {
        $firNo = $existing['fir_no'] ?? $firNo;
        $year = $existing['year'] !== null ? (int) $existing['year'] : $year;
        $station = $existing['station_name'] ?? $station;
    }
}

$pdo->prepare(
    'INSERT INTO central_deletions
        (owner_email, remote_uid, fir_no, year, station_name,
         src_device, src_platform, src_os, src_ip)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)'
)->execute([
    $email, $norm($uid), $firNo, $year, $station,
    $norm($srcDevice), $norm($srcPlatform), $norm($srcOs), $norm($srcIp),
]);

// Move the central copy to the 30-day recycle bin, then remove it so the portal
// stops showing the deleted FIR (recoverable by the admin if it was deleted in
// error or maliciously).
if ($uid !== '') {
    $pdo->prepare(
        'INSERT INTO central_trash (' . CENTRAL_COLS . ', deleted_by)
         SELECT ' . CENTRAL_COLS . ', ? FROM central_crimes
          WHERE owner_email = ? AND remote_uid = ?'
    )->execute([$email, $email, $uid]);
    $pdo->prepare('DELETE FROM central_crimes WHERE owner_email = ? AND remote_uid = ?')
        ->execute([$email, $uid]);
}

respond(['ok' => true]);
