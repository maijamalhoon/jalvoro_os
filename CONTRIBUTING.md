# Contributing to Jalvoro OS

The project is in its planning/foundation stage. Clear documentation and small, verifiable changes are especially valuable.

## Before changes
1. Read the README, master plan, architecture, and roadmap.
2. Search existing issues before opening a duplicate.
3. For major design changes, open an issue and describe the problem, alternatives, risks, and acceptance criteria.
4. Do not assume planned features already exist.

## Guidelines
- Keep each change focused and reviewable.
- Explain why a change is needed.
- Preserve upstream AOSP conventions where applicable.
- Include tests or explain why testing is not yet possible.
- Update documentation and known limitations alongside behaviour changes.
- Never commit credentials, signing keys, personal data, unlicensed blobs, or unreviewed AI model files.

## Commit messages
Use short descriptive messages, e.g. `docs: clarify virtual target`, `ui: add design tokens`, `test: cover permission behaviour`.

## Pull request checklist
- [ ] Clear rationale and acceptance criteria
- [ ] Focused scope and updated documentation
- [ ] Relevant tests run or limitations stated
- [ ] No secrets or unlicensed assets
- [ ] Security, privacy, accessibility, and upgrade impacts considered
- [ ] Claims match what was actually tested

Do not flash experimental images to a daily-use phone. Device work must include a recovery plan.