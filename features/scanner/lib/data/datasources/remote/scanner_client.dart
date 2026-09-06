// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:scanner/data/models/scanner_model.dart';

part 'scanner_client.g.dart';

@RestApi()
abstract class ScannerClient {
  factory ScannerClient(Dio dio, {String? baseUrl}) = _ScannerClient;

  @GET('/scanner')
  Future<ScannerModel> getScanner();
}
