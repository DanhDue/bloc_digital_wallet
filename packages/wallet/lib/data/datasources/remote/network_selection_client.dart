// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/network_selection_model.dart';
import 'package:network/network.dart';

part 'network_selection_client.g.dart';

@RestApi()
@injectable
abstract class NetworkSelectionClient {
  @factoryMethod
  factory NetworkSelectionClient(Dio dio, {@Named(AppUri.baseUrl) required String baseUrl}) =
      _NetworkSelectionClient;

  @GET('/api/v1/network_selection')
  Future<BaseResponseObject<NetworkSelectionModel>> getNetworkSelection();
}
