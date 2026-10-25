# Implemented Code Inventory

**Status: two Android app prototypes and a reusable product package fragment are present; full AOSP build and device validation pending.**

## Jalvoro Launcher

Location: `packages/apps/JalvoroLauncher/`

- Android HOME activity.
- Localized labels and UI strings.
- Date and time based on device locale/settings.
- Launchable-app discovery through scoped package visibility.
- App icons, sorted names, live filtering and app launching.
- Resource-based light/dark palettes and themes using Android's day/night resource qualifiers.
- Density-aware layout and basic focus/content descriptions.

## Jalvoro Settings

Location: `packages/apps/JalvoroSettings/`

- Jalvoro-branded settings landing page.
- Sections for Display, Sound, Storage, Wi-Fi, Bluetooth, Privacy, Security, Apps and About.
- Uses Android's standard settings intents for the underlying configuration.
- Localized resources, accessibility descriptions and graceful handling for missing target activities.
- Matching light/dark palettes and themes based on Android's day/night resource qualifiers.

This is a navigation hub, not a replacement for AOSP Settings or custom system services.

## AOSP product integration fragment

Location: `device/jalvoro/common/jalvoro_apps.mk`

The fragment adds both app modules to `PRODUCT_PACKAGES`. Include it from the selected product's makefile using:

```make
$(call inherit-product, device/jalvoro/common/jalvoro_apps.mk)
```

This is intentionally product-neutral. It does not choose the correct AOSP lunch target, make Jalvoro Launcher the default HOME activity, replace Launcher3, modify SystemUI, or create a full OS product.

## Build and integrate

1. Sync the selected official AOSP release and confirm the exact product/lunch target.
2. Keep both modules at their respective `packages/apps/` paths in the AOSP checkout.
3. Copy/integrate `device/jalvoro/common/jalvoro_apps.mk` and include it from the chosen product makefile.
4. Build the modules with `m JalvoroLauncher JalvoroSettings`, then build the selected product image.
5. Boot the image in Cuttlefish. Verify HOME resolution, app visibility/search/launch, settings destinations, day/night mode, rotation, accessibility, and app behavior on the selected Android branch.

## Validation and limitations

GitHub Actions validates repository structure, Bash/Python syntax, Android XML, resource references, launcher package visibility and product-fragment contents. **These checks are not an Android compile.**

No AOSP source tree has been synced in this environment. The modules have not been compiled, installed, booted or CTS-tested. A bootable Jalvoro OS image, custom SystemUI, framework changes, device integration, update signing and optional offline AI remain unimplemented. Do not describe the repository as a finished or bootable operating system until the product image is built and verified.
