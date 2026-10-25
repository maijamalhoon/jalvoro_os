#!/usr/bin/env bash
set -Eeuo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
app="packages/apps/JalvoroLauncher"

required=(
  "$app/Android.bp"
  "$app/AndroidManifest.xml"
  "$app/src/com/jalvoro/launcher/MainActivity.java"
  "$app/README.md"
  docs/IMPLEMENTED_CODE.md
)

for file in "${required[@]}"; do
  if [[ ! -s "$file" ]]; then
    printf 'MISSING: %s\n' "$file" >&2
    exit 1
  fi
  printf 'OK: %s\n' "$file"
done

grep -q 'android.intent.category.HOME' "$app/AndroidManifest.xml"
grep -q 'android.intent.category.LAUNCHER' "$app/src/com/jalvoro/launcher/MainActivity.java"
grep -q 'android_app' "$app/Android.bp"
printf 'Jalvoro launcher source checks passed. (This is not an Android compile.)\n'
