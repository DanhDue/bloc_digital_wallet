import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:bloc_digital_wallet/features/d3_votion/domain/entities/d3_votion_entity.dart';

part 'd3_votion_api.g.dart';

@RestApi(baseUrl: "https://digital-wallet-93c4ba68a41d.herokuapp.com/api/v1")
abstract class D3VotionApi {
  factory D3VotionApi(Dio dio, {String baseUrl}) = _D3VotionApi;

  @GET("/d3votion")
  Future<D3VotionEntity> getD3Votion(@Query("word") String word);
}
