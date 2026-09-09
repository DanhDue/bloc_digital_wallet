// swift-tools-version: 5.9
import PackageDescription

// `native_security` iOS — migrated from CocoaPods (`../native_security.podspec`)
// to Flutter Swift Package Manager in the `flutter_super_app_template` epic, Phase 5.
//
// This is an `ffiPlugin` (`pubspec.yaml` -> `flutter.plugin.platforms.ios.ffiPlugin`).
// It has two targets:
//   * `native_security_ffi` — the C/C++ FFI (`native_security.cpp` + `include/`
//     public header + module map). Its `__attribute__((constructor))` link anchor
//     (task_14 spike) keeps `get_ssl_pin_*` reachable via
//     `DynamicLibrary.executable()/.process()` through Release `-dead_strip`.
//   * `native_security` — the Swift surface: `NativeSecurityPlugin` (force-references
//     the C symbols a second time), `NativeSecurityContainer` (FactoryKit), and
//     `DatadogNativeAppender` (a `logger_native_bridge.NativeLogAppender`).
let package = Package(
    name: "native_security",
    platforms: [.iOS("13.0")],
    products: [
        .library(name: "native-security", targets: ["native_security"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/hmlongco/Factory.git", exact: "3.3.2"),
        // Replaces the podspec's `s.dependency 'logger_native_bridge'`.
        .package(name: "logger_native_bridge", path: "../../../logger_native_bridge/ios/logger_native_bridge")
    ],
    targets: [
        .target(
            name: "native_security_ffi",
            cSettings: [
                .unsafeFlags(["-fvisibility=default"])
            ]
        ),
        .target(
            name: "native_security",
            dependencies: [
                "native_security_ffi",
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "FactoryKit", package: "Factory"),
                .product(name: "logger-native-bridge", package: "logger_native_bridge")
            ]
        ),
        .testTarget(
            name: "native_securityTests",
            dependencies: [
                "native_security",
                .product(name: "logger-native-bridge", package: "logger_native_bridge")
            ]
        )
    ]
)
