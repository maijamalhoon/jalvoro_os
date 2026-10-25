# Initial AOSP Baseline Proposal

**Status: Proposed; not yet synced or built.**

## Candidate

- **Platform family:** Android Open Source Project (AOSP), current supported Android 17 release line.
- **Manifest branch candidate:** `android17-release`. Google’s current AOSP requirements page identifies this as the latest release branch at the time this document was researched.
- **Virtual target family:** x86_64 Cuttlefish phone target.
- **Build variant:** `userdebug` for development and debugging.
- **Build configuration:** determine the exact release configuration and lunch target from the selected branch's own build environment; do not assume an example target string stays valid across branches.

This is a starting proposal, not a guarantee that the source sync or build will succeed. Re-check the official pages before downloading. Record the manifest commit/revision and the exact lunch target in the test report after the source is synced.

## Why this route

- AOSP is the upstream Android platform, so we can start from a known baseline instead of inventing a new kernel/framework.
- Cuttlefish is a documented Android virtual-device path and reduces early dependence on a specific physical phone.
- x86_64 is a practical target for a compatible x86_64 Linux workstation with KVM enabled.
- A development build is appropriate for early feature work, but must not be treated as a production release.

## Official references

- [Try Android development / current release checkout](https://source.android.com/docs/setup/start)
- [AOSP host requirements](https://source.android.com/docs/setup/start/requirements)
- [Build Android and select a lunch target](https://source.android.com/docs/setup/build/building)
- [Cuttlefish getting started](https://source.android.com/docs/devices/cuttlefish/get-started)

## Before source sync

- [ ] Confirm host OS is a supported 64-bit Linux environment.
- [ ] Confirm actual free disk space (official guidance currently calls for at least 400 GB for checkout plus build output).
- [ ] Confirm actual RAM (official guidance currently calls for at least 64 GB).
- [ ] Confirm KVM/hardware virtualization availability.
- [ ] Re-check the selected branch and exact target on official docs.
- [ ] Capture the exact manifest revision and source sync log.
- [ ] Do not create or use production signing keys.
- [ ] Do not flash physical hardware.

## After source sync

1. Record the checked-out manifest revision and target configuration.
2. Follow the selected branch's documented environment setup.
3. Build the unmodified target first.
4. Launch the matching Cuttlefish image and wait for boot completion.
5. Capture `adb shell getprop ro.build.fingerprint`, test results and logs.
6. Only then begin Jalvoro-specific code changes.
