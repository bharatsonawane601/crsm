<?php
// Password-protected admin panel: approve / deny / reset-device / delete users.
require_once __DIR__ . '/db.php';
session_start();

// --- Login ---------------------------------------------------------------
if (isset($_POST['login_password'])) {
    if (hash_equals(ADMIN_PASSWORD, $_POST['login_password'])) {
        $_SESSION['admin'] = true;
    }
    header('Location: admin.php');
    exit;
}
if (isset($_GET['logout'])) {
    session_destroy();
    header('Location: admin.php');
    exit;
}

function loginForm(): void
{
    echo '<!doctype html><meta charset="utf-8"><title>CRMS Admin</title>';
    echo '<style>body{font-family:system-ui;max-width:420px;margin:80px auto;padding:0 16px}'
        . 'input,button{font-size:16px;padding:10px;width:100%;box-sizing:border-box;margin:6px 0}'
        . 'button{background:#13294B;color:#fff;border:0;border-radius:6px;cursor:pointer}</style>';
    echo '<h2>CRMS Admin</h2><form method="post">'
        . '<input type="password" name="login_password" placeholder="Admin password" autofocus>'
        . '<button>Sign in</button></form>';
}

if (empty($_SESSION['admin'])) {
    loginForm();
    exit;
}

$pdo = db();

// --- Release actions (in-app updater) ------------------------------------
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'upload_release') {
    handleReleaseUpload($pdo);
    header('Location: admin.php?page=' . ($_SESSION['rel_page'] ?? 'windows'));
    exit;
}
// Register an installer that was placed in api/releases/ manually (via File
// Manager / FTP). This avoids the PHP upload size limit entirely.
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'register_release') {
    handleReleaseRegister($pdo);
    header('Location: admin.php?page=' . ($_SESSION['rel_page'] ?? 'windows'));
    exit;
}
if ($_SERVER['REQUEST_METHOD'] === 'POST'
    && ($_POST['action'] ?? '') === 'delete_release'
    && isset($_POST['release_id'])) {
    $rid = (int) $_POST['release_id'];
    $row = $pdo->prepare('SELECT file_name FROM app_release WHERE id=?');
    $row->execute([$rid]);
    $relPage = 'windows';
    if ($f = $row->fetchColumn()) {
        $fp = platformForFile($f);
        if ($fp !== '') $relPage = $fp;
        $path = releasesDir() . '/' . $f;
        if (is_file($path)) @unlink($path);
    }
    $pdo->prepare('DELETE FROM app_release WHERE id=?')->execute([$rid]);
    header('Location: admin.php?page=' . $relPage);
    exit;
}

// --- Central FIR record actions (admin controls the shared crime store) ---
// Delete ONE central FIR: copy it to the 30-day recycle bin, log it to the
// deletion audit, tombstone it so the station can't re-upload it, then remove it.
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'delete_fir'
    && isset($_POST['fir_id'])) {
    $fid = (int) $_POST['fir_id'];
    $q = $pdo->prepare('SELECT * FROM central_crimes WHERE id = ?');
    $q->execute([$fid]);
    if ($row = $q->fetch()) {
        // 1) Recycle bin — keep the full record so it can be restored.
        $pdo->prepare(
            'INSERT INTO central_trash (' . CENTRAL_COLS . ', deleted_by)
             SELECT ' . CENTRAL_COLS . ', ? FROM central_crimes WHERE id = ?'
        )->execute(['Admin panel', $fid]);
        // 2) Audit (record who removed it: the admin, plus the FIR's owner).
        $pdo->prepare(
            'INSERT INTO central_deletions
                (owner_email, remote_uid, fir_no, year, station_name,
                 src_device, src_platform, src_ip)
             VALUES (?, ?, ?, ?, ?, ?, ?, ?)'
        )->execute([
            $row['owner_email'], $row['remote_uid'], $row['fir_no'], $row['year'],
            $row['station_name'], 'Admin panel', 'admin', clientIp(),
        ]);
        // 3) Tombstone so the next station sync doesn't re-create it.
        $pdo->prepare(
            'INSERT IGNORE INTO central_suppressed (owner_email, remote_uid) VALUES (?, ?)'
        )->execute([$row['owner_email'], $row['remote_uid']]);
        $pdo->prepare('DELETE FROM central_crimes WHERE id = ?')->execute([$fid]);
        $_SESSION['fir_msg'] = 'FIR ' . ($row['fir_no'] ?: '#' . $fid)
            . ' removed — recoverable from the Recycle Bin for 30 days.';
    }
    header('Location: admin.php?page=firs');
    exit;
}
// Restore a tombstoned FIR (let it sync back from the station on next upload).
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'unsuppress_fir'
    && isset($_POST['owner'], $_POST['uid'])) {
    $pdo->prepare('DELETE FROM central_suppressed WHERE owner_email = ? AND remote_uid = ?')
        ->execute([trim($_POST['owner']), trim($_POST['uid'])]);
    $_SESSION['fir_msg'] = 'FIR un-blocked — it will reappear the next time that station syncs.';
    header('Location: admin.php?page=firs');
    exit;
}
// Restore a FIR from the recycle bin straight back into the central store
// (also lifts any tombstone so it stays visible).
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'restore_fir'
    && isset($_POST['trash_id'])) {
    $ok = restoreTrash($pdo, (int) $_POST['trash_id']);
    $_SESSION['fir_msg'] = $ok ? 'FIR restored to the central store.' : 'That recycle-bin entry no longer exists.';
    header('Location: admin.php?page=deletions');
    exit;
}
// Restore the SELECTED recycle-bin entries.
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'restore_selected') {
    $ids = is_array($_POST['trash_ids'] ?? null) ? $_POST['trash_ids'] : [];
    $n = 0;
    foreach ($ids as $tid) if (restoreTrash($pdo, (int) $tid)) $n++;
    $_SESSION['fir_msg'] = $n > 0 ? "Restored $n FIR(s) to the central store." : 'No FIRs were selected to restore.';
    header('Location: admin.php?page=deletions');
    exit;
}
// Restore EVERYTHING in the recycle bin.
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'restore_all') {
    $ids = $pdo->query('SELECT id FROM central_trash')->fetchAll(PDO::FETCH_COLUMN);
    $n = 0;
    foreach ($ids as $tid) if (restoreTrash($pdo, (int) $tid)) $n++;
    $_SESSION['fir_msg'] = "Restored all $n FIR(s) from the recycle bin.";
    header('Location: admin.php?page=deletions');
    exit;
}
// Permanently delete ONE recycle-bin entry (cannot be undone).
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'purge_fir'
    && isset($_POST['trash_id'])) {
    $pdo->prepare('DELETE FROM central_trash WHERE id = ?')->execute([(int) $_POST['trash_id']]);
    $_SESSION['fir_msg'] = 'Recycle-bin entry permanently deleted.';
    header('Location: admin.php?page=deletions');
    exit;
}
// Empty the whole recycle bin (permanent). Requires typing CLEAR.
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'empty_trash') {
    if (($_POST['confirm'] ?? '') === 'CLEAR') {
        $n = (int) $pdo->query('SELECT COUNT(*) FROM central_trash')->fetchColumn();
        $pdo->exec('DELETE FROM central_trash');
        $_SESSION['fir_msg'] = "Recycle bin emptied ($n entries permanently deleted).";
    } else {
        $_SESSION['fir_msg'] = 'Empty-bin cancelled — type CLEAR exactly to confirm.';
    }
    header('Location: admin.php?page=deletions');
    exit;
}
// Clear ALL central FIR records. Requires the admin to type CLEAR to confirm.
// Each record is copied to the 30-day recycle bin first and audited (so a
// clear-all can be fully recovered), AND tombstoned so the station apps delete
// their local copies on next sync instead of re-uploading them.
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['action'] ?? '') === 'clear_firs') {
    if (($_POST['confirm'] ?? '') === 'CLEAR') {
        $n = (int) $pdo->query('SELECT COUNT(*) FROM central_crimes')->fetchColumn();
        // Recycle bin (full copies) + audit (metadata), then remove.
        $pdo->exec(
            'INSERT INTO central_trash (' . CENTRAL_COLS . ", deleted_by)
             SELECT " . CENTRAL_COLS . ", 'Admin (clear all)' FROM central_crimes"
        );
        $pdo->exec(
            "INSERT INTO central_deletions
                (owner_email, remote_uid, fir_no, year, station_name, src_device, src_platform, src_ip)
             SELECT owner_email, remote_uid, fir_no, year, station_name,
                    'Admin panel (clear all)', 'admin', '' FROM central_crimes"
        );
        // Tombstone every cleared FIR so the station apps delete their local
        // copies on next sync and don't re-upload them (true server-side delete).
        $pdo->exec(
            'INSERT IGNORE INTO central_suppressed (owner_email, remote_uid)
             SELECT owner_email, remote_uid FROM central_crimes'
        );
        $pdo->exec('DELETE FROM central_crimes');
        $_SESSION['fir_msg'] = "Cleared all $n FIR records — removed from station apps on next sync; recoverable for 30 days.";
    } else {
        $_SESSION['fir_msg'] = 'Clear-all cancelled — type CLEAR exactly to confirm.';
    }
    header('Location: admin.php?page=firs');
    exit;
}

