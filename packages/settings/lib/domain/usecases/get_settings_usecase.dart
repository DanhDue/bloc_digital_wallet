// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/domain/entities/settings_entity.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@injectable
class GetSettingsUseCase {
  final SettingsRepository _repository;

  GetSettingsUseCase(this._repository);

  Future<Either<Failure, SettingsEntity>> call() {
    return _repository.getSettings();
  }
}
