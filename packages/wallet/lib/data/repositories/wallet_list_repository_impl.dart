// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/remote/wallet_list_remote_datasource.dart';
import '../../domain/entities/wallet_list_entity.dart';
import '../../domain/repositories/wallet_list_repository.dart';

@Injectable(as: WalletListRepository)
class WalletListRepositoryImpl implements WalletListRepository {
  final WalletListRemoteDataSource _remoteDataSource;

  WalletListRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, WalletListEntity>> getWalletList() async {
    try {
      final model = await _remoteDataSource.getWalletList();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
