// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:network/network.dart' as network;
import 'package:core/core.dart' as core;
import 'package:onboard/onboard.dart' as onboard;
import 'package:settings/settings.dart' as settings;

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt')
void configureDependencies() {
  // configureDataDependencies imported from feature_module
  core.configureModuleDependencies(getIt);
  network.configureModuleDependencies(getIt);
  onboard.configureModuleDependencies(getIt);
  settings.configureModuleDependencies(getIt);

  // we need to call $initGetIt after all modules are configured
  getIt.$initGetIt();
}
