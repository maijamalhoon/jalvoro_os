# Jalvoro OS — Master Plan

## Vision
Create a polished Android-based platform with a coherent design language, useful system-level customization, strong privacy defaults, and optional offline AI. The ambition is broad, but delivery must be phased and measurable.

**Current phase:** planning and repository foundation. No bootable Jalvoro build is available yet.

## Scope
- AOSP-based platform experimentation
- Custom launcher, widgets, System UI, quick settings, lock screen, themes, and selected system apps
- Privacy/security improvements that can be implemented and tested
- Offline AI research with documented hardware and licence constraints
- Virtual-device validation first; physical-device research later
- Build automation, tests, release notes, and reproducible engineering practices

### Not in the initial scope
- Writing a new kernel or Android replacement from scratch
- Claiming support for every phone
- Bundling proprietary Google services without required approvals
- Shipping an unverified build as secure or production-ready
- Promising features before feasibility and maintenance costs are known

## Engineering sequence
1. Audit the development machine and available storage.
2. Select and pin a supported AOSP branch.
3. Build a clean baseline for a virtual-device target.
4. Record the build process and test results.
5. Implement small, reversible platform changes.
6. Build the Jalvoro design system and user-facing experience.
7. Add privacy controls and test actual enforcement.
8. Evaluate offline AI models based on memory, latency, power, and licence.
9. Add compatibility, regression, and security testing.
10. Consider physical devices only after a stable virtual milestone.

## Proposed technical stack

| Area | Initial direction | Notes |
|---|---|---|
| Platform | Android Open Source Project (AOSP) | Pin one supported branch first |
| First target | x86_64 virtual device / Cuttlefish | Avoid premature phone-specific work |
| Host | Supported Ubuntu LTS | Confirm official requirements |
| Build | repo, Soong, Ninja, Clang | Follow the selected branch's docs |
| Platform code | Java/Kotlin, C/C++; Rust where supported | Avoid unnecessary framework forks |
| Custom apps | Kotlin; Compose where appropriate | Depends on system integration |
| Source control | Git and GitHub | Small commits and reviewable changes |
| Testing | Platform tests, unit tests, emulator checks, CTS where applicable | Tests do not prove total security |
| Offline AI | Evaluate LiteRT and compatible runtimes | Select models only after licence/hardware review |

These are provisional choices. Confirm version compatibility against official documentation for the selected Android branch.

## Architecture layers
1. **Jalvoro experience:** visual language, launcher, widgets, lock screen, quick settings, themes.
2. **System applications:** settings and selected first-party apps.
3. **Android framework/services:** modify only when higher-level approaches cannot meet the requirement.
4. **Native libraries and HAL:** preserve upstream interfaces where possible.
5. **Kernel and device support:** defer device-specific work until a target device is selected.
6. **Build, test, release:** reproducible builds, automated checks, signing, and release procedures.

Prefer overlays, modular components, and narrow patches over broad upstream rewrites.

## Security and privacy requirements
- Never commit private signing keys, passwords, access tokens, or personal data.
- Keep release credentials outside source control and restrict access.
- Preserve Android permission and sandbox boundaries.
- Document every privileged permission and its purpose.
- Plan signed artifacts, verified updates, and recovery before real-device release.
- Establish a security-update policy before public distribution.
- Review third-party components and AI model licences.
- Test privacy claims rather than relying on UI appearance alone.

## Licensing
- AOSP components have their own licences and notices.
- Kernel modifications and distribution must follow applicable GPLv2 obligations.
- Preserve copyright and licence notices.
- Review all bundled components and AI models before redistribution.
- Google Play and Google Mobile Services are not part of AOSP by default.
- Avoid trademarks that imply endorsement.
- Choose a project-wide licence only after deciding what original code will be open source.

## Decisions still open
- Host PC CPU, RAM, free disk, GPU, and operating system
- Exact AOSP branch and virtual target
- UI approach: overlays first or deeper System UI/framework changes
- First offline AI use case and resource budget
- Public versus private development
- Physical device target, after emulator milestones
- Original-code licensing and release policy

## Definition of done
Every milestone records the AOSP revision, host environment, build steps, test results, known issues, and artifact location. Planned features must never be presented as implemented.