import { HttpError } from '../utils/errorHandler.js';

const TRUECALLER_TOKEN_URL = 'https://oauth-account-noneu.truecaller.com/v1/token';
const TRUECALLER_USERINFO_URL = 'https://oauth-account-noneu.truecaller.com/v1/userinfo';

async function readResponseBody(response) {
  const text = await response.text();
  if (!text) return null;
  try {
    return JSON.parse(text);
  } catch (_) {
    return text;
  }
}

function normalizePhone(raw) {
  const digits = String(raw || '').replace(/\D/g, '');
  if (digits.length === 12 && digits.startsWith('91')) return digits.slice(2);
  if (digits.length === 13 && digits.startsWith('091')) return digits.slice(3);
  if (digits.length === 10) return digits;
  return null;
}

export async function exchangeTruecallerAuthorizationCode({ clientId, authorizationCode, codeVerifier }) {
  if (!clientId) throw new HttpError(503, 'TRUECALLER_NOT_CONFIGURED', 'Truecaller client ID is not configured');
  if (!authorizationCode || !codeVerifier) {
    throw new HttpError(400, 'TRUECALLER_MISSING_FIELDS', 'Truecaller authorization code and code verifier are required');
  }

  const body = new URLSearchParams({
    grant_type: 'authorization_code',
    client_id: clientId,
    code: authorizationCode,
    code_verifier: codeVerifier,
  });

  const response = await fetch(TRUECALLER_TOKEN_URL, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body,
  });

  const payload = await readResponseBody(response);
  if (!response.ok) {
    const message =
      (payload && typeof payload === 'object' && (payload.error_description || payload.error || payload.message)) ||
      `Truecaller token exchange failed (${response.status})`;
    throw new HttpError(401, 'TRUECALLER_TOKEN_EXCHANGE_FAILED', String(message));
  }

  const accessToken = payload?.access_token?.toString?.() ?? payload?.access_token ?? '';
  if (!accessToken) {
    throw new HttpError(502, 'TRUECALLER_TOKEN_EMPTY', 'Truecaller did not return an access token');
  }

  return {
    accessToken,
    tokenType: payload?.token_type?.toString?.() ?? payload?.token_type ?? 'Bearer',
    expiresIn: Number(payload?.expires_in ?? 0),
  };
}

export async function fetchTruecallerUserInfo(accessToken) {
  if (!accessToken) throw new HttpError(400, 'TRUECALLER_MISSING_TOKEN', 'Truecaller access token is required');

  const response = await fetch(TRUECALLER_USERINFO_URL, {
    method: 'GET',
    headers: {
      Authorization: `Bearer ${accessToken}`,
    },
  });

  const payload = await readResponseBody(response);
  if (!response.ok) {
    const message =
      (payload && typeof payload === 'object' && (payload.error_description || payload.error || payload.message)) ||
      `Truecaller userinfo failed (${response.status})`;
    throw new HttpError(401, 'TRUECALLER_USERINFO_FAILED', String(message));
  }

  return payload && typeof payload === 'object' ? payload : {};
}

export async function fetchTruecallerPhoneNumberDetail({ accessToken }) {
  const info = await fetchTruecallerUserInfo(accessToken);
  const phone = info.phone_number ?? info.phone ?? info.mobile ?? null;
  return {
    phoneNumber: phone,
    phone_number: phone,
    phone,
    mobile: phone,
    state: info.phone_number_country_code ?? info.state ?? null,
  };
}

export function normalizeTruecallerPhone(rawPhone) {
  return normalizePhone(rawPhone);
}

