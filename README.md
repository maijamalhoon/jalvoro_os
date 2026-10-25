# Jalvoro OS

**An Android-based operating-system experience, built in phases.**

Jalvoro OS is a long-term project to explore a distinctive, privacy-conscious Android experience. The first engineering target is a virtual Android device. Physical-device support and optional Google Mobile Services are later milestones—not current claims.

> **Status:** Planning, repository foundation, and host-setup automation. This repository does not yet contain a bootable Jalvoro OS image.

## Principles

- **Build on AOSP:** use Android Open Source Project foundations rather than writing an OS and kernel from scratch.
- **Virtual device first:** validate platform changes before considering real hardware.
- **Privacy and security by design:** minimize permissions, protect signing keys, verify updates, and test changes.
- **Offline-first AI:** explore on-device inference only where hardware, performance, and model licences permit.
- **Incremental engineering:** document decisions, keep changes reviewable, and test every milestone.
- **Honest status:** distinguish plans, prototypes, tested features, and release-ready functionality.

## Planned experience

- Custom system UI, launcher, widgets, lock screen, quick settings, and themes
- Useful system apps and coherent settings
- Privacy controls and permission visibility
- Optional offline AI capabilities
- Signed-update strategy and platform compatibility testing

These are goals, not implemented features, until developed and verified.

## Project documents

- [Master plan](docs/MASTER_PLAN.md)
- [Proposed architecture](docs/ARCHITECTURE.md)
- [Initial AOSP baseline proposal](docs/BASELINE.md)
- [Android platform stack map](docs/ANDROID_STACK_MAP.md)
- [Android OS subsystem inventory](docs/SYSTEM_SUBSYSTEMS.md)
- [Development environment setup](docs/DEVELOPMENT_ENVIRONMENT.md)
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
- `scripts/validate-repo.sh` — required-file and Bash syntax validation.

Start with [Development Environment](docs/DEVELOPMENT_ENVIRONMENT.md). Inspect scripts before running them. The setup scripts do not fetch AOSP source, build Android, create signing keys, or flash devices.

**Do not download or build a full AOSP tree until the target branch and machine capacity are confirmed.** The exact Android branch and target must be selected using current official requirements.

## Important licensing notes

AOSP does not automatically include Google's proprietary apps or Google Mobile Services. Those require separate compatibility, eligibility, and licensing steps. Third-party components and AI models must each be reviewed under their own licences. No device compatibility or security certification is claimed.

## Current limitations

This repository establishes project documentation, setup helpers, and basic repository validation only. A bootable image, production security posture, physical-device port, and Google services integration are **not yet implemented**.
