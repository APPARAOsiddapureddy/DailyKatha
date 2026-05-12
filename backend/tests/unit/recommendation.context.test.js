import {
  normalizeTimezone,
  inferTimeCategories,
  getActiveFestivals,
} from '../../src/recommendations/timeAndFestivals.js';
import {
  applyLikedCategoryLead,
  buildRecommendationContext,
  expandCandidateCategories,
  moodAffinityForContext,
} from '../../src/recommendations/context.js';
import { scoreCard } from '../../src/recommendations/scoring.js';

describe('normalizeTimezone', () => {
  test('defaults invalid tz', () => {
    expect(normalizeTimezone('Not/AZone')).toBe('Asia/Kolkata');
    expect(normalizeTimezone(null)).toBe('Asia/Kolkata');
  });

  test('accepts Asia/Kolkata', () => {
    expect(normalizeTimezone('Asia/Kolkata')).toBe('Asia/Kolkata');
  });
});

describe('inferTimeCategories', () => {
  test('morning → goodmorning', () => {
    expect(inferTimeCategories(8).primary).toBe('goodmorning');
  });

  test('night → goodnight', () => {
    expect(inferTimeCategories(22).primary).toBe('goodnight');
    expect(inferTimeCategories(2).primary).toBe('goodnight');
  });
});

describe('buildRecommendationContext', () => {
  test('includes localDate and slot', () => {
    const ctx = buildRecommendationContext({ timezone: 'Asia/Kolkata', now: new Date('2026-06-15T12:00:00Z') });
    expect(ctx.timezone).toBe('Asia/Kolkata');
    expect(ctx.localDate).toMatch(/^\d{4}-\d{2}-\d{2}$/);
    expect(['morning', 'afternoon', 'evening', 'night']).toContain(ctx.timeSlot);
  });
});

describe('expandCandidateCategories', () => {
  test('adds time + festival buckets', () => {
    const ctx = {
      primaryTimeCategory: 'goodmorning',
      secondaryTimeCategory: 'motivation',
      festivalBoostActive: true,
      festivalApproaching: false,
      timeSlot: 'morning',
    };
    const x = expandCandidateCategories(['cinema'], ctx);
    expect(x).toEqual(expect.arrayContaining(['cinema', 'goodmorning', 'motivation', 'festival']));
  });

  test('adds calm at night', () => {
    const ctx = {
      primaryTimeCategory: 'goodnight',
      secondaryTimeCategory: 'calm',
      festivalBoostActive: false,
      festivalApproaching: false,
      timeSlot: 'night',
    };
    const x = expandCandidateCategories(['love'], ctx);
    expect(x).toContain('calm');
  });

  test('adds historically liked sections into SQL candidate pool', () => {
    const ctx = {
      primaryTimeCategory: 'goodmorning',
      secondaryTimeCategory: null,
      festivalBoostActive: false,
      festivalApproaching: false,
      timeSlot: 'morning',
    };
    const x = expandCandidateCategories(['cinema'], ctx, ['heroes', 'motivation']);
    expect(x).toEqual(expect.arrayContaining(['cinema', 'heroes', 'motivation']));
  });
});

describe('applyLikedCategoryLead', () => {
  test('pulls first matching liked category to the front', () => {
    const cards = [
      { id: 'a', category: 'cinema' },
      { id: 'b', category: 'heroes' },
      { id: 'c', category: 'love' },
    ];
    const out = applyLikedCategoryLead(cards, ['heroes']);
    expect(out[0].category).toBe('heroes');
  });
});

describe('Republic Day active', () => {
  test('Jan 26 triggers festival list', () => {
    const iso = '2026-01-26';
    const active = getActiveFestivals(iso);
    expect(active.some((a) => a.id === 'republic_day')).toBe(true);
  });
});

describe('scoreCard with context', () => {
  const baseCard = {
    id: 'x',
    category: 'goodmorning',
    mood: 'warm',
    trend_score: 1,
    collab_score: 0,
    created_at: new Date().toISOString(),
    is_festival: false,
    festival: null,
  };

  test('boosts primary time category', () => {
    const ctx = {
      primaryTimeCategory: 'goodmorning',
      secondaryTimeCategory: 'motivation',
      festivalBoostActive: false,
      festivalApproaching: false,
      activeFestivals: [],
      upcomingFestivals: [],
      timeSlot: 'morning',
    };
    const s1 = scoreCard({
      card: baseCard,
      interests: ['cinema', 'love', 'bhakti'],
      moodAffinity: 'warm',
      isColdStart: false,
      isViewed: false,
      maxTrendScore: 1,
      maxCollabScore: 1,
      context: ctx,
    });
    const s0 = scoreCard({
      card: baseCard,
      interests: ['cinema', 'love', 'bhakti'],
      moodAffinity: 'warm',
      isColdStart: false,
      isViewed: false,
      maxTrendScore: 1,
      maxCollabScore: 1,
      context: null,
    });
    expect(s1).toBeGreaterThan(s0);
  });

  test('boosts normalized liked-category signal', () => {
    const sLow = scoreCard({
      card: { ...baseCard, category: 'cinema' },
      interests: ['love', 'bhakti'],
      moodAffinity: 'warm',
      isColdStart: false,
      isViewed: false,
      maxTrendScore: 1,
      maxCollabScore: 1,
      context: null,
      likedCategoryBoost: 0,
    });
    const sHi = scoreCard({
      card: { ...baseCard, category: 'cinema' },
      interests: ['love', 'bhakti'],
      moodAffinity: 'warm',
      isColdStart: false,
      isViewed: false,
      maxTrendScore: 1,
      maxCollabScore: 1,
      context: null,
      likedCategoryBoost: 1,
    });
    expect(sHi).toBeGreaterThan(sLow);
  });
});
