// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:network/di/network_module.config.dart';
import 'package:network/dio_factory.dart';
import 'package:network/ssl/ssl.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Network package DI module providing core network dependencies.
@InjectableInit(initializerName: r'$initModuleGetIt')
void configureModuleDependencies(GetIt getIt) => getIt.$initModuleGetIt();

@module
abstract class NetworkModule {
  /// Package default: no fingerprint source ⇒ no pinning (non-debug builds use
  /// the system trust store). The app's composition layer replaces this
  /// registration with an `AutoSslConfiguration` that carries a real
  /// `SslFingerprintSource` — see `lib/di/injection.dart`.
  @lazySingleton
  SslConfiguration get sslConfiguration => const AutoSslConfiguration();

  @lazySingleton
  Talker get talker => TalkerFlutter.init(
    logger: TalkerLogger(
      output: debugPrint, // Use debugPrint to ensure visibility in Flutter console
      settings: TalkerLoggerSettings(enableColors: false),
    ),
  );

  @lazySingleton
  Dio provideDio(SslConfiguration sslConfiguration, Talker talker) => DioFactory(
    talker,
    sslConfiguration: sslConfiguration,
    baseUrl: EnvironmentConfig.apiBaseUrl,
    enableLogging: EnvironmentConfig.enableLogging,
  ).dio;

  @lazySingleton
  @Named('refreshDio')
  Dio provideRefreshDio(SslConfiguration sslConfiguration, Talker talker) => DioFactory(
    talker,
    sslConfiguration: sslConfiguration,
    baseUrl: EnvironmentConfig.apiBaseUrl,
    enableLogging: EnvironmentConfig.enableLogging,
  ).dio;
}
