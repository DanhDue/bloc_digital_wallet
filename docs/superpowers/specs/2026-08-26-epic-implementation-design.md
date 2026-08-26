# Epic Implementation — Design Spec

## Status
Approved — ready for writing-plans.

## Background
The `logging-refactor` epic now has an approved HLD (`.devtool/epic/logging_refactor/logging_refactor.en.md`/`.vi.md`) and 8 Kanban task files (`.devtool/features/task_*.md`). There is currently no automated way to actually execute these tasks: a human has to manually invoke `subagent-driven-development` per task, manually set up a worktree that can actually run/build this project, and manually keep the HLD's diagrams in sync when implementation reveals the design was wrong — exactly what happened in this same epic's own design process, when Task 7's reference integration point (`packages/native_security`) turned out to be an `dart:ffi` plugin instead of the Pigeon-based plugin the epic assumed.

This spec designs a new skill, `epic-implementation`, that automates the full lifecycle for any epic that follows this project's `.devtool/epic/<name>/` + `.devtool/features/task_*.md` convention: reload context from the epic's own docs, compute a dependency-respecting execution order, run each task through the existing `subagent-driven-development` pattern inside one dedicated worktree, enforce a strict one-commit-per-task convention, keep docs in sync when implementation diverges from the HLD, and hand off to `finishing-a-development-branch` at the end.

## Goals
- Given an epic name, read its HLD + all its task files once (context reload) before touching any code or git state.
- Compute an execution order from each task's `priority` frontmatter and its prose "Dependencies & Blockers" section (topological order, priority as tiebreak within a layer), and report which tasks *could* have run in parallel — informational only, not executed concurrently.
- Execute tasks strictly sequentially, in one dedicated worktree for the whole epic (branched from `develop`), reusing the existing, proven `subagent-driven-development` pattern (fresh subagent per task, two-stage review) rather than introducing a new concurrent-agent mechanism.
- Exactly one commit per task, message format `[EPIC_NAME] <task_title>`.
- When a task's implementation reveals the HLD is wrong (new component, changed data/control flow, an invalidated assumption), update the epic's Mermaid diagrams in **both** `.en.md`/`.vi.md` and the task file itself, as a separate commit from the task's code commit.
- Worktree bootstrap must actually be runnable against this repo: copy `secureFiles/` into the new worktree (untracked/gitignored, not brought along by `git worktree add`) and materialize per-flavor platform config via the existing `copy_secure_configurations` skill.
- End of epic: run the full test suite, then hand off to `finishing-a-development-branch` — never auto-merge to `develop` silently.

