<?php
// Investigating-Officer portal sync: phone <-> central store <-> PC.
// Each IO case is stored as one row keyed by (owner_email, remote_uid) with the
// full case bundle (case + forms + parties + exhibits) in data_json. An IO only
// ever sees their OWN cases (scoped by owner_email = the approved account).
//
// Actions:
//   push : upsert a batch of the caller's cases (last write wins by updated_at).
//   pull : return all the caller's cases (optionally only those updated since).
//
// Binary media (scene photos) are NOT synced here yet — only case data.
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');
requireAppKey();

$body = jsonBody();
$email = strtolower(trim($body['email'] ?? ''));
$action = trim((string) ($body['action'] ?? 'pull'));
if ($email === '') {
    respond(['ok' => false, 'message' => 'access.error.server']);
}

$pdo = db();
requireApprovedUser($pdo, $email);

// Self-contained table (created on first use so db.php needs no edit).
$pdo->exec(
    'CREATE TABLE IF NOT EXISTS central_io_cases (
        id              BIGINT AUTO_INCREMENT PRIMARY KEY,
        owner_email     VARCHAR(190) NOT NULL,
        remote_uid      VARCHAR(80) NOT NULL,
        title           VARCHAR(255) NULL,
        crime_type      VARCHAR(190) NULL,
        crime_category  VARCHAR(190) NULL,
        fir_no          VARCHAR(80) NULL,
        year            INT NULL,
        district        VARCHAR(160) NULL,
        police_station  VARCHAR(160) NULL,
        status          VARCHAR(40) NULL,
        data_json       LONGTEXT NULL,
        client_updated  DATETIME NULL,
        updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        UNIQUE KEY uniq_owner_uid (owner_email, remote_uid),
        KEY idx_owner (owner_email)
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4'
);

$norm = function ($v): ?string {
    $v = trim((string) ($v ?? ''));
    return $v === '' ? null : $v;
};
$dt = function ($v): ?string {
    $v = trim((string) ($v ?? ''));
    if ($v === '') return null;
    $ts = strtotime($v);
    return $ts ? date('Y-m-d H:i:s', $ts) : null;
};

if ($action === 'push') {
    $cases = $body['cases'] ?? [];
    if (!is_array($cases)) respond(['ok' => false, 'message' => 'access.error.server']);

    $upsert = $pdo->prepare(
        'INSERT INTO central_io_cases
            (owner_email, remote_uid, title, crime_type, crime_category, fir_no,
             year, district, police_station, status, data_json, client_updated, updated_at)
         VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())
         ON DUPLICATE KEY UPDATE
            title = VALUES(title),
            crime_type = VALUES(crime_type),
            crime_category = VALUES(crime_category),
            fir_no = VALUES(fir_no),
            year = VALUES(year),
            district = VALUES(district),
            police_station = VALUES(police_station),
            status = VALUES(status),
            data_json = VALUES(data_json),
            client_updated = VALUES(client_updated),
            updated_at = NOW()'
    );

    $count = 0;
    $pdo->beginTransaction();
    try {
        foreach ($cases as $c) {
            if (!is_array($c)) continue;
            $uid = trim((string) ($c['uid'] ?? ''));
            if ($uid === '') continue;
            $upsert->execute([
                $email, $uid,
                $norm($c['title'] ?? null),
                $norm($c['crime_type'] ?? null),
                $norm($c['crime_category'] ?? null),
                $norm($c['fir_no'] ?? null),
                isset($c['year']) && is_numeric($c['year']) ? (int) $c['year'] : null,
                $norm($c['district'] ?? null),
                $norm($c['police_station'] ?? null),
                $norm($c['status'] ?? null),
                isset($c['data']) ? json_encode($c['data']) : null,
                $dt($c['updated_at'] ?? null),
            ]);
            $count++;
        }
        $pdo->commit();
    } catch (Throwable $e) {
        $pdo->rollBack();
        respond(['ok' => false, 'message' => 'access.error.server']);
    }
    respond(['ok' => true, 'saved' => $count]);
}

// Default: pull.
$since = $dt($body['since'] ?? null);
if ($since !== null) {
    $q = $pdo->prepare(
        'SELECT remote_uid, client_updated, updated_at, data_json
         FROM central_io_cases WHERE owner_email = ? AND updated_at > ?
         ORDER BY updated_at ASC'
    );
    $q->execute([$email, $since]);
} else {
    $q = $pdo->prepare(
        'SELECT remote_uid, client_updated, updated_at, data_json
         FROM central_io_cases WHERE owner_email = ? ORDER BY updated_at ASC'
    );
    $q->execute([$email]);
}

$cases = [];
foreach ($q->fetchAll() as $row) {
    $cases[] = [
        'uid' => $row['remote_uid'],
        'client_updated' => $row['client_updated'],
        'server_updated' => $row['updated_at'],
        'data' => $row['data_json'] !== null
            ? json_decode($row['data_json'], true) : null,
    ];
}
respond(['ok' => true, 'cases' => $cases]);
