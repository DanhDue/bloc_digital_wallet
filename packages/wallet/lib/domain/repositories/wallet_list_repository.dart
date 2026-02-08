// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import '../entities/wallet_list_entity.dart';

abstract class WalletListRepository {
  Future<Either<Failure, WalletListEntity>> getWalletList();
}
