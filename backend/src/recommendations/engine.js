import { pool } from '../db/pool.js';
import { scoreCard } from './scoring.js';
import { diversify } from './diversity.js';
import {
  buildRecommendationContext,
  expandCandidateCategories,
  moodAffinityForContext,
  applyContextualLead,
  applyLikedCategoryLead,
} from './context.js';
import { STORY_PACK_IDS } from '../constants/storyPacks.js';

export async function runRecommendationEngine({
  userId,
  interests,
  lang,
  section,
  limit,
  offset,
  timezone = 'Asia/Kolkata',
}) {
  const context = buildRecommendationContext({ timezone });

  const likedCatResult = await pool.query(
    `SELECT c.category, COUNT(*)::int AS n
     FROM interactions i
     INNER JOIN cards c ON c.id = i.card_id
     WHERE i.user_id = $1
       AND i.action = 'liked'
       AND i.created_at > NOW() - INTERVAL '120 days'
     GROUP BY c.category`,
    [userId],
  );
  /** @type {Record<string, number>} */
  const likedCategoryCounts = {};
  for (const row of likedCatResult.rows) {
    likedCategoryCounts[row.category] = Number(row.n);
  }
  const dominantLikedCategories = Object.entries(likedCategoryCounts)
    .sort((a, b) => b[1] - a[1])
    .map(([cat]) => cat);

  const maxCatLikes = Math.max(1, ...Object.values(likedCategoryCounts));
  /** @type {Record<string, number>} */
  const likedCategoryNorm = {};
  for (const [cat, n] of Object.entries(likedCategoryCounts)) {
    likedCategoryNorm[cat] = Math.min(1, n / maxCatLikes);
  }

  const candidateCategories = expandCandidateCategories(
    interests.length > 0 ? interests : STORY_PACK_IDS,
    context,
    dominantLikedCategories,
  );

  const interactionCount = await pool.query('SELECT COUNT(*) FROM interactions WHERE user_id = $1', [userId]);
  const isColdStart = parseInt(interactionCount.rows[0].count, 10) < 5;

  const skippedResult = await pool.query(
    `SELECT card_id FROM interactions
     WHERE user_id = $1 AND action = 'skipped'
     GROUP BY card_id HAVING COUNT(*) >= 2`,
    [userId],
  );
  const skippedIds = skippedResult.rows.map((r) => r.card_id);

  const viewedResult = await pool.query(`SELECT card_id FROM interactions WHERE user_id = $1 AND action = 'viewed'`, [userId]);
  const viewedIds = new Set(viewedResult.rows.map((r) => r.card_id));

  const sec = section ? `AND c.section = $${skippedIds.length > 0 ? 4 : 3}` : '';

  const params =
    skippedIds.length > 0
      ? section
        ? [userId, candidateCategories, skippedIds, section]
        : [userId, candidateCategories, skippedIds]
      : section
        ? [userId, candidateCategories, section]
        : [userId, candidateCategories];

  const candidateQuery = `
    SELECT c.*,
      COALESCE(trend.interaction_count, 0) as trend_score,
      COALESCE(collab.collab_score, 0) as collab_score
    FROM cards c
    LEFT JOIN (
      SELECT card_id, COUNT(*) as interaction_count
      FROM interactions
      WHERE action IN ('liked', 'shared', 'saved')
        AND created_at > NOW() - INTERVAL '7 days'
      GROUP BY card_id
    ) trend ON trend.card_id = c.id
    LEFT JOIN (
      SELECT i2.card_id, COUNT(*) as collab_score
      FROM interactions i1
      JOIN interactions i2 ON i1.user_id = i2.user_id
        AND i1.action IN ('liked', 'saved')
        AND i2.action IN ('liked', 'saved')
        AND i2.card_id != i1.card_id
      WHERE i1.user_id IN (
        SELECT DISTINCT ui2.user_id
        FROM user_interests ui1
        JOIN user_interests ui2 ON ui1.interest_id = ui2.interest_id
        WHERE ui1.user_id = $1 AND ui2.user_id != $1
        LIMIT 50
      )
      GROUP BY i2.card_id
    ) collab ON collab.card_id = c.id
    WHERE c.category = ANY($2::text[])
      AND c.is_active = true
      ${skippedIds.length > 0 ? 'AND c.id != ALL($3::uuid[])' : ''}
      ${sec}
    LIMIT 300
  `;

  const candidateResult = await pool.query(candidateQuery, params);
  const candidates = candidateResult.rows;
  if (candidates.length === 0) return { cards: [], total: 0, recommendationContext: context };

  const moodAffinity = moodAffinityForContext(context);

  const maxTrendScore = Math.max(...candidates.map((c) => Number(c.trend_score || 0)), 1);
  const maxCollabScore = Math.max(...candidates.map((c) => Number(c.collab_score || 0)), 1);

  const scored = candidates.map((card) => {
    const likedCategoryBoost = likedCategoryNorm[card.category] ?? 0;
    const score = scoreCard({
      card,
      interests,
      moodAffinity,
      isColdStart,
      isViewed: viewedIds.has(card.id),
      maxTrendScore,
      maxCollabScore,
      context,
      likedCategoryBoost,
    });
    return { ...card, _score: score };
  });

  scored.sort((a, b) => b._score - a._score);

  const diversified = diversify(scored, interests);
  let ordered = diversified;
  if (offset === 0) {
    ordered = applyContextualLead(diversified, context);
    ordered = applyLikedCategoryLead(ordered, dominantLikedCategories);
  }

  const total = ordered.length;
  const page = ordered.slice(offset, offset + limit);

  return { cards: page, total, recommendationContext: context };
}
