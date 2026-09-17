// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import '../telemetry/cold_start_profiler.dart';
import 'app_initializer.dart';

class AppInitializerImpl implements AppInitializer {
  final List<AppInitializer> _initializers;

  AppInitializerImpl(this._initializers);

  @override
  Future<void> init() async {
    await Future.wait(
      _initializers.map(
        (initializer) => ColdStartProfiler.instance
            .timeAsync(initializer.runtimeType.toString(), () => initializer.init())
            .catchError((_) {
              // Individual initializer failures must not abort siblings.
            }),
      ),
    );
  }
}
