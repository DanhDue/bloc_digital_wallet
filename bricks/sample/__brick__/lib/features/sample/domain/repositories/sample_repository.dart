// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/sample_entity.dart';

abstract class SampleRepository {
  /// Get {{feature_name.lowerCase()}} by id
  Future<Either<Failure, SampleEntity>> getSample(String id);
  
  /// Get all {{feature_name.lowerCase()}}s
  Future<Either<Failure, List<SampleEntity>>> getAllSamples();
  
  /// Create a new {{feature_name.lowerCase()}}
  Future<Either<Failure, SampleEntity>> createSample(SampleEntity entity);
  
  /// Update {{feature_name.lowerCase()}}
  Future<Either<Failure, SampleEntity>> updateSample(SampleEntity entity);
  
  /// Delete {{feature_name.lowerCase()}}
  Future<Either<Failure, void>> deleteSample(String id);
}
