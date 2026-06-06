import { Router } from 'express';
import rateLimit from 'express-rate-limit';
import healthRoutes from './health.js';
import authPublic from './auth.js';
import usersRoutes from './users.js';
import feedRoutes from './feed.js';
import cardsRoutes from './cards.js';
import adminRoutes from './admin.js';
import { jwtAuth } from '../middleware/auth.js';
import { adminAuth } from '../middleware/adminAuth.js';
import { languageMiddleware } from '../middleware/language.js';
import apiV1Favorites from './api_v1/favorites.js';
import apiV1Quotes from './api_v1/quotes.js';

const router = Router();

const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 40,
  standardHeaders: true,
  legacyHeaders: false,
});

router.use(healthRoutes);
router.use('/v1/auth', authLimiter, authPublic);

const v1Authed = Router();
v1Authed.use(jwtAuth);
v1Authed.use(languageMiddleware);
v1Authed.use('/feed', feedRoutes);
v1Authed.use('/cards', cardsRoutes);
v1Authed.use('/users', usersRoutes);
v1Authed.use('/admin', adminAuth, adminRoutes);
router.use('/v1', v1Authed);

router.use('/api/v1', apiV1Quotes);
router.use('/api/v1', apiV1Favorites);

export default router;

