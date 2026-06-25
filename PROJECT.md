# Police Crime Records Management System (CRMS)

## Project Overview

A desktop and mobile application for Maharashtra Police to digitally record FIRs / crime entries and auto-generate official reports (ब पत्रक, FIR copy, chargesheet, etc.) from the stored data. Fully **bilingual: Marathi (Devanagari) and English** — user can switch language anytime from settings or the top bar.

## Goals

1. Replace manual paper-based crime entry with structured digital forms
2. Store all FIR-related data (complainant, accused, property, investigation) in a relational database
3. Allow users to generate any official report by selecting a template — data auto-fills from the database
4. Allow admin users to create custom report templates via a drag-and-drop builder
5. Allow admin users to add new custom fields without code changes (extensible schema)
6. Work offline (each station has local data); sync to central server in later phases
7. **Bilingual interface (Marathi / English)** with language toggle — every label, button, message, and report has both versions
8. **Built-in Data Analyzer** — dashboards, charts, and crime statistics generated automatically from stored FIR data

## Target Platforms

- **Phase 1:** Windows desktop (.exe installer)
- **Phase 2:** macOS desktop
- **Phase 3:** Android + iOS mobile apps (same codebase via Capacitor)

## Tech Stack (Flutter)

- **Framework:** **Flutter (Dart)** — single codebase for Windows/macOS desktop + Android/iOS mobile
- **Database:** SQLite via **`drift`** (type-safe ORM), encrypted at rest with **SQLCipher** (`sqlcipher_flutter_libs`)
- **ORM:** `drift` (tables + DAOs, reactive queries)
- **UI:** Flutter **Material 3**; `shadcn_ui` / `forui` optional for shadcn-style components
- **Forms & validation:** `flutter_form_builder` + `form_builder_validators` (Zod-equivalent schema validation)
- **Marathi font:** Noto Sans Devanagari bundled in `assets/fonts` (Flutter renders Devanagari complex script natively)
- **Internationalization (i18n):** **`easy_localization`** (JSON `mr.json` / `en.json`, runtime language toggle — closest to i18next)
- **Charts & analytics:** **Syncfusion Flutter Charts** (`syncfusion_flutter_charts`) and/or `fl_chart`
- **Document generation:** **Syncfusion DocIO** (`syncfusion_flutter_docio`, Word/.docx) + **`pdf`** package (PDF). Excel export via **Syncfusion XlsIO** (`syncfusion_flutter_xlsio`). *Syncfusion = free community license.*
- **Direct printing:** **`printing`** package (print preview + direct print on desktop & mobile)
- **Drag-drop template builder:** native Flutter `Draggable` / `DragTarget` + `reorderables`
- **Packaging:** `flutter build windows` + **`msix`** (Windows installer); later `flutter build apk` / `ipa`
- **Auth + Google Drive sync:** `google_sign_in` (mobile) / `googleapis_auth` loopback OAuth (desktop) + `googleapis` (Drive v3)
- **Field encryption:** `cryptography` / `encrypt` (AES-GCM) for Aadhaar & PAN — encrypted before any Drive upload

## Core Modules

### 1. Authentication
- Login screen with username/password
- User roles: `admin`, `station_head`, `officer`, `data_entry`
- Each role has different permissions (admin can create templates, officers can only fill forms, etc.)

### 2. Crime Entry Form
- Multi-tab form (not one long scroll):
  - Tab 1: गुन्हा माहिती (Crime Info) — FIR no, year, section, station, date, place
  - Tab 2: फिर्यादी (Complainant) — name, gender, age, address, mobile, ID proofs
  - Tab 3: आरोपी (Accused) — supports multiple accused (add/remove rows)
  - Tab 4: मालमत्ता (Property) — stolen & recovered, supports multiple items
  - Tab 5: तपास (Investigation) — officer details, arrest info
  - Tab 6: निकाल (Verdict) — chargesheet, RCC no., final order, punishment
  - Tab 7: फोटो/संलग्न (Attachments) — accused photos, evidence files
- Conditional sections: weapon/suicide/kidnapping fields appear only when relevant crime type is selected
- Auto-render any custom fields added by admin

