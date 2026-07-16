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
// The station name is the canonical org_stations one when the record is
// linked, so "दौलताबाद" and "Daulatabad" chart as ONE station.
$stmt = $pdo->prepare(
    "SELECT c.id, COALESCE(s.name, c.station_name) AS station_name, c.fir_no,
            c.year, c.crime_type, c.section, c.status,
            c.date_occurred, c.date_registered, c.data_json
     FROM central_crimes c
     LEFT JOIN org_stations s ON c.station_id = s.id
     $where
     ORDER BY c.id DESC
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
