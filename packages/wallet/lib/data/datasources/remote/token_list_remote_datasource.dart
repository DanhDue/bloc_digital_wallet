// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:injectable/injectable.dart';

import 'token_list_client.dart';
import '../../models/token_list_model.dart';

abstract class TokenListRemoteDataSource {
  Future<TokenListModel> getTokenList();
}

@Injectable(as: TokenListRemoteDataSource)
class TokenListRemoteDataSourceImpl implements TokenListRemoteDataSource {
  final TokenListClient _client;

  TokenListRemoteDataSourceImpl(this._client);

  @override
  Future<TokenListModel> getTokenList() async {
    final response = await _client.getTokenList();
    return response.data!;
  }
}
