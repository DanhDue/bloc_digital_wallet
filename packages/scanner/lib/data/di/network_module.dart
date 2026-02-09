// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:network/network.dart';
import 'package:scanner/data/datasources/remote/scanner_client.dart';

@module
abstract class ScannerNetworkModule {
  @lazySingleton
  ScannerClient scannerClient(Dio dio) =>
      ScannerClient(dio, baseUrl: AppUri.scanner.buildAppUri());
}
