package main

import (
	"io"
	"testing"
)

// The admin UI is one big html/template. Parse errors surface at package init
// (template.Must), but a field/key that a template references and the handler
// forgot to supply only blows up when that page is RENDERED. These smoke tests
// execute every template with representative data so such a mismatch fails the
// build instead of a live admin page.
func renderOK(t *testing.T, name string, p adminPage) {
	t.Helper()
	if err := adminTmpl.ExecuteTemplate(io.Discard, name, p); err != nil {
		t.Fatalf("render %q: %v", name, err)
	}
}

func TestAdminTemplatesRender(t *testing.T) {
	base := adminPage{Title: "T", Now: "now", Active: "x"}

	renderOK(t, "login", adminPage{Title: "Login", Error: "bad"})

	usersPage := base
	usersPage.Data = map[string]any{
		"Users": []struct {
			Email, Name, Status, Role, Scope string
			ScopeKey                         string
			Device, OS, Platform, AppVer, IP string
			LastSeen                         string
			LoginID                          string
			HasLogin                         bool
			PwKnown                          bool
			Expires                          string
			Expired                          bool
			Designation, Gender, Phone       string
			RecoveryEmail, StationText, Note string
			IsRequest                        bool
		}{
			{Email: "a@b.com", Status: "approved", Role: "station", LoginID: "cp1234",
				HasLogin: true, PwKnown: true, Expires: "01 Jan 2027", Phone: "999"},
			{Email: "x@pending.local", Status: "pending", Role: "station",
				IsRequest: true, Designation: "PSI", Gender: "male", Note: "new joiner"},
		},
		"Zones": []struct {
			ID   int64
			Name string
		}{{1, "Z"}},
		"Divisions": []struct {
			ID   int64
			Name string
		}{{2, "D"}},
		"Stations": []struct {
			ID   int64
			Name string
		}{{3, "S"}},
	}
	renderOK(t, "users", usersPage)

	adminsPage := base
	adminsPage.Data = map[string]any{
		"Me": "root",
		"Admins": []struct {
			Username, Name, LastLogin, LastIP string
			Active                            bool
		}{{Username: "root", Active: true, LastLogin: "now"}},
	}
	renderOK(t, "admins", adminsPage)

	auditPage := base
	auditPage.Data = map[string]any{
		"Alerts": int64(2),
		"Rows": []struct {
			At, LoginID, Email, Actor, Event, Detail, IP, Device, OS, AppVer string
			Bad                                                              bool
		}{{At: "now", Event: "login.ok", LoginID: "cp1234"},
			{At: "now", Event: "device.mismatch", Bad: true}},
	}
	renderOK(t, "audit", auditPage)
}
