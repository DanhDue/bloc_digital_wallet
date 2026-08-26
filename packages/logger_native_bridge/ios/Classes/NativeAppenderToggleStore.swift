// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import Foundation

/// Reads the same appender kill-switch state `packages/settings` persists
/// from Dart, so a headless native call can honor
/// `D3NexusLogger.setAppenderEnabled(id, false)` without any live Pigeon
/// round-trip (see the design spec's "Kill-Switch Propagation" section).
///
/// **Key contract** (must stay in sync with
/// `packages/settings/lib/data/datasources/local/settings_local_datasource_impl.dart`):
/// Dart writes a JSON-encoded flat `Map<String, bool>` via
/// `SharedPreferences.setString('logging.appender_toggles', ...)`. The
/// `shared_preferences` Flutter plugin transparently prefixes every key it
/// writes with `flutter.` in the underlying native storage on BOTH
/// platforms — so the RAW key this store must read is
/// `flutter.logging.appender_toggles`, NOT the bare `logging.appender_toggles`
/// string. On iOS/macOS that native storage is `UserDefaults.standard`.
///
/// Both an absent key overall and an absent specific appender id within the
/// decoded map mean "enabled" (default `true`), matching
/// `LogManagerImpl`'s own `?? true` semantics on the Dart side.
///
/// This file has zero Flutter/Pigeon dependency — `UserDefaults` is plain
/// Foundation, real (not stubbed) under `swift test`, so this is fully
/// unit-testable with no Xcode project / simulator / XCTest app target.
///
/// **Per-call cost**: `D3NexusNativeLogger.log` calls `isEnabled` once per
/// registered appender, per log call — `UserDefaults.string(forKey:)`
/// itself is a cheap in-memory lookup (a plist-backed cache Foundation
/// keeps resident), but re-parsing the JSON toggle map on every single
/// call would not be. `readToggles` caches the last-decoded map,
/// invalidated only when the raw string actually differs from what's
/// cached — so as long as nothing else changes `rawKey` between calls (the
/// common case: Dart writes it rarely, via Settings UI), repeat
/// `isEnabled` calls skip JSON parsing entirely.
public final class NativeAppenderToggleStore {
  /// The raw native `UserDefaults` key, already carrying the `flutter.`
  /// prefix `shared_preferences` adds transparently on the Dart side. See
  /// this class's doc comment.
  public static let rawKey = "flutter.logging.appender_toggles"

  private let userDefaults: UserDefaults
  private let lock = NSLock()
  private var cachedRawJson: String?
  private var cachedToggles: [String: Bool] = [:]

  public init(userDefaults: UserDefaults) {
    self.userDefaults = userDefaults
  }

  /// Convenience for production call sites: reads from `UserDefaults.standard`.
  public convenience init() {
    self.init(userDefaults: .standard)
  }

  /// Whether the appender identified by `appenderId` should receive
  /// headless log dispatch. Defaults to `true` (enabled) if the toggle map
  /// key is absent entirely, or if `appenderId` has no explicit entry
  /// within it.
  public func isEnabled(_ appenderId: String) -> Bool {
    let toggles = readToggles()
    return toggles[appenderId] ?? true
  }

  private func readToggles() -> [String: Bool] {
    lock.lock()
    defer { lock.unlock() }

    let json = userDefaults.string(forKey: Self.rawKey)
    if json == cachedRawJson {
      // Nothing has changed under rawKey since the last read: skip
      // re-parsing entirely.
      return cachedToggles
    }
    let decoded = Self.decodeToggles(json)
    cachedRawJson = json
    cachedToggles = decoded
    return decoded
  }

  private static func decodeToggles(_ json: String?) -> [String: Bool] {
    guard let json else { return [:] }
    guard let data = json.data(using: .utf8) else { return [:] }
    guard let raw = try? JSONSerialization.jsonObject(with: data) else { return [:] }
    guard let dict = raw as? [String: Any] else { return [:] }

    var result: [String: Bool] = [:]
    for (key, value) in dict {
      if let boolValue = strictBool(value) {
        result[key] = boolValue
      }
    }
    return result
  }

  /// `JSONSerialization` represents both JSON booleans and JSON numbers as
  /// `NSNumber`, and a plain `value as? Bool` cast on an `NSNumber` can
  /// silently accept a numeric `1`/`0` as `true`/`false` due to
  /// Objective-C bridging — this would let a malformed (but
  /// numeric-instead-of-boolean) toggle value pass through unnoticed.
  /// Guard against that by checking the underlying `NSNumber`'s
  /// Objective-C type encoding is actually `Bool` (`"c"`/`"B"`), not a
  /// numeric type.
  private static func strictBool(_ value: Any) -> Bool? {
    guard let number = value as? NSNumber else { return nil }
    let type = String(cString: number.objCType)
    guard type == "c" || type == "B" else { return nil }
    return number.boolValue
  }
}
