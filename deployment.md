# DailyKatha — stack, deployment, and architecture reference

This document describes **what frameworks and services DailyKatha uses** and **how they fit together**. Use it as a blueprint when you start another app so local run, debugging, and production deployment stay predictable.

---

## High-level architecture

| Layer | Location | Role |
|--------|-----------|------|
| **Mobile client** | `mobile/` | Flutter app (Android primary; same codebase can target iOS). |
| **HTTP API** | `backend/` | Node.js **Express** server (`src/app.js`), JSON REST, JWT auth, OpenAPI docs. |
| **Database** | Postgres | Primary store for users, OTP (when Redis is omitted), favorites, quotes, migrations via **node-pg-migrate**. |
| **Optional cache / jobs** | Redis | Rate limiting helpers, caching, **BullMQ** workers (`npm run worker`) when enabled. |
| **Card content pipeline** | `scripts/` (repo root) | Python exports spreadsheets → bundled JSON under `mobile/assets/data/`. |

The repo is a **monorepo**: Flutter and Node live side by side with separate dependency trees (`pubspec.yaml` vs `package.json`).

---

## Frontend (mobile) — Flutter

### Core platform

- **Flutter** + **Dart** (`sdk: ^3.11.5` in `mobile/pubspec.yaml`).
- **Material** UI (`uses-material-design: true`).
- **Build flavors**: Android uses **prod** / **staging** / **dev** style splits; production builds typically pass `--dart-define=FLAVOR=production`. See `mobile/lib/config/flavor_config.dart`.

### App structure (how DailyKatha organizes code)

- **Entry**: `mobile/lib/main.dart` — initializes bindings, prefs, secure storage hooks, notifications, then `runApp`.
- **Root widget**: `mobile/lib/app/app.dart` (MaterialApp wired to routing).
- **Dependency injection / app state**: **flutter_riverpod** (`ProviderScope` at root). Providers live under `mobile/lib/data/` and related folders.
- **Navigation**: **go_router** declarative routes; router is exposed via a Riverpod provider and refresh patterns in `mobile/lib/app/router.dart` (auth-aware redirects).
- **Feature folders**: Under `mobile/lib/features/*` (e.g. home, feed, explore, profile, editor) — screens + localized UI copy.

### Networking and resilience

- **dio** — HTTP client.
- **dio_smart_retry** — retries for transient failures.
- **API base URL**: Controlled by compile-time **`API_BASE`** dart-define **or** `FlavorConfig.apiBase` (see `mobile/lib/core/app_config.dart`). `API_BASE=mock` / `offline` forces **bundled JSON only** (no live API).

### Local storage & device

- **flutter_secure_storage** — sensitive tokens where supported.
- **shared_preferences** — lightweight key-value.
- **connectivity_plus** — network awareness.
- **device_info_plus** — device metadata when needed.

### Sharing, media, and editor UX

- **share_plus**, **path_provider**, **image_picker**, **image_cropper**, **photo_view**, **permission_handler**, **image_gallery_saver2_fixed** — save/share and editing flows around cards.

### Internationalization

- **flutter_localizations** (SDK) + **intl**.
- **`l10n.yaml`** — codegen from ARB templates (`mobile/lib/l10n/app_en.arb` etc.) → `AppLocalizations`. Run **`flutter gen-l10n`** when ARB strings change.

### Fonts

- **google_fonts** — remote font pipeline (cached locally by the package).

### Notifications

- **flutter_local_notifications**, **timezone**, **flutter_timezone** — scheduled local reminders (OS-aligned scheduling).

### Tooling / quality

- **flutter_lints** + **`analysis_options.yaml`** (Dart analyzer rules).
- **CI**: `.github/workflows/mobile.yml` runs `flutter pub get`, **`flutter analyze`**, and **`flutter build apk`** with prod flavor.

### How you “run and debug” the frontend

```bash
cd mobile
flutter pub get
flutter run
```

- Point at a local API:

  ```bash
  flutter run --dart-define=API_BASE=http://127.0.0.1:3000/v1
  ```

- Offline / bundled catalog:

  ```bash
  flutter run --dart-define=API_BASE=mock
  ```

See `mobile/README.md` for **release APK/AAB**, signing, and OTP-related dart-defines.

---

## Backend — Node.js (Express)

### Runtime and module system

- **Node.js 20.x** (`engines` in `backend/package.json`). Prefer **Node 20** everywhere (GitHub Actions uses 20); the repo’s `Dockerfile` may still mention an older Node image — align the image with `engines` before relying on Docker in production.

- **ES modules**: `"type": "module"` — `import`/`export`, `import.meta.url`.

### HTTP server

- **express** — app composition in `backend/src/app.js`:
  - **pino** + **pino-http** structured logging (`requestLogger`).
  - **helmet**-style/security helpers (`securityHeaders`).
  - **cors** with whitelist middleware.
  - **express-rate-limit** (optionally Redis-backed via **rate-limit-redis** + **ioredis**).
  - **express-validator** — request validation alongside **zod** where used.
  - **morgan** may appear in legacy paths; primary stack favors pino.

### Routing surface (conceptual)

Mounted from `backend/src/routes/index.js`:

- **Health**: `/health` (and related status routes).
- **Public auth**: `/v1/auth/*` — OTP send/verify (SMS via Twilio or MSG91; see `backend/docs/SMS_OTP.md`).
- **JWT-protected**: `/v1/users/*` after `jwtAuth`.
- **API v1 (quotes/catalog-style)**: `/api/v1/*` — favorites, quotes, categories, etc. (JWT on favorites routes as implemented).

