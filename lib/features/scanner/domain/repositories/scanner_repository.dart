// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/scanner_entity.dart';

abstract class ScannerRepository {
  /// Get scanner by id
  Future<Either<Failure, ScannerEntity>> getScanner(String id);

  /// Get all scanners
  Future<Either<Failure, List<ScannerEntity>>> getAllScanners();

  /// Create a new scanner
  Future<Either<Failure, ScannerEntity>> createScanner(ScannerEntity entity);

  /// Update scanner
  Future<Either<Failure, ScannerEntity>> updateScanner(ScannerEntity entity);

  /// Delete scanner
  Future<Either<Failure, void>> deleteScanner(String id);
}
