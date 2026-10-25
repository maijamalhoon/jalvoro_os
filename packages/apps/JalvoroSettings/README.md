# Jalvoro Settings (prototype)

A lightweight Android app that provides a consistent Jalvoro-branded landing page for common settings.

## Implemented

- Display, sound, storage, Wi-Fi, Bluetooth, privacy, security, apps and about-device entries.
- Opens Android's own settings activities for the actual configuration.
- Localized labels and descriptions in Android string resources.
- Density-aware cards and accessibility content descriptions.
- Graceful feedback when a settings activity is not present.

## Build inside AOSP

Keep this directory at `packages/apps/JalvoroSettings` and include both Jalvoro modules in the selected product package list:

```make
PRODUCT_PACKAGES += \
    JalvoroLauncher \
    JalvoroSettings
```

Then build the module with `m JalvoroSettings`.

## Scope and limitations

This is a settings hub, not a replacement for AOSP Settings or a custom system service. It delegates configuration to Android's standard settings activities, so available pages depend on the chosen product image. It has not been compiled against a synced AOSP tree or tested on Cuttlefish.
