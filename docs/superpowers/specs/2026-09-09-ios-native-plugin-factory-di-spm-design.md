# iOS Native Plugin — FactoryKit DI + Flutter Swift Package Manager — Design Spec

## 1. Metadata
- **Topic**: `ios-native-plugin-factory-di-spm`
- **Date**: 2026-09-09
- **Status**: Draft — pending user review
- **Parent Epic**: `flutter_super_app_template` (amends `.devtool/epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md` §4.3, §4.4, §8)
- **Reference (read-only)**: `/Users/danhdueexoictif/AllProjects/digital_wallet/ios_digital_wallet` — already migrated to Factory at commit `44716e9 [DI] use the Factory for the DI.` Used only as the pattern reference; not modified by this work.
- **Chosen approach**: Approach B — bricks first, defer existing-plugin & host full migration.

---

## 2. Background & Problem Statement

The Flutter Super App Template's `pac_native_plugin` brick generates the iOS side of a plugin as a **CocoaPods podspec** (`ios/<name>.podspec` + `ios/Classes/**`), and wires dependencies with **plain constructor injection + default arguments**:

```swift
public init(repository: FooRepository = FooRepositoryImpl()) { ... }
```

The reference iOS template (`ios_digital_wallet`) has since standardised on the **Factory** DI library (`hmlongco/Factory`): `Packages/Platform` re-exports it (`@_exported import Factory` in `DIExports.swift`), each feature owns an `XxxContainer.swift` (`extension Container { var xxx: Factory<T> {...} }`) with safe defaults, and `App/Composition/AppComposition.swift` overrides those with production implementations via `Container.shared.xxx.register { ... }`. That repo uses SwiftPM + Tuist and pins `Factory` `exact: "2.4.3"`.

We want the Flutter template's generated iOS code to adopt the same DI philosophy. Two facts shape the solution:

1. **Factory 3.x dropped CocoaPods.** The module was renamed `FactoryKit` (`import FactoryKit`) and is SPM-only. The last CocoaPods-capable line is `Factory` 2.4.x/2.5.3 (`import Factory`), now frozen.
2. **Flutter 3.44+ supports Swift Package Manager for plugins**, running SPM plugins and CocoaPods plugins side by side in the same app. The template is on **Flutter 3.47.0** (`.fvmrc`), so the modern SPM plugin layout is available.

Therefore adopting Factory 3.x (`FactoryKit`) for generated plugins implies moving those plugins to SPM.

---

## 3. Scope

### 3.1 In scope (this task)
1. **Enable Flutter SPM for the template** — minimal, hybrid-safe host change.
2. **Rewrite the iOS side of `pac_native_plugin`** — SPM package layout, `FactoryKit` dependency, one `SharedContainer` subclass per plugin, `@Injected` consumers, `register(with:)` as the composition point.
3. **Update `pac_add_native_ui`** — emit `Presentation/` in the new SPM layout; patch the SPM-layout plugin class.
4. **Update brick hooks** — drop podspec handling, adjust paths, adjust Pigeon `swiftOut`.
5. **`pac_rename_project` light touch** — rewrite the `Package.swift` `name` / library-product tokens for generated SPM plugins (see R5); no other rename change.
6. **Update documentation** — parent epic spec §4.3 / §4.4 / §8 and the epic HLD (`flutter_super_app_template.en.md` / `.vi.md`).

### 3.2 Explicitly deferred (tracked as a follow-up epic, NOT done here)
- Migrating the existing shipped plugins `native_security` (incl. its C++/FFI `native_security.cpp` / `.h`) and `logger_native_bridge` from podspec to `Package.swift`.
- Removing CocoaPods entirely from `ios/Runner` (Podfile / Pods / `flutter_install_all_ios_pods`).
- Replacing or forking third-party plugins that lack upstream SPM support (`image_gallery_saver_plus`, `animated_item`, `pretty_animated_text` — to be verified).

