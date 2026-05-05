/**
 * SMS OTP for Indian mobiles (+91). Used for OTP autofill–friendly carrier SMS.
 *
 * Env:
 * - SMS_PROVIDER: `twilio` | `msg91` — optional; auto-detected from credentials if unset.
 * - SMS_OTP_MESSAGE — must include `{otp}`; text must match your India DLT–registered template
 *   exactly when using MSG91 (and often for Twilio India routes).
 * - OTP_ALLOW_WITHOUT_SMS=true — log only (local / staging).
 *
 * Twilio: TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN, TWILIO_FROM (+E.164 or approved sender).
 * MSG91: MSG91_AUTHKEY, MSG91_SENDER (6-char DLT header), optional MSG91_ROUTE (default 4).
 */

const DEFAULT_SMS_TEMPLATE =
  'Your Daily Katha verification code is {otp}. Do not share it with anyone.';

function buildMessage(code) {
  const tmpl = (process.env.SMS_OTP_MESSAGE || DEFAULT_SMS_TEMPLATE).trim();
  if (!tmpl.includes('{otp}')) {
    const err = new Error('SMS_OTP_MESSAGE must include {otp} placeholder');
    err.code = 'SMS_MISCONFIGURED';
    throw err;
  }
  return tmpl.replaceAll('{otp}', String(code));
}

function resolveProvider() {
  const explicit = (process.env.SMS_PROVIDER || '').trim().toLowerCase();
  if (explicit === 'twilio' || explicit === 'msg91') return explicit;

  const twilioOk =
    process.env.TWILIO_ACCOUNT_SID &&
    process.env.TWILIO_AUTH_TOKEN &&
    process.env.TWILIO_FROM;
  if (twilioOk) return 'twilio';

  const msg91Ok = process.env.MSG91_AUTHKEY && process.env.MSG91_SENDER;
  if (msg91Ok) return 'msg91';

  return null;
}

async function sendViaTwilio(phoneDigits, message) {
  const sid = process.env.TWILIO_ACCOUNT_SID;
  const token = process.env.TWILIO_AUTH_TOKEN;
  const from = process.env.TWILIO_FROM;
  const to = `+91${phoneDigits}`;

  const auth = Buffer.from(`${sid}:${token}`).toString('base64');
  const body = new URLSearchParams({
    To: to,
    From: from,
    Body: message,
  });

  const url = `https://api.twilio.com/2010-04-01/Accounts/${sid}/Messages.json`;
  const res = await fetch(url, {
    method: 'POST',
    headers: {
      Authorization: `Basic ${auth}`,
      'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
    },
    body: body.toString(),
  });

  const text = await res.text();
  if (!res.ok) {
    const err = new Error(`Twilio SMS failed (${res.status}): ${text}`);
    err.code = 'SMS_SEND_FAILED';
    throw err;
  }
}

async function sendViaMsg91(phoneDigits, message) {
  const authkey = process.env.MSG91_AUTHKEY;
  const sender = process.env.MSG91_SENDER;
  const route = process.env.MSG91_ROUTE || '4';

  const payload = {
    sender,
    route,
    country: '91',
    sms: [{ message, to: [`91${phoneDigits}`] }],
  };

  const res = await fetch('https://control.msg91.com/api/v2/sendsms', {
    method: 'POST',
    headers: {
      authkey,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(payload),
  });

  const text = await res.text();
  let data;
  try {
    data = JSON.parse(text);
  } catch {
    const err = new Error(`MSG91 SMS unexpected response (${res.status}): ${text}`);
    err.code = 'SMS_SEND_FAILED';
    throw err;
  }

  if (data?.type !== 'success') {
    const err = new Error(
      `MSG91 SMS failed: ${typeof data?.message === 'string' ? data.message : JSON.stringify(data)}`,
    );
    err.code = 'SMS_SEND_FAILED';
    throw err;
  }
}

/**
 * @param {string} phoneDigits — 10-digit Indian mobile (no country code prefix)
 * @param {string} code — 6-digit OTP
 */
export async function sendOtpViaSms(phoneDigits, code) {
  const allowSkip = process.env.OTP_ALLOW_WITHOUT_SMS === 'true';
  if (allowSkip) {
    console.warn(`[sms] OTP_ALLOW_WITHOUT_SMS — skipping send to 91${phoneDigits} (${code})`);
    return;
  }

  const provider = resolveProvider();
  if (!provider) {
    const err = new Error(
      'SMS OTP is not configured (set Twilio vars or MSG91_AUTHKEY+MSG91_SENDER, or SMS_PROVIDER)',
    );
    err.code = 'SMS_NOT_CONFIGURED';
    throw err;
  }

  const message = buildMessage(code);
  if (provider === 'twilio') await sendViaTwilio(phoneDigits, message);
  else await sendViaMsg91(phoneDigits, message);
}
