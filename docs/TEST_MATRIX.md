# Android Validation Matrix

This matrix identifies what to validate. It does not mean any listed test has passed. Mark results only with the target, build fingerprint, steps, logs and date.

| Area | Baseline check | Later Jalvoro regression |
|---|---|---|
| Boot | Virtual target reaches home screen | Reboot and recovery after changes |
| Build | Pinned source builds successfully | Repeatable build from documented revision |
| UI | Settings and launcher open | Layout, rotation, font scaling, animations |
| Apps | Install and launch test APK | Lifecycle, process death, configuration changes |
| Permissions | Prompt and denial behavior | No unexpected privilege escalation |
| Notifications | Receive and dismiss test notification | Lock-screen privacy and channel behavior |
| SystemUI | Quick Settings opens | Tiles, brightness, volume, recents, screenshots |
| Storage | Read/write test app data | Encryption/data preservation where supported |
| Networking | Supported virtual network connectivity | Reconnect, permissions and privacy behavior |
| Graphics | Render surfaces without crash | Frame timing and visual regression |
| Audio | Virtual audio check if supported | Focus, route and volume behavior |
| Accessibility | TalkBack and font scaling | Labels, focus order, contrast and touch targets |
| Security | SELinux mode and relevant logs | Policy review and negative tests |
| OTA | Not applicable to first baseline | Signature, rollback, interruption and recovery |
| AI | Not part of initial baseline | Licence, privacy, quality, RAM, latency and disable behavior |
| Hardware | Record virtual-device limitations | Test each actual device/variant independently |
| Compatibility | Identify relevant platform tests | CTS/VTS or other applicable suites |

## Test report template

- Date/time:
- AOSP manifest revision:
- Jalvoro commit:
- Host OS and hardware:
- Build target and fingerprint:
- Test case:
- Steps:
- Expected result:
- Actual result:
- Pass/fail/blocked:
- Logs/artifacts:
- Known limitations:
