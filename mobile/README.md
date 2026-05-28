# Daily Katha (Flutter)

Multilingual shareable status cards. The production client lives here; product specs live in the repo root (`PRD.md`, etc.).

**Shipping version:** `1.2.0+138` in `pubspec.yaml` (`versionName` / `CFBundleShortVersionString` **1.2.0**, `versionCode` / `CFBundleVersion` **138**).

## Run

```bash
cd mobile
flutter pub get
flutter run
```

Optional API: `flutter run --dart-define=API_BASE=https://your.api.host`

With an empty `API_BASE`, the app uses bundled JSON under `assets/data/` (see exporter below).

## APK you’ve been installing (`build/app/outputs/flutter-apk/app-release.apk`)

After **Android flavors** were added, `flutter build apk --release` should use the **prod** flavor. Flutter writes the main file as **`app-prod-release.apk`**.

- **Older `app-release.apk`** on disk is only valid if **rebuilt** after your latest code changes. If you kept opening the old file, it would **not** include the latest login and auth fixes.
- **Rebuild the familiar path:** from `mobile/` run:

```bash
./scripts/build_app_release_apk.sh
```

That runs `flutter build apk --flavor prod --release …` and copies the result to **`build/app/outputs/flutter-apk/app-release.apk`** so you can keep installing the same path while you iterate toward launch.

Manual equivalent:

```bash
flutter build apk --flavor prod --release --dart-define=FLAVOR=production
# then install: build/app/outputs/flutter-apk/app-prod-release.apk
```

## Content export (after editing spreadsheets at repo root)

```bash
# from repository root (parent of mobile/)
python3 scripts/export_language_catalogs.py
```

## Auth / Truecaller / Render

Daily Katha now uses **Truecaller** for login on Android. The app launches the Truecaller consent flow, sends the returned authorization code to the backend, and the backend exchanges it for a Daily Katha session.

**Dart behavior (`lib/core/app_config.dart`):**

- The login screen is now the Truecaller entry point.
- If no persisted session exists, the app routes to `/login`.
- After Truecaller success, the backend returns the normal Daily Katha session and onboarding continues as before.

**Production build (AAB / APK)**

```bash
flutter build appbundle --flavor prod --release --dart-define=FLAVOR=production
```

On Render, configure **`TRUECALLER_CLIENT_ID`** in addition to the normal API secrets.

Configure **release signing** in `android/app/build.gradle.kts` (replace the temporary debug signing before uploading an AAB).
