// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'package:app_platform/platform.dart';
import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/domain/entities/language_sync_status.dart';
export 'package:settings/domain/entities/language_sync_status.dart';
import 'package:settings/domain/usecases/check_language_cached_usecase.dart';
import 'package:settings/domain/usecases/get_dynamic_localization_usecase.dart';
import 'package:settings/domain/usecases/update_user_language_usecase.dart';

@injectable
class ChangeLanguageUseCase {
  final CheckLanguageCachedUseCase _checkLanguageCachedUseCase;
  final GetDynamicLocalizationUseCase _getDynamicLocalizationUseCase;
  final UpdateUserLanguageUseCase _updateUserLanguageUseCase;
  final AppEventBus? _appEventBus;

  ChangeLanguageUseCase(
    this._checkLanguageCachedUseCase,
    this._getDynamicLocalizationUseCase,
    this._updateUserLanguageUseCase, [
    this._appEventBus,
  ]);

  static String? _latestRequestedLanguageCode;

  Stream<LanguageSyncStatus> call(String languageCode) async* {
    _latestRequestedLanguageCode = languageCode;
    final currentLocale = LocalizationManager.instance.currentLocale;
    final targetLocale = LocalizationManager.instance.resolveLocale(languageCode);
    final isSameLanguage = targetLocale.languageCode == currentLocale.languageCode;

    // Same-language skip: immediately return without any emissions or network calls
    if (isSameLanguage) {
      return;
    }

    // Bundled languages (en, vi) are always treated as cached
    final isBundled = languageCode == 'en' || languageCode == 'vi';
    final isCached = isBundled || await _checkLanguageCachedUseCase(languageCode);

    if (isCached) {
      // Optimistic switch
      if (_latestRequestedLanguageCode != languageCode) return;
      await LocalizationManager.instance.setLocaleFromCode(languageCode);
      _appEventBus?.publish(AppLanguageChanged(languageCode: languageCode));
      yield LanguageSyncStatus.cachedApplied(languageCode);

      // Silent delta check in background
      await _getDynamicLocalizationUseCase(languageCode);
      if (_latestRequestedLanguageCode != languageCode) return;
      yield LanguageSyncStatus.success(languageCode);
    } else {
      // Uncached remote OTA download
      yield LanguageSyncStatus.loading(languageCode);

      final result = await _getDynamicLocalizationUseCase(languageCode);

      // Race guard: If a newer language was requested while downloading, discard stale response
      if (_latestRequestedLanguageCode != languageCode) {
        return;
      }

      if (result.isLeft()) {
        final failure = result.swap().getOrElse(
          () => const ServerFailure(message: 'Unknown error'),
        );
        yield LanguageSyncStatus.error(languageCode, failure.message);
        return;
      }

      await LocalizationManager.instance.setLocaleFromCode(languageCode);
      _appEventBus?.publish(AppLanguageChanged(languageCode: languageCode));
      yield LanguageSyncStatus.success(languageCode);
    }

    // Persist remote user preferences only if still the active selection
    if (_latestRequestedLanguageCode == languageCode) {
      await _updateUserLanguageUseCase(languageCode);
    }
  }
}
