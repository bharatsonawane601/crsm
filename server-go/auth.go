package main

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"crypto/subtle"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
	"golang.org/x/crypto/argon2"
)

// DB Square auth: admin-issued credentials, no self-registration.
//
// An officer taps "Request ID & password" in the app; an admin turns that
// request into a login and hands over a ONE-TIME password. First login forces
// a password change and binds the account to that machine's hardware id, after
// which the app holds a device-bound token instead of the password.
//
// Passwords are stored as Argon2id hashes — they cannot be read back, only
// reset. Nothing here trusts the client for identity: role, scope, access
// window and device binding are all decided server-side.

// --- Password hashing ------------------------------------------------------

// Argon2id parameters. 64 MB / 3 passes is the OWASP baseline and takes well
// under a second on the office VM, which is fine for a login that happens once
// per device rather than on every request.
const (
	argonTime    = 3
	argonMemory  = 64 * 1024
	argonThreads = 4
	argonKeyLen  = 32
	argonSaltLen = 16
)

// hashPassword returns an encoded Argon2id hash in the standard PHC string
// format, so the parameters travel with the hash and can be raised later
// without invalidating existing passwords.
func hashPassword(pw string) (string, error) {
	salt := make([]byte, argonSaltLen)
	if _, err := rand.Read(salt); err != nil {
		return "", err
	}
	key := argon2.IDKey([]byte(pw), salt, argonTime, argonMemory, argonThreads, argonKeyLen)
	return fmt.Sprintf("$argon2id$v=%d$m=%d,t=%d,p=%d$%s$%s",
		argon2.Version, argonMemory, argonTime, argonThreads,
		base64.RawStdEncoding.EncodeToString(salt),
		base64.RawStdEncoding.EncodeToString(key)), nil
}

// verifyPassword checks pw against an encoded hash in constant time. A
// malformed or empty hash always fails (never "matches everything").
func verifyPassword(pw, encoded string) bool {
	parts := strings.Split(encoded, "$")
	if len(parts) != 6 || parts[1] != "argon2id" {
		return false
	}
	var version int
	if _, err := fmt.Sscanf(parts[2], "v=%d", &version); err != nil || version != argon2.Version {
		return false
	}
	var memory uint32
	var timeCost uint32
	var threads uint8
	if _, err := fmt.Sscanf(parts[3], "m=%d,t=%d,p=%d", &memory, &timeCost, &threads); err != nil {
		return false
	}
	salt, err := base64.RawStdEncoding.DecodeString(parts[4])
	if err != nil {
		return false
	}
	want, err := base64.RawStdEncoding.DecodeString(parts[5])
	if err != nil {
		return false
	}
	got := argon2.IDKey([]byte(pw), salt, timeCost, memory, threads, uint32(len(want)))
	return subtle.ConstantTimeCompare(got, want) == 1
}

// --- Tokens ----------------------------------------------------------------

// newToken returns a 256-bit URL-safe random token and the hash stored in the
// database. Only the hash is persisted, so a database leak can't be replayed
// as a live session.
func newToken() (token, hash string, err error) {
	raw := make([]byte, 32)
	if _, err = rand.Read(raw); err != nil {
		return "", "", err
	}
	token = base64.RawURLEncoding.EncodeToString(raw)
	return token, hashToken(token), nil
}

func hashToken(token string) string {
	sum := sha256.Sum256([]byte(token))
	return hex.EncodeToString(sum[:])
}

// generatePassword builds a readable one-time password: 12 characters from an
// alphabet with no 0/O/1/l/I, so it survives being written on paper and read
// back over a phone line.
func generatePassword() (string, error) {
	const alphabet = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnpqrstuvwxyz23456789"
	buf := make([]byte, 12)
	if _, err := rand.Read(buf); err != nil {
		return "", err
	}
	out := make([]byte, len(buf))
	for i, b := range buf {
		out[i] = alphabet[int(b)%len(alphabet)]
	}
	return string(out), nil
}

// --- Audit -----------------------------------------------------------------

