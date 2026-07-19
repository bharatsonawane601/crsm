package main

import (
	"strings"
	"testing"
)

func TestPasswordHashRoundTrip(t *testing.T) {
	hash, err := hashPassword("correct horse battery")
	if err != nil {
		t.Fatalf("hashPassword: %v", err)
	}
	if !strings.HasPrefix(hash, "$argon2id$") {
		t.Fatalf("not an argon2id hash: %s", hash)
	}
	if strings.Contains(hash, "correct horse battery") {
		t.Fatal("hash leaks the plaintext password")
	}
	if !verifyPassword("correct horse battery", hash) {
		t.Fatal("correct password rejected")
	}
	if verifyPassword("wrong password", hash) {
		t.Fatal("wrong password accepted")
	}
}

func TestPasswordHashIsSalted(t *testing.T) {
	a, _ := hashPassword("same")
	b, _ := hashPassword("same")
	if a == b {
		t.Fatal("identical passwords produced identical hashes (no salt)")
	}
	if !verifyPassword("same", a) || !verifyPassword("same", b) {
		t.Fatal("salted hashes must both verify")
	}
}

// A malformed, empty or truncated hash must never verify — otherwise a user row
// with a corrupt password_hash would accept any password at all.
func TestVerifyRejectsMalformedHashes(t *testing.T) {
	good, _ := hashPassword("pw")
	bad := []string{
		"",
		"not a hash",
		"$argon2id$",
		"$argon2i$v=19$m=65536,t=3,p=4$AAAA$BBBB",  // wrong algorithm
		"$argon2id$v=99$m=65536,t=3,p=4$AAAA$BBBB", // wrong version
		good[:len(good)-5],                         // truncated key
		good[:strings.LastIndex(good, "$")],        // key section missing entirely
		strings.Replace(good, "$", "|", 1),         // separator mangled
	}
	for _, h := range bad {
		if verifyPassword("pw", h) {
			t.Fatalf("malformed hash accepted a password: %q", h)
		}
		if verifyPassword("", h) {
			t.Fatalf("malformed hash accepted an empty password: %q", h)
		}
	}
}

func TestTokensAreUniqueAndStoredHashed(t *testing.T) {
	seen := map[string]bool{}
	for i := 0; i < 200; i++ {
		token, hash, err := newToken()
		if err != nil {
			t.Fatalf("newToken: %v", err)
		}
		if token == "" || hash == "" {
			t.Fatal("empty token or hash")
		}
		if token == hash {
			t.Fatal("token stored verbatim instead of hashed")
		}
		if hashToken(token) != hash {
			t.Fatal("hashToken disagrees with newToken")
		}
		if seen[token] {
			t.Fatal("duplicate token generated")
		}
		seen[token] = true
		// 256 bits of entropy, base64url encoded.
		if len(token) < 40 {
			t.Fatalf("token too short to be unguessable: %d chars", len(token))
		}
	}
}

func TestGeneratedPasswordsAreReadableAndUnique(t *testing.T) {
	const ambiguous = "0O1lI"
	seen := map[string]bool{}
	for i := 0; i < 200; i++ {
		pw, err := generatePassword()
		if err != nil {
			t.Fatalf("generatePassword: %v", err)
		}
		if len(pw) != 12 {
			t.Fatalf("expected 12 chars, got %d", len(pw))
		}
		if strings.ContainsAny(pw, ambiguous) {
			t.Fatalf("password %q contains an ambiguous character", pw)
		}
		if seen[pw] {
			t.Fatal("duplicate one-time password generated")
		}
		seen[pw] = true
	}
}

// The build-number formula must stay identical to the app's, or update checks
// silently stall (this bit us once already).
func TestVersionToBuildMatchesAppFormula(t *testing.T) {
	cases := map[string]int{
		"1.14.0": 1014000,
		"1.14.1": 1014001,
		"1.15.0": 1015000,
		"2.0.0":  2000000,
	}
	for version, want := range cases {
		if got := versionToBuild(version); got != want {
			t.Fatalf("versionToBuild(%q) = %d, want %d", version, got, want)
		}
	}
}
