<?php
// Officer portal -> all scope-filtered crime rows for the analytics dashboard.
// Read-only. The client aggregates these into the charts (same engine the
// station app uses), so every chart works across the officer's jurisdiction.
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');
requireAppKey();

$body = jsonBody();
$email = strtolower(trim($body['email'] ?? ''));
if ($email === '') respond(['ok' => false, 'message' => 'access.error.server']);

$pdo = db();
$user = requireApprovedUser($pdo, $email);

if (!in_array($user['role'], ['acp', 'dcp', 'cp'], true)) {
    http_response_code(403);
    respond(['ok' => false, 'message' => 'access.error.server']);
}

$scope = effectiveScope($pdo, $user, $body);
[$scopeSql, $params] = scopeWhere($scope);
$where = $scopeSql === '' ? '' : "WHERE $scopeSql";

// Cap to keep the payload sane; dashboards summarise, so this is plenty.
$stmt = $pdo->prepare(
    "SELECT id, station_name, fir_no, year, crime_type, section, status,
            date_occurred, date_registered, data_json
     FROM central_crimes $where
     ORDER BY id DESC
     LIMIT 20000"
);
$stmt->execute($params);

$rows = [];
foreach ($stmt->fetchAll() as $r) {
    $r['data'] = $r['data_json'] ? json_decode($r['data_json'], true) : null;
    unset($r['data_json']);
    $rows[] = $r;
}

respond(['ok' => true, 'rows' => $rows]);
