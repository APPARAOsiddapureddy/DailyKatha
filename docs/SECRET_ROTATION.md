# Secret rotation

## `JWT_SECRET`

1. Generate: `openssl rand -hex 32`.
2. Set new value on **Render** (and GitHub Actions secrets if used).
3. **Redeploy** the API. Existing user tokens become invalid; users sign in again.

## Neon database password

1. Neon dashboard → reset role password.
2. Update **`DATABASE_URL`** everywhere (Render, GitHub `DATABASE_URL`, local `.env`).
3. Redeploy / rerun migrations if needed.

## WhatsApp (`WHATSAPP_ACCESS_TOKEN`)

1. Meta Business → WhatsApp → regenerate token as required.
2. Update Render env vars.
3. Redeploy.

## Redis

If using Upstash/Redis Cloud, rotate credentials there and update **`REDIS_URL`** on Render.
