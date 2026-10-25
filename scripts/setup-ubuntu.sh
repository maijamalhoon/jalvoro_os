#!/usr/bin/env bash
set -Eeuo pipefail

# Run on a supported x86_64 Ubuntu LTS host. This installs build dependencies only.
# It deliberately does NOT sync AOSP source, select a branch, accept licenses,
# configure signing keys, or start a multi-hour build.

if [[ "$(uname -m)" != "x86_64" ]]; then
  echo "ERROR: AOSP platform builds require an x86_64 Linux host for this setup." >&2
  exit 1
fi

if [[ ! -r /etc/os-release ]]; then
  echo "ERROR: Cannot identify Linux distribution." >&2
  exit 1
fi
. /etc/os-release
if [[ "${ID:-}" != "ubuntu" ]]; then
  echo "ERROR: This script targets Ubuntu LTS. Detected: ${PRETTY_NAME:-unknown}" >&2
  echo "Use docs/DEVELOPMENT_ENVIRONMENT.md to adapt packages for another distro." >&2
  exit 1
fi

if [[ $EUID -eq 0 ]]; then
  SUDO=""
elif command -v sudo >/dev/null 2>&1; then
  SUDO="sudo"
else
  echo "ERROR: sudo is required to install system packages." >&2
  exit 1
fi

echo "Ubuntu detected: ${PRETTY_NAME:-unknown}"
echo "Installing host packages; this changes system packages and may take several minutes."
read -r -p "Continue? [y/N] " answer
case "$answer" in y|Y|yes|YES) ;; *) echo "Cancelled."; exit 0 ;; esac

$SUDO apt-get update
$SUDO apt-get install -y --no-install-recommends \
  bc bison build-essential ccache clang cmake curl flex fontconfig \
  g++-multilib gcc-multilib git git-lfs git-core gnupg gperf imagemagick \
  lib32ncurses-dev lib32z1-dev libelf-dev liblz4-tool libncurses-dev \
  libssl-dev libxml2-utils lz4 make m4 openjdk-17-jdk \
  python3 python-is-python3 python3-pip python3-venv rsync unzip \
  zip zlib1g-dev xsltproc ninja-build adb fastboot repo

mkdir -p "$HOME/bin" "$HOME/aosp"
if ! command -v repo >/dev/null 2>&1; then
  echo "The Ubuntu repo package was not found; installing Google's repo launcher in ~/bin."
  repo_tmp="$(mktemp)"
  repo_sig="$(mktemp)"
  trap 'rm -f "$repo_tmp" "$repo_sig"' EXIT
  curl -fL https://storage.googleapis.com/git-repo-downloads/repo -o "$repo_tmp"
  curl -fL https://storage.googleapis.com/git-repo-downloads/repo.asc -o "$repo_sig"
  gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys 8BB9AD793E8E6153AF0F9A4416530D5E920F5C65
  gpg --verify "$repo_sig" "$repo_tmp"
  install -m 0755 "$repo_tmp" "$HOME/bin/repo"
  rm -f "$repo_tmp" "$repo_sig"
  trap - EXIT
  if ! grep -q 'HOME/bin' "$HOME/.profile" 2>/dev/null; then
    printf '\n# Jalvoro OS tools\nexport PATH="$HOME/bin:$PATH"\n' >> "$HOME/.profile"
  fi
fi

git lfs install --skip-repo 2>/dev/null || true

echo
echo "Host packages installed. Open a new terminal, then run:"
echo "  bash scripts/check-host.sh"
echo
echo "Next: read docs/DEVELOPMENT_ENVIRONMENT.md and choose a specific Android release/branch."
echo "No AOSP source was downloaded and no OS image was built."
