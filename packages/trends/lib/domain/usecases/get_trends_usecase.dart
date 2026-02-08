// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:trends/domain/entities/trends_entity.dart';
import 'package:trends/domain/repositories/trends_repository.dart';

@injectable
class GetTrendsUseCase {
  final TrendsRepository _repository;

  GetTrendsUseCase(this._repository);

  Future<Either<Failure, TrendsEntity>> call() {
    return _repository.getTrends();
  }
}
