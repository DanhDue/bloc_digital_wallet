// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/entities/d3_votion_entity.dart';

part 'd3_votion_client.g.dart';

@RestApi()
abstract class D3VotionClient {
  factory D3VotionClient(Dio dio, {String baseUrl}) = _D3VotionClient;

  @GET("")
  Future<D3VotionEntity> getD3Votion(@Query("word") String word);
}
