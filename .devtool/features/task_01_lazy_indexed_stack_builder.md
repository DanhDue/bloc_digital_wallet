---
id: "task_01_lazy_indexed_stack_builder"
status: "todo"
priority: "high"
assignee: null
epic: "startup_rendering_optimization"
dueDate: null
created: "2026-09-17T18:00:00+07:00"
modified: "2026-09-17T18:00:00+07:00"
completedAt: null
labels: ["ui_kit", "rendering", "lazy-loading"]
order: "a1"
---

# Task 01: True Lazy Builder for LazyIndexedStack

## Context & Objectives
Refactor `LazyIndexedStack` in `packages/ui_kit/lib/widgets/lazy_indexed_stack.dart` to support a true lazy builder pattern using `itemCount` and `itemBuilder: (BuildContext context, int index)` (alongside backwards-compatible constructors). Inactive tab builders must never be evaluated or instantiated in memory until their index is activated.

---

## BDD Acceptance Criteria

```gherkin
Feature: LazyIndexedStack Builder Evaluation

  Scenario: Only active tab builder is evaluated on initial mount
    Given a LazyIndexedStack with itemCount 3 and default index 2
    When the widget is pumped into the element tree
    Then itemBuilder should be invoked for index 2
    And itemBuilder should NOT be invoked for index 0 or index 1
    And the rendered tree should contain SizedBox.shrink for indices 0 and 1

  Scenario: Inactive tab builder is triggered only upon switching
    Given LazyIndexedStack is mounted at index 2 with only child 2 active
    When the index is updated to 0
    Then itemBuilder should be invoked for index 0
    And both child 0 and child 2 should now be preserved in the stack

  Scenario: Clamped index handling
    Given a LazyIndexedStack with itemCount 3
    When an out-of-bounds index -1 or 10 is passed
    Then the index is clamped safely between 0 and 2 without throwing an exception
```

---

## TDD Implementation Steps

### 1. QA Red Team (Test Authoring)
- Update `packages/ui_kit/test/widgets/lazy_indexed_stack_test.dart` with builder tests:
  - Track `List<int> builtIndices = []`.
  - Mount `LazyIndexedStack(index: 2, itemCount: 3, itemBuilder: (context, i) { builtIndices.add(i); return Text('Tab $i'); })`.
  - Assert `builtIndices` contains only `[2]`.
  - Update `index` to 0 via `tester.pumpWidget(...)`.
  - Assert `builtIndices` contains `[2, 0]`.

### 2. TDD Master (Implementation)
- Modify `LazyIndexedStack` in `packages/ui_kit/lib/widgets/lazy_indexed_stack.dart`:
  - Add `NullableIndexedWidgetBuilder itemBuilder` and `int itemCount`.
  - Ensure backward compatibility constructor or direct migration.
  - In `build()`, only call `widget.itemBuilder(context, i)` if `_activatedIndices.contains(i)`, otherwise return `const SizedBox.shrink()`.
- Export if necessary in `packages/ui_kit/lib/ui_kit.dart`.

### 3. System Integration & Verification
- Run `fvm flutter test packages/ui_kit/test/widgets/lazy_indexed_stack_test.dart`.
- Run `fvm flutter analyze packages/ui_kit`.
- Ensure zero errors and zero warnings.

---

## Definition of Done (DoD)
- [ ] Widget unit tests pass 100%.
- [ ] Zero builder calls for inactive tabs.
- [ ] 0 analyzer issues, formatting compliant with 99-character line length.
