// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/data/datasources/remote/wallet_remote_datasource.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/domain/repositories/wallet_repository.dart';

@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;

  WalletRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, WalletEntity>> getWallet() {
    return _remoteDataSource.getWallet();
  }
}
