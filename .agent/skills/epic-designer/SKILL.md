---
name: epic-designer
description: Use when analyzing high-level requirements to design a complete software Epic, including High-Level Design (HLD), Mermaid diagrams, and Kanban task breakdowns.
---

# Epic Designer

## Overview
This skill transforms high-level product or technical requirements into a structured, developer-ready Epic. It creates a centralized High-Level Design (HLD) document and breaks the work down into granular Kanban tasks enforcing Test-Driven Development (TDD) and strict Definition of Done (DoD).

## When to Use
- When the user provides a high-level requirement or problem statement and asks for a technical design or task breakdown.
- When starting a new major feature, epic, or large-scale refactoring.
- When generating architecture diagrams (Use Cases, Sequence, Architecture) and converting them into actionable tasks.
- When the `brainstorming` skill routes here after spec approval, for a spec it judged epic-scale.

## Input

This skill can start from either:

1. **A raw high-level requirement** given directly by the user (standalone use).
2. **An approved spec from the `brainstorming` skill** (preferred entry point — the spec has already been through clarifying questions, alternatives, and user approval). For epic-scale work, `brainstorming` relocates the spec file into this epic's own directory, `.devtool/epic/<epic_name>/<same-filename>.md`, before invoking this skill — so the spec already lives alongside the HLD and task files this skill generates.

When invoked with an approved spec, **treat it as the source of truth for scope and decisions already made** — do not re-litigate architecture choices or trade-offs the user already approved. Your job is to *formalize* it: translate its architecture/components/data-flow into the Mermaid diagrams and structured sections below, and break it into Kanban tasks. If the spec is missing something this skill requires (e.g., a rollout strategy), fill the gap, but don't override decisions the spec already made.

Record the link back to the source in the Epic's **Meta Data** section, e.g. `Source Spec: [<topic>-design.md](<file>.md)` — a same-directory link, since the spec already lives in this epic's directory — so the HLD and the original spec stay traceable to each other without leaving `.devtool/epic/<epic_name>/`. If there is no source spec (standalone use), omit this field.

If the original brainstorming request was decomposed into multiple sub-project specs, each spec maps to **its own separate epic** — never merge multiple specs into one epic directory.

## Workflow / Prompt Instructions

When invoked, you MUST strictly follow this exact 2-step workflow to organize the user's requirements:

### Step 1: Create the Epic Overview Document (HLD/RFC)
Generate the Epic Overview documents inside a dedicated directory: `.devtool/epic/<epic_name>/`.
You MUST generate two language variants for the overview document:
- English: `.devtool/epic/<epic_name>/<epic_name>.en.md`
- Vietnamese: `.devtool/epic/<epic_name>/<epic_name>.vi.md`

Each document MUST contain the following sections:

1. **Meta Data**: Epic name, Status, Target Release, and `Source Spec` link if this epic was derived from an approved brainstorming spec (see Input section above).
2. **Background (Bối cảnh)**: The problem statement or context (Why are we doing this?).
3. **Goals & Non-Goals**: Clearly define what is expected to be achieved and what is strictly out of scope to avoid scope creep.
4. **Architecture & Technical Design**:
   - **High-Level Architecture**: Use a `mermaid graph TD` to show component interactions.
   - **Use Cases**: Use a `mermaid flowchart` to define Actors and their interactions with the system.
   - **Sequence Diagram**: Use a `mermaid sequenceDiagram` to show the step-by-step lifecycle of the primary flow.
5. **Rollout Strategy & Mitigation**: Describe how to deploy this safely (e.g., phased rollout, feature flags) and fallback plans.
6. **Kanban Tasks Breakdown**: A list of links pointing to the individual task files created in Step 2.

**Canonical language**: The `.en.md` variant is the source of truth for tooling/agents — always write and update it first. The `.vi.md` variant is a translation for local team communication and MUST be kept in sync whenever the `.en.md` changes; never let the two diverge in structure or facts.

