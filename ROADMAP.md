# Jalvoro OS Roadmap

Items are goals, not completed capabilities unless verified in an issue or release record.

## Phase 0 — Foundation
- [x] Create project repository
- [x] Document vision, proposed architecture, and engineering principles
- [x] Add host setup helpers and repository validation script
- [x] Document Android platform layers, feature backlog, release gates, AI policy, and test matrix
- [ ] Audit development PC (CPU, RAM, free storage, GPU, OS)
- [ ] Select and pin an AOSP branch
- [ ] Decide visibility and original-code licence

**Exit gate:** host and target branch selected using current official requirements; repository checks pass.

## Phase 1 — Reproducible baseline
- [ ] Set up supported Ubuntu LTS
- [ ] Fetch AOSP using official instructions
- [ ] Build an unmodified virtual-device target
- [ ] Record exact steps and test results
- [ ] Document limitations and artifact location

**Exit gate:** baseline build is reproducible from documented steps and boots successfully on the selected virtual target.

## Phase 2 — Jalvoro visual identity
- [ ] Define typography, spacing, colour, icon, motion, and accessibility rules
- [ ] Prototype launcher and system experience
- [ ] Validate layouts on the virtual target
- [ ] Choose overlays or deeper System UI work based on a concrete requirement
- [ ] Add UI regression checks

## Phase 3 — System integration
- [ ] Implement selected settings / quick settings / lock-screen changes
- [ ] Document privileged permissions
- [ ] Add automated regression tests
- [ ] Track upstream patch compatibility

## Phase 4 — Privacy, security, updates
- [ ] Threat-model privileged components and update path
- [ ] Audit permissions and dependencies
- [ ] Define signing-key handling, update integrity, and recovery
- [ ] Establish security-update and vulnerability-response policies
- [ ] Run relevant security and compatibility tests

## Phase 5 — Offline AI evaluation
- [ ] Select one concrete offline use case
- [ ] Compare runtimes and model licences
- [ ] Measure RAM, storage, latency, thermal impact, and battery impact
- [ ] Keep AI optional and provide a non-AI fallback where practical

## Phase 6 — Device feasibility
- [ ] Select a device with a viable bootloader/unlock path
- [ ] Research kernel, vendor blobs, partitions, and device trees
- [ ] Assess recovery and rollback risks
- [ ] Build and test separately from the virtual target

## Phase 7 — Release readiness
- [ ] Reproducible build and signed artifacts
- [ ] Compatibility, regression, and security testing
- [ ] Privacy policy and component notices
- [ ] Release notes, known issues, recovery instructions
- [ ] Ongoing maintenance ownership

**Release gate:** supported devices, limitations, and test evidence are published. No blanket compatibility or security claims.
