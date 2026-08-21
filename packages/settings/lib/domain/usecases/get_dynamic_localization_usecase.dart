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

    // 2. Get cached JSON to compute checksum
    final cachedJsonResultForChecksum = await _repository.getCachedTranslationJson(languageCode);
    final cachedJsonForChecksum = cachedJsonResultForChecksum.fold((l) => null, (r) => r);
    String? checksum;
    if (cachedJsonForChecksum != null) {
      checksum = ChecksumUtils.computeSha256(cachedJsonForChecksum);
    }

    // 3. Fetch localization overrides (full or delta)
    final responseOrFailure = await _repository.getLocalizationOverrides(
      languageCode,
      sinceVersion: cachedVersion,
      eTag: checksum != null ? '"$checksum"' : null,
    );

    if (responseOrFailure.isLeft()) {
      final failure = responseOrFailure.fold((l) => l, (r) => throw Exception('unreachable'));
      if (failure is ServerFailure && failure.code == 304) {
        // 304 Not Modified: Cache is up to date, load from cache and apply
        final cachedJsonResult = await _repository.getCachedTranslationJson(languageCode);
        final jsonMap = cachedJsonResult.fold((l) => <String, dynamic>{}, (r) => r ?? <String, dynamic>{});
        await LocalizationManager.instance.applyDynamicTranslations(
          jsonMap,
          targetLanguageCode: languageCode,
        );
        return const Right(null);
      }
      return Left(failure);
    }

    final response = responseOrFailure.getOrElse(() => throw Exception('unreachable'));

    Map<String, dynamic> jsonMap = response.translations;
    final version = response.version;

    // 4. If the backend returns empty translations or the version matches the cached version, load from local cache
    if ((jsonMap.isEmpty || version == cachedVersion) && cachedVersion != null) {
      final cachedJsonResult = await _repository.getCachedTranslationJson(languageCode);
      jsonMap = cachedJsonResult.fold((l) => <String, dynamic>{}, (r) => r ?? <String, dynamic>{});
    } else {
      // Save new data to local cache
      await _repository.saveCachedTranslationJson(languageCode, jsonMap);
      await _repository.saveCachedTranslationVersion(languageCode, version);
    }

    // 5. Apply dynamic translations (always do this to ensure memory has it)
    await LocalizationManager.instance.applyDynamicTranslations(
      jsonMap,
      targetLanguageCode: languageCode,
    );

    return const Right(null);
  }
}
