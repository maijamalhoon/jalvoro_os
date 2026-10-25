#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/sync-aosp.sh /path/to/new/aosp-checkout [manifest-branch] [jobs]

Example:
  bash scripts/sync-aosp.sh "$HOME/aosp/jalvoro-android17" android17-release 8

This helper:
  - Requires an x86_64 Linux host and the 'repo' launcher.
  - Requires at least 400 GiB free on the destination filesystem.
  - Refuses to overwrite a non-empty directory or reuse an existing checkout.
  - Prompts before downloading the AOSP source tree.
  - Does not build, flash, change signing keys, or claim the result is bootable.
EOF
}

if [[ $# -lt 1 || $# -gt 3 ]]; then
  usage
  exit 2
fi

if [[ "$(uname -m)" != "x86_64" ]]; then
  echo "ERROR: AOSP platform builds require an x86_64 Linux host." >&2
  exit 1
fi
if ! command -v repo >/dev/null 2>&1; then
  echo "ERROR: 'repo' launcher not found. Run scripts/setup-ubuntu.sh first." >&2
  exit 1
fi

destination="$(realpath -m "$1")"
manifest_branch="${2:-android17-release}"
jobs="${3:-8}"

if [[ ! "$manifest_branch" =~ ^[A-Za-z0-9._/-]+$ || "$manifest_branch" == -* ]]; then
  echo "ERROR: Invalid manifest branch name." >&2
  exit 2
fi
if [[ ! "$jobs" =~ ^[1-9][0-9]*$ ]]; then
  echo "ERROR: jobs must be a positive integer." >&2
  exit 2
fi
if [[ "$destination" == "/" || "$destination" == "$HOME" ]]; then
  echo "ERROR: Choose a dedicated checkout directory, not / or your home directory." >&2
  exit 2
fi
if [[ -e "$destination" ]]; then
  if [[ ! -d "$destination" || -n "$(find "$destination" -mindepth 1 -maxdepth 1 -print -quit 2>/dev/null)" ]]; then
    echo "ERROR: Destination exists and is not empty: $destination" >&2
    echo "Choose a new empty directory. This script will not overwrite existing files." >&2
    exit 1
  fi
fi

parent="$(dirname "$destination")"
mkdir -p "$parent"
available_kib="$(df -Pk "$parent" | awk 'NR==2 {print $4}')"
minimum_kib=$((400 * 1024 * 1024))
if [[ ! "$available_kib" =~ ^[0-9]+$ ]] || (( available_kib < minimum_kib )); then
  available_gib="unknown"
  if [[ "$available_kib" =~ ^[0-9]+$ ]]; then
    available_gib=$((available_kib / 1024 / 1024))
  fi
  echo "ERROR: Need at least 400 GiB free; currently available: ${available_gib} GiB." >&2
  exit 1
fi

if [[ -d "$destination/.repo" ]]; then
  echo "ERROR: A .repo directory already exists; this helper expects a fresh checkout." >&2
  exit 1
fi

cat <<EOF
AOSP source sync plan
  Destination: $destination
  Manifest:    https://android.googlesource.com/platform/manifest
  Branch:      $manifest_branch
  Sync jobs:   $jobs
  Free space:  $((available_kib / 1024 / 1024)) GiB

This can download a very large source tree and may take hours.
EOF
read -r -p "Continue with repo init and repo sync? Type YES to proceed: " answer
if [[ "$answer" != "YES" ]]; then
  echo "Cancelled. No AOSP source sync was started."
  exit 0
fi

mkdir -p "$destination"
cd "$destination"
repo init -u https://android.googlesource.com/platform/manifest -b "$manifest_branch"
repo sync -c -j"$jobs"

cat <<EOF

AOSP source sync finished for branch: $manifest_branch
Next:
  1. Inspect docs/BASELINE.md and the selected branch's build instructions.
  2. Confirm the exact Cuttlefish lunch target in this checkout.
  3. Integrate device/jalvoro/common/jalvoro_apps.mk into the selected product.
  4. Build and test before claiming a bootable Jalvoro image.
EOF
