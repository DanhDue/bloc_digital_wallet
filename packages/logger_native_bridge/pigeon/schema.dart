// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// Pigeon schema for the logger_native_bridge headless replay channel.
//
// This channel exists ONLY to replay best-effort, already-happened native
// log entries into the Dart-side D3NexusLogger/Talker the next time a
// FlutterEngine attaches (see NativeLogBridgePlugin.onAttachedToEngine).
// It is NOT the path headless native code uses to reach a telemetry
// backend — that path (D3NexusNativeLogger -> NativeLogAppender, e.g.
// DatadogNativeAppender) has zero Flutter/Pigeon dependency by design, so
// it works with no FlutterEngine at all. See
// .devtool/epic/logging_refactor/2026-08-26-logger-native-bridge-headless-design.md
//
// Regenerate with (from packages/logger_native_bridge/):
//   dart run pigeon --input pigeon/schema.dart

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/src/messages.g.dart',
    kotlinOut: 'android/src/main/kotlin/com/danhdue/logger_native_bridge/Messages.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.danhdue.logger_native_bridge'),
    swiftOut: 'ios/Classes/Messages.g.swift',
    dartPackageName: 'logger_native_bridge',
  ),
)
/// Severity of a replayed native log entry. Mirrors `LogLevel` in
/// `package:logger` (kept as a separate enum here since Pigeon-generated
/// types must not depend on `package:logger`'s Dart types directly — the
/// mapping from this enum to `package:logger`'s `LogLevel` happens by hand
/// in `lib/src/native_log_bridge.dart`).
enum NativeLogLevel { verbose, debug, info, warning, error }

/// A single native log entry, replayed from `NativeLogQueue` into Dart.
///
/// [timestamp] is epoch milliseconds (UTC) captured natively at the moment
/// the original headless log call happened — NOT at replay/drain time —
/// so replay genuinely preserves original causal ordering and timing even
/// when the drain happens much later (e.g. next app foreground).
class NativeLogMessage {
  const NativeLogMessage({
    required this.level,
    required this.tag,
    required this.message,
    required this.timestamp,
    this.traceId,
  });

  final NativeLogLevel level;
  final String tag;
  final String message;
  final int timestamp;
  final String? traceId;
}

/// Implemented on the Dart side (`NativeLogBridge`). Called by
/// `NativeLogBridgePlugin` once per queued entry, in original FIFO order,
/// when a FlutterEngine attaches.
@FlutterApi()
abstract class NativeLogFlutterApi {
  void onNativeLog(NativeLogMessage message);
}

/// Optional dev/test convenience: forces an immediate queue drain without
/// waiting for/restarting the engine attach lifecycle. Not required for
/// correctness — the automatic `onAttachedToEngine` drain covers the real
/// flow.
@HostApi()
abstract class NativeLogHostApi {
  void triggerFlush();
}
