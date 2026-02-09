// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

@injectable
class GetAllHomesUseCase {
  final HomeRepository _homeRepository;

  GetAllHomesUseCase(this._homeRepository);

  Future<Either<Failure, List<HomeEntity>>> call() {
    return _homeRepository.getAllHomes();
  }
}
