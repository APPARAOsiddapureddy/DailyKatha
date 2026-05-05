# SMS OTP (production checklist)

Daily Katha sends login OTP via **carrier SMS** (not WhatsApp). The API response uses `channel: "sms"`.

## 1. Backend env (Render)

Set from `backend/.env.production.template` (real values — never commit).

| Variable | Purpose |
|----------|---------|
| `SMS_PROVIDER` | Optional: `twilio` \| `msg91`. If omitted, the server picks Twilio when `TWILIO_*` is set, else MSG91 when `MSG91_*` is set. |
| `SMS_OTP_MESSAGE` | Optional. **Must contain `{otp}`.** Must match **India DLT–approved** wording exactly when using MSG91 (and for many Indian routes via Twilio). Default is in `smsOtp.js`. |
| `OTP_ALLOW_WITHOUT_SMS` | Set `true` only in dev/staging to log the code without sending SMS. Leave **unset/false** in production. |

### Twilio

1. Create a [Twilio](https://www.twilio.com/) account and a **Messaging Service** / sender approved for SMS to India (`+91`) if applicable.
2. Set **`TWILIO_ACCOUNT_SID`**, **`TWILIO_AUTH_TOKEN`**, **`TWILIO_FROM`** (E.164 or approved alphanumeric where allowed).
3. Ensure the OTP body (`SMS_OTP_MESSAGE` or default) complies with carrier and country rules.

### MSG91 (common in India)

1. Complete **enterprise / DLT** registration (principal entity, sender ID, **content template**).
2. Register a **template** whose text matches **`SMS_OTP_MESSAGE`** (including `{otp}` replaced by the live code in the portal’s variable pattern — your DLT template must match the final SMS text).
3. Set **`MSG91_AUTHKEY`**, **`MSG91_SENDER`** (6-character approved header), optional **`MSG91_ROUTE`** (default `4` transactional).
4. Redeploy and send a test OTP to your own number.

## 2. India (DLT)

Transactional SMS to Indian subscribers requires **DLT** registration (entity, header, template). The string your API sends must match the registered template **character-for-character** (except the OTP digits). Plan this before launch.

## 3. Android OTP autofill (optional, app-side)

Carrier SMS enables **SMS User Consent** / **SMS Retriever** APIs. Steps (high level):

1. Add Flutter packages or platform code for **SMS Retriever** and/or **sms_autofill**.
2. Send SMS in the format Google documents (often including optional **11-character app hash** line for Retriever-only flows).

The backend currently sends plain text OTP; formatting can be adjusted later to include the hash line required by your app signing cert.

## 4. Verification

1. `POST /v1/auth/send-otp` with `{ "phone": "<10 digits>" }` → `channel: "sms"`.
2. Check device inbox; check Render logs for `SMS_SEND_FAILED` / `SMS_NOT_CONFIGURED`.
3. For temporary debugging only: `OTP_LOG_IN_PROD=true` logs the OTP in server logs — disable after troubleshooting.
