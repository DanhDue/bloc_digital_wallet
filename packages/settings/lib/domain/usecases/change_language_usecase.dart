// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/domain/usecases/check_language_cached_usecase.dart';
import 'package:settings/domain/usecases/get_dynamic_localization_usecase.dart';
import 'package:settings/domain/usecases/update_user_language_usecase.dart';

enum LanguageSyncStatus {
  loading,
  cachedApplied,
  success,
  error,
}

@injectable
class ChangeLanguageUseCase {
  final CheckLanguageCachedUseCase _checkLanguageCachedUseCase;
  final GetDynamicLocalizationUseCase _getDynamicLocalizationUseCase;
  final UpdateUserLanguageUseCase _updateUserLanguageUseCase;

  ChangeLanguageUseCase(
    this._checkLanguageCachedUseCase,
    this._getDynamicLocalizationUseCase,
    this._updateUserLanguageUseCase,
  );

  Stream<LanguageSyncStatus> call(String languageCode) async* {
    final currentLocale = LocalizationManager.instance.currentLocale;
    final targetLocale = LocalizationManager.instance.resolveLocale(languageCode);
    final isSameLanguage = targetLocale == currentLocale;

    if (isSameLanguage) {
      // Delta update only, skip Static locale setting and backend updates
      final result = await _getDynamicLocalizationUseCase(languageCode);
      if (result.isLeft()) {
        yield LanguageSyncStatus.error;
      }
      return;
    }

    final isCached = await _checkLanguageCachedUseCase(languageCode);
    if (isCached) {
      // Optimistic UI
      await LocalizationManager.instance.setLocaleFromCode(languageCode);
      yield LanguageSyncStatus.cachedApplied;
    } else {
      yield LanguageSyncStatus.loading;
    }

    final result = await _getDynamicLocalizationUseCase(languageCode);
    if (result.isLeft()) {
      yield LanguageSyncStatus.error;
      // Revert if it was NOT cached
      if (!isCached) {
        // We can't revert perfectly without knowing the exact previous locale object, but we just leave it in previous state
        // Actually, if it wasn't cached, we didn't call setLocaleFromCode yet. So no revert needed.
      }
    } else {
      // It might have been updated by GetDynamicLocalizationUseCase
      // Note: GetDynamicLocalizationUseCase already calls `setLocale` internally when it applies new data
      if (!isCached) {
        await LocalizationManager.instance.setLocaleFromCode(languageCode);
      }
      yield LanguageSyncStatus.success;
    }

    // Always update backend preferences, even if delta fetch failed, as long as it's a new language click
    await _updateUserLanguageUseCase(languageCode);
  }
}
