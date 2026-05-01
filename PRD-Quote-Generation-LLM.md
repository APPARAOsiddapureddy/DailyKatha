# Daily Katha — PRD: Interest-Driven Quote Generation (Claude / LLM)

**Document:** Content & generation pipeline  
**Version:** 1.0  
**Date:** 24 April 2026  
**Status:** Draft — for product, backend, and prompt engineering  
**Companion:** [PRD.md](./PRD.md) (app UX, Flutter, REST shell)

---

## 1. Purpose

This PRD defines **how Daily Katha produces and refreshes shareable quote cards** aligned with each user’s **interests**, **language**, **religion (optional)**, and **context** (time of day, festivals). It is written so you can:

- Hand **§10–12** to **Claude** (or any LLM) as the authoritative spec for **batch quote generation**.  
- Implement **§7–9** as backend APIs, jobs, and storage.  
- Validate output using **§13** acceptance criteria.

**Scope:** Text generation for the `quote` / `author` fields across six locales (`te`, `hi`, `ta`, `kn`, `ml`, `en`), plus metadata (`category`, `mood`, `section`). **Out of scope for this doc:** image rendering, push notifications, payment.

---

## 2. Problem statement

Users select **up to three interests** during onboarding (e.g. `goodmorning`, `bhakti`, `festival`). The app’s “For you” rail and feed must surface **fresh, safe, culturally appropriate** lines that:

- Match **interest semantics** (not generic motivational spam).  
- Respect **religion** when set (e.g. avoid mixing incompatible devotional idioms).  
- Are **short** and **line-broken** for WhatsApp status (2–4 short lines per language).  
- Exist in **all six languages** on the card (hero = user `contentLanguage`, others for sharing / bilingual cards).

Manual CMS does not scale; **LLM-assisted generation** with strict **schema**, **guardrails**, and optional **human review** is the intended path.

---

## 3. Definitions

| Term | Meaning |
|------|--------|
| **Card** | One shareable unit: `quote` + `author` maps, `category`, `mood`, `section`, optional `isFestival` / `festival`. |
| **Interest ID** | One of: `goodmorning`, `goodnight`, `love`, `bhakti`, `motivation`, `festival`, `family`, `cinema`, `heroes`, `poetry`, `friendship`, `birthday` (aligned with app catalog). |
| **Religion ID** | `hindu`, `muslim`, `christian`, `sikh`, `spiritual`, `none`, or omitted / null = no filter. |
| **Content language** | User’s primary script locale: `te` \| `hi` \| `ta` \| `kn` \| `ml` \| `en`. |
| **Generation job** | Server-side request that asks the LLM for **N cards** with explicit inputs and returns **JSON** only. |

---

## 4. Inputs to the generator (required context)

Every generation call **must** receive a structured payload (JSON). Minimum fields:

```json
{
  "jobId": "uuid",
  "userId": "optional-for-logging",
  "contentLanguage": "te",
  "interestIds": ["goodmorning", "bhakti"],
  "religionId": "hindu",
  "region": "IN",
  "timezone": "Asia/Kolkata",
  "localDate": "2026-04-24",
  "occasions": [
    { "slug": "ugadi", "weight": 1.0 }
  ],
  "constraints": {
    "cardsRequested": 10,
    "maxCharsPerQuoteLine": 42,
    "maxQuoteLines": 4,
    "forbidCopyrightFilmQuotes": true,
    "forbidRealPoliticianNames": true,
    "forbidMedicalClaims": true
  }
}
```

### 4.1 Field semantics

| Field | Required | Notes |
|--------|----------|--------|
| `contentLanguage` | Yes | Hero language; LLM must ensure this string is **natural** and **script-correct**. |
| `interestIds` | Yes | 1–3 values; generation should **cover each** across the batch (see §6). |
| `religionId` | No | Tunes devotional/festival wording; `none` / omit → neutral ecumenical spiritual tone only where needed. |
| `localDate` + `timezone` | Yes | Morning vs good-night, festival proximity. |
| `occasions` | No | If present, **at least 20%** of batch (rounded up) should be festival-aware when `festival` ∈ `interestIds` or global festival pack is enabled. |
| `constraints` | Yes | Hard limits for token control and policy flags. |

---

## 5. Output schema (LLM must return this)

The model must return **only** a JSON object (no markdown fences in production parser; fences allowed in dev if stripped). Root shape:

```json
{
  "jobId": "uuid-matching-request",
  "model": "claude-3-5-sonnet-20241022",
  "generatedAt": "2026-04-24T10:15:00+05:30",
  "cards": [
    {
      "clientTempId": "string-uuid",
      "section": "interests",
      "category": "bhakti",
      "mood": "devotional",
      "isFestival": false,
      "festival": null,
      "quote": {
        "te": "…",
        "hi": "…",
        "ta": "…",
        "kn": "…",
        "ml": "…",
        "en": "…"
      },
      "author": {
        "te": "— …",
        "hi": "— …",
        "ta": "— …",
        "kn": "— …",
        "ml": "— …",
        "en": "— …"
      }
    }
  ]
}
```

