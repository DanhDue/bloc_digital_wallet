// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import FactoryKit
import Flutter
import UIKit

/// {{name.pascalCase()}}'s composition root — the only place with the
/// `FlutterPluginRegistrar`. Register any `{{name.pascalCase()}}Container`
/// override that needs `registrar` / `messenger` here, *before* building the
/// consumer, then wire the Pigeon `HostApi` (headless) or the
/// `PlatformViewFactory` (native UI).
public class {{name.pascalCase()}}Plugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        // Example override (delete if the default `{{name.pascalCase()}}DataSource`
        // is enough):
        // {{name.pascalCase()}}Container.shared.repository.register {
        //     Real{{name.pascalCase()}}DataSource(messenger: registrar.messenger())
        // }
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
