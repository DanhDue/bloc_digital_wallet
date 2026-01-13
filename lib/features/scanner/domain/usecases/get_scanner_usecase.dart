// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/scanner_entity.dart';
import '../repositories/scanner_repository.dart';

@injectable
class GetScannerUseCase {
  final ScannerRepository repository;

  GetScannerUseCase(this.repository);

  Future<Either<Failure, ScannerEntity>> call(String id) async {
    return await repository.getScanner(id);
  }
}
