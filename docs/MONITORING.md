# Monitoring checklist

## Daily Katha API (Render)

- **Logs** — errors, 5xx, OTP failures.
- **Metrics** — CPU/memory if instance is undersized.
- **Deploy** — confirm latest commit after merges.

## Neon

- Connection count, storage, slow queries (dashboard).

## Sentry (optional)

- Issues filtered by `environment:production`.
- Ignore noise from health probes if any appear.

## Uptime (optional)

- HTTP GET `/health` every 5 minutes (e.g. UptimeRobot).
- Alert if **non-200** or missing `database: connected` for extended periods.

## Escalation

1. Check Render env (`DATABASE_URL`, SMS OTP vars: Twilio or MSG91).  
2. `curl /health` and recent deploy logs.  
3. Neon status / credentials.
