# Android Platform Stack Map

Jalvoro OS is an AOSP-based project, not a new kernel or a rewrite of Android. This is a scope map: listing a subsystem does not mean it is implemented or enabled yet.

## Platform layers

| Layer | Upstream Android/AOSP area | Jalvoro approach |
|---|---|---|
| Boot chain | Bootloader interfaces, AVB, boot image | Keep upstream interfaces; device-specific work later |
| Linux kernel | Kernel/common or device/vendor kernel | Select a compatible kernel/device target; do not invent hardware support |
| Native system | Bionic, linker, init, SELinux, native daemons | Preserve upstream security boundaries |
| Hardware abstraction | AIDL HALs, VINTF, vendor interface | Use compatible reference/device implementations |
| System services | system_server, framework services | Add changes incrementally with tests |
| Runtime | ART, core libraries | Prefer upstream runtime |
| IPC | Binder, AIDL, intents, content providers | Follow platform permission and compatibility contracts |
| UI framework | Android framework, WindowManager, SystemUI | Customize experience without breaking platform contracts |
| Launcher | AOSP launcher or a separately maintained launcher | Develop Jalvoro launcher after baseline boots |
| Apps | Settings, SystemUI, permissions, files, dialer, etc. | Inventory and customize one app at a time |
| Graphics | SurfaceFlinger, HWComposer, Vulkan/OpenGL ES | Depend on supported graphics stack; RTX on host does not imply guest Android GPU acceleration |
| Media | MediaCodec, Media3/app stack, audio services | Preserve codec licensing and device capabilities |
| Connectivity | Wi-Fi, Bluetooth, NFC, USB, Ethernet | Hardware/vendor dependent; test each target separately |
| Telephony | Radio HAL, telephony framework | Requires supported modem/device; not available just because emulator boots |
| Location | GNSS, location providers | Emulator simulation first; device-specific later |
| Security | SELinux, permissions, Keystore/KeyMint, Gatekeeper, AVB | Security changes require threat model and regression tests |
| Storage | vold, FBE, adoptable storage, filesystems | Test data lifecycle and encryption behavior |
| Power | Doze, App Standby, thermal and battery services | Hardware-dependent validation |
| Updates | A/B or Virtual A/B OTA, update_engine | Design and test before physical deployment |
| Compatibility | CDD, CTS, VTS, GTS where applicable | Add formal compatibility validation as target matures |
| Developer tooling | repo, Soong, Ninja, Clang, adb, fastboot, emulator/Cuttlefish | Pin versions and keep logs |
| Optional AI | Android ML APIs / on-device runtimes | Separate optional feature; evaluate memory, latency, privacy, licences |

For the more detailed inventory of framework, kernel, security, graphics, media, connectivity, power, update, and test subsystems, see [System Subsystems](SYSTEM_SUBSYSTEMS.md).

## Development stages

1. **Host readiness:** Linux, toolchain packages, disk, KVM.
2. **Known-good baseline:** pinned AOSP release builds unchanged.
3. **Virtual device:** boot Cuttlefish and record smoke-test results.
4. **Product identity:** branding, launcher, wallpaper, icons, first-run experience.
5. **System UX:** Settings, Quick Settings, notifications, recents, gestures, lock screen.
6. **Platform features:** privacy controls, accessibility, app permissions, backup, battery and performance.
7. **Optional services:** offline AI, only after measuring hardware requirements and reviewing licences.
8. **Device port:** only with a specific supported device, vendor blobs/firmware, and recovery plan.
9. **Release hardening:** AVB, signing, OTA, SELinux audit, CTS/VTS, security update process.

## Definition of done

A subsystem is done only when there is a defined behavior, code change, automated/manual test, device/target scope, known limitations, and a recorded result. A roadmap item or design mockup is not evidence of implementation.
