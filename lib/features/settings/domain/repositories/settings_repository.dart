// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/settings_entity.dart';

abstract class SettingsRepository {
  /// Get settings (List)
  Future<Either<Failure, List<SettingsEntity>>> getSettingss();
}
