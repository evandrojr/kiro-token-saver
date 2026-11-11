#!/usr/bin/env bash
set -euo pipefail
KIRO="${KIRO_HOME:-$HOME/.kiro}"
export PATH="$HOME/.cargo/bin:$PATH"
command -v rtk >/dev/null && rtk init -g --agent kiro --uninstall || true
rm -fv "$KIRO/skills/caveman/SKILL.md" "$KIRO/hooks/caveman-default.json" "$KIRO/steering/token-saver.md"
rmdir "$KIRO/skills/caveman" 2>/dev/null || true
echo "rtk binary left in ~/.cargo/bin. Remove with: cargo uninstall rtk"
