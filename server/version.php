<?php
// Returns the latest published app release as JSON. The app calls this on every
// launch (and from Settings → Check for update) to decide whether to update.
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');

// Shared-key gate (same key as the access API).
$appKey = $_SERVER['HTTP_X_APP_KEY'] ?? '';
if (!hash_equals(APP_KEY, $appKey)) {
    http_response_code(401);
    respond(['ok' => false, 'message' => 'unauthorized']);
}

$pdo = db();

// The app reports its platform (?platform=macos|windows|linux). Older Windows
// clients don't send it, so default to 'windows' for backward compatibility.
$platform = strtolower(trim($_GET['platform'] ?? 'windows'));
if (!in_array($platform, ['windows', 'macos', 'linux'], true)) {
    $platform = 'windows';
}

$stmt = $pdo->prepare(
    'SELECT * FROM app_release WHERE platform = ? ORDER BY build DESC, id DESC LIMIT 1'
);
$stmt->execute([$platform]);
$r = $stmt->fetch();

// No release published yet → app stays on its current version.
if (!$r) {
    respond(['ok' => true, 'version' => '', 'build' => 0]);
}

respond([
    'ok'        => true,
    'version'   => $r['version'],
    'build'     => (int) $r['build'],
    'notes'     => $r['notes'] ?? '',
    'mandatory' => ((int) $r['mandatory']) === 1,
    'sha256'    => $r['sha256'] ?? '',
    'url'       => releaseUrl($r['file_name']),
]);
