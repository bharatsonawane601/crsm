<?php
// CRMS access-approval server config — TEMPLATE.
// Copy this file to `config.php` on the server and fill in the real values.
// `config.php` is git-ignored so your live credentials are never committed.
//
// Upload the whole `server/` folder to your Hostinger hosting (e.g. into a
// subfolder `api/` of your domain) and fill in the values below.

// --- MySQL (create a database + user in Hostinger → Databases → MySQL) ------
const DB_HOST = 'localhost';            // Hostinger usually 'localhost'
const DB_NAME = 'PASTE_DB_NAME';
const DB_USER = 'PASTE_DB_USER';
const DB_PASS = 'PASTE_DB_PASSWORD';

// --- Shared app key -------------------------------------------------------
// Must EXACTLY match the app's CRMS_APP_KEY (--dart-define) / AccessConfig.appKey.
// Long & random.
const APP_KEY = 'PASTE_A_LONG_RANDOM_APP_KEY';

// --- Admin panel ----------------------------------------------------------
// Password to open admin.php. Use a strong value.
const ADMIN_PASSWORD = 'PASTE_A_STRONG_ADMIN_PASSWORD';

// --- Google token verification -------------------------------------------
// Your Google OAuth *client ID* (Desktop). Once the app sends a real Google
// id_token, set VERIFY_GOOGLE_TOKEN = true to cryptographically verify it.
// Leave false while the app still uses the demo stub (no token yet).
const GOOGLE_CLIENT_ID = 'PASTE_GOOGLE_CLIENT_ID.apps.googleusercontent.com';
const VERIFY_GOOGLE_TOKEN = false;

// One approved email = one device (HWID-locked). Set false to allow any device.
const ONE_DEVICE_PER_EMAIL = true;
