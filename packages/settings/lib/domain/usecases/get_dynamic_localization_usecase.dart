// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@injectable
class GetDynamicLocalizationUseCase {
  final SettingsRepository _repository;

  GetDynamicLocalizationUseCase(this._repository);

  Future<Either<Failure, void>> call(String languageCode) async {
    // 1. Get cached version
    final cachedVersionResult = await _repository.getCachedTranslationVersion(languageCode);
    final cachedVersion = cachedVersionResult.fold((l) => null, (r) => r);

    // 2. Fetch JSON from API with sinceVersion
    final responseOrFailure = await _repository.getLocalizationOverrides(
      languageCode,
      sinceVersion: cachedVersion,
    );

    if (responseOrFailure.isLeft()) {
      return Left(responseOrFailure.fold((l) => l, (r) => throw Exception('unreachable')));
    }

    final response = responseOrFailure.getOrElse(() => throw Exception('unreachable'));

    Map<String, dynamic> jsonMap = response.translations;
    final version = response.version;

    // 3. If the backend returns empty translations or the version matches the cached version, load from local cache
    if ((jsonMap.isEmpty || version == cachedVersion) && cachedVersion != null) {
      final cachedJsonResult = await _repository.getCachedTranslationJson(languageCode);
      jsonMap = cachedJsonResult.fold((l) => {}, (r) => r ?? {});
    } else {
      // Save new data to local cache
      await _repository.saveCachedTranslationJson(languageCode, jsonMap);
      await _repository.saveCachedTranslationVersion(languageCode, version);
    }

    // 4. Apply dynamic translations (always do this to ensure memory has it)
    await LocalizationManager.instance.applyDynamicTranslations(
      jsonMap,
      targetLanguageCode: languageCode,
    );

    return const Right(null);
  }
}
