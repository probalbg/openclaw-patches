#!/usr/bin/env bash
# Apply or inspect the local OpenClaw patch set.
# --check is strictly read-only; without it, patches may modify the installation.

set -euo pipefail
PATCH_DIR="$(cd "$(dirname "$0")" && pwd)"
CHECK_ONLY=false
[[ "${1:-}" == "--check" ]] && CHECK_ONLY=true

echo "=== OpenClaw Local Patches ==="
echo "Patch directory: $PATCH_DIR"
if "$CHECK_ONLY"; then echo "Mode: CHECK ONLY (read-only)"; else echo "Mode: APPLY"; fi

mapfile -t PATCHES < <(find "$PATCH_DIR" -maxdepth 1 -type f -name '*.patch.sh' | sort)
if (("${#PATCHES[@]}" == 0)); then echo "No patches found."; exit 0; fi

FAILED=0
for patch in "${PATCHES[@]}"; do
    echo "--- $(basename "$patch") ---"
    if "$CHECK_ONLY"; then
        if bash "$patch" --check; then :; else FAILED=$((FAILED + 1)); fi
    else
        if bash "$patch"; then :; else FAILED=$((FAILED + 1)); fi
    fi
done

echo "=== Summary ==="
echo "Patches checked: ${#PATCHES[@]}"
echo "Failures: $FAILED"
if ((FAILED > 0)); then
    echo "Review failed patch output before proceeding." >&2
    exit 1
fi
if ! "$CHECK_ONLY"; then
    echo "If any patch changed installed files, restart the OpenClaw gateway during an approved maintenance window."
fi