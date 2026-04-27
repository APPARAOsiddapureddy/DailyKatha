import { Router } from 'express';
import { HttpError } from '../middleware/errorHandler.js';
import { query } from '../db/pool.js';
import { mapCardRow } from '../utils/cardMapper.js';
import { invalidateUserFeedCache } from '../services/redis.js';
import { getUserInterests, setUserInterests } from '../db/queries/userInterests.js';
import { feedRefreshLimiter } from '../middleware/rateLimit.js';

const router = Router();

router.get('/me', async (req, res, next) => {
  try {
    const u = req.user;
    const { rows: interests } = await query(`SELECT interest_id, rank FROM user_interests WHERE user_id = $1 ORDER BY rank`, [
      u.id,
    ]);
    res.json({
      id: u.id,
      phone: u.phone,
      name: u.name,
      contentLanguage: u.content_language,
      religionId: u.religion_id,
      region: u.region,
      timezone: u.timezone,
      interests: interests.map((r) => ({ interestId: r.interest_id, rank: r.rank })),
    });
  } catch (e) {
    next(e);
  }
});

router.put('/me', async (req, res, next) => {
  try {
    const { name, contentLanguage, religionId, region, timezone } = req.body || {};
    const { rows } = await query(
      `UPDATE users SET
         name = COALESCE($1, name),
         content_language = COALESCE($2, content_language),
         religion_id = COALESCE($3, religion_id),
         region = COALESCE($4, region),
         timezone = COALESCE($5, timezone),
         updated_at = NOW()
       WHERE id = $6
       RETURNING *`,
      [name ?? null, contentLanguage ?? null, religionId ?? null, region ?? null, timezone ?? null, req.user.id],
    );
    await invalidateUserFeedCache(req.user.id);
    res.json({ user: rows[0] });
  } catch (e) {
    next(e);
  }
});

router.put('/me/interests', async (req, res, next) => {
  try {
    const list = req.body?.interests;
    if (!Array.isArray(list) || list.length < 1 || list.length > 3) {
      throw new HttpError(400, 'INVALID_INTERESTS', 'Provide 1–3 interests');
    }
    const ids = [];
    for (const item of list) {
      const id = typeof item === 'string' ? item : item?.interest_id || item?.interestId;
      if (!id) throw new HttpError(400, 'INVALID_INTERESTS', 'Each interest needs interest_id');
      ids.push(String(id));
    }
    await setUserInterests(req.user.id, ids);
    await invalidateUserFeedCache(req.user.id);
    const ordered = await getUserInterests(req.user.id);
    res.json({ interests: ordered });
  } catch (e) {
    next(e);
  }
});

router.post('/me/refresh-feed', feedRefreshLimiter, async (req, res, next) => {
  try {
    await invalidateUserFeedCache(req.user.id);
    res.json({ ok: true });
  } catch (e) {
    next(e);
  }
});

async function paginatedCards(req, action) {
  const page = Math.max(1, parseInt(req.query.page, 10) || 1);
  const limit = Math.min(50, Math.max(1, parseInt(req.query.limit, 10) || 20));
  const offset = (page - 1) * limit;
  const { rows } = await query(
    `SELECT c.* FROM cards c
     INNER JOIN interactions i ON i.card_id = c.id AND i.user_id = $1 AND i.action = $4
     ORDER BY i.created_at DESC
     LIMIT $2 OFFSET $3`,
    [req.user.id, limit, offset, action],
  );
  const { rows: c2 } = await query(
    `SELECT COUNT(*)::int AS n FROM interactions WHERE user_id = $1 AND action = $2`,
    [req.user.id, action],
  );
  const lang = req.lang;
  return { cards: rows.map((r) => mapCardRow(r, lang)), nextPage: rows.length === limit ? page + 1 : null, total: c2[0].n };
}

router.get('/me/liked', async (req, res, next) => {
  try {
    res.json(await paginatedCards(req, 'liked'));
  } catch (e) {
    next(e);
  }
});

router.get('/me/saved', async (req, res, next) => {
  try {
    res.json(await paginatedCards(req, 'saved'));
  } catch (e) {
    next(e);
  }
});

router.get('/me/history', async (req, res, next) => {
  try {
    res.json(await paginatedCards(req, 'viewed'));
  } catch (e) {
    next(e);
  }
});

export default router;
