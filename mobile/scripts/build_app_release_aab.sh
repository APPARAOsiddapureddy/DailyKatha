#!/usr/bin/env bash
# Play Store bundle (AAB), prod flavor + production dart-define.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

BN="${BUILD_NUMBER:-${GITHUB_RUN_NUMBER:-}}"
DEFINES=(--dart-define=FLAVOR=production)
if [[ -n "${BN}" ]]; then
  DEFINES+=(--build-number="$BN")
fi

flutter pub get
flutter build appbundle --flavor prod --release "${DEFINES[@]}" "$@"

OUT="$ROOT/build/app/outputs/bundle/prodRelease/app-prod-release.aab"
if [[ -f "$OUT" ]]; then
  echo "AAB: $OUT"
fi