### 3. List & Search
- View all FIRs in a sortable, filterable table
- Filter by date range, police station, section, status, officer
- Search by FIR no, complainant name, accused name
- Click any row → opens full details

### 4. Report Generation
- "Generate Report" button on every crime detail page
- Dropdown shows all available templates
- User picks template → app fetches data → renders .docx or .pdf
- Marathi font embedded so output prints correctly
- Pre-loaded templates: B-Patrak, FIR copy, A-Patrak, C-Patrak, Chargesheet summary, Daily Diary, Seizure memo, Arrest memo, Monthly statistics

### 5. Template Builder (admin only)
- Drag-and-drop UI to design new report templates
- For each row: type the label (Marathi), pick the data field from a dropdown of all available DB fields
- Supports tables, sections, headers, footers, page numbers
- Supports placeholders: simple, combined, loops (for multiple accused/property), conditionals
- Save template with a name → it instantly appears in the report dropdown for all users
- Edit/duplicate/delete existing templates

### 6. Custom Fields Manager (admin only)
- Add new fields to any section of the crime form
- Field types: text, number, date, dropdown, checkbox, file upload
- Mark as required/optional
- Once added, the field auto-appears in the entry form and becomes available in the template builder

### 7. Backup & Restore
- Daily automatic backup of SQLite DB to a chosen folder
- Manual export to encrypted .zip
- Restore from backup file

### 8. Data Analyzer (Dashboard & Statistics)
A dedicated analytics module that turns raw FIR data into visual insights. No manual counting — everything updates live as new crimes are entered.

- **Main Dashboard** with KPI cards:
  - Total FIRs (today / this week / this month / this year)
  - Pending vs solved cases
  - Total accused arrested vs wanted
  - Property recovered (₹ value)
  - Average days to chargesheet
- **Charts & visualizations:**
  - Crime trend over time (line chart — daily/weekly/monthly)
  - Crime type breakdown (pie chart — theft, assault, fraud, etc. by IPC/BNS section)
  - Heatmap of crime by location/area
  - Top sections invoked (bar chart)
  - Officer-wise case load
  - Station-wise comparison (if multi-station)
  - Age/gender distribution of accused and complainants
  - Day-of-week and time-of-day crime patterns
- **Filters:** date range, station, section, officer, crime type — all charts update together
- **Custom queries:** admin can build a query (e.g. "all theft cases by accused aged 18–25 in last 6 months") and save it as a saved view
- **Export:** any chart/table → PNG, PDF, or Excel
- **Auto-generated reports:** monthly statistics report (मासिक अहवाल) pulls directly from analyzer data
- **Alerts:** flag unusual spikes (e.g. "thefts in this area up 40% this month")

### 9. Settings
- Station details (name, district, code)
- User management
- Backup folder location
- Default report template
- **Language preference (Marathi / English)** — also togglable from top bar

## Database Schema (Core Tables)

```sql
-- Core fixed tables
crimes (id, fir_no, year, section, sub_section, station_id, district, date_occurred, time_occurred, place_occurred, date_registered, time_registered, crime_type, status, created_at, updated_at)

complainants (id, crime_id, name, gender, age, address, mobile, email, aadhaar, pan, passport)

accused (id, crime_id, name, gender, age, address, mobile, email, aadhaar, pan, passport, arrest_status, arrest_date, arrest_time, photo_path)

stolen_property (id, crime_id, type, description, value)

recovered_property (id, crime_id, description, value, recovery_date)

investigation (id, crime_id, officer_name, officer_id, officer_mobile, filed_by, preventive_action, preventive_no, preventive_date, wanted_accused)

verdict (id, crime_id, chargesheet_no, chargesheet_date, rcc_no, final_order, found_guilty, punishment)

attachments (id, crime_id, file_path, file_type, description, uploaded_at)

-- Extensibility (EAV pattern)
custom_fields (id, field_name_marathi, field_name_english, field_type, section, is_required, dropdown_options_json, display_order, created_at)

custom_field_values (id, crime_id, custom_field_id, value)

-- Templates
report_templates (id, name, description, template_json, output_format, is_system, created_by, created_at, updated_at)

-- Users
users (id, username, password_hash, full_name, role, station_id, is_active, created_at)

stations (id, name_marathi, name_english, code, district, address)

-- Audit
audit_log (id, user_id, action, entity_type, entity_id, changes_json, timestamp)
```

