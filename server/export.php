<?php
// Bulk export for the new self-hosted mirror server. App-key gated, read-only.
// The Go server on the Proxmox VM polls this endpoint to keep its PostgreSQL
// copy in sync with this (Hostinger) install until the final cutover.
//
// Body: { "table": <name>, "mode": "rows"|"ids",
//         "since": <datetime>, "after_id": <int>, "limit": <int> }
//   - Small tables ignore since/after_id and return everything.
//   - central_crimes / central_io_cases page by (updated_at, id) so the mirror
//     can pull increments cheaply.
//   - mode=ids returns just the identity pairs, letting the mirror detect rows
//     deleted here without re-downloading everything.
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');
requireAppKey();

$body = jsonBody();
$table = trim((string) ($body['table'] ?? ''));
$mode = ($body['mode'] ?? 'rows') === 'ids' ? 'ids' : 'rows';
$since = trim((string) ($body['since'] ?? ''));
$afterId = isset($body['after_id']) && is_numeric($body['after_id']) ? (int) $body['after_id'] : 0;
$limit = isset($body['limit']) && is_numeric($body['limit']) ? (int) $body['limit'] : 500;
$limit = max(1, min(2000, $limit));

$pdo = db();

// Ensure the IO cases table exists even if io_sync.php has never run.
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

// Whitelisted tables with explicit column lists — nothing else is exportable.
$small = [
    'org_zones' => 'id, name, name_mr, sort',
    'org_divisions' => 'id, zone_id, name, name_mr, sort',
    'org_stations' => 'id, division_id, name, name_mr, code, sort',
    'access_users' => 'id, email, name, status, hwid, role,
        scope_zone_id, scope_division_id, scope_station_id,
        requested_at, decided_at, expires_at, last_seen_at,
        last_ip, user_agent, client_platform, client_os, client_device, app_version',
    'app_release' => 'id, version, build, platform, file_name, notes, mandatory, sha256, created_at',
    'central_suppressed' => 'owner_email, remote_uid, suppressed_at',
    'central_deletions' => 'id, owner_email, remote_uid, fir_no, year, station_name,
        src_device, src_platform, src_os, src_ip, deleted_at',
    'central_trash' => 'id, ' . CENTRAL_COLS . ', deleted_by, deleted_at',
];

if (isset($small[$table])) {
    $rows = $pdo->query("SELECT {$small[$table]} FROM `$table`")->fetchAll();
    respond(['ok' => true, 'rows' => $rows, 'server_time' => gmdate('Y-m-d H:i:s')]);
}

if ($table === 'central_crimes' || $table === 'central_io_cases') {
    if ($mode === 'ids') {
        $rows = $pdo->query("SELECT owner_email, remote_uid FROM `$table`")->fetchAll();
        respond(['ok' => true, 'rows' => $rows, 'server_time' => gmdate('Y-m-d H:i:s')]);
    }
    $cols = $table === 'central_crimes'
        ? 'id, ' . CENTRAL_COLS . ', updated_at'
        : 'id, owner_email, remote_uid, title, crime_type, crime_category, fir_no,
           year, district, police_station, status, data_json, client_updated, updated_at';
    if ($since !== '') {
        $q = $pdo->prepare(
            "SELECT $cols FROM `$table`
              WHERE updated_at > ? OR (updated_at = ? AND id > ?)
              ORDER BY updated_at, id LIMIT $limit"
        );
        $q->execute([$since, $since, $afterId]);
    } else {
        $q = $pdo->prepare("SELECT $cols FROM `$table` ORDER BY updated_at, id LIMIT $limit");
        $q->execute();
    }
    respond(['ok' => true, 'rows' => $q->fetchAll(), 'server_time' => gmdate('Y-m-d H:i:s')]);
}

respond(['ok' => false, 'message' => 'unknown table']);
