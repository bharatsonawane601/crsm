Logo files (PNG, transparent background, roughly square) go here:

  1. crms_logo.png      — the CRMS / police app logo
                          Shown on splash, login, welcome, access and PIN screens.

  2. company_logo.png   — the DB Square Technology company logo
                          Shown on the welcome page and the "waiting for approval"
                          vendor card.

Until each file exists a styled fallback is shown, so the app still builds.

Recommended size: 512x512 px (or larger), PNG with transparency.

After adding/replacing a file:
  flutter pub get        (only needed the first time the file is added)
  then hot-restart (R), or rebuild the EXE.