## Template JSON Format

Example for B-Patrak:

```json
{
  "name": "ब पत्रक",
  "type": "table",
  "header": "ब पत्रक",
  "page_size": "A4",
  "rows": [
    { "sr": 1, "label": "पोलीस ठाणे", "value": "{station.name_marathi}, {station.district}" },
    { "sr": 2, "label": "गु.र.नं.व कलम", "value": "{crime.fir_no}/{crime.year} कलम {crime.section} {crime.sub_section}" },
    { "sr": 3, "label": "फिर्यादी", "value": "{complainant.name} वय-{complainant.age} वर्ष व्यवसाय रा.{complainant.address} मो.{complainant.mobile}" },
    { "sr": 4, "label": "गु.घ.वेळ व ठिकाण", "value": "दि.{crime.date_occurred} रोजी {crime.time_occurred} वा. {crime.place_occurred}" },
    { "sr": 5, "label": "गु.दा.ता.वेळ", "value": "दि.{crime.date_registered} रोजी {crime.time_registered} वाजता" },
    { "sr": 10, "label": "गेला माल", "value": "{#stolen_property}{description}{/stolen_property}" },
    { "sr": 12, "label": "आरोपीचे नाव", "value": "{#accused}{name}{/accused}", "fallback": "दोन अनोळखी" },
    { "sr": 17, "label": "सविस्तर खुलासा", "value": "{crime.detailed_description}" }
  ]
}
```

## File Structure

```
crms/
├── PROJECT.md                  (this file - always read first)
├── pubspec.yaml                (Flutter deps & asset declarations)
├── assets/
│   ├── fonts/
│   │   └── NotoSansDevanagari-*.ttf
│   └── translations/
│       ├── mr.json             (Marathi translations)
│       └── en.json             (English translations)
├── lib/
│   ├── main.dart               (app entry, runApp)
│   ├── app.dart                (MaterialApp, routing, EasyLocalization)
│   ├── core/
│   │   ├── i18n/               (easy_localization setup, language switch)
│   │   ├── theme/
│   │   ├── crypto/             (AES field-encryption helpers)
│   │   └── utils/
│   ├── data/
│   │   ├── db/
│   │   │   ├── database.dart    (drift database)
│   │   │   ├── tables/          (drift table defs)
│   │   │   └── daos/            (queries — ORM only)
│   │   └── sync/               (Google Drive sync)
│   ├── features/
│   │   ├── auth/               (Sign in with Google)
│   │   ├── crime_entry/        (7-tab form)
│   │   ├── crime_list/         (list + search + detail)
│   │   ├── reports/
│   │   │   ├── engine.dart      (template rendering engine)
│   │   │   ├── docx_renderer.dart
│   │   │   ├── pdf_renderer.dart
│   │   │   └── templates/       (pre-loaded JSON templates)
│   │   │       ├── b-patrak.json
│   │   │       ├── fir-copy.json
│   │   │       └── ...
│   │   ├── template_builder/   (drag-drop builder, admin)
│   │   ├── custom_fields/      (EAV field manager, admin)
│   │   ├── analyzer/
│   │   │   ├── dashboard.dart
│   │   │   ├── charts/
│   │   │   ├── queries.dart     (saved analytics queries)
│   │   │   └── exports.dart     (PNG/PDF/Excel export)
│   │   └── settings/
│   └── shared/
│       └── widgets/            (reusable UI: bilingual fields, tables)
├── windows/  macos/  android/  ios/   (platform runners — flutter create)
└── test/
```

## Build Phases

### Phase 1: Foundation (Week 1-2) — ✅ DONE
- Project setup, **Flutter (Dart)** — desktop + mobile targets
- SQLite + **drift** ORM setup (SQLCipher encryption — field-level done; whole-file TODO)
- Core schema migrations (drift tables — all 14 tables)
- **i18n setup (easy_localization) with Marathi + English locale files**
- **Sign in with Google** login screen (bilingual; OAuth stubbed pending credentials)

