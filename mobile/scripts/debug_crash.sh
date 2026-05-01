#!/usr/bin/env bash
set -euo pipefail

echo "Clearing logcat..."
adb logcat -c || true

echo "Installing debug APK..."
flutter install --debug

echo "Capturing crash logs for 30 seconds..."
echo "Open the app NOW on your phone"
echo ""

PKG="com.dailykatha.daily_katha"
PID="$(adb shell pidof "$PKG" 2>/dev/null || echo 0)"

adb logcat \
  --pid="$PID" \
  -s flutter:V AndroidRuntime:E ActivityManager:I \
  | grep -E "FATAL|Error|Exception|flutter|DailyKatha|crash" \
  | head -100

