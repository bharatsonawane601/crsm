<?php
require_once __DIR__ . '/config.php';

/// The shared column list for central_crimes <-> central_trash moves, in a
/// fixed order so INSERT ... SELECT statements line up. Excludes id/updated_at.
const CENTRAL_COLS = 'owner_email,remote_uid,station_id,station_name,fir_no,year,'
    . 'crime_type,section,status,date_occurred,date_registered,data_json,'
    . 'src_device,src_platform,src_os,src_ip';

/// Opens a PDO connection and ensures the access_users table exists.
function db(): PDO
{
    static $pdo = null;
    if ($pdo !== null) return $pdo;

    $pdo = new PDO(
        'mysql:host=' . DB_HOST . ';dbname=' . DB_NAME . ';charset=utf8mb4',
        DB_USER,
        DB_PASS,
        [
            PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
            PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
        ]
    );

    // Store every timestamp in UTC regardless of the host's MySQL timezone, so
    // CURRENT_TIMESTAMP is consistent. The admin panel converts to IST on
    // display (see fmtIst() in admin.php).
    $pdo->exec("SET time_zone = '+00:00'");

    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS access_users (
            id           INT AUTO_INCREMENT PRIMARY KEY,
            email        VARCHAR(190) NOT NULL UNIQUE,
            name         VARCHAR(190) NULL,
            status       ENUM("pending","approved","denied") NOT NULL DEFAULT "pending",
            hwid         VARCHAR(128) NULL,
            requested_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            decided_at   DATETIME NULL,
            expires_at   DATETIME NULL,
            last_seen_at DATETIME NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4'
    );

    // Add expires_at to tables created before this column existed.
    ensureColumn($pdo, 'access_users', 'expires_at', 'DATETIME NULL');

    // --- Officer hierarchy + read-only portal -----------------------------
    // The org tree is DATA-DRIVEN (editable in the admin panel) so zones /
    // divisions / stations can be added or re-mapped without code changes.
    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS org_zones (
            id      INT AUTO_INCREMENT PRIMARY KEY,
            name    VARCHAR(120) NOT NULL,
            name_mr VARCHAR(120) NULL,
            sort    INT NOT NULL DEFAULT 0
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4'
    );
    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS org_divisions (
            id      INT AUTO_INCREMENT PRIMARY KEY,
            zone_id INT NOT NULL,
            name    VARCHAR(120) NOT NULL,
            name_mr VARCHAR(120) NULL,
            sort    INT NOT NULL DEFAULT 0,
            FOREIGN KEY (zone_id) REFERENCES org_zones(id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4'
    );
    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS org_stations (
            id          INT AUTO_INCREMENT PRIMARY KEY,
            division_id INT NULL,
            name        VARCHAR(160) NOT NULL UNIQUE,
            name_mr     VARCHAR(160) NULL,
            code        VARCHAR(40) NULL,
            sort        INT NOT NULL DEFAULT 0,
            FOREIGN KEY (division_id) REFERENCES org_divisions(id) ON DELETE SET NULL
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4'
    );

    // Officer role + jurisdiction scope on the existing user row.
    //   role: 'station' = normal data-entry app user (uploads its station data)
    //         'acp' | 'dcp' | 'cp' = read-only portal officer.
    // Scope columns are filled per role (cp = whole city, no scope id needed).
    ensureColumn($pdo, 'access_users', 'role',
        "ENUM('station','acp','dcp','cp') NOT NULL DEFAULT 'station'");
    ensureColumn($pdo, 'access_users', 'scope_zone_id', 'INT NULL');
    ensureColumn($pdo, 'access_users', 'scope_division_id', 'INT NULL');
    ensureColumn($pdo, 'access_users', 'scope_station_id', 'INT NULL');

    // Security / audit fields captured on every app check-in (see check.php).
    ensureColumn($pdo, 'access_users', 'last_ip', 'VARCHAR(45) NULL');
    ensureColumn($pdo, 'access_users', 'user_agent', 'VARCHAR(255) NULL');
    ensureColumn($pdo, 'access_users', 'client_platform', 'VARCHAR(20) NULL');
    ensureColumn($pdo, 'access_users', 'client_os', 'VARCHAR(160) NULL');
    ensureColumn($pdo, 'access_users', 'client_device', 'VARCHAR(190) NULL');
    ensureColumn($pdo, 'access_users', 'app_version', 'VARCHAR(40) NULL');

    // Central crime/FIR store — each station app uploads its records here so
    // senior officers can search across their whole jurisdiction. Indexed
    // columns drive search + dashboard; data_json holds the full record for the
    // detail view / PDF export.
    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS central_crimes (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            owner_email     VARCHAR(190) NOT NULL,
            remote_uid      VARCHAR(80) NOT NULL,
            station_id      INT NULL,
            station_name    VARCHAR(160) NULL,
            fir_no          VARCHAR(80) NULL,
            year            INT NULL,
            crime_type      VARCHAR(190) NULL,
            section         VARCHAR(255) NULL,
            status          VARCHAR(40) NULL,
            date_occurred   DATE NULL,
            date_registered DATE NULL,
            data_json       LONGTEXT NULL,
            updated_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            UNIQUE KEY uniq_owner_uid (owner_email, remote_uid),
            KEY idx_station (station_id),
            KEY idx_year (year),
            KEY idx_status (status)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4'
    );
    // Which device/IP last uploaded each FIR — so the admin can audit the
    // source of every record. Added by migration on existing installs.
    ensureColumn($pdo, 'central_crimes', 'src_device', 'VARCHAR(190) NULL');
    ensureColumn($pdo, 'central_crimes', 'src_platform', 'VARCHAR(20) NULL');
    ensureColumn($pdo, 'central_crimes', 'src_os', 'VARCHAR(160) NULL');
    ensureColumn($pdo, 'central_crimes', 'src_ip', 'VARCHAR(45) NULL');

    // Audit trail of FIR deletions. When a station deletes a FIR the app reports
    // it here (best-effort) and the central copy is removed, so a senior officer
    // can always see what was deleted, by whom, from which device.
    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS central_deletions (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            owner_email     VARCHAR(190) NOT NULL,
            remote_uid      VARCHAR(80) NULL,
            fir_no          VARCHAR(80) NULL,
            year            INT NULL,
            station_name    VARCHAR(160) NULL,
            src_device      VARCHAR(190) NULL,
            src_platform    VARCHAR(20) NULL,
            src_os          VARCHAR(160) NULL,
            src_ip          VARCHAR(45) NULL,
            deleted_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            KEY idx_owner (owner_email),
            KEY idx_when (deleted_at)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4'
    );

    // Tombstones for FIRs the admin removed from the central store. The upload
    // endpoint skips any (owner_email, remote_uid) listed here, so an admin
    // deletion is not silently re-created the next time the station syncs.
    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS central_suppressed (
            owner_email VARCHAR(190) NOT NULL,
            remote_uid  VARCHAR(80) NOT NULL,
            suppressed_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (owner_email, remote_uid)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4'
    );

    // Recycle bin: a full copy of every deleted FIR (admin or station deletion)
    // kept for 30 days so it can be restored. Auto-purged after that in admin.php.
    $pdo->exec(
        'CREATE TABLE IF NOT EXISTS central_trash (
            id              BIGINT AUTO_INCREMENT PRIMARY KEY,
            owner_email     VARCHAR(190) NOT NULL,
            remote_uid      VARCHAR(80) NOT NULL,
            station_id      INT NULL,
            station_name    VARCHAR(160) NULL,
            fir_no          VARCHAR(80) NULL,
            year            INT NULL,
            crime_type      VARCHAR(190) NULL,
            section         VARCHAR(255) NULL,
            status          VARCHAR(40) NULL,
            date_occurred   DATE NULL,
            date_registered DATE NULL,
            data_json       LONGTEXT NULL,
            src_device      VARCHAR(190) NULL,
            src_platform    VARCHAR(20) NULL,
            src_os          VARCHAR(160) NULL,
            src_ip          VARCHAR(45) NULL,
            deleted_by      VARCHAR(190) NULL,
            deleted_at      DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
            KEY idx_when (deleted_at)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4'
    );

    seedOrg($pdo);

    // Released app versions for the in-app updater. `platform` lets one server
    // serve both the Windows (.exe) and macOS (.dmg) builds of the same version.
    $pdo->exec(
        "CREATE TABLE IF NOT EXISTS app_release (
            id         INT AUTO_INCREMENT PRIMARY KEY,
            version    VARCHAR(40) NOT NULL,
            build      INT NOT NULL,
            platform   VARCHAR(10) NOT NULL DEFAULT 'windows',
            file_name  VARCHAR(190) NOT NULL,
            notes      TEXT NULL,
            mandatory  TINYINT(1) NOT NULL DEFAULT 0,
            sha256     CHAR(64) NULL,
            created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"
    );
    // Migrate older app_release tables that predate the platform column.
    ensureColumn($pdo, 'app_release', 'platform', "VARCHAR(10) NOT NULL DEFAULT 'windows'");

    return $pdo;
}

/// The 18 Chhatrapati Sambhaji Nagar city police stations. Kept in sync with
/// kPoliceStations in the app. All are ensured to exist; only their
/// division mapping is seeded (and only on first run).
const ORG_STATIONS = [
    'City Chowk', 'Kranti Chowk', 'Vedant Nagar', 'Begumpura', 'Chhavani',
    'Waluj', 'MIDC Waluj', 'Daulatabad', 'Jinsi', 'CIDCO', 'MIDC CIDCO',
    'Harsul', 'Jawahar Nagar', 'Usmanpura', 'Pundlik Nagar', 'Mukundwadi',
    'Satara', 'Cyber Police Station',
];

/// Seeds the org tree once. Idempotent: always ensures every station row
/// exists, but only creates the zone/division structure + initial mapping when
/// no zones exist yet (so later admin edits are never clobbered). Both zones'
/// ACP divisions and their station mappings are seeded; Cyber Police Station
/// is left unassigned (city-wide unit) for the admin to map if needed.
function seedOrg(PDO $pdo): void
{
    // Always make sure every station exists (division left NULL if new).
    $ins = $pdo->prepare('INSERT IGNORE INTO org_stations (name) VALUES (?)');
    foreach (ORG_STATIONS as $s) $ins->execute([$s]);

    // Only build the hierarchy the first time.
    if ((int) $pdo->query('SELECT COUNT(*) FROM org_zones')->fetchColumn() > 0) {
        return;
    }

    $pdo->prepare('INSERT INTO org_zones (name, sort) VALUES (?, ?)')
        ->execute(['Zone 1', 1]);
    $zone1 = (int) $pdo->lastInsertId();
    $pdo->prepare('INSERT INTO org_zones (name, sort) VALUES (?, ?)')
        ->execute(['Zone 2', 2]);
    $zone2 = (int) $pdo->lastInsertId();

    $divIns = $pdo->prepare(
        'INSERT INTO org_divisions (zone_id, name, sort) VALUES (?, ?, ?)'
    );
    $divIns->execute([$zone1, 'ACP City', 1]);
    $acpCity = (int) $pdo->lastInsertId();
    $divIns->execute([$zone1, 'ACP Chhavni', 2]);
    $acpChhavni = (int) $pdo->lastInsertId();
    $divIns->execute([$zone2, 'ACP CIDCO', 1]);
    $acpCidco = (int) $pdo->lastInsertId();
    $divIns->execute([$zone2, 'ACP Usmanpura', 2]);
    $acpUsmanpura = (int) $pdo->lastInsertId();

    $map = [
        $acpCity => ['City Chowk', 'Kranti Chowk', 'Vedant Nagar', 'Begumpura'],
        $acpChhavni => ['Chhavani', 'MIDC Waluj', 'Waluj', 'Daulatabad'],
        $acpCidco => ['CIDCO', 'MIDC CIDCO', 'Jinsi', 'Harsul'],
        $acpUsmanpura => ['Mukundwadi', 'Jawahar Nagar', 'Usmanpura', 'Satara', 'Pundlik Nagar'],
    ];
    $upd = $pdo->prepare(
        'UPDATE org_stations SET division_id = ? WHERE name = ?'
    );
    foreach ($map as $divId => $stations) {
        foreach ($stations as $name) $upd->execute([$divId, $name]);
    }
}

/// Resolves the set of station ids a user may see, from their role + scope:
///   cp      -> all stations
///   dcp     -> stations whose division is in the user's zone
///   acp     -> stations in the user's division
///   station -> the user's own station (if any)
/// Returns ['all' => true] for CP, else ['ids' => int[]].
function stationScopeForUser(PDO $pdo, array $user): array
{
    $role = $user['role'] ?? 'station';
    if ($role === 'cp') return ['all' => true];

    if ($role === 'dcp' && !empty($user['scope_zone_id'])) {
        $q = $pdo->prepare(
            'SELECT s.id FROM org_stations s
             JOIN org_divisions d ON s.division_id = d.id
             WHERE d.zone_id = ?'
        );
        $q->execute([$user['scope_zone_id']]);
        return ['ids' => array_map('intval', $q->fetchAll(PDO::FETCH_COLUMN))];
    }
    if ($role === 'acp' && !empty($user['scope_division_id'])) {
        $q = $pdo->prepare('SELECT id FROM org_stations WHERE division_id = ?');
        $q->execute([$user['scope_division_id']]);
        return ['ids' => array_map('intval', $q->fetchAll(PDO::FETCH_COLUMN))];
    }
    if (!empty($user['scope_station_id'])) {
        return ['ids' => [(int) $user['scope_station_id']]];
    }
    return ['ids' => []];
}

/// Station ids for a zone / division / station (org-tree lookups).
function stationIdsInZone(PDO $pdo, int $zoneId): array
{
    $q = $pdo->prepare(
        'SELECT s.id FROM org_stations s
         JOIN org_divisions d ON s.division_id = d.id WHERE d.zone_id = ?'
    );
    $q->execute([$zoneId]);
    return array_map('intval', $q->fetchAll(PDO::FETCH_COLUMN));
}

function stationIdsInDivision(PDO $pdo, int $divisionId): array
{
    $q = $pdo->prepare('SELECT id FROM org_stations WHERE division_id = ?');
    $q->execute([$divisionId]);
    return array_map('intval', $q->fetchAll(PDO::FETCH_COLUMN));
}

/// The effective station scope for a request: the user's base scope, optionally
/// narrowed by a requested zone/division/station filter. The narrowing is always
/// intersected with the base scope, so an officer can never widen their access.
/// Returns ['all' => true] (CP, no filter) or ['ids' => int[]].
function effectiveScope(PDO $pdo, array $user, array $body): array
{
    $base = stationScopeForUser($pdo, $user);

    $reqIds = null;
    if (!empty($body['station_id'])) {
        $reqIds = [(int) $body['station_id']];
    } elseif (!empty($body['division_id'])) {
        $reqIds = stationIdsInDivision($pdo, (int) $body['division_id']);
    } elseif (!empty($body['zone_id'])) {
        $reqIds = stationIdsInZone($pdo, (int) $body['zone_id']);
    }
    if ($reqIds === null) return $base; // no narrowing requested

    if (!empty($base['all'])) return ['ids' => $reqIds];
    return ['ids' => array_values(array_intersect($reqIds, $base['ids'] ?? []))];
}

/// Builds the scope-filter SQL fragment + params from an effective scope.
/// Returns [whereSql, params] where whereSql is '' (all) or 'station_id IN (...)'.
/// When the scope is an empty id set, returns an impossible condition so the
/// query yields nothing.
function scopeWhere(array $scope): array
{
    if (!empty($scope['all'])) return ['', []];
    $ids = $scope['ids'] ?? [];
    if (count($ids) === 0) return ['1=0', []];
    return ['station_id IN (' . implode(',', array_fill(0, count($ids), '?')) . ')', $ids];
}

/// Absolute path to the folder where uploaded installers are stored.
function releasesDir(): string
{
    return __DIR__ . '/releases';
}

/// Public URL of an installer file in the releases folder (same host/dir as the
/// API). e.g. https://site/api/releases/crms-setup-1.1.0.exe
function releaseUrl(string $fileName): string
{
    $scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off')
        ? 'https' : 'http';
    $host = $_SERVER['HTTP_HOST'] ?? '';
    $dir = rtrim(str_replace('\\', '/', dirname($_SERVER['SCRIPT_NAME'] ?? '')), '/');
    return $scheme . '://' . $host . $dir . '/releases/' . rawurlencode($fileName);
}

/// Adds a column if it isn't already present (simple migration helper).
function ensureColumn(PDO $pdo, string $table, string $col, string $def): void
{
    $q = $pdo->prepare(
        'SELECT COUNT(*) FROM information_schema.COLUMNS
         WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = ? AND COLUMN_NAME = ?'
    );
    $q->execute([$table, $col]);
    if ((int) $q->fetchColumn() === 0) {
        $pdo->exec("ALTER TABLE `$table` ADD COLUMN `$col` $def");
    }
}

/// Maps a version string ("1.2.3") to a single comparable integer. Must match
/// the Dart `versionToBuild()` in the app so both agree on update ordering.
function versionToBuild(string $version): int
{
    $parts = preg_split('/[.+\-]/', trim($version));
    $at = function (int $i) use ($parts): int {
        return isset($parts[$i]) && is_numeric(trim($parts[$i]))
            ? (int) trim($parts[$i]) : 0;
    };
    $major = max(0, min(2000, $at(0)));
    $minor = max(0, min(999, $at(1)));
    $patch = max(0, min(999, $at(2)));
    return $major * 1000000 + $minor * 1000 + $patch;
}

/// Shared-key gate for an API request. Stops with 401 on mismatch.
function requireAppKey(): void
{
    $appKey = $_SERVER['HTTP_X_APP_KEY'] ?? '';
    if (!hash_equals(APP_KEY, $appKey)) {
        http_response_code(401);
        respond(['ok' => false, 'message' => 'access.error.server']);
    }
}

/// Reads the JSON request body as an array.
function jsonBody(): array
{
    return json_decode(file_get_contents('php://input'), true) ?? [];
}

/// Best-effort client IP, honouring the proxy headers Hostinger / Cloudflare
/// set in front of PHP, then falling back to the direct connection address.
function clientIp(): string
{
    foreach (['HTTP_CF_CONNECTING_IP', 'HTTP_X_FORWARDED_FOR', 'HTTP_X_REAL_IP'] as $h) {
        if (!empty($_SERVER[$h])) {
            // X-Forwarded-For can be a comma list "client, proxy1, proxy2".
            $ip = trim(explode(',', $_SERVER[$h])[0]);
            if (filter_var($ip, FILTER_VALIDATE_IP)) return $ip;
        }
    }
    return $_SERVER['REMOTE_ADDR'] ?? '';
}

/// Loads an approved, non-expired user by email or stops with an error status.
/// Returns the user row. Used by the data endpoints (upload / portal).
function requireApprovedUser(PDO $pdo, string $email): array
{
    $stmt = $pdo->prepare('SELECT * FROM access_users WHERE email = ?');
    $stmt->execute([strtolower(trim($email))]);
    $user = $stmt->fetch();
    if (!$user || $user['status'] !== 'approved') {
        respond(['ok' => false, 'status' => 'denied']);
    }
    if (!empty($user['expires_at']) && strtotime($user['expires_at']) < time()) {
        respond(['ok' => false, 'status' => 'expired']);
    }
    return $user;
}

/// Sends a JSON response and stops.
function respond(array $data): void
{
    header('Content-Type: application/json');
    echo json_encode($data);
    exit;
}
