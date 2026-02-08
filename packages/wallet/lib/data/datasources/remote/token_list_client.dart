// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/token_list_model.dart';
import 'package:network/network.dart';

part 'token_list_client.g.dart';

@RestApi()
@injectable
abstract class TokenListClient {
  @factoryMethod
  factory TokenListClient(Dio dio, {@Named(AppUri.baseUrl) required String baseUrl}) =
      _TokenListClient;

  @GET('/api/v1/token_list')
  Future<BaseResponseObject<TokenListModel>> getTokenList();
}
