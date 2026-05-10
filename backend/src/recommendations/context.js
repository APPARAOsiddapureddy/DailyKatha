import {
  normalizeTimezone,
  getWallClock,
  inferTimeCategories,
  getActiveFestivals,
  getUpcomingFestivals,
} from './timeAndFestivals.js';

/**
 * Full recommendation context for scoring + API responses.
 */
export function buildRecommendationContext({ now = new Date(), timezone = 'Asia/Kolkata' } = {}) {
  const tz = normalizeTimezone(timezone);
  const wall = getWallClock(tz, now);
  const { timeSlot, primary, secondary } = inferTimeCategories(wall.hour);
  const activeFestivals = getActiveFestivals(wall.isoDate);
  const upcomingFestivals = getUpcomingFestivals(wall.isoDate, 14);

  const festivalBoostActive = activeFestivals.length > 0;
  const festivalApproaching = upcomingFestivals.some((f) => f.daysUntil <= 7 && f.daysUntil > 0);

  return {
    timezone: tz,
    localDate: wall.isoDate,
    localHour: wall.hour,
    localMinute: wall.minute,
    timeSlot,
    primaryTimeCategory: primary,
    secondaryTimeCategory: secondary,
    activeFestivals,
    upcomingFestivals,
    festivalBoostActive,
    festivalApproaching,
  };
}

/**
 * Broaden SQL candidate categories so time-of-day & festival cards can surface
 * even if the user did not explicitly pick that interest (still ranked by score).
 */
export function expandCandidateCategories(interests, context) {
  const set = new Set(Array.isArray(interests) ? [...interests] : []);
  if (context.primaryTimeCategory) set.add(context.primaryTimeCategory);
  if (context.secondaryTimeCategory) set.add(context.secondaryTimeCategory);
  if (context.festivalBoostActive || context.festivalApproaching) set.add('festival');
  if (context.timeSlot === 'night') set.add('calm');
  return [...set];
}

/**
 * Mood label on cards — align slot to legacy scoring hooks.
 */
export function moodAffinityForContext(context) {
  const map = {
    morning: 'warm',
    afternoon: 'bold',
    evening: 'calm',
    night: 'calm',
  };
  return map[context.timeSlot] || 'warm';
}

/**
 * Move best contextual card to the front of the first page (does not change total ordering deeply).
 */
export function applyContextualLead(cards, context) {
  if (!cards?.length) return cards;
  const out = [...cards];

  if (context.festivalBoostActive) {
    const fi = out.findIndex((c) => c.category === 'festival' || c.is_festival);
    if (fi > 0) {
      const [x] = out.splice(fi, 1);
      out.unshift(x);
    }
    return out;
  }

  const lead = context.primaryTimeCategory;
  if (!lead) return out;

  const ti = out.findIndex(
    (c) =>
      c.category === lead ||
      (lead === 'goodnight' && (c.category === 'calm' || c.category === 'goodnight')),
  );
  if (ti > 0) {
    const [x] = out.splice(ti, 1);
    out.unshift(x);
  }
  return out;
}
