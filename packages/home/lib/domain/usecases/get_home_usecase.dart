// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:home/domain/entities/home_entity.dart';
import 'package:home/domain/repositories/home_repository.dart';

@injectable
class GetHomeUseCase {
  final HomeRepository _homeRepository;

  GetHomeUseCase(this._homeRepository);

  Future<Either<Failure, HomeEntity>> call(String params) {
    return _homeRepository.getHome(params);
  }
}
