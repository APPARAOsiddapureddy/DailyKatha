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

## APK you’ve been installing (`build/app/outputs/flutter-apk/app-release.apk`)

After **Android flavors** were added, `flutter build apk --release` should use the **prod** flavor. Flutter writes the main file as **`app-prod-release.apk`**.

- **Older `app-release.apk`** on disk is only valid if **rebuilt** after your latest code changes. If you kept opening the old file, it would **not** include OTP bypass or other fixes.
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

## Auth / OTP / Render

**Testing APK (default compile flags):**

- **`ALLOW_LIVE_BACKEND_OTP`**: defaults to **`false`** → the app never calls Render for `send-otp` / `verify-otp`.
- **`REQUIRE_BACKEND_OTP`**: ignored for HTTP until `ALLOW_LIVE_BACKEND_OTP=true`.
- **`TESTING_SKIP_TO_HOME_AFTER_LOCAL_OTP`**: defaults to **`false`** → enter any **6 digits** → **Verify** → **Language → Religion → Interests → Home** (no SMS).

To skip straight to **Home** after verify on a testing build:

```bash
flutter build apk --flavor prod --release \
  --dart-define=FLAVOR=production \
  --dart-define=TESTING_SKIP_TO_HOME_AFTER_LOCAL_OTP=true
```

**Do you need to change Render for testing APKs?**

- **No** — bypass is entirely on the device. Quotes/feed calls still use `API_BASE` / `FlavorConfig.apiBase`; only OTP is skipped.
- When you eventually enable **real SMS OTP**, you must deploy the **legacy** Node service that exposes **`POST /v1/auth/send-otp`** and **`POST /v1/auth/verify-otp`** (`backend/src/server.js` style). The newer **`src/app.js`** REST API **does not** implement those routes, so **`useLiveOtp`** would otherwise get **404** and appear “stuck” on OTP.

**Production SMS OTP (Play Store bundle):**

Pass **both** flags (plus your signing setup):

```bash
flutter build appbundle --flavor prod --release \
  --dart-define=FLAVOR=production \
  --dart-define=ALLOW_LIVE_BACKEND_OTP=true \
  --dart-define=REQUIRE_BACKEND_OTP=true
```

Optional: `--dart-define=TESTING_SKIP_TO_HOME_AFTER_LOCAL_OTP=true` so verify skips onboarding and opens Home directly.

Configure **release signing** in `android/app/build.gradle.kts` (replace the temporary debug signing before uploading an AAB).