### Checkpoint: Confirm Task Breakdown Before Writing Task Files
Before generating any task file, list the proposed tasks as a short numbered summary (title + one-line scope each) and ask the user to confirm the breakdown and granularity. This is a lightweight check, not a full brainstorming dialogue — the architecture is already approved (from the spec or from this skill's own Step 1); only the *task split* is new and unapproved. Only proceed to write task files once the user confirms or adjusts the list.

### Step 2: Generate LachyFS Kanban Tasks
Break the Epic down into granular implementation tasks. **Crucially, the task breakdown and implementation checklists MUST be structured around the Test-Driven Development (TDD) process** wherever the task produces testable behavior (see the TDD Adaptation note below for tasks that don't). For each task, generate a Markdown file located at `.devtool/features/task_<number>_<name>.md`.

Task files are English-only — do not generate a `.vi.md` variant for tasks and do not mix Vietnamese prose into section headers or body. The English/Vietnamese pairing applies only to the Epic Overview document from Step 1.

Each task file MUST adhere to this exact structure:

1. **YAML Frontmatter (LachyFS Kanban Markdown compatible)**:
   ```yaml
   ---
   id: "task_<number>_<name>"
   status: "todo"          # one of: backlog | todo | in-progress | review | done
   priority: "high"        # one of: low | medium | high
   assignee: null
   epic: "<epic_name>"
   dueDate: null
   created: "<ISO-8601 timestamp, set once at creation>"
   modified: "<ISO-8601 timestamp, update on every edit>"
   completedAt: null       # set to an ISO-8601 timestamp only when status becomes "done"
   labels: ["architecture", "feature"]
   order: "a<number>"
   ---
   ```
2. **Title**: `# Task <number>: <Task Name>`
3. **Epic Reference**: A link back to the parent HLD, e.g. `Epic: [<epic_name>](../epic/<epic_name>/<epic_name>.en.md)`. This is the agent's entry point back to architecture/diagram context.
4. **Requirement Analysis**: Context and requirements specific to this task.
5. **Relevant Files & Context Pointers**: An explicit bullet list of exact file/directory paths this task reads or modifies (e.g. `packages/core/lib/utils/log.dart`). This is what lets an agent load full context in one pass instead of searching — always populate it, even if just 2-3 paths.
6. **Design Rationale**: Architecture decisions or design patterns chosen. **Crucially, review the available skills in `.agent/skills/` and if any skill is directly applicable to this task (e.g., `api_integration`, `mobile-uiux-promax`), explicitly note it here so the developer or agent knows which skill to invoke when implementing.**
7. **TDD Checklist**:
   - [ ] **RED**: Write failing tests (Unit/Widget/Integration).
   - [ ] **GREEN**: Write minimal code to pass the tests.
   - [ ] **REFACTOR**: Clean up code and optimize.

   **TDD Adaptation**: For tasks that are pure refactors, mass find/replace, or config/infra changes with no new behavior (e.g. "replace all call sites"), RED/GREEN/REFACTOR doesn't literally apply. Replace the checklist with concrete, verifiable steps instead (what to change, then "run the existing test suite / `melos run analyze` to confirm no regression"), and say explicitly in the task why TDD was adapted. Never silently drop structure — state the substitution.
8. **Definition of Done (DoD)**: Acceptance criteria (e.g., 80% coverage, linting passed).
9. **Dependencies & Blockers**: Link to blocking/blocked task files as markdown links (e.g. `Blocked by [Task 1](task_1_create_package.md)`), not prose-only references.
10. **References & Rollback**: Links to docs, APIs, and a rollback strategy if this specific task fails.

### Step 3: Finalize & Commit
After the Epic Overview and all confirmed task files are written (or updated), commit them to git — mirroring the `brainstorming` skill's convention:

- Read `.agent/config.yml` — check the `auto_commit` setting.
- If `auto_commit: true` (default when absent): stage exactly the generated/modified paths (the epic's `.devtool/epic/<epic_name>/` directory and each new/modified `.devtool/features/task_*.md` file) — never `git add .` or `git add -A`, to avoid staging unrelated changes. Then commit:
  - New epic: `git commit -m "docs: generate epic and tasks for <epic_name>"`
  - Update to an existing epic: `git commit -m "docs: add tasks to epic <epic_name>"`
- If `auto_commit: false`: skip staging and committing entirely. Print: "Skipping commit (auto_commit: false in .agent/config.yml). Files are ready for manual commit."

### Updating an Existing Epic
When new requirements arrive for an epic already in progress, do not regenerate or renumber existing files. Append new task files continuing the existing number/`order` sequence, and append their links to the Epic Overview's Kanban Tasks Breakdown section (in both language variants).

**CRITICALLY**: If the new requirements change the architecture, data flow, or actors (e.g. a new task introduces a new component like `TraceInterceptor`), you MUST also update the corresponding Mermaid diagrams (Architecture graph, Use Cases flowchart, Sequence diagram) in the Epic Overview — in both language variants. Do not let the diagrams silently go stale while only the task list grows.

Finally, update the Epic's **Status** field if the overall epic phase has changed. Only edit an existing task file in place if its own scope changed before implementation started. Apply Step 3 (Finalize & Commit) here too — commit the updated/new files once confirmed.

## Red Flags - STOP and Start Over
- Writing task files before the user has confirmed the task breakdown checkpoint.
- Generating tasks without a TDD checklist or an explicit, stated TDD Adaptation.
- Creating the Epic overview in the project root instead of `.devtool/epic/<epic_name>/`.
- Generating Kanban tasks without the LachyFS YAML Frontmatter.
- Skipping the Mermaid diagrams in the Epic Overview.
- Adding a task that changes architecture/data flow/actors without updating the Epic Overview's Mermaid diagrams to match.
- A task file missing its Epic Reference link or Relevant Files section.
- Mixing languages within a single task file.

If you violate any of these red flags, delete the generated files and start over.
