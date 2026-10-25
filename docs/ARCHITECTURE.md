# Proposed Architecture

This document describes a design direction, not code already implemented.

```text
Jalvoro experience
  ├── Launcher, widgets, themes
  ├── Quick settings, lock screen, System UI
  └── Selected system apps
            |
Android framework and system services
            |
Native libraries and hardware abstraction layers
            |
Linux kernel and virtual/device hardware
```

Cross-cutting concerns: reproducible builds, permissions, privacy, testing, signing, updates, and licence compliance.

## Design rules
- Start with the least invasive implementation that meets the requirement.
- Prefer resource overlays and configuration before forking core framework code.
- Keep custom apps separate from privileged platform components where possible.
- Document the purpose and permission needs of every privileged component.
- Track upstream changes so rebases remain manageable.
- Keep secrets out of source control and CI logs.
- Review AI models and runtimes as third-party dependencies.

## Initial target
An x86_64 virtual device is the first target because it avoids early dependence on a specific phone's bootloader, kernel, modem, camera, and vendor blobs.

## Possible future boundaries
These are conceptual modules; create them only when a concrete implementation needs them.
- `jalvoro-ui`: visual tokens, icons, design references, UI specifications
- `platform-overlays`: scoped AOSP resource/configuration overlays
- `systemui`: changes not achievable through overlays
- `system-apps`: selected Jalvoro applications
- `device-config`: virtual target and later device configuration
- `tests`: automated checks and regression plans

## Build and release flow
1. Pin the AOSP revision and document host dependencies.
2. Fetch source using official AOSP instructions.
3. Build the unmodified baseline.
4. Apply one small patch and rebuild.
5. Run relevant tests and record results.
6. Produce signed artifacts only through a controlled release process.
7. Publish no release-ready claim without test evidence and known-issues notes.