// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:get_it/get_it.dart';

/// Registers this package's dependencies into the shared [GetIt] container.
///
/// Nothing needs registering yet: [DeepLinkRoutes] is a set of static route
/// constants with no runtime dependencies. This hook exists so the host
/// app's composition root (`lib/di/injection.dart`) already wires `platform`
/// in, ready for the app-wide event bus and any other platform-level
/// services this package grows to hold.
void configureModuleDependencies(GetIt getIt) {}
