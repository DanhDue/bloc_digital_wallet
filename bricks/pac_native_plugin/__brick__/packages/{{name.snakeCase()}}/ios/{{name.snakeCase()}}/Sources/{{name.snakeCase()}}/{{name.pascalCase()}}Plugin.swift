// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import FactoryKit
import Flutter
import UIKit

/// Root plugin entry point and composition root for Flutter iOS bindings.
public final class {{name.pascalCase()}}Plugin: NSObject, @preconcurrency FlutterPlugin {
    private var messenger: FlutterBinaryMessenger?

    public init(messenger: FlutterBinaryMessenger? = nil) {
        self.messenger = messenger
        super.init()
    }

    public static func register(with registrar: FlutterPluginRegistrar) {
        let binaryMessenger = registrar.messenger()

{{#has_ui}}
        // Register Platform View Factory (With UI)
        let viewFactory = {{name.pascalCase()}}PlatformViewFactory()
        registrar.register(viewFactory, withId: {{name.pascalCase()}}PlatformViewFactory.viewType)
{{/has_ui}}
{{^has_ui}}
        // Setup Headless Host API (Pigeon)
        let hostApi = {{name.pascalCase()}}HostApiImpl()
        {{name.pascalCase()}}HostApiSetup.setUp(binaryMessenger: binaryMessenger, api: hostApi)
{{/has_ui}}

        // Register Background Task scheduler before application launch completes
        {{name.pascalCase()}}SyncTask.register()

        let channel = FlutterMethodChannel(
            name: "com.danhdue.{{name.snakeCase()}}/methods",
            binaryMessenger: binaryMessenger
        )
        let instance = {{name.pascalCase()}}Plugin(messenger: binaryMessenger)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            let version = MainActor.assumeIsolated {
                "iOS " + UIDevice.current.systemVersion
            }
            result(version)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func detachFromEngine(for _: FlutterPluginRegistrar) {
{{^has_ui}}
        if let messenger {
            {{name.pascalCase()}}HostApiSetup.setUp(binaryMessenger: messenger, api: nil)
        }
{{/has_ui}}
        messenger = nil
    }
}