/// Restores one recycle-bin entry back into the central store: overwrites any
/// current row for the same FIR, lifts its tombstone, and removes the bin entry.
/// Returns true if the entry existed.
function restoreTrash(PDO $pdo, int $tid): bool
{
    $q = $pdo->prepare('SELECT owner_email, remote_uid FROM central_trash WHERE id = ?');
    $q->execute([$tid]);
    $t = $q->fetch();
    if (!$t) return false;
    $pdo->prepare('DELETE FROM central_crimes WHERE owner_email = ? AND remote_uid = ?')
        ->execute([$t['owner_email'], $t['remote_uid']]);
    $pdo->prepare(
        'INSERT INTO central_crimes (' . CENTRAL_COLS . ', updated_at)
         SELECT ' . CENTRAL_COLS . ', NOW() FROM central_trash WHERE id = ?'
    )->execute([$tid]);
    $pdo->prepare('DELETE FROM central_suppressed WHERE owner_email = ? AND remote_uid = ?')
        ->execute([$t['owner_email'], $t['remote_uid']]);
    $pdo->prepare('DELETE FROM central_trash WHERE id = ?')->execute([$tid]);
    return true;
}

/// Validates and stores an uploaded installer + release metadata. The version is
/// taken from the upload form, or auto-detected from the installer's file name
/// (crms-setup-<version>.exe); the build number is derived from the version.
function handleReleaseUpload(PDO $pdo): void
{
    $notes = trim($_POST['notes'] ?? '');
    $mandatory = isset($_POST['mandatory']) ? 1 : 0;

    if (!isset($_FILES['installer']) || $_FILES['installer']['error'] !== UPLOAD_ERR_OK) {
        $code = $_FILES['installer']['error'] ?? '?';
        $_SESSION['rel_msg'] = "Installer upload failed (error $code). "
            . 'The file may exceed the host upload limit.';
        return;
    }
    $origName = $_FILES['installer']['name'];
    $ext = strtolower(pathinfo($origName, PATHINFO_EXTENSION));
    $plat = platformForFile($origName);
    if ($plat !== '') $_SESSION['rel_page'] = $plat;
    if ($plat === '') {
        $_SESSION['rel_msg'] = 'Only .exe (Windows), .dmg / .pkg (macOS) or .AppImage (Linux) installers are allowed.';
        return;
    }

    // Version: from the form, else auto-detect from "crms-setup-<version>.<ext>".
    $version = trim($_POST['version'] ?? '');
    if ($version === ''
        && preg_match('/(\d+(?:\.\d+){1,3})/', pathinfo($origName, PATHINFO_FILENAME), $m)) {
        $version = $m[1];
    }
    if ($version === '') {
        $_SESSION['rel_msg'] = 'Could not detect a version. Name the file like '
            . 'crms-setup-1.1.0.exe, or type the version.';
        return;
    }
    $build = versionToBuild($version);
    if ($build <= 0) {
        $_SESSION['rel_msg'] = "Version \"$version\" is not valid (use numbers like 1.1.0).";
        return;
    }
    $dir = releasesDir();
    if (!is_dir($dir) && !@mkdir($dir, 0755, true)) {
        $_SESSION['rel_msg'] = 'Could not create the releases folder on the server.';
        return;
    }
    // Keep the original extension so Windows and macOS builds don't collide.
    $safe = 'crms-setup-' . preg_replace('/[^a-zA-Z0-9._-]/', '_', $version) . '.' . $ext;
    $dest = $dir . '/' . $safe;
    if (!move_uploaded_file($_FILES['installer']['tmp_name'], $dest)) {
        $_SESSION['rel_msg'] = 'Could not save the uploaded installer.';
        return;
    }
    recordRelease($pdo, $version, $safe, $notes, $mandatory, 'uploaded');
}

/// Maps an installer file name to the platform it targets, or '' if unknown.
function platformForFile(string $fileName): string
{
    $ext = strtolower(pathinfo($fileName, PATHINFO_EXTENSION));
    if ($ext === 'exe') return 'windows';
    if ($ext === 'dmg' || $ext === 'pkg') return 'macos';
    if ($ext === 'appimage') return 'linux';
    return '';
}

/// Registers an installer that already exists in api/releases/ (uploaded by FTP
/// or File Manager). No file upload happens here, so the PHP upload size limit
/// does not apply — the reliable path for large installers on shared hosting.
function handleReleaseRegister(PDO $pdo): void
{
    $notes = trim($_POST['notes'] ?? '');
    $mandatory = isset($_POST['mandatory']) ? 1 : 0;
    $file = basename(trim($_POST['existing_file'] ?? '')); // basename: no path traversal
    $filePlat = platformForFile($file);
    if ($filePlat !== '') $_SESSION['rel_page'] = $filePlat;
    if ($file === '' || $filePlat === '') {
        $_SESSION['rel_msg'] = 'Pick a .exe / .dmg / .pkg / .AppImage file from api/releases/ to register.';
        return;
    }
    $path = releasesDir() . '/' . $file;
    if (!is_file($path)) {
        $_SESSION['rel_msg'] = "File \"$file\" was not found in api/releases/. "
            . 'Upload it there first (File Manager / FTP), then register it.';
        return;
    }
    $version = trim($_POST['version'] ?? '');
    if ($version === ''
        && preg_match('/(\d+(?:\.\d+){1,3})/', pathinfo($file, PATHINFO_FILENAME), $m)) {
        $version = $m[1];
    }
    if ($version === '') {
        $_SESSION['rel_msg'] = 'Could not detect a version from the file name; type it in.';
        return;
    }
    recordRelease($pdo, $version, $file, $notes, $mandatory, 'registered');
}

/// Inserts (or refreshes) an app_release row for an installer file that is
/// already saved in api/releases/. Shared by upload + register.
function recordRelease(PDO $pdo, string $version, string $fileName, string $notes, int $mandatory, string $how): void
{
    $build = versionToBuild($version);
    if ($build <= 0) {
        $_SESSION['rel_msg'] = "Version \"$version\" is not valid (use numbers like 1.1.0).";
        return;
    }
    $platform = platformForFile($fileName);
    if ($platform === '') {
        $_SESSION['rel_msg'] = "Unsupported installer type for \"$fileName\".";
        return;
    }
    $path = releasesDir() . '/' . $fileName;
    $sha = is_file($path) ? (hash_file('sha256', $path) ?: null) : null;
    // Replace any prior row for the same version + platform so re-registering is
    // idempotent, while letting Windows and macOS builds of a version coexist.
    $pdo->prepare('DELETE FROM app_release WHERE version = ? AND platform = ?')
        ->execute([$version, $platform]);
    $pdo->prepare(
        'INSERT INTO app_release (version, build, platform, file_name, notes, mandatory, sha256)
         VALUES (?, ?, ?, ?, ?, ?, ?)'
    )->execute([$version, $build, $platform, $fileName, $notes, $mandatory, $sha]);
    $labels = ['macos' => 'macOS', 'linux' => 'Linux', 'windows' => 'Windows'];
    $label = $labels[$platform] ?? 'Windows';
    $_SESSION['rel_page'] = $platform;
    $_SESSION['rel_msg'] = "$label release $version (build $build) $how successfully.";
}

/// Lists installer files (.exe / .dmg / .pkg) present in api/releases/ that are
/// not yet registered as a release (so the admin can register one in a click).
function unregisteredReleaseFiles(PDO $pdo): array
{
    $dir = releasesDir();
    if (!is_dir($dir)) return [];
    $known = $pdo->query('SELECT file_name FROM app_release')->fetchAll(PDO::FETCH_COLUMN);
    $known = array_flip($known);
    $out = [];
    foreach (glob($dir . '/*.{exe,dmg,pkg,AppImage,appimage}', GLOB_BRACE) ?: [] as $f) {
        $name = basename($f);
        if (!isset($known[$name])) $out[] = $name;
    }
    sort($out);
    return $out;
}

// --- Officer hierarchy actions -------------------------------------------
// The org tree is edited here; everything else (scope filtering) derives from it.
if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['org_action'] ?? '') !== '') {
    switch ($_POST['org_action']) {
        case 'add_zone':
            $n = trim($_POST['zone_name'] ?? '');
            if ($n !== '') $pdo->prepare('INSERT INTO org_zones (name) VALUES (?)')->execute([$n]);
            break;
        case 'add_division':
            $zid = (int) ($_POST['zone_id'] ?? 0);
            $n = trim($_POST['division_name'] ?? '');
            if ($zid && $n !== '') {
                $pdo->prepare('INSERT INTO org_divisions (zone_id, name) VALUES (?, ?)')
                    ->execute([$zid, $n]);
            }
            break;
        case 'add_station':
            $n = trim($_POST['station_name'] ?? '');
            if ($n !== '') $pdo->prepare('INSERT IGNORE INTO org_stations (name) VALUES (?)')->execute([$n]);
            break;
        case 'assign_station':
            $sid = (int) ($_POST['station_id'] ?? 0);
            $did = (int) ($_POST['division_id'] ?? 0);
            if ($sid) {
                $pdo->prepare('UPDATE org_stations SET division_id=? WHERE id=?')
                    ->execute([$did ?: null, $sid]);
            }
            break;
        case 'delete_zone':
            $pdo->prepare('DELETE FROM org_zones WHERE id=?')->execute([(int) ($_POST['zone_id'] ?? 0)]);
            break;
        case 'delete_division':
            $pdo->prepare('DELETE FROM org_divisions WHERE id=?')->execute([(int) ($_POST['division_id'] ?? 0)]);
            break;
    }
    header('Location: admin.php?page=hierarchy');
    exit;
}

