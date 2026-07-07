#!/usr/bin/env bash
# apply-all.sh — Master patch script for OpenClaw local patches
#
# Applies all patches in numerical order. Idempotent — safe to run multiple times.
# Run this AFTER any `openclaw update` to re-apply local fixes.
#
# Each patch:
#   - Is a standalone .patch.sh script
#   - Checks if already applied (skips if so)
#   - Warns if target file has changed (may need manual review)
#   - Exits 0 on success, non-zero on real failure
#
# Usage:
#   bash patches/apply-all.sh          # apply all
#   bash patches/apply-all.sh --check  # check status only, don't apply
#
# Created: 2026-07-07 by Kael

set -euo pipefail

PATCH_DIR="$(cd "$(dirname "$0")" && pwd)"
CHECK_ONLY=false

if [ "${1:-}" = "--check" ]; then
    CHECK_ONLY=true
fi

echo "=== OpenClaw Local Patches ==="
echo "Patch directory: $PATCH_DIR"
echo "Mode: $([ "$CHECK_ONLY" = true ] && echo 'CHECK ONLY' || echo 'APPLY')"
echo ""

# Collect all patch scripts sorted numerically
PATCHES=()
while IFS= read -r f; do
    PATCHES+=("$f")
done < <(find "$PATCH_DIR" -maxdepth 1 -name '*.patch.sh' | sort)

if [ ${#PATCHES[@]} -eq 0 ]; then
    echo "No patches found."
    exit 0
fi

echo "Found ${#PATCHES[@]} patch(es):"
for p in "${PATCHES[@]}"; do
    echo "  - $(basename "$p")"
done
echo ""

APPLIED=0
SKIPPED=0
FAILED=0

for patch in "${PATCHES[@]}"; do
    name=$(basename "$patch")
    echo "--- $name ---"
    
    if [ "$CHECK_ONLY" = true ]; then
        # Just run the patch in check mode (it's idempotent, so running it is safe)
        bash "$patch" && {
            output=$(bash "$patch" 2>&1)
            if echo "$output" | grep -q "Already patched"; then
                echo "  Status: APPLIED"
                APPLIED=$((APPLIED + 1))
            else
                echo "  Status: NOT APPLIED"
            fi
        } || echo "  Status: CHECK FAILED"
    else
        if bash "$patch"; then
            output=$(bash "$patch" 2>&1)
            if echo "$output" | grep -q "Already patched"; then
                echo "  Status: already applied"
                SKIPPED=$((SKIPPED + 1))
            else
                echo "  Status: applied"
                APPLIED=$((APPLIED + 1))
            fi
        else
            echo "  Status: FAILED"
            FAILED=$((FAILED + 1))
        fi
    fi
    echo ""
done

echo "=== Summary ==="
echo "Applied: $APPLIED"
echo "Skipped (already applied): $SKIPPED"
echo "Failed: $FAILED"

if [ "$FAILED" -gt 0 ]; then
    echo ""
    echo "⚠️ Some patches failed. Review the output above."
    echo "   This may happen if upstream changed the target files."
    exit 1
fi

echo ""
echo "✅ All patches applied successfully."

# Remind to restart gateway if any patches were applied
if [ "$CHECK_ONLY" = false ] && [ "$APPLIED" -gt 0 ]; then
    echo ""
    echo "⚠️ Patches were applied. Restart the gateway to pick up changes:"
    echo "   openclaw gateway restart"
fi