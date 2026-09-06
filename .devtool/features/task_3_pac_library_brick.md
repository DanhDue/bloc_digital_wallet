---
id: "task_3_pac_library_brick"
status: "todo"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-06T18:05:00.000Z"
modified: "2026-09-06T18:05:00.000Z"
completedAt: null
labels: ["mason", "tooling", "infrastructure"]
order: "a3"
---

# Task 3: Brick `pac_library` Creation

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
Developers frequently need to create internal utility libraries, SDK clients, or shared business logic that are not UI features (so they do not need MVI, BLoC, or AutoRoute) and do not need native platform bindings (so they are not Flutter plugins). Currently, there is no standardized brick for this, leading to ad-hoc folder creation.

Requirements:
1. Create `bricks/pac_library/brick.yaml` with parameters:
   - `name`: Package name in snake_case.
   - `is_flutter`: Boolean (default: true). If false, creates a pure Dart package (no flutter SDK dependency).
2. Implement `__brick__/packages/{{name.snakeCase()}}/`:
   - `lib/{{name.snakeCase()}}.dart`: Public API barrel.
   - `lib/src/{{name.snakeCase()}}_base.dart`: Internal implementation skeleton.
   - `test/{{name.snakeCase()}}_test.dart`: Unit test template.
   - `pubspec.yaml`: Resolution workspace configuration, depending on Flutter SDK if `is_flutter` is true.
   - `analysis_options.yaml`: Pointing to root linter rules.
3. Implement `hooks/post_gen.dart`:
   - Registers `- packages/{{name.snakeCase()}}` in root `pubspec.yaml` `workspace` section.
4. Register `pac_library` in root `mason.yaml`.

## Relevant Files & Context Pointers
- `mason.yaml`
- `pubspec.yaml`
- `packages/core/pubspec.yaml` (structural reference)
- New directory: `bricks/pac_library/`

## Design Rationale
Keeps infrastructure packages strictly separated from features. Providing an automated brick ensures analysis options, workspace resolution, and unit tests are properly set up from day one.
Applicable skill: `writing-skills`.

## TDD Checklist
- [ ] **RED**: Create a test assertion script/test in a scratch folder trying to run `mason make pac_library` before the brick exists.
- [ ] **GREEN**:
  - [ ] Create `bricks/pac_library/brick.yaml`.
  - [ ] Implement `__brick__/packages/{{name.snakeCase()}}/` files.
  - [ ] Implement `hooks/post_gen.dart` to wire into root `pubspec.yaml`.
  - [ ] Register `pac_library: {path: bricks/pac_library}` in `mason.yaml`.
  - [ ] Run `mason get && mason make pac_library --name test_utils --is_flutter true`.
  - [ ] Verify `packages/test_utils/` is generated and added to `pubspec.yaml`.
- [ ] **REFACTOR**:
  - [ ] Run `melos bootstrap`.
  - [ ] Run `fvm flutter test packages/test_utils/test/test_utils_test.dart` and confirm 100% pass.
  - [ ] Clean up `packages/test_utils/` and revert `pubspec.yaml` changes.

## Definition of Done (DoD)
1. `pac_library` brick is registered and resolvable via `mason list`.
2. Running `mason make pac_library` creates a working package in `packages/`.
3. Root `pubspec.yaml` is automatically updated with the new workspace member.
4. The generated package passes `dart analyze` and unit tests cleanly.

## Dependencies & Blockers
- Blocked by: [Task 1](task_1_monorepo_restructuring.md)
- Blocks: None

## References & Rollback
- Source Spec: [2026-09-06-flutter-super-app-template-design.md](../epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md) §4.2
- Rollback: Delete `bricks/pac_library/` and remove entry from `mason.yaml`.
