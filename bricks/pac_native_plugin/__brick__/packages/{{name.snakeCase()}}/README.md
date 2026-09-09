# {{name.pascalCase()}}

Native plugin package for the Super App ecosystem.
{{#has_ui}}
Provides native Jetpack Compose and SwiftUI PlatformViews.
{{/has_ui}}
{{^has_ui}}
Provides headless type-safe Pigeon IPC communication.
{{/has_ui}}

## iOS: Swift Package Manager only

The iOS side ships as a Swift Package (`ios/{{name.snakeCase()}}/Package.swift`) with
**no `.podspec`** — the DI library FactoryKit 3.x is SPM-only. Consuming this plugin
needs a host with SPM enabled (Flutter ≥ 3.44):

```bash
flutter config --enable-swift-package-manager
```

CocoaPods plugins keep working alongside it (hybrid).

## Dependency injection (`{{name.pascalCase()}}Container`)

Dependencies resolve through the plugin's own FactoryKit container
(`ios/{{name.snakeCase()}}/Sources/{{name.snakeCase()}}/{{name.pascalCase()}}Container.swift`):

- **Add a dependency**: declare a `Factory` on `{{name.pascalCase()}}Container` with a
  safe default, then read it with `@Injected(\{{name.pascalCase()}}Container.myThing)`.
- **Production override**: register it in `{{name.pascalCase()}}Plugin.register(with:)` —
  the only place with the `FlutterPluginRegistrar`.
- **In tests**: `{{name.pascalCase()}}Container.shared.repository.register { Mock() }`,
  then `{{name.pascalCase()}}Container.shared.manager.reset()` in teardown.

## Android

Unchanged — Kotlin, self-contained constructor injection.
