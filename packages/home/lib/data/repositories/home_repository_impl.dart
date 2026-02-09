// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:home/domain/entities/home_entity.dart';
import 'package:home/domain/repositories/home_repository.dart';
import 'package:home/data/datasources/home_remote_datasource.dart';

@Injectable(as: HomeRepository)
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;

  HomeRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, HomeEntity>> getHome(String id) async {
    try {
      final model = await _remoteDataSource.getHome(id);
      return Right(model.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<HomeEntity>>> getAllHomes() async {
    try {
      final models = await _remoteDataSource.getAllHomes();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
