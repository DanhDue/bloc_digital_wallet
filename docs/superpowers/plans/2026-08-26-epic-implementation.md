# Epic Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a new skill, `epic-implementation`, that reloads an approved epic's docs, computes a dependency-respecting sequential execution order for its Kanban tasks, bootstraps a runnable git worktree for it, and documents how to drive each task through the existing `subagent-driven-development` pattern with a strict one-commit-per-task convention.

**Architecture:** Two small, independently-testable stdlib scripts (a Python dependency-graph/order calculator, a Bash worktree bootstrapper) live under the skill's `resources/scripts/`, and the `SKILL.md` itself is prose that wires them together with three existing skills (`using-git-worktrees`, `subagent-driven-development`, `finishing-a-development-branch`). The skill produces no application code changes — its own deliverable is the skill file plus scripts, validated by running them against the real `logging-refactor` epic already in this repo.

**Tech Stack:** Python 3 (stdlib only: `argparse`, `re`, `pathlib`, `unittest`), Bash, existing project tooling (`melos`, `git worktree`).

**Spec:** [2026-08-26-epic-implementation-design.md](../specs/2026-08-26-epic-implementation-design.md)

## Global Constraints
- Exactly one worktree per epic, created from `develop` (never per-task worktrees — true parallel execution was evaluated and rejected in the spec).
- Exactly one commit per task, message format `[EPIC_NAME] <task_title>` (`EPIC_NAME` = epic slug upper-cased with hyphens, e.g. `LOGGING-REFACTOR`); a divergence-triggered doc-sync commit is a separate, additional commit, never folded into the task commit.
- Reuse `superpowers:using-git-worktrees`, `superpowers:subagent-driven-development`, `superpowers:test-driven-development`, `superpowers:finishing-a-development-branch`, and `copy_secure_configurations` as-is — do not reimplement their logic inside this skill.
- Never copy or symlink `.dart_tool/`, `/build/`, `ios/Flutter/ephemeral/Packages/`, or any `android/**/.cxx/` directory between worktrees (absolute-path-sensitive, confirmed unsafe in this repo).
- This project uses Swift Package Manager, not CocoaPods — no `pod install` step anywhere in this skill.
- Only a line containing the literal phrase "Blocked by" counts as a hard dependency edge when parsing a task's "Dependencies & Blockers" section; anything else (e.g. "Recommended to do after...") is surfaced as a manual-review note, never auto-applied.

---

## Task 1: Execution-order calculator

**Files:**
- Create: `.agent/skills/epic-implementation/resources/scripts/compute_execution_order.py`
- Test: `.agent/skills/epic-implementation/resources/scripts/test_compute_execution_order.py`

**Interfaces:**
- Produces: `load_tasks(features_dir: Path, epic: str) -> dict[str, dict]` — each value has keys `id`, `path`, `priority`, `status`, `blockers` (`list[str]`), `soft_notes` (`list[str]`), `title`.
- Produces: `compute_layers(tasks: dict[str, dict]) -> list[list[str]]` — raises `ValueError` on a dependency cycle or missing dependency.
- Produces: `main(argv: list[str] | None = None) -> int` — CLI entry point, prints the layer report + flattened order + manual-review notes to stdout.
- Consumes: nothing from other tasks (this is the first task).

- [ ] **Step 1: Write the failing tests**

Create `.agent/skills/epic-implementation/resources/scripts/test_compute_execution_order.py`:

