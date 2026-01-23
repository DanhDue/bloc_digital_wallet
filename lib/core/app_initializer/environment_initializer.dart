// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import '../../config/environment_config.dart';
import 'app_initializer.dart';

class EnvironmentInitializer implements AppInitializer {
  @override
  Future<void> init() async {
    // Print environment configuration
    EnvironmentConfig.printConfig();
  }
}
