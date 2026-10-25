# Jalvoro Launcher (prototype)

This is the first runnable Jalvoro OS application module, written with Android platform APIs and no third-party runtime dependencies.

## Current features

- Declares itself as a Home/Launcher activity.
- Displays localized time and date.
- Lists launchable apps using Android's package manager.
- Filters the app list as the user types.
- Opens selected apps and handles launch failures without crashing.
- Uses responsive, density-aware platform layouts.

## Build inside AOSP

Place this directory at `packages/apps/JalvoroLauncher` in an AOSP checkout, then include the module in the selected product's package list:

```make
PRODUCT_PACKAGES += \
    JalvoroLauncher
```

Use the exact lunch target documented by the checked-out AOSP branch. Then build the module with:

```bash
m JalvoroLauncher
```

To make it the default home app, the product must also ensure no competing HOME activity has higher resolution priority and the launcher is installed in the image. Product integration and boot validation are still pending.

## Scope and limitations

This is a starter launcher, not a replacement for Android SystemUI. It does not yet implement widgets, recents, gestures, folders, a dock, dynamic theming, lock screen, quick settings, or offline AI. It has not yet been compiled against a synced AOSP tree or tested on Cuttlefish.
