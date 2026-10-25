# Optional On-Device AI Policy

AI is a later, optional feature area. The project must first have a reproducible Android baseline. A model demo is not equivalent to a trusted system service.

## Selection criteria

For each proposed use case, document:
- User problem and why on-device inference is appropriate.
- Runtime support for the selected Android release and CPU/accelerator target.
- Model, tokenizer, code and dataset licences, attribution and redistribution conditions.
- Download size, installed size, peak RAM, latency, energy use, heat and quality.
- Supported languages and evaluation methodology.
- Failure behavior, user controls, accessibility and non-AI fallback.

## Privacy defaults

- Prefer local inference where practical.
- Do not silently upload prompts, files, contacts, messages, location or telemetry.
- Clearly disclose any network request and require appropriate user consent.
- Keep prompts and outputs out of routine logs unless explicitly needed for debugging and safely redacted.
- Provide a way to disable the feature and delete locally stored AI data.
- Do not use private user data to train or fine-tune models without an explicit, lawful process.

## Security boundaries

- Treat model output as untrusted input.
- Do not let AI output directly execute shell commands, alter security policy, grant permissions, flash partitions, or change update/signing settings.
- Use narrow APIs and explicit user confirmation for consequential actions.
- Keep model inference away from privileged system paths until the threat model, sandboxing and tests are reviewed.

## Acceptance gate

A candidate is eligible for integration only after licence review, benchmark results on the target, privacy review, safety testing, disable/fallback behavior, and reproducible instructions are documented.
