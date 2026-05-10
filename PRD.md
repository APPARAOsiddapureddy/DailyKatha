# Daily Katha — Product Requirements Document (PRD)

**Version:** 1.0  
**Date:** 24 April 2026  
**Status:** Draft for Flutter implementation  
**Source of truth:** Flutter client under `mobile/`; bundled card JSON in `mobile/assets/data/` (exported from `DailyKatha_*_Upload.xlsx` via `scripts/export_language_catalogs.py`). Legacy HTML/React prototypes were removed from this repo.

**See also:** [PRD-Quote-Generation-LLM.md](./PRD-Quote-Generation-LLM.md) — detailed spec for **interest-driven quote batches** and **Claude / LLM** JSON output (for content pipelines and prompt engineering).

---

## 1. Executive summary

**Daily Katha** (product name; UI copy uses “Dailykatha”) is a mobile app for multilingual daily greetings, devotional lines, festival wishes, and shareable “status” cards aimed at users in India who share content on WhatsApp and set wallpapers. The prototype emphasises warm Indian visual language (marigold, temple red, cream paper), Telugu-first bilingual chrome where appropriate, and a TikTok-style vertical feed of full-bleed cards.

**This PRD** translates every screen, data structure, and interaction from the reviewed files into requirements for a **Flutter** client and a **backend** that can replace in-memory mock data.

---

## 2. Goals and non-goals

### 2.1 Goals

- Ship a Flutter app that **matches the prototype’s information architecture, flows, and visual intent** (not necessarily pixel-perfect HTML/CSS).
- Support **six content locales**: Telugu (`te`), Hindi (`hi`), Tamil (`ta`), Kannada (`kn`), Malayalam (`ml`), English (`en`).
- Persist **auth**, **user preferences** (language, religion, interests), and **engagement** (likes, saves, shares) server-side where possible.
- Enable **discovery** (home sections, explore, search) and **full-screen feed** with like / share / save / wallpaper / edit actions (platform capabilities define what “share to WhatsApp status” means on device).

### 2.2 Non-goals (v1)

- Building the HTML prototype into production (Flutter is the target).
- Full CMS authoring UI for non-technical editors (backend can seed JSON or use admin tools later).
- Legal clearance for copyrighted cinema dialogue (product must respect rights; see §10).

---

## 3. Repository layout (Flutter production client)

| Path | Role |
|------|------|
| `mobile/lib/` | App source: routing, features, theme, models, services, bundled catalog loaders. |
| `mobile/assets/data/` | `*_cards.json` per content language (generated; do not hand-edit for bulk updates). |
| `DailyKatha_*_Upload.xlsx` | Authoring spreadsheets at repo root; re-run exporter after changes. |
| `scripts/export_language_catalogs.py` | XLSX → JSON for all six languages. |
| `PRD.md`, `PRD-Quote-Generation-LLM.md`, `Card-Storage-For-Recommendations.md` | Product and pipeline docs. |

---

## 4. Personas and UX principles

- **Primary persona:** Smartphone user comfortable with regional languages; shares morning wishes / festival posts / bhakti lines to family groups and status.
- **Principles:** Large touch targets, bilingual headings where Telugu is selected, minimal typing (OTP + chips), **one-handed** feed with right-side action rail, **9:16-ish** cards for status/wallpaper framing.

---

## 5. Information architecture and navigation

### 5.1 Screen flow (auth and onboarding)

1. **Splash** (~2.4s): Brand, diya, tagline “A story worth sharing, every day.”
2. **Login:** India `+91` phone, 10 digits, valid leading digit `6–9`, primary CTA “Send OTP”.
3. **OTP:** 6 boxes, resend countdown (30s), back to login; prototype allows any 6 digits for demo — **production must verify OTP via backend**.
4. **Language (step 1/3):** Grid of `LANGUAGES`; **entire screen English** until selection confirmed (per prototype comment).
5. **Religion (step 2/3):** List from `RELIGIONS`; optional **Skip**; if Telugu UI language, show Telugu labels with English.
6. **Interests (step 3/3):** Up to **3** selections from `INTERESTS`; CTA “Finish · Start reading”.

### 5.2 Post-onboarding: main shell

