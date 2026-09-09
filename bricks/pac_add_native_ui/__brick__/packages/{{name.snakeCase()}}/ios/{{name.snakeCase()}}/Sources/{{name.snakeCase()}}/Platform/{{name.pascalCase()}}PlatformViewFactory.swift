// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import Flutter
import UIKit

/// [has_ui=true] Builds a fresh `{{name.pascalCase()}}ViewModel` per platform
/// view via the injected closure — in production `{ {{name.pascalCase()}}ViewModel() }`,
/// which resolves the ViewModel's dependencies through `{{name.pascalCase()}}Container`.
public class {{name.pascalCase()}}PlatformViewFactory: NSObject, FlutterPlatformViewFactory {
    private let makeViewModel: () -> {{name.pascalCase()}}ViewModel

    public init(makeViewModel: @escaping () -> {{name.pascalCase()}}ViewModel) {
        self.makeViewModel = makeViewModel
        super.init()
    }

    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        {{name.pascalCase()}}PlatformView(
            frame: frame,
            viewIdentifier: viewId,
            arguments: args,
            viewModel: makeViewModel()
        )
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}
