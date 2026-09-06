import Flutter
import UIKit
import SwiftUI

public class {{name.pascalCase()}}PlatformView: NSObject, FlutterPlatformView {
    private var hostingController: UIHostingController<{{name.pascalCase()}}View>?

    public init(
        frame: CGRect,
        viewIdentifier viewId: Int64,
        arguments args: Any?,
        binaryMessenger messenger: FlutterBinaryMessenger?,
        viewModel: {{name.pascalCase()}}ViewModel? = nil
    ) {
        super.init()
        let vm = viewModel ?? {{name.pascalCase()}}ViewModel()
        let swiftUIView = {{name.pascalCase()}}View(viewModel: vm)
        let controller = UIHostingController(rootView: swiftUIView)
        controller.view.frame = frame
        controller.view.backgroundColor = .clear
        self.hostingController = controller
    }

    public func view() -> UIView {
        return hostingController?.view ?? UIView()
    }
}
