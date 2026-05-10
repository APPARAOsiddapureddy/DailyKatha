/**
 * @param {object} params
 * @param {object} [params.context] - from buildRecommendationContext
 */
export function scoreCard({
  card,
  interests,
  moodAffinity,
  isColdStart,
  isViewed,
  maxTrendScore,
  maxCollabScore,
  context,
}) {
  let score = 0;

  const primaryInterest = interests[0];
  const secondaryInterest = interests[1];
  const tertiaryInterest = interests[2];

  if (card.category === primaryInterest) score += 0.35;
  else if (card.category === secondaryInterest) score += 0.2;
  else if (card.category === tertiaryInterest) score += 0.1;

  if (card.mood === moodAffinity) score += 0.15;

  if (context) {
    if (context.primaryTimeCategory) {
      if (card.category === context.primaryTimeCategory) score += 0.28;
      else if (
        context.primaryTimeCategory === 'goodnight' &&
        (card.category === 'calm' || card.category === 'goodnight')
      ) {
        score += 0.24;
      }
    }
    if (context.secondaryTimeCategory && card.category === context.secondaryTimeCategory) {
      score += 0.12;
    }

    if (context.festivalBoostActive && (card.category === 'festival' || card.is_festival)) {
      score += 0.34;
    } else if (
      context.festivalApproaching &&
      !context.festivalBoostActive &&
      (card.category === 'festival' || card.is_festival)
    ) {
      score += 0.16;
    }

    if (context.festivalBoostActive && festivalTagMatches(card, context.activeFestivals)) {
      score += 0.14;
    }

    if (context.festivalApproaching && festivalTagMatches(card, context.upcomingFestivals)) {
      score += 0.06;
    }
  }

  if (isColdStart) {
    score *= 0.5;
    score += (Number(card.trend_score || 0) / maxTrendScore) * 0.3;
    score += freshnessScore(card.created_at) * 0.2;
  } else {
    score += (Number(card.trend_score || 0) / maxTrendScore) * 0.15;
    score += (Number(card.collab_score || 0) / maxCollabScore) * 0.1;
    score += freshnessScore(card.created_at) * 0.05;
  }

  if (isViewed) score -= 0.5;

  return Math.max(0, score);
}

function festivalTagMatches(card, festivalList) {
  if (!festivalList?.length) return false;
  const raw = card.festival;
  const blob =
    typeof raw === 'string'
      ? raw.toLowerCase()
      : JSON.stringify(raw ?? {})
          .toLowerCase();
  if (!blob) return false;
  return festivalList.some((f) => (f.tags || []).some((t) => blob.includes(String(t).toLowerCase())));
}

function freshnessScore(createdAt) {
  const ageMs = Date.now() - new Date(createdAt).getTime();
  const ageDays = ageMs / (1000 * 60 * 60 * 24);
  return Math.max(0, 1 - ageDays / 30);
}
