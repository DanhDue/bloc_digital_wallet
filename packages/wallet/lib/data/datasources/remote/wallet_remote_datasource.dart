// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:network/network.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:wallet/data/datasources/remote/token_client.dart';
import 'package:wallet/data/datasources/remote/wallet_client.dart';
import 'package:wallet/data/models/nfts_list_model.dart';
import 'package:wallet/data/models/token_list_model.dart';
import 'package:wallet/data/models/wallet_list_model.dart';
import 'package:wallet/data/models/wallet_model.dart';
import 'package:wallet/domain/entities/wallet_entity.dart';

@lazySingleton
class WalletRemoteDataSource with SafeCallApiMixin {
  final WalletClient _client;
  final TokenClient _tokenClient;

  WalletRemoteDataSource(this._client, this._tokenClient);

  Future<Either<Failure, WalletEntity>> getWallet() async {
    final result = await safeApiCall(() => _client.getWallet());
    return result.map((model) => model.toEntity());
  }

  Future<Either<Failure, BaseResponseObject<List<TokenListModel>>>> getTokenAccounts(
    String address,
  ) => safeApiCall(() => _tokenClient.getTokenAccounts(address));

  Future<WalletListModel> getWalletList() async {
    final response = await _client.getWalletList();
    return response.data!;
  }

  Future<NftsListModel> getNftsList() async {
    final response = await _client.getNftsList();
    return response.data!;
  }
}
