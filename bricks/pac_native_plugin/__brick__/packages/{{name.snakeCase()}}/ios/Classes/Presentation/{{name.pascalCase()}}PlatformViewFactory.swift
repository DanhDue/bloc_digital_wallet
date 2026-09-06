// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import Flutter
import UIKit

public class {{name.pascalCase()}}PlatformViewFactory: NSObject, FlutterPlatformViewFactory {
    private var messenger: FlutterBinaryMessenger?
    private var viewModel: {{name.pascalCase()}}ViewModel?

    public init(messenger: FlutterBinaryMessenger? = nil, viewModel: {{name.pascalCase()}}ViewModel? = nil) {
        self.messenger = messenger
        self.viewModel = viewModel
        super.init()
    }

    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        return {{name.pascalCase()}}PlatformView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            binaryMessenger: messenger,
            viewModel: viewModel
        )
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
