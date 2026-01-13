// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trends_entity.dart';

abstract class TrendsRepository {
  /// Get trends by id
  Future<Either<Failure, TrendsEntity>> getTrends(String id);

  /// Get all trendss
  Future<Either<Failure, List<TrendsEntity>>> getAllTrendss();

  /// Create a new trends
  Future<Either<Failure, TrendsEntity>> createTrends(TrendsEntity entity);

  /// Update trends
  Future<Either<Failure, TrendsEntity>> updateTrends(TrendsEntity entity);

  /// Delete trends
  Future<Either<Failure, void>> deleteTrends(String id);
}
