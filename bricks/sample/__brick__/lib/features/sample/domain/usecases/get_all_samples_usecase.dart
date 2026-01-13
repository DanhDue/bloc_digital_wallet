// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/sample_entity.dart';
import '../repositories/sample_repository.dart';

@injectable
class GetAllSamplesUseCase {
  final SampleRepository repository;

  GetAllSamplesUseCase(this.repository);

  Future<Either<Failure, List<SampleEntity>>> call() async {
    return await repository.getAllSamples();
  }
}
