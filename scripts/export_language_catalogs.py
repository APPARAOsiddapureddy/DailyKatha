#!/usr/bin/env python3
"""Export DailyKatha_*_Upload.xlsx workbooks → mobile/assets/data/*.json.

Layouts (sheet1, row 1 = header):
  Hindi, Telugu, Kannada, Tamil, Malayalam: ID | Interest | Quote_<Lang> | Quote_English | Mood
  English: ID | Interest | Quote_English | Quote_Secondary | Mood
    (primary + optional secondary line are merged into one `en` quote with a blank line between.)

Run from repo root:
  python3 scripts/export_language_catalogs.py
"""
from __future__ import annotations

import json
import re
import sys
import zipfile
import xml.etree.ElementTree as ET
from pathlib import Path

NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"


def col_row(ref: str) -> tuple[int, int] | None:
    m = re.match(r"^([A-Z]+)(\d+)$", ref)
    if not m:
        return None
    letters, rs = m.group(1), int(m.group(2))
    col = 0
    for ch in letters:
        col = col * 26 + (ord(ch) - 64)
    return col, rs


def load_shared_strings(z: zipfile.ZipFile) -> list[str]:
    if "xl/sharedStrings.xml" not in z.namelist():
        return []
    root = ET.fromstring(z.read("xl/sharedStrings.xml"))
    out: list[str] = []
    for si in root.findall(f".//{NS}si"):
        parts: list[str] = []
        for t in si.findall(f".//{NS}t"):
            if t.text:
                parts.append(t.text)
        out.append("".join(parts))
    return out


def cell_text(c: ET.Element, shared: list[str]) -> str:
    t = c.get("t")
    if t == "inlineStr":
        is_el = c.find(f"{NS}is")
        if is_el is None:
            return ""
        parts: list[str] = []
        for te in is_el.findall(f".//{NS}t"):
            if te.text:
                parts.append(te.text)
            if te.tail:
                parts.append(te.tail)
        return "".join(parts)
    v_el = c.find(f"{NS}v")
    if v_el is None or v_el.text is None:
        return ""
    val = v_el.text
    if t == "s":
        return shared[int(val)]
    return val


def fnv1a_positive_31(s: str) -> int:
    h = 2166136261
    for b in s.encode("utf-8"):
        h ^= b
        h = (h * 16777619) & 0xFFFFFFFF
    return h & 0x7FFFFFFF


def read_rows(xlsx: Path) -> dict[int, dict[int, str]]:
    rows: dict[int, dict[int, str]] = {}
    with zipfile.ZipFile(xlsx) as z:
        shared = load_shared_strings(z)
        sheet = ET.fromstring(z.read("xl/worksheets/sheet1.xml"))
        for c in sheet.findall(f".//{NS}c"):
            ref = c.get("r")
            if not ref:
                continue
            parsed = col_row(ref)
            if parsed is None:
                continue
            col, row = parsed
            text = cell_text(c, shared)
            rows.setdefault(row, {})[col] = text
    return rows


def _author_row(native_lang: str, native_label: str) -> dict[str, str]:
    """Attribution line per language; non-native keys use English label for parity."""
    row = {
        "hi": "— दैनिक कथा",
        "te": "— దైనిక కథ",
        "ta": "— தினசரி கதை",
        "kn": "— ದೈನಂದಿನ ಕಥೆ",
        "ml": "— ദൈനിക കഥ",
        "en": "— Daily Katha",
    }
    row[native_lang] = native_label
    return row


AUTHORS: dict[str, dict[str, str]] = {
    "hi": _author_row("hi", "— दैनिक कथा"),
    "te": _author_row("te", "— దైనిక కథ"),
    "ta": _author_row("ta", "— தினசரி கதை"),
    "kn": _author_row("kn", "— ದೈನಂದಿನ ಕಥೆ"),
    "ml": _author_row("ml", "— ദൈനിക കഥ"),
    "en": _author_row("en", "— Daily Katha"),
}


def export_workbook(
    xlsx: Path,
    out_path: Path,
    *,
    section: str,
    quote_lang: str,
) -> int:
    if not xlsx.exists():
        print(f"Skip (missing): {xlsx.name}", file=sys.stderr)
        return 0

    rows = read_rows(xlsx)
    max_row = max(rows) if rows else 0
    cards: list[dict] = []
    seen_ids: set[int] = set()

    for r in range(2, max_row + 1):
        row = rows.get(r, {})
        source_id = (row.get(1) or "").strip()
        interest = (row.get(2) or "").strip()
        col_c = (row.get(3) or "").strip()
        col_d = (row.get(4) or "").strip()
        mood = (row.get(5) or "warm").strip() or "warm"

        if quote_lang == "en":
            if not col_c and not col_d:
                continue
            body = col_c
            if col_d:
                body = f"{col_c}\n\n{col_d}" if col_c else col_d
            quote: dict[str, str] = {"en": body}
        else:
            if not col_c and not col_d:
                continue
            quote = {quote_lang: col_c, "en": col_d or col_c}

        if not source_id:
            source_id = f"row_{r}"

        nid = fnv1a_positive_31(source_id)
        while nid in seen_ids:
            nid = (nid + 1) & 0x7FFFFFFF
        seen_ids.add(nid)
        cards.append(
            {
                "id": nid,
                "sourceId": source_id,
                "section": section,
                "category": interest or "general",
                "mood": mood,
                "isFestival": False,
                "quote": quote,
                "author": AUTHORS[quote_lang],
            }
        )

    out_path.parent.mkdir(parents=True, exist_ok=True)
    out_path.write_text(json.dumps(cards, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(f"Wrote {len(cards)} cards → {out_path}")
    return len(cards)


def main() -> int:
    root = Path(__file__).resolve().parents[1]
    data_dir = root / "mobile" / "assets" / "data"
    jobs = [
        (root / "DailyKatha_Hindi_Upload.xlsx", data_dir / "hindi_cards.json", "hindi", "hi"),
        (root / "DailyKatha_Telugu_Upload.xlsx", data_dir / "telugu_cards.json", "telugu", "te"),
        (root / "DailyKatha_Kannada_Upload.xlsx", data_dir / "kannada_cards.json", "kannada", "kn"),
        (root / "DailyKatha_Tamil_Upload.xlsx", data_dir / "tamil_cards.json", "tamil", "ta"),
        (root / "DailyKatha_Malayalam_Upload.xlsx", data_dir / "malayalam_cards.json", "malayalam", "ml"),
        (root / "DailyKatha_English_Upload.xlsx", data_dir / "english_cards.json", "english", "en"),
    ]
    total = 0
    for xlsx, out, section, qlang in jobs:
        total += export_workbook(xlsx, out, section=section, quote_lang=qlang)
    if total == 0:
        print("No workbooks found or all empty.", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
