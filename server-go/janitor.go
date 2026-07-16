package main

import (
	"context"
	"log"
	"time"
)

// runJanitor keeps the sync bookkeeping small forever. Hourly (and once at
// startup) it prunes suppression tombstones that have already done their job:
// a tombstone exists so the owner's device deletes its local copy of an
// admin-deleted FIR, and every app launch (check.php, which stamps
// last_seen_at) is followed by a FULL tombstone pull — so any tombstone older
// than the owner's last check-in has been applied and can go. Without this the
// tombstone list only ever grows and every station re-downloads it on sync.
func (a *App) runJanitor(ctx context.Context) {
	tick := time.NewTicker(time.Hour)
	defer tick.Stop()
	for {
		tag, err := a.db.Exec(ctx, `
			DELETE FROM central_suppressed s
			 USING access_users u
			 WHERE u.email = s.owner_email
			   AND u.last_seen_at IS NOT NULL
			   AND s.suppressed_at < u.last_seen_at - interval '1 hour'`)
		if err != nil {
			log.Printf("janitor: %v", err)
		} else if n := tag.RowsAffected(); n > 0 {
			log.Printf("janitor: pruned %d applied tombstones", n)
		}
		select {
		case <-ctx.Done():
			return
		case <-tick.C:
		}
	}
}
