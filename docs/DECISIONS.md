# Jalvoro OS Engineering Decision Log

Use this log for decisions that materially affect architecture, security, build reproducibility or maintenance. A proposal is not a decision until marked Accepted with a date and rationale.

## Accepted project direction

### D-001 — Base the platform on AOSP
- **Status:** Accepted
- **Decision:** Use Android Open Source Project as the platform foundation rather than writing a kernel/OS from scratch.
- **Reason:** Reuse the Android framework, runtime, security model, build system and compatibility infrastructure.
- **Consequence:** Upstream branch selection, licences, patch maintenance and release cadence are project responsibilities.

### D-002 — Virtual device before physical device
- **Status:** Accepted
- **Decision:** Establish an unmodified AOSP baseline on a documented x86_64 virtual target before device-specific work.
- **Reason:** Reduces early dependence on bootloader unlock, kernel, vendor blobs, modem and device recovery.
- **Consequence:** Emulator results do not prove camera, telephony, GNSS, NFC, battery or physical-device compatibility.

### D-003 — Honest feature status
- **Status:** Accepted
- **Decision:** Separate planned, prototyped, implemented, tested and release-ready states.
- **Reason:** Avoid implying that docs or mockups are functional OS features.
- **Consequence:** Roadmap completion requires evidence and a reproducible test result.

### D-004 — Least-invasive customization first
- **Status:** Accepted
- **Decision:** Prefer resource overlays, configuration and separate apps before deep framework/SystemUI forks when they satisfy the requirement.
- **Reason:** Reduces merge conflicts and makes upstream updates easier.
- **Consequence:** Some requested system-level behaviors will still require platform changes and dedicated tests.

### D-005 — Secrets do not belong in Git
- **Status:** Accepted
- **Decision:** Do not commit signing keys, credentials, tokens, personal data or proprietary artifacts without explicit legal review.
- **Reason:** Prevents avoidable credential exposure and redistribution issues.
- **Consequence:** Release signing must use a separately controlled process.

## Open decisions — do not guess

- **D-006 — Android release/branch:** choose after current official requirements and Cuttlefish target support are checked.
- **D-007 — Host environment:** native Ubuntu versus WSL2; based on the actual PC audit.
- **D-008 — Initial UI implementation:** launcher prototype versus platform overlays/SystemUI; decide from the first UX requirements.
- **D-009 — Original-code licence:** decide before accepting external contributions or publishing reusable libraries.
- **D-010 — First offline AI use case:** choose the problem first; then compare runtime, model licence and hardware costs.
- **D-011 — Physical device:** choose only after baseline and recovery feasibility review.
- **D-012 — Google services:** no assumption of inclusion; separately evaluate compatibility, eligibility and licensing.
- **D-013 — Public/private repository:** choose based on project goals and secrets/IP policy.

## Decision template

For each new decision, record: ID, date, status, context, options considered, chosen option, rationale, security/licensing impact, and revisit trigger.
