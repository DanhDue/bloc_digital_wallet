// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:dartz/dartz.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@injectable
class GetAvailableLanguagesUseCase {
  final SettingsRepository _repository;

  GetAvailableLanguagesUseCase(this._repository);

  Future<Either<Failure, List<AvailableLanguage>>> call() async {
    return _repository.getAvailableLanguages();
  }
}
