// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

@injectable
class GetSettingsUseCase {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  /// Get all settingss
  Future<Either<Failure, List<SettingsEntity>>> call() async {
    return await repository.getSettingss();
  }
}
