// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import FactoryKit
import Foundation

/// {{name.pascalCase()}}'s own dependency-injection container.
///
/// A dedicated `SharedContainer` subclass — not the global `Container.shared` —
/// so the plugin stays self-contained: it has no app-side Swift composition
/// root, and per-plugin containers can't collide on factory names.
///
/// Register production overrides in `{{name.pascalCase()}}Plugin.register(with:)`
/// (the only place with the `FlutterPluginRegistrar`). Tests override with
/// `{{name.pascalCase()}}Container.shared.repository.register { Mock() }` and call
/// `.reset()` (or `manager.reset()`) in teardown.
public final class {{name.pascalCase()}}Container: SharedContainer {
    public static let shared = {{name.pascalCase()}}Container()
    public let manager = ContainerManager()
}

public extension {{name.pascalCase()}}Container {
    /// The domain repository. Default: the `Data`-layer implementation, which
    /// needs nothing from the registrar. Override in `register(with:)` if a
    /// real implementation needs `registrar.messenger()` or engine-scoped state.
    var repository: Factory<{{name.pascalCase()}}Repository> {
        self { {{name.pascalCase()}}DataSource() }
    }
}
