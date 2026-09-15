// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import Flutter
import SwiftUI
import UIKit

/// Flutter Platform View bridging {{name.pascalCase()}}View into Flutter widget trees.
public final class {{name.pascalCase()}}PlatformView: NSObject, @preconcurrency FlutterPlatformView, @unchecked Sendable {
    public let hostingController: UIHostingController<{{name.pascalCase()}}View>

    public init(
        frame: CGRect,
        viewIdentifier _: Int64,
        arguments _: Any?,
        viewModel: {{name.pascalCase()}}ViewModel? = nil
    ) {
        let controller = MainActor.assumeIsolated {
            let pluginView = {{name.pascalCase()}}View(viewModel: viewModel)
            let ctrl = UIHostingController(rootView: pluginView)
            ctrl.view.frame = frame
            return ctrl
        }
        hostingController = controller
        super.init()
    }

    public func view() -> UIView {
        MainActor.assumeIsolated {
            hostingController.view
        }
    }
}
