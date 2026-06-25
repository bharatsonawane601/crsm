<?php
// Station app -> central store. Receives a batch of crime/FIR records and
// upserts them by (owner_email, remote_uid) so re-uploads update in place.
// Each record is tagged with its own police station (resolved to a station id)
// so senior officers can search across their jurisdiction.
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');
requireAppKey();

$body = jsonBody();
$email = strtolower(trim($body['email'] ?? ''));
$records = $body['records'] ?? [];
// The machine's own station — used to tag records whose police_station field
// was left blank (common in imported data), so they still scope to a station.
$defaultStation = trim((string) ($body['default_station'] ?? ''));
if ($email === '' || !is_array($records)) {
    respond(['ok' => false, 'message' => 'access.error.server']);
}

// Source device/IP for this upload — recorded against every FIR for auditing.
$srcIp = clientIp();
$srcPlatform = substr(strtolower(trim($body['platform'] ?? '')), 0, 20);
$srcOs = substr(trim($body['os'] ?? ''), 0, 160);
$srcDevice = substr(trim($body['device'] ?? ''), 0, 190);

$pdo = db();
$user = requireApprovedUser($pdo, $email);

// FIRs the admin deleted from the central store: skip them so they are not
// re-created when this station syncs again.
$suppressed = [];
$sq = $pdo->prepare('SELECT remote_uid FROM central_suppressed WHERE owner_email = ?');
$sq->execute([$email]);
foreach ($sq->fetchAll(PDO::FETCH_COLUMN) as $u) $suppressed[(string) $u] = true;

// Cache station name -> id lookups for this batch.
$stationIdByName = [];
$lookup = function (?string $name) use ($pdo, &$stationIdByName): ?int {
    $name = trim((string) $name);
    if ($name === '') return null;
    if (array_key_exists($name, $stationIdByName)) return $stationIdByName[$name];
    $q = $pdo->prepare('SELECT id FROM org_stations WHERE name = ?');
    $q->execute([$name]);
    $id = $q->fetchColumn();
    return $stationIdByName[$name] = ($id !== false ? (int) $id : null);
};

$upsert = $pdo->prepare(
    'INSERT INTO central_crimes
        (owner_email, remote_uid, station_id, station_name, fir_no, year,
         crime_type, section, status, date_occurred, date_registered,
         data_json, src_device, src_platform, src_os, src_ip, updated_at)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
     ON DUPLICATE KEY UPDATE
        station_id = VALUES(station_id),
        station_name = VALUES(station_name),
        fir_no = VALUES(fir_no),
        year = VALUES(year),
        crime_type = VALUES(crime_type),
        section = VALUES(section),
        status = VALUES(status),
        date_occurred = VALUES(date_occurred),
        date_registered = VALUES(date_registered),
        data_json = VALUES(data_json),
        src_device = VALUES(src_device),
        src_platform = VALUES(src_platform),
        src_os = VALUES(src_os),
        src_ip = VALUES(src_ip),
        updated_at = NOW()'
);

$norm = function ($v): ?string {
    $v = trim((string) ($v ?? ''));
    return $v === '' ? null : $v;
};
$date = function ($v): ?string {
    $v = trim((string) ($v ?? ''));
    if ($v === '') return null;
    $ts = strtotime($v);
    return $ts ? date('Y-m-d', $ts) : null;
};

$count = 0;
$pdo->beginTransaction();
try {
    foreach ($records as $r) {
        if (!is_array($r)) continue;
        $uid = trim((string) ($r['uid'] ?? ''));
        if ($uid === '') continue;
        if (isset($suppressed[$uid])) continue; // admin removed this FIR
        $stationName = trim((string) ($r['police_station'] ?? ''));
        if ($stationName === '') $stationName = $defaultStation;
        $upsert->execute([
            $email,
            $uid,
            $lookup($stationName),
            $norm($stationName),
            $norm($r['fir_no'] ?? null),
            isset($r['year']) && is_numeric($r['year']) ? (int) $r['year'] : null,
            $norm($r['crime_type'] ?? null),
            $norm($r['section'] ?? null),
            $norm($r['status'] ?? null),
            $date($r['date_occurred'] ?? null),
            $date($r['date_registered'] ?? null),
            isset($r['data']) ? json_encode($r['data']) : null,
            $norm($srcDevice), $norm($srcPlatform), $norm($srcOs), $norm($srcIp),
        ]);
        $count++;
    }
    $pdo->commit();
} catch (Throwable $e) {
    $pdo->rollBack();
    respond(['ok' => false, 'message' => 'access.error.server']);
}

respond(['ok' => true, 'saved' => $count]);