### 5.1 Validation rules (hard)

1. **`cards` length** = `constraints.cardsRequested` unless the job explicitly requests fewer; if the model cannot comply, return **`error` object** (see §5.3) instead of partial silent failure.  
2. **Keys:** Every card **must** include all six language keys in `quote` and `author` (non-empty strings).  
3. **`quote` format:** Use `\n` for line breaks (2–4 lines per language). No hashtags unless `category` is explore-style tag experiment (default **no hashtags**).  
4. **`author` format:** Short attribution (e.g. `— traditional`, `— festival greeting`, `— reflection`); **not** a second long poem. Max **80 characters** per language in `author`.  
5. **`mood`** must be one of: `warm`, `devotional`, `bold`, `festive`, `calm`, `romantic`, `cool`.  
6. **`section`** must be one of: `morning`, `trending`, `festival`, `interests`, `evening`.  
7. **`category`** must equal one of the **interest IDs** or a strict allow-list extension documented in OpenAPI (avoid free-text categories).  
8. **Encoding:** UTF-8; no HTML; no emoji inside `quote`/`author` unless `category === "birthday"` or `festival` (optional **one** emoji max in `quote` for festive only — default **none**).

### 5.2 Soft quality targets

- **Telugu (and each Indic script):** idiomatic, not English calqued word-for-word unless `en` is the only natural line.  
- **English:** natural, not preachy; may serve as “echo” line for bilingual cards.  
- **Semantic distance:** within one batch, **Jaccard-like** bigram overlap between any two cards’ `quote[contentLanguage]` should be low (implement server-side reject/regenerate if similarity > threshold).

### 5.3 Error object (when refusing)

```json
{
  "jobId": "uuid",
  "error": {
    "code": "POLICY_REFUSAL",
    "message": "human-readable",
    "retryable": false
  }
}
```

---

## 6. Distribution rules across interests

For a batch of size `N` with interest set `I = {i1, i2, i3}`:

1. **Partition:** Each interest should receive **at least ⌊N / |I|⌋** cards; distribute remainder one-by-one in order of `interestIds` array.  
2. **Religion:** If `religionId` is set, **bhakti** / **festival** / **goodmorning** / **goodnight** cards must not contradict that path (e.g. Islamic `bhakti` → use culturally appropriate dhikr / values language, not Hindu deity names unless user religion is `hindu` or `spiritual` / `none`).  
3. **`cinema` / `heroes`:** **Original** inspirational lines in *film style* — **never** copy real movie dialogues (see §11).  
4. **`love` / `family` / `friendship`:** inclusive, non-explicit, no stalking / control themes.  
5. **`motivation`:** no guaranteed-income / miracle claims.

---

## 7. System & user prompts (for Claude)

### 7.1 System prompt (stable)

Use a **system** message that includes:

- Role: “You are a content generator for Daily Katha, a multilingual Indian greetings app.”  
- Output: “Return **only** valid JSON matching the schema in the user message. No markdown.”  
- Safety: list §11 prohibitions explicitly.  
- Languages: “Produce fluent text in Telugu, Hindi, Tamil, Kannada, Malayalam, and English scripts as appropriate.”  
- Style: “Short lines for mobile status; warm respectful tone.”

### 7.2 User prompt (per job)

Must include:

1. The **input JSON** from §4 verbatim.  
2. The **output schema** summary (reference §5).  
3. **3-shot style examples** (optional but recommended): one `bhakti`, one `goodmorning`, one `motivation` mini example **not** copied into production DB (synthetic).  

### 7.3 Model parameters (recommendations)

| Parameter | Suggested value | Rationale |
|-----------|-----------------|------------|
| Temperature | `0.7`–`0.9` for creative variety; lower if high duplication | Tune per A/B. |
| Max output tokens | Enough for ~15 cards × ~400 chars/lang → budget **8k–16k** | Use batched jobs if hitting limits. |
| Top-p | `0.9` | Optional. |
| Stop sequences | None | JSON-only discipline via prompt + parser. |

**Batching:** If `N > 15`, split into multiple jobs of **10–15 cards** to reduce truncation and parse errors.

---

## 8. Backend architecture (generation service)

### 8.1 Components

1. **API Gateway** — authenticated admin or internal `POST /v1/internal/generate` (service account).  
2. **Job queue** — Redis / SQS / BullMQ: `pending` → `running` → `completed` \| `failed`.  
3. **Worker** — loads prompt, calls **Claude Messages API**, validates JSON, runs **similarity + policy checks**, writes DB.  
4. **Card store** — PostgreSQL `cards` table + optional `card_generation_meta` (`job_id`, `model`, `prompt_hash`, `input_hash`).  
5. **Idempotency** — `Idempotency-Key` header on job create; store result for 24h.

