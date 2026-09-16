// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:network/network.dart' as network;
import 'package:app_platform/platform.dart' as platform;
import 'package:core/core.dart' as core;
// di:scanner-import:begin
import 'package:scanner/scanner.dart' as scanner;
// di:scanner-import:end
import 'package:settings/settings.dart' as settings;
import 'package:transaction/transaction.dart' as transaction;
import 'package:wallet/wallet.dart' as wallet;
import 'package:authentication/authentication.dart' as authentication;
import 'package:onboard/onboard.dart' as onboard;

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(initializerName: r'$initGetIt')
Future<void> configureDependencies() async {
  core.configureModuleDependencies(getIt);
  network.configureModuleDependencies(getIt);
  platform.configureModuleDependencies(getIt);
  // di:scanner-module:begin
  scanner.configureModuleDependencies(getIt);
  // di:scanner-module:end
  await settings.configureModuleDependencies(getIt);
  transaction.configureModuleDependencies(getIt);
  wallet.configureModuleDependencies(getIt);
  authentication.configureModuleDependencies(getIt);
  onboard.configureModuleDependencies(getIt);

  // `packages/network` registers a no-pinning `SslConfiguration` default; the
  // app owns SSL pinning (it's the only layer allowed to touch
  // `native_security`). Drop the package default so `AppNetworkModule`'s
  // `sslConfiguration` — registered by `$initGetIt()` below — takes over. Safe
  // to unregister here: `Dio`/`refreshDio` are lazy, nothing has resolved
  // `SslConfiguration` yet.
  if (getIt.isRegistered<network.SslConfiguration>()) {
    getIt.unregister<network.SslConfiguration>();
  }

  getIt.$initGetIt();
}
