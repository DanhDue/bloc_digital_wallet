// swift-tools-version: 5.9
import PackageDescription

// `logger_native_bridge` iOS — migrated from CocoaPods (`../logger_native_bridge.podspec`)
// to Flutter Swift Package Manager in the `flutter_super_app_template` epic, Phase 5.
//
// Package name & target: `logger_native_bridge` (snake_case). Library product:
// `logger-native-bridge` (Flutter's SPM naming rule — hyphens in the product name only).
//
// DI: FactoryKit 3.x per-plugin container (`LoggerNativeBridgeContainer`). The package
// keeps `swift-tools-version: 5.9` so its own hand-tuned `NSLock`/threading code stays in
// Swift 5 language mode; FactoryKit builds itself in its own (Swift 6) mode.
let package = Package(
    name: "logger_native_bridge",
    platforms: [.iOS("13.0")],
    products: [
        .library(name: "logger-native-bridge", targets: ["logger_native_bridge"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(url: "https://github.com/hmlongco/Factory.git", exact: "3.3.2")
    ],
    targets: [
        .target(
            name: "logger_native_bridge",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "FactoryKit", package: "Factory")
            ]
        ),
        .testTarget(
            name: "logger_native_bridgeTests",
            dependencies: ["logger_native_bridge"]
        )
    ]
)
