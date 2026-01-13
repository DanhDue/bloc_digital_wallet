// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/trends_entity.dart';
import '../repositories/trends_repository.dart';

@injectable
class GetAllTrendssUseCase {
  final TrendsRepository repository;

  GetAllTrendssUseCase(this.repository);

  Future<Either<Failure, List<TrendsEntity>>> call() async {
    return await repository.getAllTrendss();
  }
}
