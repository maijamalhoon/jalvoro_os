# Implemented Code Inventory

**Status: first Android application prototype added; full AOSP build and device validation pending.**

## Jalvoro Launcher

Location: `packages/apps/JalvoroLauncher/`

The initial Java/Soong module provides a real Android HOME activity with:
- Localized app labels and UI strings in Android resources.
- Date and time using the device's locale and time settings.
- Launchable-app discovery using scoped Android package visibility rather than requesting broad `QUERY_ALL_PACKAGES` access.
- App icons, alphabetically sorted names, and live text filtering.
- App launching with basic failure feedback.
- Density-aware platform layouts and basic focus/content-description support.

### Build and integrate

1. Sync the selected official AOSP release and confirm the exact lunch target.
2. Keep this module at `packages/apps/JalvoroLauncher` in the AOSP checkout.
3. Add `JalvoroLauncher` to the chosen product's `PRODUCT_PACKAGES`.
4. Build the module using `m JalvoroLauncher`, then build the selected product image.
5. Boot the image in Cuttlefish and verify HOME resolution, app discovery, search, app launch, rotation, accessibility, and package visibility.

### Explicitly not done yet

No AOSP source tree has been synced in this environment. The app has not been compiled, installed, booted, or CTS-tested. The repository's CI performs source/file and shell-syntax checks only; it is not an Android build. This module is the first code milestone, not a bootable Jalvoro OS image. SystemUI, custom settings, framework changes, device integration, update signing, and optional offline AI remain separate engineering work.
