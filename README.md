# kiro-token-saver

One-shot setup that makes Kiro CLI spend fewer tokens.

| Piece | What it does | Where |
|---|---|---|
| [rtk](https://github.com/rtk-ai/rtk) | Filters command output. Kiro has no rewrite hook, so a steering file tells the agent to prefix `rtk`. | `~/.kiro/steering/rtk.md` |
| caveman | Terse replies. Skill + `SessionStart` hook activate it each session. | `~/.kiro/skills/caveman/`, `~/.kiro/hooks/caveman-default.json` |
| token-saver steering | Habits: grep before read, ranged reads, batch calls, sub-agents, no recaps. | `~/.kiro/steering/token-saver.md` |

## Use

```sh
./install.sh      # idempotent; backs up changed files as *.bak.<ts>
./verify.sh       # file checks; add --live to run kiro-cli (spends credits)
./uninstall.sh
```

## Notes

- rtk Kiro support is in PR [rtk-ai/rtk#5072](https://github.com/rtk-ai/rtk/pull/5072) (not merged). Until then `install.sh` builds from the PR branch (`RTK_GIT`, `RTK_BRANCH` override). Needs Rust/cargo.
- rtk prints `No hook installed` on stderr under Kiro. Harmless.
- Caveman skill is a slim version (1.2 KB). The original (4.7 KB) is kept in `assets/skills/caveman/SKILL.full.md`. In 3 runs each, slim used 0.38-0.44 credits vs 0.45-0.46 for full, with similar answer length (small sample).
- Disable caveman in a session: say `stop caveman`. Disable permanently: delete the hook file.
- Other ideas not installed (need your call): `/compact` discipline, smaller default model for simple tasks, `.kiroignore`-style excludes for `node_modules`/`target`, scoped steering with `inclusion: fileMatch` instead of `always`.
