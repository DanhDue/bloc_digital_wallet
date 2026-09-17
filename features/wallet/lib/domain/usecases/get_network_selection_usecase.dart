// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../entities/network_selection_entity.dart';
import '../repositories/network_selection_repository.dart';

@injectable
class GetNetworkSelectionUseCase {
  final NetworkSelectionRepository _repository;

  GetNetworkSelectionUseCase(this._repository);

  Future<Either<Failure, List<NetworkSelectionEntity>>> call() {
    return _repository.getNetworks();
  }
}
