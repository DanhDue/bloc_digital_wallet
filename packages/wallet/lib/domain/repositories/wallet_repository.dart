// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:wallet/domain/entities/nfts_list_entity.dart';
import 'package:wallet/domain/entities/token_list_entity.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';
import 'package:wallet/domain/entities/wallet_list_entity.dart';

abstract class WalletRepository {
  Future<Either<Failure, WalletEntity>> getWallet();

  Future<Either<Failure, List<TokenListEntity>>> getTokenAccounts(String address);

  Future<Either<Failure, NftsListEntity>> getNftsList();

  Future<Either<Failure, WalletListEntity>> getWalletList();
}
