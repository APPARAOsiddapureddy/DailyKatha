# Daily Katha (monorepo)

- **Mobile app:** [`mobile/`](mobile/README.md) (Flutter).
- **API:** [`backend/`](backend/README.md) (`cd backend && npm ci && npm start`).
- **Card content:** Root `DailyKatha_*_Upload.xlsx` → run `python3 scripts/export_language_catalogs.py`.
- **Product notes:** [`PRD.md`](PRD.md), [`Daily Katha Redesign.html`](Daily%20Katha%20Redesign.html).

A duplicate standalone Node layout at `./src/` with a root-level `package.json` was removed; use **`backend/`** only.