### 3.3 Non-goals
- **Android side of the bricks** — unchanged (Kotlin plugins keep self-contained manual constructor injection per parent epic §4.3).
- **The Dart side of any plugin** — unchanged. No Dart DI module is added; the existing `get_it` / `injectable` mechanism used elsewhere is untouched (parent epic non-goal: "không thay get_it").
- **Legacy `lib/features/` bricks** (`mvi_feature`, …) — untouched.
- **The `ios_digital_wallet` repository** — reference only.

---

## 4. Decisions

| # | Decision | Rationale |
|---|---|---|
| D1 | Generated plugins are **SPM-only** — the brick emits `ios/<name>/Package.swift` and **no `.podspec`**. | FactoryKit 3.x has no CocoaPods spec; dual support would force the pod path onto `Factory` 2.4.3 and split the API surface (`import Factory` vs `import FactoryKit`). The template host has SPM enabled, so generated plugins resolve. Trade-off accepted: a generated plugin is not consumable by a non-SPM host. |
| D2 | DI library: **FactoryKit 3.x** via `.package(url: "https://github.com/hmlongco/Factory.git", from: "3.x")`, exact version pinned in the brick template so every generated `Package.swift` matches. | Current, maintained line; Swift 6 concurrency & Swift Testing friendly. |
| D3 | DI topology: **one `SharedContainer` subclass per plugin** (`final class <Name>Container: SharedContainer`), no shared/global container, no central iOS infra package. | Mirrors the Android bricks' self-contained plugins (parent epic §4.3). The Flutter host has no Swift composition root to own a global `Container.shared`; a per-plugin container avoids cross-plugin name collisions and keeps each plugin independently testable. |
| D4 | `register(with registrar:)` is the plugin's **composition root** — it overrides any container default that needs `FlutterPluginRegistrar` / `messenger` before the ViewModel / HostApi is built. | The only per-plugin hook Flutter gives that has access to the engine-scoped objects. |
| D5 | The `MviViewModel` base stays **copied into each plugin** (`Sources/<name>/Presentation/MviViewModel.swift`). | Consistency with the parent epic's "self-contained, no hard external path" rule; no shared package to hold it (D3). |
| D6 | Approach B: **bricks first**, existing plugins + host full migration deferred (§3.2). | User selection. Flutter's hybrid SPM+CocoaPods support makes this safe: pod plugins keep working while new plugins are SPM. |
| D7 | Route the follow-up implementation to **`writing-plans`**, not `epic-designer`. | Approach B is a single coherent implementation plan (2 brick rewrites + host enablement + doc edits), not a multi-component epic. |

---

## 5. Enabling Flutter SPM (host-side, minimal)

- Add `flutter config --enable-swift-package-manager` to developer setup docs and CI setup steps. Requires Flutter ≥ 3.44 — template is on 3.47.0, satisfied.
- On the first `flutter run` / `flutter build ios` with SPM enabled, the Flutter CLI performs a one-time migration of `ios/Runner.xcodeproj`, adding the local `FlutterGeneratedPluginSwiftPackage` package reference to the `Runner` target. This is committed to the template.
- **CocoaPods stays** for `ios/Runner`: `native_security`, `logger_native_bridge`, and all third-party pods continue to resolve via CocoaPods unchanged. SPM and CocoaPods plugins coexist.
- `scripts/buildIPA.sh` and other build scripts: no logic change; only the one-time `flutter config` in setup.

---

## 6. `pac_native_plugin` — new iOS layout

