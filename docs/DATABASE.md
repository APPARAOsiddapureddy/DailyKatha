# Database layout

There are **two migration paths** in this repo:

1. **`npm run migrate`** (`backend/migrations/*.js`, node-pg-migrate) — v1 API tables (`quotes` integer id, `users` email in older migration file, etc.).
2. **`backend/src/db/migrations/*.sql`** — legacy **cards / UUID users** schema used by `src/server.js` (Render production today).

Your Neon database may contain **one or both**, depending on what you applied.

## Checks

```bash
cd backend && npm run db:ping
# Expect connection success; quote counts depend on which schema + seeds you ran.
```

## `otp_codes`

Required for OTP without Redis. Created by `1747363200000_otp_codes.js` or `migrations/01-init.sql` / `scripts/sql/create_otp_codes.sql`.

Schema note: `phone` is the **primary key** (no separate `id` column). There is no `is_verified` column — verification consumes the row via `DELETE`.

## Quotes (360)

There is no bundled 360-quote seed in-repo by default. Import your dataset into `quotes` (or `cards`, depending on schema) after migrations, or add a seed script under `backend/scripts/`.
