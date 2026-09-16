// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:network/base_response_object.dart';
import 'package:wallet/data/datasources/remote/wallet_uri.dart';
import 'package:retrofit/retrofit.dart';

import 'package:wallet/data/models/token_list_model.dart';

part 'token_client.g.dart';

@RestApi()
abstract class TokenClient {
  factory TokenClient(Dio dio, {String? baseUrl}) = _TokenClient;

  @GET('/${WalletUri.accounts}${WalletUri.pathAddress}')
  Future<BaseResponseObject<List<TokenListModel>>> getTokenAccounts(
    @Path("address") String address,
  );
}
