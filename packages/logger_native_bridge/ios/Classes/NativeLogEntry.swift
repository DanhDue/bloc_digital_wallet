// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// Severity of a `NativeLogEntry`. Mirrors `LogLevel` in `package:logger`
/// (Dart) and the Pigeon-generated `NativeLogLevel`, but is intentionally a
/// separate type: this file has zero Flutter/Pigeon dependency, so the
/// native core (this file, `NativeLogQueue`, `NativeAppenderToggleStore`,
/// `D3NexusNativeLogger`, `NativeLogAppender`) compiles and runs with no
/// Flutter engine, no Pigeon-generated code, and no iOS
/// simulator/Xcode project on the classpath at all. Only
/// `NativeLogBridgePlugin` knows how to map this enum to the
/// Pigeon-generated `NativeLogLevel`.
public enum NativeLogSeverity: String, Codable {
  case verbose
  case debug
  case info
  case warning
  case error
}

/// A single native log event, as seen by `D3NexusNativeLogger` and
/// dispatched to registered `NativeLogAppender`s / enqueued into
/// `NativeLogQueue`.
///
/// `timestampMillis` is epoch milliseconds (UTC), captured at the moment
/// the originating `D3NexusNativeLogger.d/i/w/e/v(...)` call happened (NOT
/// at enqueue/drain/replay time) so that best-effort replay into Talker
/// later preserves original causal ordering and timing.
public struct NativeLogEntry: Codable, Equatable {
  public let severity: NativeLogSeverity
  public let tag: String
  public let message: String
  public let timestampMillis: Int64
  public let traceId: String?

  public init(
    severity: NativeLogSeverity,
    tag: String,
    message: String,
    timestampMillis: Int64,
    traceId: String? = nil
  ) {
    self.severity = severity
    self.tag = tag
    self.message = message
    self.timestampMillis = timestampMillis
    self.traceId = traceId
  }
}