// audit records a security event. Best-effort: a logging failure must never
// block or fail the login it describes.
func (a *App) audit(ctx context.Context, ev auditEvent) {
	_, _ = a.db.Exec(ctx, `
		INSERT INTO login_audit
			(login_id, email, actor, event, detail, ip, hwid, device, os, app_version)
		VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10)`,
		normStr(ev.LoginID), normStr(ev.Email), normStr(ev.Actor), ev.Event,
		normStr(ev.Detail), normStr(ev.IP), normStr(ev.HWID),
		normStr(ev.Device), normStr(ev.OS), normStr(ev.AppVersion))
}

type auditEvent struct {
	LoginID    string
	Email      string
	Actor      string // admin username for admin-side actions
	Event      string // login.ok, login.bad_password, device.mismatch, ...
	Detail     string
	IP         string
	HWID       string
	Device     string
	OS         string
	AppVersion string
}

// auditFromRequest pre-fills the client fields every app request carries.
func auditFromRequest(r *http.Request, b map[string]any) auditEvent {
	return auditEvent{
		IP:         clientIP(r),
		HWID:       bodyStr(b, "hwid"),
		Device:     truncate(bodyStr(b, "device"), 190),
		OS:         truncate(bodyStr(b, "os"), 160),
		AppVersion: truncate(bodyStr(b, "app_version"), 40),
	}
}

// --- Login -----------------------------------------------------------------

// Lockout policy: five wrong passwords freeze the account for 15 minutes. The
// counter is per-account (not per-IP) because the threat here is someone with
// a stolen credential slip, not a botnet.
const (
	maxFailedAttempts = 5
	lockoutDuration   = 15 * time.Minute
)

type authUser struct {
	ID           int64
	Email        string
	LoginID      string
	Name         *string
	Status       string
	Role         string
	PasswordHash *string
	MustChangePw bool
	TempExpires  *time.Time
	Failed       int
	LockedUntil  *time.Time
	BoundHwid    *string
	ExpiresAt    *time.Time
}

// loadAuthUser fetches a user by login id (case-insensitive). Email is also
// accepted so the existing Google-era accounts can sign in with their address
// during the changeover.
func (a *App) loadAuthUser(ctx context.Context, loginID string) (*authUser, error) {
	u := &authUser{}
	err := a.db.QueryRow(ctx, `
		SELECT id, email, COALESCE(login_id,''), name, status, role,
		       password_hash, must_change_pw, temp_expires_at,
		       failed_attempts, locked_until, hwid, expires_at
		  FROM access_users
		 WHERE lower(login_id) = lower($1) OR lower(email) = lower($1)
		 ORDER BY (lower(login_id) = lower($1)) DESC
		 LIMIT 1`, loginID,
	).Scan(&u.ID, &u.Email, &u.LoginID, &u.Name, &u.Status, &u.Role,
		&u.PasswordHash, &u.MustChangePw, &u.TempExpires,
		&u.Failed, &u.LockedUntil, &u.BoundHwid, &u.ExpiresAt)
	if err != nil {
		return nil, err
	}
	return u, nil
}

