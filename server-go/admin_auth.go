package main

import (
	"context"
	"errors"
	"fmt"
	"net/http"
	"regexp"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
)

// Admin-side credential management: issue and reset the ID + password officers
// use to sign in, set their access window, and manage the panel's own admin
// logins. All of these are POST + admin cookie (registered in admin_actions.go).

var loginIDRe = regexp.MustCompile(`^[a-z0-9][a-z0-9._-]{2,39}$`)

// accessPeriod maps a dropdown value to an expiry time. "perm" = no expiry.
func accessPeriod(v string) (*time.Time, bool) {
	now := time.Now()
	switch v {
	case "perm", "":
		return nil, true
	case "1m":
		t := now.AddDate(0, 1, 0)
		return &t, true
	case "3m":
		t := now.AddDate(0, 3, 0)
		return &t, true
	case "6m":
		t := now.AddDate(0, 6, 0)
		return &t, true
	case "1y":
		t := now.AddDate(1, 0, 0)
		return &t, true
	}
	return nil, false
}

// actUserIssueLogin creates OR updates a user's login. The admin controls both
// the username (login ID) and the password:
//
//   - Type a password  -> that becomes the working password immediately. The
//     admin knows it (they set it), so it is what the officer signs in with;
//     no forced change. pw_admin_set is marked so the panel can show that the
//     admin still knows this password.
//   - Leave it blank    -> a one-time password is generated that the officer
//     must change on first sign-in (only they will know the new one).
//
// Either way the credentials are shown once in the redirect banner; the stored
// form is always an Argon2id hash, never readable plaintext.
func (a *App) actUserIssueLogin(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	_ = r.ParseForm()
	email := strings.ToLower(strings.TrimSpace(r.PostFormValue("email")))
	loginID := strings.ToLower(strings.TrimSpace(r.PostFormValue("login_id")))
	chosenPw := r.PostFormValue("password")
	period := r.PostFormValue("period")
	if email == "" {
		back(w, r, "/admin/users", "Missing user")
		return
	}

	// Look up the target row and its current identity.
	var (
		id           int64
		currentEmail string
		currentLogin *string
		hasLogin     bool
	)
	err := a.db.QueryRow(ctx, `
		SELECT id, email, login_id, (password_hash IS NOT NULL AND password_hash <> '')
		  FROM access_users WHERE lower(email) = lower($1)`, email,
	).Scan(&id, &currentEmail, &currentLogin, &hasLogin)
	if errors.Is(err, pgx.ErrNoRows) {
		back(w, r, "/admin/users", "User not found")
		return
	}
	if err != nil {
		back(w, r, "/admin/users", "Error: "+err.Error())
		return
	}

	// Resolve the login ID: keep the current one if the admin left it blank,
	// auto-generate if there's none yet, otherwise validate their choice.
	switch {
	case loginID != "":
		if !loginIDRe.MatchString(loginID) {
			back(w, r, "/admin/users",
				"Login ID must be 3–40 chars: letters, digits, dot, dash, underscore.")
			return
		}
	case currentLogin != nil && *currentLogin != "":
		loginID = *currentLogin
	default:
		loginID, err = a.uniqueLoginID(ctx)
		if err != nil {
			back(w, r, "/admin/users", "Could not allocate a login ID")
			return
		}
	}

	// Fresh app requests carry a placeholder email; give them a stable identity
	// derived from the login ID. Legacy Google users keep their real address so
	// the FIRs they already uploaded stay attached to them.
	newEmail := currentEmail
	if strings.HasSuffix(strings.ToLower(currentEmail), "@pending.local") {
		newEmail = loginID + "@dbsquare.local"
	}

	expires, ok := accessPeriod(period)
	if !ok {
		back(w, r, "/admin/users", "Invalid access period")
		return
	}

	// Admin-typed password vs auto one-time password.
	adminSet := strings.TrimSpace(chosenPw) != ""
	var (
		showPw     string
		mustChange bool
		tempExpiry *time.Time
	)
	if adminSet {
		if len([]rune(chosenPw)) < 6 {
			back(w, r, "/admin/users", "Password must be at least 6 characters.")
			return
		}
		showPw = chosenPw
	} else {
		showPw, err = generatePassword()
		if err != nil {
			back(w, r, "/admin/users", "Could not generate a password")
			return
		}
		mustChange = true
		t := time.Now().Add(48 * time.Hour)
		tempExpiry = &t
	}
	hash, err := hashPassword(showPw)
	if err != nil {
		back(w, r, "/admin/users", "Could not secure the password")
		return
	}

	if _, err := a.db.Exec(ctx, `
		UPDATE access_users
		   SET login_id = $1, email = $2, password_hash = $3, must_change_pw = $4,
		       temp_expires_at = $5, expires_at = $6, status = 'approved',
		       pw_admin_set = $7, pw_changed_at = now(),
		       failed_attempts = 0, locked_until = NULL, decided_at = now()
		 WHERE id = $8`,
		loginID, newEmail, hash, mustChange, tempExpiry, expires, adminSet, id); err != nil {
		if strings.Contains(err.Error(), "idx_access_login_id") {
			back(w, r, "/admin/users", "That login ID is already taken. Pick another.")
			return
		}
		back(w, r, "/admin/users", "Error: "+err.Error())
		return
	}
	// Any admin credential change invalidates existing sessions on this account.
	_, _ = a.db.Exec(ctx,
		`UPDATE auth_sessions SET revoked_at = now() WHERE user_id = $1 AND revoked_at IS NULL`, id)

	a.audit(ctx, auditEvent{
		Actor: a.adminActor(r), LoginID: loginID, Email: newEmail,
		Event: "admin.login_issued", IP: clientIP(r),
		Detail: fmt.Sprintf("access %s, %s", periodLabel(period),
			map[bool]string{true: "admin-set password", false: "one-time password"}[adminSet]),
	})

	if adminSet {
		back(w, r, "/admin/users", fmt.Sprintf(
			"Login saved — ID: %s   Password: %s   (you set this, so you know it; the officer signs in with it directly)",
			loginID, showPw))
	} else {
		back(w, r, "/admin/users", fmt.Sprintf(
			"Login saved — give these to the officer now (shown once):  ID: %s   Temporary password: %s   (they set their own on first sign-in; expires in 48 h)",
			loginID, showPw))
	}
}

