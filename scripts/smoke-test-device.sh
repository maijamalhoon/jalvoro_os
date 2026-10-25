#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v adb >/dev/null 2>&1; then
  echo "ERROR: adb is not installed or not on PATH." >&2
  exit 1
fi

serial="${1:-}"
if [[ -n "$serial" ]]; then
  adb -s "$serial" wait-for-device
  ADB=(adb -s "$serial")
else
  adb wait-for-device
  ADB=(adb)
fi

echo "Waiting for Android boot completion..."
booted=""
for _ in $(seq 1 120); do
  booted="$("${ADB[@]}" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r' || true)"
  [[ "$booted" == "1" ]] && break
  sleep 2
done
if [[ "$booted" != "1" ]]; then
  echo "FAIL: Android did not report sys.boot_completed=1 within 240 seconds." >&2
  "${ADB[@]}" logcat -d -t 300 2>/dev/null || true
  exit 1
fi

fingerprint="$("${ADB[@]}" shell getprop ro.build.fingerprint | tr -d '\r')"
release="$("${ADB[@]}" shell getprop ro.build.version.release | tr -d '\r')"
sdk="$("${ADB[@]}" shell getprop ro.build.version.sdk | tr -d '\r')"
device="$("${ADB[@]}" shell getprop ro.product.device | tr -d '\r')"

printf '\nPASS: Android boot completed\n'
printf 'Fingerprint: %s\n' "$fingerprint"
printf 'Release: %s\nSDK: %s\nDevice: %s\n' "$release" "$sdk" "$device"

if [[ -z "$fingerprint" || -z "$sdk" ]]; then
  echo "FAIL: Required build identity properties are empty." >&2
  exit 1
fi

if "${ADB[@]}" shell pm path android >/dev/null 2>&1; then
  echo "PASS: Package Manager responds"
else
  echo "FAIL: Package Manager did not respond successfully" >&2
  exit 1
fi

echo
echo "Basic smoke test passed. This is not CTS/VTS, a security audit, or proof of hardware compatibility."
