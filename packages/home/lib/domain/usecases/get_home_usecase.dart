// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:home/domain/entities/home_entity.dart';
import 'package:home/domain/repositories/home_repository.dart';

@injectable
class GetHomeUseCase {
  final HomeRepository _repository;

  GetHomeUseCase(this._repository);

  Future<Either<Failure, HomeEntity>> call() {
    return _repository.getHome();
  }
}