// handleAuthLogin exchanges an ID + password (+ this machine's hwid) for a
// device-bound session token.
//
// Failure responses are deliberately uniform ("access.error.credentials") so
// the endpoint can't be used to discover which login IDs exist. The genuinely
// actionable states — must change password, locked out, expired, wrong device,
// awaiting approval — do get their own message, because the user needs to know
// what to do next and none of them leak anything to a stranger.
func (a *App) handleAuthLogin(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	loginID := strings.TrimSpace(bodyStr(b, "login_id"))
	password := bodyStr(b, "password")
	hwid := bodyStr(b, "hwid")
	ev := auditFromRequest(r, b)
	ev.LoginID = loginID

	if loginID == "" || password == "" || hwid == "" {
		respond(w, map[string]any{"ok": false, "message": "access.error.credentials"})
		return
	}

	u, err := a.loadAuthUser(ctx, loginID)
	if errors.Is(err, pgx.ErrNoRows) {
		// Hash anyway so a missing account and a wrong password take the same
		// time — otherwise response timing reveals which IDs are real.
		_ = verifyPassword(password, "$argon2id$v=19$m=65536,t=3,p=4$"+
			"AAAAAAAAAAAAAAAAAAAAAA$AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA")
		ev.Event = "login.unknown_id"
		a.audit(ctx, ev)
		respond(w, map[string]any{"ok": false, "message": "access.error.credentials"})
		return
	}
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	ev.Email = u.Email

	if u.LockedUntil != nil && u.LockedUntil.After(time.Now()) {
		ev.Event = "login.locked"
		a.audit(ctx, ev)
		respond(w, map[string]any{
			"ok":      false,
			"message": "access.error.locked",
			"minutes": int(time.Until(*u.LockedUntil).Minutes()) + 1,
		})
		return
	}

	// No password set yet: the account exists (or is a legacy Google user) but
	// an admin hasn't issued credentials.
	if u.PasswordHash == nil || *u.PasswordHash == "" {
		ev.Event = "login.no_password"
		a.audit(ctx, ev)
		respond(w, map[string]any{"ok": false, "message": "access.error.no_password"})
		return
	}

	if !verifyPassword(password, *u.PasswordHash) {
		failed := u.Failed + 1
		if failed >= maxFailedAttempts {
			until := time.Now().Add(lockoutDuration)
			_, _ = a.db.Exec(ctx, `
				UPDATE access_users SET failed_attempts = 0, locked_until = $1
				 WHERE id = $2`, until, u.ID)
			ev.Event = "login.lockout"
			ev.Detail = fmt.Sprintf("locked for %v after %d failed attempts",
				lockoutDuration, maxFailedAttempts)
			a.audit(ctx, ev)
			respond(w, map[string]any{
				"ok": false, "message": "access.error.locked",
				"minutes": int(lockoutDuration.Minutes()),
			})
			return
		}
		_, _ = a.db.Exec(ctx,
			`UPDATE access_users SET failed_attempts = $1 WHERE id = $2`, failed, u.ID)
		ev.Event = "login.bad_password"
		ev.Detail = fmt.Sprintf("attempt %d of %d", failed, maxFailedAttempts)
		a.audit(ctx, ev)
		respond(w, map[string]any{"ok": false, "message": "access.error.credentials"})
		return
	}

	// Correct password. A one-time password that was never used in time is
	// dead — the admin must issue a new one.
	if u.MustChangePw && u.TempExpires != nil && u.TempExpires.Before(time.Now()) {
		ev.Event = "login.temp_expired"
		a.audit(ctx, ev)
		respond(w, map[string]any{"ok": false, "message": "access.error.temp_expired"})
		return
	}

	if u.Status != "approved" {
		ev.Event = "login.not_approved"
		ev.Detail = "status=" + u.Status
		a.audit(ctx, ev)
		respond(w, map[string]any{"ok": false, "message": "access.status." + u.Status})
		return
	}
	if u.ExpiresAt != nil && u.ExpiresAt.Before(time.Now()) {
		ev.Event = "login.expired"
		a.audit(ctx, ev)
		respond(w, map[string]any{"ok": false, "message": "access.error.expired"})
		return
	}

	// One login = one device. The first successful login claims the machine;
	// after that a different hwid is refused and flagged for the admin.
	if a.cfg.OneDevicePerEmail {
		if u.BoundHwid == nil || *u.BoundHwid == "" {
			if _, err := a.db.Exec(ctx,
				`UPDATE access_users SET hwid = $1 WHERE id = $2`, hwid, u.ID); err != nil {
				respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
				return
			}
			ev.Event = "device.bound"
			a.audit(ctx, ev)
		} else if *u.BoundHwid != hwid {
			ev.Event = "device.mismatch"
			ev.Detail = "bound to another machine"
			a.audit(ctx, ev)
			respond(w, map[string]any{"ok": false, "message": "access.error.device"})
			return
		}
	}

	// Password must be changed before a session is issued: the caller gets a
	// short-lived change ticket, not a working token.
	if u.MustChangePw {
		token, hash, err := newToken()
		if err != nil {
			respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
			return
		}
		expires := time.Now().Add(15 * time.Minute)
		if err := a.storeSession(ctx, u.ID, hash, hwid, &expires, r, b); err != nil {
			respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
			return
		}
		_, _ = a.db.Exec(ctx,
			`UPDATE access_users SET failed_attempts = 0, locked_until = NULL WHERE id = $1`, u.ID)
		ev.Event = "login.must_change_pw"
		a.audit(ctx, ev)
		respond(w, map[string]any{
			"ok": true, "must_change_password": true, "change_token": token,
		})
		return
	}

	token, hash, err := newToken()
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	// The session never outlives the account's access window.
	if err := a.storeSession(ctx, u.ID, hash, hwid, u.ExpiresAt, r, b); err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	_, _ = a.db.Exec(ctx, `
		UPDATE access_users
		   SET failed_attempts = 0, locked_until = NULL, last_login_at = now(),
		       last_seen_at = now(), last_ip = $1, client_device = $2,
		       client_os = $3, app_version = $4
		 WHERE id = $5`,
		normStr(ev.IP), normStr(ev.Device), normStr(ev.OS), normStr(ev.AppVersion), u.ID)
	ev.Event = "login.ok"
	a.audit(ctx, ev)

	respond(w, a.authOK(ctx, u, token))
}