JWTs use **jsonwebtoken** (HS256; `JWT_SECRET`). See `backend/README.md` for **`sub`** claim matching `users.id`.

### Persistence

- **pg** (`node-postgres`) — Postgres access; pooling tuned for Neon/Render (URL normalization documented in backend README).

- **node-pg-migrate** — **`npm run migrate`** / **`npm run migrate:prod`** applies SQL migrations in `backend/migrations/`.

### Background work (optional)

- **bullmq** + **Redis** — job queue (`npm run worker` → `backend/src/workers/generationWorker.js`).
- **node-cron** — scheduled tasks if enabled in your deployment.

### External integrations

- **@anthropic-ai/sdk** — optional AI-assisted flows.
- **@sentry/node** — error tracking when `SENTRY_DSN` is set.

### API documentation

- **swagger-jsdoc** + **swagger-ui-express** — OpenAPI UI (e.g. `/api-docs` and JSON manifest as noted in `backend/README.md`).

### Testing

- **jest** (`NODE_OPTIONS=--experimental-vm-modules`) — unit tests; **supertest** for HTTP-level tests; integration/e2e configs as separate npm scripts (`test:integration`, `test:e2e`).

### How you “run and debug” the backend

```bash
cd backend
cp .env.example .env   # then edit DATABASE_URL, JWT_SECRET, CORS_WHITELIST, optional REDIS_URL
docker compose up -d    # Postgres 15432, Redis 16379 — see backend/docker-compose.yml
npm ci
npm run migrate
npm run dev             # Node --watch src/app.js
```

OpenAPI UI: **`http://localhost:3000/api-docs`** (per backend README).

---

## Infrastructure patterns (daily operations)

### Local databases (Docker Compose)

File: **`backend/docker-compose.yml`**.

- **Postgres 14** — mapped to host port **15432**, DB/user/password `dailykatha`.
- **Redis 7** — host port **16379**.

Compose is **scoped to backend services** — not the Flutter app. The mobile app connects to your machine’s loopback (`FlavorConfig.development` → `http://localhost:3000/v1` unless overridden).

### Production-style hosting (reference setup)

DailyKatha’s docs describe:

- **Render** — managed **Web Service** for Node (`npm ci`, `npm start`), **managed Postgres**, optional Redis.
- **GitHub Actions** — e.g. `backend-cd-render.yml`:
  - On push to **`main`** (paths under `backend/`), **`npm ci`**, **`npm run migrate:prod`** with **`DATABASE_URL`**, then **`curl` POST** to **Render deploy hook**.
- Separate **staging** workflow and secrets (`STAGING_DATABASE_URL`, `STAGING_RENDER_DEPLOY_HOOK_URL`).

Treat this as a **recipe**: DB migrate first, then deploy hook — avoids serving new code against an old schema.

### Container image (backend)

**`backend/Dockerfile`** — multi-stage-lite pattern: install prod deps (`npm ci --omit=dev`), copy `src` + `migrations`, `EXPOSE 3000`, **`CMD ["node","src/app.js"]`**. Bump the Node base image to **20** to match `engines` if you deploy with Docker.

---

## Content and data that are not “the API schema”

- **Bundled catalogs**: Exported JSON consumed by Flutter from **`mobile/assets/data/`** (offline / fast-first load).
- **Exporter**: Repo root **`python3 scripts/export_language_catalogs.py`** after editing `DailyKatha_*_Upload.xlsx` spreadsheets.

Pipeline: spreadsheet → Python → committed JSON assets → **`flutter pub get` / rebuild**.

---

## Reusing this architecture for your next app

1. **Monorepo layout**: `mobile/` (Flutter) + `backend/` (Node) + `scripts/` (optional tooling) + `.github/workflows/` (CI/CD).
2. **Flutter**: Riverpod + GoRouter + dio + flavors + `dart-define` for API base; ARB + `flutter gen-l10n` for strings.
3. **Backend**: Express as a thin HTTP layer; route modules; zod/validator; JWT for authenticated routes; **node-pg-migrate** for schema changes; env via **dotenv** (`backend/.env.example`).
4. **Local dev**: Docker Compose for Postgres/Redis; `npm run dev` with watch; Flutter against `localhost` or `10.0.2.2` on Android emulator as needed.
5. **Production**: Managed Postgres + stateless Node service; migrations in CI **before** deploy hook; secrets in GitHub Environments / Render dashboards.
6. **Observability**: Structured logs (pino), optional Sentry on both tiers if you extend the mobile app similarly later.

Keeping **version pinning** consistent (Node major in `engines`, Dockerfile, CI) and **migrations gated** ahead of deploys will save most cross-project debugging time.

---

## Quick file map

| Concern | Path |
|----------|------|
| Flutter deps | `mobile/pubspec.yaml` |
| Flavor / default API hosts | `mobile/lib/config/flavor_config.dart`, `mobile/lib/core/app_config.dart` |
| Router | `mobile/lib/app/router.dart` |
| Backend entry | `backend/src/app.js` |
| Route table | `backend/src/routes/index.js` |
| NPM deps | `backend/package.json` |
| Local DB | `backend/docker-compose.yml` |
| Backend env template | `backend/.env.example` |
| Detailed API deploy notes | `backend/README.md` |
| Root overview | `README.md` |

This is a **living reference**. When you change major versions or hosting, update **`deployment.md`** alongside `README.md` / `backend/README.md` / `mobile/README.md` so the three stay aligned.
