#!/usr/bin/env bash
# Installs token-saving setup for Kiro CLI: rtk + caveman + token-saver steering.
# Idempotent. Existing files are backed up as *.bak.<timestamp>.
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIRO="${KIRO_HOME:-$HOME/.kiro}"
RTK_GIT="${RTK_GIT:-https://github.com/evandrojr/rtk}"   # fork of PR rtk-ai/rtk#5072
RTK_BRANCH="${RTK_BRANCH:-feat/kiro-agent}"
TS="$(date +%s)"

log() { printf '==> %s\n' "$*"; }

install_file() { # src dst
  mkdir -p "$(dirname "$2")"
  if [ -e "$2" ] && ! cmp -s "$1" "$2"; then
    cp "$2" "$2.bak.$TS"
    log "backup: $2.bak.$TS"
  fi
  cp "$1" "$2"
  log "installed: $2"
}

# 1. rtk (needs `rtk init --agent kiro`; until PR #5072 is merged, build from the PR branch)
export PATH="$HOME/.cargo/bin:$PATH"
if rtk init --help 2>/dev/null | grep -qi kiro; then
  log "rtk with kiro support already installed: $(rtk --version)"
else
  command -v cargo >/dev/null || { echo "cargo not found. Install Rust: https://rustup.rs" >&2; exit 1; }
  log "building rtk from $RTK_GIT@$RTK_BRANCH (several minutes)"
  cargo install --git "$RTK_GIT" --branch "$RTK_BRANCH" --locked --force rtk
fi
rtk init -g --agent kiro

# 2. PATH for non-interactive shells (Kiro runs commands this way)
if ! grep -qs 'cargo/bin' "$HOME/.zshenv" 2>/dev/null; then
  echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.zshenv"
  log "PATH added to ~/.zshenv"
fi
if [ -f "$HOME/.bashrc" ] && ! grep -qs 'cargo/bin' "$HOME/.bashrc"; then
  echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.bashrc"
  log "PATH added to ~/.bashrc"
fi

# 3. caveman skill + SessionStart hook, token-saver steering
install_file "$HERE/assets/skills/caveman/SKILL.md"      "$KIRO/skills/caveman/SKILL.md"
install_file "$HERE/assets/hooks/caveman-default.json"   "$KIRO/hooks/caveman-default.json"
install_file "$HERE/assets/steering/token-saver.md"      "$KIRO/steering/token-saver.md"

log "done. Verify: ./verify.sh"
