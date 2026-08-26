// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:logger/d3nexus_logger.dart';
import 'package:talker_flutter/talker_flutter.dart' hide LogLevel;
import '../../di/injection.dart';
import '../../logging/appenders_for_environment.dart';
import 'package:core/core.dart';

class LoggingInitializer implements AppInitializer {
  @override
  Future<void> init() async {
    final talker = getIt<Talker>();

    // Initialize Log with Talker instance from DI
    Log.init(talker);

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
    D3NexusLogger.initialize(manager);
  }
}
