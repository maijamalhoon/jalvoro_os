# Jalvoro OS

**An Android-based operating-system experience, built in phases.**

Jalvoro OS is a long-term project to explore a distinctive, privacy-conscious Android experience. The first engineering target is a virtual Android device. Physical-device support and optional Google Mobile Services are later milestones—not current claims.

> **Status:** Repository foundation plus two Android application prototypes. A bootable Jalvoro OS image has not yet been built or verified.

## Principles

- **Build on AOSP:** use Android Open Source Project foundations rather than writing an OS and kernel from scratch.
- **Virtual device first:** validate platform changes before considering real hardware.
- **Privacy and security by design:** minimize permissions, protect signing keys, verify updates, and test changes.
- **Offline-first AI:** explore on-device inference only where hardware, performance, and model licences permit.
- **Incremental engineering:** document decisions, keep changes reviewable, and test every milestone.
- **Honest status:** distinguish plans, prototypes, tested features, and release-ready functionality.

## Implemented code

### Jalvoro Launcher

A Soong app module at [packages/apps/JalvoroLauncher](packages/apps/JalvoroLauncher/README.md).

- HOME activity declaration and localized app strings.
- Localized date/time display and app icons.
- Launchable-app discovery using scoped package visibility.
- Live app-name search/filter and app launching.
- Density-aware platform UI and basic accessibility descriptions.

### Jalvoro Settings

A Soong app module at [packages/apps/JalvoroSettings](packages/apps/JalvoroSettings/README.md).

- A unified Jalvoro-styled settings landing page.
- Organized Display, Sound, Storage, Wi-Fi, Bluetooth, Privacy, Security, Apps and About sections.
- Opens the corresponding Android system settings activities instead of bypassing Android's own security controls.
- Localized resource strings, accessible card descriptions and graceful handling if a settings page is unavailable.

**Important:** Both apps are prototypes. The Settings app is a styled entry point to existing Android settings, not yet a replacement for AOSP Settings. Neither module has been compiled against a synced AOSP tree or boot-tested on Cuttlefish. See [Implemented Code Inventory](docs/IMPLEMENTED_CODE.md).

## Planned experience

- Custom SystemUI, lock screen, quick settings, widgets, navigation and theme engine
- Deeper settings integration and privacy dashboards
- System apps and carefully integrated platform changes
- Optional offline AI capabilities
- Signed-update strategy, compatibility testing and device ports

These remain goals until implemented and verified.

## Project documents

- [Master plan](docs/MASTER_PLAN.md)
- [Proposed architecture](docs/ARCHITECTURE.md)
- [Initial AOSP baseline proposal](docs/BASELINE.md)
- [Android platform stack map](docs/ANDROID_STACK_MAP.md)
- [Android OS subsystem inventory](docs/SYSTEM_SUBSYSTEMS.md)
- [Development environment setup](docs/DEVELOPMENT_ENVIRONMENT.md)
- [Implemented code inventory](docs/IMPLEMENTED_CODE.md)
- [Feature backlog](docs/FEATURE_BACKLOG.md)
- [Engineering decisions](docs/DECISIONS.md)
- [Build and release policy](docs/BUILD_AND_RELEASE.md)
- [Privacy policy for optional on-device AI](docs/AI_POLICY.md)
- [Testing checklist](docs/TESTING.md)
- [Cross-layer test matrix](docs/TEST_MATRIX.md)
- [Roadmap](ROADMAP.md)
- [Contribution workflow](CONTRIBUTING.md)
- [Security policy](SECURITY.md)

## Development setup

The repository includes:
- `scripts/prepare-wsl.ps1` — optional Windows helper to request WSL2 + Ubuntu installation.
- `scripts/setup-ubuntu.sh` — interactive Ubuntu dependency bootstrap.
- `scripts/check-host.sh` — host diagnostic report.
- `scripts/build-aosp.sh` — guarded build helper for a source checkout and explicitly selected branch target.
- `scripts/smoke-test-device.sh` — basic ADB boot and system identity smoke test.
- `scripts/validate-repo.sh`, `scripts/validate-launcher.sh`, and Python resource validators — source-level and repository checks.

Start with [Development Environment](docs/DEVELOPMENT_ENVIRONMENT.md). Inspect scripts before running them. The setup scripts do not sync AOSP source, build the full OS, create signing keys, or flash devices.

**Do not download or build a full AOSP tree until the target branch and machine capacity are confirmed.** See the official [AOSP host requirements](https://source.android.com/docs/setup/start/requirements).

## Important licensing notes

AOSP does not automatically include Google's proprietary apps or Google Mobile Services. Those require separate compatibility, eligibility, and licensing steps. Third-party components and AI models must each be reviewed under their own licences. No device compatibility or security certification is claimed.

## Current limitations

A bootable image, production security posture, physical-device port, complete custom SystemUI/settings, offline AI, and Google services integration are **not yet implemented**. The two Android app modules are early milestones and still require a real AOSP compile and device testing.
