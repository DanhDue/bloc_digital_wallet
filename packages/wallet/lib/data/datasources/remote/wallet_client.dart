// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:wallet/data/models/wallet_model.dart';

part 'wallet_client.g.dart';

@RestApi()
abstract class WalletClient {
  factory WalletClient(Dio dio, {String? baseUrl}) = _WalletClient;

  @GET('/wallet')
  Future<WalletModel> getWallet();
}
