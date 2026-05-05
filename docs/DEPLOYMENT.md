# Production deployment (Daily Katha)

## 1. Neon (PostgreSQL)

1. Create project → copy **pooler** `DATABASE_URL` (host contains `-pooler`).
2. Run migrations: `cd backend && npm ci && DATABASE_URL=... npm run migrate:prod`.
3. If you use **legacy `server.js`** schema, apply `backend/src/db/migrations/*.sql` in order (see `docs/DATABASE.md`).
4. Verify: `npm run db:ping`.

## 2. Render (API)

1. Web service → **Root** = repo root for `dailykatha-backend` subtree, or set **start** to `node src/server.js`.
2. Set env from `backend/.env.production.template` (real values, never commit).
3. **Secrets:** `DATABASE_URL`, `JWT_SECRET`, **SMS OTP** vars (`TWILIO_*` or `MSG91_*`, plus optional `SMS_OTP_MESSAGE`; see `docs/SMS_OTP.md`), optional `REDIS_URL`, `SENTRY_DSN`, `CORS_WHITELIST`.
4. Health: `GET https://<service>.onrender.com/health` → `database: connected`.

## 3. GitHub

- **Secrets:** `DATABASE_URL`, `JWT_SECRET`, `RENDER_DEPLOY_HOOK_URL` (monorepo `backend-cd-render.yml`), or repo secrets for subtree `database-migrate.yml`.
- **QA:** set `ENABLE_QA_SHORTCUTS=false` on Render for public launch.

## 4. Mobile

1. Production API base: `https://dailykatha-backend.onrender.com/v1` (or see `lib/config/flavor_config.dart` / `prod_config.dart`).
2. Build APK/AAB: `mobile/scripts/build_app_release_apk.sh` or `build_app_release_aab.sh`.
3. Play Console / App Store: privacy policy URL, signing keys (local or CI secrets).

## 5. Compliance & ops

- `docs/PRIVACY_POLICY.md`, `docs/TERMS_OF_SERVICE.md` — host publicly; paste URLs into stores.
- `docs/SECRET_ROTATION.md`, `docs/MONITORING.md`.
- Optional: UptimeRobot → `/health` every 5 minutes.
