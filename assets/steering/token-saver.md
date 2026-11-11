---
inclusion: always
---

# Token saver

Reduce tokens without losing correctness.

- Search before reading: use grep/symbol search, then read only the needed range (offset/limit). Do not read whole large files.
- Do not re-read files or re-run commands whose result is already in context.
- Batch independent tool calls in one turn.
- Delegate broad codebase exploration to a sub-agent so the main context stays small.
- Limit command output: use `--stat`, `-n`, `head`, `--quiet` flags. Never dump logs, lockfiles, or build output in full.
- Do not echo file contents back to the user. Show only changed lines plus 1-2 lines of context.
- Do not write summaries, recaps, or offers of further help at the end of a reply.
- Ask one precise question when blocked instead of exploring blindly.
- Use `/compact` when the session grows long; start a new session for an unrelated task.
