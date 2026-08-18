// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@injectable
class GetDynamicLocalizationUseCase {
  final SettingsRepository _repository;

  GetDynamicLocalizationUseCase(this._repository);

  Future<Either<Failure, void>> call(String languageCode, String fetchUrl) async {
    // This is called on-demand when the user selects a new language.
    // Fetch JSON from URL
    final fetchResult = await _repository.fetchTranslationJson(fetchUrl);

    if (fetchResult.isLeft()) {
      return Left(fetchResult.fold((l) => l, (r) => throw Exception('unreachable')));
    }

    final jsonMap = fetchResult.getOrElse(() => {});

    // Save to local cache
    await _repository.saveCachedTranslationJson(languageCode, jsonMap);

    // Apply dynamic translations
    LocalizationManager.instance.applyDynamicTranslations(jsonMap);

    return const Right(null);
  }
}