```python
#!/usr/bin/env python3
"""Tests for compute_execution_order.py.

Run: python3 .agent/skills/epic-implementation/resources/scripts/test_compute_execution_order.py -v
"""
import sys
import tempfile
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).parent))
from compute_execution_order import compute_layers, load_tasks, parse_blockers, parse_soft_notes


def write_task(directory: Path, filename: str, *, epic: str, priority: str, title: str, dependencies_body: str) -> None:
    (directory / filename).write_text(
        f'---\nid: "{filename[:-3]}"\nstatus: "todo"\npriority: "{priority}"\nepic: "{epic}"\n---\n'
        f"# {title}\n\n## Dependencies & Blockers\n{dependencies_body}\n"
    )


class ParseBlockersTests(unittest.TestCase):
    def test_single_blocker(self):
        section = "- **Dependencies**: Blocked by [Task 2](task_2_core_interfaces.md) (needs interfaces)."
        self.assertEqual(parse_blockers(section), ["task_2_core_interfaces"])

    def test_two_blockers_on_one_line(self):
        section = (
            "- **Dependencies**: Blocked by [Task 4](task_4_appenders_di.md) "
            "(reason) and [Task 5](task_5_network_tracing.md) (reason)."
        )
        self.assertEqual(parse_blockers(section), ["task_4_appenders_di", "task_5_network_tracing"])

    def test_no_blockers(self):
        self.assertEqual(parse_blockers("- **Dependencies**: None.\n- **Blockers**: None."), [])

    def test_link_without_blocked_by_is_ignored(self):
        section = "- **New dependency**: confirm the key used by [Task 6](task_6_settings_ui.md)."
        self.assertEqual(parse_blockers(section), [])


class ParseSoftNotesTests(unittest.TestCase):
    def test_recommended_note_captured(self):
        section = (
            "- **Dependencies**: Blocked by [Task 2](task_2_core_interfaces.md). "
            "Recommended to do after the core Flutter-side tasks (1-4) are complete."
        )
        notes = parse_soft_notes(section)
        self.assertEqual(len(notes), 1)
        self.assertIn("Recommended to do after the core Flutter-side tasks (1-4)", notes[0])

    def test_no_note_when_absent(self):
        self.assertEqual(parse_soft_notes("- **Dependencies**: Blocked by [Task 1](task_1.md)."), [])


class ComputeLayersTests(unittest.TestCase):
    def test_linear_chain(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            write_task(directory, "task_1_a.md", epic="demo", priority="high", title="Task 1: A",
                       dependencies_body="- **Dependencies**: None.")
            write_task(directory, "task_2_b.md", epic="demo", priority="high", title="Task 2: B",
                       dependencies_body="- **Dependencies**: Blocked by [Task 1](task_1_a.md).")
            tasks = load_tasks(directory, "demo")
            self.assertEqual(compute_layers(tasks), [["task_1_a"], ["task_2_b"]])

    def test_independent_tasks_share_a_layer_and_sort_by_priority_then_number(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            write_task(directory, "task_1_a.md", epic="demo", priority="high", title="Task 1: A",
                       dependencies_body="- **Dependencies**: None.")
            write_task(directory, "task_2_b.md", epic="demo", priority="medium", title="Task 2: B",
                       dependencies_body="- **Dependencies**: Blocked by [Task 1](task_1_a.md).")
            write_task(directory, "task_3_c.md", epic="demo", priority="high", title="Task 3: C",
                       dependencies_body="- **Dependencies**: Blocked by [Task 1](task_1_a.md).")
            tasks = load_tasks(directory, "demo")
            layers = compute_layers(tasks)
            self.assertEqual(layers[0], ["task_1_a"])
            self.assertEqual(layers[1], ["task_3_c", "task_2_b"])

    def test_ignores_tasks_from_other_epics(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            write_task(directory, "task_1_a.md", epic="demo", priority="high", title="Task 1: A",
                       dependencies_body="- **Dependencies**: None.")
            write_task(directory, "task_9_other.md", epic="other-epic", priority="high", title="Task 9: Other",
                       dependencies_body="- **Dependencies**: None.")
            tasks = load_tasks(directory, "demo")
            self.assertEqual(list(tasks.keys()), ["task_1_a"])

    def test_cycle_raises(self):
        with tempfile.TemporaryDirectory() as tmp:
            directory = Path(tmp)
            write_task(directory, "task_1_a.md", epic="demo", priority="high", title="Task 1: A",
                       dependencies_body="- **Dependencies**: Blocked by [Task 2](task_2_b.md).")
            write_task(directory, "task_2_b.md", epic="demo", priority="high", title="Task 2: B",
                       dependencies_body="- **Dependencies**: Blocked by [Task 1](task_1_a.md).")
            tasks = load_tasks(directory, "demo")
            with self.assertRaises(ValueError):
                compute_layers(tasks)


class RealLoggingRefactorEpicTests(unittest.TestCase):
    """Integration test against this repo's actual logging-refactor tasks.

    Pins the CURRENT state of `.devtool/features/task_*.md` for the
    `logging-refactor` epic. If a task's priority or "Blocked by" line
    changes later, update the expected layers below to match -- that is
    expected maintenance, not a bug in the script.
    """

    FEATURES_DIR = Path(__file__).resolve().parents[5] / ".devtool" / "features"

    def test_computed_layers_match_current_epic_state(self):
        tasks = load_tasks(self.FEATURES_DIR, "logging-refactor")
        layers = compute_layers(tasks)
        self.assertEqual(
            layers,
            [
                ["task_1_create_package"],
                ["task_2_core_interfaces"],
                ["task_3_log_manager", "task_5_network_tracing", "task_7_native_bridge"],
                ["task_4_appenders_di", "task_6_settings_ui"],
                ["task_8_refactor_codebase"],
            ],
        )

    def test_task_7_recommended_note_is_surfaced_not_silently_applied(self):
        tasks = load_tasks(self.FEATURES_DIR, "logging-refactor")
        notes = tasks["task_7_native_bridge"]["soft_notes"]
        self.assertTrue(any("Recommended to do after the core Flutter-side tasks (1-4)" in n for n in notes))


if __name__ == "__main__":
    unittest.main()
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `python3 .agent/skills/epic-implementation/resources/scripts/test_compute_execution_order.py -v`
Expected: FAIL/ERROR — `ModuleNotFoundError: No module named 'compute_execution_order'` (the module doesn't exist yet).

- [ ] **Step 3: Write the implementation**

Create `.agent/skills/epic-implementation/resources/scripts/compute_execution_order.py`:

```python
#!/usr/bin/env python3
"""Compute a sequential execution order for one epic's Kanban tasks.

Reads every `.devtool/features/task_*.md` file whose frontmatter `epic:`
matches the given epic slug, builds a dependency graph from each task's
"## Dependencies & Blockers" section (only lines containing the literal
phrase "Blocked by" count as hard blockers -- this matches the phrasing
epic-designer's own task template prescribes), and prints:

  1. Tasks grouped into layers. Tasks in the same layer have no dependency
     on each other -- they could technically run in parallel, though
     epic-implementation runs them sequentially (see the design spec).
  2. Any "Recommended ..." notes found in that section -- these are NOT
     treated as hard blockers, so review them manually; the computed
     layer for that task may be earlier than the note suggests.
  3. One flattened sequential order: earlier layers first, and within a
     layer, higher priority first, then lower task number first.
"""
import argparse
import re
import sys
from pathlib import Path

