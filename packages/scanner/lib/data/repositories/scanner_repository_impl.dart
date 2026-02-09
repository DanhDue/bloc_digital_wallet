// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:scanner/data/datasources/remote/scanner_remote_datasource.dart';
import 'package:scanner/domain/entities/scanner_entity.dart';
import 'package:scanner/domain/repositories/scanner_repository.dart';

@LazySingleton(as: ScannerRepository)
class ScannerRepositoryImpl implements ScannerRepository {
  final ScannerRemoteDataSource _remoteDataSource;

  ScannerRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, ScannerEntity>> getScanner() {
    return _remoteDataSource.getScanner();
  }
}
