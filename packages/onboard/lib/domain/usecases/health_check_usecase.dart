// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:network/network.dart';
import '../repositories/onboard_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

/// Use case for performing health check on the backend service.
@injectable
class HealthCheckUseCase {
  final OnboardRepository _repository;

  HealthCheckUseCase(this._repository);

  Future<Either<Failure, BaseResponseObject<dynamic>>> call() async {
    return _repository.healthCheck();
  }
}