// actUserResetPassword issues a fresh one-time password for an existing login.
func (a *App) actUserResetPassword(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	_ = r.ParseForm()
	email := strings.ToLower(strings.TrimSpace(r.PostFormValue("email")))
	if email == "" {
		back(w, r, "/admin/users", "Missing user")
		return
	}
	var loginID *string
	err := a.db.QueryRow(ctx,
		`SELECT login_id FROM access_users WHERE lower(email) = lower($1)`, email).Scan(&loginID)
	if errors.Is(err, pgx.ErrNoRows) || loginID == nil || *loginID == "" {
		back(w, r, "/admin/users", "That user has no login yet. Use ‘Give ID & password’.")
		return
	}
	if err != nil {
		back(w, r, "/admin/users", "Error: "+err.Error())
		return
	}
	tempPw, err := generatePassword()
	if err != nil {
		back(w, r, "/admin/users", "Could not generate a password")
		return
	}
	hash, err := hashPassword(tempPw)
	if err != nil {
		back(w, r, "/admin/users", "Could not secure the password")
		return
	}
	tempExpiry := time.Now().Add(48 * time.Hour)
	if _, err := a.db.Exec(ctx, `
		UPDATE access_users
		   SET password_hash = $1, must_change_pw = true, temp_expires_at = $2,
		       pw_admin_set = false, pw_changed_at = now(),
		       failed_attempts = 0, locked_until = NULL
		 WHERE lower(email) = lower($3)`, hash, tempExpiry, email); err != nil {
		back(w, r, "/admin/users", "Error: "+err.Error())
		return
	}
	// New password ⇒ any session on the old one is dead.
	_, _ = a.db.Exec(ctx, `
		UPDATE auth_sessions SET revoked_at = now()
		 WHERE revoked_at IS NULL AND user_id =
		       (SELECT id FROM access_users WHERE lower(email) = lower($1))`, email)

	a.audit(ctx, auditEvent{
		Actor: a.adminActor(r), LoginID: *loginID, Email: email,
		Event: "admin.password_reset", IP: clientIP(r),
	})
	back(w, r, "/admin/users", fmt.Sprintf(
		"Password reset — give this to the officer now (shown once):  ID: %s   Temporary password: %s   (expires in 48 h)",
		*loginID, tempPw))
}

