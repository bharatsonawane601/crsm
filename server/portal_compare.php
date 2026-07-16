<?php
// Officer portal -> side-by-side comparison. Given a set of police stations OR
// ACP divisions, returns a KPI bundle per entity so the app can render them
// against each other. Read-only and scope-enforced: an officer can only compare
// entities inside their own jurisdiction (each requested entity is intersected
// with the officer's base station scope).
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

$base = stationScopeForUser($pdo, $user); // ['all'=>true] | ['ids'=>int[]]
$by = in_array($body['by'] ?? '', ['zone', 'division', 'station'], true)
    ? $body['by'] : 'station';
$ids = array_values(array_unique(array_filter(
    array_map('intval', (array) ($body['ids'] ?? [])),
    fn($v) => $v > 0
)));

// Keep only the station ids the officer is actually allowed to read.
$allow = function (array $stationIds) use ($base): array {
    if (!empty($base['all'])) return $stationIds;
    return array_values(array_intersect($stationIds, $base['ids'] ?? []));
};

$rows = [];
foreach ($ids as $entId) {
    if ($by === 'zone') {
        $q = $pdo->prepare('SELECT name FROM org_zones WHERE id = ?');
        $q->execute([$entId]);
        $label = $q->fetchColumn() ?: ('#' . $entId);
        $stIds = $allow(stationIdsInZone($pdo, $entId));
    } elseif ($by === 'division') {
        $q = $pdo->prepare('SELECT name FROM org_divisions WHERE id = ?');
        $q->execute([$entId]);
        $label = $q->fetchColumn() ?: ('#' . $entId);
        $stIds = $allow(stationIdsInDivision($pdo, $entId));
    } else {
        $q = $pdo->prepare('SELECT name FROM org_stations WHERE id = ?');
        $q->execute([$entId]);
        $label = $q->fetchColumn() ?: ('#' . $entId);
        $stIds = $allow([$entId]);
    }

    $kpi = ['total' => 0, 'detected' => 0, 'undetected' => 0, 'arrested' => 0,
            'wanted' => 0, 'recovered' => 0.0, 'chargesheeted' => 0];
    if ($stIds) {
        $ph = implode(',', array_fill(0, count($stIds), '?'));
        $rq = $pdo->prepare("SELECT status, data_json FROM central_crimes WHERE station_id IN ($ph)");
        $rq->execute($stIds);
        foreach ($rq as $r) {
            $kpi['total']++;
            if (($r['status'] ?? '') === 'detected') $kpi['detected']++;
            else $kpi['undetected']++;
            $d = !empty($r['data_json']) ? json_decode($r['data_json'], true) : null;
            if (is_array($d)) {
                $kpi['arrested'] += (int) ($d['arrested_count'] ?? 0);
                $kpi['wanted'] += (int) ($d['wanted_count'] ?? 0);
                $kpi['recovered'] += (float) ($d['recovered_value'] ?? 0);
                if (!empty($d['chargesheet_date'])) $kpi['chargesheeted']++;
            }
        }
    }
    $rows[] = ['id' => $entId, 'label' => $label, 'kpi' => $kpi];
}

respond(['ok' => true, 'by' => $by, 'rows' => $rows]);
