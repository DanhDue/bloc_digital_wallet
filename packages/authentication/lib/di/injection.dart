// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:authentication/di/injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

@InjectableInit(initializerName: r'$initModuleGetIt')
void configureModuleDependencies(GetIt getIt) => getIt.$initModuleGetIt();

@module
abstract class AuthenticationNetworkModule {}
