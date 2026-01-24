import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../models/d3_votion_res_object.dart';

part 'd3_votion_client.g.dart';

@RestApi()
abstract class D3VotionClient {
  factory D3VotionClient(Dio dio, {String baseUrl}) = _D3VotionClient;

  @GET('')
  Future<D3VotionResObject> getD3Votion(@Query('word') String word);
}