// authOK is the shared "you're in" response for login / change-password /
// session — same role/portal/scope shape the app's access layer already reads
// from /check.php, plus the session token.
func (a *App) authOK(ctx context.Context, u *authUser, token string) map[string]any {
	return map[string]any{
		"ok":         true,
		"status":     "approved",
		"token":      token,
		"login_id":   u.LoginID,
		"email":      u.Email,
		"name":       u.Name,
		"role":       u.Role,
		"portal":     u.Role == "acp" || u.Role == "dcp" || u.Role == "cp",
		"scope":      a.scopeLabels(ctx, u.Email),
		"expires_at": isoOrNil(u.ExpiresAt),
	}
}

func (a *App) storeSession(ctx context.Context, userID int64, tokenHash, hwid string,
	expires *time.Time, r *http.Request, b map[string]any) error {
	_, err := a.db.Exec(ctx, `
		INSERT INTO auth_sessions
			(user_id, token_hash, hwid, expires_at, client_ip,
			 client_device, client_os, app_version)
		VALUES ($1,$2,$3,$4,$5,$6,$7,$8)`,
		userID, tokenHash, hwid, expires, normStr(clientIP(r)),
		normStr(truncate(bodyStr(b, "device"), 190)),
		normStr(truncate(bodyStr(b, "os"), 160)),
		normStr(truncate(bodyStr(b, "app_version"), 40)))
	return err
}

// handleAuthChangePassword sets a new password using either the change ticket
// from a forced first login or a normal live session. The new password is
// checked for length and for not repeating the old one, all sessions are
// revoked, and the caller is issued a fresh token.
func (a *App) handleAuthChangePassword(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	token := bodyStr(b, "token")
	newPw := bodyStr(b, "new_password")
	hwid := bodyStr(b, "hwid")
	ev := auditFromRequest(r, b)

	if token == "" || hwid == "" {
		respond(w, map[string]any{"ok": false, "message": "access.error.session"})
		return
	}
	if len([]rune(newPw)) < 8 {
		respond(w, map[string]any{"ok": false, "message": "access.error.pw_short"})
		return
	}

	u, err := a.sessionUser(ctx, token, hwid)
	if err != nil {
		respond(w, map[string]any{"ok": false, "message": "access.error.session"})
		return
	}
	ev.LoginID, ev.Email = u.LoginID, u.Email

	if u.PasswordHash != nil && verifyPassword(newPw, *u.PasswordHash) {
		respond(w, map[string]any{"ok": false, "message": "access.error.pw_same"})
		return
	}
	hash, err := hashPassword(newPw)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	tx, err := a.db.Begin(ctx)
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	defer tx.Rollback(ctx)

	if _, err := tx.Exec(ctx, `
		UPDATE access_users
		   SET password_hash = $1, must_change_pw = false, temp_expires_at = NULL,
		       pw_admin_set = false, pw_changed_at = now(),
		       failed_attempts = 0, locked_until = NULL
		 WHERE id = $2`, hash, u.ID); err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	// Changing a password invalidates every existing session, including the
	// change ticket that got us here.
	if _, err := tx.Exec(ctx, `
		UPDATE auth_sessions SET revoked_at = now()
		 WHERE user_id = $1 AND revoked_at IS NULL`, u.ID); err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	newToken, newHash, err := newToken()
	if err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	if _, err := tx.Exec(ctx, `
		INSERT INTO auth_sessions (user_id, token_hash, hwid, expires_at, client_ip)
		VALUES ($1,$2,$3,$4,$5)`,
		u.ID, newHash, hwid, u.ExpiresAt, normStr(clientIP(r))); err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}
	if err := tx.Commit(ctx); err != nil {
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return
	}

	ev.Event = "password.changed"
	a.audit(ctx, ev)
	respond(w, a.authOK(ctx, u, newToken))
}

