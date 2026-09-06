// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@injectable
class LoadBundledFallbackUseCase {
  final SettingsRepository _repository;

  LoadBundledFallbackUseCase(this._repository);

  Future<Either<Failure, Map<String, dynamic>>> call(String languageCode) async {
    return _repository.loadBundledFallback(languageCode);
  }
}
