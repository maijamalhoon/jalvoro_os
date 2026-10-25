#!/usr/bin/env bash
set -Eeuo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

required=(
  README.md ROADMAP.md CONTRIBUTING.md SECURITY.md
  docs/MASTER_PLAN.md docs/ARCHITECTURE.md
  docs/DEVELOPMENT_ENVIRONMENT.md docs/ANDROID_STACK_MAP.md docs/TESTING.md
  docs/FEATURE_BACKLOG.md docs/DECISIONS.md docs/BUILD_AND_RELEASE.md
  docs/AI_POLICY.md docs/TEST_MATRIX.md docs/BASELINE.md docs/SYSTEM_SUBSYSTEMS.md
  docs/IMPLEMENTED_CODE.md
  scripts/setup-ubuntu.sh scripts/check-host.sh scripts/prepare-wsl.ps1 scripts/build-aosp.sh scripts/smoke-test-device.sh
  scripts/validate-android-resources.py scripts/validate-settings.py
  packages/apps/JalvoroLauncher/Android.bp
  packages/apps/JalvoroLauncher/AndroidManifest.xml
  packages/apps/JalvoroLauncher/src/com/jalvoro/launcher/MainActivity.java
  packages/apps/JalvoroLauncher/res/values/strings.xml
  packages/apps/JalvoroSettings/Android.bp
  packages/apps/JalvoroSettings/AndroidManifest.xml
  packages/apps/JalvoroSettings/src/com/jalvoro/settings/MainActivity.java
  packages/apps/JalvoroSettings/res/values/strings.xml
)

fail=0
for file in "${required[@]}"; do
  if [[ ! -s "$file" ]]; then
    printf 'MISSING: %s\n' "$file" >&2
    fail=1
  else
    printf 'OK: %s\n' "$file"
  fi
done

for file in scripts/*.sh; do
  [[ -f "$file" ]] || continue
  if bash -n "$file"; then
    printf 'SHELL SYNTAX OK: %s\n' "$file"
  else
    printf 'SHELL SYNTAX FAIL: %s\n' "$file" >&2
    fail=1
  fi
done

for file in scripts/validate-android-resources.py scripts/validate-settings.py; do
  if python3 -m py_compile "$file"; then
    printf 'PYTHON SYNTAX OK: %s\n' "$file"
  else
    printf 'PYTHON SYNTAX FAIL: %s\n' "$file" >&2
    fail=1
  fi
done

if ! bash scripts/validate-launcher.sh; then
  printf 'LAUNCHER SOURCE CHECKS FAILED\n' >&2
  fail=1
fi

if ! python3 scripts/validate-settings.py; then
  printf 'SETTINGS SOURCE CHECKS FAILED\n' >&2
  fail=1
fi

if [[ "$fail" -ne 0 ]]; then
  echo "Repository validation failed." >&2
  exit 1
fi

echo "Repository structure, Android resource consistency and script syntax checks passed."
