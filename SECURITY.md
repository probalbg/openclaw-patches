# Security Policy

This repository contains patches for an existing OpenClaw installation. Treat patch scripts as privileged code: inspect them before running them.

## Reporting a vulnerability

Do not publish exploit details, credentials, private logs, or customer information in a public issue. Contact the repository maintainer privately through the contact options on the GitHub profile and provide a concise report, affected version, impact, and safe reproduction steps.

## Scope

- Do not submit patches that bypass authentication, authorization, sandboxing, safety controls, or security boundaries.
- Do not include secrets, personal data, production configuration, or unredacted logs.
- Test changes in a disposable environment before any production use.
- A passing test suite is not a guarantee of security.
