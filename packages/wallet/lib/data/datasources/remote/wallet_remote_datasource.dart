// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/data/datasources/remote/wallet_client.dart';
import 'package:wallet/data/models/wallet_model.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';

@lazySingleton
class WalletRemoteDataSource with SafeCallApiMixin {
  final WalletClient _client;

  WalletRemoteDataSource(this._client);

  Future<Either<Failure, WalletEntity>> getWallet() async {
    final result = await safeApiCall(() => _client.getWallet());
    return result.map((model) => model.toEntity());
  }
}
