// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';

import 'nfts_list_client.dart';
import '../../models/nfts_list_model.dart';

abstract class NftsListRemoteDataSource {
  Future<NftsListModel> getNftsList();
}

@Injectable(as: NftsListRemoteDataSource)
class NftsListRemoteDataSourceImpl implements NftsListRemoteDataSource {
  final NftsListClient _client;

  NftsListRemoteDataSourceImpl(this._client);

  @override
  Future<NftsListModel> getNftsList() async {
    final response = await _client.getNftsList();
    return response.data!;
  }
}