### 6.1 Directory structure
```
packages/{{name.snakeCase()}}/
├── pubspec.yaml                       # flutter.plugin.platforms.ios.pluginClass unchanged;
│                                      # Flutter auto-discovers ios/{{name}}/Package.swift
├── pigeons/{{name}}_messages.dart     # [has_ui=false] @ConfigurePigeon swiftOut →
│                                      #   ios/{{name}}/Sources/{{name}}/Messages.g.swift
├── lib/                               # Dart side — UNCHANGED from today's brick
│   ├── {{name.snakeCase()}}.dart
│   ├── src/messages.g.dart            # [has_ui=false] Pigeon dartOut
│   └── src/ui/{{name}}_native_view.dart  # [has_ui=true]
└── ios/
    └── {{name}}/
        ├── Package.swift
        └── Sources/{{name}}/
            ├── {{name.pascalCase()}}Plugin.swift        # composition root (register(with:))
            ├── {{name.pascalCase()}}Container.swift      # final class …Container: SharedContainer
            ├── Platform/
            │   ├── {{name.pascalCase()}}HostApiImpl.swift        # [has_ui=false] Pigeon impl
            │   └── {{name.pascalCase()}}PlatformViewFactory.swift # [has_ui=true]
            ├── Domain/{{name.pascalCase()}}Repository.swift       # pure Swift protocol
            ├── Data/{{name.pascalCase()}}DataSource.swift         # concrete impl (Apple frameworks)
            └── Presentation/                             # [CHỈ SINH KHI has_ui=true]
                ├── MviViewModel.swift                    # base, copied per plugin
                ├── {{name.pascalCase()}}ViewModel.swift
                ├── {{name.pascalCase()}}Action.swift / State.swift / Event.swift
                ├── {{name.pascalCase()}}View.swift        # SwiftUI
                └── {{name.pascalCase()}}PlatformView.swift # UIHostingController → FlutterPlatformView
```

### 6.2 `Package.swift` (brick template)
```swift
// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "{{name.snakeCase()}}",
    platforms: [.iOS("13.0")],
    products: [
        .library(name: "{{name.paramCase()}}", targets: ["{{name.snakeCase()}}"]),
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // Pin to an exact 3.x tag in the brick template (resolve the latest 3.x at
        // implementation time; 3.0.0 is the floor). Every generated Package.swift
        // carries the same pinned version.
        .package(url: "https://github.com/hmlongco/Factory.git", exact: "3.0.0"),
    ],
    targets: [
        .target(
            name: "{{name.snakeCase()}}",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "FactoryKit", package: "Factory"),
            ]
        ),
        .testTarget(
            name: "{{name.snakeCase()}}Tests",
            dependencies: ["{{name.snakeCase()}}"]
        ),
    ]
)
```
Library product name uses `paramCase` (hyphens) per Flutter's SPM naming rule; package & target names use `snakeCase`.

### 6.3 Per-plugin container — `{{Name}}Container.swift` (both `has_ui` modes)
```swift
import FactoryKit

public final class {{name.pascalCase()}}Container: SharedContainer {
    public static let shared = {{name.pascalCase()}}Container()
    public let manager = ContainerManager()
}

extension {{name.pascalCase()}}Container {
    var repository: Factory<{{name.pascalCase()}}Repository> {
        self { {{name.pascalCase()}}DataSource() }        // safe default; no registrar needed
    }
}
```

### 6.4 Composition root — `{{Name}}Plugin.swift`
```swift
import Flutter
import FactoryKit

public final class {{name.pascalCase()}}Plugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        // Override any default that needs engine-scoped objects, BEFORE building consumers:
        // {{name.pascalCase()}}Container.shared.repository.register { {{name.pascalCase()}}DataSource(messenger: registrar.messenger()) }

        {{#has_ui}}
        let factory = {{name.pascalCase()}}PlatformViewFactory { {{name.pascalCase()}}ViewModel() }
        registrar.register(factory, withId: "com.danhdue.{{name.snakeCase()}}/native_view")
        {{/has_ui}}
        {{^has_ui}}
        let api = {{name.pascalCase()}}HostApiImpl()
        {{name.pascalCase()}}HostApiSetup.setUp(binaryMessenger: registrar.messenger(), api: api)
        {{/has_ui}}
    }
}
```

