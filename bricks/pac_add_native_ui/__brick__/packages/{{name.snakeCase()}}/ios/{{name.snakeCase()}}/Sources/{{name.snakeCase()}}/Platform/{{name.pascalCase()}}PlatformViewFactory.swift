// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import Flutter
import UIKit

/// Factory responsible for instantiating {{name.pascalCase()}}PlatformView instances for Flutter.
public final class {{name.pascalCase()}}PlatformViewFactory: NSObject, FlutterPlatformViewFactory {
    public static let viewType = "com.danhdue.{{name.snakeCase()}}/native_view"

    private let viewModelProvider: () -> {{name.pascalCase()}}ViewModel

    public init(viewModelProvider: @escaping () -> {{name.pascalCase()}}ViewModel = { {{name.pascalCase()}}ViewModel(getDataUseCase: {{name.pascalCase()}}Container.shared.getDataUseCase()) }) {
        self.viewModelProvider = viewModelProvider
        super.init()
    }

    public func create(
        withFrame frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?
    ) -> FlutterPlatformView {
        {{name.pascalCase()}}PlatformView(frame: frame, viewIdentifier: viewId, arguments: args, viewModel: viewModelProvider())
    }

    public func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        FlutterStandardMessageCodec.sharedInstance()
    }
}
