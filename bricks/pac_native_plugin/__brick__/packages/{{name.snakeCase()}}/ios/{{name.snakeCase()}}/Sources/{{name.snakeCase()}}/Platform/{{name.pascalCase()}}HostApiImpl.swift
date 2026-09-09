// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import FactoryKit
import Flutter
import UIKit

/// [has_ui=false] The Pigeon `HostApi` implementation. Resolves its domain
/// repository from the plugin's own container, so tests swap it with
/// `{{name.pascalCase()}}Container.shared.repository.register { Mock() }`.
final class {{name.pascalCase()}}HostApiImpl: {{name.pascalCase()}}HostApi {
    @Injected(\{{name.pascalCase()}}Container.repository) private var repository

    func getPlatformVersion() throws -> String {
        // Demo schema method. A real headless call would go through
        // `repository` — Pigeon supports async host methods via a completion
        // parameter; regenerate the schema to that shape when you need it.
        _ = repository
        return "iOS " + UIDevice.current.systemVersion
    }
}