/// Parses the combined "access" select value into [role, zoneId, divId, stationId].
function parseAccess(string $v): array
{
    if ($v === 'cp') return ['cp', null, null, null];
    if (str_starts_with($v, 'dcp:')) return ['dcp', (int) substr($v, 4) ?: null, null, null];
    if (str_starts_with($v, 'acp:')) return ['acp', null, (int) substr($v, 4) ?: null, null];
    return ['station', null, null, null];
}

// --- Actions -------------------------------------------------------------
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'], $_POST['id'])) {
    $id = (int) $_POST['id'];
    switch ($_POST['action']) {
        case 'approve':
            // Build an expiry from the chosen duration + unit (0 / lifetime = no expiry).
            $duration = (int) ($_POST['duration'] ?? 0);
            $unit = $_POST['unit'] ?? 'days';
            $expires = null;
            $allowed = ['minutes', 'hours', 'days', 'months', 'years'];
            if ($unit !== 'lifetime' && $duration > 0 && in_array($unit, $allowed, true)) {
                // Store in UTC to match the DB connection timezone (+00:00).
                $expires = gmdate('Y-m-d H:i:s', strtotime("+$duration $unit"));
            }
            [$role, $sz, $sd, $ss] = parseAccess($_POST['access'] ?? 'station');
            $pdo->prepare('UPDATE access_users SET status="approved", decided_at=NOW(),
                    expires_at=?, role=?, scope_zone_id=?, scope_division_id=?, scope_station_id=? WHERE id=?')
                ->execute([$expires, $role, $sz, $sd, $ss, $id]);
            break;
        case 'set_access':
            // Change role/scope without touching approval or expiry.
            [$role, $sz, $sd, $ss] = parseAccess($_POST['access'] ?? 'station');
            $pdo->prepare('UPDATE access_users SET role=?, scope_zone_id=?,
                    scope_division_id=?, scope_station_id=? WHERE id=?')
                ->execute([$role, $sz, $sd, $ss, $id]);
            break;
        case 'deny':
            $pdo->prepare('UPDATE access_users SET status="denied", decided_at=NOW() WHERE id=?')->execute([$id]);
            break;
        case 'reset_device':
            // Clears the HWID so the user can re-bind on a new computer.
            $pdo->prepare('UPDATE access_users SET hwid=NULL WHERE id=?')->execute([$id]);
            break;
        case 'delete':
            $pdo->prepare('DELETE FROM access_users WHERE id=?')->execute([$id]);
            break;
    }
    header('Location: admin.php?page=users');
    exit;
}

$rows = $pdo->query('SELECT * FROM access_users ORDER BY
    FIELD(status,"pending","approved","denied"), requested_at DESC')->fetchAll();

$releases = $pdo->query('SELECT * FROM app_release ORDER BY build DESC, id DESC')
    ->fetchAll();
$relMsg = $_SESSION['rel_msg'] ?? '';
unset($_SESSION['rel_msg']);
$uploadLimit = ini_get('upload_max_filesize');
$postLimit = ini_get('post_max_size');
$pendingFiles = unregisteredReleaseFiles($pdo);

// --- Central shared crime database (FIR records + deletion audit) --------
// The one store every station app uploads to. We list the most recent rows;
// the totals power the dashboard.
$firs = $pdo->query('SELECT * FROM central_crimes ORDER BY updated_at DESC LIMIT 500')->fetchAll();
$firTotal = (int) $pdo->query('SELECT COUNT(*) FROM central_crimes')->fetchColumn();
$deletions = $pdo->query('SELECT * FROM central_deletions ORDER BY deleted_at DESC LIMIT 300')->fetchAll();
$delTotal = (int) $pdo->query('SELECT COUNT(*) FROM central_deletions')->fetchColumn();
$del7 = (int) $pdo->query('SELECT COUNT(*) FROM central_deletions
    WHERE deleted_at > (UTC_TIMESTAMP() - INTERVAL 7 DAY)')->fetchColumn();
$suppressed = $pdo->query('SELECT * FROM central_suppressed ORDER BY suppressed_at DESC LIMIT 200')->fetchAll();
// Recycle bin: auto-purge anything older than 30 days, then list what remains.
$pdo->exec('DELETE FROM central_trash WHERE deleted_at < (UTC_TIMESTAMP() - INTERVAL 30 DAY)');
$trash = $pdo->query('SELECT * FROM central_trash ORDER BY deleted_at DESC LIMIT 500')->fetchAll();
$trashTotal = (int) $pdo->query('SELECT COUNT(*) FROM central_trash')->fetchColumn();
$firMsg = $_SESSION['fir_msg'] ?? '';
unset($_SESSION['fir_msg']);

// --- Dashboard stats -----------------------------------------------------
$stats = ['total' => count($rows), 'pending' => 0, 'approved' => 0,
          'denied' => 0, 'officers' => 0, 'active7' => 0,
          'firs' => $firTotal, 'deletions' => $delTotal, 'del7' => $del7];
$weekAgo = time() - 7 * 86400;
foreach ($rows as $r) {
    $st = $r['status'] ?? 'pending';
    if (isset($stats[$st])) $stats[$st]++;
    if (in_array($r['role'] ?? 'station', ['acp', 'dcp', 'cp'], true)) $stats['officers']++;
    if (!empty($r['last_seen_at']) && strtotime($r['last_seen_at'] . ' UTC') > $weekAgo) {
        $stats['active7']++;
    }
}

// Releases split per platform for the separate Windows / macOS / Linux sections.
$relWin = array_values(array_filter($releases, fn($x) => ($x['platform'] ?? 'windows') === 'windows'));
$relMac = array_values(array_filter($releases, fn($x) => ($x['platform'] ?? 'windows') === 'macos'));
$relLinux = array_values(array_filter($releases, fn($x) => ($x['platform'] ?? 'windows') === 'linux'));
$latestWin = $relWin[0]['version'] ?? null;
$latestMac = $relMac[0]['version'] ?? null;

// --- CSV exports (security/audit) ----------------------------------------
$export = $_GET['export'] ?? '';
if ($export === 'users') {
    csvHeaders('crms-users');
    $out = fopen('php://output', 'w');
    fputcsv($out, ['Email', 'Name', 'Status', 'Role', 'Requested', 'Expires',
        'Last seen', 'IP', 'Platform', 'OS', 'Device', 'App version', 'User agent']);
    foreach ($rows as $r) {
        fputcsv($out, [
            $r['email'], $r['name'], $r['status'], $r['role'] ?? 'station',
            $r['requested_at'] ?? '', $r['expires_at'] ?? '', $r['last_seen_at'] ?? '',
            $r['last_ip'] ?? '', $r['client_platform'] ?? '', $r['client_os'] ?? '',
            $r['client_device'] ?? '', $r['app_version'] ?? '', $r['user_agent'] ?? '',
        ]);
    }
    fclose($out);
    exit;
}
if ($export === 'firs') {
    csvHeaders('crms-fir-records');
    $out = fopen('php://output', 'w');
    fputcsv($out, ['FIR No', 'Year', 'Station', 'Crime type', 'Section', 'Status',
        'Date registered', 'Uploaded by', 'Source device', 'Platform', 'OS', 'IP', 'Updated']);
    foreach ($firs as $r) {
        fputcsv($out, [
            $r['fir_no'] ?? '', $r['year'] ?? '', $r['station_name'] ?? '',
            $r['crime_type'] ?? '', $r['section'] ?? '', $r['status'] ?? '',
            $r['date_registered'] ?? '', $r['owner_email'] ?? '', $r['src_device'] ?? '',
            $r['src_platform'] ?? '', $r['src_os'] ?? '', $r['src_ip'] ?? '', $r['updated_at'] ?? '',
        ]);
    }
    fclose($out);
    exit;
}
if ($export === 'deletions') {
    csvHeaders('crms-deletions');
    $out = fopen('php://output', 'w');
    fputcsv($out, ['Deleted at (UTC)', 'FIR No', 'Year', 'Station', 'Deleted by',
        'Source device', 'Platform', 'OS', 'IP']);
    foreach ($deletions as $r) {
        fputcsv($out, [
            $r['deleted_at'] ?? '', $r['fir_no'] ?? '', $r['year'] ?? '',
            $r['station_name'] ?? '', $r['owner_email'] ?? '', $r['src_device'] ?? '',
            $r['src_platform'] ?? '', $r['src_os'] ?? '', $r['src_ip'] ?? '',
        ]);
    }
    fclose($out);
    exit;
}

// Org tree for the access selects + hierarchy card.
$zones = $pdo->query('SELECT * FROM org_zones ORDER BY sort, id')->fetchAll();
$divisions = $pdo->query('SELECT * FROM org_divisions ORDER BY sort, id')->fetchAll();
$stations = $pdo->query('SELECT * FROM org_stations ORDER BY sort, name')->fetchAll();
$zoneName = [];
foreach ($zones as $z) $zoneName[$z['id']] = $z['name'];

function e(?string $s): string { return htmlspecialchars($s ?? '', ENT_QUOTES); }

/// Sends CSV download headers with a timestamped file name.
function csvHeaders(string $base): void
{
    header('Content-Type: text/csv; charset=utf-8');
    header('Content-Disposition: attachment; filename="' . $base . '-' . date('Ymd-His') . '.csv"');
}

/// Formats a UTC datetime string (as stored in the DB) into readable IST, e.g.
/// "24 Jun 2026, 9:15 PM". Returns '' for empty input.
function fmtIst(?string $utc): string
{
    if ($utc === null || trim($utc) === '') return '';
    try {
        $dt = new DateTime($utc, new DateTimeZone('UTC'));
        $dt->setTimezone(new DateTimeZone('Asia/Kolkata'));
        return $dt->format('d M Y, g:i A');
    } catch (Exception $ex) {
        return $utc;
    }
}

/// The current combined access value for a user row.
function accessValue(array $r): string
{
    return match ($r['role'] ?? 'station') {
        'cp' => 'cp',
        'dcp' => 'dcp:' . (int) ($r['scope_zone_id'] ?? 0),
        'acp' => 'acp:' . (int) ($r['scope_division_id'] ?? 0),
        default => 'station',
    };
}

/// Builds the <option> list for the access select, with [$current] selected.
function accessOptions(array $zones, array $divisions, array $zoneName, string $current): string
{
    $opt = function (string $val, string $label) use ($current): string {
        $sel = $val === $current ? ' selected' : '';
        return "<option value=\"" . e($val) . "\"$sel>" . e($label) . '</option>';
    };
    $h = $opt('station', 'Station (data entry)');
    $h .= $opt('cp', 'CP — All city');
    foreach ($zones as $z) $h .= $opt('dcp:' . $z['id'], 'DCP — ' . $z['name']);
    foreach ($divisions as $d) {
        $zn = $zoneName[$d['zone_id']] ?? '';
        $h .= $opt('acp:' . $d['id'], 'ACP — ' . $d['name'] . ($zn ? " ($zn)" : ''));
    }
    return $h;
}

/// Short human label for a user's current access (for the table cell).
function accessLabel(array $r, array $zoneName, array $divisions): string
{
    switch ($r['role'] ?? 'station') {
        case 'cp': return 'CP — All city';
        case 'dcp': return 'DCP — ' . ($zoneName[$r['scope_zone_id']] ?? '?');
        case 'acp':
            foreach ($divisions as $d) {
                if ((int) $d['id'] === (int) ($r['scope_division_id'] ?? 0)) return 'ACP — ' . $d['name'];
            }
            return 'ACP — ?';
        default: return 'Station';
    }
}

/// Derives a friendly client/browser name from a User-Agent string. The CRMS
/// desktop app uses the Dart HTTP client, so that's the common case.
function browserFromUa(?string $ua): string
{
    $ua = trim((string) $ua);
    if ($ua === '') return '—';
    if (stripos($ua, 'Dart') !== false) return 'CRMS app';
    if (stripos($ua, 'Edg') !== false) return 'Edge';
    if (stripos($ua, 'OPR') !== false || stripos($ua, 'Opera') !== false) return 'Opera';
    if (stripos($ua, 'Firefox') !== false) return 'Firefox';
    if (stripos($ua, 'Chrome') !== false) return 'Chrome';
    if (stripos($ua, 'Safari') !== false) return 'Safari';
    return mb_substr($ua, 0, 40);
}

/// Friendly platform label with an OS-style emoji.
function platLabelOf(?string $p): string
{
    return match ($p) {
        'macos' => '🍎 macOS',
        'windows' => '🪟 Windows',
        'linux' => '🐧 Linux',
        default => '—',
    };
}

/// "active" green dot if last-seen is within 7 days, plus the IST timestamp.
function seenBadge(?string $utc): string
{
    if (empty($utc)) return '<span class="muted">never</span>';
    $online = strtotime($utc . ' UTC') > time() - 7 * 86400;
    $dot = $online ? '<span class="dot on"></span>' : '<span class="dot"></span>';
    return $dot . e(fmtIst($utc));
}

/// Renders one platform's update section: upload form, FTP-register form, and
/// the releases table — used to keep Windows, macOS and Linux fully separate.
function renderReleaseSection(string $plat, array $rels, array $pending, string $uploadLimit): void
{
    $label = match ($plat) { 'macos' => 'macOS', 'linux' => 'Linux', default => 'Windows' };
    $exts = match ($plat) { 'macos' => '.dmg,.pkg', 'linux' => '.AppImage', default => '.exe' };
    $example = match ($plat) {
        'macos' => 'CRMS-1.4.0.dmg',
        'linux' => 'crms-setup-1.4.0.AppImage',
        default => 'crms-setup-1.4.0.exe',
    };
    $id = $plat; // 'windows' | 'macos' | 'linux'
    ?>
    <form class="up" method="post" enctype="multipart/form-data">
      <input type="hidden" name="action" value="upload_release">
      <label><?= $label ?> installer (<?= e($exts) ?>)</label>
      <input type="file" name="installer" id="file_<?= $id ?>" accept="<?= e($exts) ?>" required>
      <label>Version <span class="muted">(auto-filled from the file name)</span></label>
      <input type="text" name="version" id="ver_<?= $id ?>" placeholder="e.g. 1.3.2">
      <label>Release notes (What's new)</label>
      <textarea name="notes" placeholder="• What changed in this version"></textarea>
      <label class="ckbox"><input type="checkbox" name="mandatory"> Mandatory (force update)</label>
      <br><button type="submit">Upload <?= $label ?> release</button>
    </form>
    <script>
      document.getElementById('file_<?= $id ?>').addEventListener('change', function () {
        var f = this.files && this.files[0] ? this.files[0].name : '';
        var m = f.match(/(\d+(?:\.\d+){1,3})/);
        var vf = document.getElementById('ver_<?= $id ?>');
        if (m && !vf.value) vf.value = m[1];
      });
    </script>

    <details class="ftp">
      <summary>Big file? Register one uploaded by FTP / File Manager</summary>
      <p class="muted">
        Upload the <?= e($exts) ?> into <code>api/releases/</code> (Hostinger File
        Manager or FTP), then register it here — no upload-size limit applies.
        <?php if ($plat === 'macos'): ?>This is the usual path for Mac <code>.dmg</code> builds.<?php endif; ?>
        <?php if ($plat === 'linux'): ?>This is the usual path for Linux <code>.AppImage</code> builds.<?php endif; ?>
      </p>
      <?php if ($pending): ?>
      <form class="up" method="post">
        <input type="hidden" name="action" value="register_release">
        <label>File found in api/releases/</label>
        <select name="existing_file" id="exist_<?= $id ?>" required>
          <option value="">— choose a file —</option>
          <?php foreach ($pending as $f): ?>
            <option value="<?= e($f) ?>"><?= e($f) ?></option>
          <?php endforeach; ?>
        </select>
        <label>Version</label>
        <input type="text" name="version" id="rver_<?= $id ?>" placeholder="e.g. 1.3.2">
        <label>Release notes</label>
        <textarea name="notes" placeholder="• What changed"></textarea>
        <label class="ckbox"><input type="checkbox" name="mandatory"> Mandatory (force update)</label>
        <br><button type="submit">Register <?= $label ?> release</button>
      </form>
      <script>
        document.getElementById('exist_<?= $id ?>').addEventListener('change', function () {
          var m = this.value.match(/(\d+(?:\.\d+){1,3})/);
          var vf = document.getElementById('rver_<?= $id ?>');
          if (m) vf.value = m[1];
        });
      </script>
      <?php else: ?>
      <p class="muted"><i>No unregistered <?= e($exts) ?> files in api/releases/.</i></p>
      <?php endif; ?>
    </details>

    <?php if ($rels): ?>
    <table style="margin-top:16px">
      <tr><th>Version</th><th>Build</th><th>Mandatory</th><th>Uploaded</th><th>File</th><th></th></tr>
      <?php foreach ($rels as $i => $rel): ?>
      <tr>
        <td><b><?= e($rel['version']) ?></b><?= $i === 0 ? ' <span class="b approved">latest</span>' : '' ?></td>
        <td><?= (int) $rel['build'] ?></td>
        <td><?= ((int) $rel['mandatory'] === 1) ? 'Yes' : 'No' ?></td>
        <td><?= e(fmtIst($rel['created_at'])) ?></td>
        <td><a href="releases/<?= rawurlencode($rel['file_name']) ?>"><?= e($rel['file_name']) ?></a></td>
        <td>
          <form method="post" onsubmit="return confirm('Delete this release and its file?')">
            <input type="hidden" name="release_id" value="<?= (int) $rel['id'] ?>">
            <input type="hidden" name="action" value="delete_release">
            <button class="del">Delete</button>
          </form>
        </td>
      </tr>
      <?php endforeach; ?>
    </table>
    <?php else: ?>
      <p class="muted">No <?= $label ?> releases yet.</p>
    <?php endif; ?>
    <?php
}
?>
<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>CRMS Admin · DB Square Technology</title>
<style>
  :root{--navy:#13294B;--navy2:#1d3a66;--khaki:#9a8c5c;--ink:#1b1b1b;--line:#e7e9ee;--bg:#f4f6fa;}
  *{box-sizing:border-box}
  body{font-family:'Segoe UI',system-ui,sans-serif;margin:0;color:var(--ink);background:var(--bg)}
  a{color:var(--navy);text-decoration:none}
  .wrap{max-width:1080px;margin:0 auto;padding:0 18px 60px}
  /* top bar */
  .topbar{background:linear-gradient(110deg,var(--navy),var(--navy2));color:#fff;
    padding:16px 0;box-shadow:0 2px 10px rgba(0,0,0,.12);position:sticky;top:0;z-index:20}
  .topbar .wrap{display:flex;align-items:center;justify-content:space-between;padding-bottom:0}
  .brand{display:flex;align-items:center;gap:12px}
  .brand .logo{width:40px;height:40px;border-radius:9px;background:var(--khaki);color:#fff;
    display:grid;place-items:center;font-weight:800;font-size:17px;letter-spacing:.5px}
  .brand b{font-size:18px;display:block;line-height:1.1}
  .brand span{font-size:12px;opacity:.8}
  .topbar a.out{color:#fff;border:1px solid rgba(255,255,255,.4);padding:7px 14px;border-radius:7px;font-size:13px}
  .topbar a.out:hover{background:rgba(255,255,255,.12)}
  /* nav pills */
  nav.tabs{display:flex;gap:8px;flex-wrap:wrap;margin:18px 0 6px}
  nav.tabs a{background:#fff;border:1px solid var(--line);padding:8px 14px;border-radius:20px;
    font-size:13px;font-weight:600;color:var(--navy)}
  nav.tabs a:hover{border-color:var(--navy);background:#eef2fb}
  nav.tabs a.on{background:var(--navy);color:#fff;border-color:var(--navy)}
  /* device / source cell */
  .src{font-size:12px;color:#445;line-height:1.6}
  .src b{color:#223;font-weight:600}
  .src .ip{font-family:ui-monospace,Consolas,monospace;background:#eef1f7;padding:1px 5px;border-radius:4px}
  .pagehead{display:flex;align-items:center;justify-content:space-between;gap:12px;flex-wrap:wrap;margin:4px 0 2px}
  .pagehead h2{font-size:20px;color:var(--navy);margin:0}
  /* stat cards */
  .stats{display:grid;grid-template-columns:repeat(auto-fit,minmax(150px,1fr));gap:14px;margin:14px 0 8px}
  .stat{background:#fff;border:1px solid var(--line);border-radius:12px;padding:16px 18px;
    box-shadow:0 1px 3px rgba(20,40,80,.05)}
  .stat .n{font-size:30px;font-weight:800;color:var(--navy);line-height:1}
  .stat .l{font-size:12.5px;color:#667;margin-top:6px;text-transform:uppercase;letter-spacing:.4px}
  .stat.amber .n{color:#C8870A}.stat.green .n{color:#1E7E34}.stat.violet .n{color:#5b3fb0}
  /* cards + tables */
  .card{background:#fff;border:1px solid var(--line);border-radius:12px;padding:20px 22px;margin:20px 0;
    box-shadow:0 1px 3px rgba(20,40,80,.05)}
  .card h3{margin:0 0 4px;font-size:18px;color:var(--navy);display:flex;align-items:center;gap:8px}
  .card .sub{color:#778;font-size:13px;margin:0 0 14px}
  table{border-collapse:collapse;width:100%;font-size:13.5px}
  th,td{border-bottom:1px solid var(--line);padding:9px 8px;text-align:left;vertical-align:top}
  th{font-size:11.5px;text-transform:uppercase;letter-spacing:.4px;color:#889;background:#fafbfe}
  tbody tr:hover{background:#fafbff}
  .b{display:inline-block;padding:2px 9px;border-radius:11px;font-size:11.5px;color:#fff;font-weight:600}
  .pending{background:#E0A800}.approved{background:#1E7E34}.denied{background:#C82333}
  button{padding:6px 11px;border:0;border-radius:6px;cursor:pointer;color:#fff;font-size:12.5px;font-weight:600}
  button:hover{filter:brightness(1.07)}
  .ok{background:#1E7E34}.no{background:#C82333}.rs{background:#5A6268}.del{background:#9b1c1c}
  form{display:inline}
  .dot{display:inline-block;width:8px;height:8px;border-radius:50%;background:#c2c7d0;margin-right:6px}
  .dot.on{background:#1E7E34;box-shadow:0 0 0 3px rgba(30,126,52,.18)}
  details.sec{margin-top:5px}
  details.sec summary{cursor:pointer;color:var(--navy);font-size:12px;font-weight:600}
  details.sec .kv{margin-top:6px;font-size:12px;color:#445;line-height:1.7}
  details.sec .kv b{color:#223;font-weight:600}
  .up label{display:block;font-size:13px;color:#445;margin:9px 0 3px;font-weight:600}
  .up input[type=text],.up input[type=number],.up textarea,.up select{width:100%;
    padding:9px;border:1px solid #ccd2dc;border-radius:7px;font-size:14px;background:#fff}
  .up textarea{min-height:62px}
  .up .row{display:flex;gap:14px;flex-wrap:wrap}.up .row>div{flex:1;min-width:200px}
  .up button{background:var(--navy);margin-top:14px;padding:11px 18px;font-size:14px}
  .ckbox{display:inline-flex;align-items:center;gap:7px;margin-top:12px;font-weight:600;font-size:13px}
  .ckbox input{width:auto}
  .muted{color:#889;font-size:12px}
  .msg{background:#e7f4ea;border:1px solid #bcdfc6;color:#1E7E34;padding:11px 14px;border-radius:8px;margin:6px 0 14px}
  .ftp{margin-top:16px;border-top:1px dashed #d6dae3;padding-top:12px}
  .ftp summary{cursor:pointer;font-weight:600;color:var(--navy)}
  .toolbar{display:flex;gap:12px;align-items:center;margin-bottom:12px;flex-wrap:wrap}
  .toolbar input[type=search]{flex:1;min-width:220px;padding:9px 12px;border:1px solid #ccd2dc;border-radius:8px;font-size:14px}
  .toolbar a.exp{background:#fff;border:1px solid var(--line);color:var(--navy);padding:9px 14px;border-radius:8px;font-size:13px;font-weight:600}
  code{background:#eef1f7;padding:1px 5px;border-radius:4px;font-size:12.5px}
  .grid2{display:grid;grid-template-columns:1fr 1fr;gap:20px}
  @media(max-width:780px){.grid2{grid-template-columns:1fr}}
</style>
</head><body>
<div class="topbar"><div class="wrap">
  <div class="brand">
    <div class="logo">CR</div>
    <div><b>CRMS Admin</b><span>Crime Records Management · DB Square Technology</span></div>
  </div>
  <a class="out" href="?logout=1">Sign out</a>
</div></div>

<?php
// Which page is shown. Each nav tab is now its own page for a cleaner,
// more professional layout (was one long scroll).
$pages = ['dashboard', 'users', 'firs', 'deletions', 'hierarchy', 'windows', 'macos', 'linux'];
$page = $_GET['page'] ?? 'dashboard';
if (!in_array($page, $pages, true)) $page = 'dashboard';

/// Renders the source device / platform / OS / IP for a central record.
function srcCell(array $r): void
{
    echo '<div class="src">';
    echo '<div>' . platLabelOf($r['src_platform'] ?? null) . ' '
        . (($r['src_device'] ?? '') !== '' ? '<b>' . e($r['src_device']) . '</b>' : '<span class="muted">unknown device</span>')
        . '</div>';
    if (($r['src_os'] ?? '') !== '') echo '<div class="muted">' . e($r['src_os']) . '</div>';
    echo '<div>IP: <span class="ip">' . (($r['src_ip'] ?? '') !== '' ? e($r['src_ip']) : '—') . '</span></div>';
    echo '</div>';
}
?>
<div class="wrap">
<nav class="tabs">
  <a class="<?= $page === 'dashboard' ? 'on' : '' ?>" href="?page=dashboard">📊 Dashboard</a>
  <a class="<?= $page === 'users' ? 'on' : '' ?>" href="?page=users">👥 Users &amp; Access</a>
  <a class="<?= $page === 'firs' ? 'on' : '' ?>" href="?page=firs">🗂️ FIR Records</a>
  <a class="<?= $page === 'deletions' ? 'on' : '' ?>" href="?page=deletions">🗑️ Deletions<?= $stats['del7'] > 0 ? ' <span class="b denied">' . (int) $stats['del7'] . '</span>' : '' ?></a>
  <a class="<?= $page === 'hierarchy' ? 'on' : '' ?>" href="?page=hierarchy">🏛️ Hierarchy</a>
  <a class="<?= $page === 'windows' ? 'on' : '' ?>" href="?page=windows">🪟 Windows</a>
  <a class="<?= $page === 'macos' ? 'on' : '' ?>" href="?page=macos">🍎 macOS</a>
  <a class="<?= $page === 'linux' ? 'on' : '' ?>" href="?page=linux">🐧 Linux</a>
</nav>

<?php if ($page === 'dashboard'): ?>
<div class="pagehead"><h2>📊 Dashboard</h2><span class="muted">Crime Records Management System · live overview</span></div>
<div class="stats">
  <div class="stat"><div class="n"><?= (int) $stats['total'] ?></div><div class="l">Total users</div></div>
  <div class="stat amber"><div class="n"><?= (int) $stats['pending'] ?></div><div class="l">Pending</div></div>
  <div class="stat green"><div class="n"><?= (int) $stats['approved'] ?></div><div class="l">Approved</div></div>
  <div class="stat violet"><div class="n"><?= (int) $stats['officers'] ?></div><div class="l">Portal officers</div></div>
  <div class="stat green"><div class="n"><?= (int) $stats['active7'] ?></div><div class="l">Active (7 days)</div></div>
  <div class="stat"><div class="n"><?= (int) $stats['firs'] ?></div><div class="l">FIR records (central)</div></div>
  <div class="stat <?= $stats['deletions'] > 0 ? 'amber' : '' ?>"><div class="n"><?= (int) $stats['deletions'] ?></div><div class="l">FIRs deleted (<?= (int) $stats['del7'] ?> in 7 days)</div></div>
  <div class="stat <?= $trashTotal > 0 ? 'violet' : '' ?>"><div class="n"><?= (int) $trashTotal ?></div><div class="l">Recoverable (recycle bin)</div></div>
  <div class="stat"><div class="n" style="font-size:20px;padding-top:6px"><?= e($latestWin ?? '—') ?></div><div class="l">Latest Windows</div></div>
  <div class="stat"><div class="n" style="font-size:20px;padding-top:6px"><?= e($latestMac ?? '—') ?></div><div class="l">Latest macOS</div></div>
</div>
<div class="grid2">
  <div class="card">
    <h3>🗑️ Recent FIR deletions</h3>
    <p class="sub">Latest records removed by a station — full log on the Deletions page.</p>
    <?php if ($deletions): ?>
    <table>
      <tr><th>When (IST)</th><th>FIR</th><th>Station</th><th>By</th></tr>
      <?php foreach (array_slice($deletions, 0, 6) as $d): ?>
      <tr>
        <td class="muted"><?= e(fmtIst($d['deleted_at'] ?? '')) ?></td>
        <td><b><?= e($d['fir_no'] ?? '') ?: '—' ?></b><?= ($d['year'] ?? '') !== '' ? '/' . e($d['year']) : '' ?></td>
        <td><?= e($d['station_name'] ?? '') ?: '—' ?></td>
        <td class="muted"><?= e($d['owner_email'] ?? '') ?></td>
      </tr>
      <?php endforeach; ?>
    </table>
    <?php else: ?><p class="muted">No deletions recorded. 👍</p><?php endif; ?>
  </div>
  <div class="card">
    <h3>🗂️ Latest FIR uploads</h3>
    <p class="sub">Most recently synced records and the device they came from.</p>
    <?php if ($firs): ?>
    <table>
      <tr><th>FIR</th><th>Station</th><th>From device</th></tr>
      <?php foreach (array_slice($firs, 0, 6) as $f): ?>
      <tr>
        <td><b><?= e($f['fir_no'] ?? '') ?: '—' ?></b><?= ($f['year'] ?? '') !== '' ? '/' . e($f['year']) : '' ?></td>
        <td><?= e($f['station_name'] ?? '') ?: '—' ?></td>
        <td class="muted"><?= e($f['src_device'] ?? '') ?: '—' ?></td>
      </tr>
      <?php endforeach; ?>
    </table>
    <?php else: ?><p class="muted">No FIRs uploaded to the central store yet.</p><?php endif; ?>
  </div>
</div>

<?php elseif ($page === 'users'): ?>
<div class="card" id="users">
  <h3>👥 Access Requests &amp; Devices</h3>
  <p class="sub">Approve access, set jurisdiction, and review the device, IP and app version each officer signs in from (security audit).</p>
  <div class="toolbar">
    <input type="search" id="userSearch" placeholder="🔎 Search by email, name, IP, device, status…" onkeyup="filterUsers()">
    <a class="exp" href="?export=users">⬇ Export CSV</a>
  </div>
<table id="usersTable">
  <tr><th>Email</th><th>Name</th><th>Status</th><th>Requested</th><th>Access</th><th>Expires</th><th>Device / Security</th><th>Approve / Extend &amp; access</th><th></th></tr>
  <?php foreach ($rows as $r): ?>
  <?php
    $expLabel = 'Lifetime';
    $expired = false;
    if (!empty($r['expires_at'])) {
        // Stored as UTC; compare against now and show in IST.
        $expired = strtotime($r['expires_at'] . ' UTC') < time();
        $expLabel = fmtIst($r['expires_at']) . ($expired ? ' (expired)' : '');
    }
  ?>
  <?php
    $searchKey = strtolower(implode(' ', [
        $r['email'] ?? '', $r['name'] ?? '', $r['status'] ?? '',
        $r['last_ip'] ?? '', $r['client_device'] ?? '', $r['client_os'] ?? '',
        $r['client_platform'] ?? '',
    ]));
    $deviceBound = empty($r['hwid']) ? 'Not bound' : 'Bound';
  ?>
  <tr data-search="<?= e($searchKey) ?>">
    <td><?= e($r['email']) ?></td>
    <td><?= e($r['name']) ?></td>
    <td><span class="b <?= e($r['status']) ?>"><?= e($r['status']) ?></span></td>
    <td class="muted"><?= e(fmtIst($r['requested_at'] ?? '')) ?></td>
    <td><?= e(accessLabel($r, $zoneName, $divisions)) ?></td>
    <td<?= $expired ? ' style="color:#C82333;font-weight:600"' : '' ?>><?= e($expLabel) ?></td>
    <td>
      <div><?= platLabelOf($r['client_platform'] ?? null) ?></div>
      <div class="muted"><?= seenBadge($r['last_seen_at'] ?? null) ?></div>
      <details class="sec">
        <summary>Security details</summary>
        <div class="kv">
          <div><b>IP:</b> <?= e($r['last_ip'] ?? '') ?: '—' ?></div>
          <div><b>Device:</b> <?= e($r['client_device'] ?? '') ?: '—' ?></div>
          <div><b>OS:</b> <?= e($r['client_os'] ?? '') ?: '—' ?></div>
          <div><b>Client:</b> <?= e(browserFromUa($r['user_agent'] ?? '')) ?></div>
          <div><b>App version:</b> <?= e($r['app_version'] ?? '') ?: '—' ?></div>
          <div><b>Device lock:</b> <?= e($deviceBound) ?></div>
        </div>
      </details>
    </td>
    <td>
      <form method="post">
        <input type="hidden" name="id" value="<?= (int)$r['id'] ?>">
        <input type="number" name="duration" value="30" min="0" style="width:56px">
        <select name="unit">
          <option value="minutes">minutes</option>
          <option value="hours">hours</option>
          <option value="days" selected>days</option>
          <option value="months">months</option>
          <option value="years">years</option>
          <option value="lifetime">lifetime</option>
        </select><br>
        <select name="access" style="margin-top:4px;max-width:220px">
          <?= accessOptions($zones, $divisions, $zoneName, accessValue($r)) ?>
        </select><br>
        <button class="ok" name="action" value="approve"><?= $r['status'] === 'approved' ? 'Extend' : 'Approve' ?></button>
        <button class="rs" name="action" value="set_access" title="Change access level only">Save access</button>
      </form>
    </td>
    <td>
      <?php if ($r['status'] !== 'denied'): ?>
        <form method="post"><input type="hidden" name="id" value="<?= (int)$r['id'] ?>"><input type="hidden" name="action" value="deny"><button class="no">Deny</button></form>
      <?php endif; ?>
      <form method="post"><input type="hidden" name="id" value="<?= (int)$r['id'] ?>"><input type="hidden" name="action" value="reset_device"><button class="rs">Reset device</button></form>
      <form method="post" onsubmit="return confirm('Delete this user?')"><input type="hidden" name="id" value="<?= (int)$r['id'] ?>"><input type="hidden" name="action" value="delete"><button class="del">Delete</button></form>
    </td>
  </tr>
  <?php endforeach; ?>
</table>
<script>
  function filterUsers() {
    var q = document.getElementById('userSearch').value.toLowerCase().trim();
    var rows = document.querySelectorAll('#usersTable tr[data-search]');
    rows.forEach(function (tr) {
      tr.style.display = tr.getAttribute('data-search').indexOf(q) > -1 ? '' : 'none';
    });
  }
</script>
</div>

<?php elseif ($page === 'firs'): ?>
<?php if ($firMsg): ?><div class="msg"><?= e($firMsg) ?></div><?php endif; ?>
<div class="card">
  <div class="pagehead">
    <h3>🗂️ FIR Records <span class="muted" style="font-weight:400">(central shared database)</span></h3>
    <div style="display:flex;gap:10px;align-items:center">
      <a class="exp" href="?export=firs">⬇ Export CSV</a>
      <?php if ($firs): ?>
      <form method="post" id="clearForm" onsubmit="return confirmClear()">
        <input type="hidden" name="action" value="clear_firs">
        <input type="hidden" name="confirm" id="clearConfirm">
        <button class="del">🗑️ Clear ALL</button>
      </form>
      <?php endif; ?>
    </div>
  </div>
  <p class="sub">
    Every FIR uploaded by the station apps lives here — one shared database for
    the whole city. You control it: <b>View data</b> to inspect a record,
    <b>Delete</b> to remove one (it is logged &amp; blocked from re-syncing), or
    <b>Clear ALL</b> to wipe the central store. The <b>Source</b> column shows the
    computer / IP each record came from. Showing the latest <?= count($firs) ?> of
    <b><?= (int) $firTotal ?></b> records.
  </p>
  <div class="toolbar">
    <input type="search" id="firSearch" placeholder="🔎 Search FIR no, station, type, device, email…" onkeyup="filterTable('firSearch','firTable')">
  </div>
  <?php if ($firs): ?>
  <table id="firTable">
    <tr><th>FIR No / Year</th><th>Station</th><th>Type / Section</th><th>Status</th><th>Source device / IP</th><th>Synced</th><th>Data</th><th></th></tr>
    <?php foreach ($firs as $f): ?>
    <?php
      $key = strtolower(implode(' ', [$f['fir_no'] ?? '', $f['year'] ?? '', $f['station_name'] ?? '', $f['crime_type'] ?? '', $f['owner_email'] ?? '', $f['src_device'] ?? '', $f['src_ip'] ?? '']));
      $data = json_decode($f['data_json'] ?? '', true);
    ?>
    <tr data-search="<?= e($key) ?>">
      <td><b><?= e($f['fir_no'] ?? '') ?: '—' ?></b><?= ($f['year'] ?? '') !== '' ? '/' . e($f['year']) : '' ?>
        <div class="muted"><?= e($f['owner_email'] ?? '') ?></div></td>
      <td><?= e($f['station_name'] ?? '') ?: '—' ?></td>
      <td><?= e($f['crime_type'] ?? '') ?: '—' ?><?php if (($f['section'] ?? '') !== ''): ?><div class="muted"><?= e($f['section']) ?></div><?php endif; ?></td>
      <td><?= e($f['status'] ?? '') ?: '—' ?><div class="muted"><?= e($f['date_registered'] ?? '') ?></div></td>
      <td><?php srcCell($f); ?></td>
      <td class="muted"><?= e(fmtIst($f['updated_at'] ?? '')) ?></td>
      <td>
        <?php if (is_array($data) && $data): ?>
        <details class="sec"><summary>View data</summary><div class="kv">
          <?php foreach ($data as $dk => $dv): if (is_scalar($dv) && (string) $dv !== ''): ?>
            <div><b><?= e((string) $dk) ?>:</b> <?= e(mb_substr((string) $dv, 0, 200)) ?></div>
          <?php endif; endforeach; ?>
        </div></details>
        <?php else: ?><span class="muted">—</span><?php endif; ?>
      </td>
      <td>
        <form method="post" onsubmit="return confirm('Delete FIR <?= e($f['fir_no'] ?? '') ?> from the central store? It will be logged and blocked from re-syncing.')">
          <input type="hidden" name="action" value="delete_fir">
          <input type="hidden" name="fir_id" value="<?= (int) $f['id'] ?>">
          <button class="del">Delete</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
  </table>
  <?php else: ?>
  <p class="muted">No FIRs have been uploaded to the central store yet. They appear here automatically once a station app syncs.</p>
  <?php endif; ?>
</div>

<?php if ($suppressed): ?>
<div class="card">
  <h3>🚫 Blocked FIRs <span class="muted" style="font-weight:400">(deleted by admin — won't re-sync)</span></h3>
  <p class="sub">These FIRs were removed from the central store and are blocked from being re-uploaded. Un-block one to let its station sync it back.</p>
  <table>
    <tr><th>Owner</th><th>Record id</th><th>Blocked at</th><th></th></tr>
    <?php foreach ($suppressed as $s): ?>
    <tr>
      <td><?= e($s['owner_email']) ?></td>
      <td class="muted"><?= e($s['remote_uid']) ?></td>
      <td class="muted"><?= e(fmtIst($s['suppressed_at'] ?? '')) ?></td>
      <td>
        <form method="post">
          <input type="hidden" name="action" value="unsuppress_fir">
          <input type="hidden" name="owner" value="<?= e($s['owner_email']) ?>">
          <input type="hidden" name="uid" value="<?= e($s['remote_uid']) ?>">
          <button class="rs">Un-block</button>
        </form>
      </td>
    </tr>
    <?php endforeach; ?>
  </table>
</div>
<?php endif; ?>
<script>
  function confirmClear() {
    if (!confirm('This permanently clears ALL FIR records from the central store. Continue?')) return false;
    var t = prompt('Type CLEAR to confirm wiping all central FIR records:');
    if (t !== 'CLEAR') { alert('Cancelled — you must type CLEAR exactly.'); return false; }
    document.getElementById('clearConfirm').value = 'CLEAR';
    return true;
  }
</script>

<?php elseif ($page === 'deletions'): ?>
<?php if ($firMsg): ?><div class="msg"><?= e($firMsg) ?></div><?php endif; ?>

<div class="card">
  <div class="pagehead">
    <h3>♻️ Recycle Bin <span class="muted" style="font-weight:400">(deleted FIRs — recoverable for 30 days)</span></h3>
    <?php if ($trash): ?>
    <div style="display:flex;gap:8px;align-items:center;flex-wrap:wrap">
      <form method="post" onsubmit="return confirm('Restore ALL <?= (int) $trashTotal ?> FIR(s) from the recycle bin?')">
        <input type="hidden" name="action" value="restore_all">
        <button class="ok">↩ Restore all</button>
      </form>
      <form method="post" id="emptyForm" onsubmit="return confirmEmpty()">
        <input type="hidden" name="action" value="empty_trash">
        <input type="hidden" name="confirm" id="emptyConfirm">
        <button class="del">🗑️ Empty bin</button>
      </form>
    </div>
    <?php endif; ?>
  </div>
  <p class="sub">
    Every deleted FIR — whether removed by a station or cleared from the admin
    panel — is kept here in full for <b>30 days</b>. <b>Restore</b> puts it back
    into the central store; entries older than 30 days are deleted automatically.
    <?= (int) $trashTotal ?> recoverable now.
  </p>
  <?php if ($trash): ?>
  <form method="post" id="selForm">
    <input type="hidden" name="action" value="restore_selected">
    <div class="toolbar">
      <button type="submit" class="ok">↩ Restore selected</button>
      <span class="muted">Tick the rows you want, then Restore selected.</span>
    </div>
    <table>
      <tr>
        <th><input type="checkbox" onclick="toggleAll(this)" title="Select all"></th>
        <th>FIR No / Year</th><th>Station</th><th>Deleted by</th><th>Deleted (IST)</th><th>Time left</th><th>Data</th>
      </tr>
      <?php foreach ($trash as $t): ?>
      <?php
        $data = json_decode($t['data_json'] ?? '', true);
        $ageDays = (time() - strtotime(($t['deleted_at'] ?? '') . ' UTC')) / 86400;
        $left = max(0, 30 - (int) floor($ageDays));
      ?>
      <tr>
        <td><input type="checkbox" name="trash_ids[]" value="<?= (int) $t['id'] ?>" class="selbox"></td>
        <td><b><?= e($t['fir_no'] ?? '') ?: '—' ?></b><?= ($t['year'] ?? '') !== '' ? '/' . e($t['year']) : '' ?>
          <div class="muted"><?= e($t['owner_email'] ?? '') ?></div></td>
        <td><?= e($t['station_name'] ?? '') ?: '—' ?></td>
        <td class="muted"><?= e($t['deleted_by'] ?? '') ?: '—' ?></td>
        <td class="muted"><?= e(fmtIst($t['deleted_at'] ?? '')) ?></td>
        <td><span class="b <?= $left <= 5 ? 'denied' : 'approved' ?>"><?= (int) $left ?> day<?= $left === 1 ? '' : 's' ?></span></td>
        <td>
          <?php if (is_array($data) && $data): ?>
          <details class="sec"><summary>View data</summary><div class="kv">
            <?php foreach ($data as $dk => $dv): if (is_scalar($dv) && (string) $dv !== ''): ?>
              <div><b><?= e((string) $dk) ?>:</b> <?= e(mb_substr((string) $dv, 0, 200)) ?></div>
            <?php endif; endforeach; ?>
          </div></details>
          <?php else: ?><span class="muted">—</span><?php endif; ?>
        </td>
      </tr>
      <?php endforeach; ?>
    </table>
  </form>
  <p class="muted" style="margin-top:10px">Permanent delete of a single entry:</p>
  <div style="display:flex;gap:6px;flex-wrap:wrap">
    <?php foreach ($trash as $t): ?>
    <form method="post" onsubmit="return confirm('Permanently delete FIR <?= e($t['fir_no'] ?? '') ?>? This cannot be undone.')">
      <input type="hidden" name="action" value="purge_fir">
      <input type="hidden" name="trash_id" value="<?= (int) $t['id'] ?>">
      <button class="del"><?= e($t['fir_no'] ?? '') ?: '#' . (int) $t['id'] ?> ✕</button>
    </form>
    <?php endforeach; ?>
  </div>
  <?php else: ?>
  <p class="muted">Recycle bin is empty — no recoverable deletions.</p>
  <?php endif; ?>
</div>
<script>
  function toggleAll(cb) {
    document.querySelectorAll('#selForm .selbox').forEach(function (b) { b.checked = cb.checked; });
  }
  function confirmEmpty() {
    if (!confirm('Permanently delete ALL recycle-bin entries? This cannot be undone.')) return false;
    var t = prompt('Type CLEAR to permanently empty the recycle bin:');
    if (t !== 'CLEAR') { alert('Cancelled — you must type CLEAR exactly.'); return false; }
    document.getElementById('emptyConfirm').value = 'CLEAR';
    return true;
  }
</script>

<div class="card">
  <div class="pagehead">
    <h3>🗑️ FIR Deletion Audit</h3>
    <a class="exp" href="?export=deletions">⬇ Export CSV</a>
  </div>
  <p class="sub">
    Whenever a station deletes a FIR, it is recorded here — what was deleted,
    by whom, and from which device / IP — so a deletion can never go unnoticed.
    Showing the latest <?= count($deletions) ?> of <b><?= (int) $delTotal ?></b>.
  </p>
  <div class="toolbar">
    <input type="search" id="delSearch" placeholder="🔎 Search FIR no, station, email, device…" onkeyup="filterTable('delSearch','delTable')">
  </div>
  <?php if ($deletions): ?>
  <table id="delTable">
    <tr><th>Deleted (IST)</th><th>FIR No / Year</th><th>Station</th><th>Deleted by</th><th>Source device / IP</th></tr>
    <?php foreach ($deletions as $d): ?>
    <?php $key = strtolower(implode(' ', [$d['fir_no'] ?? '', $d['year'] ?? '', $d['station_name'] ?? '', $d['owner_email'] ?? '', $d['src_device'] ?? '', $d['src_ip'] ?? ''])); ?>
    <tr data-search="<?= e($key) ?>">
      <td><?= e(fmtIst($d['deleted_at'] ?? '')) ?></td>
      <td><b><?= e($d['fir_no'] ?? '') ?: '—' ?></b><?= ($d['year'] ?? '') !== '' ? '/' . e($d['year']) : '' ?></td>
      <td><?= e($d['station_name'] ?? '') ?: '—' ?></td>
      <td class="muted"><?= e($d['owner_email'] ?? '') ?></td>
      <td><?php srcCell($d); ?></td>
    </tr>
    <?php endforeach; ?>
  </table>
  <?php else: ?>
  <p class="muted">No deletions recorded. 👍</p>
  <?php endif; ?>
</div>

<?php elseif ($page === 'hierarchy'): ?>
<div class="card" id="hierarchy">
  <h3>🏛️ Officer Hierarchy <span class="muted" style="font-weight:400">(Zones → Divisions → Stations)</span></h3>
  <p class="muted">
    Define the chain here, then assign each officer an access level above
    (CP sees the whole city, a DCP sees one zone, an ACP sees one division,
    a station user just enters data). Stations not yet assigned to a division
    are only visible to the CP.
  </p>

  <div class="up row">
    <div>
      <form method="post">
        <input type="hidden" name="org_action" value="add_zone">
        <label>New zone (DCP)</label>
        <input type="text" name="zone_name" placeholder="e.g. Zone 1" required>
        <button type="submit">Add zone</button>
      </form>
    </div>
    <div>
      <form method="post">
        <input type="hidden" name="org_action" value="add_division">
        <label>New division (ACP)</label>
        <select name="zone_id" required>
          <option value="">— zone —</option>
          <?php foreach ($zones as $z): ?>
            <option value="<?= (int)$z['id'] ?>"><?= e($z['name']) ?></option>
          <?php endforeach; ?>
        </select>
        <input type="text" name="division_name" placeholder="e.g. ACP City" required>
        <button type="submit">Add division</button>
      </form>
    </div>
    <div>
      <form method="post">
        <input type="hidden" name="org_action" value="add_station">
        <label>New station</label>
        <input type="text" name="station_name" placeholder="Station name" required>
        <button type="submit">Add station</button>
      </form>
    </div>
  </div>

  <table style="margin-top:16px">
    <tr><th>Station</th><th>Assigned division (ACP)</th><th>Zone</th></tr>
    <?php foreach ($stations as $s): ?>
    <?php
      $curDiv = (int) ($s['division_id'] ?? 0);
      $curZoneName = '';
      foreach ($divisions as $d) {
          if ((int) $d['id'] === $curDiv) { $curZoneName = $zoneName[$d['zone_id']] ?? ''; break; }
      }
    ?>
    <tr>
      <td><?= e($s['name']) ?></td>
      <td>
        <form method="post">
          <input type="hidden" name="org_action" value="assign_station">
          <input type="hidden" name="station_id" value="<?= (int)$s['id'] ?>">
          <select name="division_id" onchange="this.form.submit()">
            <option value="0">— unassigned —</option>
            <?php foreach ($divisions as $d): ?>
              <option value="<?= (int)$d['id'] ?>"<?= $curDiv === (int)$d['id'] ? ' selected' : '' ?>>
                <?= e($d['name']) ?> (<?= e($zoneName[$d['zone_id']] ?? '') ?>)
              </option>
            <?php endforeach; ?>
          </select>
        </form>
      </td>
      <td><?= e($curZoneName ?: '—') ?></td>
    </tr>
    <?php endforeach; ?>
  </table>

  <?php if ($divisions): ?>
  <p class="muted" style="margin-top:16px">Remove a division or zone (stations are kept, just unassigned):</p>
  <div>
    <?php foreach ($divisions as $d): ?>
      <form method="post" onsubmit="return confirm('Delete division <?= e($d['name']) ?>?')">
        <input type="hidden" name="org_action" value="delete_division">
        <input type="hidden" name="division_id" value="<?= (int)$d['id'] ?>">
        <button class="del"><?= e($d['name']) ?> ✕</button>
      </form>
    <?php endforeach; ?>
    <?php foreach ($zones as $z): ?>
      <form method="post" onsubmit="return confirm('Delete zone <?= e($z['name']) ?> and its divisions?')">
        <input type="hidden" name="org_action" value="delete_zone">
        <input type="hidden" name="zone_id" value="<?= (int)$z['id'] ?>">
        <button class="no"><?= e($z['name']) ?> ✕</button>
      </form>
    <?php endforeach; ?>
  </div>
  <?php endif; ?>
</div>

<?php elseif ($page === 'windows'): ?>
<?php if ($relMsg): ?><div class="msg"><?= e($relMsg) ?></div><?php endif; ?>
<div class="card" id="win">
  <h3>🪟 Windows Updates</h3>
  <p class="sub">
    Publish the Windows <code>.exe</code> installer; the app downloads and
    installs it silently. Upload limit <b><?= e($uploadLimit) ?></b>
    (post max <b><?= e($postLimit) ?></b>) — for bigger files use the FTP register option.
  </p>
  <?php renderReleaseSection(
      'windows',
      $relWin,
      array_values(array_filter($pendingFiles, fn($f) => platformForFile($f) === 'windows')),
      $uploadLimit
  ); ?>
</div>

<?php elseif ($page === 'macos'): ?>
<?php if ($relMsg): ?><div class="msg"><?= e($relMsg) ?></div><?php endif; ?>
<div class="card" id="mac">
  <h3>🍎 macOS Updates</h3>
  <p class="sub">
    Publish the macOS <code>.dmg</code> build (Apple Silicon M1–M5 + Intel).
    The app prompts the user and opens the <code>.dmg</code> to install. Large
    <code>.dmg</code> files usually exceed the upload limit — drop them into
    <code>api/releases/</code> by FTP and register below.
  </p>
  <?php renderReleaseSection(
      'macos',
      $relMac,
      array_values(array_filter($pendingFiles, fn($f) => platformForFile($f) === 'macos')),
      $uploadLimit
  ); ?>
</div>

<?php elseif ($page === 'linux'): ?>
<?php if ($relMsg): ?><div class="msg"><?= e($relMsg) ?></div><?php endif; ?>
<div class="card" id="linux">
  <h3>🐧 Linux Updates</h3>
  <p class="sub">
    Publish the Linux <code>.AppImage</code> build (portable, no install — runs
    on most 64-bit distributions). The app downloads the new <code>.AppImage</code>,
    makes it executable and relaunches automatically. Large files usually exceed
    the upload limit — drop them into <code>api/releases/</code> by FTP and
    register below.
  </p>
  <?php renderReleaseSection(
      'linux',
      $relLinux,
      array_values(array_filter($pendingFiles, fn($f) => platformForFile($f) === 'linux')),
      $uploadLimit
  ); ?>
</div>
<?php endif; ?>

</div><!-- .wrap -->
<script>
  // Generic client-side filter for the FIR / deletions tables.
  function filterTable(inputId, tableId) {
    var q = document.getElementById(inputId).value.toLowerCase().trim();
    document.querySelectorAll('#' + tableId + ' tr[data-search]').forEach(function (tr) {
      tr.style.display = tr.getAttribute('data-search').indexOf(q) > -1 ? '' : 'none';
    });
  }
</script>
</body></html>
