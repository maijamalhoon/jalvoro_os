# Jalvoro Control Center

A launchable, dependency-free Android control hub included in the Jalvoro AOSP prototype.

## Current behavior
- Branded, accessible settings cards with custom, dependency-free Canvas icons.
- Delegates Wi-Fi, Bluetooth, display, sound, battery, privacy and device information to Android settings activities.
- Uses Android light/dark resource selection.
- Draws distinct Wi-Fi, Bluetooth, display, sound, battery, privacy and information symbols at runtime.
- No third-party SDKs, network calls, analytics or special permissions.

## Important boundary
This is **not the privileged SystemUI Quick Settings shade**. Android reserves direct control of several radios and system surfaces for platform components and privileged permissions. This app delegates those actions to Android settings instead of pretending to toggle them.

## Build integration
Soong module: JalvoroControlCenter. Include it through device/jalvoro/common/jalvoro_apps.mk. Actual compilation and runtime validation require an AOSP checkout and have not yet been performed.
