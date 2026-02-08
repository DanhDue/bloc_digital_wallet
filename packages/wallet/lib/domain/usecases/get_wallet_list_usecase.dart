// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';

import '../entities/wallet_list_entity.dart';
import '../repositories/wallet_repository.dart';

@injectable
class GetWalletListUseCase {
  final WalletRepository _repository;

  GetWalletListUseCase(this._repository);

  Future<Either<Failure, WalletListEntity>> call() {
    return _repository.getWalletList();
  }
}
