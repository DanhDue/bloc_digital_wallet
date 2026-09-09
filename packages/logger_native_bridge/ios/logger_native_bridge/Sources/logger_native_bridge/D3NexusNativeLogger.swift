// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// Native-side facade a headless `BGTaskScheduler` handler / background
/// fetch / Notification Service Extension calls directly, e.g.
/// `D3NexusNativeLogger.d(tag, message)` — with NO `FlutterEngine` or
/// Pigeon channel involved at all. Mirrors `D3NexusLogger` on the Dart
/// side and `D3NexusNativeLogger` (Kotlin) on Android.
///
/// **Dispatch order** (see the design spec's headless sequence diagram):
/// for each `d`/`i`/`w`/`e`/`v` call, every registered `NativeLogAppender`
/// is checked against `NativeAppenderToggleStore.isEnabled` — disabled
/// appenders are skipped, enabled ones receive the entry. Regardless of
/// any toggle, the entry is ALWAYS enqueued into `NativeLogQueue`
/// afterwards: toggles gate live backend delivery, not local replay
/// visibility, so a developer can still see a headless log on Talker even
/// if its backend was disabled at the time.
///
/// Call `initialize` once (e.g. from `AppDelegate.didFinishLaunchingWithOptions`,
/// a `BGTask` handler's first use, or `NativeLogBridgePlugin.register`
/// as a fallback if nothing else got there first) before
/// `registerAppender` / `d`/`i`/`w`/`e`/`v`. `initialize` is safe to call
/// more than once — it does NOT clear previously registered appenders.
///
/// **Thread safety**: this is the exact class real headless callers hit
/// from a background `BGTaskScheduler`/background-fetch thread,
/// potentially concurrently with a main-thread `registerAppender` call.
/// `initialize`/`registerAppender`/`resetForTest` hold `lock` for their
/// whole body. `log` takes a consistent snapshot of `toggleStore` and a
/// copy of `appenders` under that same lock, THEN releases it before
/// dispatching to each appender/`queue` — this fixes the actual data race
/// (`registerAppender` mutating `appenders` while `log` iterates it, which
/// is undefined behavior on a Swift `Array`) without holding the lock
/// across foreign `NativeLogAppender.append` calls (which could be slow,
/// e.g. a real SDK's I/O) or risking a same-thread re-entrant deadlock on
/// `NSLock` (which, unlike Kotlin's `synchronized`, is NOT reentrant) if
/// an appender ever logged back through this facade.
///
/// This file has zero Flutter/Pigeon dependency.
public enum D3NexusNativeLogger {
  private static var toggleStore: NativeAppenderToggleStore?
  private static var queue: NativeLogQueue?
  private static var appenders: [NativeLogAppender] = []
  private static let lock = NSLock()

  /// Wires this facade to `toggleStore` and `queue`. Must be called before
  /// `d`/`i`/`w`/`e`/`v`. Safe to call more than once — later calls replace
  /// `toggleStore`/`queue` but never clear already-`registerAppender`-ed
  /// appenders.
  public static func initialize(toggleStore: NativeAppenderToggleStore, queue: NativeLogQueue) {
    lock.lock()
    defer { lock.unlock() }
    self.toggleStore = toggleStore
    self.queue = queue
  }

  /// Registers `appender` to receive future dispatch, subject to its toggle.
  public static func registerAppender(_ appender: NativeLogAppender) {
    lock.lock()
    defer { lock.unlock() }
    appenders.append(appender)
  }

  /// Test-only: clears every registered appender and un-initializes the
  /// toggle store/queue, so each test starts from a clean slate despite
  /// this facade being a process-wide singleton namespace. Production code
  /// must never call this.
  public static func resetForTest() {
    lock.lock()
    defer { lock.unlock() }
    appenders.removeAll()
    toggleStore = nil
    queue = nil
  }

  public static func d(_ tag: String, _ message: String, traceId: String? = nil) {
    log(.debug, tag, message, traceId)
  }

  public static func i(_ tag: String, _ message: String, traceId: String? = nil) {
    log(.info, tag, message, traceId)
  }

  public static func w(_ tag: String, _ message: String, traceId: String? = nil) {
    log(.warning, tag, message, traceId)
  }

  public static func e(_ tag: String, _ message: String, traceId: String? = nil) {
    log(.error, tag, message, traceId)
  }

  public static func v(_ tag: String, _ message: String, traceId: String? = nil) {
    log(.verbose, tag, message, traceId)
  }

  private static func log(
    _ severity: NativeLogSeverity,
    _ tag: String,
    _ message: String,
    _ traceId: String?
  ) {
    // Snapshot the shared mutable state under the lock, then release it
    // before dispatching -- see this class's "Thread safety" doc comment
    // for why.
    let (store, snapshotAppenders, activeQueue): (
      NativeAppenderToggleStore, [NativeLogAppender], NativeLogQueue?
    ) = {
      lock.lock()
      defer { lock.unlock() }
      guard let store = toggleStore else {
        preconditionFailure(
          "D3NexusNativeLogger.initialize() must be called before logging. "
            + "Call it once during native bootstrap."
        )
      }
      return (store, appenders, queue)
    }()

    let timestampMillis = Int64(Date().timeIntervalSince1970 * 1000)
    let entry = NativeLogEntry(
      severity: severity,
      tag: tag,
      message: message,
      timestampMillis: timestampMillis,
      traceId: traceId
    )

    for appender in snapshotAppenders where store.isEnabled(appender.id) {
      appender.append(entry)
    }

    activeQueue?.enqueue(entry)
  }
}
