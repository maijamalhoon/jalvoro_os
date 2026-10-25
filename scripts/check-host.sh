#!/usr/bin/env bash
set -Eeuo pipefail

section() { printf '\n== %s ==\n' "$1"; }
have() { command -v "$1" >/dev/null 2>&1; }

section "Jalvoro OS host preflight"
printf 'Date: '; date -Is 2>/dev/null || date
printf 'Kernel: '; uname -a
printf 'Architecture: '; uname -m

if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  printf 'OS: %s %s\n' "${PRETTY_NAME:-unknown}" "${VERSION_ID:-}"
fi

section "CPU"
if have lscpu; then lscpu | grep -E '^(Architecture|CPU\(s\)|Model name|Thread\(s\) per core|Core\(s\) per socket|Socket\(s\):)' || true; else echo "lscpu not installed"; fi

section "Memory"
if have free; then free -h; else echo "free not installed"; fi

section "Disk space"
df -hT "$HOME" /tmp 2>/dev/null || df -h

section "Required development tools"
for cmd in git python3 curl make gcc g++ java repo; do
  if have "$cmd"; then printf 'OK   %-10s %s\n' "$cmd" "$(command -v "$cmd")"
  else printf 'MISS %-10s\n' "$cmd"
  fi
done

section "Environment hints"
if grep -qiE 'microsoft|wsl' /proc/version 2>/dev/null; then
  echo "Detected WSL. Keep AOSP source/build output inside the Linux filesystem (e.g. ~/aosp), not /mnt/c."
else
  echo "No WSL marker detected. Native Linux is preferred for predictable AOSP builds."
fi

if [[ -d /dev/kvm && -r /dev/kvm && -w /dev/kvm ]]; then
  echo "KVM: available to this user"
else
  echo "KVM: unavailable or not writable; emulator acceleration/Cuttlefish may need host setup."
fi

echo
echo "This is a diagnostic only; it does not install packages or modify the system."
