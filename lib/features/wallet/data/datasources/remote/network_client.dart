// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/core/network/base_response_object.dart';
import 'package:bloc_digital_wallet/features/wallet/data/models/network_object.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'network_client.g.dart';

@RestApi()
abstract class NetworkClient {
  factory NetworkClient(Dio dio, {String baseUrl}) = _NetworkClient;

  @GET('')
  Future<BaseResponseObject<List<NetworkObject>>> getNetworks();
}
