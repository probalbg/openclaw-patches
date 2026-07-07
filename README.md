# OpenClaw Stability Project

**Pinning, extending, and fixing OpenClaw v2026.6.11 — without forced upgrades.**

## The Problem

OpenClaw releases frequently. New versions bring features, but also break things.
Production servers can't chase upstream every week. You need stability, predictability,
and control over when you upgrade.

## Our Approach

We took OpenClaw v2026.6.11 — a solid release — and made it our stable base.
Instead of upgrading to get fixes and features, we **backport, patch, and extend**
the version we have. This repo is the collection of everything we've added.

**We are not a fork.** We don't redistribute OpenClaw. We distribute patches that
modify an existing OpenClaw installation. You install OpenClaw yourself, then apply
our patches on top.

## What's Inside

| Type | Description |
|------|-------------|
| **Bug fixes** | Corrections to OpenClaw dist files that haven't been fixed upstream yet |
| **Backports** | Features from newer OpenClaw versions, adapted to work on v2026.6.11 |
| **Extensions** | New capabilities we've built that OpenClaw doesn't have |
| **Hardening** | Stability improvements for production deployments |

## Quick Start

```bash
# 1. Have OpenClaw v2026.6.11 installed
openclaw --version
# Should show: OpenClaw 2026.6.11 (e085fa1)

# 2. Clone this repo
git clone https://github.com/probalbg/openclaw-patches.git

# 3. Apply all patches
cd openclaw-patches
bash apply-all.sh

# 4. Restart your gateway
openclaw gateway restart
```

## Check Status

```bash
bash apply-all.sh --check
```

## Patches

| # | Name | Type | Description |
|---|------|------|-------------|
| 001 | schema-lookup-colon | Bug fix | Allow `:` in `config.schema.lookup` paths for model IDs like `glm-5.2:cloud` |

See [MANIFEST.md](MANIFEST.md) for full details, upstream status, and per-patch documentation.

## Philosophy

- **Stability over novelty** — a working server beats a bleeding-edge server
- **Patch over upgrade** — if we can fix it locally, we do
- **Document everything** — every change has a reason and a paper trail
- **Share with the community** — if it helps us, it might help you
- **No security bypasses** — we never patch auth, sandbox, or safety logic
- **Upgrade deliberately** — when there's a genuinely compelling reason, we assess, document, and upgrade on our terms

## Who Is This For?

- **Production users** who can't afford to break things every update cycle
- **Self-hosters** who want control over their OpenClaw version
- **Anyone** who found a bug in v2026.6.11 and wants a fix without a full upgrade

## OpenClaw Version Pin

We develop and test against **v2026.6.11 (e085fa1)**. Patches may work on other
versions, but we only guarantee compatibility with this specific release.

```bash
# Verify your version
openclaw --version
```

## Contributing

Found a bug in v2026.6.11? Wrote a fix? Submit a PR.

1. Follow the patch naming convention: `NNN-descriptive-name.patch.sh`
2. Make it idempotent (safe to run multiple times)
3. Document what/why/upstream status
4. Test with `bash apply-all.sh --check`

## Disclaimer

This is an independent community project, not affiliated with OpenClaw's core team.
We respect their work and file upstream issues where appropriate. Our patches modify
installed dist files — always review what a patch does before applying it.

## License

MIT — use freely, attribution appreciated.

---

**Maintained by:** [Probal Rahman](https://github.com/probalbg) and Kael (AI agent)  
**Started:** 2026-07-07 · **Base version:** OpenClaw v2026.6.11