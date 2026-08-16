import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    
    let channel = FlutterMethodChannel(
      name: "com.zeno.app/clipboard",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
      
    channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "copySensitive" {
          self?.handleCopySensitive(call: call, result: result)
      } else {
          result(FlutterMethodNotImplemented)
      }
    }
  }

  private func handleCopySensitive(call: FlutterMethodCall, result: @escaping FlutterResult) {
      guard let args = call.arguments as? [String: Any],
            let text = args["text"] as? String else {
          result(FlutterError(code: "INVALID_ARGS", message: "Missing text", details: nil))
          return
      }
      
      let expiry = args["expiry"] as? Double ?? 30.0
      
      let pasteboard = UIPasteboard.general
      let item: [String: Any] = ["public.utf8-plain-text": text]
      
      let expirationDate = Date().addingTimeInterval(expiry)
      pasteboard.setItems([item], options: [.expirationDate: expirationDate])
      
      result(nil)
  }
}
