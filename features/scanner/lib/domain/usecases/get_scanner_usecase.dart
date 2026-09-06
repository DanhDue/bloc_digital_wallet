// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:scanner/domain/entities/scanner_entity.dart';
import 'package:scanner/domain/repositories/scanner_repository.dart';

@injectable
class GetScannerUseCase {
  final ScannerRepository _repository;

  GetScannerUseCase(this._repository);

  Future<Either<Failure, ScannerEntity>> call() {
    return _repository.getScanner();
  }
}
