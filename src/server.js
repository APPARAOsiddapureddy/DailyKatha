import 'dotenv/config';
import express from 'express';
import cors from 'cors';

import { errorHandler, getMetrics } from './middleware/errorHandler.js';
import { jwtAuth, internalKeyAuth } from './middleware/auth.js';
import { authLimiter, generalLimiter, internalLimiter } from './middleware/rateLimit.js';
import { languageMiddleware } from './middleware/language.js';
import { httpLogger } from './middleware/logger.js';
import { pool } from './db/pool.js';
import { redis } from './services/redis.js';

import authPublic from './routes/auth.js';
import feedRoutes from './routes/feed.js';
import cardsRoutes from './routes/cards.js';
import usersRoutes from './routes/users.js';
import internalRoutes from './routes/internal.js';

if (!process.env.JWT_SECRET) {
  console.error('FATAL: JWT_SECRET is required');
  process.exit(1);
}

const app = express();
app.use(cors());
app.use(express.json({ limit: '2mb' }));
app.use(httpLogger);

app.get('/health', async (_req, res) => {
  try {
    await pool.query('SELECT 1');
    await redis.ping();
    res.json({
      status: 'ok',
      db: 'connected',
      redis: 'connected',
      uptime: process.uptime(),
      timestamp: new Date().toISOString(),
    });
  } catch (err) {
    res.status(503).json({ status: 'error', error: err.message });
  }
});

app.get('/metrics', (req, res) => {
  res.json({
    errors: getMetrics(),
    uptime: process.uptime(),
    memory: process.memoryUsage(),
    timestamp: new Date().toISOString(),
  });
});

app.use('/v1/auth', authLimiter, authPublic);

app.use('/v1/internal', internalLimiter, internalKeyAuth, internalRoutes); // POST /v1/internal/generation-jobs

const authed = express.Router();
authed.use(generalLimiter);
authed.use(jwtAuth);
authed.use(languageMiddleware);
authed.use('/feed', feedRoutes);
authed.use('/cards', cardsRoutes);
authed.use('/users', usersRoutes);

app.use('/v1', authed);

app.use(errorHandler);

const port = parseInt(process.env.PORT || '3000', 10);
app.listen(port, () => {
  console.log(`Daily Katha API listening on :${port}`);
});
