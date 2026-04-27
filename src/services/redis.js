import Redis from 'ioredis';

export const redis = new Redis(process.env.REDIS_URL, {
  // Don't crash the whole API when Redis is temporarily unavailable.
  maxRetriesPerRequest: null,
  retryStrategy: (times) => Math.min(times * 100, 3000),
  enableReadyCheck: false,
});

redis.on('error', (err) => {
  console.error('Redis error:', err.message);
});

async function delByPattern(pattern) {
  const stream = redis.scanStream({ match: pattern, count: 250 });
  const keys = [];
  for await (const batch of stream) keys.push(...batch);
  if (keys.length) await redis.del(...keys);
  return keys.length;
}

export async function invalidateUserFeedCache(userId) {
  const patterns = [`feed:${userId}:*`, `explore:${userId}:*`];
  for (const p of patterns) {
    try {
      await delByPattern(p);
    } catch (e) {
      console.warn('Redis invalidate failed', p, e.message);
    }
  }
}

export async function invalidateAllFeedCaches() {
  const patterns = ['feed:*', 'explore:*'];
  for (const p of patterns) {
    try {
      await delByPattern(p);
    } catch (e) {
      console.warn('Redis invalidate failed', p, e.message);
    }
  }
}

