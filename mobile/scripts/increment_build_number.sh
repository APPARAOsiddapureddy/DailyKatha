#!/usr/bin/env bash
# Bumps the +build number in pubspec.yaml (e.g. 1.1.0+115 → 1.1.0+116).
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FILE="$ROOT/pubspec.yaml"
LINE=$(grep '^version:' "$FILE" | head -1)
if [[ "$LINE" =~ ^version:[[:space:]]*([0-9]+\.[0-9]+\.[0-9]+)\+([0-9]+) ]]; then
  VER="${BASH_REMATCH[1]}"
  BUILD="${BASH_REMATCH[2]}"
  NEXT=$((BUILD + 1))
  if [[ "$(uname)" == Darwin ]]; then
    sed -i '' "s/^version:.*$/version: ${VER}+${NEXT}/" "$FILE"
  else
    sed -i "s/^version:.*$/version: ${VER}+${NEXT}/" "$FILE"
  fi
  echo "Updated to ${VER}+${NEXT}"
else
  echo "Could not parse version line in pubspec.yaml" >&2
  exit 1
fi
