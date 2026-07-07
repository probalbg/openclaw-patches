#!/usr/bin/env bash
# Patch 001: Allow ':' in config.schema.lookup path parameter
#
# Problem: Ollama model IDs use ':' (e.g. glm-5.2:cloud) but the Zod schema
# for config.schema.lookup's `path` param doesn't allow ':' in its regex.
# This causes a validation error when looking up model-specific config paths.
#
# Upstream status: Not yet filed. Should be reported to OpenClaw GitHub.
# Target file: /usr/lib/node_modules/openclaw/dist/schema-Ctppm7Dp.js
# Line: 1722
#
# Created: 2026-07-07
# Author: Kael

set -euo pipefail

TARGET="/usr/lib/node_modules/openclaw/dist/schema-Ctppm7Dp.js"
OLD='pattern: "^[A-Za-z0-9_./\\[\\]\\-*]+$"'
NEW='pattern: "^[A-Za-z0-9_./\\[\\]\\-*:]+$"'

if [ ! -f "$TARGET" ]; then
    echo "[SKIP] Target file not found: $TARGET"
    exit 0
fi

if grep -qF "$NEW" "$TARGET"; then
    echo "[OK] Already patched (or upstream fixed): $TARGET"
    exit 0
fi

if grep -qF "$OLD" "$TARGET"; then
    sudo sed -i "s|$(printf '%s\n' "$OLD" | sed 's/[\\]/\\\\&/g')|$(printf '%s\n' "$NEW" | sed 's/[\\]/\\\\&/g')|g" "$TARGET" 2>/dev/null || {
        # Fallback: use python for reliable string replacement
        sudo python3 -c "
import sys
with open('$TARGET', 'r') as f:
    content = f.read()
old = '''$OLD'''
new = '''$NEW'''
if old in content:
    content = content.replace(old, new, 1)
    with open('$TARGET', 'w') as f:
        f.write(content)
    print('[PATCHED] Replaced pattern in $TARGET')
else:
    print('[WARN] Pattern not found - file may have changed')
"
    }
    echo "[PATCHED] $TARGET"
else
    echo "[WARN] Neither old nor new pattern found - file may have changed upstream"
    exit 1
fi