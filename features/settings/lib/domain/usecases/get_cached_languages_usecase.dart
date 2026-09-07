// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/domain/entities/supported_language.dart';
import 'package:settings/domain/repositories/settings_repository.dart';
import 'package:settings/domain/usecases/check_language_cached_usecase.dart';

@injectable
class GetCachedLanguagesUseCase {
  final SettingsRepository _repository;
  final CheckLanguageCachedUseCase _checkLanguageCachedUseCase;

  static const List<SupportedLanguage> defaultBundledLanguages = [
    SupportedLanguage(
      languageCode: 'en',
      languageName: 'English',
      isDefault: true,
      isActive: true,
      isCached: true,
    ),
    SupportedLanguage(
      languageCode: 'vi',
      languageName: 'Tiếng Việt',
      isDefault: false,
      isActive: true,
      isCached: true,
    ),
  ];

  GetCachedLanguagesUseCase(this._repository, this._checkLanguageCachedUseCase);

  Future<Either<Failure, List<SupportedLanguage>>> call() async {
    final result = await _repository.getAvailableLanguages();

    return result.fold((failure) => const Right(defaultBundledLanguages), (languages) async {
      if (languages.isEmpty) {
        return const Right(defaultBundledLanguages);
      }

      final supportedList = <SupportedLanguage>[];
      for (final lang in languages) {
        final isCached = (lang.languageCode == 'en' || lang.languageCode == 'vi')
            ? true
            : await _checkLanguageCachedUseCase(lang.languageCode);

        supportedList.add(
          SupportedLanguage(
            languageCode: lang.languageCode,
            languageName: lang.languageName,
            isDefault: lang.isDefault,
            isActive: lang.isActive,
            isCached: isCached,
          ),
        );
      }

      return Right(supportedList);
    });
  }
}
