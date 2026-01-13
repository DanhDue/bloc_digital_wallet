// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/sample_entity.dart';
import '../repositories/sample_repository.dart';

@injectable
class GetSampleUseCase {
  final SampleRepository repository;

  GetSampleUseCase(this.repository);

  Future<Either<Failure, SampleEntity>> call(String id) async {
    return await repository.getSample(id);
  }
}
