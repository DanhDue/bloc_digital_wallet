// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/remote/token_list_remote_datasource.dart';
import '../../domain/entities/token_list_entity.dart';
import '../../domain/repositories/token_list_repository.dart';

@Injectable(as: TokenListRepository)
class TokenListRepositoryImpl implements TokenListRepository {
  final TokenListRemoteDataSource _remoteDataSource;

  TokenListRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, TokenListEntity>> getTokenList() async {
    try {
      final model = await _remoteDataSource.getTokenList();
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