### 6.5 Consumers resolve via the plugin's container
```swift
// has_ui=false — Platform/{{Name}}HostApiImpl.swift
final class {{name.pascalCase()}}HostApiImpl: {{name.pascalCase()}}HostApi {
    @Injected(\{{name.pascalCase()}}Container.repository) private var repository
    func getStatus() throws -> String { /* ... uses repository ... */ }
}

// has_ui=true — Presentation/{{Name}}ViewModel.swift
public final class {{name.pascalCase()}}ViewModel: MviViewModel<{{name.pascalCase()}}Action, {{name.pascalCase()}}State, {{name.pascalCase()}}Event> {
    @Injected(\{{name.pascalCase()}}Container.repository) private var repository

    public init() { super.init(initialState: {{name.pascalCase()}}State()) }
    // ... onAction ...
}
```
The current `init(repository: FooRepository = FooRepositoryImpl())` default-argument pattern is removed. Tests override with `{{name.pascalCase()}}Container.shared.repository.register { Mock() }` and `.reset()` in teardown.

### 6.6 `brick.yaml`
Vars unchanged: `name` (string), `has_ui` (bool, default `false`). No `android_package` var exists in the current brick; leave as-is.

---

## 7. `pac_add_native_ui` — changes

- `hooks/pre_gen.dart`: existence check target becomes `packages/{{name}}/ios/{{name}}/Sources/{{name}}/Presentation/` (must be absent).
- `__brick__`: emit `ios/{{name}}/Sources/{{name}}/Presentation/**` (incl. `MviViewModel.swift` base) in the SPM layout; emit `lib/src/ui/{{name}}_native_view.dart` unchanged.
- `hooks/post_gen.dart`:
  - Patch `Sources/{{name}}/{{Name}}Plugin.swift` to add `registrar.register({{Name}}PlatformViewFactory { {{Name}}ViewModel() }, withId: "com.danhdue/{{name}}/native_view")`.
  - Add the export line to the barrel.
  - **No `Package.swift` edit** — `FactoryKit` is already a dependency from `pac_native_plugin`.
  - Android steps (`build.gradle.kts` `compose = true`, `*Plugin.kt` patch) — unchanged, out of this spec's iOS scope.

---

## 8. Brick hooks — `pac_native_plugin/hooks/post_gen.dart`

- **Remove** all `.podspec` awareness. There is no podspec to template or clean.
- **Directory cleanup by `has_ui`** — keep, but retarget paths:
  - `has_ui=false`: delete `ios/{{name}}/Sources/{{name}}/Presentation/`; keep `pigeons/`, keep `Platform/{{Name}}HostApiImpl.swift`.
  - `has_ui=true`: delete `pigeons/`, `lib/src/messages.g.dart`, `Sources/{{name}}/Messages.g.swift`; keep `Presentation/`, keep `Platform/{{Name}}PlatformViewFactory.swift`.
- **Workspace registration** — unchanged (`pubspec.yaml` `workspace:` block append).
- **After generation**: `melos bootstrap` (unchanged) + `flutter pub get` (new — lets Flutter pick up the SPM plugin).
- Pigeon: `pigeons/{{name}}_messages.dart` `@ConfigurePigeon` `swiftOut` → `ios/{{name}}/Sources/{{name}}/Messages.g.swift`; `dartOut` and Kotlin out unchanged.
- Brick `.gitignore`: add `.build/`, `.swiftpm/`, `Package.resolved`.

---

## 9. Parity mapping to `ios_digital_wallet`

| `ios_digital_wallet` (reference) | This brick | Why different |
|---|---|---|
| Global `Container.shared` + `public extension Container` per feature | `final class {{Name}}Container: SharedContainer` per plugin | No Swift composition root in the Flutter host to own a global container; plugins are independent (D3) |
| `Packages/Platform/DIExports.swift` = `@_exported import Factory` | Each `Package.swift` declares `FactoryKit` directly | No shared iOS infra package (D3) |
| `App/Composition/AppComposition.swift` calls `…register { realImpl }` | `{{Name}}Plugin.register(with:)` calls `…register { realImpl }` | Plugin's natural composition point (D4) |
| `import Factory` (2.4.3, SwiftPM via Tuist) | `import FactoryKit` (3.x, Flutter SPM) | Newer line, SPM-only (D1, D2) |
| `MviViewModel` in `Packages/Framework` | `MviViewModel.swift` copied per plugin | No shared package (D5) |

---

## 10. Risks & assumptions