- **Bottom tabs:** `home` | `explore` | `profile` (labels: Home, Explore, You).
- **Home:** Sticky header (logo “Dailykatha”, search shortcut → explore tab, notifications bell with dot).
- **Overlay / full-screen:** **Feed** (vertical snap, one card per viewport) opened from “View all”, section cards, explore intents, profile grid taps. Feed **hides bottom tabs**; dark chrome; back returns to home stack.

### 5.3 Home content blocks (in order)

1. **Greeting hero** — Time-based greeting (morning / afternoon / evening / night) + optional Telugu line + profile avatar button.
2. **Festival banner** — “Today’s Festival” (prototype: Ugadi), CTA “Open pack”.
3. **Sections** (each horizontal rail + “View all”):  
   - Morning / good morning  
   - Festival specials  
   - For you (interests + bhakti/motivation/love)  
   - Trending  
   - Entertainment (cinema / heroes / friendship)

### 5.4 Explore

- Search bar (placeholder bilingual “Search · వెతకండి…”).
- **Jump in** horizontal chips: Good Morning, Love, Motivation, Devotional, Festivals, Good Night.
- **Trending** mini-cards rail + “See all”.
- **Categories** 2-column grid with gradient tiles and counts (mock).
- **Popular searches** as hashtag pills.
- **Upcoming occasions** list (Ugadi, Sri Rama Navami, Hanuman Jayanti in mock).

### 5.5 Profile

- Header gradient: avatar initial, display name + Telugu name when `lang === te`, phone, join date, preference chips.
- Stats: Liked / Saved / Shared counts.
- Segments: **Liked | Saved | Shared** (shared empty state explains WhatsApp sharing).
- Settings rows: Language, Interests, Downloads, Notifications, Help, Sign out.
- Footer: version / “Made with love · Hyderabad” (update branding to Daily Katha consistently).

### 5.6 Feed screen

- Full-screen scroll-snap vertical list of **status cards**.
- Floating header: back, index `n / total`, hint “Scroll / Swipe up”.
- **Action rail** (per card): Like, Status (share), Wallpaper, Save, Edit.
- Page dots at bottom.

---

## 6. Visual and motion design (Flutter mapping)

### 6.1 Colours (`MAVIO` token names → use in `ThemeData` / constants)

- Cream `#FBF4E6`, creamDeep `#F2E7CE`, ink `#1F1410`, inkSoft `#5A3E2A`, inkMute `#8A6F56`
- Marigold `#E8761E`, marigoldDeep `#B94E11`, marigoldLight `#F4A547`
- Kumkum `#B3261E`, kumkumDeep `#7A1410`
- Gold `#D4A12A`, goldLight `#F5D06B`, peacock `#0F6E5E`, indigo `#2A2566`
- Lines: `rgba(31,20,16,0.12)` / `0.22`, white `#FFFCF3`

### 6.2 Typography

- **Latin headings / UI:** Serif display (Fraunces equivalent), **UI sans:** Inter.  
- **Telugu (and other Indic scripts):** Noto Serif Telugu or per-locale Noto serif as appropriate.

### 6.3 Status card

- Rounded rect (~28dp), double frame (solid inner + dashed outer), paisley corners, optional festival pill label, **hero script** = user’s primary quote language (prototype hard-codes Telugu hero + English echo — **PRD:** hero = selected app `contentLanguage`, secondary line = English or user-chosen second language).
- Background: gradient from `getCardBg(mood)` mapping: `warm | devotional | bold | festive | calm | romantic | cool`.
- Bottom watermark: “DAILYKATHA”.

### 6.4 Motion

- Screen enter fade-up (~360ms), CTA press scale, like heart burst, splash gold sweep, diya flame subtle loop.

---

## 7. Data model (domain)

### 7.1 Enumerations

- **Language ID:** `te` | `hi` | `ta` | `kn` | `ml` | `en` (UI + content).
- **Religion ID:** `hindu` | `muslim` | `christian` | `sikh` | `spiritual` | `none` (or null if skipped).
- **Interest ID:** matches `MockCatalog.interests` in `mobile/lib/data/local/mock_catalog.dart` (`goodmorning`, `goodnight`, `love`, `bhakti`, `motivation`, `festival`, `family`, `cinema`, `heroes`, `poetry`, `friendship`, `birthday`).
- **Card section (feed grouping):** `morning` | `trending` | `festival` | `interests` | `evening` (extend as needed).
- **Category ID:** aligns with interests + `all` for filters.
- **Mood:** `warm` | `devotional` | `bold` | `festive` | `calm` | `romantic` | `cool` — drives gradients.

