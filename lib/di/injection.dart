// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:network/network.dart' as network;
import 'package:app_platform/platform.dart' as platform;
import 'package:core/core.dart' as core;
import 'package:scanner/scanner.dart' as scanner;
import 'package:settings/settings.dart' as settings;

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt')
Future<void> configureDependencies() async {
  core.configureModuleDependencies(getIt);
  network.configureModuleDependencies(getIt);
  platform.configureModuleDependencies(getIt);
  scanner.configureModuleDependencies(getIt);
  await settings.configureModuleDependencies(getIt);

  getIt.$initGetIt();
}
