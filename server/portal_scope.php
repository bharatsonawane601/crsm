<?php
// Officer portal -> the list of scope options the officer can drill into:
//   CP  : All city + each zone
//   DCP : All <zone> + each division in that zone
//   ACP : All <division> + each station in that division
// Each option carries the filter the client sends back (zone_id / division_id /
// station_id), so the server stays the single source of truth for access.
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');
requireAppKey();

$body = jsonBody();
$email = strtolower(trim($body['email'] ?? ''));
if ($email === '') respond(['ok' => false, 'message' => 'access.error.server']);

$pdo = db();
$user = requireApprovedUser($pdo, $email);
$role = $user['role'] ?? 'station';

if (!in_array($role, ['acp', 'dcp', 'cp'], true)) {
    http_response_code(403);
    respond(['ok' => false, 'message' => 'access.error.server']);
}

$name = function (string $table, $id): ?string {
    if (empty($id)) return null;
    static $pdoRef;
    $pdoRef = db();
    $q = $pdoRef->prepare("SELECT name FROM `$table` WHERE id = ?");
    $q->execute([$id]);
    $n = $q->fetchColumn();
    return $n !== false ? $n : null;
};

$options = [];

if ($role === 'cp') {
    $options[] = ['label' => 'All city', 'type' => 'all'];
    foreach ($pdo->query('SELECT id, name FROM org_zones ORDER BY sort, id') as $z) {
        $options[] = ['label' => $z['name'], 'type' => 'zone', 'id' => (int) $z['id']];
    }
} elseif ($role === 'dcp') {
    $zoneId = (int) ($user['scope_zone_id'] ?? 0);
    $options[] = ['label' => 'All ' . ($name('org_zones', $zoneId) ?? 'zone'), 'type' => 'zone', 'id' => $zoneId];
    $q = $pdo->prepare('SELECT id, name FROM org_divisions WHERE zone_id = ? ORDER BY sort, id');
    $q->execute([$zoneId]);
    foreach ($q as $d) {
        $options[] = ['label' => $d['name'], 'type' => 'division', 'id' => (int) $d['id']];
    }
} else { // acp
    $divId = (int) ($user['scope_division_id'] ?? 0);
    $options[] = ['label' => 'All ' . ($name('org_divisions', $divId) ?? 'division'), 'type' => 'division', 'id' => $divId];
    $q = $pdo->prepare('SELECT id, name FROM org_stations WHERE division_id = ? ORDER BY sort, name');
    $q->execute([$divId]);
    foreach ($q as $s) {
        $options[] = ['label' => $s['name'], 'type' => 'station', 'id' => (int) $s['id']];
    }
}

respond(['ok' => true, 'role' => $role, 'options' => $options]);
