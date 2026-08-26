// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// Covers the fix-round-2 bug: NativeLogBridgePlugin's attach-time
// auto-drain fires before Dart's main() even starts (during
// FlutterActivity.onCreate / AppDelegate engine setup), so on every real
// cold start it races against -- and loses to -- Dart-side handler
// registration. registerNativeLogBridge() must call NativeLogFlutterApi.
// setUp(...) BEFORE NativeLogHostApi().triggerFlush(), so the drain Dart
// itself requests always reaches a live handler.
//
// This test simulates the real native round trip (triggerFlush ->
// onNativeLog) through Flutter's test binary messenger, rather than only
// asserting call order in the abstract, so it actually reproduces the
// failure mode (a null/unhandled reply on the onNativeLog channel) if the
// ordering regresses.

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:logger_native_bridge/logger_native_bridge.dart';

import 'support/fake_logging.dart';

const _triggerFlushChannel = 'dev.flutter.pigeon.logger_native_bridge.NativeLogHostApi.triggerFlush';
const _onNativeLogChannel = 'dev.flutter.pigeon.logger_native_bridge.NativeLogFlutterApi.onNativeLog';

/// Simulates a message arriving FROM native TO Dart on [channel] -- exactly
/// what `NativeLogBridgePlugin`'s real `onNativeLog(...)` call does on the
/// Kotlin/Swift side. Returns the reply Dart's registered handler sends
/// back, or `null` if nothing is registered to handle it (the exact
/// signature of the bug this test guards against).
Future<ByteData?> _simulateIncomingFromNative(String channel, ByteData? message) {
  final completer = Completer<ByteData?>();
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
    channel,
    message,
    (ByteData? reply) => completer.complete(reply),
  );
  return completer.future;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FakeLogManager manager;

  setUp(() {
    manager = FakeLogManager();
    D3NexusLogger.initialize(manager);
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
      _triggerFlushChannel,
      null,
    );
  });

  test(
    'registerNativeLogBridge installs the onNativeLog handler before '
    'requesting a native flush, so a drain triggered by that flush reaches '
    'a live Dart handler instead of racing an unregistered channel',
    () async {
      var triggerFlushCallCount = 0;
      ByteData? onNativeLogReply;

      // Mocks the NATIVE side of triggerFlush(): when Dart calls it, this
      // simulates NativeLogBridgePlugin.triggerFlush()'s real behavior --
      // drain the queue by sending a NativeLogMessage back to Dart on the
      // onNativeLog channel, then reply success.
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMessageHandler(
        _triggerFlushChannel,
        (ByteData? message) async {
          triggerFlushCallCount++;

          final encodedCall = NativeLogFlutterApi.pigeonChannelCodec.encodeMessage(<Object?>[
            NativeLogMessage(
              level: NativeLogLevel.warning,
              tag: 'HeadlessWorker',
              message: 'queued while no engine was attached',
              timestamp: 1700000000000,
            ),
          ]);
          onNativeLogReply = await _simulateIncomingFromNative(_onNativeLogChannel, encodedCall);

          return NativeLogHostApi.pigeonChannelCodec.encodeMessage(<Object?>[]);
        },
      );

      registerNativeLogBridge();
      // registerNativeLogBridge's triggerFlush() call is intentionally
      // fire-and-forget (see its doc comment) -- pump the event loop so it
      // actually runs before asserting on its effects.
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(triggerFlushCallCount, 1);
      expect(
        onNativeLogReply,
        isNotNull,
        reason:
            'onNativeLog must have reached a live handler when the flush fired -- a null '
            'reply means no handler was registered yet, reproducing the exact race this '
            'fix corrects (NativeLogFlutterApi.setUp must run BEFORE triggerFlush() is '
            'called)',
      );

      final logger = D3NexusLogger.getLogger('Native:HeadlessWorker') as FakeLogger;
      expect(logger.records, hasLength(1));
      expect(logger.records.single.message, contains('queued while no engine was attached'));
    },
  );
}
