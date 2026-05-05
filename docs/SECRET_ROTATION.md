# Secret rotation

## `JWT_SECRET`

1. Generate: `openssl rand -hex 32`.
2. Set new value on **Render** (and GitHub Actions secrets if used).
3. **Redeploy** the API. Existing user tokens become invalid; users sign in again.

## Neon database password

1. Neon dashboard → reset role password.
2. Update **`DATABASE_URL`** everywhere (Render, GitHub `DATABASE_URL`, local `.env`).
3. Redeploy / rerun migrations if needed.

## SMS (Twilio or MSG91)

### Twilio

1. Twilio Console → Auth token / API keys → rotate if needed.
2. Update **`TWILIO_AUTH_TOKEN`** (and `TWILIO_ACCOUNT_SID` if you recreated the subaccount).

### MSG91

1. MSG91 dashboard → regenerate **auth key** per their flow.
2. Update **`MSG91_AUTHKEY`** on Render and redeploy.

## Redis

If using Upstash/Redis Cloud, rotate credentials there and update **`REDIS_URL`** on Render.
