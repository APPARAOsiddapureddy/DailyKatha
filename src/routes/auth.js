import { Router } from 'express';
import { HttpError } from '../middleware/errorHandler.js';
import { query } from '../db/pool.js';
import { signUserToken } from '../services/jwt.js';
import { storeOtp, verifyOtp } from '../services/otp.js';

const router = Router();

function normalizePhone(raw) {
  const d = String(raw || '').replace(/\D/g, '');
  if (d.length === 12 && d.startsWith('91')) return d.slice(2);
  if (d.length === 13 && d.startsWith('091')) return d.slice(3);
  if (d.length === 10) return d;
  return null;
}

router.post('/send-otp', async (req, res, next) => {
  try {
    const phone = normalizePhone(req.body?.phone);
    if (!phone) throw new HttpError(400, 'INVALID_PHONE', 'Provide a valid 10-digit Indian mobile');
    const code = await storeOtp(phone);
    if (process.env.NODE_ENV !== 'production' || process.env.OTP_LOG_IN_PROD === 'true') {
      console.info(`[mock-otp] ${phone} -> ${code}`);
    }
    res.json({ ok: true, requestId: phone, message: 'OTP sent (mock in dev: check server logs if Redis unavailable)' });
  } catch (e) {
    next(e);
  }
});

router.post('/verify-otp', async (req, res, next) => {
  try {
    const phone = normalizePhone(req.body?.phone || req.body?.requestId);
    const code = String(req.body?.code ?? req.body?.otp ?? '').replace(/\D/g, '');
    if (!phone || code.length !== 6) throw new HttpError(400, 'INVALID_INPUT', 'phone and 6-digit code required');

    const ok = await verifyOtp(phone, code);
    if (!ok) throw new HttpError(400, 'INVALID_OTP', 'Incorrect or expired OTP');

    const { rows } = await query(
      `INSERT INTO users (phone, name) VALUES ($1, $2)
       ON CONFLICT (phone) DO UPDATE SET updated_at = NOW()
       RETURNING *`,
      [phone, `User ${phone.slice(-4)}`],
    );
    const user = rows[0];
    const token = signUserToken(user.id);
    res.json({
      token,
      user: {
        id: user.id,
        phone: user.phone,
        name: user.name,
        content_language: user.content_language || 'te',
        religion_id: user.religion_id,
        region: user.region || 'IN',
        interests: [],
        created_at: user.created_at,
      },
    });
  } catch (e) {
    next(e);
  }
});

export default router;
