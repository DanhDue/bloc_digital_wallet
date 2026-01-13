// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

@injectable
class GetWalletUseCase {
  final WalletRepository repository;

  GetWalletUseCase(this.repository);

  Future<Either<Failure, WalletEntity>> call(String id) async {
    return await repository.getWallet(id);
  }
}
