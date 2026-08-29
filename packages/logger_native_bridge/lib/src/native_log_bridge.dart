// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:logger/d3nexus_logger.dart';

import 'messages.g.dart';

/// Implements the Pigeon-generated [NativeLogFlutterApi]: called by native
/// code (`NativeLogBridgePlugin.onAttachedToEngine`) once per queued
/// headless entry, in original FIFO order, and forwards each into
/// `D3NexusLogger.getLogger('Native:$tag')` — so headless native logs
/// surface on Talker (and any other registered Dart-side appender) the
/// next time a `FlutterEngine` attaches.
///
/// **Known gap — original timestamp is not preserved on the forwarded
/// [LogRecord] itself.** [ILogger]'s `d`/`i`/`w`/`e`/`v` methods don't
/// accept an explicit timestamp; `LoggerImpl` always stamps
/// `LogRecord.timestamp` with `DateTime.now()` at call time (see
/// `packages/logger/lib/src/logger_impl.dart`). `packages/logger` is a
/// committed, stable package from an earlier task in this epic and is
/// deliberately NOT modified here to thread a timestamp override through
/// `ILogger`'s interface. The Pigeon message itself DOES correctly carry
/// the original native timestamp end-to-end (see
/// `NativeLogMessage.timestamp`, populated at the moment the headless call
/// happened, not at replay time) — this class makes that original value
/// visible by prefixing it onto the forwarded message text (see
/// [_prefixWithOriginalTimestamp]), so a developer reading Talker can see
/// when the entry actually happened, even though the in-app `LogRecord`'s
/// own `.timestamp` field reflects replay time, not original time.
/// **Causal order is unaffected by this gap**: [NativeLogBridgePlugin]
/// replays entries strictly in original FIFO order, and Talker displays
/// entries in the order they were appended — order does not depend on the
/// `LogRecord.timestamp` field.
///
/// **Known gap — native `traceId` is not attached to the forwarded
/// [LogRecord]'s trace/span correlation.** `ILogger.traceId`/`spanId` are
/// generated once, per module, when a logger is first obtained from
/// `getLogger` (see `LoggerImpl`) — there's no supported way to stamp an
/// externally-supplied trace id onto an individual `d`/`i`/`w`/`e`/`v`
/// call without the same `packages/logger` interface change this class
/// deliberately avoids. `NativeLogMessage.traceId` is preserved on the
/// wire (Pigeon message) but not threaded into the replayed
/// `LogRecord.traceId`.
class NativeLogBridge implements NativeLogFlutterApi {
  @override
  void onNativeLog(NativeLogMessage message) {
    final logger = D3NexusLogger.getLogger('Native:${message.tag}');
    final text = _prefixWithOriginalTimestamp(message);

    switch (message.level) {
      case NativeLogLevel.verbose:
        logger.v(text);
      case NativeLogLevel.debug:
        logger.d(text);
      case NativeLogLevel.info:
        logger.i(text);
      case NativeLogLevel.warning:
        logger.w(text);
      case NativeLogLevel.error:
        logger.e(text);
    }
  }

  /// Prefixes [message]'s text with its original native timestamp
  /// (epoch-milliseconds -> UTC ISO-8601), since the forwarded
  /// [LogRecord] itself can't carry it (see this class's doc comment).
  static String _prefixWithOriginalTimestamp(NativeLogMessage message) {
    final originalTimestamp = DateTime.fromMillisecondsSinceEpoch(message.timestamp, isUtc: true);
    return '[native @ ${originalTimestamp.toIso8601String()}] ${message.message}';
  }
}
