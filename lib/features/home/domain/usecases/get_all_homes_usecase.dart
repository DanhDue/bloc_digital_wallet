// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

@injectable
class GetAllHomesUseCase {
  final HomeRepository repository;

  GetAllHomesUseCase(this.repository);

  Future<Either<Failure, List<HomeEntity>>> call() async {
    return await repository.getAllHomes();
  }
}
