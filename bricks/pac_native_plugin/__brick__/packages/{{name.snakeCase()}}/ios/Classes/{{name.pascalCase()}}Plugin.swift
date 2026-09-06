// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import Flutter
import UIKit

public class {{name.pascalCase()}}Plugin: NSObject, FlutterPlugin{{^has_ui}}, {{name.pascalCase()}}HostApi{{/has_ui}} {
    public static func register(with registrar: FlutterPluginRegistrar) {
{{#has_ui}}
        let viewModel = {{name.pascalCase()}}ViewModel()
        let factory = {{name.pascalCase()}}PlatformViewFactory(viewModel: viewModel)
        registrar.register(factory, withId: "com.danhdue.{{name.snakeCase()}}/native_view")
{{/has_ui}}
{{^has_ui}}
        let messenger = registrar.messenger()
        let api = {{name.pascalCase()}}Plugin()
        {{name.pascalCase()}}HostApiSetup.setUp(binaryMessenger: messenger, api: api)
{{/has_ui}}
    }
{{^has_ui}}

    public func getPlatformVersion() throws -> String {
        return "iOS " + UIDevice.current.systemVersion
    }
{{/has_ui}}
}
