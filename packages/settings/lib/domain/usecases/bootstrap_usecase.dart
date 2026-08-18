// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/data/models/sync/cached_translation_item.dart';
import 'package:settings/data/models/sync/sync_bootstrap_request.dart';
import 'package:settings/data/models/sync/sync_bootstrap_response.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@injectable
class BootstrapUseCase {
  final SettingsRepository _repository;

  BootstrapUseCase(this._repository);

  Future<Either<Failure, SyncBootstrapResponse>> call() async {
    // Collect all cached translations from local storage
    final List<CachedTranslationItem> cachedTranslations = [];

    // We get all cached language codes
    final languageCodesResult = await _repository.getAllCachedLanguageCodes();

    if (languageCodesResult.isRight()) {
      final languageCodes = languageCodesResult.getOrElse(() => []);
      for (final code in languageCodes) {
        final versionResult = await _repository.getCachedTranslationVersion(code);
        if (versionResult.isRight()) {
          final version = versionResult.getOrElse(() => null);
          if (version != null) {
            cachedTranslations.add(CachedTranslationItem(resourceId: code, version: version));
          }
        }
      }
    }

    // Create the bootstrap request
    final request = SyncBootstrapRequest(cachedTranslations: cachedTranslations);

    // Call the repository to perform the bootstrap
    return _repository.bootstrap(request);
  }
}
