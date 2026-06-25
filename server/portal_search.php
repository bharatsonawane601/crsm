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

// Free-text search.
$q = trim((string) ($body['q'] ?? ''));
if ($q !== '') {
    $where[] = '(fir_no LIKE ? OR section LIKE ? OR crime_type LIKE ? OR station_name LIKE ?)';
    $like = '%' . $q . '%';
    array_push($params, $like, $like, $like, $like);
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

$total = (int) (function () use ($pdo, $whereSql, $params) {
    $c = $pdo->prepare("SELECT COUNT(*) FROM central_crimes $whereSql");
    $c->execute($params);
    return $c->fetchColumn();
})();

$pageSize = (int) ($body['page_size'] ?? 50);
$pageSize = max(1, min(200, $pageSize));
$page = max(1, (int) ($body['page'] ?? 1));
$offset = ($page - 1) * $pageSize;

$sql = "SELECT id, station_name, fir_no, year, crime_type, section, status,
               date_occurred, date_registered, data_json, updated_at
        FROM central_crimes $whereSql
        ORDER BY date_registered DESC, id DESC
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
