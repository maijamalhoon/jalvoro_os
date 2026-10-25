# Build, Artifact and Release Policy

## Development builds

- Start from a recorded AOSP manifest revision and clean source state.
- Record host OS, CPU, RAM, disk capacity, tool versions, build target, command and exit status.
- Keep generated output outside tracked source unless upstream explicitly requires otherwise.
- Store build logs as CI artifacts only after checking they contain no secrets or sensitive local paths.
- A successful compile is not proof of successful boot or feature correctness.

## Artifact stages

1. **Source-synced:** manifest revision recorded; source download completed.
2. **Build-passed:** documented build command exits successfully.
3. **Boot-verified:** target boots and smoke checks pass.
4. **Feature-tested:** tests for a specific change pass and limitations are recorded.
5. **Release-candidate:** security, compatibility, update and recovery gates are reviewed.
6. **Released:** artifacts, hashes, signatures, notices, support scope and known issues are published.

Never skip stages in status claims.

## Signing and update security

- Use disposable/test keys for local development only.
- Keep release keys out of the repository, ordinary CI logs, and general-purpose developer workstations.
- Restrict key access and document backup/rotation/revocation responsibilities.
- Before physical deployment, design and test Verified Boot, signed OTA packages, rollback protection and recovery.
- Never tell users to flash an image without device-specific verification and a recovery path.

## Release checklist

- [ ] Source revision and build environment recorded.
- [ ] Build and boot evidence stored.
- [ ] Relevant automated and manual tests passed.
- [ ] Security and privacy changes reviewed.
- [ ] OTA integrity, rollback and recovery tested if updates are included.
- [ ] Device model/variant support explicitly listed.
- [ ] Unsupported features and known issues published.
- [ ] Third-party notices and redistribution rights checked.
- [ ] Artifact checksums and signing information published.
- [ ] Maintenance owner and security update policy identified.

## Google services

AOSP source does not automatically provide proprietary Google Mobile Services or Play Store. Do not bundle or advertise them without separately satisfying applicable eligibility, compatibility and licensing requirements.
