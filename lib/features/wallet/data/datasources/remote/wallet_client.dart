// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../../core/network/app_uri.dart';
import '../../../../../core/network/base_response_object.dart';
import '../../models/token_account_object.dart';

part 'wallet_client.g.dart';

@RestApi()
abstract class WalletClient {
  factory WalletClient(Dio dio, {String baseUrl}) = _WalletClient;

  @GET('/${AppUri.accounts}/{address}')
  Future<BaseResponseObject<List<TokenAccountObject>>> getTokenAccounts(
    @Path('address') String address,
  );
}
