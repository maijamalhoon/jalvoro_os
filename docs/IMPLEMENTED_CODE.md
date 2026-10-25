# Implemented Code Inventory

**Status: first application prototype added; AOSP build and device validation pending.**

## Jalvoro Launcher

Location: `packages/apps/JalvoroLauncher/`

The initial Java/Soong module provides a real Android HOME activity with an app list, live text filtering, app launch handling, localized date/time, and a lightweight adaptive layout. It uses platform Android widgets and does not add third-party libraries.

### Build and integrate

1. Sync the selected official AOSP release and confirm the exact lunch target.
2. Copy/keep this module in `packages/apps/JalvoroLauncher`.
3. Add `JalvoroLauncher` to the chosen product's `PRODUCT_PACKAGES`.
4. Build using `m JalvoroLauncher`, then build the product image.
5. Boot the image in Cuttlefish and verify HOME resolution, app discovery, search, app launch, rotation and accessibility.

### Explicitly not done yet

No AOSP source tree has been synced here. The app has not been compiled, installed, booted, or CTS-tested. This module is the first code milestone, not a bootable Jalvoro OS image. SystemUI, settings, framework changes, device integration, update signing and optional offline AI remain separate engineering work.