### 8.2 Suggested REST endpoints

| Method | Path | Description |
|--------|------|-------------|
| POST | `/v1/admin/generation-jobs` | Body: §4 payload + optional `dryRun: true` (returns JSON without insert). |
| GET | `/v1/admin/generation-jobs/{jobId}` | Status + errors + output preview. |
| POST | `/v1/users/me/refresh-feed` *(optional product)* | Queues **small** personalised batch using only that user’s interests (rate-limited). |

### 8.3 Personalised vs catalogue generation

| Mode | Trigger | Input interests |
|------|---------|-----------------|
| **Catalogue** | Editorial / cron | Curated list per festival week |
| **Personalised** | User taps “More like this” / nightly cron | That user’s `interestIds` + `religionId` |

Personalised jobs must **never** log full prompts with PII; hash `userId` in logs.

---

## 9. Post-processing pipeline (mandatory before publish)

1. **JSON parse** — strict; on failure → `failed` + store raw text for debugging (encrypted, TTL 7d).  
2. **Schema validate** — AJV / Zod equivalent on server.  
3. **Language detector** (optional) — spot-check that `te` is Telugu script, etc.; mismatch → quarantine.  
4. **Profanity / slur filter** — blocklist + classifier.  
5. **Near-duplicate check** — embedding cosine similarity vs last **30 days** of same `category`; if > **0.92**, discard or rewrite once.  
6. **Human review queue** *(recommended for v1 launch)* — flag first **500** cards per category or all `religionId != none` batches until metrics stable.

---

## 10. Ready-to-paste “Claude task” block

You can paste the block below into Claude when asking for quotes.

```
You are generating content for Daily Katha (multilingual Indian greetings app).

INPUT (JSON): 
<PASTE THE §4 JSON HERE>

RULES:
- Output ONLY valid JSON with root keys: jobId, model, generatedAt, cards.
- cards.length must equal constraints.cardsRequested.
- Each card must have: clientTempId (uuid), section, category, mood, isFestival, festival (null or string), quote{te,hi,ta,kn,ml,en}, author{te,hi,ta,kn,ml,en}.
- quote: 2-4 lines per language, use \n between lines; suitable for WhatsApp status.
- author: short line starting with — max 80 chars per language.
- Distribute cards across interestIds as evenly as possible.
- Respect religionId for tone and references; if muslim/christian/sikh, do not use Hindu deity names in bhakti unless spiritual/none/hindu.
- Do NOT copy real movie dialogues, song lyrics, or trademarked slogans. Cinema style = original lines only.
- No politicians, no medical/financial promises, no hate, no explicit romance.

OUTPUT:
Raw JSON only, no markdown fences.
```

---

## 11. Policy & legal (generation-specific)

1. **No verbatim** film dialogues, lyrics, or translated copies of same.  
2. **No real** celebrity / politician / religious leader **quotes** unless public-domain and verified (default: **do not** attribute to named living persons).  
3. **Festival content** must use **inclusive** language; avoid sectarian insults.  
4. **Cinema** category: **original** punchy lines in colloquial register — not IP-infringing.  
5. **Data retention:** store `prompt_hash` + `input_hash`, not raw prompts, unless admin debug flag.

---

## 12. Observability & cost

- Log: `jobId`, `latency_ms`, `input_token_count`, `output_token_count`, `cards_accepted`, `cards_rejected`, `failure_code`.  
- Alert if **rejection rate > 30%** over 1h.  
- Per-user daily cap for personalised refresh (e.g. **3** / day) unless paid tier.

---

## 13. Acceptance criteria (generation subsystem)

1. For valid §4 input, **≥ 95%** of jobs produce schema-valid JSON on first attempt (after prompt tuning).  
2. **100%** of persisted cards pass server validation in §5.1.  
3. For each `interestId` present in input, **≥ 1** card per batch has `category` equal to that interest (for N ≥ |I|).  
4. Spot-check: **10 random** cards reviewed by native speakers per language show **≤ 1** major error / 100 cards.  
5. Automated filter: **0** cards contain blocklisted slurs or known movie dialogue n-grams from a reference denylist (maintained separately).

---

## 14. Roadmap (generation)

| Phase | Deliverable |
|-------|-------------|
| P0 | Manual Claude batch → JSON file → DB import (admin script). |
| P1 | Worker + queue + `POST /v1/admin/generation-jobs` + validation. |
| P2 | Personalised user refresh endpoint + rate limits. |
| P3 | Embedding dedupe + A/B mood tuning from engagement metrics. |

---

## 15. Document control

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2026-04-24 | Product | Initial LLM / interest quote PRD |

**References:** `PRD.md` §7 (data model), `mobile/lib/models/katha_card.dart` and `mobile/lib/data/local/mock_catalog.dart` (`INTERESTS`, sample `KathaCard` shapes).

---

*End of PRD — Quote generation & Claude integration.*
