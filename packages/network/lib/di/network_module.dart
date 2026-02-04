// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:network/di/network_module.config.dart';
import 'package:network/ssl/ssl.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:dio/dio.dart';

/// Network package DI module providing core network dependencies.
@InjectableInit(initializerName: r'$initModuleGetIt')
void configureModuleDependencies(GetIt getIt) => getIt.$initModuleGetIt();

@module
abstract class NetworkModule {
  @lazySingleton
  SslConfiguration get sslConfiguration => const AutoSslConfiguration();

  @lazySingleton
  Talker get talker => TalkerFlutter.init(
    logger: TalkerLogger(
      output: debugPrint, // Use debugPrint to ensure visibility in Flutter console
      settings: TalkerLoggerSettings(enableColors: false),
    ),
  );
}
