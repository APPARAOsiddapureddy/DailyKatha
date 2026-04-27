import Redis from 'ioredis';

let _redis;

export function getRedis() {
  if (_redis) return _redis;
  const url = process.env.REDIS_URL;
  if (!url) return null;
  _redis = new Redis(url, { maxRetriesPerRequest: null, enableReadyCheck: true });
  return _redis;
}

export async function cacheGet(key) {
  const r = getRedis();
  if (!r) return null;
  try {
    return await r.get(key);
  } catch (e) {
    console.warn('Redis get failed', e.message);
    return null;
  }
}

export async function cacheSet(key, value, ttlSec) {
  const r = getRedis();
  if (!r) return;
  try {
    if (ttlSec) await r.set(key, value, 'EX', ttlSec);
    else await r.set(key, value);
  } catch (e) {
    console.warn('Redis set failed', e.message);
  }
}

export async function invalidateUserFeed(userId) {
  const r = getRedis();
  if (!r) return;
  try {
    const stream = r.scanStream({ match: `feed:${userId}:*`, count: 100 });
    const keys = [];
    for await (const batch of stream) {
      keys.push(...batch);
    }
    if (keys.length) await r.del(...keys);
  } catch (e) {
    console.warn('Redis invalidate feed failed', e.message);
  }
}
