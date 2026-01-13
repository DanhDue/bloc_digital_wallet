// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/settings_entity.dart';
import '../repositories/settings_repository.dart';

/// Use case for Profile feature in Settings module
@injectable
class GetProfileUseCase {
  final SettingsRepository repository;

  GetProfileUseCase(this.repository);

  /// Execute the Profile use case
  ///
  /// Returns:
  ///   - Either<Failure, List<SettingsEntity>> - Result of the operation
  Future<Either<Failure, List<SettingsEntity>>> call() async {
    // Assuming the subfeature works with the module's main entity list.
    // If entity_name differs from module_name, manual adjustment may be required.
    return await repository.getSettingss() as Future<Either<Failure, List<SettingsEntity>>>;
  }
}
