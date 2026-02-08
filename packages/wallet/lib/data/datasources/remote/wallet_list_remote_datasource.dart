// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';

import 'wallet_list_client.dart';
import '../../models/wallet_list_model.dart';

abstract class WalletListRemoteDataSource {
  Future<WalletListModel> getWalletList();
}

@Injectable(as: WalletListRemoteDataSource)
class WalletListRemoteDataSourceImpl implements WalletListRemoteDataSource {
  final WalletListClient _client;

  WalletListRemoteDataSourceImpl(this._client);

  @override
  Future<WalletListModel> getWalletList() async {
    final response = await _client.getWalletList();
    return response.data!;
  }
}
