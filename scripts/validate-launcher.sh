#!/usr/bin/env bash
set -Eeuo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
app="packages/apps/JalvoroLauncher"

required=(
  "$app/Android.bp"
  "$app/AndroidManifest.xml"
  "$app/src/com/jalvoro/launcher/MainActivity.java"
  "$app/res/values/strings.xml"
  "$app/README.md"
  docs/IMPLEMENTED_CODE.md
  scripts/validate-android-resources.py
)

for file in "${required[@]}"; do
  if [[ ! -s "$file" ]]; then
    printf 'MISSING: %s\n' "$file" >&2
    exit 1
  fi
  printf 'OK: %s\n' "$file"
done

grep -q 'android.intent.category.HOME' "$app/AndroidManifest.xml"
grep -q 'android.intent.category.LAUNCHER' "$app/AndroidManifest.xml"
grep -q '<queries>' "$app/AndroidManifest.xml"
grep -q 'Intent.CATEGORY_LAUNCHER' "$app/src/com/jalvoro/launcher/MainActivity.java"
grep -q 'R.string.search_apps_hint' "$app/src/com/jalvoro/launcher/MainActivity.java"
grep -q 'Math.min(6, width / dp(82))' "$app/src/com/jalvoro/launcher/MainActivity.java"
grep -q 'android_app' "$app/Android.bp"
python3 scripts/validate-android-resources.py
printf 'Jalvoro launcher source checks passed. (This is not an Android compile.)\n'
