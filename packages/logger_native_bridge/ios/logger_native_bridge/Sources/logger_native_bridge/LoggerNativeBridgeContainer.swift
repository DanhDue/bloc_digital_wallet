// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import FactoryKit
import Foundation

/// The plugin's own dependency-injection container (Phase 5 — `flutter_super_app_template`).
///
/// A dedicated `SharedContainer` subclass rather than the global
/// `Container.shared`: this plugin ships independently and has no app-side
/// Swift composition root to own a global container, and a per-plugin
/// container keeps the `logging.` factory names from colliding with any
/// other native plugin's.
///
/// It exposes the two `UserDefaults`-backed collaborators
/// `NativeLogBridgePlugin.register(with:)` needs. The headless path
/// (`D3NexusNativeLogger` called from a `BGTask` handler with no engine)
/// still uses the plain `init()` convenience initializers directly — it
/// must not depend on FactoryKit resolution having run.
///
/// Tests override with
/// `LoggerNativeBridgeContainer.shared.<factory>.register { … }` and call
/// `.reset()` in teardown.
public final class LoggerNativeBridgeContainer: SharedContainer {
    public static let shared = LoggerNativeBridgeContainer()
    public let manager = ContainerManager()
}

public extension LoggerNativeBridgeContainer {
    /// Reads the appender kill-switch map `packages/settings` persists from Dart.
    var toggleStore: Factory<NativeAppenderToggleStore> {
        self { NativeAppenderToggleStore(userDefaults: .standard) }
    }

    /// The persisted best-effort replay queue drained on engine attach.
    var logQueue: Factory<NativeLogQueue> {
        self { NativeLogQueue(userDefaults: .standard) }
    }
}
