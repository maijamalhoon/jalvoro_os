# Jalvoro OS Development Environment

This document defines a reproducible, cautious setup path for the Jalvoro OS AOSP project.

## What this setup does

- Installs common Ubuntu host packages used for Android platform development.
- Adds a host preflight script for CPU, memory, disk, Java, repo, and KVM checks.
- Creates `~/aosp` as the intended workspace.
- Does **not** download hundreds of gigabytes of source, choose an Android release, create signing keys, flash a device, or claim that Jalvoro is bootable.

## Host recommendation

- x86_64 CPU with hardware virtualization enabled in firmware.
- 64 GB RAM is a practical target for large modern Android platform builds; more helps parallel builds.
- Reserve roughly 400 GB or more for a checkout and build output; 1 TB or more is more comfortable for multiple branches/builds. Actual needs vary by Android branch and build targets.
- Ubuntu LTS on a native Linux filesystem is the preferred first setup. WSL2 may be possible, but native Linux is preferred for predictable I/O and virtualization. If using WSL2, keep source and output under the Linux home filesystem, not `/mnt/c`.
- NVIDIA RTX graphics is not required for the AOSP platform build; CPU, RAM, storage I/O, and virtualization matter more.

## 1. Prepare Ubuntu

On a clean Ubuntu LTS installation, clone the repository and switch to this development branch:

```bash
git clone https://github.com/maijamalhoon/jalvoro_os.git
cd jalvoro_os
git switch feature/dev-environment
```

Inspect scripts before running them. Then install host dependencies:

```bash
bash scripts/setup-ubuntu.sh
```

This script uses apt and sudo to change system packages. It asks before proceeding. Do not run it on a production/server machine without reviewing the package list.

## 2. Check the host

```bash
bash scripts/check-host.sh
```

Resolve missing tools, insufficient disk space, or unavailable virtualization before syncing AOSP.

## 3. Choose an Android baseline before syncing

Do not use an unpinned `repo init` command in a long-lived project. Select a supported Android release/branch after checking the official AOSP requirements and the intended Cuttlefish target. Record the exact manifest branch/tag and build target in project docs before downloading source.

Official references:
- AOSP setup: https://source.android.com/docs/setup/start
- AOSP host requirements: https://source.android.com/docs/setup/start/requirements
- Download source: https://source.android.com/docs/setup/download
- Build Android: https://source.android.com/docs/setup/build/building
- Cuttlefish: https://source.android.com/docs/devices/cuttlefish
- Android compatibility: https://source.android.com/docs/compatibility

## 4. Source and build workflow (after baseline approval)

The expected workflow is:

1. Create a dedicated source workspace such as `~/aosp/jalvoro`.
2. Initialize the AOSP manifest using the selected, pinned branch.
3. Sync source; verify free disk space and preserve the sync logs.
4. Select the exact Cuttlefish x86_64 lunch target supported by that branch.
5. Build with `m` and a conservative parallelism setting, then increase based on RAM/thermal behavior.
6. Launch the matching Cuttlefish image and run smoke tests.
7. Track local changes as patches/branches; never silently replace upstream files.
8. Add platform tests and CTS/VTS work as features mature.

Commands and target names vary by Android release. Do not copy target names from a different release without checking the branch's documentation.

## 5. Security and release gates

- Never commit private signing keys, access tokens, service-account files, or local build artifacts.
- Do not use personal/release signing keys for development builds.
- Keep bootloader, Verified Boot, OTA, and key-management decisions documented before testing on physical devices.
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
