#!/usr/bin/env bash
set -Eeuo pipefail

root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

required=(
  README.md ROADMAP.md CONTRIBUTING.md SECURITY.md
  docs/MASTER_PLAN.md docs/ARCHITECTURE.md
  docs/DEVELOPMENT_ENVIRONMENT.md docs/ANDROID_STACK_MAP.md docs/TESTING.md
  docs/FEATURE_BACKLOG.md docs/DECISIONS.md docs/BUILD_AND_RELEASE.md
  docs/AI_POLICY.md docs/TEST_MATRIX.md docs/BASELINE.md
  scripts/setup-ubuntu.sh scripts/check-host.sh scripts/prepare-wsl.ps1
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

if [[ "$fail" -ne 0 ]]; then
  echo "Repository validation failed." >&2
  exit 1
fi

echo "Repository structure and shell syntax checks passed."
