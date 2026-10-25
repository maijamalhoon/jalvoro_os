# Jalvoro OS Testing Checklist

Record Android release/manifest revision, host OS, CPU/RAM, build target, build command, image revision, test date, logs, and pass/fail for every test session.

## Host preflight

- [ ] Host is x86_64 Linux and AOSP branch requirements are met.
- [ ] Free disk space is sufficient for source + output.
- [ ] Java/Python/Git/repo are available as required by selected branch.
- [ ] KVM is accessible when needed.
- [ ] Source and build output are outside Windows-mounted folders when using WSL2.

## Baseline build and emulator

- [ ] AOSP sync completed without unresolved errors.
- [ ] Build completed with exit code 0.
- [ ] Cuttlefish/selected virtual device starts and reaches the home screen.
- [ ] `adb devices` lists the expected emulator/device.
- [ ] `adb shell getprop ro.build.fingerprint` records the image identity.
- [ ] Reboot works and the device returns to the home screen.
- [ ] Basic Settings screens open without repeated crashes.
- [ ] Logcat has no new fatal crash associated with the change under test.
- [ ] Network, sound, rotation, screenshots, and app installation checked where supported by the target.

## Regression for every change

- [ ] Change has a narrow scope and a linked issue/plan.
- [ ] Relevant unit, integration, or platform tests run.
- [ ] Manual steps and observed result are recorded.
- [ ] Logs and screenshots contain no secrets or personal data.
- [ ] No private keys, credentials, proprietary blobs, or build output were committed.

## Later release gates

- [ ] Permission and privacy regression tests.
- [ ] SELinux enforcing mode and denial review.
- [ ] Verified Boot and signing review.
- [ ] OTA install, rollback/recovery, and data-preservation tests.
- [ ] CTS/VTS or other applicable compatibility suites.
- [ ] Security update and vulnerability response plan.
