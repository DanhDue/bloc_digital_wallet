// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/wallet_list_model.dart';
import 'package:network/network.dart';

part 'wallet_list_client.g.dart';

@RestApi()
@injectable
abstract class WalletListClient {
  @factoryMethod
  factory WalletListClient(Dio dio, {@Named(AppUri.baseUrl) required String baseUrl}) =
      _WalletListClient;

  @GET('/api/v1/wallet_list')
  Future<BaseResponseObject<WalletListModel>> getWalletList();
}