// actUserSetExpiry changes just the access window (time limit) of a user.
func (a *App) actUserSetExpiry(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	_ = r.ParseForm()
	email := strings.ToLower(strings.TrimSpace(r.PostFormValue("email")))
	period := r.PostFormValue("period")
	if email == "" {
		back(w, r, "/admin/users", "Missing user")
		return
	}
	expires, ok := accessPeriod(period)
	if !ok {
		back(w, r, "/admin/users", "Invalid access period")
		return
	}
	tag, err := a.db.Exec(ctx,
		`UPDATE access_users SET expires_at = $1 WHERE lower(email) = lower($2)`, expires, email)
	if err != nil {
		back(w, r, "/admin/users", "Error: "+err.Error())
		return
	}
	if tag.RowsAffected() == 0 {
		back(w, r, "/admin/users", "User not found")
		return
	}
	a.audit(ctx, auditEvent{
		Actor: a.adminActor(r), Email: email, Event: "admin.access_period",
		IP: clientIP(r), Detail: periodLabel(period),
	})
	back(w, r, "/admin/users", "Access period updated: "+periodLabel(period))
}

// actUserDelete removes a user's access record entirely (login, sessions,
// request details, device binding). Their uploaded FIRs are NOT touched — those
// are keyed by email in central_crimes and stay in the system. If the same
// person requests access again from the app, a fresh pending row is created and
// they reappear in the list, exactly as the admin asked for.
func (a *App) actUserDelete(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	_ = r.ParseForm()
	email := strings.ToLower(strings.TrimSpace(r.PostFormValue("email")))
	if email == "" {
		back(w, r, "/admin/users", "Missing user")
		return
	}
	// auth_sessions rows cascade on the access_users delete (FK ON DELETE CASCADE).
	tag, err := a.db.Exec(ctx,
		`DELETE FROM access_users WHERE lower(email) = lower($1)`, email)
	if err != nil {
		back(w, r, "/admin/users", "Error: "+err.Error())
		return
	}
	if tag.RowsAffected() == 0 {
		back(w, r, "/admin/users", "User not found")
		return
	}
	a.audit(ctx, auditEvent{
		Actor: a.adminActor(r), Email: email, Event: "admin.user_deleted",
		IP: clientIP(r),
	})
	back(w, r, "/admin/users",
		"User deleted. If they request access again from the app, they'll reappear as a new request.")
}

// uniqueLoginID returns an unused auto-generated login ID like "cp4821".
func (a *App) uniqueLoginID(ctx context.Context) (string, error) {
	for i := 0; i < 20; i++ {
		pw, err := generatePassword()
		if err != nil {
			return "", err
		}
		id := "cp" + strings.ToLower(pw[:4])
		var exists bool
		if err := a.db.QueryRow(ctx,
			`SELECT EXISTS(SELECT 1 FROM access_users WHERE lower(login_id) = $1)`, id,
		).Scan(&exists); err != nil {
			return "", err
		}
		if !exists {
			return id, nil
		}
	}
	return "", errors.New("could not allocate a unique login id")
}

func periodLabel(v string) string {
	switch v {
	case "1m":
		return "1 month"
	case "3m":
		return "3 months"
	case "6m":
		return "6 months"
	case "1y":
		return "1 year"
	default:
		return "permanent (no expiry)"
	}
}

// --- Panel admin accounts --------------------------------------------------

