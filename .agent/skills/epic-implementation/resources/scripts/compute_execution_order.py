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
# Soft-note markers: keyword list used to surface advisory content that isn't a hard blocker.
# These are small, documented keywords — not a general sentence parser. Phase 0 (full task text)
# in the operating skill is the actual safety net for anything these markers miss.
SOFT_NOTE_MARKERS = ("Recommended", "New dependency")
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
    return [line.strip().lstrip("-").strip() for line in section.splitlines()
            if any(marker in line for marker in SOFT_NOTE_MARKERS)]


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
    # Validate that all blockers reference existing tasks
    for task_id, task in tasks.items():
        for blocker in task["blockers"]:
            if blocker not in tasks:
                raise ValueError(f"Task '{task_id}' is blocked by unknown task '{blocker}'")

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
            if all(b in resolved for b in task["blockers"])
        ]
        if not current_layer:
            raise ValueError(f"Cycle detected among: {sorted(remaining)}")
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
