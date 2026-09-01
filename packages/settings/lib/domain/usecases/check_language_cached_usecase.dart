// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:injectable/injectable.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@injectable
class CheckLanguageCachedUseCase {
  final SettingsRepository _repository;

  CheckLanguageCachedUseCase(this._repository);

  Future<bool> call(String languageCode) async {
    if (languageCode == 'en' || languageCode == 'vi') return true;
    final cachedVersionResult = await _repository.getCachedTranslationVersion(languageCode);
    return cachedVersionResult.fold((l) => false, (r) => r != null);
  }
}
