# Android OS Subsystem Inventory

This inventory defines the major Android operating-system subsystems relevant to Jalvoro OS. It is a scope map, not a claim that Jalvoro has implemented or tested them. Availability varies by Android branch, virtual target, hardware, and vendor support.

## Boot and low-level platform

- **Boot chain / boot image:** bootloader interface, boot image formats, kernel and ramdisk handoff, boot state.
- **Linux kernel:** scheduler, memory management, device drivers, namespaces, cgroups, networking, filesystems and kernel security.
- **Android init:** service startup, property system, filesystem setup, service lifecycle and triggers.
- **SELinux:** mandatory access control, domains, labels and policy enforcement.
- **Verified Boot (AVB):** boot-chain integrity and rollback protections where supported.
- **Dynamic partitions / partition metadata:** partition layout and update compatibility; device-specific.
- **Recovery / fastboot:** maintenance and recovery interfaces; physical-device support is not implied by a virtual target.

## Hardware abstraction and vendor boundary

- **HALs:** hardware abstraction interfaces, generally AIDL for current interfaces and legacy HIDL where still required.
- **VINTF:** vendor/system interface compatibility declarations and manifests.
- **Vendor interface / proprietary blobs:** device-specific code and firmware, subject to compatibility and redistribution rules.
- **Power, thermal, sensors and lights HALs:** actual behavior depends on target hardware.
- **Camera, audio, graphics, radio and biometrics HALs:** cannot be assumed available on a generic virtual target.

## Core runtime and application framework

- **Bionic libc and dynamic linker:** native process runtime.
- **ART:** Android Runtime, managed code execution, compilation and garbage collection.
- **Core libraries:** Java/Kotlin platform APIs.
- **Binder IPC:** core inter-process communication and service calls.
- **AIDL:** interface definitions for IPC and HAL/service boundaries.
- **system_server:** core Android framework services.
- **Package Manager:** package installation, signatures, updates and component metadata.
- **Activity / Task / Window managers:** activity lifecycle, tasks, windows, display policy and input routing.
- **Permission controller / AppOps:** runtime permissions, special access and operation tracking.
- **Content providers, intents and broadcasts:** app integration and inter-app communication.
- **JobScheduler, alarms and background limits:** scheduling and power-aware execution.
- **Keystore / KeyMint / Gatekeeper:** key protection and authentication support as provided by the target.
- **Credential-encrypted and device-encrypted storage:** Android file-based encryption behavior, hardware support dependent.

## User experience and system applications

- **SystemUI:** status bar, navigation, notifications, Quick Settings, keyguard and related system surfaces.
- **Launcher / home app:** app drawer, home screen, widgets, search and gestures.
- **Settings:** platform configuration and system controls.
- **Lock screen / keyguard:** authentication and privacy-aware locked state.
- **Notifications:** channels, ranking, notification listener access and lock-screen visibility.
- **Recents / task switcher:** task overview and app switching.
- **Input method framework:** keyboards, IME lifecycle and language input.
- **Accessibility:** accessibility services, TalkBack compatibility, magnification, captions and large text.
- **Text-to-speech and speech services:** service and language availability dependent.
- **Wallpaper, widgets, shortcuts and sharing UI:** framework APIs and supported launchers.
- **First-party apps:** optional separately maintained apps; keep them separate from privileged platform code where possible.

## Graphics, display and media

- **SurfaceFlinger:** composition of application and system surfaces.
- **Hardware Composer (HWC):** display composition interface; implementation depends on graphics stack.
- **OpenGL ES / Vulkan / EGL:** graphics APIs and driver capabilities.
- **DisplayManager / WindowManager:** display topology, density, orientation and window policy.
- **Media framework:** media sessions, playback, recording and routing.
- **MediaCodec:** codec interfaces; codec availability and licensing vary.
- **AudioFlinger / AudioPolicy:** mixing, routing, focus and audio policy.
- **Camera framework / Camera2:** camera APIs; camera access requires compatible HAL and permissions.
- **DRM:** protected media support depends on licensed components and hardware.
- **WebView:** web content component; provider/version and distribution conditions must be reviewed.

## Connectivity and device interaction

- **Wi-Fi / Ethernet:** networking, permissions, configuration and connectivity monitoring.
- **Bluetooth:** profiles and services depend on controller and stack support.
- **NFC:** requires a supported NFC controller and HAL.
- **USB / USB-C:** host/device roles, accessory modes and permissions depend on hardware.
- **Telephony / Radio HAL:** modem, SIM/eSIM, radio interface and carrier features require device support.
- **Location / GNSS:** location providers and GNSS hardware or simulation.
- **Sensors:** accelerometer, gyroscope, proximity, light and other sensors.
- **Printing / casting / nearby device features:** capabilities depend on included services and external protocols.

## Power, reliability and maintenance

- **PowerManager / Doze / App Standby:** background execution and idle policy.
- **Thermal management:** thermal signals and throttling require suitable hardware support.
- **Watchdog / health services:** platform health and recovery signals.
- **Stats / tracing / diagnostics:** performance observability with privacy-aware log handling.
- **Backup and restore:** supported transport and user-data policy.
- **OTA / update_engine:** update package verification and installation; exact support depends on target.
- **A/B or Virtual A/B updates:** partition and snapshot support depends on the device configuration.
- **Rollback protection and recovery:** must be designed and tested before any physical-device release.

## Security and trust

- **App sandbox and UID separation**
- **Runtime permissions and special access**
- **SELinux enforcement**
- **Verified Boot and rollback protections**
- **Keystore / hardware-backed keys where supported**
- **Biometrics framework:** actual sensors and secure hardware required for meaningful device integration.
- **Network security configuration and certificate handling**
- **Security patch management and vulnerability response**
- **Debug access / ADB controls**
- **Privacy indicators, permission history and data access transparency**

## Build, test and compatibility infrastructure

- **Repo manifests and Git:** multi-repository source management.
- **Soong / Blueprint, Ninja and Clang:** Android platform build pipeline.
- **Kati / Make compatibility:** used by parts of the build depending on branch.
- **Bazel / Kleaf:** relevant to supported kernel build workflows, not a replacement for every Android build step.
- **ADB / fastboot:** debugging and device interaction.
- **Cuttlefish:** virtual Android device.
- **Unit / integration / platform tests:** selected based on the changed component.
- **CTS / VTS:** compatibility and vendor-interface validation when applicable.
- **STS and security testing:** relevant security test suites depending on branch and distribution goals.
- **Build provenance, artifact hashes and release notes:** evidence needed for repeatable releases.

## Jalvoro implementation rule

Do not rewrite every subsystem just to say it is custom. Preserve upstream Android components unless there is a clear, testable product requirement to change them. For each change, record:

1. Requirement and user benefit.
2. Upstream component and files affected.
3. Whether a resource overlay or separate app is sufficient.
4. Required privileges and security implications.
5. Target/hardware assumptions.
6. Automated and manual tests.
7. Rebase and maintenance cost.
8. Licence and redistribution impact.

A generic Cuttlefish boot validates only the subsystems supported by that virtual target; it does not prove physical phone hardware support.
