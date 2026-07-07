# OpenClaw Patch Manifest

**Base version:** OpenClaw v2026.6.11 (e085fa1)  
**Maintainers:** Kael (agent) / Probal Rahman (human)

## Mission

We develop OpenClaw v2026.6.11 forward — fixing bugs, backporting features from
newer releases, and building extensions — so that we (and the community) don't need
to upgrade to newer OpenClaw versions unless there is a genuinely compelling reason.

This is not a fork. It's a patch layer on top of an existing OpenClaw installation.

## Upgrade Policy

1. **We are pinned to v2026.6.11.** No `openclaw update` without explicit approval.
2. **Before any proposed upgrade**, we check if we can patch ourselves instead.
3. **Only upgrade for:** security fixes we can't patch, or features we genuinely need
   that can't be backported. Even then — we assess, document, and decide deliberately.
4. **After any upgrade**, run `bash apply-all.sh` to restore all local fixes.
5. **Kael's standing order:** During idle time between user tasks, monitor OpenClaw
   changelogs and releases. Compare new features/fixes against our version. If
   something useful can be backported, develop a patch and propose it.

## What We Patch

- ✅ Bug fixes in dist files (schema validation, tool behavior, defaults)
- ✅ Backports of features from newer OpenClaw versions
- ✅ Extensions that add capability OpenClaw doesn't have
- ✅ Stability and production hardening
- ❌ NEVER: auth, sandbox, safety, or security logic
- ❌ NEVER: protocol changes that break API contracts

## Patches

| # | Name | Type | Target File | Description | Upstream Status |
|---|------|------|-------------|-------------|----------------|
| 001 | schema-lookup-colon | Bug fix | schema-Ctppm7Dp.js | Allow `:` in `config.schema.lookup` paths for model IDs like `glm-5.2:cloud` | Not yet filed |

## Patch Format

Each patch is a standalone bash script (`NNN-name.patch.sh`) that:

1. **Checks if already applied** → skips (idempotent)
2. **Checks if old pattern exists** → applies fix
3. **If neither found** → warns that upstream changed (manual review needed)
4. **Exits 0** on success or already-applied, **non-zero** on real failure

## Development Workflow

```
Issue found in v2026.6.11
    ↓
Can we patch it locally? → YES → Write patch → Test → Push to repo
                          → NO  → Document in MANIFEST as "needs upgrade"
    ↓
Is it worth backporting from a newer release?
    ↓
Check newer OpenClaw changelog → Identify feature → Adapt to v2026.6.11 → Test → Push
    ↓
File upstream issue (when appropriate) for long-term convergence
```

## Idle-Time Research Directive

When Kael is waiting for user input or between tasks:

1. Check OpenClaw GitHub for recent releases, PRs, and issues
2. Compare changelogs against our v2026.6.11 base
3. Identify fixes/features that would benefit our deployment
4. Assess: can we backport or patch this ourselves?
5. If yes → develop patch, test, propose to Probal
6. If no → document in "Upgrade Candidates" section below
7. Write findings to `RESEARCH.md`

## Upgrade Candidates

Nothing yet. We assess as we go.

## Community

This repo is public. Others running OpenClaw v2026.6.11 can use our patches.
We accept PRs. We document everything. We don't redistribute OpenClaw itself —
only patches that modify an existing installation.