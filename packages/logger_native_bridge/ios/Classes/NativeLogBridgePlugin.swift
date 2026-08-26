// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import Flutter
import UIKit

/// The ONLY class in this package allowed to import Flutter/Pigeon.
///
/// Everything else in `ios/Classes` (`D3NexusNativeLogger`,
/// `NativeLogAppender`, `NativeLogQueue`, `NativeAppenderToggleStore`,
/// `NativeLogEntry`) has zero Flutter/Pigeon dependency and works with no
/// engine at all — that is what makes the headless push path
/// (`D3NexusNativeLogger.d(...)` called from a `BGTaskScheduler` handler
/// with no `FlutterEngine` running) possible.
///
/// This plugin only matters once a `FlutterEngine` DOES attach (via
/// `register(with:)`, the iOS plugin registration entry point — see
/// `NativeSecurityPlugin.swift` for this repo's existing convention): it
/// (re-)wires `D3NexusNativeLogger` to a real `UserDefaults`-backed
/// `NativeAppenderToggleStore`/`NativeLogQueue` (in case nothing did so
/// earlier, e.g. no `AppDelegate` bootstrap exists in this app yet), then
/// drains `NativeLogQueue` and replays each entry, in original FIFO order,
/// into Dart via the Pigeon-generated `NativeLogFlutterApi.onNativeLog`.
/// The queue is cleared ONLY after every replayed entry's callback reports
/// success — so a process death mid-replay never LOSES entries: the whole
/// batch (including any already-delivered entries) simply replays again on
/// the next attach, since `NativeLogQueue` is only cleared after every
/// entry in a batch succeeds (see `NativeLogQueue.clear`'s doc comment).
/// Note this means a partial-failure replay CAN duplicate entries into
/// Talker across attach attempts — that's an accepted trade-off (see the
/// design spec's "Replay is best-effort, not guaranteed" rationale):
/// correctness here means "never silently drop a headless log," not
/// "exactly-once delivery to a debug console."
///
/// **`register(with:)`'s own drain call is best-effort only, NOT the
/// reliable replay path.** `register(with:)` runs during
/// `AppDelegate`/engine setup — strictly BEFORE the Dart side's `main()`
/// (and therefore before `NativeLogFlutterApi.setUp(...)` /
/// `registerNativeLogBridge()`) can possibly have run on a real cold
/// start. Calling `drainAndReplay` here can and normally DOES race an
/// as-yet-unregistered Dart handler: each `onNativeLog` send then lands in
/// Flutter's `ChannelBuffers` (capacity 1 per channel) and overflow
/// entries are silently dropped, Pigeon maps the resulting reply to a
/// failure, and this class correctly does NOT clear the queue in that case
/// (see `drainAndReplay`'s doc comment) — so this call fails safely, but
/// it is not what makes replay reliable. Implements the (also NOT merely a
/// dev/test convenience, despite the schema's own doc comment framing it
/// that way) `NativeLogHostApi` (`triggerFlush()`) precisely so the DART
/// side can explicitly re-request a drain once it has actually installed
/// its handler — see `NativeLogBridge.registerNativeLogBridge()`'s doc
/// comment (Dart) for the real, race-free replay path this app relies on.
public class NativeLogBridgePlugin: NSObject, FlutterPlugin, NativeLogHostApi {
  private var queue: NativeLogQueue?
  private var flutterApi: NativeLogFlutterApi?

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = NativeLogBridgePlugin()

    let toggleStore = NativeAppenderToggleStore(userDefaults: .standard)
    let logQueue = NativeLogQueue(userDefaults: .standard)
    instance.queue = logQueue

    // Idempotent: does not clear appenders already registered by an
    // earlier D3NexusNativeLogger.initialize() call (e.g. from a native
    // AppDelegate bootstrap, if/when one exists).
    D3NexusNativeLogger.initialize(toggleStore: toggleStore, queue: logQueue)

    let api = NativeLogFlutterApi(binaryMessenger: registrar.messenger())
    instance.flutterApi = api

    NativeLogHostApiSetup.setUp(binaryMessenger: registrar.messenger(), api: instance)

    instance.drainAndReplay(logQueue, api)
  }

  /// `NativeLogHostApi`: forces an immediate drain. Despite the Pigeon
  /// schema's own doc comment calling this a "dev/test convenience," it is
  /// ALSO the production replay path — `NativeLogBridge.
  /// registerNativeLogBridge()` (Dart) calls this immediately after
  /// installing its `onNativeLog` handler, since `register(with:)`'s own
  /// attach-time drain call races (and normally loses to) Dart startup on
  /// a real cold start. See this class's doc comment.
  public func triggerFlush() throws {
    guard let logQueue = queue, let api = flutterApi else { return }
    drainAndReplay(logQueue, api)
  }

  /// Drains every currently-queued entry and replays it, in original FIFO
  /// order, via `api`. Clears `queue` only once every entry in THIS drain
  /// batch has been acknowledged successfully — see `NativeLogQueue.clear`.
  private func drainAndReplay(_ queue: NativeLogQueue, _ api: NativeLogFlutterApi) {
    let entries = queue.drainAll()
    guard !entries.isEmpty else { return }

    var pending = entries.count
    var sawFailure = false

    for entry in entries {
      api.onNativeLog(message: entry.toPigeonMessage()) { result in
        pending -= 1
        if case .failure = result {
          sawFailure = true
        }
        if pending == 0 && !sawFailure {
          queue.clear()
        }
      }
    }
  }
}

extension NativeLogEntry {
  fileprivate func toPigeonMessage() -> NativeLogMessage {
    return NativeLogMessage(
      level: severity.toPigeonLevel(),
      tag: tag,
      message: message,
      timestamp: timestampMillis,
      traceId: traceId
    )
  }
}

extension NativeLogSeverity {
  fileprivate func toPigeonLevel() -> NativeLogLevel {
    switch self {
    case .verbose: return .verbose
    case .debug: return .debug
    case .info: return .info
    case .warning: return .warning
    case .error: return .error
    }
  }
}
