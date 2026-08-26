// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:logger/d3nexus_logger.dart';
import 'package:logger_native_bridge/logger_native_bridge.dart';
import 'package:settings/settings.dart' show SettingsLocalDataSource;
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;
import '../../di/injection.dart';
import '../../logging/appenders_for_environment.dart';
import 'package:core/core.dart';

class LoggingInitializer implements AppInitializer {
  @override
  Future<void> init() async {
    final talker = getIt<Talker>();

    // Initialize D3NexusLogger (backend-agnostic logging facade) with the
    // environment-appropriate appender set. See
    // `appendersForEnvironment` for the dev vs. staging/production split.
    final manager = LogManagerImpl();
    for (final appender in appendersForEnvironment(
      talker,
      isDevelopment: EnvironmentConfig.isDevelopment,
    )) {
      manager.registerAppender(appender);
    }

    // Apply any module/appender toggles the user set in a previous session
    // (Settings -> Module Logging / Telemetry) directly to `manager`,
    // before wiring it into the D3NexusLogger facade below. This must be
    // done on the LogManagerImpl instance directly (not via
    // D3NexusLogger.setModuleEnabled/setAppenderEnabled) since the facade
    // throws StateError until D3NexusLogger.initialize() has run — which
    // happens after this point.
    final settingsLocalDataSource = getIt<SettingsLocalDataSource>();
    final moduleToggles = await settingsLocalDataSource.getModuleToggles();
    for (final entry in moduleToggles.entries) {
      manager.setModuleEnabled(entry.key, entry.value);
    }
    final appenderToggles = await settingsLocalDataSource.getAppenderToggles();
    for (final entry in appenderToggles.entries) {
      manager.setAppenderEnabled(entry.key, entry.value);
    }

    D3NexusLogger.initialize(manager);

    // Wire the headless native-log replay channel. NativeLogBridgePlugin
    // (Kotlin/Swift) attaches during FlutterActivity.onCreate/AppDelegate
    // engine setup -- strictly BEFORE Dart's main() (and therefore this
    // call) can possibly run -- so its attach-time auto-drain cannot be
    // relied on to find a Dart handler already installed; it races this
    // app's own startup and loses on every real cold start.
    // registerNativeLogBridge() itself installs the Dart handler
    // (NativeLogFlutterApi.setUp) and THEN explicitly requests a flush
    // (NativeLogHostApi().triggerFlush()) -- see that function's doc
    // comment for the full failure mode this avoids. Because Dart drives
    // the drain itself, replay is reliable regardless of the attach-time
    // race, as long as this call happens after D3NexusLogger.initialize()
    // above (NativeLogBridge forwards into D3NexusLogger.getLogger(...)).
    //
    // Note: this only wires the DART-side replay listener. The native-side
    // production bootstrap (e.g. registering a real `DatadogNativeAppender`
    // from `Application.onCreate`/`AppDelegate`, outside of tests) remains
    // a deliberate future step, not an oversight -- no native bootstrap
    // hook exists yet for `native_security` today (see Task 7's design
    // spec), and creating one is a separate, out-of-scope concern.
    registerNativeLogBridge();
  }
}
