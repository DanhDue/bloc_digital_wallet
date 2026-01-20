// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/core/network/base_response_object.dart';
import 'package:bloc_digital_wallet/features/onboard/data/datasources/onboard_remote_datasource.dart';
import 'package:bloc_digital_wallet/features/onboard/domain/repositories/onboard_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// ============================================================================
/// Onboard Repository Implementation
/// ============================================================================
/// Repository implementations handle data source orchestration and error handling.
/// They implement the domain repository interface.
/// ============================================================================

@LazySingleton(as: OnboardRepository)
class OnboardRepositoryImpl implements OnboardRepository {
  final OnboardRemoteDataSource _remoteDataSource;

  OnboardRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, BaseResponseObject<dynamic>>> healthCheck() =>
      _remoteDataSource.healthCheck();
}
