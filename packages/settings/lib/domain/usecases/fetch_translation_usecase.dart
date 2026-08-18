// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/data/models/sync/bootstrap_translation_item.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@injectable
class FetchTranslationUseCase {
  final SettingsRepository _repository;

  FetchTranslationUseCase(this._repository);

  Future<Either<Failure, void>> call(BootstrapTranslationItem item) async {
    final languageCode = item.languageCode;

    // Fetch JSON from URL
    final fetchResult = await _repository.fetchTranslationJson(
      item.mode == 'full' ? item.fullFetchUrl! : item.fetchUrl!,
    );

    if (fetchResult.isLeft()) {
      return Left(fetchResult.fold((l) => l, (r) => throw Exception('unreachable')));
    }

    final changes = fetchResult.getOrElse(() => {});

    Map<String, dynamic> mergedJson;

    if (item.mode == 'full') {
      mergedJson = changes;
    } else {
      // mode == 'delta'
      final cachedResult = await _repository.getCachedTranslationJson(languageCode);
      var cachedJson = cachedResult.getOrElse(() => null);

      if (cachedJson == null) {
        // If delta but we don\'t have a cache, we must fetch full
        final fullFetchResult = await _repository.fetchTranslationJson(item.fullFetchUrl!);
        if (fullFetchResult.isLeft()) {
          return Left(fullFetchResult.fold((l) => l, (r) => throw Exception('unreachable')));
        }
        mergedJson = fullFetchResult.getOrElse(() => {});
      } else {
        mergedJson = DeepMergeUtils.deepMerge(cachedJson, changes);
        if (item.deletedKeys != null && item.deletedKeys!.isNotEmpty) {
          mergedJson = DeepMergeUtils.deleteKeys(mergedJson, item.deletedKeys!);
        }

        // Validate checksum
        final checksum = ChecksumUtils.computeSha256(mergedJson);
        if (checksum != item.checksum) {
          // Checksum mismatch -> Delete cache and fetch full
          await _repository.deleteCachedTranslation(languageCode);
          final fullFetchResult = await _repository.fetchTranslationJson(item.fullFetchUrl!);
          if (fullFetchResult.isLeft()) {
            return Left(fullFetchResult.fold((l) => l, (r) => throw Exception('unreachable')));
          }
          mergedJson = fullFetchResult.getOrElse(() => {});
        }
      }
    }

    // Save the new merged json to cache
    await _repository.saveCachedTranslationJson(languageCode, mergedJson);

    // Update version
    await _repository.saveCachedTranslationVersion(languageCode, item.version);

    // Apply dynamic translations via LocalizationManager
    // This will be called outside, or we can inject LocalizationManager
    // The plan says: "Call LocalizationManager.applyDynamicTranslations(mergedJson) after saving."
    LocalizationManager.instance.applyDynamicTranslations(mergedJson);

    return const Right(null);
  }
}
