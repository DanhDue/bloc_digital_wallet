---
id: "task_10_app_event_bus"
status: "done"
priority: "high"
assignee: null
epic: "super_app_governance"
dueDate: null
created: "2026-08-26T10:00:00.000Z"
modified: "2026-08-26T18:40:41.000Z"
completedAt: "2026-08-26T18:40:41.000Z"
labels: ["architecture", "platform", "event-bus"]
order: "a10"
---
# Task 10: Implement `AppEventBus`

Epic: [super_app_governance](../epic/super_app_governance/super_app_governance.en.md)

## Requirement Analysis
No Event Bridge exists anywhere in the codebase today — cross-feature signals (when one Mini App needs to tell another something happened) have no sanctioned mechanism, which is part of why direct imports crept in. This task adds a typed, broadcast-stream `AppEventBus` to the `platform` package (created in Task 9), giving Mini Apps a way to publish/subscribe without importing each other.

## Relevant Files & Context Pointers
- `packages/platform/lib/app_event_bus.dart` (new) — `AppEvent` base class + `AppEventBus`.
- `packages/platform/lib/di/injection.dart` — register `AppEventBus` as `@lazySingleton`.
- `packages/platform/lib/platform.dart` — export `app_event_bus.dart` from the barrel.
- `packages/framework/lib/mvi_base.dart` — reference for the existing Action/State/Event naming convention this should mirror.
- `packages/platform/test/app_event_bus_test.dart` (new).

## Design Rationale
```dart
abstract class AppEvent {}

@lazySingleton
class AppEventBus {
  final _controller = StreamController<AppEvent>.broadcast();
  void publish(AppEvent event) => _controller.add(event);
  Stream<T> on<T extends AppEvent>() => _controller.stream.whereType<T>();
}
```
Each feature defines its own `AppEvent` subclasses in its own barrel (not here) — this task only builds the bus itself, no concrete event types yet (those arrive with their first real publisher/subscriber, e.g. in Task 14). No central event-type registry is needed: a subscriber importing another feature's event *type* is acceptable, since event classes are data contracts, the same posture as importing a domain entity. See the source spec's "AppEventBus (new)" section.

## TDD Checklist
- [ ] **RED**: Write failing tests — a single subscriber receives a published event; `on<T>()` filters out events of unrelated types; multiple subscribers each receive the same published event independently; publishing before any subscription doesn't throw (broadcast stream semantics).
- [ ] **GREEN**: Implement `AppEvent`/`AppEventBus` to pass the tests above.
- [ ] **REFACTOR**: Clean up; confirm the DI registration resolves via `getIt<AppEventBus>()` in a widget/bloc test context.

## Definition of Done (DoD)
- [ ] All tests in `app_event_bus_test.dart` pass.
- [ ] ≥80% line coverage on `app_event_bus.dart`.
- [ ] `flutter analyze` clean on `packages/platform`.
- [ ] `AppEventBus` is registered in `platform`'s DI module and resolvable via `getIt`.

## Dependencies & Blockers
Blocked by [Task 9](task_9_create_platform_package.md) — requires the `platform` package to exist.

## References & Rollback
- Source spec: [AppEventBus (new) section](../epic/super_app_governance/2026-08-26-super-app-governance-design.md#platform-package).
- Rollback: delete `app_event_bus.dart` + its DI registration — no consumers exist yet at this point in the epic, zero blast radius.
