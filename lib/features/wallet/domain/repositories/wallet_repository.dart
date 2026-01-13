// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/wallet_entity.dart';

abstract class WalletRepository {
  /// Get wallet by id
  Future<Either<Failure, WalletEntity>> getWallet(String id);

  /// Get all wallets
  Future<Either<Failure, List<WalletEntity>>> getAllWallets();

  /// Create a new wallet
  Future<Either<Failure, WalletEntity>> createWallet(WalletEntity entity);

  /// Update wallet
  Future<Either<Failure, WalletEntity>> updateWallet(WalletEntity entity);

  /// Delete wallet
  Future<Either<Failure, void>> deleteWallet(String id);
}
