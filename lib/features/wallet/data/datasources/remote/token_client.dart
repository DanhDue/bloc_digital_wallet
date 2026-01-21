// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:bloc_digital_wallet/core/network/app_uri.dart';
import 'package:bloc_digital_wallet/features/wallet/data/models/token_account_object.dart';
import 'package:bloc_digital_wallet/core/network/base_response_object.dart';

part 'token_client.g.dart';

@RestApi()
abstract class TokenClient {
  factory TokenClient(Dio dio, {String baseUrl}) = _TokenClient;

  @GET(AppUri.accounts + UriPathParameters.address)
  Future<BaseResponseObject<List<TokenAccountObject>>> getTokenAccounts(
    @Path("address") String address,
  );
}