// sessionUser resolves a token to its user, enforcing that the token is live,
// unexpired, issued to THIS machine, and that the account is still approved and
// inside its access window. Every authenticated call goes through here.
func (a *App) sessionUser(ctx context.Context, token, hwid string) (*authUser, error) {
	if token == "" {
		return nil, errors.New("no token")
	}
	u := &authUser{}
	var sessionHwid string
	var sessionExpires *time.Time
	err := a.db.QueryRow(ctx, `
		SELECT s.hwid, s.expires_at,
		       u.id, u.email, COALESCE(u.login_id,''), u.name, u.status, u.role,
		       u.password_hash, u.must_change_pw, u.hwid, u.expires_at
		  FROM auth_sessions s
		  JOIN access_users u ON u.id = s.user_id
		 WHERE s.token_hash = $1 AND s.revoked_at IS NULL`, hashToken(token),
	).Scan(&sessionHwid, &sessionExpires,
		&u.ID, &u.Email, &u.LoginID, &u.Name, &u.Status, &u.Role,
		&u.PasswordHash, &u.MustChangePw, &u.BoundHwid, &u.ExpiresAt)
	if err != nil {
		return nil, err
	}
	if sessionExpires != nil && sessionExpires.Before(time.Now()) {
		return nil, errors.New("session expired")
	}
	if hwid != "" && sessionHwid != hwid {
		return nil, errors.New("wrong device")
	}
	if u.Status != "approved" {
		return nil, errNotApproved
	}
	if u.ExpiresAt != nil && u.ExpiresAt.Before(time.Now()) {
		return nil, errNotApproved
	}
	_, _ = a.db.Exec(ctx,
		`UPDATE auth_sessions SET last_used_at = now() WHERE token_hash = $1`,
		hashToken(token))
	return u, nil
}

// handleAuthSession is the app's launch check-in for a stored token: confirms
// the session is still good and returns the current role / access window, so a
// revoked or expired account is locked out at the next start.
func (a *App) handleAuthSession(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	u, err := a.sessionUser(ctx, bodyStr(b, "token"), bodyStr(b, "hwid"))
	if err != nil {
		respond(w, map[string]any{"ok": false, "message": "access.error.session"})
		return
	}
	ev := auditFromRequest(r, b)
	_, _ = a.db.Exec(ctx, `
		UPDATE access_users
		   SET last_seen_at = now(), last_ip = $1, client_device = $2,
		       client_os = $3, app_version = $4
		 WHERE id = $5`,
		normStr(ev.IP), normStr(ev.Device), normStr(ev.OS), normStr(ev.AppVersion), u.ID)
	resp := a.authOK(ctx, u, "")
	delete(resp, "token") // caller already holds the token
	respond(w, resp)
}

// handleAuthLogout revokes just this device's session.
func (a *App) handleAuthLogout(w http.ResponseWriter, r *http.Request) {
	b := jsonBody(r)
	token := bodyStr(b, "token")
	if token != "" {
		_, _ = a.db.Exec(r.Context(),
			`UPDATE auth_sessions SET revoked_at = now()
			  WHERE token_hash = $1 AND revoked_at IS NULL`, hashToken(token))
	}
	respond(w, map[string]any{"ok": true})
}

