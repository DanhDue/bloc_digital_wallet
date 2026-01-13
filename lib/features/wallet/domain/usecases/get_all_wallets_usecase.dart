// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/wallet_entity.dart';
import '../repositories/wallet_repository.dart';

@injectable
class GetAllWalletsUseCase {
  final WalletRepository repository;

  GetAllWalletsUseCase(this.repository);

  Future<Either<Failure, List<WalletEntity>>> call() async {
    return await repository.getAllWallets();
  }
}
