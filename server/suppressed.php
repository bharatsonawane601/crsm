<?php
// Returns the remote_uids of this user's FIRs that were deleted on the server
// (admin panel). The station app uses this on launch to delete its own local
// copies, so a server-side deletion is not re-created on the next sync.
require_once __DIR__ . '/db.php';

header('Content-Type: application/json');
requireAppKey();

$body = jsonBody();
$email = strtolower(trim($body['email'] ?? ''));
if ($email === '') {
    respond(['ok' => false, 'message' => 'access.error.server']);
}

$pdo = db();
$q = $pdo->prepare('SELECT remote_uid FROM central_suppressed WHERE owner_email = ?');
$q->execute([$email]);
$uids = array_map('strval', $q->fetchAll(PDO::FETCH_COLUMN));

respond(['ok' => true, 'uids' => array_values($uids)]);
