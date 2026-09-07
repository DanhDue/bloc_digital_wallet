---
description: Git write operations — check auto_commit before any git write command
alwaysApply: true
---

# Git Policy

> **Core rule:** Before ANY git write operation, read `.agents/config.yml` — if `auto_commit: false`, skip the operation and print "Skipping git operation (auto_commit: false)."

<HARD-GATE>
Before running ANY git write operation — git add, git commit, git push,
git pull, git merge, git tag, git branch -d, git branch -D, git worktree remove,
git rebase, git cherry-pick, git reset --hard —
you MUST read `.agents/config.yml` and check the `auto_commit` setting.

If `auto_commit: false`:
  - DO NOT run the operation
  - Print exactly: "Skipping git operation (auto_commit: false)."
  - Continue with the rest of the task (non-git steps still execute)

If `auto_commit: true` (or key is absent): proceed normally.
</HARD-GATE>

This applies everywhere — inside skills, workflows, and any ad-hoc actions.
No exceptions.

## Always Allowed (read-only)

These operations are never blocked:
- `git status`, `git log`, `git diff`, `git show`
- `git worktree add`, `git worktree list`
- `git checkout <branch>` (navigation only)

## User Review & Explicit Commit Gate (Interactive Bug Fixes & Ad-hoc Work)

1. **No Silent Commits on Bug Fixes**: Never execute `git commit` automatically when fixing bugs found during testing, refactoring, or interactive user requests.
2. **Transparent Diff Presentation**: When bug fixes or code modifications are made, always provide a detailed summary:
   - What failed / Root cause.
   - Files changed and exact modifications.
   - Side effects and how to review in IDE Source Control (`Cmd/Ctrl + Shift + G`) or CLI `git diff`.
3. **User Decides**: Only commit when the user explicitly reviews the diff and commands: "Code ok, commit đi" or equivalent.
4. **Epic Implementation**: Pre-approved Kanban tasks executing inside `epic-implementation` retain automated per-task commits to preserve autonomous end-to-end execution.
