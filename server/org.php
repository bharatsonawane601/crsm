<?php
// Returns the org tree (zones -> divisions -> stations) for admin dropdowns and
// the app. Read-only; gated by the shared app key.
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');

$appKey = $_SERVER['HTTP_X_APP_KEY'] ?? '';
if (!hash_equals(APP_KEY, $appKey)) {
    http_response_code(401);
    respond(['ok' => false, 'message' => 'access.error.server']);
}

$pdo = db();

$zones = $pdo->query('SELECT id, name, name_mr FROM org_zones ORDER BY sort, id')
    ->fetchAll();
$divisions = $pdo->query(
    'SELECT id, zone_id, name, name_mr FROM org_divisions ORDER BY sort, id'
)->fetchAll();
$stations = $pdo->query(
    'SELECT id, division_id, name, name_mr, code FROM org_stations ORDER BY sort, name'
)->fetchAll();

respond([
    'ok' => true,
    'zones' => $zones,
    'divisions' => $divisions,
    'stations' => $stations,
]);
