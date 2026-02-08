// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../entities/nfts_list_entity.dart';
import '../repositories/nfts_list_repository.dart';

@injectable
class GetNftsListUseCase {
  final NftsListRepository _repository;

  GetNftsListUseCase(this._repository);

  Future<Either<Failure, NftsListEntity>> call() {
    return _repository.getNftsList();
  }
}
