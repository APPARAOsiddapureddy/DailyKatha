# Daily Katha (Flutter)

Multilingual shareable status cards. The production client lives here; product specs live in the repo root (`PRD.md`, etc.).

## Run

```bash
cd mobile
flutter pub get
flutter run
```

Optional API: `flutter run --dart-define=API_BASE=https://your.api.host`

With an empty `API_BASE`, the app uses bundled JSON under `assets/data/` (see exporter below).

## Content export (after editing spreadsheets at repo root)

```bash
# from repository root (parent of mobile/)
python3 scripts/export_language_catalogs.py
```

## Android release (Play Store)

```bash
flutter build appbundle --release
```

Configure **release signing** in `android/app/build.gradle.kts` (replace the temporary debug signing before uploading an AAB).
