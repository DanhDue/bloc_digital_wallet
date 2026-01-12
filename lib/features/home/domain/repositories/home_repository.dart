// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/home_entity.dart';

abstract class HomeRepository {
  /// Get home by id
  Future<Either<Failure, HomeEntity>> getHome(String id);

  /// Get all homes
  Future<Either<Failure, List<HomeEntity>>> getAllHomes();

  /// Create a new home
  Future<Either<Failure, HomeEntity>> createHome(HomeEntity entity);

  /// Update home
  Future<Either<Failure, HomeEntity>> updateHome(HomeEntity entity);

  /// Delete home
  Future<Either<Failure, void>> deleteHome(String id);
}