### 7.2 Content card (canonical JSON shape)

```json
{
  "id": "uuid-or-int",
  "section": "trending",
  "category": "bhakti",
  "mood": "devotional",
  "isFestival": false,
  "festival": "Ugadi",
  "quote": { "te": "…", "hi": "…", "ta": "…", "kn": "…", "ml": "…", "en": "…" },
  "author": { "te": "…", "hi": "…", "ta": "…", "kn": "…", "ml": "…", "en": "…" }
}
```

Server returns only needed locales if bandwidth is a concern; client falls back to `en` per prototype `cardQuote` / `cardAuthor`.

### 7.3 User profile (server)

- `userId`, `phoneE164`, `displayName`, optional `displayNameNative`
- `uiLanguage` (for chrome; prototype gates Telugu bilingual on `te`)
- `contentLanguage` (primary quote language)
- `religionId` | null
- `interestIds` (max 3)
- `createdAt`, `updatedAt`
- Optional: `avatarUrl`

### 7.4 Engagement

- **Like:** `userId`, `cardId`, `createdAt` (unique per user+card).
- **Save:** same pattern.
- **Share event:** `userId`, `cardId`, `channel` (e.g. `whatsapp_status`), `createdAt` (for analytics and profile “Shared” tab).
- **Download / wallpaper apply:** log for support analytics (optional in v1).

### 7.5 Notifications (in-app list)

Mirror structure in `NOTIFICATIONS`: `id`, `type`, `icon` key or enum, `timeAgo` **or** server `createdAt` with client-relative formatting, localized `title` / `body` maps.

### 7.6 Explore / taxonomy

- **Category tiles:** id, gradient mood, emoji, localized title, **count** from server (cached).
- **Trending tags:** server-provided strings or computed from search logs.

### 7.7 Occasions / festival calendar

- Entities: `Occasion` with `slug`, date rules or fixed dates, localized names, link to content packs.

---

## 8. Functional requirements (numbered)

**FR-1** Phone login: validate format; request OTP from backend; rate-limit per device/IP as implemented server-side.  
**FR-2** OTP: verify code; issue **session tokens** (short access + refresh JWT or opaque refresh cookie).  
**FR-3** Onboarding: persist language, religion (nullable), interests (1–3) to user profile before entering home.  
**FR-4** Home: load section rails from API (paged); tap opens feed at selected index.  
**FR-5** Feed: vertical paging; prefetch next card assets; sync like state optimistically.  
**FR-6** Share: use platform share sheet; deep link or image file as required for WhatsApp status (typically **image export** of card).  
**FR-7** Save / download: render card to a high-DPI 9:16 PNG (e.g. ~1440×2560 from 360×640 logical at 4× export scale); save to gallery with permission handling (Android/iOS).  
**FR-8** Wallpaper: OS-specific “set wallpaper” where supported or guide user from saved image.  
**FR-9** Edit: v1 can open simple text overlay editor or defer to v2 (prototype stub).  
**FR-10** Explore: search queries hit `/search?q=`; intents map to category filters.  
**FR-11** Profile: stats and grids from user engagement APIs; settings navigate to sub-screens.  
**FR-12** Notifications: list from `/notifications`; mark read.  
**FR-13** i18n: all chrome strings externalized (ARB in Flutter); content strings from API.

---

## 9. Backend specification

### 9.1 Recommended stack (flexible)

- **API:** REST + JSON (or GraphQL if preferred); **OpenAPI** document recommended.
- **Auth:** OTP via SMS provider (e.g. Twilio / MSG91 / AWS SNS); store hashed refresh tokens; optional device binding.
- **DB:** PostgreSQL (relational data + JSONB for flexible localized fields).
- **Media:** Object storage (S3/GCS) for pre-rendered wallpapers optional; v1 can render client-side.
- **Cache:** Redis for session, rate limits, trending lists.
- **Admin:** Seed `FEED_CARDS`-equivalent content via migration or CSV import.

### 9.2 Core REST endpoints (draft)

