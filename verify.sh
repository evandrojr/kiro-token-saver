#!/usr/bin/env bash
set -u
KIRO="${KIRO_HOME:-$HOME/.kiro}"
export PATH="$HOME/.cargo/bin:$PATH"
ok=0
chk() { if eval "$2" >/dev/null 2>&1; then echo "OK   $1"; else echo "FAIL $1"; ok=1; fi; }
chk "rtk in PATH"            "command -v rtk"
chk "rtk steering"           "test -f $KIRO/steering/rtk.md"
chk "token-saver steering"   "test -f $KIRO/steering/token-saver.md"
chk "caveman skill"          "test -f $KIRO/skills/caveman/SKILL.md"
chk "caveman hook"           "test -f $KIRO/hooks/caveman-default.json"
if [ "${1:-}" = "--live" ]; then
  echo "--- live test (uses credits)"
  kiro-cli chat --no-interactive --trust-all-tools \
    "Rode git status e diga o comando exato executado." 2>&1 | grep -q 'rtk git status' \
    && echo "OK   kiro prefixes rtk" || { echo "FAIL kiro did not prefix rtk"; ok=1; }
fi
exit $ok
