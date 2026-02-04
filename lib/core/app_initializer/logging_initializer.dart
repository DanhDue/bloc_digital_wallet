// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:talker_flutter/talker_flutter.dart';
import '../../di/injection.dart';
import 'package:core/core.dart';

class LoggingInitializer implements AppInitializer {
  @override
  Future<void> init() async {
    // Initialize Log with Talker instance from DI
    Log.init(getIt<Talker>());
  }
}
