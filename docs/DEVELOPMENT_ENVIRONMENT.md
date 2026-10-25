# Jalvoro OS Development Environment

This document defines a reproducible, cautious setup path for the Jalvoro OS AOSP project.

## What this setup does

- Installs common Ubuntu host packages used for Android platform development.
- Adds host preflight scripts for CPU, memory, disk, Java, repo, and KVM checks.
- Provides an optional Windows PowerShell helper to request WSL2 + Ubuntu installation.
- Provides a guarded AOSP source-sync helper that checks available disk space and asks for explicit confirmation.
- Provides a guarded integration helper to copy Jalvoro apps and the product fragment into an existing AOSP checkout without overwriting existing paths.
- Does **not** run a full AOSP build, create signing keys, flash a device, or claim that Jalvoro is bootable.

## Host recommendation

- x86_64 CPU with hardware virtualization enabled in firmware.
- 64 GB RAM is a practical target for large modern Android platform builds; more helps parallel builds.
- Reserve roughly 400 GB or more for a checkout and build output; 1 TB or more is more comfortable for multiple branches/builds. Actual needs vary by Android branch and build targets.
- Native Ubuntu LTS is preferred for predictable I/O and virtualization. WSL2 may be possible but is a compromise for a large platform build.
- If using WSL2, keep source and output under the Linux home filesystem, not `/mnt/c`.
- NVIDIA RTX graphics is not required for the AOSP platform build; CPU, RAM, storage I/O, and virtualization matter more.

## 1. Windows option: WSL2 + Ubuntu

Open PowerShell **as Administrator**, clone the repository on Windows, then run the helper from the repository directory:

```powershell
git clone https://github.com/maijamalhoon/jalvoro_os.git
cd jalvoro_os
git switch main
.\scripts\prepare-wsl.ps1
```

The script asks for explicit confirmation, then requests WSL2 and Ubuntu 22.04. Windows may need a restart; first launch of Ubuntu requires you to create a Linux username/password. This step cannot be fully unattended.

After Ubuntu opens, run these commands **inside Ubuntu**, not PowerShell:

```bash
sudo apt-get update
sudo apt-get install -y git
git clone https://github.com/maijamalhoon/jalvoro_os.git
cd jalvoro_os
git switch main
bash scripts/setup-ubuntu.sh
bash scripts/check-host.sh
```

AOSP source and build output should live in Linux home (e.g. `~/aosp`), not `/mnt/c`. Native Ubuntu is preferred if WSL2 virtualization or performance is unreliable.

## 2. Native Ubuntu option

On a clean Ubuntu LTS installation:

```bash
git clone https://github.com/maijamalhoon/jalvoro_os.git
cd jalvoro_os
git switch main
bash scripts/setup-ubuntu.sh
bash scripts/check-host.sh
```

The setup script uses apt and sudo to change system packages. It asks before proceeding. Review the package list before running on a production/server machine.

## 3. Choose an Android baseline before syncing

The repository's current candidate is documented in [BASELINE.md](BASELINE.md): Android 17's `android17-release` manifest branch and an x86_64 Cuttlefish phone target. This is a **proposal**, not a claim that the source tree or build has been verified. Recheck the official AOSP pages and confirm the branch-specific lunch target before continuing.

Official references:
- AOSP setup: https://source.android.com/docs/setup/start
- AOSP host requirements: https://source.android.com/docs/setup/start/requirements
- Download source: https://source.android.com/docs/setup/download
- Build Android: https://source.android.com/docs/setup/build/building
- Cuttlefish: https://source.android.com/docs/devices/cuttlefish
- Android compatibility: https://source.android.com/docs/compatibility

## 4. Source and build workflow (after baseline approval)

Sync source into a new dedicated directory:

```bash
bash scripts/sync-aosp.sh "$HOME/aosp/jalvoro-android17" android17-release 8
```

It requires an x86_64 Linux host, the `repo` launcher, at least 400 GiB free on the destination filesystem, and the exact word `YES` before starting a large download. It refuses to overwrite non-empty directories. The helper syncs source only; it does not build.

After sync, copy both app modules and the product fragment into the checkout:

```bash
bash scripts/integrate-aosp-apps.sh "$HOME/aosp/jalvoro-android17"
```

The integration helper also requires explicit `YES` confirmation and refuses to overwrite existing destination paths. It does not edit your selected product makefile.

Then:

1. Add this line to the selected product's makefile:

   ```make
   $(call inherit-product, device/jalvoro/common/jalvoro_apps.mk)
   ```

2. Confirm the exact Cuttlefish x86_64 lunch target supported by that branch.
3. Build the app modules with `m JalvoroLauncher JalvoroSettings`.
4. Build the selected product image and launch it in Cuttlefish.
5. Run `scripts/smoke-test-device.sh` from this repository against the running emulator. It checks boot completion and basic system identity; it is not a substitute for compatibility tests.
6. Track local changes as patches/branches; never silently replace upstream files.
7. Add platform tests and CTS/VTS work as features mature.

Commands and target names vary by Android release. Do not copy target names from a different release without checking that branch's documentation.

## 5. Security and release gates

- Never commit private signing keys, access tokens, service-account files, or local build artifacts.
- Do not use personal/release signing keys for development builds.
- Document bootloader, Verified Boot, OTA, and key-management decisions before testing on physical devices.
- Do not flash a personal phone until recovery/unbrick steps and device-specific support are verified.
- AOSP does not automatically include Google Mobile Services or the Play Store. Distribution with those services requires separate eligibility, compatibility, and licensing processes.
- Follow upstream component licenses and preserve required notices.

## 6. Success criteria

The environment is not considered complete until:
- `scripts/check-host.sh` reports required tools present.
- A selected AOSP branch syncs successfully.
- The branch's documented Cuttlefish target builds.
- The emulator boots and basic smoke tests pass.
- Build/source versions and known limitations are recorded in a reproducible test report.
