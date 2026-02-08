// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:network/network.dart';
import 'package:retrofit/retrofit.dart';

import 'package:wallet/data/models/token_list_model.dart';

part 'token_client.g.dart';

@RestApi()
@injectable
abstract class TokenClient {
  @factoryMethod
  factory TokenClient(Dio dio, {@Named(AppUri.baseUrl) required String baseUrl}) = _TokenClient;

  @GET('/${AppUri.accounts}/${UriPathParameters.address}')
  Future<BaseResponseObject<List<TokenListModel>>> getTokenAccounts(
    @Path("address") String address,
  );
}
