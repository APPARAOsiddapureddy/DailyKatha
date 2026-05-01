# Storing cards for a strong future recommendation system

This doc answers: *“If I store one love card in Telugu, what should I save so recommendations are easy later?”*

---

## 1. What “good storage for recommendations” really means

A recommender needs three kinds of information:

| Kind | What it is | Example |
|------|--------------|--------|
| **Item (card) side** | What this card *is* — so we can match “similar items” and filter by topic/mood. | `category=love`, `mood=romantic`, **embedding vector**, language, length. |
| **User side** | What this person *likes* — from onboarding and behaviour. | `interest_ids`, implicit taste from clicks/likes. |
| **Interactions** | What actually happened — the ground truth for learning. | “Shown on home rail #3”, “viewed 4s”, “liked”, “shared”. |

If you only store Telugu text, you can still do **simple** rules (“more `love` cards”). For a **very good** system you also want **structured fields**, **vectors**, and **event logs** — not only the final quote.

---

## 2. Minimum card record (you should always have)

Think of one row in `cards` (or one document) as:

**Identity & display (already aligned with your PRD / app)**

- `id` (UUID)
- `quote` → map for **all six** scripts: `te`, `hi`, `ta`, `kn`, `ml`, `en` (even if the “hero” is Telugu, keep others for share + future users)
- `author` → same six keys (short attribution)
- `category` → e.g. `love` (must match your catalogue / interest ids)
- `mood` → e.g. `romantic` (drives UI gradient + coarse similarity)
- `section` → e.g. `interests` (where it belongs in rails)
- `is_festival`, `festival` (nullable)
- `created_at`, `updated_at`, `published_at` (when it went live)

**Why multilingual on disk:** recommendations and search may be language-agnostic (embeddings over all text) or language-specific (filter `content_language = te`); sharing still needs other locales.

---

## 3. Fields to add *specifically* for recommendations (high value)

### 3.1 Semantic vector (strongest lever later)

- `embedding` — e.g. 384–1536 floats, or store **only in a vector DB** (Pinecone, pgvector) keyed by `card_id`.
- **What to embed:** concatenate `quote.te + quote.en` (or all languages) with a small prefix like `category=love|mood=romantic|` so the model sees context.

**Use:** “More like this card”, deduplication, clustering, cold-start “similar to liked items”.

### 3.2 Explicit targeting (cheap, interpretable)

- `target_interests` — array (often one: `["love"]`; can be multiple if editorial)
- `religion_sensitivity` — enum e.g. `neutral` | `hindu_flavoured` | `islam_flavoured` … or nullable `religion_tags[]` so you never recommend the wrong devotional tone.

**Use:** hard filters + explainability (“because you like love + morning”).

### 3.3 Content stats (cheap, helps ranking & quality)

- `primary_script` or `hero_language` — e.g. `te` (which line is “primary” in UI)
- `line_count`, `max_line_length`, `total_chars` per hero language
- `language_detector_scores` (optional JSON) — sanity check Telugu vs wrong script

**Use:** length limits for status, quality gates, diversity (“not five ultra-long cards in a row”).

### 3.4 Source & lifecycle (for drift and safety)

- `source` — `editorial` | `llm` | `user` | `import`
- `generation_job_id`, `model_name`, `prompt_hash` (if LLM) — reproduce/debug without storing full prompts
- `review_status` — `pending` | `approved` | `rejected` (if human or auto moderation)
- `quality_score` (optional float) — human or model rating for ranking

**Use:** only show `approved`; down-rank old LLM bucket if quality drops.

### 3.5 Popularity aggregates (updated by batch jobs)

- `like_count`, `save_count`, `share_count`, `impression_count` (counters)
- `last_engaged_at` — for recency
- optional **decayed score** `trending_score` recomputed nightly (so old viral cards fall off)

**Use:** trending rail, “people also liked”, exploration vs exploitation.

---

## 4. What you must store *outside* the card row: interaction events

Per impression / tap, append to an **events** table (or analytics pipeline), not only counters:

Suggested event shape:

- `user_id`, `card_id`, `event_type` (`impression` | `view_start` | `view_end` | `like` | `save` | `share` | `dismiss`)
- `surface` (`home_rail_foryou` | `feed` | `explore` | `search`)
- `position` (index in list), `session_id`, `timestamp`
- optional: `dwell_ms` on `view_end`

**Use:** collaborative filtering (“users who liked A liked B”), sequence models, A/B on placement — **this is as important as the card text**.

---

## 5. Concrete example: one **love** card, **Telugu-forward**

**Card row (conceptual):**

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "category": "love",
  "mood": "romantic",
  "section": "interests",
  "hero_language": "te",
  "quote": { "te": "…", "hi": "…", "ta": "…", "kn": "…", "ml": "…", "en": "…" },
  "author": { "te": "— …", "hi": "— …", "ta": "— …", "kn": "— …", "ml": "— …", "en": "— …" },
  "target_interests": ["love"],
  "religion_sensitivity": "neutral",
  "source": "llm",
  "generation_job_id": "job-abc",
  "model_name": "claude-3-5-sonnet",
  "review_status": "approved",
  "line_count_te": 3,
  "created_at": "2026-04-24T10:00:00+05:30",
  "published_at": "2026-04-24T10:05:00+05:30"
}
```

**Vector store:** same `id` → `embedding` from concatenated controlled text.

**When user U scrolls and likes it:** insert `user_card_events` row `(U, card_id, like, feed, …)`.

---

## 6. What I suggest you **make** (build order)

1. **`cards` table** — PRD shape + §3 fields above (embedding either column `vector` with pgvector or separate store).
2. **`user_card_events` table** — append-only events (or send to Segment/BigQuery); nightly job rolls up counters on `cards`.
3. **Materialised or nightly `user_taste_profiles`** — top categories, % love vs bhakti, optional mean embedding of last 50 liked cards (advanced but very effective).
4. **Retrieval API** — `GET /v1/recommendations?user_id=&limit=` that blends: content-based (embedding near profile), collaborative (similar users), and rules (interests, religion, language).

You do **not** need everything on day one: start with **`cards` + categories + event log**; add **embeddings** when you want “more like this” quality.

---

## 7. One-line summary

**Store the card as structured multilingual content + category/mood + (optional) embedding + provenance; store every user–card interaction as events; aggregate popularity.** That trio is what makes a future recommendation system “easy and very good” instead of fighting messy text-only data.

---

*Companion: [PRD.md](./PRD.md), [PRD-Quote-Generation-LLM.md](./PRD-Quote-Generation-LLM.md)*
