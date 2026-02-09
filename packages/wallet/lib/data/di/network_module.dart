// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:network/app_uri.dart';
import 'package:network/extensions/string_ext.dart';
import 'package:wallet/data/datasources/remote/token_client.dart';
import 'package:wallet/data/datasources/remote/wallet_client.dart';

@module
abstract class WalletNetworkModule {
  @singleton
  WalletClient provideWalletClient(Dio dio) =>
      WalletClient(dio, baseUrl: AppUri.wallets.buildAppUri());

  @lazySingleton
  TokenClient tokenClient(Dio dio) => TokenClient(dio, baseUrl: AppUri.tokens.buildAppUri());
}