### Phase 2: Data Entry (Week 3-4) — ✅ DONE
- Crime entry form with all 7 tabs (bilingual labels, validated)
- Multi-accused, multi-property support (add/remove rows)
- Save/edit/delete crimes (drift transaction; Aadhaar/PAN encrypted on save)
- Note: native file picker for attachments deferred to a later phase

### Added feature: Excel Import — ✅ DONE
- Import old records from .xlsx; auto-maps all 51 Marathi column headers to the model
- Handles Devanagari numerals (२०२६→2026), multiple date formats, Marathi gender/guilty values
- Aadhaar/PAN encrypted on import; each row → new crime; blank rows skipped
- Added schema v2: `crimes.police_station` column (per-record station name); surfaced in form/detail/reports

### Phase 3: List & Search (Week 5) — ✅ DONE
- Crime list page with search (FIR/complainant/accused) + status & date-range filters
- Read-only detail view with edit/delete
- Live-updating list (drift stream); is now the post-login home screen
- Note: station/officer filters deferred until that data exists (Phase 8)

### Phase 4: Report Engine (Week 6-7) — ✅ DONE
- Template engine: simple/combined placeholders, loops (accused/property), fallback
- DOCX renderer (hand-built OOXML; Word shapes Marathi correctly) — recommended for official output
- PDF renderer (pdf package, embedded Noto Devanagari) + OS direct print (printing package)
- B-Patrak template bundled; "Generate Report" on the detail screen (pick template + PDF/DOCX, print/save)
- Note: pure-Dart PDF has limited Devanagari shaping; DOCX/OS-print are the correct-Marathi paths (renderer is swappable)

### Added feature: Crime Statistics report — ✅ DONE
- Pick a year → matrix of crime-type rows × 12 months (निकाली solved / प्रलंबित unsolved) + year & previous-year totals + grand total
- On-screen scrollable table (Unicode Marathi) + Excel (.xlsx) export; reached from the Data Analyzer
- "New template" now starts as a proper multi-row ब-पत्रक (fixes custom reports rendering as one box)

### Phase 5: Template Builder (Week 8-9) — ✅ DONE
- Reorderable row builder with bilingual field-insert picker (drag to reorder)
- Save/edit/duplicate/delete templates (DB-backed); duplicate bundled → custom
- DB templates appear in the report picker alongside bundled B-Patrak
- Note: more standard templates (A/C-Patrak, chargesheet, etc.) still to be authored; section/footer/page-number layout deferred (table type for now)

### Phase 6: Custom Fields (Week 10) — ✅ DONE
- Admin manager: add/edit/delete fields (text/number/date/dropdown/checkbox/file), required flag, dropdown options
- Fields attach to a section (crime info/complainant/investigation/verdict/other) and auto-render in the entry form
- Values stored via EAV (custom_field_values), shown in detail view, addressable in templates as {custom.<id>}
- Note: custom fields are one-per-crime (not supported on multi-row accused/property sections)

### Phase 7: Data Analyzer (Week 11-12) — ✅ DONE (core)
- Live dashboard: KPI cards (total/today/week/month/year, pending/solved, arrested/wanted, ₹ recovered, avg days to chargesheet)
- Charts (fl_chart): monthly trend line, status pie, day-of-week bars; ranked bars for top sections / crime types / officer load
- Shared filters (date range / status / section) recompute every card + chart together
- Pure compute layer (computeAnalytics) fully unit-tested
- Deferred: heatmap, saved queries, auto monthly report, chart export to PNG/PDF/Excel, spike alerts

### Phase 8: Polish (Week 13-14) — ◐ PARTIAL
- ✅ Settings: station details (name mr/en, district, code) + default report template; station feeds {station.*} in reports
- ✅ Audit logging: every crime create/update/delete recorded; read-only Audit Log viewer
- ✅ Backup & Restore: AES-encrypted DB export (VACUUM INTO); restore staged & applied on next launch (avoids file locks)
- ⏳ Deferred: user management (needs real auth/roles), Windows .exe installer (msix/Inno — packaging step)

