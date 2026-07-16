<?php
// Officer portal -> the list of scope options the officer can drill into. Every
// rank gets the FULL hierarchy it is allowed to see, so it can filter at any
// level (whole jurisdiction / a zone / a division-ACP / a single police station):
//   CP  : All city + each zone + every division + every station (indented tree)
//   DCP : All <zone> + each division in the zone + every station in the zone
//   ACP : All <division> + each station in the division
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

// Appends every station in a division as an indented, selectable option.
$addStations = function (int $divisionId, string $indent) use ($pdo, &$options): void {
    $sq = $pdo->prepare('SELECT id, name FROM org_stations WHERE division_id = ? ORDER BY sort, name');
    $sq->execute([$divisionId]);
    foreach ($sq as $s) {
        $options[] = ['label' => $indent . $s['name'], 'type' => 'station', 'id' => (int) $s['id']];
    }
};

// Appends each division in a zone, then that division's stations (one level down).
$addDivisions = function (int $zoneId) use ($pdo, &$options, $addStations): void {
    $dq = $pdo->prepare('SELECT id, name FROM org_divisions WHERE zone_id = ? ORDER BY sort, id');
    $dq->execute([$zoneId]);
    foreach ($dq as $d) {
        $did = (int) $d['id'];
        $options[] = ['label' => '   ↳ ' . $d['name'] . ' (ACP)', 'type' => 'division', 'id' => $did];
        $addStations($did, '        • ');
    }
};

if ($role === 'cp') {
    $options[] = ['label' => 'All city', 'type' => 'all'];
    foreach ($pdo->query('SELECT id, name FROM org_zones ORDER BY sort, id') as $z) {
        $zid = (int) $z['id'];
        $options[] = ['label' => $z['name'] . ' — whole zone', 'type' => 'zone', 'id' => $zid];
        $addDivisions($zid);
    }
    // Stations not yet assigned to any division are visible to the CP only.
    $uq = $pdo->query('SELECT id, name FROM org_stations WHERE division_id IS NULL ORDER BY sort, name');
    foreach ($uq as $s) {
        $options[] = ['label' => '• ' . $s['name'] . ' (unassigned)', 'type' => 'station', 'id' => (int) $s['id']];
    }
} elseif ($role === 'dcp') {
    $zoneId = (int) ($user['scope_zone_id'] ?? 0);
    $options[] = ['label' => 'All ' . ($name('org_zones', $zoneId) ?? 'zone') . ' — whole zone', 'type' => 'zone', 'id' => $zoneId];
    $addDivisions($zoneId);
} else { // acp
    $divId = (int) ($user['scope_division_id'] ?? 0);
    $options[] = ['label' => 'All ' . ($name('org_divisions', $divId) ?? 'division'), 'type' => 'division', 'id' => $divId];
    $addStations($divId, '   • ');
}

// --- Structured org lists (scoped) for the three cascading dropdowns and the
// comparison picker in the app. Each row carries its parent ids so the client
// can cascade Zone -> ACP -> Police Station and offer independent selection.
$zones = [];
$divisions = [];
$stations = [];

if ($role === 'cp') {
    foreach ($pdo->query('SELECT id, name FROM org_zones ORDER BY sort, id') as $z) {
        $zones[] = ['id' => (int) $z['id'], 'name' => $z['name']];
    }
    foreach ($pdo->query('SELECT id, name, zone_id FROM org_divisions ORDER BY sort, id') as $d) {
        $divisions[] = ['id' => (int) $d['id'], 'name' => $d['name'], 'zone_id' => (int) $d['zone_id']];
    }
    foreach ($pdo->query('SELECT s.id, s.name, s.division_id, d.zone_id
                          FROM org_stations s LEFT JOIN org_divisions d ON s.division_id = d.id
                          ORDER BY s.sort, s.name') as $s) {
        $stations[] = ['id' => (int) $s['id'], 'name' => $s['name'],
            'division_id' => $s['division_id'] !== null ? (int) $s['division_id'] : null,
            'zone_id' => $s['zone_id'] !== null ? (int) $s['zone_id'] : null];
    }
} elseif ($role === 'dcp') {
    $zoneId = (int) ($user['scope_zone_id'] ?? 0);
    if (($zn = $name('org_zones', $zoneId)) !== null) $zones[] = ['id' => $zoneId, 'name' => $zn];
    $dq = $pdo->prepare('SELECT id, name, zone_id FROM org_divisions WHERE zone_id = ? ORDER BY sort, id');
    $dq->execute([$zoneId]);
    foreach ($dq as $d) $divisions[] = ['id' => (int) $d['id'], 'name' => $d['name'], 'zone_id' => (int) $d['zone_id']];
    $sq = $pdo->prepare('SELECT s.id, s.name, s.division_id, d.zone_id
                         FROM org_stations s JOIN org_divisions d ON s.division_id = d.id
                         WHERE d.zone_id = ? ORDER BY s.sort, s.name');
    $sq->execute([$zoneId]);
    foreach ($sq as $s) $stations[] = ['id' => (int) $s['id'], 'name' => $s['name'],
        'division_id' => (int) $s['division_id'], 'zone_id' => (int) $s['zone_id']];
} else { // acp
    $divId = (int) ($user['scope_division_id'] ?? 0);
    $dz = $pdo->prepare('SELECT zone_id FROM org_divisions WHERE id = ?');
    $dz->execute([$divId]);
    $zoneId = (int) ($dz->fetchColumn() ?: 0);
    if ($zoneId > 0 && ($zn = $name('org_zones', $zoneId)) !== null) $zones[] = ['id' => $zoneId, 'name' => $zn];
    if (($dn = $name('org_divisions', $divId)) !== null) {
        $divisions[] = ['id' => $divId, 'name' => $dn, 'zone_id' => $zoneId];
    }
    $sq = $pdo->prepare('SELECT id, name, division_id FROM org_stations WHERE division_id = ? ORDER BY sort, name');
    $sq->execute([$divId]);
    foreach ($sq as $s) $stations[] = ['id' => (int) $s['id'], 'name' => $s['name'],
        'division_id' => (int) $s['division_id'], 'zone_id' => $zoneId];
}

respond([
    'ok' => true,
    'role' => $role,
    'options' => $options, // legacy flat tree (older app builds)
    'zones' => $zones,
    'divisions' => $divisions,
    'stations' => $stations,
]);
