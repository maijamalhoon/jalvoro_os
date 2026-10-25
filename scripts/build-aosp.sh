#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/build-aosp.sh /path/to/aosp-checkout <lunch-target> [jobs]

Example (target must be verified for your checked-out branch):
  bash scripts/build-aosp.sh "$HOME/aosp/jalvoro" aosp_cf_x86_64_only_phone-aosp_current-userdebug 16

This helper does not sync source or choose a branch. It sources the selected
checkout's build/envsetup.sh, selects the explicit target, then invokes m.
EOF
}

if [[ $# -lt 2 || $# -gt 3 ]]; then usage; exit 2; fi
src="$(realpath "$1")"
target="$2"
jobs="${3:-}"

if [[ ! -f "$src/build/envsetup.sh" ]]; then
  echo "ERROR: $src does not look like an AOSP source checkout (build/envsetup.sh missing)." >&2
  exit 1
fi
if [[ ! "$target" =~ ^[A-Za-z0-9_.+-]+$ ]]; then
  echo "ERROR: Invalid lunch target string." >&2
  exit 2
fi
if [[ -n "$jobs" && ! "$jobs" =~ ^[1-9][0-9]*$ ]]; then
  echo "ERROR: jobs must be a positive integer." >&2
  exit 2
fi

cd "$src"
printf 'Source: %s\nTarget: %s\n' "$src" "$target"
printf 'Manifest revision (if available):\n'
repo manifest -r 2>/dev/null | sha256sum || true
echo "NOTE: Verify the lunch target against this branch's official build output before proceeding."
read -r -p "Start build for this exact target? [y/N] " answer
case "$answer" in y|Y|yes|YES) ;; *) echo "Cancelled."; exit 0 ;; esac

# AOSP defines lunch as a shell function; it must run in this same Bash process.
source build/envsetup.sh
lunch "$target"
if [[ -n "$jobs" ]]; then
  m "-j$jobs"
else
  m
fi