PRIORITY_RANK = {"high": 0, "medium": 1, "low": 2}
FRONTMATTER_RE = re.compile(r"^---\n(.*?)\n---\n", re.DOTALL)
SECTION_RE = re.compile(r"##\s*Dependencies\s*&\s*Blockers\s*\n(.*?)(\n##|\Z)", re.DOTALL)
LINK_RE = re.compile(r"\]\(([^)]+\.md)\)")
TITLE_RE = re.compile(r"^#\s*Task\s*\d+:\s*(.+)$", re.MULTILINE)
NUMBER_RE = re.compile(r"\d+")


def parse_frontmatter(text: str) -> dict:
    match = FRONTMATTER_RE.match(text)
    if not match:
        return {}
    fields = {}
    for line in match.group(1).splitlines():
        line = line.strip()
        if not line or ":" not in line:
            continue
        key, _, value = line.partition(":")
        fields[key.strip()] = value.strip().strip('"')
    return fields


def parse_dependencies_section(text: str) -> str:
    match = SECTION_RE.search(text)
    return match.group(1) if match else ""


def parse_blockers(section: str) -> list[str]:
    blockers = []
    for line in section.splitlines():
        if "Blocked by" not in line:
            continue
        blockers.extend(Path(link).stem for link in LINK_RE.findall(line))
    return blockers


def parse_soft_notes(section: str) -> list[str]:
    return [line.strip().lstrip("-").strip() for line in section.splitlines() if "Recommended" in line]


def extract_title(text: str) -> str:
    match = TITLE_RE.search(text)
    return match.group(1).strip() if match else "Untitled"


def load_tasks(features_dir: Path, epic: str) -> dict[str, dict]:
    tasks: dict[str, dict] = {}
    for path in sorted(Path(features_dir).glob("task_*.md")):
        text = path.read_text()
        fm = parse_frontmatter(text)
        if fm.get("epic") != epic:
            continue
        section = parse_dependencies_section(text)
        task_id = fm.get("id", path.stem)
        tasks[task_id] = {
            "id": task_id,
            "path": path,
            "priority": fm.get("priority", "medium"),
            "status": fm.get("status", "todo"),
            "blockers": parse_blockers(section),
            "soft_notes": parse_soft_notes(section),
            "title": extract_title(text),
        }
    return tasks


