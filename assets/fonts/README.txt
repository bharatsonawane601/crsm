Fonts used by CRMS
==================

Bundled (already working):
  - Inter-VF.ttf               English UI text
  - NotoSansDevanagari-VF.ttf  Marathi (Devanagari) — renders all Unicode
                               Marathi, including text typed via the Windows
                               InScript keyboard or ISM in Unicode mode.
  - JetBrainsMono-VF.ttf       FIR numbers / codes

Marathi typing — important
--------------------------
Type Marathi in UNICODE mode, not the old "typewriter" (legacy font) mode.

  * Easiest: turn on the Windows "Marathi - InScript" keyboard
      Settings > Time & Language > Language > Marathi > add keyboard "InScript".
    Switch with Left-Alt+Shift (or Win+Space) and type — it renders correctly.

  * If you use ISM: set the script/keyboard to a UNICODE layout
    (e.g. "Remington Unicode" / "InScript Unicode"), NOT the legacy
    "Marathi Typewriter (DV-…/Shree…)" font layout. The legacy layout sends
    ASCII bytes that only an old legacy font can show, which is why it looks
    garbled in any Unicode app.

Optional: use the classic "Mangal" face
----------------------------------------
Mangal is a Microsoft font (not bundled here for licensing). To use it:
  1. Copy  C:\Windows\Fonts\mangal.ttf  into this folder as  Mangal.ttf
  2. In pubspec.yaml, under flutter: > fonts:, add:

        - family: Mangal
          fonts:
            - asset: assets/fonts/Mangal.ttf

  3. flutter pub get  and rebuild.
The app already prefers the "Mangal" family for Marathi when it is registered,
falling back to Noto Sans Devanagari otherwise.
