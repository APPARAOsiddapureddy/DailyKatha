#!/usr/bin/env bash
# Builds prod release APK and copies it to build/app/outputs/flutter-apk/app-release.apk
# so the path matches older workflows before Android flavors existed.
#
# Internal testing (Dart default): real backend OTP is OFF — any 6 digits, then onboarding → Home.
# Store / rollout with SMS OTP: add --dart-define=REQUIRE_BACKEND_OTP=true
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

OUT_DIR="$ROOT/build/app/outputs/flutter-apk"
PRIMARY="$OUT_DIR/app-prod-release.apk"
LEGACY_NAME="$OUT_DIR/app-release.apk"

flutter build apk --flavor prod --release --dart-define=FLAVOR=production "$@"

if [[ -f "$PRIMARY" ]]; then
  cp -f "$PRIMARY" "$LEGACY_NAME"
  echo ""
  echo "Primary artifact: $PRIMARY"
  echo "Same path as before:  $LEGACY_NAME"
else
  echo "warning: missing $PRIMARY (check split-per-abi output names)" >&2
  exit 1
fi
