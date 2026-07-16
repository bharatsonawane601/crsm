<?php
// Officer portal -> scope-filtered crime/FIR search. Read-only. The server
// computes which stations the officer may see from their role + scope, so the
// client can never widen its own access.
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');
requireAppKey();

$body = jsonBody();
$email = strtolower(trim($body['email'] ?? ''));
if ($email === '') respond(['ok' => false, 'message' => 'access.error.server']);

$pdo = db();
$user = requireApprovedUser($pdo, $email);

// Only portal officers (acp/dcp/cp) may read across stations.
if (!in_array($user['role'], ['acp', 'dcp', 'cp'], true)) {
    http_response_code(403);
    respond(['ok' => false, 'message' => 'access.error.server']);
}

$scope = effectiveScope($pdo, $user, $body);
[$scopeSql, $scopeParams] = scopeWhere($scope);
$where = [];
$params = [];
if ($scopeSql !== '') {
    $where[] = $scopeSql;
    $params = array_merge($params, $scopeParams);
}

// Free-text search. Matches both the uploaded station spelling and the
// canonical org_stations name, so "Daulatabad" also finds "दौलताबाद" rows.
$q = trim((string) ($body['q'] ?? ''));
if ($q !== '') {
    $where[] = '(fir_no LIKE ? OR section LIKE ? OR crime_type LIKE ?'
        . ' OR c.station_name LIKE ? OR s.name LIKE ?)';
    $like = '%' . $q . '%';
    array_push($params, $like, $like, $like, $like, $like);
}

// Structured filters.
if (!empty($body['year']) && is_numeric($body['year'])) {
    $where[] = 'year = ?';
    $params[] = (int) $body['year'];
}
if (!empty($body['status'])) {
    $where[] = 'status = ?';
    $params[] = (string) $body['status'];
}
if (!empty($body['crime_type'])) {
    $where[] = 'crime_type = ?';
    $params[] = (string) $body['crime_type'];
}

$whereSql = $where ? ('WHERE ' . implode(' AND ', $where)) : '';
// LEFT JOIN keeps every FIR (station-less ones included) while exposing the
// canonical station name for display and search.
$fromSql = 'FROM central_crimes c LEFT JOIN org_stations s ON c.station_id = s.id';

$total = (int) (function () use ($pdo, $fromSql, $whereSql, $params) {
    $c = $pdo->prepare("SELECT COUNT(*) $fromSql $whereSql");
    $c->execute($params);
    return $c->fetchColumn();
})();

$pageSize = (int) ($body['page_size'] ?? 50);
$pageSize = max(1, min(200, $pageSize));
$page = max(1, (int) ($body['page'] ?? 1));
$offset = ($page - 1) * $pageSize;

$sql = "SELECT c.id, COALESCE(s.name, c.station_name) AS station_name, c.fir_no,
               c.year, c.crime_type, c.section, c.status,
               c.date_occurred, c.date_registered, c.data_json, c.updated_at
        $fromSql $whereSql
        ORDER BY c.date_registered DESC, c.id DESC
        LIMIT $pageSize OFFSET $offset";
$stmt = $pdo->prepare($sql);
$stmt->execute($params);

$rows = [];
foreach ($stmt->fetchAll() as $r) {
    $r['data'] = $r['data_json'] ? json_decode($r['data_json'], true) : null;
    unset($r['data_json']);
    $rows[] = $r;
}

respond([
    'ok' => true,
    'total' => $total,
    'page' => $page,
    'page_size' => $pageSize,
    'rows' => $rows,
]);
