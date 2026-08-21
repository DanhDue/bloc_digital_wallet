// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/data/models/sync/bootstrap_translation_item.dart';
import 'package:settings/data/models/sync/translation_override_response.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@injectable
class FetchTranslationUseCase {
  final SettingsRepository _repository;

  FetchTranslationUseCase(this._repository);

  Future<Either<Failure, void>> call(BootstrapTranslationItem item) async {
    final languageCode = item.resourceId;

    String? sinceVersion;
    Map<String, dynamic>? cachedJson;

    if (item.mode == 'delta') {
      final cachedVersionResult = await _repository.getCachedTranslationVersion(languageCode);
      sinceVersion = cachedVersionResult.getOrElse(() => null);

      final cachedJsonResult = await _repository.getCachedTranslationJson(languageCode);
      cachedJson = cachedJsonResult.getOrElse(() => null);

      // If we don't have cached JSON or version, we must do a full fetch (no sinceVersion)
      if (cachedJson == null || sinceVersion == null) {
        sinceVersion = null;
        cachedJson = null;
      }
    }

    String? checksum;
    if (cachedJson != null) {
      checksum = ChecksumUtils.computeSha256(cachedJson);
    }

    // Fetch JSON overrides (delta or full)
    final fetchResult = await _repository.getLocalizationOverrides(
      languageCode,
      sinceVersion: sinceVersion,
      eTag: checksum != null ? '"$checksum"' : null,
    );

    if (fetchResult.isLeft()) {
      final failure = fetchResult.fold((l) => l, (r) => throw Exception('unreachable'));
      if (failure is ServerFailure && failure.code == 304) {
        // 304 Not Modified: Cache is up to date, nothing to do.
        return const Right(null);
      }
      return Left(failure);
    }

    final overrideData = fetchResult.getOrElse(
      () => const TranslationOverrideData(version: '1.0.0', translations: {}),
    );
    final changes = overrideData.translations;

    Map<String, dynamic> mergedJson;

    if (item.mode == 'full' || cachedJson == null || sinceVersion == null) {
      mergedJson = changes;
    } else {
      // mode == 'delta' AND we have cache
      mergedJson = DeepMergeUtils.deepMerge(cachedJson, changes);
      if (item.deletedKeys != null && item.deletedKeys!.isNotEmpty) {
        mergedJson = DeepMergeUtils.deleteKeys(mergedJson, item.deletedKeys!);
      }

      // Validate checksum if provided
      final computedChecksum = ChecksumUtils.computeSha256(mergedJson);
      if (item.checksum != null && computedChecksum != item.checksum) {
        // Checksum mismatch -> Delete cache and fallback (fetch full)
        await _repository.deleteCachedTranslation(languageCode);

        // Fetch full JSON because delta merge failed checksum
        final fullFetchResult = await _repository.getLocalizationOverrides(languageCode);
        if (fullFetchResult.isLeft()) {
          return Left(fullFetchResult.fold((l) => l, (r) => throw Exception('unreachable')));
        }
        mergedJson = fullFetchResult
            .getOrElse(() => const TranslationOverrideData(version: '1.0.0', translations: {}))
            .translations;
      }
    }

    // Save the new merged json to cache
    await _repository.saveCachedTranslationJson(languageCode, mergedJson);

    // Update version
    await _repository.saveCachedTranslationVersion(languageCode, item.latestVersion);

    // Apply dynamic translations via LocalizationManager
    // This will be called outside, or we can inject LocalizationManager
    // The plan says: "Call LocalizationManager.applyDynamicTranslations(mergedJson) after saving."
    LocalizationManager.instance.applyDynamicTranslations(
      mergedJson,
      targetLanguageCode: languageCode,
    );

    return const Right(null);
  }
}