### Design System Refactor — ◐ IN PROGRESS
- **Tokens** (`lib/core/theme/`): colors (Maharashtra Police navy/khaki/gold), typography (Inter + Noto Devanagari fallback + JetBrains Mono, bundled), spacing (8-pt), radii, shadows; `CrmsTheme.light()/.dark()` + `themeModeProvider`.
- **Widget kit** (`lib/shared/widgets/crms.dart`): CrmsButton (4 variants), CrmsTextField, CrmsCard, CrmsBadge (status pills), CrmsTable, CrmsModal, CrmsToast, CrmsEmptyState, CrmsTopBar, CrmsSidebar, DarkModeToggle, LanguageToggle (pill).
- **Screens refactored:** Splash (new), Login (split navy/form), Crime list (Phosphor icons, status badges, empty states, dark toggle), Dashboard (accent KPI cards, brand chart palette), empty states across templates/custom fields/audit/stats/analyzer.
- **Dark mode** implemented (toggle in top bars). Fonts bundled (offline-first; no google_fonts runtime fetch). Icons: Phosphor (regular).
- **Deferred:** full sidebar-shell navigation, Ctrl+K command palette wiring, loading skeletons, chart draw-in animation, per-screen component swap for detail/report/settings (currently theme-styled).

### Phase 9+: Mac, Android, iOS

## Rules for Claude Code

When working on this project:

1. **Always read this PROJECT.md first** at the start of every session
2. Build **one feature at a time** — do not scaffold the whole app at once
3. **Bilingual UI (Marathi + English)** — every user-facing string must come from the i18n locale files (`mr.json` / `en.json`). Never hard-code labels. User can switch language anytime and the whole UI updates live.
4. **Never hard-code field labels** in the report engine — always read from template JSON
5. **All DB queries must go through the ORM**, never raw SQL except for migrations
6. **Every form must have Zod validation** before saving
7. **Photos and attachments** are stored as file paths, not blobs
8. **Aadhaar, PAN must be encrypted at rest** using node `crypto`
9. **Test the report output** by generating B-Patrak after every change to the engine
10. **Confirm before destructive actions** (delete crime, delete template)

## Decisions (Resolved 2026-06-14)

- [x] **Architecture:** Multi-station. The "central server" is **Google Drive** — no self-hosted backend. Each station keeps a local encrypted SQLite DB and syncs through Google Drive.
- [x] **Auth + Sync:** **Login with Google (email / OAuth)**. User signs in with their Google account; crime data syncs to Google Drive. (See "Auth & Sync Model" below — exact Drive sharing model still being pinned down.)
- [x] **Aadhaar storage:** **Full 12-digit number, encrypted at rest** using node `crypto`. Especially important since data leaves the device to Google Drive.
- [x] **Report output:** **Direct print from the app + file generation** (.docx / .pdf).

## Still Open

- [ ] Who maintains pre-loaded templates — bundled with app or downloaded?
- [ ] Cross-station / HQ aggregation: how does data from many per-user Drives ever roll up? (deferred — needs a merge strategy in a later phase)

## Auth & Sync Model (Google Drive)

- **Sync (implemented): folder-based.** The app writes an AES-encrypted copy of the DB into a user-chosen folder (their **Google Drive for Desktop** folder); Google Drive Desktop uploads it — including offline buffering. Offline-first: local SQLite is always the source of truth; the cloud copy catches up when online. Push is debounced on every change + manual "Sync now"; pull happens on launch if the remote copy is newer (last-write-wins). No OAuth/credentials needed.
- **Identity:** Google OAuth ("Sign in with Google") — **deferred**. Real per-account Drive API + mobile sync would use this; folder-sync covers desktop now without it. Login is currently stubbed (demo).
- **Drive model:** **Per-user personal Drive.** Each officer's data lives in their own Drive folder. Data is isolated per user.
- **Encryption:** sensitive fields (Aadhaar, PAN) are encrypted **before** they ever reach Drive, so Google never sees plaintext. The DB file uploaded to Drive is encrypted at rest.
- **Implication to track:** because each user has their own Drive copy, there is no single station-level source of truth out of the box. Station/HQ roll-up requires an explicit merge step — deferred to a later phase (see Still Open).
- **Privacy note:** this is real crime data (incl. Aadhaar) on Google infrastructure — encryption-before-upload is mandatory and non-negotiable.
