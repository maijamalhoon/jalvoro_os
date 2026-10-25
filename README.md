# Jalvoro OS

**An Android-based operating-system experience, built in phases.**

Jalvoro OS is a long-term project to explore a distinctive, privacy-conscious Android experience. The first engineering target is a virtual Android device. Physical-device support and optional Google Mobile Services are later milestones—not current claims.

> **Status:** Planning and repository foundation. This repository does not yet contain a bootable Jalvoro OS image.

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

## Start here

1. [Master plan](docs/MASTER_PLAN.md)
2. [Proposed architecture](docs/ARCHITECTURE.md)
3. [Roadmap](ROADMAP.md)
4. [Contribution workflow](CONTRIBUTING.md)
5. [Security policy](SECURITY.md)

## Initial development direction

The intended platform-development environment is a supported Ubuntu LTS machine with enough RAM and storage for an AOSP checkout and build. The first target is an x86_64 virtual device such as Cuttlefish. The exact Android branch and host requirements will be pinned after the development machine is audited.

**Do not download or build a full AOSP tree until the target branch and machine capacity are confirmed.**

## Important licensing notes

AOSP does not automatically include Google's proprietary apps or Google Mobile Services. Those require separate compatibility, eligibility, and licensing steps. Third-party components and AI models must each be reviewed under their own licences. No device compatibility or security certification is claimed.

## Current limitations

This repository establishes documentation and workflow only. A bootable image, production security posture, physical-device port, and Google services integration are **not yet implemented**.
