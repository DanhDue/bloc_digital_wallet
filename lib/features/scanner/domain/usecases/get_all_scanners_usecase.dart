// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/scanner_entity.dart';
import '../repositories/scanner_repository.dart';

@injectable
class GetAllScannersUseCase {
  final ScannerRepository repository;

  GetAllScannersUseCase(this.repository);

  Future<Either<Failure, List<ScannerEntity>>> call() async {
    return await repository.getAllScanners();
  }
}