// handleAuthRequest is the app's "Request ID & password" button. It records an
// access request for the admin to act on. Re-requesting from the same machine
// updates the existing pending row rather than piling up duplicates, and a
// request can never modify an account that already has a login.
func (a *App) handleAuthRequest(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	b := jsonBody(r)
	name := truncate(bodyStr(b, "name"), 120)
	hwid := bodyStr(b, "hwid")
	phone := truncate(bodyStr(b, "phone"), 20)
	recovery := strings.ToLower(truncate(bodyStr(b, "recovery_email"), 190))
	designation := truncate(bodyStr(b, "designation"), 80)
	gender := truncate(bodyStr(b, "gender"), 20)
	station := truncate(bodyStr(b, "station"), 120)
	note := truncate(bodyStr(b, "note"), 500)

	if name == "" || hwid == "" || phone == "" {
		respond(w, map[string]any{"ok": false, "message": "access.error.request_fields"})
		return
	}

	ev := auditFromRequest(r, b)
	ev.Email = recovery

	// An identity for the request row. The admin replaces this with the real
	// login id when issuing credentials; it only has to be unique until then.
	placeholder := fmt.Sprintf("request+%s@pending.local", shortHash(hwid+phone))

	var existingID int64
	var hasLogin bool
	err := a.db.QueryRow(ctx, `
		SELECT id, (password_hash IS NOT NULL AND password_hash <> '')
		  FROM access_users WHERE hwid = $1 OR email = $2 LIMIT 1`,
		hwid, placeholder).Scan(&existingID, &hasLogin)

	switch {
	case errors.Is(err, pgx.ErrNoRows):
		if _, err := a.db.Exec(ctx, `
			INSERT INTO access_users
				(email, name, hwid, status, designation, gender, phone,
				 recovery_email, station_text, request_note, requested_at,
				 last_ip, client_device, client_os, app_version)
			VALUES ($1,$2,$3,'pending',$4,$5,$6,$7,$8,$9, now(), $10,$11,$12,$13)`,
			placeholder, name, hwid, normStr(designation), normStr(gender),
			normStr(phone), normStr(recovery), normStr(station), normStr(note),
			normStr(ev.IP), normStr(ev.Device), normStr(ev.OS), normStr(ev.AppVersion)); err != nil {
			respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
			return
		}
		ev.Event = "access.requested"
		ev.Detail = name + " / " + designation
		a.audit(ctx, ev)

	case err != nil:
		respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
		return

	case hasLogin:
		// This machine already has credentials — tell them to sign in rather
		// than silently overwriting a working account's details.
		respond(w, map[string]any{"ok": false, "message": "access.error.already_issued"})
		return

	default:
		if _, err := a.db.Exec(ctx, `
			UPDATE access_users
			   SET name = $1, designation = $2, gender = $3, phone = $4,
			       recovery_email = $5, station_text = $6, request_note = $7,
			       requested_at = now(), last_ip = $8, client_device = $9,
			       client_os = $10, app_version = $11
			 WHERE id = $12`,
			name, normStr(designation), normStr(gender), normStr(phone),
			normStr(recovery), normStr(station), normStr(note),
			normStr(ev.IP), normStr(ev.Device), normStr(ev.OS),
			normStr(ev.AppVersion), existingID); err != nil {
			respondStatus(w, 500, map[string]any{"ok": false, "message": "access.error.server"})
			return
		}
		ev.Event = "access.re_requested"
		a.audit(ctx, ev)
	}

	respond(w, map[string]any{"ok": true, "status": "pending"})
}

func shortHash(s string) string {
	sum := sha256.Sum256([]byte(s))
	return hex.EncodeToString(sum[:])[:12]
}

func isoOrNil(t *time.Time) any {
	if t == nil {
		return nil
	}
	return t.UTC().Format(time.RFC3339)
}
