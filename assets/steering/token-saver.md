---
inclusion: always
---

# Token saver

- Search first (grep/symbols), then read only the needed line range of large files.
- Do not re-read files or re-run commands whose result is already in context.
- Limit command output: `--stat`, `-n`, `head`, `--quiet`. Never dump logs, lockfiles, or build output in full.
