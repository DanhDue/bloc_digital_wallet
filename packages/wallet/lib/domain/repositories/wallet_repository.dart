// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletEntity>> getWallet();
}
