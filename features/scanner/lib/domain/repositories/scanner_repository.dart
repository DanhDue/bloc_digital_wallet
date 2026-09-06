// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:scanner/domain/entities/scanner_entity.dart';

abstract class ScannerRepository {
  Future<Either<Failure, ScannerEntity>> getScanner();
}
