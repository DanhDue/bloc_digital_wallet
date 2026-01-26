// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/token_account_entity.dart';
import '../../domain/repositories/wallet_repository.dart';

@injectable
class GetTokenAccountsUseCase {
  final WalletRepository _repository;

  GetTokenAccountsUseCase(this._repository);

  Future<Either<Failure, List<TokenAccountEntity>>> call(String address) {
    return _repository.getTokenAccounts(address);
  }
}
