// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/domain/repositories/wallet_repository.dart';

@injectable
class GetWalletUseCase {
  final WalletRepository _repository;

  GetWalletUseCase(this._repository);

  Future<Either<Failure, WalletEntity>> call() {
    return _repository.getWallet();
  }
}
