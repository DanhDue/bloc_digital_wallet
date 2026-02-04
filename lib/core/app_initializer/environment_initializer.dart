// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

// coverage:ignore-file
import 'package:core/core.dart';

class EnvironmentInitializer implements AppInitializer {
  @override
  Future<void> init() async {
    // Print environment configuration
    EnvironmentConfig.printConfig();
  }
}