def compute_layers(tasks: dict[str, dict]) -> list[list[str]]:
    remaining = dict(tasks)
    resolved: set[str] = set()
    layers: list[list[str]] = []

    def sort_key(task_id: str) -> tuple:
        task = tasks[task_id]
        number_match = NUMBER_RE.search(task_id)
        number = int(number_match.group()) if number_match else 0
        return (PRIORITY_RANK.get(task["priority"], 1), number)

    while remaining:
        current_layer = [
            task_id
            for task_id, task in remaining.items()
            if all(b in resolved or b not in tasks for b in task["blockers"])
        ]
        if not current_layer:
            raise ValueError(f"Cycle or missing dependency among: {sorted(remaining)}")
        current_layer.sort(key=sort_key)
        layers.append(current_layer)
        resolved.update(current_layer)
        for task_id in current_layer:
            del remaining[task_id]
    return layers


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("epic", help="Epic slug, e.g. logging-refactor")
    parser.add_argument("--features-dir", default=".devtool/features",
                         help="Directory containing task_*.md files (default: .devtool/features)")
    args = parser.parse_args(argv)

    tasks = load_tasks(Path(args.features_dir), args.epic)
    if not tasks:
        print(f"No tasks found for epic '{args.epic}' in {args.features_dir}", file=sys.stderr)
        return 1

    layers = compute_layers(tasks)

    print(f"Execution plan for epic '{args.epic}' ({len(tasks)} tasks):\n")
    flattened: list[str] = []
    for i, layer in enumerate(layers):
        names = ", ".join(f"{tid} ({tasks[tid]['priority']})" for tid in layer)
        parallel_note = "  -- could run in parallel" if len(layer) > 1 else ""
        print(f"Layer {i}: {names}{parallel_note}")
        flattened.extend(layer)

    print("\nFlattened sequential order:")
    for i, task_id in enumerate(flattened, start=1):
        task = tasks[task_id]
        print(f"  {i}. {task_id} - {task['title']} [{task['priority']}, {task['status']}]")

    soft_notes = {tid: t["soft_notes"] for tid, t in tasks.items() if t["soft_notes"]}
    if soft_notes:
        print("\nManual review advised (not parsed as hard blockers):")
        for task_id, notes in soft_notes.items():
            for note in notes:
                print(f"  {task_id}: {note}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `python3 .agent/skills/epic-implementation/resources/scripts/test_compute_execution_order.py -v`
Expected: all tests PASS, including the two `RealLoggingRefactorEpicTests` cases against the real `.devtool/features/` directory.

- [ ] **Step 5: Manually verify the CLI output reads well**

Run: `python3 .agent/skills/epic-implementation/resources/scripts/compute_execution_order.py logging-refactor`
Expected output includes `Layer 2: task_3_log_manager (high), task_5_network_tracing (medium), task_7_native_bridge (medium)  -- could run in parallel` and a "Manual review advised" line mentioning Task 7's "Recommended to do after" note.

- [ ] **Step 6: Commit**

```bash
git add .agent/skills/epic-implementation/resources/scripts/compute_execution_order.py .agent/skills/epic-implementation/resources/scripts/test_compute_execution_order.py
git commit -m "feat: add execution-order calculator for epic-implementation skill"
```

---

## Task 2: Worktree bootstrap script

**Files:**
- Create: `.agent/skills/epic-implementation/resources/scripts/bootstrap_worktree.sh`
- Test: `.agent/skills/epic-implementation/resources/scripts/test_bootstrap_worktree_validation.sh`

**Interfaces:**
- Produces: `bootstrap_worktree.sh <worktree_path>` — exit 0 on success; exit 1 with a message on stderr if called with the wrong number of arguments, a nonexistent worktree path, or a missing `secureFiles/` in the repo root.
- Consumes: nothing from Task 1 (independent deliverable); both are consumed together by Task 3's `SKILL.md`.

- [ ] **Step 1: Write the failing test**

Create `.agent/skills/epic-implementation/resources/scripts/test_bootstrap_worktree_validation.sh`:

```bash
#!/usr/bin/env bash
# Validates bootstrap_worktree.sh's argument/precondition checks without
# actually running melos/copy_secure_configurations (those are exercised
# for real in Task 4's end-to-end dry run).
#
# Run: bash .agent/skills/epic-implementation/resources/scripts/test_bootstrap_worktree_validation.sh
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$SCRIPT_DIR/bootstrap_worktree.sh"
FAILURES=0

check() {
  local description="$1"
  local expected_substring="$2"
  shift 2
  local output
  output="$("$@" 2>&1)"
  local status=$?
  if [ "$status" -eq 0 ]; then
    echo "FAIL: $description -- expected non-zero exit, got 0"
    FAILURES=$((FAILURES + 1))
    return
  fi
  if ! grep -q "$expected_substring" <<<"$output"; then
    echo "FAIL: $description -- expected output to contain '$expected_substring', got: $output"
    FAILURES=$((FAILURES + 1))
    return
  fi
  echo "PASS: $description"
}

check "no arguments" "Usage:" "$SCRIPT"
check "nonexistent worktree path" "does not exist" "$SCRIPT" "/tmp/definitely-does-not-exist-xyz-$$"

if [ "$FAILURES" -ne 0 ]; then
  echo "$FAILURES check(s) failed"
  exit 1
fi
echo "All checks passed"
```

- [ ] **Step 2: Run test to verify it fails**

Run: `bash .agent/skills/epic-implementation/resources/scripts/test_bootstrap_worktree_validation.sh`
Expected: FAIL — `bootstrap_worktree.sh: No such file or directory` (the script doesn't exist yet).

- [ ] **Step 3: Write the implementation**

Create `.agent/skills/epic-implementation/resources/scripts/bootstrap_worktree.sh`:

```bash
#!/usr/bin/env bash
# Bootstrap a freshly created git worktree so it can actually build/run
# this project. Run from the REPO ROOT (the main checkout, not the new
# worktree), after using-git-worktrees has created the worktree.
#
# This project uses Swift Package Manager, not CocoaPods, so there is no
# `pod install` step -- SPM resolves automatically on the first iOS build.
#
# Usage: bootstrap_worktree.sh <worktree_path>
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <worktree_path>" >&2
  exit 1
fi

WORKTREE_PATH="$1"
REPO_ROOT="$(git rev-parse --show-toplevel)"

if [ ! -d "$WORKTREE_PATH" ]; then
  echo "Worktree path does not exist: $WORKTREE_PATH" >&2
  exit 1
fi

if [ ! -d "$REPO_ROOT/secureFiles" ]; then
  echo "secureFiles/ not found at $REPO_ROOT/secureFiles -- run the check_secure_files skill first" >&2
  exit 1
fi

echo "Copying secureFiles/ into worktree (untracked, so 'git worktree add' does not bring it along)..."
cp -R "$REPO_ROOT/secureFiles" "$WORKTREE_PATH/secureFiles"

echo "Placing platform config via copy_secure_configurations..."
(cd "$WORKTREE_PATH" && sh .agent/skills/copy_secure_configurations/resources/scripts/copy_secure_files.sh)

echo "Running melos bootstrap (fast: ~/.pub-cache is global and already warm)..."
(cd "$WORKTREE_PATH" && melos bootstrap)

echo "Worktree bootstrap complete at $WORKTREE_PATH"
echo "Note: no 'pod install' needed (Swift Package Manager, not CocoaPods)."
echo "The first iOS build here will resolve SPM packages automatically (one-time cost)."
```

Make it executable: `chmod +x .agent/skills/epic-implementation/resources/scripts/bootstrap_worktree.sh`

- [ ] **Step 4: Run test to verify it passes**

Run: `bash .agent/skills/epic-implementation/resources/scripts/test_bootstrap_worktree_validation.sh`
Expected: `PASS: no arguments`, `PASS: nonexistent worktree path`, `All checks passed`.

- [ ] **Step 5: Commit**

```bash
git add .agent/skills/epic-implementation/resources/scripts/bootstrap_worktree.sh .agent/skills/epic-implementation/resources/scripts/test_bootstrap_worktree_validation.sh
git commit -m "feat: add worktree bootstrap script for epic-implementation skill"
```

---

## Task 3: Write the `epic-implementation` SKILL.md

**Files:**
- Create: `.agent/skills/epic-implementation/SKILL.md`

**Interfaces:**
- Consumes: `compute_execution_order.py` (Task 1) and `bootstrap_worktree.sh` (Task 2) by exact relative path; `superpowers:using-git-worktrees`, `superpowers:subagent-driven-development`, `superpowers:test-driven-development`, `superpowers:finishing-a-development-branch`, `copy_secure_configurations` by name.
- Produces: nothing consumed by a later task in this plan (Task 4 exercises it, doesn't import from it).

- [ ] **Step 1: Write the skill file**

Create `.agent/skills/epic-implementation/SKILL.md`:

```markdown
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

**Don't use when:** the epic/tasks don't exist yet (use `brainstorming` then `epic-designer` first), or you're implementing a single one-off task with no epic context (just use `subagent-driven-development` directly).

## Process

### Phase 0 — Context Reload (once, not per task)

Read, in full:
- `.devtool/epic/<epic_name>/<epic_name>.en.md` (the canonical HLD — never `.vi.md` for decisions, that's a synced translation).
- Every `.devtool/features/task_*.md` whose frontmatter `epic:` matches `<epic_name>`.
- Any spec file(s) linked from the HLD's Meta Data section.

This is an autonomous read-and-internalize pass, not a re-run of the interactive `brainstorming` skill — the design is already approved; there is nothing left to ask the user about the architecture itself.

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
```

- [ ] **Step 2: Self-review against the No-Placeholders / writing-skills checklist**

Confirm: frontmatter has only `name`/`description`, description starts with "Use when" and contains no workflow summary beyond triggering conditions, every script path referenced actually exists (from Tasks 1-2), no "TBD"/"TODO" anywhere, every reused skill is named with its `superpowers:` prefix where applicable. Fix inline if any check fails.

- [ ] **Step 3: Commit**

```bash
git add .agent/skills/epic-implementation/SKILL.md
git commit -m "feat: add epic-implementation SKILL.md"
```

---

## Task 4: End-to-end dry run against the real `logging-refactor` epic

**Files:**
- No new files — this task exercises Tasks 1-3's deliverables against the real repo and cleans up after itself.

**Interfaces:**
- Consumes: `compute_execution_order.py` (Task 1), `bootstrap_worktree.sh` (Task 2), the process described in `SKILL.md` (Task 3).

- [ ] **Step 1: Run the order calculator for real and capture output**

Run: `python3 .agent/skills/epic-implementation/resources/scripts/compute_execution_order.py logging-refactor`
Expected: layers exactly as pinned in Task 1's `RealLoggingRefactorEpicTests`, plus a "Manual review advised" line for `task_7_native_bridge`.

- [ ] **Step 2: Create a throwaway worktree via `using-git-worktrees`**

Follow that skill to create a worktree at `.worktrees/epic-implementation-smoke-test` on a new branch `smoke-test/epic-implementation` from `develop`.

- [ ] **Step 3: Run the bootstrap script against it for real**

Run: `.agent/skills/epic-implementation/resources/scripts/bootstrap_worktree.sh .worktrees/epic-implementation-smoke-test`
Expected: exits 0; prints the "Worktree bootstrap complete" line.

- [ ] **Step 4: Verify the worktree can actually see its config and dependencies**

Run:
```bash
test -f .worktrees/epic-implementation-smoke-test/android/app/src/dev/google-services.json && echo "secure config present"
test -f .worktrees/epic-implementation-smoke-test/packages/core/.dart_tool/package_config.json && echo "melos bootstrap succeeded"
```
Expected: both lines print.

- [ ] **Step 5: Clean up the smoke-test worktree**

```bash
git worktree remove .worktrees/epic-implementation-smoke-test
git branch -D smoke-test/epic-implementation
```

- [ ] **Step 6: Run the full test suites for Tasks 1 and 2 one more time together**

```bash
python3 .agent/skills/epic-implementation/resources/scripts/test_compute_execution_order.py -v
bash .agent/skills/epic-implementation/resources/scripts/test_bootstrap_worktree_validation.sh
```
Expected: all pass.

- [ ] **Step 7: Commit** (only if Step 4-6 required any fix; otherwise nothing to commit)

```bash
git add .agent/skills/epic-implementation/
git commit -m "fix: address end-to-end dry run findings for epic-implementation"
```

## Self-Review Notes

- **Spec coverage:** Phase 0-4 + Worktree Bootstrap from the spec are each represented by a section in `SKILL.md` (Task 3); the dependency-graph algorithm (Task 1) and worktree bootstrap steps (Task 2) are the two Non-Goals-adjacent risk areas the spec called out by name, and both get their own dedicated tests including one run against the real epic.
- **Placeholder scan:** no "TBD"/"TODO" in any step; every code block is complete and runnable as written.
- **Type/name consistency:** `load_tasks`/`compute_layers` signatures introduced in Task 1 are the exact names `SKILL.md` (Task 3) and the integration test reference; `bootstrap_worktree.sh <worktree_path>` argument shape is consistent between Task 2's script, its test, `SKILL.md`, and Task 4's dry run.
