// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/remote/nfts_list_remote_datasource.dart';
import '../../domain/entities/nfts_list_entity.dart';
import '../../domain/repositories/nfts_list_repository.dart';

@Injectable(as: NftsListRepository)
class NftsListRepositoryImpl implements NftsListRepository {
  final NftsListRemoteDataSource _remoteDataSource;

  NftsListRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, NftsListEntity>> getNftsList() async {
    try {
      final model = await _remoteDataSource.getNftsList();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
