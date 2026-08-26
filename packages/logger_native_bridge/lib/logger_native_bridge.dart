// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

/// Headless native-to-Dart logging bridge.
///
/// Lets plain Kotlin/Swift code (no `FlutterEngine` attached) push logs to
/// native telemetry appenders and queues them for best-effort replay into
/// `D3NexusLogger`/Talker the next time the Flutter engine attaches. See
/// `.devtool/epic/logging_refactor/2026-08-26-logger-native-bridge-headless-design.md`
/// for the full architecture.
library;

import 'dart:async';

import 'src/messages.g.dart';
import 'src/native_log_bridge.dart';

export 'src/messages.g.dart';
export 'src/native_log_bridge.dart';

/// Registers a [NativeLogBridge] to receive native replay calls, then
/// explicitly requests an immediate drain of anything already queued.
///
/// Call once during app startup, after `D3NexusLogger.initialize(...)`, so
/// the underlying `ILogManager` is ready before any replayed entry can
/// reach it.
///
/// **Why this calls `triggerFlush()` itself, rather than relying on
/// `NativeLogBridgePlugin`'s attach-time auto-drain:** the native plugin
/// attaches (`onAttachedToEngine` / `register(with:)`) during
/// `FlutterActivity.onCreate`/`AppDelegate` engine setup, which happens
/// BEFORE Dart's `main()` even starts running -- strictly before this
/// function can possibly have run. On every real cold start, the
/// attach-time auto-drain therefore fires with NO Dart handler installed
/// yet: each `onNativeLog` send lands in Flutter's `ChannelBuffers`
/// (capacity 1), overflow entries are silently dropped, Pigeon maps the
/// resulting empty/non-list reply to a failure, and
/// `NativeLogBridgePlugin` never calls `NativeLogQueue.clear()` because
/// not every entry in the batch succeeded -- so replay would silently and
/// permanently break on every cold start with more than one queued entry.
///
/// Calling `NativeLogHostApi().triggerFlush()` here -- AFTER
/// `NativeLogFlutterApi.setUp` has installed the handler -- makes Dart the
/// one that drives the drain, once it's actually ready to receive. This
/// reuses the exact same `drainAndReplay` path the (harmless, best-effort)
/// attach-time auto-drain already exercises natively -- see
/// `NativeLogBridgePlugin`'s doc comment on both platforms.
void registerNativeLogBridge() {
  NativeLogFlutterApi.setUp(NativeLogBridge());
  unawaited(NativeLogHostApi().triggerFlush());
}
