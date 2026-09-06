// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:framework/framework.dart';
import 'package:injectable/injectable.dart';
import 'package:scanner/data/datasources/remote/scanner_client.dart';
import 'package:scanner/domain/entities/scanner_entity.dart';

@lazySingleton
class ScannerRemoteDataSource with SafeCallApiMixin {
  final ScannerClient _client;

  ScannerRemoteDataSource(this._client);

  Future<Either<Failure, ScannerEntity>> getScanner() async {
    final result = await safeApiCall(() => _client.getScanner());
    return result.map((model) => model.toEntity());
  }
}