| Method | Path | Description |
|--------|------|-------------|
| POST | `/v1/auth/otp/send` | Body: `{ "phone": "+919876543210" }` → sends OTP, returns `requestId`. |
| POST | `/v1/auth/otp/verify` | Body: `{ "requestId", "code" }` → returns `{ accessToken, refreshToken, user }`. |
| POST | `/v1/auth/refresh` | Refresh access token. |
| GET | `/v1/me` | Current user profile + preferences. |
| PATCH | `/v1/me` | Update name, languages, religion, interests. |
| GET | `/v1/cards` | Query: `section`, `category`, `cursor`, `limit`, `lang` — paged cards. |
| GET | `/v1/cards/{id}` | Single card. |
| GET | `/v1/home` | Server-composed rails for the user (personalisation). |
| GET | `/v1/explore` | Categories, trending tags, occasions snapshot. |
| GET | `/v1/search` | `q`, `lang`, cursor pagination. |
| POST | `/v1/cards/{id}/like` | Toggle or idempotent like. |
| DELETE | `/v1/cards/{id}/like` | Unlike if not toggle. |
| POST | `/v1/cards/{id}/save` | Save. |
| DELETE | `/v1/cards/{id}/save` | Unsave. |
| POST | `/v1/cards/{id}/share` | Body: `{ "channel": "whatsapp_status" }` — analytics. |
| GET | `/v1/me/likes`, `/v1/me/saves`, `/v1/me/shares` | For profile tabs with pagination. |
| GET | `/v1/notifications` | List; `PATCH /v1/notifications/{id}/read` optional. |

### 9.3 Database tables (minimal)

- `users`, `user_sessions`, `otp_requests`
- `cards` (columns or JSONB for `quote`, `author`, enums for section/category/mood)
- `user_likes`, `user_saves`, `user_shares`
- `notifications`
- `occasions`, `search_queries` (analytics, optional)

### 9.4 Personalisation rules (v1)

- Home **“For you”** rail: filter cards by user’s `interestIds` and `religionId` (e.g. filter out mismatched devotional content when religion-specific; `none` shows all).
- **Festival rail:** driven by `occasions` active for “today” in user’s timezone (default `Asia/Kolkata`).
- **Trending:** precomputed job every N minutes from shares + likes.

### 9.5 Security and compliance

- Store phone numbers normalized E.164; encrypt PII at rest if required by policy.
- GDPR-style deletion endpoint (future) — design `users.deleted_at`.
- Content moderation pipeline for UGC if **Edit** allows user text (v2).

---

## 10. Content and legal

- Seed quotes similar to prototype tone; **cinema category** must use licensed lines or original pastiches to avoid IP issues.
- Festival names and religious content: factual, respectful; allow user **Skip** for religion.

---

## 11. Analytics (recommended events)

`app_open`, `onboarding_complete`, `card_impression`, `card_like`, `card_share`, `card_save`, `feed_session_duration`, `search_submit`, `notification_open`.

---

## 12. Technical debt in prototype (fix in Flutter / server)

- `StatusCard` references `card.te`, `card.quoteTe`, `card.author` as flat fields; canonical model is nested `quote` / `author` per language — **Flutter models should use nested maps** and resolve display language in one place.
- Feed header still says “MAVIO” in places — unify to **Daily Katha**.
- `LanguageScreen` calls `onNext(sel)` but parent in HTML does not pass `setLang` from that screen — **Flutter must wire selected language into app state**.
- `ReligionScreen` / `InterestsScreen` receive `lang` in prototype but HTML flow does not pass `lang` until after language — ensure **Religion** receives effective UI language.

---

## 13. Milestones (suggested order after this PRD)

1. Flutter monorepo + design tokens + typography + empty navigation shell.  
2. Onboarding + auth screens wired to **staging** OTP API.  
3. Home + rails from `/v1/home`; card widget parity with `StatusCard`.  
4. Feed pager + action rail + like/save/share integrations.  
5. Explore + search.  
6. Profile + settings + sign out.  
7. Notifications; festival calendar; polish and store listing.

---

## 14. Acceptance criteria (v1 “done”)

- User can complete phone OTP, pick language/religion/interests, see personalised home, open feed, like and save cards, export/share at least one card as image, and see counts on profile.  
- All six languages display correct script for quotes when API provides them.  
- Backend documents above endpoints with stable schemas and error codes.

---

*End of PRD — derived from full review of all files in `/Users/siva/DailyKatha`.*
