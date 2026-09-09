// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

#if canImport(logger_native_bridge)
  import logger_native_bridge
#endif

/// Native (Swift/iOS) `NativeLogAppender` for Datadog, registered from
/// `native_security`'s own native code — per the `logger_native_bridge`
/// design spec, concrete backend appenders live in the CONSUMING module,
/// not inside `logger_native_bridge` itself (mirrors the Dart-side rule:
/// "core has zero concrete-SDK dependency, appenders live at the app
/// layer").
///
/// **This is a placeholder, not a real Datadog SDK integration** — this
/// repo has no real `DatadogCore`/`DatadogLogs` (or equivalent)
/// dependency/account set up anywhere, on either the Dart side or here.
/// Task 4 already established, for the Dart-side `DatadogAppender`, that
/// wiring a real Datadog/OTel SDK isn't achievable as a thin adapter
/// without out-of-scope native account/SDK provisioning — the exact same
/// reasoning applies here, symmetrically, on the native side. The shape of
/// this class (an `append(_:)` that would forward to a real
/// `Logger`/`Logs` client) is exactly where that real call would go once
/// the SDK/account exists; see the `// TODO(datadog-sdk)` marker below.
///
/// What IS proven here (see
/// `ios/Tests/native_securityTests/DatadogNativeAppenderHeadlessTests.swift`):
/// `D3NexusNativeLogger.d()` correctly reaches this appender's `append`
/// when the `"datadog"` toggle is enabled, and correctly skips it when
/// disabled — the same standard Task 4 already set for the Dart-side
/// `DatadogAppender`/`NoopDatadogLogClient` (architecture/dispatch-level
/// proof, no real network call).
public final class DatadogNativeAppender: NativeLogAppender {
  public let id: String = "datadog"

  /// Every entry this appender has been asked to append, in receipt
  /// order. Exposed for tests; a real implementation would not need this
  /// (the real Datadog SDK client would own delivery/buffering itself).
  public private(set) var delivered: [NativeLogEntry] = []

  public init() {}

  public func append(_ entry: NativeLogEntry) {
    // TODO(datadog-sdk): once a real Datadog iOS SDK dependency and
    // account/client token are provisioned for this app, replace this
    // with e.g.:
    //   Logger.create(with: config).log(
    //       level: entry.severity.toDatadogLogLevel(),
    //       message: entry.message,
    //       attributes: ["tag": entry.tag, "traceId": entry.traceId as Any],
    //   )
    // Until then, this appender exists purely to prove the headless
    // dispatch path (D3NexusNativeLogger -> toggle check -> appender)
    // works end-to-end with no FlutterEngine involved.
    delivered.append(entry)
  }
}
