// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:app_platform/di/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

/// Registers this package's dependencies into the shared [GetIt] container.
@InjectableInit(initializerName: r'$initModuleGetIt')
void configureModuleDependencies(GetIt getIt) => getIt.$initModuleGetIt();
