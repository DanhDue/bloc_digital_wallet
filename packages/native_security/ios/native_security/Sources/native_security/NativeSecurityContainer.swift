// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import FactoryKit
import Foundation

/// The plugin's own dependency-injection container (Phase 5 — `flutter_super_app_template`).
///
/// A dedicated `SharedContainer` subclass rather than the global
/// `Container.shared`: `native_security` ships independently and has no
/// app-side Swift composition root, and a per-plugin container avoids
/// factory-name collisions with any other native plugin.
///
/// It currently exposes the `DatadogNativeAppender`. That appender is a
/// placeholder (no real Datadog SDK in this repo) and is **not** wired
/// into `D3NexusNativeLogger` from production code yet — that wiring is
/// Task 7's concern. The factory exists now for pattern parity with the
/// `pac_native_plugin` brick and so tests can override it via
/// `NativeSecurityContainer.shared.datadogAppender.register { … }`.
public final class NativeSecurityContainer: SharedContainer {
    public static let shared = NativeSecurityContainer()
    public let manager = ContainerManager()
}

public extension NativeSecurityContainer {
    var datadogAppender: Factory<DatadogNativeAppender> {
        self { DatadogNativeAppender() }
    }
}