func (a *App) adminAdmins(w http.ResponseWriter, r *http.Request) {
	type adminRow struct {
		Username, Name, LastLogin, LastIP string
		Active                            bool
	}
	rows, _ := a.db.Query(r.Context(), `
		SELECT username, COALESCE(name,''), is_active, last_login_at, COALESCE(last_ip,'')
		  FROM admin_users ORDER BY username`)
	list := []adminRow{}
	if rows != nil {
		for rows.Next() {
			var x adminRow
			var last *time.Time
			if rows.Scan(&x.Username, &x.Name, &x.Active, &last, &x.LastIP) == nil {
				if last != nil {
					x.LastLogin = istStamp(*last)
				}
				list = append(list, x)
			}
		}
		rows.Close()
	}
	renderAdmin(w, "admins", a.page(r, "Admins", "admins", map[string]any{
		"Admins": list,
		"Me":     a.adminActor(r),
	}))
}

func (a *App) actAdminCreate(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	_ = r.ParseForm()
	username := strings.ToLower(strings.TrimSpace(r.PostFormValue("username")))
	name := strings.TrimSpace(r.PostFormValue("name"))
	pw := r.PostFormValue("password")
	if !loginIDRe.MatchString(username) {
		back(w, r, "/admin/admins",
			"Username must be 3–40 chars: letters, digits, dot, dash, underscore.")
		return
	}
	if strings.EqualFold(username, adminRootUser) {
		back(w, r, "/admin/admins", "‘root’ is reserved for the bootstrap password.")
		return
	}
	if len([]rune(pw)) < 8 {
		back(w, r, "/admin/admins", "Password must be at least 8 characters.")
		return
	}
	hash, err := hashPassword(pw)
	if err != nil {
		back(w, r, "/admin/admins", "Could not secure the password")
		return
	}
	if _, err := a.db.Exec(ctx, `
		INSERT INTO admin_users (username, name, password_hash) VALUES ($1,$2,$3)`,
		username, nilIfEmpty(name), hash); err != nil {
		if strings.Contains(err.Error(), "admin_users_username_key") {
			back(w, r, "/admin/admins", "That username already exists.")
			return
		}
		back(w, r, "/admin/admins", "Error: "+err.Error())
		return
	}
	a.audit(ctx, auditEvent{
		Actor: a.adminActor(r), Event: "admin.account_created",
		Detail: "username=" + username, IP: clientIP(r),
	})
	back(w, r, "/admin/admins", "Admin ‘"+username+"’ created.")
}

func (a *App) actAdminReset(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	_ = r.ParseForm()
	username := strings.ToLower(strings.TrimSpace(r.PostFormValue("username")))
	pw := r.PostFormValue("password")
	if username == "" || len([]rune(pw)) < 8 {
		back(w, r, "/admin/admins", "Password must be at least 8 characters.")
		return
	}
	hash, err := hashPassword(pw)
	if err != nil {
		back(w, r, "/admin/admins", "Could not secure the password")
		return
	}
	tag, err := a.db.Exec(ctx,
		`UPDATE admin_users SET password_hash = $1 WHERE lower(username) = lower($2)`, hash, username)
	if err != nil || tag.RowsAffected() == 0 {
		back(w, r, "/admin/admins", "Admin not found.")
		return
	}
	a.audit(ctx, auditEvent{
		Actor: a.adminActor(r), Event: "admin.account_password_reset",
		Detail: "username=" + username, IP: clientIP(r),
	})
	back(w, r, "/admin/admins", "Password updated for ‘"+username+"’.")
}

func (a *App) actAdminToggle(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	_ = r.ParseForm()
	username := strings.ToLower(strings.TrimSpace(r.PostFormValue("username")))
	active := r.PostFormValue("active") == "1"
	tag, err := a.db.Exec(ctx,
		`UPDATE admin_users SET is_active = $1 WHERE lower(username) = lower($2)`, active, username)
	if err != nil || tag.RowsAffected() == 0 {
		back(w, r, "/admin/admins", "Admin not found.")
		return
	}
	// Deactivating kills any live panel session by making the account fail the
	// active check on the next request.
	state := "enabled"
	if !active {
		state = "disabled"
	}
	a.audit(ctx, auditEvent{
		Actor: a.adminActor(r), Event: "admin.account_" + state,
		Detail: "username=" + username, IP: clientIP(r),
	})
	back(w, r, "/admin/admins", "Admin ‘"+username+"’ "+state+".")
}

