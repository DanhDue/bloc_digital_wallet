// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/data/datasources/remote/wallet_remote_datasource.dart';
import 'package:wallet/domain/entities/nfts_list_entity.dart';
import 'package:wallet/domain/entities/token_list_entity.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/domain/entities/wallet_list_entity.dart';
import 'package:wallet/domain/repositories/wallet_repository.dart';

import 'package:wallet/data/datasources/local/wallet_local_datasource.dart';

@LazySingleton(as: WalletRepository)
class WalletRepositoryImpl implements WalletRepository {
  final WalletRemoteDataSource _remoteDataSource;
  final WalletLocalDataSource _localDataSource;

  WalletRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, WalletEntity>> getWallet() {
    return _remoteDataSource.getWallet();
  }

  @override
  Future<Either<Failure, List<TokenListEntity>>> getTokenAccounts(String address) async {
    final result = await _remoteDataSource.getTokenAccounts(address);
    return result.map((response) => (response.data ?? []).map((e) => e.toEntity()).toList());
  }

  @override
  Future<Either<Failure, NftsListEntity>> getNftsList() async {
    try {
      final model = await _remoteDataSource.getNftsList();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WalletListEntity>> getWalletList() async {
    try {
      final model = await _localDataSource.getWalletList();
      return Right(model.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
