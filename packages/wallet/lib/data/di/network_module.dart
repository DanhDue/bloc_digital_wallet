// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/data/datasources/remote/wallet_client.dart';

@module
abstract class WalletNetworkModule {
  @lazySingleton
  WalletClient walletClient(Dio dio) => WalletClient(dio);
}
