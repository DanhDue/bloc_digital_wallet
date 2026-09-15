---
id: "task_5_pac_native_plugin_ios_bgtask"
status: "todo"
priority: "high"
assignee: null
epic: "flutter_super_app_template"
dueDate: null
created: "2026-09-15T13:20:00Z"
modified: "2026-09-15T13:20:00Z"
completedAt: null
labels: ["mason", "ios", "factorykit", "bgtaskscheduler", "swiftui", "spm", "bricks"]
order: "a5"
---

# Task 5: Brick `pac_native_plugin` — iOS BGTaskScheduler & FactoryKit

Epic: [flutter_super_app_template](../epic/flutter_super_app_template/flutter_super_app_template.en.md)

## Requirement Analysis
Upgrade the iOS portion of the `bricks/pac_native_plugin` Mason template to achieve 100% architectural parity with iOS Devbed `Plugin` (`ios_digital_wallet`):
1. **SwiftPM `Package.swift` Configuration**:
   - Deliver plugin via Flutter SwiftPM (`ios/{{name.snakeCase()}}/Package.swift`), targeting `platforms: [.iOS("15.0")]`.
   - Declare exact dependency on `Factory` 3.3.2 (`import FactoryKit`).
   - Eliminate any reliance on CocoaPods `.podspec` for generated plugins.
2. **Dedicated FactoryKit DI Container**:
   - Generate `Sources/{{name.snakeCase()}}/{{name.pascalCase()}}Container.swift` inheriting from `SharedContainer`.
   - Provide clean factory registrations for Repository and UseCases.
   - Avoid global `Container.shared` to eliminate inter-plugin collision.
3. **Zero Flutter Engine Background Execution (BGTaskScheduler)**:
   - Generate `Data/Background/{{name.pascalCase()}}SyncTask.swift`.
   - Register BGTask identifier in `{{name.pascalCase()}}Plugin.register(with:)` strictly before application launch returns.
   - Handle background processing task using UseCase from `{{name.pascalCase()}}Container.shared` without spinning up a headless `FlutterEngine`.
4. **SwiftUI & PlatformView (When `has_ui: true`)**:
   - Generate `Presentation/` with `MviViewModel.swift` (Combine `@Published` + `PassthroughSubject`), `{{name.pascalCase()}}View.swift`, and `{{name.pascalCase()}}PlatformView.swift` wrapping `UIHostingController` into `FlutterPlatformView`.
   - Generate `Platform/{{name.pascalCase()}}PlatformViewFactory.swift`.
5. **Swift Tests**:
   - Generate `Tests/{{name.snakeCase()}}Tests/` covering container overrides, task execution, and ViewModel.

## Relevant Files & Context Pointers
- `bricks/pac_native_plugin/brick.yaml`
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/ios/{{name.snakeCase()}}/Package.swift`
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/ios/{{name.snakeCase()}}/Sources/{{name.snakeCase()}}/{{name.pascalCase()}}Container.swift`
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/ios/{{name.snakeCase()}}/Sources/{{name.snakeCase()}}/Data/Background/{{name.pascalCase()}}SyncTask.swift` [NEW]
- `bricks/pac_native_plugin/__brick__/packages/{{name.snakeCase()}}/ios/{{name.snakeCase()}}/Sources/{{name.snakeCase()}}/{{name.pascalCase()}}Plugin.swift`
- Reference: `/Users/danhdueexoictif/AllProjects/digital_wallet/ios_digital_wallet/Plugin/`

## Design Rationale
- **Container Isolation**: Dedicated `SharedContainer` per plugin ensures that two plugins generated with `pac_native_plugin` in the same Flutter project can never collide or override each other's registrations.
- **Strict Apple Lifecycle Compliance**: `BGTaskScheduler.register` must happen before `didFinishLaunchingWithOptions` finishes; placing it inside Flutter's `register(with:)` guarantees compliance.
- **Applicable Skills**: `ios-ui-audit`, `writing-skills`.

## Impact Analysis & Blast Radius
- **Target Files & Symbols**: `bricks/pac_native_plugin` iOS files.
- **Downstream Callers**: All newly generated native plugins in `packages/`.
- **Cross-Platform Bridges**: `Messages.g.swift`, `FlutterPlatformViewFactory`.
- **Target Test Coverage Threshold**: 100% compilation pass; $\ge 85\%$ line coverage for generated Swift unit tests.

### BDD SCENARIOS

#### Scenario 5.1: [Tier A - Unit] Scaffolding Headless iOS Plugin (`has_ui: false`)
```gherkin
When running "mason make pac_native_plugin --name device_monitor --has_ui false"
Then "packages/device_monitor/ios/device_monitor/Package.swift" is generated targeting iOS 15
And declares dependency on FactoryKit 3.3.2
And "Sources/device_monitor/Data/Background/DeviceMonitorSyncTask.swift" is created
And no "Presentation/" folder is generated
```

#### Scenario 5.2: [Tier A - Unit] Scaffolding UI-Enabled iOS Plugin (`has_ui: true`)
```gherkin
When running "mason make pac_native_plugin --name custom_scanner --has_ui true"
Then "Sources/custom_scanner/Presentation/CustomScannerView.swift" is generated with SwiftUI
And "Sources/custom_scanner/Presentation/CustomScannerPlatformView.swift" wraps UIHostingController
And "Sources/custom_scanner/CustomScannerPlugin.swift" registers PlatformViewFactory
```

#### Scenario 5.3: [Tier A - Unit] Zero Engine Background Task Handler
```gherkin
Given "DeviceMonitorSyncTask" triggered with a mock "BGProcessingTask"
When "handle(task)" is invoked
Then it resolves "SyncDeviceMonitorDataUseCase" from "DeviceMonitorContainer.shared"
And executes asynchronous work without launching a "FlutterEngine"
And calls "task.setTaskCompleted(success: true)" upon completion
```

#### Scenario 5.4: [Tier C - Integration] PlatformView Registration in Flutter Host
```gherkin
Given a generated plugin with "has_ui: true"
When the Flutter app launches on an iOS simulator
Then the UiKitView embeds the SwiftUI View cleanly
And user touches propagate without gesture blocking
```

## Test & Verification Checklist
- [ ] **RED**: Assert template failure when `BGTaskScheduler` registration or FactoryKit import is missing.
- [ ] **GREEN**: Add `DataSyncTask.swift` and update `*Plugin.swift` and `Package.swift` in `pac_native_plugin`.
- [ ] **REFACTOR**: Validate Swift formatting, access control levels (`public`/`internal`), and documentation comments.
- [ ] **Tier C (Integration)**: Run `mason make pac_native_plugin --name test_ios_plugin --has_ui true` in a testbed and verify `Package.swift` syntax.

## Definition of Done (DoD)
- SwiftPM `Package.swift` targets iOS 15 floor and FactoryKit 3.3.2.
- Dedicated `SharedContainer` subclass is generated.
- `BGTaskScheduler` background task handler is generated and registered in `Plugin.register(with:)`.
- `has_ui` false and true both generate valid, compiling SPM layouts.

## Dependencies & Blockers
- Independent. Can be developed in parallel with Android tasks.

## References & Rollback
- References: Spec Section 5, HLD Section 4.
- Rollback: `git checkout HEAD -- bricks/pac_native_plugin/`.
