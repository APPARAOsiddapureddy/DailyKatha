import { HttpError } from '../utils/errorHandler.js';

const MSG91_VERIFY_ACCESS_TOKEN_URL = 'https://control.msg91.com/api/v5/widget/verifyAccessToken';

async function readResponseBody(response) {
  const text = await response.text();
  if (!text) return null;
  try {
    return JSON.parse(text);
  } catch (_) {
    return text;
  }
}

/**
 * Verifies the JWT access token returned by the MSG91 OTP widget after the user verifies OTP.
 *
 * @see https://docs.msg91.com/otp-widget
 */
export async function verifyMsg91AccessToken({ authKey, accessToken }) {
  const key = String(authKey || process.env.MSG91_AUTHKEY || '').trim();
  const token = String(accessToken || '').trim();

  if (!key) {
    throw new HttpError(503, 'MSG91_NOT_CONFIGURED', 'MSG91 auth key is not configured');
  }
  if (!token) {
    throw new HttpError(400, 'MSG91_MISSING_TOKEN', 'MSG91 access token is required');
  }

  const body = new URLSearchParams({
    authkey: key,
    'access-token': token,
  });

  const response = await fetch(MSG91_VERIFY_ACCESS_TOKEN_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
      Accept: 'application/json',
    },
    body,
  });

  const payload = await readResponseBody(response);
  if (!response.ok) {
    const message =
      (payload && typeof payload === 'object' && (payload.message || payload.error || payload.type)) ||
      `MSG91 access token verification failed (${response.status})`;
    throw new HttpError(401, 'MSG91_VERIFY_FAILED', String(message));
  }

  if (payload && typeof payload === 'object') {
    const type = String(payload.type || '').toLowerCase();
    if (type && type !== 'success') {
      throw new HttpError(
        401,
        'MSG91_VERIFY_FAILED',
        String(payload.message || payload.error || 'MSG91 access token verification failed'),
      );
    }
    return payload.data && typeof payload.data === 'object' ? payload.data : payload;
  }

  throw new HttpError(502, 'MSG91_VERIFY_EMPTY', 'MSG91 returned an empty verification response');
}
