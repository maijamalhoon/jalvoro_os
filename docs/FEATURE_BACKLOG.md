# Jalvoro OS Feature Backlog

This backlog is a planning inventory. Nothing here is implemented merely because it appears in this file. Each item needs an issue, acceptance criteria, code, and test evidence before being marked complete.

## P0 — Foundation and baseline

- [ ] Confirm host OS, CPU, RAM, free storage, virtualization support.
- [ ] Select a currently supported AOSP release and pin the manifest revision.
- [ ] Build upstream AOSP for one documented x86_64 virtual target without Jalvoro patches.
- [ ] Boot the target, capture build fingerprint, and run smoke tests.
- [ ] Store build instructions and known limitations in the repository.
- [ ] Establish code ownership, licence, contribution and security-reporting process.

## P1 — Product identity and UX specification

- [ ] Define Jalvoro brand mark, typography, colour tokens, spacing, elevation, motion and icon style.
- [ ] Define light/dark theme and contrast requirements.
- [ ] Specify launcher grid, app drawer, widgets, search and gesture behavior.
- [ ] Specify lock screen, clock, notifications and privacy-sensitive notification behavior.
- [ ] Specify Quick Settings tiles, edit mode, brightness and volume interactions.
- [ ] Define responsive layouts, large-screen behavior, font scaling and accessibility.
- [ ] Create visual regression reference screens for supported emulator sizes.

## P2 — First experience prototype

- [ ] Choose whether the first launcher is a standalone app or platform-integrated launcher.
- [ ] Implement core launcher surfaces and deterministic demo data where needed.
- [ ] Test rotation, process death, configuration changes, large fonts and TalkBack.
- [ ] Document which parts are prototype-only and which are system integrated.

## P3 — System integration

- [ ] Apply resource overlays before patching framework source where feasible.
- [ ] Add custom Settings entry points only when backed by real system behavior.
- [ ] Customize Quick Settings / SystemUI in small, reviewable patches.
- [ ] Add privacy dashboard shortcuts and understandable permission explanations.
- [ ] Verify notifications, recents, screenshot, rotation and app launch regressions.
- [ ] Track upstream conflicts and rebase effort per platform patch.

## P4 — Privacy, security and reliability

- [ ] Threat-model the system UI, privileged apps, update path and debug interfaces.
- [ ] Audit privileged permissions and enforce least privilege.
- [ ] Keep SELinux enforcing; document any proposed policy change and test it.
- [ ] Test app sandbox and permission behavior after platform changes.
- [ ] Define development and release signing-key boundaries.
- [ ] Plan Verified Boot, OTA validation, rollback protection and recovery.
- [ ] Establish security updates and vulnerability response process.
- [ ] Add crash, boot-loop and recovery diagnostics that avoid collecting sensitive data.

## P5 — Platform quality

- [ ] Measure cold boot, app launch, memory pressure and UI jank against upstream baseline.
- [ ] Add battery and thermal testing when a supported device target exists.
- [ ] Validate network, storage, audio, graphics, USB and rotation on the virtual target where supported.
- [ ] Run relevant platform tests; add CTS/VTS when target and integration make them applicable.
- [ ] Document unsupported telephony, camera, NFC, GNSS and other hardware features on virtual targets.

## P6 — Optional offline AI

- [ ] Choose a single user problem before choosing a model.
- [ ] Compare supported on-device runtimes and model formats.
- [ ] Audit model, tokenizer, runtime and dataset licences.
- [ ] Measure model size, peak RAM, latency, energy, thermal impact and output quality.
- [ ] Keep inference on-device by default and make network behavior explicit.
- [ ] Provide disable controls, data deletion, and a non-AI fallback.
- [ ] Do not ship AI in privileged/system paths until threat and privacy reviews pass.

## P7 — Physical device feasibility

- [ ] Choose a specific device only after the virtual target is stable.
- [ ] Verify bootloader unlock, recovery, partitions, device tree, kernel and vendor interface.
- [ ] Audit vendor blob redistribution restrictions.
- [ ] Document unbrick and rollback procedure before first flash.
- [ ] Keep device support claims limited to tested model/variant and build.

## P8 — Release

- [ ] Reproducible build notes and source manifest recorded.
- [ ] Release artifacts signed through controlled process.
- [ ] Validate update package, integrity, rollback and recovery.
- [ ] Complete applicable compatibility, security and regression test reports.
- [ ] Publish component notices, licence information, known issues and supported-device list.
- [ ] Define maintenance owner, release cadence and end-of-support policy.
