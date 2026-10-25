# Jalvoro Launcher (prototype)

This is an AOSP Soong application module for the Jalvoro home screen, using Android platform APIs and no third-party runtime dependencies.

## Current features

- Declares itself as a Home/Launcher activity.
- Displays localized time and date.
- Discovers launchable apps using scoped package visibility, without requesting broad `QUERY_ALL_PACKAGES` access.
- Shows app icons and alphabetically sorted labels.
- Filters the app list as the user types.
- Opens selected apps and handles launch failures.
- Uses density-aware layouts and basic accessibility descriptions.

## Build inside AOSP

Place this directory at `packages/apps/JalvoroLauncher` in an AOSP checkout, then include both Jalvoro app modules in the selected product's package list:

```make
PRODUCT_PACKAGES += \
    JalvoroLauncher \
    JalvoroSettings
```

Use the exact lunch target documented by the checked-out AOSP branch. Then build the launcher module with:

```bash
m JalvoroLauncher
```

To make it the default home app, the product must ensure no competing HOME activity has higher resolution priority and that the launcher is installed in the image. Product integration and boot validation are still pending.

## Scope and limitations

This is a starter launcher, not a replacement for Android SystemUI. Widgets, recents, gestures, folders, dock favorites, dynamic theming, lock screen, quick settings, and offline AI are not implemented. The app has not yet been compiled against a synced AOSP tree or tested on Cuttlefish.
