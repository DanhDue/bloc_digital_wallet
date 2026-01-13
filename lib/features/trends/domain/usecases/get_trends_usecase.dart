// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trends_entity.dart';
import '../repositories/trends_repository.dart';

@injectable
class GetTrendsUseCase {
  final TrendsRepository repository;

  GetTrendsUseCase(this.repository);

  Future<Either<Failure, TrendsEntity>> call(String id) async {
    return await repository.getTrends(id);
  }
}
