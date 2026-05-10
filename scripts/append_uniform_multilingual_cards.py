#!/usr/bin/env python3
"""Merge `scripts/data/batch_multilingual_*.json` into `mobile/assets/data/*_cards.json`.

Each batch row may include multilingual `quote` and `author` maps (te/hi/ta/kn/ml/en).
The same payload is written into every language catalog; only `section` and numeric
`id` (hash of section + sourceId) differ. Skips rows whose `sourceId` already exists
in that file. Run from repo root:

  python3 scripts/append_uniform_multilingual_cards.py
"""
from __future__ import annotations

import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA = ROOT / "scripts" / "data"
ASSETS = ROOT / "mobile" / "assets" / "data"

TARGETS: list[tuple[str, str]] = [
    ("hindi_cards.json", "hindi"),
    ("telugu_cards.json", "telugu"),
    ("kannada_cards.json", "kannada"),
    ("tamil_cards.json", "tamil"),
    ("malayalam_cards.json", "malayalam"),
    ("english_cards.json", "english"),
]


def default_author_line() -> dict[str, str]:
    return {
        "hi": "— दैनिक कथा",
        "te": "— దైనిక కథ",
        "ta": "— தினசரி கதை",
        "kn": "— ದೈನಂದಿನ ಕಥೆ",
        "ml": "— ദൈനിക കഥ",
        "en": "— Daily Katha",
    }


def fnv1a_positive_31(s: str) -> int:
    h = 2166136261
    for b in s.encode("utf-8"):
        h ^= b
        h = (h * 16777619) & 0xFFFFFFFF
    return h & 0x7FFFFFFF


def load_batches() -> list[dict]:
    parts = sorted(DATA.glob("batch_multilingual_*.json"))
    if not parts:
        raise SystemExit(f"No files matching {DATA}/batch_multilingual_*.json")
    out: list[dict] = []
    for p in parts:
        chunk = json.loads(p.read_text(encoding="utf-8"))
        if not isinstance(chunk, list):
            raise SystemExit(f"{p.name}: expected JSON array")
        out.extend(chunk)
        print(f"Loaded {len(chunk)} from {p.name}")
    return out


def normalize(raw: dict, index: int) -> dict:
    cat = (raw.get("category") or "goodmorning").strip().lower().replace("_", "")
    mood = (raw.get("mood") or "warm").strip().lower()
    quotes = raw["quote"]
    authors = raw.get("author")
    if not isinstance(quotes, dict):
        raise SystemExit(f"Card {index}: quote must be an object")
    if not isinstance(authors, dict) or not authors:
        authors = default_author_line()
    sid = raw.get("sourceId") or f"warm_bulk_{index + 1:03d}"
    return {
        "sourceId": sid,
        "category": cat,
        "mood": mood,
        "isFestival": bool(raw.get("isFestival", False)),
        "festival": raw.get("festival"),
        "quote": {k: str(v) for k, v in quotes.items()},
        "author": {k: str(v) for k, v in authors.items()},
    }


def main() -> int:
    raw_cards = load_batches()
    seen_sids: set[str] = set()
    models: list[dict] = []
    for i, raw in enumerate(raw_cards):
        m = normalize(raw, i)
        if m["sourceId"] in seen_sids:
            raise SystemExit(f"Duplicate sourceId {m['sourceId']}")
        seen_sids.add(m["sourceId"])
        models.append(m)

    all_ids: set[int] = set()
    for fname, _ in TARGETS:
        path = ASSETS / fname
        cat = json.loads(path.read_text(encoding="utf-8"))
        for c in cat:
            all_ids.add(int(c["id"]))

    for fname, section in TARGETS:
        path = ASSETS / fname
        catalog: list[dict] = json.loads(path.read_text(encoding="utf-8"))
        existing_sids = {str(c.get("sourceId", "")) for c in catalog}
        for m in models:
            sid = m["sourceId"]
            if sid in existing_sids:
                continue
            existing_sids.add(sid)
            nid = fnv1a_positive_31(f"{section}:{sid}")
            while nid in all_ids:
                nid = (nid + 1) & 0x7FFFFFFF
            all_ids.add(nid)
            entry: dict = {
                "id": nid,
                "sourceId": sid,
                "section": section,
                "category": m["category"],
                "mood": m["mood"],
                "isFestival": m["isFestival"],
                "quote": m["quote"],
                "author": m["author"],
            }
            fest = m["festival"]
            if fest:
                entry["festival"] = fest
            catalog.append(entry)
        path.write_text(json.dumps(catalog, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
        print(f"Wrote {len(catalog)} total → {path.relative_to(ROOT)}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
