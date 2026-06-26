---
name: commit-msg
description: Generate a commit message from staged changes. Use when the user says "生成 commit message" or "generate commit message".
---

# Generate Commit Message

## Steps

1. Run `git diff --cached` to read staged changes. If the staging area is empty, ask the user to `git add` first.
2. Analyze the changes and generate a one-line English commit message.
3. Output the message only. Do NOT run `git commit`.

## Message format

- Start with a conventional commit prefix: `feat`, `fix`, `refac`, `style`, `doc`, `test`, `perf`, `revert`, `chore`, `ci`, `build`, etc.
- English, one line, as short as possible
- Use backticks for code references (function names, file names, etc.) when helpful, but not required
- No trailing period

## Examples

```
feat: add `retry` option to `fetchData`
fix: handle null `user.email` in login flow
refac: extract `parseConfig` from `main.ts`
chore: bump eslint to v9
```
