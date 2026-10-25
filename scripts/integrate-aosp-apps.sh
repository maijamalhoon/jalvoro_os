#!/usr/bin/env bash
set -Eeuo pipefail

usage() {
  cat <<'EOF'
Usage:
  bash scripts/integrate-aosp-apps.sh /path/to/aosp-checkout

The helper copies Jalvoro Launcher, Jalvoro Settings, and the shared product
fragment into an existing AOSP tree. It refuses to overwrite any destination
and does not modify a product makefile or build the OS.
EOF
}

if [[ $# -ne 1 ]]; then usage; exit 2; fi

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
aosp_root="$(realpath "$1")"

if [[ ! -f "$aosp_root/build/envsetup.sh" ]]; then
  echo "ERROR: AOSP checkout not found (build/envsetup.sh missing): $aosp_root" >&2
  exit 1
fi

sources=(
  "$repo_root/packages/apps/JalvoroLauncher"
  "$repo_root/packages/apps/JalvoroSettings"
  "$repo_root/device/jalvoro/common/jalvoro_apps.mk"
)
destinations=(
  "$aosp_root/packages/apps/JalvoroLauncher"
  "$aosp_root/packages/apps/JalvoroSettings"
  "$aosp_root/device/jalvoro/common/jalvoro_apps.mk"
)

for source in "${sources[@]}"; do
  if [[ ! -e "$source" ]]; then
    echo "ERROR: Required Jalvoro source is missing: $source" >&2
    exit 1
  fi
done
for destination in "${destinations[@]}"; do
  if [[ -e "$destination" ]]; then
    echo "ERROR: Destination already exists; refusing to overwrite: $destination" >&2
    echo "Review it manually, then choose a clean checkout or handle the merge yourself." >&2
    exit 1
  fi
done

cat <<EOF
Jalvoro integration plan
  AOSP root: $aosp_root
  Copy:
    packages/apps/JalvoroLauncher
    packages/apps/JalvoroSettings
    device/jalvoro/common/jalvoro_apps.mk

This does not edit your product makefile, select a lunch target, or build anything.
EOF
read -r -p "Copy these files into the AOSP checkout? Type YES to proceed: " answer
if [[ "$answer" != "YES" ]]; then
  echo "Cancelled. No files were copied."
  exit 0
fi

mkdir -p "$aosp_root/packages/apps" "$aosp_root/device/jalvoro/common"
cp -a "${sources[0]}" "$aosp_root/packages/apps/"
cp -a "${sources[1]}" "$aosp_root/packages/apps/"
cp -a "${sources[2]}" "$aosp_root/device/jalvoro/common/"

cat <<EOF

Files copied. Next:
  1. Add this line to the selected product's makefile:
     $(call inherit-product, device/jalvoro/common/jalvoro_apps.mk)
  2. Confirm the exact lunch target for this AOSP branch.
  3. Build the app modules:
     m JalvoroLauncher JalvoroSettings
  4. Build and boot the selected product image in Cuttlefish.
EOF
