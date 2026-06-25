<?php
// ONE-TIME migration: add Zone 2's two ACP divisions and map their stations,
// for servers whose org tree was seeded before Zone 2 had divisions.
// Idempotent — safe to run more than once. DELETE this file after running.
require_once __DIR__ . '/db.php';
session_start();
if (empty($_SESSION['admin'])) {
    http_response_code(403);
    exit('Sign in to admin.php first, then reload this page.');
}

header('Content-Type: text/plain; charset=utf-8');

// Find Zone 2 (by name, falling back to sort=2).
$zone2 = (int) ($pdo->query(
    "SELECT id FROM org_zones WHERE name = 'Zone 2' OR sort = 2 ORDER BY (name='Zone 2') DESC LIMIT 1"
)->fetchColumn());
if (!$zone2) {
    exit("Zone 2 not found. Add it in admin.php first.\n");
}
echo "Zone 2 id = $zone2\n";

// Ensure a division exists under Zone 2; return its id.
function ensureDivision(PDO $pdo, int $zoneId, string $name, int $sort): int
{
    $q = $pdo->prepare('SELECT id FROM org_divisions WHERE zone_id = ? AND name = ? LIMIT 1');
    $q->execute([$zoneId, $name]);
    $id = (int) $q->fetchColumn();
    if ($id) {
        echo "  division '$name' already exists (id $id)\n";
        return $id;
    }
    $pdo->prepare('INSERT INTO org_divisions (zone_id, name, sort) VALUES (?, ?, ?)')
        ->execute([$zoneId, $name, $sort]);
    $id = (int) $pdo->lastInsertId();
    echo "  created division '$name' (id $id)\n";
    return $id;
}

$acpCidco     = ensureDivision($pdo, $zone2, 'ACP CIDCO', 1);
$acpUsmanpura = ensureDivision($pdo, $zone2, 'ACP Usmanpura', 2);

$map = [
    $acpCidco     => ['CIDCO', 'MIDC CIDCO', 'Jinsi', 'Harsul'],
    $acpUsmanpura => ['Mukundwadi', 'Jawahar Nagar', 'Usmanpura', 'Satara', 'Pundlik Nagar'],
];

// Make sure each station row exists, then map it to its division.
$ins = $pdo->prepare('INSERT IGNORE INTO org_stations (name) VALUES (?)');
$upd = $pdo->prepare('UPDATE org_stations SET division_id = ? WHERE name = ?');
foreach ($map as $divId => $stations) {
    foreach ($stations as $name) {
        $ins->execute([$name]);
        $upd->execute([$divId, $name]);
        echo "  mapped '$name' -> division $divId\n";
    }
}

echo "\nDone. Zone 2 ACPs are now in the dropdown. DELETE this file now.\n";
