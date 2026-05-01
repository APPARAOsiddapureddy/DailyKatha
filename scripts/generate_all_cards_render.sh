#!/usr/bin/env bash
# Generate cards for all interest categories on Render (Step 6).
# Default RENDER must match kDailyKathaProductionApiBase in mobile/lib/config/flavor_config.dart (without /v1).
# Usage:
#   export RENDER="https://dailykatha-backend.onrender.com"
#   export KEY="your-INTERNAL_API_KEY-from-Render"
#   ./scripts/generate_all_cards_render.sh
set -euo pipefail

RENDER="${RENDER:-https://dailykatha-backend.onrender.com}"
KEY="${KEY:-}"

if [[ -z "$KEY" ]]; then
  echo "Set KEY to your Render INTERNAL_API_KEY (same as x-internal-key for /metrics)." >&2
  exit 1
fi

categories=(goodmorning goodnight love bhakti motivation festival family cinema heroes poetry friendship birthday)

for category in "${categories[@]}"; do
  job_id="$(uuidgen 2>/dev/null | tr '[:upper:]' '[:lower:]' || python3 -c 'import uuid; print(uuid.uuid4())')"
  echo "Generating cards for: $category (job $job_id)"
  curl -sS -X POST "${RENDER%/}/v1/internal/generation-jobs" \
    -H "Content-Type: application/json" \
    -H "x-internal-key: $KEY" \
    -d "{
      \"jobId\": \"$job_id\",
      \"interestIds\": [\"$category\"],
      \"contentLanguage\": \"te\",
      \"localDate\": \"$(date +%Y-%m-%d)\",
      \"timezone\": \"Asia/Kolkata\",
      \"occasions\": [],
      \"constraints\": {
        \"cardsRequested\": 20,
        \"maxCharsPerQuoteLine\": 42,
        \"maxQuoteLines\": 4,
        \"forbidCopyrightFilmQuotes\": true,
        \"forbidRealPoliticianNames\": true,
        \"forbidMedicalClaims\": true
      }
    }" || true
  echo ""
  sleep 45
done

echo "Done. Poll job status with:"
echo "  curl -sS \"\$RENDER/v1/internal/generation-jobs/JOB_ID\" -H \"x-internal-key: \$KEY\""
