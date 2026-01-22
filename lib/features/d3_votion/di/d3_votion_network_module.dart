import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:bloc_digital_wallet/features/d3_votion/data/datasources/remote/d3_votion_api.dart';

@module
abstract class D3VotionNetworkModule {
  @lazySingleton
  D3VotionApi d3VotionApi(Dio dio) => D3VotionApi(dio);
}
