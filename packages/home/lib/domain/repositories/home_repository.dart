// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:home/domain/entities/home_entity.dart';

import 'package:dartz/dartz.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeEntity>> getHome(String id);
  Future<Either<Failure, List<HomeEntity>>> getAllHomes();
}
