// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// A bounded, FIFO, drop-oldest ring buffer of `NativeLogEntry` values,
/// persisted to `UserDefaults` so it survives process death between the
/// headless push and the next Flutter engine attach.
///
/// Backed by the SAME `UserDefaults` `NativeAppenderToggleStore` reads
/// from, but under its OWN key (`rawKey`) — this is a queue of best-effort
/// replay entries, not a toggle map, so it must not collide with
/// `logging.appender_toggles`. Unlike the toggle key, `rawKey` is written
/// and read exclusively by native code (Dart never touches it directly),
/// so it deliberately does NOT carry the `flutter.` prefix
/// `shared_preferences` adds to Dart-written keys.
///
/// Bound: `maxEntries` entries (default 200) OR `maxBytes` of encoded JSON
/// (default 64KB), whichever is hit first — the OLDEST entry is dropped to
/// make room, per the design spec's "Replay is best-effort, not
/// guaranteed" rationale (durable delivery already happened via the native
/// SDK during the original headless push; this queue only exists for
/// developer-facing Talker visibility).
///
/// **Per-call cost**: `enqueue` necessarily does a read-modify-write of the
/// ENTIRE queue on every call — there's no partial-append operation on a
/// `UserDefaults` string value, and swapping the backing store for
/// something that supports one (e.g. a small file with true appends) is an
/// already-acknowledged, deliberately-deferred option (see the design
/// spec's "Risks & Rollback" section) if this bound is ever hit hard
/// enough to matter. What this class DOES avoid is redundant JSON
/// *decoding*: `readAll` caches the last-decoded entry list, invalidated
/// only when the raw string actually differs from what's cached, and
/// `writeAll` updates that cache directly from the entries it just wrote
/// (no read-back needed) — so a burst of `enqueue` calls only ever
/// re-decodes once (lazily, on first access after a cold start), not once
/// per call. This is judged acceptable given the intended usage
/// (infrequent headless background events, not a hot logging loop).
///
/// This file has zero Flutter/Pigeon dependency.
public final class NativeLogQueue {
  public static let defaultMaxEntries = 200
  public static let defaultMaxBytes = 64 * 1024

  /// Raw native `UserDefaults` key this queue is stored under.
  public static let rawKey = "com.danhdue.logger_native_bridge.queue"

  private let userDefaults: UserDefaults
  private let maxEntries: Int
  private let maxBytes: Int
  private let lock = NSLock()
  private var cachedRawJson: String?
  private var cachedEntries: [NativeLogEntry] = []

  public init(
    userDefaults: UserDefaults,
    maxEntries: Int = NativeLogQueue.defaultMaxEntries,
    maxBytes: Int = NativeLogQueue.defaultMaxBytes
  ) {
    self.userDefaults = userDefaults
    self.maxEntries = maxEntries
    self.maxBytes = maxBytes
  }

  /// Convenience for production call sites: backs onto `UserDefaults.standard`.
  public convenience init() {
    self.init(userDefaults: .standard)
  }

  /// Appends `entry` to the tail of the queue, dropping the oldest
  /// entry/entries first if appending would exceed `maxEntries` or
  /// `maxBytes`.
  public func enqueue(_ entry: NativeLogEntry) {
    lock.lock()
    defer { lock.unlock() }

    var entries = readAll()
    entries.append(entry)
    while entries.count > maxEntries || encodedByteSize(entries) > maxBytes {
      guard !entries.isEmpty else { break }
      entries.removeFirst()
    }
    writeAll(entries)
  }

  /// Returns every currently-queued entry, oldest first. Does not clear.
  public func drainAll() -> [NativeLogEntry] {
    lock.lock()
    defer { lock.unlock() }
    return readAll()
  }

  /// Clears the queue. Callers (namely `NativeLogBridgePlugin`) must only
  /// call this AFTER every drained entry has been successfully replayed —
  /// clearing first and replaying second would lose entries if the process
  /// dies mid-replay.
  public func clear() {
    lock.lock()
    defer { lock.unlock() }
    userDefaults.removeObject(forKey: Self.rawKey)
    cachedRawJson = nil
    cachedEntries = []
  }

  /// Number of entries currently queued. Exposed for tests/diagnostics.
  public func size() -> Int {
    lock.lock()
    defer { lock.unlock() }
    return readAll().count
  }

  /// Caller must already hold `lock`.
  private func readAll() -> [NativeLogEntry] {
    let json = userDefaults.string(forKey: Self.rawKey)
    if json == cachedRawJson {
      // Nothing has changed under rawKey since the last read/write: skip
      // re-decoding entirely.
      return cachedEntries
    }
    let decoded = Self.decodeEntries(json)
    cachedRawJson = json
    cachedEntries = decoded
    return decoded
  }

  private static func decodeEntries(_ json: String?) -> [NativeLogEntry] {
    guard let json else { return [] }
    guard let data = json.data(using: .utf8) else { return [] }
    guard let decoded = try? JSONDecoder().decode([NativeLogEntry].self, from: data) else {
      return []
    }
    return decoded
  }

  /// Caller must already hold `lock`.
  private func writeAll(_ entries: [NativeLogEntry]) {
    guard let data = try? JSONEncoder().encode(entries) else { return }
    let json = String(data: data, encoding: .utf8) ?? "[]"
    userDefaults.set(json, forKey: Self.rawKey)
    // Update the cache directly from what we just wrote instead of
    // reading it back and re-decoding.
    cachedRawJson = json
    cachedEntries = entries
  }

  private func encodedByteSize(_ entries: [NativeLogEntry]) -> Int {
    guard let data = try? JSONEncoder().encode(entries) else { return .max }
    return data.count
  }
}