| ID | Item | Status / mitigation |
|---|---|---|
| R1 | Generated plugin unusable by a non-SPM host (D1). | Accepted. Template host has SPM enabled. Documented in the brick README. |
| R2 | Flutter ≥ 3.44 required. | Satisfied — template on 3.47.0 (`.fvmrc`). |
| R3 | `native_security` C++/FFI → SPM (mixed C++/Swift target, module map) is fiddly. | Out of scope (§3.2); does not block this task since that plugin stays on CocoaPods. |
| R4 | Third-party plugins without upstream SPM keep a minimal Podfile (true "zero CocoaPods" not reached). | Out of scope (§3.2). Hybrid is expected and supported. |
| R5 | `pac_rename_project` currently rewrites podspec/bundle-id tokens. | Light touch: add `Package.swift` `name` / library-product token rewrite; `com.danhdue.*` vendor namespace preserved as today. Include in the implementation plan. |
| R6 | `FactoryKit` `@Injected(\CustomContainer.keyPath)` requires the keypath form (not the `Container.shared` form). | Confirmed against Factory source: `@Injected` has `init<C: SharedContainer>(_ keyPath: KeyPath<C, Factory<T>>)`. Brick templates use `\{{Name}}Container.repository`. |
| R7 | Swift concurrency: `@Injected` in a `MainActor` ViewModel + `register` at plugin load. | Follow the reference repo's pattern (`@MainActor` factories where needed); validated during implementation via the example app build. |

---

## 11. Testing & verification

| # | Check | Pass criteria |
|---|---|---|
| 1 | `flutter config --enable-swift-package-manager` then `mason make pac_native_plugin --name device_info --has_ui false` | Generates `packages/device_info/ios/device_info/Package.swift` + `Sources/device_info/**`; no `.podspec`. `melos bootstrap` + `flutter pub get` succeed. |
| 2 | Build & run the plugin's example on iOS (`has_ui=false`) | Pigeon round-trips Dart↔Swift; `DeviceInfoHostApiImpl` resolves `repository` from `DeviceInfoContainer`. |
| 3 | `mason make pac_native_plugin --name custom_camera --has_ui true` then run on iOS | SwiftUI `View` renders through `UiKitView` / `FlutterPlatformView`; `ViewModel` resolves `repository` via `@Injected(\CustomCameraContainer.repository)`. |
| 4 | `mason make pac_add_native_ui --name device_info` | Adds `Sources/device_info/Presentation/**`; patches `DeviceInfoPlugin.swift` with the `PlatformViewFactory` registration; project builds. |
| 5 | Swift unit test in the generated `device_infoTests` target | `DeviceInfoContainer.shared.repository.register { Mock() }` overrides resolution; `.reset()` restores; test passes. |
| 6 | `melos build_ios` on the template with one SPM plugin present | IPA builds; SPM plugin and the existing CocoaPods plugins (`native_security`, `logger_native_bridge`) both link. |
| 7 | Existing pod plugins unaffected | `native_security` / `logger_native_bridge` still resolve via CocoaPods; no regression. |

---

## 12. Documentation updates

- `.devtool/epic/flutter_super_app_template/2026-09-06-flutter-super-app-template-design.md`:
  - §4.3 — replace the `ios/` podspec layout with the SPM layout from §6.1; note "iOS DI = FactoryKit per-plugin `SharedContainer`; SPM-only".
  - §4.4 — `pac_add_native_ui` iOS steps updated per §7.
  - §8 — verification rows 5–7 updated per §11.
- Epic HLD (`flutter_super_app_template.en.md` / `.vi.md`): add a "Deferred: full CocoaPods → SPM migration" note and reference this spec.
- New brick `README.md` content: SPM-only requirement (R1), how to add a dependency to `{{Name}}Container`, how to override in tests.

---

## 13. Next step

After user review of this spec → invoke **`writing-plans`** to produce the implementation plan (brick rewrites + hook edits + host SPM enablement + doc edits + `pac_rename_project` light touch). The deferred full migration (§3.2) is a separate future spec under the `flutter_super_app_template` epic.
