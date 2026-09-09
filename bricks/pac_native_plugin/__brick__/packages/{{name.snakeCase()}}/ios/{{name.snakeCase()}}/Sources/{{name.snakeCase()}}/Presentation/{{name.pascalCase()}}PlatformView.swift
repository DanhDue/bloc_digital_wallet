// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import Flutter
import SwiftUI
import UIKit

public class {{name.pascalCase()}}PlatformView: NSObject, FlutterPlatformView {
    private let hostingController: UIHostingController<{{name.pascalCase()}}View>

    public init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        viewModel: {{name.pascalCase()}}ViewModel
    ) {
        let controller = UIHostingController(rootView: {{name.pascalCase()}}View(viewModel: viewModel))
        controller.view.frame = frame
        controller.view.backgroundColor = .clear
        self.hostingController = controller
        super.init()
    }

    public func view() -> UIView {
        hostingController.view
    }
}