## Non-Goals
- **True concurrent multi-worktree parallel execution.** Designed in detail, then explicitly rejected for this version — see Alternatives Considered.
- **Symlinking or copying per-checkout build artifacts** (`.dart_tool/`, `/build/`, `ios/Flutter/ephemeral/Packages/`, any `android/**/.cxx/` directory) between worktrees. Rejected as unsafe: inspection of this repo's own `packages/native_security/android/.cxx/**/*.json` confirmed these caches hard-code the source checkout's absolute path — reusing them from a different worktree path would silently corrupt the build.
- **Redirecting `PUB_CACHE`/`GRADLE_USER_HOME`/Swift Package Manager cache to a project-local shared path.** Unnecessary — confirmed no such override exists anywhere in this repo outside `.devcontainer/` (which itself uses the standard global `$HOME/.pub-cache`), so dependency caches are already global and shared across every worktree on this machine by default.
- **Any CocoaPods handling** (`pod install`, `Podfile`, pod cache). Not applicable — this project fully migrated to Swift Package Manager (git history: `813b11e migrate to SPM and remove generated files from git`, plus PRs #22–#30). `ios/Podfile`/`ios/Pods/`/`ios/.symlinks/` may still be present on an existing local disk checkout, but none of them are git-tracked, so a fresh worktree created from `develop` will not have them at all.
- **Literal re-invocation of the interactive `brainstorming` skill** as the "context reload" step. There is nothing new to brainstorm — the design is already approved; this is an autonomous read-and-internalize pass instead.
- **Changing the epic-designer task template to add a machine-readable dependency field.** The orchestrator reads the existing prose "Dependencies & Blockers" section directly (e.g. "Blocked by [Task 2](task_2_core_interfaces.md)").

## Architecture

### Worktree & branch model
```
develop
 └─ epic/<epic_name>     ← ONE worktree, created once via using-git-worktrees, from develop
      Task 1 → Task 2 → ... → Task N   (strictly sequential, all inside this one worktree)
```

### Worktree Bootstrap (runs once, right after `using-git-worktrees` creates the worktree)
1. `cp -R secureFiles <worktree_path>/secureFiles` — required because `secureFiles/` is gitignored; `git worktree add` only checks out tracked content, so it never brings this along.
2. Run `copy_secure_configurations`'s script from inside the new worktree to place files into `android/app/src/<flavor>/` and `ios/Runner/Firebase/`.
3. Run `melos bootstrap` explicitly (do **not** rely on `using-git-worktrees`'s own generic project-setup auto-detection — that step's current auto-detect list only covers Node/Rust/Python/Go, not Flutter/melos monorepos; `epic-implementation` runs this itself regardless). Fast, since `~/.pub-cache` is global and already warm.
4. No manual iOS dependency-install step is needed — this project uses Swift Package Manager, not CocoaPods (see Non-Goals). SPM package resolution happens automatically the first time `flutter build ios`/`xcodebuild` runs in the new worktree, materializing `ios/Flutter/ephemeral/Packages/` fresh. The underlying package sources resolve from Swift Package Manager's own global cache (`~/Library/Caches/org.swift.swiftpm/`), already shared across worktrees on this machine the same way `~/.pub-cache` and `~/.gradle/caches` are — so this first build pays a one-time resolution/indexing cost, not a re-download cost.
5. Do **not** attempt to copy or symlink `.dart_tool/`, `/build/`, `ios/Flutter/ephemeral/Packages/`, or any `android/**/.cxx/` directory from another checkout — see Non-Goals.

### Phase 0 — Context Reload
Read, once, before any task starts:
- The epic's canonical `.en.md` HLD (per epic-designer's own "canonical language" rule — `.en.md` is source of truth, `.vi.md` is a synced translation).
- Every `.devtool/features/task_*.md` whose frontmatter `epic:` matches the target epic.
- Any spec file(s) linked from the epic's Meta Data section.

This is an autonomous read-and-internalize pass, not a re-invocation of the interactive `brainstorming` skill.

