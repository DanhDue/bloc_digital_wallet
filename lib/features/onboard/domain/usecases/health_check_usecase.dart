// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:bloc_digital_wallet/core/errors/failures.dart';
import 'package:bloc_digital_wallet/core/network/base_response_object.dart';
import 'package:bloc_digital_wallet/features/onboard/domain/repositories/onboard_repository.dart';
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
