// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'app_initializer.dart';

class AppInitializerImpl implements AppInitializer {
  final List<AppInitializer> _initializers;

  AppInitializerImpl(this._initializers);

  @override
  Future<void> init() async {
    for (final initializer in _initializers) {
      await initializer.init();
    }
  }
}
