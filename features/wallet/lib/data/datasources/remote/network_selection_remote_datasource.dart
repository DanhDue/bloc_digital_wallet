// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/network_selection_entity.dart';

abstract class NetworkSelectionRemoteDataSource {
  Future<Either<Failure, List<NetworkSelectionEntity>>> getNetworks();
}

@Injectable(as: NetworkSelectionRemoteDataSource)
class NetworkSelectionRemoteDataSourceImpl implements NetworkSelectionRemoteDataSource {
  NetworkSelectionRemoteDataSourceImpl();

  @override
  Future<Either<Failure, List<NetworkSelectionEntity>>> getNetworks() async {
    // Mocked data matching source implementation
    final modifiedList = [
      const NetworkSelectionEntity(id: 'ALL', name: 'All Networks', logo: ''),
      const NetworkSelectionEntity(
        id: 'SOL',
        logo: 'https://s2.coinmarketcap.com/static/img/coins/200x200/5426.png',
        name: 'Solana Mainnet',
      ),
    ];
    return Right(modifiedList);
  }
}
