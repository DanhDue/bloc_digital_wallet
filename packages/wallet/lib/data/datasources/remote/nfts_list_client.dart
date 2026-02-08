// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/nfts_list_model.dart';
import 'package:network/network.dart';

part 'nfts_list_client.g.dart';

@RestApi()
@injectable
abstract class NftsListClient {
  @factoryMethod
  factory NftsListClient(Dio dio, {@Named(AppUri.baseUrl) required String baseUrl}) =
      _NftsListClient;

  @GET('/api/v1/nfts_list')
  Future<BaseResponseObject<NftsListModel>> getNftsList();
}
