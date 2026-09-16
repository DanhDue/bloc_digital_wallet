// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../../data/datasources/remote/network_selection_remote_datasource.dart';
import '../../domain/entities/network_selection_entity.dart';
import '../../domain/repositories/network_selection_repository.dart';

@Injectable(as: NetworkSelectionRepository)
class NetworkSelectionRepositoryImpl implements NetworkSelectionRepository {
  final NetworkSelectionRemoteDataSource _remoteDataSource;

  NetworkSelectionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<NetworkSelectionEntity>>> getNetworks() async {
    return _remoteDataSource.getNetworks();
  }
}
