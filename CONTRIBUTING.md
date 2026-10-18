# Contributing

Thanks for considering a contribution. Small, reproducible fixes are welcome.

## Before opening a pull request

1. Open or link an issue describing the problem and the exact OpenClaw version.
2. Explain the expected behavior and actual behavior, with logs sanitized of secrets and personal data.
3. Keep each patch focused on one change.
4. Never modify authentication, authorization, sandboxing, safety controls, or security boundaries as a workaround.
5. Never include credentials, customer data, private logs, or proprietary OpenClaw files.

## Patch requirements

- Use the naming pattern `NNN-short-description.patch.sh`.
- Make patches idempotent: running them again must not apply the change twice.
- Support `--check` as a strictly read-only status check.
- Fail clearly if the expected source pattern is missing or has changed.
- Document target version, target file, reason, upstream status, and rollback considerations.
- Prefer a minimal diff and avoid unrelated refactoring.

## Validation

Run these checks in a disposable test environment, not on a production server:

```bash
bash -n apply-all.sh
bash -n 001-schema-lookup-colon.patch.sh
bash apply-all.sh --check
```

For any patch that changes installed files, test against the exact version listed in `VERSION_PIN` and document the result. Do not run apply mode on production as part of a pull request.

## Pull requests

Include:
- Problem and impact
- Exact version tested
- What changed and why
- Test commands and their results
- Known risks and rollback steps
- Whether an upstream issue or fix exists

A maintainer reviews and tests every contribution. Passing CI does not automatically authorize deployment to any production system.