### Phase 1 — Execution Plan
1. For each task, parse frontmatter `priority` (`low`/`medium`/`high`) and `status`, and read the "Dependencies & Blockers" section's prose to identify blocking task IDs.
2. Build a dependency graph; compute topological layers (a task's layer = 1 + max layer of its blockers; no blockers = layer 0).
3. Within a layer, order by priority (high → medium → low), then by task number as a final tiebreak.
4. Flatten all layers into one strict sequential execution order.
5. Report the computed order, annotating which tasks share a layer (i.e. *could* have run in parallel) — informational only, does not change execution. For `logging-refactor` today, this surfaces two such layers: Tasks 3/5/7 (all blocked only by Task 2) and Tasks 4/6 (both blocked only by Task 3).
6. **Checkpoint**: present this order for user confirmation before creating any worktree or dispatching any subagent — mirrors `epic-designer`'s own task-breakdown checkpoint.

### Phase 2 — Sequential Task Execution
Reuses `superpowers:subagent-driven-development` almost exactly, task by task in the confirmed order, inside the one epic worktree:
1. Dispatch an implementer subagent with the full task file text plus epic context. It follows `superpowers:test-driven-development` (RED→GREEN→REFACTOR) and self-reviews — unlike the base skill, it does **not** commit yet.
2. Dispatch a spec-compliance reviewer subagent (against the task's own DoD checklist). Fix loop until approved.
3. Dispatch a code-quality reviewer subagent. Fix loop until approved.
4. Only once both reviews pass: make exactly one commit, `git commit -m "[EPIC_NAME] <task_title>"`. `EPIC_NAME` is the epic slug, upper-cased with hyphens (e.g. `LOGGING-REFACTOR`, from frontmatter `epic: "logging-refactor"`). `<task_title>` is the task's `# Task N: <Title>` heading with the "Task N:" prefix stripped.
5. Update that task's frontmatter in `.devtool/features/task_<n>.md`: `status: "done"`, `completedAt: "<ISO-8601 now>"`.
6. If the implementer or either reviewer flags that the implementation diverged from the HLD, go to Phase 3 before starting the next task.

### Phase 3 — Doc Sync on Divergence
Only runs when Phase 2 step 6 flags divergence:
1. Update the epic's Mermaid diagrams (Architecture/Use Case/Sequence — whichever are affected) in **both** `.en.md` and `.vi.md`, never letting one language drift from the other.
2. Update the affected task file(s)' own prose if their description was inaccurate.
3. Commit separately: `[EPIC_NAME] docs: sync HLD after <task_title>`. This keeps the task's code commit exactly one commit even when divergence is found — doc-sync is an additional, clearly-labeled commit, never folded into the code commit.

### Phase 4 — End of Epic
1. Once every task in the execution order is `done`, run the full test suite once more on the epic worktree.
2. Invoke `superpowers:finishing-a-development-branch` on the epic branch (base = `develop`) — presents the standard 4 options (merge locally / PR / keep / discard). Never auto-merge to `develop` outside of this.

## Alternatives Considered

**True multi-worktree parallel execution** (one worktree per task within an independent layer, concurrent subagents, sequential merge-back into the epic branch) was designed in full detail, then rejected. For `logging-refactor`, the only real parallel opportunities are Tasks 3/5/7 and Tasks 4/6 — a modest win — while the added risk is real: managing multiple worktrees, coordinating merge order, and a genuine chance that tasks in the same layer all touch the same DI/bootstrap file, causing merge conflicts. The existing, proven `subagent-driven-development` pattern already explicitly prohibits concurrent implementation subagents for exactly this reason ("Dispatch multiple implementation subagents in parallel (conflicts)"). Sequential-with-dependency-analysis captures the planning value without the new risk surface; true parallelism can be revisited later, on a larger epic, once this simpler version is validated.

**Copying/symlinking build caches between worktrees** (to speed up bootstrap) was considered and rejected — see Non-Goals for the concrete evidence found in this repo.

## Testing Strategy
This skill's output is a process/documentation artifact, not application code, so verification is scenario-based:
- Dry-run the dependency-graph computation against `logging-refactor`'s actual 8 tasks; confirm the computed order matches manual analysis. Verified against the real task files: the layering is `{1} → {2} → {3, 5, 7} → {4, 6} → {8}` (Task 5 and Task 7 are both blocked by Task 2, not Task 3), which is what the calculator produces and what `RealLoggingRefactorEpicTests` pins. Task 7 is graph-eligible in layer 2 but its own file recommends doing it after Tasks 1-4 — surfaced as a soft note for manual review, never silently applied.
- Verify the worktree bootstrap steps end-to-end against this repo's actual `secureFiles/` copy, `melos bootstrap`, and a first iOS build's automatic SPM resolution — confirm a freshly created worktree can actually run the app.
- After a real run, inspect `git log` on the epic branch to confirm exactly one commit per task (plus doc-sync commits only where divergence genuinely occurred).

## References
- Epic used as the worked example: `.devtool/epic/logging_refactor/logging_refactor.en.md`
- Reused skills: `superpowers:using-git-worktrees`, `superpowers:subagent-driven-development`, `superpowers:test-driven-development`, `superpowers:finishing-a-development-branch`, `copy_secure_configurations`
- Evidence for the absolute-path build-cache risk: `packages/native_security/android/.cxx/**/*.json`