func (a *App) actAdminDelete(w http.ResponseWriter, r *http.Request) {
	ctx := r.Context()
	_ = r.ParseForm()
	username := strings.ToLower(strings.TrimSpace(r.PostFormValue("username")))
	if _, err := a.db.Exec(ctx,
		`DELETE FROM admin_users WHERE lower(username) = lower($1)`, username); err != nil {
		back(w, r, "/admin/admins", "Error: "+err.Error())
		return
	}
	a.audit(ctx, auditEvent{
		Actor: a.adminActor(r), Event: "admin.account_deleted",
		Detail: "username=" + username, IP: clientIP(r),
	})
	back(w, r, "/admin/admins", "Admin ‘"+username+"’ deleted.")
}

// --- Login & security audit ------------------------------------------------

func (a *App) adminAudit(w http.ResponseWriter, r *http.Request) {
	type auditRow struct {
		At, LoginID, Email, Actor, Event, Detail, IP, Device, OS, AppVer string
		Bad                                                              bool
	}
	rows, _ := a.db.Query(r.Context(), `
		SELECT at, COALESCE(login_id,''), COALESCE(email,''), COALESCE(actor,''),
		       event, COALESCE(detail,''), COALESCE(ip,''), COALESCE(device,''),
		       COALESCE(os,''), COALESCE(app_version,'')
		  FROM login_audit ORDER BY at DESC LIMIT 500`)
	list := []auditRow{}
	if rows != nil {
		for rows.Next() {
			var x auditRow
			var at time.Time
			if rows.Scan(&at, &x.LoginID, &x.Email, &x.Actor, &x.Event, &x.Detail,
				&x.IP, &x.Device, &x.OS, &x.AppVer) == nil {
				x.At = istStamp(at)
				x.Bad = strings.Contains(x.Event, "fail") ||
					strings.Contains(x.Event, "bad") ||
					strings.Contains(x.Event, "lock") ||
					strings.Contains(x.Event, "mismatch") ||
					strings.Contains(x.Event, "unknown") ||
					strings.Contains(x.Event, "expired") ||
					strings.Contains(x.Event, "denied")
				list = append(list, x)
			}
		}
		rows.Close()
	}
	// Device-mismatch alerts in the last 7 days, surfaced at the top.
	var alerts int64
	_ = a.db.QueryRow(r.Context(),
		`SELECT COUNT(*) FROM login_audit WHERE event = 'device.mismatch' AND at > now() - interval '7 days'`,
	).Scan(&alerts)
	renderAdmin(w, "audit", a.page(r, "Security log", "audit", map[string]any{
		"Rows":   list,
		"Alerts": alerts,
	}))
}

// actMirrorImport pulls once from the Hostinger site on the admin's command.
// The automatic background pull is OFF (it kept re-importing rows deleted
// here), so this is the only way data comes across — deliberately manual.
func (a *App) actMirrorImport(w http.ResponseWriter, r *http.Request) {
	if a.cfg.MirrorBaseURL == "" {
		back(w, r, "/admin/org", "No Hostinger source configured (MIRROR_BASE_URL is empty).")
		return
	}
	// Give the pull its own timeout: the admin's browser request may be gone
	// long before a big import finishes, and cancelling mid-way would leave a
	// half-imported set.
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Minute)
	defer cancel()

	start := time.Now()
	if err := a.mirrorOnce(ctx); err != nil {
		a.audit(r.Context(), auditEvent{
			Actor: a.adminActor(r), Event: "admin.mirror_import_failed",
			Detail: err.Error(), IP: clientIP(r),
		})
		back(w, r, "/admin/org", "Import failed: "+err.Error())
		return
	}
	a.audit(r.Context(), auditEvent{
		Actor: a.adminActor(r), Event: "admin.mirror_import",
		Detail: "took " + time.Since(start).Round(time.Millisecond).String(),
		IP:     clientIP(r),
	})
	back(w, r, "/admin/org", fmt.Sprintf(
		"Imported from Hostinger in %s. Note: anything you deleted here that still exists there comes back.",
		time.Since(start).Round(time.Millisecond)))
}

func nilIfEmpty(s string) any {
	if strings.TrimSpace(s) == "" {
		return nil
	}
	return s
}
