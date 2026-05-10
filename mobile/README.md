# Daily Katha (Flutter)

Multilingual shareable status cards. The production client lives here; product specs live in the repo root (`PRD.md`, etc.).

**Shipping version:** `1.2.0+119` in `pubspec.yaml` (`versionName` / `CFBundleShortVersionString` **1.2.0**, `versionCode` / `CFBundleVersion` **119**).

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

OTP is **`POST /v1/auth/send-otp`** and **`/verify-otp`** on the deployed API (**`backend/src/app.js`**). The backend sends **`SMS`** via **Twilio or MSG91** (`docs/SMS_OTP.md`).

**Dart behavior (`lib/core/app_config.dart`):**

- **Production / staging flavor** (`FLAVOR=production` or `staging`): **`useLiveOtp`** defaults **on** (both **`ALLOW_LIVE_BACKEND_OTP`** and **`REQUIRE_BACKEND_OTP`** default **`true`**). Users receive a carrier **SMS** and must verify with the backend.
- **Development flavor**: **`useLiveOtp`** is **off** → enter **any 6 digits** for local/demo flow (see `AuthRepository`).
- **`API_BASE=mock`** (or `offline`): no HTTP OTP — bundled catalog flows only.

Optional: **`TESTING_SKIP_TO_HOME_AFTER_LOCAL_OTP`** (`false` by default) — after verify, skip onboarding and jump to Home when paired with demo/local OTP paths.

**Production build (AAB / APK)**

Defaults are usually enough for real SMS OTP; override only if needed:

```bash
flutter build appbundle --flavor prod --release \
  --dart-define=FLAVOR=production \
  --dart-define=ALLOW_LIVE_BACKEND_OTP=true \
  --dart-define=REQUIRE_BACKEND_OTP=true
```

Optional: **`--dart-define=TESTING_SKIP_TO_HOME_AFTER_LOCAL_OTP=true`** for testing shortcuts alongside demo flows.

On Render, configure **`TWILIO_*`** or **`MSG91_*`** (and India **DLT** template text matching **`SMS_OTP_MESSAGE`**) — see **`docs/SMS_OTP.md`**.

Configure **release signing** in `android/app/build.gradle.kts` (replace the temporary debug signing before uploading an AAB).
