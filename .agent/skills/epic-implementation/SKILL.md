---
name: epic-implementation
description: Use when an epic already has an approved HLD and Kanban task files (`.devtool/epic/<name>/` + `.devtool/features/task_*.md`) and you need to actually execute those tasks against the codebase, in the right order, inside an isolated worktree.
---

# Epic Implementation

## Overview

Runs an already-approved epic's Kanban tasks end-to-end: reload the epic's own docs for context, compute a dependency-safe execution order, bootstrap one worktree that can actually build this project, then drive each task sequentially through `superpowers:subagent-driven-development` with exactly one commit per task.

**Core principle:** One worktree, one task at a time, one commit per task, docs stay truthful.

**Announce at start:** "I'm using the epic-implementation skill to implement the `<epic_name>` epic."

**Full rationale:** [2026-08-26-epic-implementation-design.md](../../../docs/superpowers/specs/2026-08-26-epic-implementation-design.md)

## When to Use

- The epic has a `.devtool/epic/<epic_name>/<epic_name>.en.md` HLD and one or more `.devtool/features/task_*.md` files with `epic: "<epic_name>"` in frontmatter, and a human has already approved that design.
- You are about to implement more than one task from that epic in this session.

**Don't use when:** the epic/tasks don't exist yet (use `superpowers:brainstorming` then `epic-designer` first), or you're implementing a single one-off task with no epic context (just use `superpowers:subagent-driven-development` directly).

## Process

### Phase 0 — Context Reload (once, not per task)

Read, in full:
- `.devtool/epic/<epic_name>/<epic_name>.en.md` (the canonical HLD — never `.vi.md` for decisions, that's a synced translation).
- Every `.devtool/features/task_*.md` whose frontmatter `epic:` matches `<epic_name>`.
- Any spec file(s) linked from the HLD's Meta Data section.

This is an autonomous read-and-internalize pass, not a re-run of the interactive `superpowers:brainstorming` skill — the design is already approved; there is nothing left to ask the user about the architecture itself.

### Phase 1 — Execution Plan

1. Run:
   ```bash
   python3 .agent/skills/epic-implementation/resources/scripts/compute_execution_order.py <epic_name>
   ```
2. Read the "Manual review advised" section of the output (if any) and cross-check it against what you read in Phase 0 — a task's own prose may recommend a later placement than its strict dependency layer allows (this happened for `logging-refactor`'s Task 7: graph-eligible right after Task 2, but its own file recommends doing it after Tasks 1-4). Adjust the flattened order by hand if the prose note should win.
3. **Checkpoint:** present the final order (with any manual adjustment explained) to the user and get confirmation before creating any worktree or dispatching any subagent.

### Worktree Bootstrap (once, after the order is confirmed)

1. Follow `superpowers:using-git-worktrees` to create one worktree named for the epic (e.g. branch `epic/<epic_name>`), from `develop`.
2. Run:
   ```bash
   .agent/skills/epic-implementation/resources/scripts/bootstrap_worktree.sh <worktree_path>
   ```
   Run this with your current working directory at the checkout you want treated as `REPO_ROOT` (typically the main checkout) — not from inside a different worktree — otherwise `secureFiles/` and other repo-root-relative lookups resolve against the wrong tree.
   This copies `secureFiles/` in, places platform config via `copy_secure_configurations`, and runs `melos bootstrap`. It does **not** run `pod install` — this project uses Swift Package Manager, not CocoaPods.
3. Do not copy or symlink `.dart_tool/`, `/build/`, `ios/Flutter/ephemeral/Packages/`, or any `android/**/.cxx/` directory from another checkout into this worktree — these embed the source checkout's absolute paths and will silently corrupt the build from a different path.

### Phase 2 — Sequential Task Execution

For each task in the confirmed order, follow `superpowers:subagent-driven-development` almost exactly, with two differences:

1. Dispatch implementer subagent with the full task file text. It follows `superpowers:test-driven-development`, self-reviews, but does **not** commit yet.
2. Dispatch spec-compliance reviewer, then code-quality reviewer, same as the base skill. Fix loops as needed — still uncommitted.
3. Only once both reviews pass, make exactly one commit:
   ```bash
   git commit -m "[EPIC_NAME] <task_title>"
   ```
   `EPIC_NAME` is the epic slug upper-cased with hyphens (e.g. `LOGGING-REFACTOR`). `<task_title>` is the task's `# Task N: <Title>` heading with the `Task N:` prefix stripped.
4. Update that task's frontmatter: `status: "done"`, `completedAt: "<ISO-8601 now>"`.
5. If the implementer or a reviewer flags that the implementation diverged from the HLD, go to Doc Sync below before starting the next task.

### Doc Sync on Divergence

Only when Phase 2 step 5 flags divergence:
1. Update the epic's Mermaid diagrams in **both** `.en.md` and `.vi.md` — never let one drift from the other.
2. Update the affected task file(s)' own prose if it was inaccurate.
3. Commit separately:
   ```bash
   git commit -m "[EPIC_NAME] docs: sync HLD after <task_title>"
   ```
   This keeps the task's code commit exactly one commit even when divergence is found.

### Phase 4 — End of Epic

1. Once every task is `done`, run the full test suite once more on the epic worktree.
2. Use `superpowers:finishing-a-development-branch` on the epic branch (base = `develop`). Never merge to `develop` outside of that skill's flow.

## Quick Reference

| Step | Tool |
|------|------|
| Compute execution order | `resources/scripts/compute_execution_order.py <epic_name>` |
| Create the epic worktree | `superpowers:using-git-worktrees` |
| Bootstrap the worktree | `resources/scripts/bootstrap_worktree.sh <worktree_path>` |
| Run each task | `superpowers:subagent-driven-development` |
| Per-task TDD | `superpowers:test-driven-development` |
| Finish the epic branch | `superpowers:finishing-a-development-branch` |

## Common Mistakes

**Trusting the computed layer blindly** — a task's own prose can carry a softer "Recommended to do after..." note the parser doesn't treat as a hard blocker. Always read the "Manual review advised" output before confirming the order.

**Copying build caches to "speed up" a new worktree** — `.dart_tool/`, `ios/Flutter/ephemeral/Packages/`, and native `.cxx/` directories hard-code the source checkout's absolute path; copying them corrupts the build in a different worktree path. Let them regenerate — the dependency-level caches (`~/.pub-cache`, `~/.gradle/caches`, Swift Package Manager's cache) are already global and make regeneration fast.

**Running `pod install`** — this project migrated to Swift Package Manager; there is no `Podfile` tracked in git.

**Folding a doc-sync into the task's code commit** — keep them separate so `git log` always shows a clean one-commit-per-task history, with doc-sync commits clearly labeled as such.

## Red Flags

**Never:**
- Create a worktree per task or dispatch concurrent implementation subagents (rejected in the spec — file/merge conflicts).
- Skip the Phase 1 confirmation checkpoint before touching git.
- Merge to `develop` without going through `superpowers:finishing-a-development-branch`.
- Treat a "Recommended..." note as equivalent to "Blocked by..." without telling the user you're overriding the computed order.

## Integration

**Required workflow skills:**
- **superpowers:using-git-worktrees** — creates the epic worktree.
- **superpowers:subagent-driven-development** — runs each task.
- **superpowers:test-driven-development** — used by each task's implementer subagent.
- **superpowers:finishing-a-development-branch** — completes the epic branch.
- **copy_secure_configurations** — invoked by `bootstrap_worktree.sh`.
