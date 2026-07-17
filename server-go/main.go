// CRMS central server (Go) — drop-in replacement for the PHP API on Hostinger.
// Serves the SAME routes (/check.php, /upload.php, ...) with the same JSON
// contract, so the station app only needs its base URL changed. Backed by
// PostgreSQL; mirrors data from the Hostinger MySQL install until cutover.
package main

import (
	"context"
	"crypto/subtle"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"time"
)

func main() {
	cfg := loadConfig()

	ctx, cancel := context.WithTimeout(context.Background(), 60*time.Second)
	pool, err := openDB(ctx, cfg.DatabaseURL)
	cancel()
	if err != nil {
		log.Fatalf("db: %v", err)
	}
	defer pool.Close()

	app := &App{cfg: cfg, db: pool}

	mux := http.NewServeMux()
	// Same file-style paths as the PHP server so the app's base-URL swap works.
	mux.HandleFunc("POST /check.php", app.gated(app.handleCheck))
	mux.HandleFunc("GET /version.php", app.gated(app.handleVersion))
	mux.HandleFunc("POST /upload.php", app.gated(app.handleUpload))
	mux.HandleFunc("POST /suppressed.php", app.gated(app.handleSuppressed))
	mux.HandleFunc("POST /deletions.php", app.gated(app.handleDeletions))
	mux.HandleFunc("POST /portal_scope.php", app.gated(app.handlePortalScope))
	mux.HandleFunc("POST /portal_search.php", app.gated(app.handlePortalSearch))
	mux.HandleFunc("POST /portal_rows.php", app.gated(app.handlePortalRows))
	mux.HandleFunc("POST /portal_compare.php", app.gated(app.handlePortalCompare))
	mux.HandleFunc("POST /io_sync.php", app.gated(app.handleIoSync))
	// Command messaging (CP/DCP/ACP/HQ → units or individuals; apps poll inbox).
	mux.HandleFunc("POST /messages.php", app.gated(app.handleMessages))
	mux.HandleFunc("POST /messages_send.php", app.gated(app.handleMessageSend))
	mux.HandleFunc("POST /messages_users.php", app.gated(app.handleMessageUsers))
	// The self-hosted admin panel (see admin.go).
	app.registerAdmin(mux)
	// Friendly index so opening /api/ in a browser shows the server is alive
	// instead of a bare 404. No data, no key required.
	mux.HandleFunc("GET /{$}", func(w http.ResponseWriter, r *http.Request) {
		respond(w, map[string]any{"ok": true, "service": "CRMS API", "status": "running"})
	})
	// Health probe for Docker / Nginx (no app key needed).
	mux.HandleFunc("GET /healthz", func(w http.ResponseWriter, r *http.Request) {
		if err := pool.Ping(r.Context()); err != nil {
			http.Error(w, "db down", http.StatusServiceUnavailable)
			return
		}
		w.Write([]byte("ok"))
	})

	// Background mirror from the Hostinger PHP server (until cutover).
	if cfg.MirrorBaseURL != "" {
		go app.runMirror(context.Background())
	}
	// Hourly cleanup of already-applied suppression tombstones (janitor.go).
	// Only once this server is standalone — while the mirror runs, Hostinger
	// still owns the tombstone list and would re-import anything pruned.
	if cfg.MirrorBaseURL == "" {
		go app.runJanitor(context.Background())
	}

	addr := ":" + cfg.Port
	log.Printf("crms-server listening on %s (mirror: %v)", addr, cfg.MirrorBaseURL != "")
	// Generous body timeouts: installer uploads (~20 MB) can crawl through a
	// relayed tailnet path, and big station syncs stream slowly on BSNL lines.
	srv := &http.Server{
		Addr:              addr,
		Handler:           mux,
		ReadHeaderTimeout: 10 * time.Second,
		ReadTimeout:       15 * time.Minute,
		WriteTimeout:      15 * time.Minute,
	}
	log.Fatal(srv.ListenAndServe())
}

// gated wraps a handler with the shared X-App-Key check (same gate as PHP).
func (a *App) gated(h http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		key := r.Header.Get("X-App-Key")
		if subtle.ConstantTimeCompare([]byte(key), []byte(a.cfg.AppKey)) != 1 {
			respondStatus(w, http.StatusUnauthorized, map[string]any{
				"ok": false, "message": "access.error.server",
			})
			return
		}
		h(w, r)
	}
}

// Config holds everything read from the environment (12-factor style).
type Config struct {
	Port              string
	AppKey            string
	DatabaseURL       string
	GoogleClientID    string
	VerifyGoogleToken bool
	OneDevicePerEmail bool
	// Password for the /admin panel. Empty disables the panel entirely.
	AdminPassword string
	// Mirror source: the Hostinger PHP API base (e.g. https://host/api) plus
	// how often to pull. Empty base URL disables mirroring (standalone mode).
	MirrorBaseURL  string
	MirrorInterval time.Duration
	// "full": Hostinger is master — overwrite and delete locally to match it.
	// "transition": both servers take writes during the app rollout — only add
	// missing rows / keep the newest FIR version, never delete locally.
	MirrorMode string
	// Where installer files live. Defaults to <MirrorBaseURL>/releases while the
	// binaries stay on Hostinger; point it elsewhere after full cutover.
	ReleaseURLPrefix string
}

func loadConfig() Config {
	env := func(k, def string) string {
		if v := os.Getenv(k); v != "" {
			return v
		}
		return def
	}
	interval, err := time.ParseDuration(env("MIRROR_INTERVAL", "5m"))
	if err != nil {
		interval = 5 * time.Minute
	}
	cfg := Config{
		Port:              env("PORT", "8080"),
		AppKey:            os.Getenv("CRMS_APP_KEY"),
		DatabaseURL:       os.Getenv("DATABASE_URL"),
		GoogleClientID:    os.Getenv("CRMS_GOOGLE_CLIENT_ID"),
		VerifyGoogleToken: env("VERIFY_GOOGLE_TOKEN", "0") == "1",
		OneDevicePerEmail: env("ONE_DEVICE_PER_EMAIL", "1") == "1",
		AdminPassword:     os.Getenv("ADMIN_PASSWORD"),
		MirrorBaseURL:     os.Getenv("MIRROR_BASE_URL"),
		MirrorInterval:    interval,
		MirrorMode:        env("MIRROR_MODE", "full"),
		ReleaseURLPrefix:  os.Getenv("RELEASE_URL_PREFIX"),
	}
	if cfg.ReleaseURLPrefix == "" && cfg.MirrorBaseURL != "" {
		cfg.ReleaseURLPrefix = cfg.MirrorBaseURL + "/releases"
	}
	if cfg.AppKey == "" || cfg.DatabaseURL == "" {
		log.Fatal("CRMS_APP_KEY and DATABASE_URL are required")
	}
	return cfg
}

// respond writes the standard JSON envelope used by every endpoint.
func respond(w http.ResponseWriter, body any) { respondStatus(w, http.StatusOK, body) }

func respondStatus(w http.ResponseWriter, status int, body any) {
	w.Header().Set("Content-Type", "application/json")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(body)
}
