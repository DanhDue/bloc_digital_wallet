// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/domain/entities/token_list_entity.dart';
import 'package:wallet/domain/repositories/wallet_repository.dart';

/// Use case to get token accounts for a wallet address
@injectable
class GetTokenAccountsUseCase {
  final WalletRepository _repository;

  GetTokenAccountsUseCase(this._repository);

  Future<Either<Failure, List<TokenListEntity>>> call(String address) {
    return _repository.getTokenAccounts(address);
  }
}
