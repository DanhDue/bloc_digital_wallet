# Flutter Settings Language Switch & Dynamic OTA Localization Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement tri-platform parity for language switching and Over-The-Air (OTA) dynamic localization on Flutter with instant Frame-0 cache loading, silent background bootstrap, optimistic switching for bundled (`en`, `vi`) & cached languages, and modal loading OTA downloads for uncached remote languages with error rollback.

**Architecture:** Clean Architecture + MVI pattern across multi-module Flutter monorepo. Domain use cases orchestrate state streams (`LanguageSyncStatus`), data sources manage atomic JSON file caching and asset fallbacks, and `SettingsBloc` handles instant UI hydration with background delta syncs.

**Tech Stack:** Flutter (Dart 3.x), flutter_bloc, get_it / injectable, slang / slang_flutter, dartz (Either), shared_preferences, mocktail / flutter_test.

**Spec:** [2026-09-06-settings-language-sync-design.md](file:///Users/danhdue/AllProjects/digital_wallet/bloc_digital_wallet/.worktrees/flutter_super_app_template/docs/superpowers/specs/2026-09-06-settings-language-sync-design.md)

## Global Constraints

- **Strict Bundled Boundary:** Only English (`en`) and Vietnamese (`vi`) are default bundled languages during development. All other languages (e.g. Japanese `ja`, Korean `ko`, Chinese `zh`) are delivered solely Over-The-Air (OTA) from the backend.
- **Instant Frame-0 UI:** Opening the Settings screen must never trigger a modal `LoadingDialog`; it must immediately render cached or default bundled languages (`en`, `vi`).
- **Same-Language Skip:** Selecting the currently active language immediately dismisses the bottom sheet without network requests or state emissions.
- **Zero Analyzer Issues:** Must pass `melos run analyze` with 0 warnings/errors before every commit.
- **Monorepo Boundaries:** No cross-feature dependencies between `features/settings` and `features/scanner`; core utilities reside in `packages/core`.

---

### Task 1: Domain Entities (`SupportedLanguage` & `LanguageSyncStatus`)

**Files:**
- Create: `features/settings/lib/domain/entities/supported_language.dart`
- Create: `features/settings/lib/domain/entities/language_sync_status.dart`
- Modify: `features/settings/lib/settings.dart`
- Test: `features/settings/test/domain/entities/supported_language_test.dart`
- Test: `features/settings/test/domain/entities/language_sync_status_test.dart`

**Interfaces:**
- Produces:
  - `class SupportedLanguage extends Equatable { final String languageCode; final String languageName; final String? version; final bool isDefault; final bool isActive; final bool isCached; ... }`
  - `sealed class LanguageSyncStatus extends Equatable { const factory LanguageSyncStatus.idle(); const factory LanguageSyncStatus.loading(String languageCode); const factory LanguageSyncStatus.cachedApplied(String languageCode); const factory LanguageSyncStatus.success(String languageCode); const factory LanguageSyncStatus.error(String languageCode, String message); ... }`

- [ ] **Step 1: Write the failing tests for `SupportedLanguage` and `LanguageSyncStatus`**

Create `features/settings/test/domain/entities/supported_language_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:settings/domain/entities/supported_language.dart';

void main() {
  group('SupportedLanguage', () {
    test('supports value equality', () {
      const lang1 = SupportedLanguage(
        languageCode: 'en',
        languageName: 'English',
        isDefault: true,
        isActive: true,
        isCached: true,
      );
      const lang2 = SupportedLanguage(
        languageCode: 'en',
        languageName: 'English',
        isDefault: true,
        isActive: true,
        isCached: true,
      );

      expect(lang1, equals(lang2));
      expect(lang1.props, equals(['en', 'English', null, true, true, true]));
    });

    test('default property values', () {
      const lang = SupportedLanguage(
        languageCode: 'ja',
        languageName: 'Japanese',
      );

      expect(lang.isDefault, isFalse);
      expect(lang.isActive, isTrue);
      expect(lang.isCached, isFalse);
      expect(lang.version, isNull);
    });
  });
}
```

Create `features/settings/test/domain/entities/language_sync_status_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:settings/domain/entities/language_sync_status.dart';

void main() {
  group('LanguageSyncStatus', () {
    test('subclasses support value equality', () {
      expect(
        const LanguageSyncStatus.idle(),
        equals(const LanguageSyncStatus.idle()),
      );
      expect(
        const LanguageSyncStatus.loading('ja'),
        equals(const LanguageSyncStatus.loading('ja')),
      );
      expect(
        const LanguageSyncStatus.cachedApplied('vi'),
        equals(const LanguageSyncStatus.cachedApplied('vi')),
      );
      expect(
        const LanguageSyncStatus.success('en'),
        equals(const LanguageSyncStatus.success('en')),
      );
      expect(
        const LanguageSyncStatus.error('ko', 'network_failed'),
        equals(const LanguageSyncStatus.error('ko', 'network_failed')),
      );
    });

    test('pattern matching exhaustiveness', () {
      const LanguageSyncStatus status = LanguageSyncStatus.loading('ja');
      final result = switch (status) {
        LanguageSyncIdle() => 'idle',
        LanguageSyncLoading(:final languageCode) => 'loading_$languageCode',
        LanguageSyncCachedApplied(:final languageCode) => 'cached_$languageCode',
        LanguageSyncSuccess(:final languageCode) => 'success_$languageCode',
        LanguageSyncError(:final languageCode, :final message) => 'error_${languageCode}_$message',
      };
      expect(result, equals('loading_ja'));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
fvm flutter test features/settings/test/domain/entities/supported_language_test.dart features/settings/test/domain/entities/language_sync_status_test.dart
```
Expected: FAIL (files do not exist yet)

- [ ] **Step 3: Write minimal implementation**

Create `features/settings/lib/domain/entities/supported_language.dart`:
```dart
// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

class SupportedLanguage extends Equatable {
  final String languageCode;
  final String languageName;
  final String? version;
  final bool isDefault;
  final bool isActive;
  final bool isCached;

  const SupportedLanguage({
    required this.languageCode,
    required this.languageName,
    this.version,
    this.isDefault = false,
    this.isActive = true,
    this.isCached = false,
  });

  SupportedLanguage copyWith({
    String? languageCode,
    String? languageName,
    String? version,
    bool? isDefault,
    bool? isActive,
    bool? isCached,
  }) {
    return SupportedLanguage(
      languageCode: languageCode ?? this.languageCode,
      languageName: languageName ?? this.languageName,
      version: version ?? this.version,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      isCached: isCached ?? this.isCached,
    );
  }

  @override
  List<Object?> get props => [
        languageCode,
        languageName,
        version,
        isDefault,
        isActive,
        isCached,
      ];
}
```

Create `features/settings/lib/domain/entities/language_sync_status.dart`:
```dart
// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:equatable/equatable.dart';

sealed class LanguageSyncStatus extends Equatable {
  const LanguageSyncStatus();

  const factory LanguageSyncStatus.idle() = LanguageSyncIdle;
  const factory LanguageSyncStatus.loading(String languageCode) = LanguageSyncLoading;
  const factory LanguageSyncStatus.cachedApplied(String languageCode) = LanguageSyncCachedApplied;
  const factory LanguageSyncStatus.success(String languageCode) = LanguageSyncSuccess;
  const factory LanguageSyncStatus.error(String languageCode, String message) = LanguageSyncError;
}

class LanguageSyncIdle extends LanguageSyncStatus {
  const LanguageSyncIdle();

  @override
  List<Object?> get props => [];
}

class LanguageSyncLoading extends LanguageSyncStatus {
  final String languageCode;
  const LanguageSyncLoading(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LanguageSyncCachedApplied extends LanguageSyncStatus {
  final String languageCode;
  const LanguageSyncCachedApplied(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LanguageSyncSuccess extends LanguageSyncStatus {
  final String languageCode;
  const LanguageSyncSuccess(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class LanguageSyncError extends LanguageSyncStatus {
  final String languageCode;
  final String message;
  const LanguageSyncError(this.languageCode, this.message);

  @override
  List<Object?> get props => [languageCode, message];
}
```

Export both in `features/settings/lib/settings.dart`.

- [ ] **Step 4: Run tests to verify they pass**

Run:
```bash
fvm flutter test features/settings/test/domain/entities/supported_language_test.dart features/settings/test/domain/entities/language_sync_status_test.dart
```
Expected: PASS (All tests passed!)

- [ ] **Step 5: Commit**

```bash
git add features/settings/lib/domain/entities/ features/settings/test/domain/entities/ features/settings/lib/settings.dart
git commit -m "feat(settings): add SupportedLanguage entity and LanguageSyncStatus sealed hierarchy"
```

---

### Task 2: Instant Frame-0 Domain Use Case (`GetCachedLanguagesUseCase`)

**Files:**
- Create: `features/settings/lib/domain/usecases/get_cached_languages_usecase.dart`
- Test: `features/settings/test/domain/usecases/get_cached_languages_usecase_test.dart`

**Interfaces:**
- Consumes: `SettingsRepository.getAvailableLanguages()`, `CheckLanguageCachedUseCase`
- Produces: `Future<Either<Failure, List<SupportedLanguage>>> call()`

- [ ] **Step 1: Write the failing test for `GetCachedLanguagesUseCase`**

Create `features/settings/test/domain/usecases/get_cached_languages_usecase_test.dart`:
```dart
import 'package:core/core.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/domain/entities/supported_language.dart';
import 'package:settings/domain/repositories/settings_repository.dart';
import 'package:settings/domain/usecases/check_language_cached_usecase.dart';
import 'package:settings/domain/usecases/get_cached_languages_usecase.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}
class MockCheckLanguageCachedUseCase extends Mock implements CheckLanguageCachedUseCase {}

void main() {
  late GetCachedLanguagesUseCase useCase;
  late MockSettingsRepository mockRepository;
  late MockCheckLanguageCachedUseCase mockCheckLanguageCachedUseCase;

  setUp(() {
    mockRepository = MockSettingsRepository();
    mockCheckLanguageCachedUseCase = MockCheckLanguageCachedUseCase();
    useCase = GetCachedLanguagesUseCase(mockRepository, mockCheckLanguageCachedUseCase);
  });

  group('GetCachedLanguagesUseCase', () {
    test('returns bundled default languages (en, vi) when stored cache is empty', () async {
      when(() => mockRepository.getAvailableLanguages())
          .thenAnswer((_) async => const Right([]));

      final result = await useCase();

      expect(result.isRight(), isTrue);
      final languages = result.getOrElse(() => []);
      expect(languages.length, equals(2));
      expect(languages[0].languageCode, equals('en'));
      expect(languages[0].languageName, equals('English'));
      expect(languages[0].isDefault, isTrue);
      expect(languages[0].isCached, isTrue);
      expect(languages[1].languageCode, equals('vi'));
      expect(languages[1].languageName, equals('Tiếng Việt'));
      expect(languages[1].isDefault, isFalse);
      expect(languages[1].isCached, isTrue);
    });

    test('returns bundled default languages when repository returns failure', () async {
      when(() => mockRepository.getAvailableLanguages())
          .thenAnswer((_) async => const Left(CacheFailure(message: 'Cache miss')));

      final result = await useCase();

      expect(result.isRight(), isTrue);
      final languages = result.getOrElse(() => []);
      expect(languages.length, equals(2));
      expect(languages.map((e) => e.languageCode), containsAll(['en', 'vi']));
    });

    test('maps available languages and checks cache status for remote languages', () async {
      when(() => mockRepository.getAvailableLanguages()).thenAnswer(
        (_) async => const Right([
          AvailableLanguage(languageCode: 'en', languageName: 'English', isDefault: true),
          AvailableLanguage(languageCode: 'vi', languageName: 'Tiếng Việt', isDefault: false),
          AvailableLanguage(languageCode: 'ja', languageName: 'Japanese', isDefault: false),
        ]),
      );
      when(() => mockCheckLanguageCachedUseCase('en')).thenAnswer((_) async => true);
      when(() => mockCheckLanguageCachedUseCase('vi')).thenAnswer((_) async => true);
      when(() => mockCheckLanguageCachedUseCase('ja')).thenAnswer((_) async => false);

      final result = await useCase();

      expect(result.isRight(), isTrue);
      final languages = result.getOrElse(() => []);
      expect(languages.length, equals(3));
      expect(languages.firstWhere((l) => l.languageCode == 'en').isCached, isTrue);
      expect(languages.firstWhere((l) => l.languageCode == 'vi').isCached, isTrue);
      expect(languages.firstWhere((l) => l.languageCode == 'ja').isCached, isFalse);
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
fvm flutter test features/settings/test/domain/usecases/get_cached_languages_usecase_test.dart
```
Expected: FAIL (GetCachedLanguagesUseCase does not exist)

- [ ] **Step 3: Write minimal implementation**

Create `features/settings/lib/domain/usecases/get_cached_languages_usecase.dart`:
```dart
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

  GetCachedLanguagesUseCase(
    this._repository,
    this._checkLanguageCachedUseCase,
  );

  Future<Either<Failure, List<SupportedLanguage>>> call() async {
    final result = await _repository.getAvailableLanguages();

    return result.fold(
      (failure) => const Right(defaultBundledLanguages),
      (languages) async {
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
      },
    );
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
fvm flutter test features/settings/test/domain/usecases/get_cached_languages_usecase_test.dart
```
Expected: PASS (All tests passed!)

- [ ] **Step 5: Commit**

```bash
git add features/settings/lib/domain/usecases/get_cached_languages_usecase.dart features/settings/test/domain/usecases/get_cached_languages_usecase_test.dart
git commit -m "feat(settings): add GetCachedLanguagesUseCase with bundled en and vi defaults"
```

---

### Task 3: Data Layer Asset Paths & Cache Registration

**Files:**
- Modify: `features/settings/lib/data/datasources/local/settings_local_datasource_impl.dart:148-176`
- Test: `features/settings/test/data/datasources/local/settings_local_datasource_impl_test.dart`

**Interfaces:**
- Consumes: AssetBundle / rootBundle, SharedPreferences
- Produces: `loadBundledFallback(String languageCode)`, `isLanguageCached(String languageCode)`

- [ ] **Step 1: Write test verifying bundled fallback paths and cached language tracking**

Check/create test in `features/settings/test/data/datasources/local/settings_local_datasource_impl_test.dart`:
```dart
import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings/data/datasources/local/settings_local_datasource_impl.dart';

void main() {
  late SettingsLocalDataSourceImpl dataSource;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    dataSource = SettingsLocalDataSourceImpl(prefs);
  });

  group('SettingsLocalDataSourceImpl', () {
    test('getAllCachedLanguageCodes returns empty list initially', () async {
      final codes = await dataSource.getAllCachedLanguageCodes();
      expect(codes, isEmpty);
    });

    test('getAvailableLanguages falls back gracefully if json is malformed', () async {
      await prefs.setString('available_languages', 'not-a-json');
      final langs = await dataSource.getAvailableLanguages();
      expect(langs, isEmpty);
    });
  });
}
```

- [ ] **Step 2: Run test to verify current state**

Run:
```bash
fvm flutter test features/settings/test/data/datasources/local/settings_local_datasource_impl_test.dart
```
Expected: PASS

- [ ] **Step 3: Update `loadBundledFallback` candidate paths in `settings_local_datasource_impl.dart`**

Modify `features/settings/lib/data/datasources/local/settings_local_datasource_impl.dart`:
```dart
  @override
  Future<Map<String, dynamic>> loadBundledFallback(String languageCode) async {
    final Map<String, dynamic> combinedJson = {};

    final candidatePaths = [
      'assets/locales/$languageCode.i18n.json',
      'packages/core/assets/locales/$languageCode.i18n.json',
      'packages/scanner/assets/locales/$languageCode.i18n.json',
      'packages/settings/assets/locales/$languageCode.i18n.json',
      'features/scanner/assets/locales/$languageCode.i18n.json',
      'features/settings/assets/locales/$languageCode.i18n.json',
    ];

    for (final path in candidatePaths) {
      try {
        final content = await rootBundle.loadString(path);
        final jsonMap = jsonDecode(content) as Map<String, dynamic>;
        combinedJson.addAll(jsonMap);
      } catch (_) {
        // Continue checking fallback candidate paths
      }
    }

    return combinedJson;
  }
```

Also, in `saveCachedTranslationJson`:
```dart
    final codes = await getAllCachedLanguageCodes();
    if (!codes.contains(languageCode)) {
      codes.add(languageCode);
      await _sharedPreferences.setStringList(_cachedLanguageCodesKey, codes);
    }
```

- [ ] **Step 4: Run test to verify passes**

Run:
```bash
fvm flutter test features/settings/test/data/datasources/local/settings_local_datasource_impl_test.dart
```
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add features/settings/lib/data/datasources/local/settings_local_datasource_impl.dart features/settings/test/data/datasources/local/settings_local_datasource_impl_test.dart
git commit -m "fix(settings): support features/ path fallbacks and atomic cache tracking"
```

---

### Task 4: Reactive Stream Orchestration (`ChangeLanguageUseCase`)

**Files:**
- Modify: `features/settings/lib/domain/usecases/change_language_usecase.dart`
- Modify: `features/settings/test/domain/usecases/change_language_usecase_test.dart`

**Interfaces:**
- Consumes: `CheckLanguageCachedUseCase`, `GetDynamicLocalizationUseCase`, `UpdateUserLanguageUseCase`, `LocalizationManager`
- Produces: `Stream<LanguageSyncStatus> call(String languageCode)`

- [ ] **Step 1: Write the updated unit tests for `ChangeLanguageUseCase`**

Modify `features/settings/test/domain/usecases/change_language_usecase_test.dart` to use the `LanguageSyncStatus` sealed class:
```dart
// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart' hide test;
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/d3nexus_logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:settings/domain/entities/language_sync_status.dart';
import 'package:settings/domain/usecases/change_language_usecase.dart';
import 'package:settings/domain/usecases/check_language_cached_usecase.dart';
import 'package:settings/domain/usecases/get_dynamic_localization_usecase.dart';
import 'package:settings/domain/usecases/update_user_language_usecase.dart';

class MockCheckLanguageCachedUseCase extends Mock implements CheckLanguageCachedUseCase {}
class MockGetDynamicLocalizationUseCase extends Mock implements GetDynamicLocalizationUseCase {}
class MockUpdateUserLanguageUseCase extends Mock implements UpdateUserLanguageUseCase {}

void main() {
  late ChangeLanguageUseCase usecase;
  late MockCheckLanguageCachedUseCase mockCheckLanguageCachedUseCase;
  late MockGetDynamicLocalizationUseCase mockGetDynamicLocalizationUseCase;
  late MockUpdateUserLanguageUseCase mockUpdateUserLanguageUseCase;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    D3NexusLogger.initialize(LogManagerImpl());

    mockCheckLanguageCachedUseCase = MockCheckLanguageCachedUseCase();
    mockGetDynamicLocalizationUseCase = MockGetDynamicLocalizationUseCase();
    mockUpdateUserLanguageUseCase = MockUpdateUserLanguageUseCase();

    usecase = ChangeLanguageUseCase(
      mockCheckLanguageCachedUseCase,
      mockGetDynamicLocalizationUseCase,
      mockUpdateUserLanguageUseCase,
    );

    LocaleSettings.useDeviceLocale();
    await LocalizationManager.instance.setLocaleFromCode('en');
  });

  group('ChangeLanguageUseCase', () {
    test('Scenario 1: Same Language Selection - Skips silently without emissions', () async {
      final stream = usecase('en');

      await expectLater(stream, emitsDone);

      verifyNever(() => mockUpdateUserLanguageUseCase(any()));
      verifyNever(() => mockGetDynamicLocalizationUseCase(any()));
    });

    test('Scenario 2: Optimistic switch for bundled or cached language (vi)', () async {
      when(() => mockCheckLanguageCachedUseCase('vi')).thenAnswer((_) async => true);
      when(() => mockGetDynamicLocalizationUseCase('vi'))
          .thenAnswer((_) async => const Right(null));
      when(() => mockUpdateUserLanguageUseCase('vi'))
          .thenAnswer((_) async => const Right(null));

      final stream = usecase('vi');

      await expectLater(
        stream,
        emitsInOrder([
          const LanguageSyncStatus.cachedApplied('vi'),
          const LanguageSyncStatus.success('vi'),
          emitsDone,
        ]),
      );

      expect(LocalizationManager.instance.currentLocale.languageCode, equals('vi'));
      verify(() => mockUpdateUserLanguageUseCase('vi')).called(1);
    });

    test('Scenario 3: Uncached remote language (ja) shows loading dialog then succeeds', () async {
      when(() => mockCheckLanguageCachedUseCase('ja')).thenAnswer((_) async => false);
      when(() => mockGetDynamicLocalizationUseCase('ja'))
          .thenAnswer((_) async => const Right(null));
      when(() => mockUpdateUserLanguageUseCase('ja'))
          .thenAnswer((_) async => const Right(null));

      final stream = usecase('ja');

      await expectLater(
        stream,
        emitsInOrder([
          const LanguageSyncStatus.loading('ja'),
          const LanguageSyncStatus.success('ja'),
          emitsDone,
        ]),
      );

      expect(LocalizationManager.instance.currentLocale.languageCode, equals('ja'));
      verify(() => mockUpdateUserLanguageUseCase('ja')).called(1);
    });

    test('Scenario 4: Uncached remote language network failure rolls back and retains locale', () async {
      await LocalizationManager.instance.setLocaleFromCode('en');
      when(() => mockCheckLanguageCachedUseCase('ko')).thenAnswer((_) async => false);
      when(() => mockGetDynamicLocalizationUseCase('ko')).thenAnswer(
        (_) async => const Left(ServerFailure(message: 'Connection timeout', code: 504)),
      );
      when(() => mockUpdateUserLanguageUseCase('ko'))
          .thenAnswer((_) async => const Right(null));

      final stream = usecase('ko');

      await expectLater(
        stream,
        emitsInOrder([
          const LanguageSyncStatus.loading('ko'),
          const LanguageSyncStatus.error('ko', 'Connection timeout'),
          emitsDone,
        ]),
      );

      // Active locale must still be English
      expect(LocalizationManager.instance.currentLocale.languageCode, equals('en'));
    });
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
fvm flutter test features/settings/test/domain/usecases/change_language_usecase_test.dart
```
Expected: FAIL (types mismatch with sealed class)

- [ ] **Step 3: Implement `ChangeLanguageUseCase`**

Modify `features/settings/lib/domain/usecases/change_language_usecase.dart`:
```dart
// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/domain/entities/language_sync_status.dart';
import 'package:settings/domain/usecases/check_language_cached_usecase.dart';
import 'package:settings/domain/usecases/get_dynamic_localization_usecase.dart';
import 'package:settings/domain/usecases/update_user_language_usecase.dart';

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
      await LocalizationManager.instance.setLocaleFromCode(languageCode);
      yield LanguageSyncStatus.cachedApplied(languageCode);

      // Silent delta check in background
      await _getDynamicLocalizationUseCase(languageCode);
      yield LanguageSyncStatus.success(languageCode);
    } else {
      // Uncached remote OTA download
      yield LanguageSyncStatus.loading(languageCode);

      final result = await _getDynamicLocalizationUseCase(languageCode);

      if (result.isLeft()) {
        final failure = result.swap().getOrElse(() => const ServerFailure(message: 'Unknown error'));
        yield LanguageSyncStatus.error(languageCode, failure.message);
        return;
      }

      await LocalizationManager.instance.setLocaleFromCode(languageCode);
      yield LanguageSyncStatus.success(languageCode);
    }

    // Persist remote user preferences
    await _updateUserLanguageUseCase(languageCode);
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
fvm flutter test features/settings/test/domain/usecases/change_language_usecase_test.dart
```
Expected: PASS (All 4 scenarios passed!)

- [ ] **Step 5: Commit**

```bash
git add features/settings/lib/domain/usecases/change_language_usecase.dart features/settings/test/domain/usecases/change_language_usecase_test.dart
git commit -m "feat(settings): implement ChangeLanguageUseCase with same-language skip and OTA rollback"
```

---

### Task 5: Presentation Layer Refactoring (`SettingsBloc` & Models)

**Files:**
- Modify: `features/settings/lib/presentation/settings/models/settings_ui_model.dart`
- Modify: `features/settings/lib/presentation/settings/settings_bloc.dart`
- Modify: `features/settings/test/presentation/settings/settings_bloc_test.dart`

**Interfaces:**
- Consumes: `GetCachedLanguagesUseCase`, `BootstrapUseCase`, `ChangeLanguageUseCase`, `AppInfoService`
- Produces: `SettingsState` with `SettingsUiModel(availableLanguages: List<SupportedLanguage>)`

- [ ] **Step 1: Write updated tests for `SettingsBloc`**

Modify `features/settings/test/presentation/settings/settings_bloc_test.dart`:
- Mock `GetCachedLanguagesUseCase` returning `[SupportedLanguage('en', 'English'), SupportedLanguage('vi', 'Tiếng Việt')]`.
- Mock `BootstrapUseCase` returning `SyncBootstrapResponse(...)`.
- Verify `_onStarted` produces `SettingsStatus.success` with Frame-0 cached languages immediately.
- Verify `_onChangeLanguage` handles `LanguageSyncLoading` -> `SettingsStatus.loading` and `LanguageSyncError` -> `SettingsEvent.showError`.

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
fvm flutter test features/settings/test/presentation/settings/settings_bloc_test.dart
```
Expected: FAIL (Constructor signature of SettingsBloc changed)

- [ ] **Step 3: Update `SettingsUiModel` and `SettingsBloc`**

Update `SettingsUiModel` in `features/settings/lib/presentation/settings/models/settings_ui_model.dart`:
```dart
import 'package:settings/domain/entities/supported_language.dart';

@freezed
abstract class SettingsUiModel with _$SettingsUiModel {
  const factory SettingsUiModel({
    required String id,
    String? userName,
    String? email,
    @Default(false) bool isDarkModeEnabled,
    @Default(false) bool isBiometricEnabled,
    @Default('USD') String selectedCurrency,
    @Default(true) bool isNotificationsEnabled,
    @Default(false) bool isDeveloperModeEnabled,
    String? appVersion,
    String? buildNumber,
    @Default([]) List<SupportedLanguage> availableLanguages,
  }) = _SettingsUiModel;
  ...
}
```

Update `SettingsBloc` in `features/settings/lib/presentation/settings/settings_bloc.dart`:
```dart
@injectable
class SettingsBloc extends MviBloc<SettingsAction, SettingsState, SettingsEvent> {
  final AppInfoService _appInfoService;
  final GetCachedLanguagesUseCase _getCachedLanguagesUseCase;
  final BootstrapUseCase _bootstrapUseCase;
  final ChangeLanguageUseCase _changeLanguageUseCase;

  String? _pendingLanguageCode;

  SettingsBloc(
    this._appInfoService,
    this._getCachedLanguagesUseCase,
    this._bootstrapUseCase,
    this._changeLanguageUseCase,
  ) : super(const SettingsState()) {
    on<SettingsActionStarted>(_onStarted);
    ...
    on<SettingsActionChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onStarted(SettingsActionStarted action, Emitter<SettingsState> emit) async {
    // 1. Instant Frame-0: get package info and cached languages
    final results = await Future.wait([
      _appInfoService.getPackageInfo(),
      _getCachedLanguagesUseCase(),
    ]);

    final packageInfo = results[0] as PackageInfo;
    final languagesResult = results[1] as Either<Failure, List<SupportedLanguage>>;
    final cachedLanguages = languagesResult.getOrElse(() => GetCachedLanguagesUseCase.defaultBundledLanguages);

    final initialUiModel = SettingsUiModel(
      id: 'local',
      appVersion: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      isDarkModeEnabled: ThemeManager.instance.isDarkMode,
      availableLanguages: cachedLanguages,
    );

    // Frame-0: Instant render without modal loading dialog
    emit(state.copyWith(status: SettingsStatus.success, uiModel: initialUiModel));

    // 2. Silent background bootstrap
    _runBackgroundBootstrap(emit);
  }

  Future<void> _runBackgroundBootstrap(Emitter<SettingsState> emit) async {
    final bootstrapResult = await _bootstrapUseCase();
    bootstrapResult.fold(
      (failure) => null, // Stale cache is fine, silently proceed
      (response) async {
        final refreshedLanguagesResult = await _getCachedLanguagesUseCase();
        refreshedLanguagesResult.fold(
          (failure) => null,
          (refreshedLanguages) {
            if (!isClosed) {
              final updatedModel = state.uiModel?.copyWith(availableLanguages: refreshedLanguages);
              emit(state.copyWith(uiModel: updatedModel));
            }
          },
        );
      },
    );
  }

  Future<void> _onChangeLanguage(
    SettingsActionChangeLanguage action,
    Emitter<SettingsState> emit,
  ) async {
    final langCode = action.languageCode;
    _pendingLanguageCode = langCode;

    await emit.forEach<LanguageSyncStatus>(
      _changeLanguageUseCase(langCode),
      onData: (status) {
        if (_pendingLanguageCode != langCode) {
          return state;
        }

        switch (status) {
          case LanguageSyncIdle():
            return state;
          case LanguageSyncLoading():
            return state.copyWith(status: SettingsStatus.loading);
          case LanguageSyncCachedApplied():
          case LanguageSyncSuccess():
            return state.copyWith(status: SettingsStatus.success);
          case LanguageSyncError(:final message):
            emitEvent(SettingsEvent.showError(message: message));
            return state.copyWith(status: SettingsStatus.success);
        }
      },
    );
  }
```

- [ ] **Step 4: Run build_runner and tests**

Run:
```bash
cd features/settings && fvm dart run build_runner build --delete-conflicting-outputs && cd ../..
fvm flutter test features/settings/test/presentation/settings/settings_bloc_test.dart
```
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add features/settings/lib/presentation/settings/ features/settings/test/presentation/settings/
git commit -m "feat(settings): hydrate SettingsBloc with Frame-0 cached languages and silent bootstrap"
```

---

### Task 6: Extract `LanguagePickerBottomSheet` & Settings Page Integration

**Files:**
- Create: `features/settings/lib/presentation/settings/widgets/language_picker_bottom_sheet.dart`
- Modify: `features/settings/lib/presentation/settings/settings_page.dart`
- Test: `features/settings/test/presentation/settings/widgets/language_picker_bottom_sheet_test.dart`
- Modify: `features/settings/test/presentation/settings/settings_page_test.dart`

**Interfaces:**
- Produces: `LanguagePickerBottomSheet.show(BuildContext context, {required List<SupportedLanguage> languages, required String currentLanguageCode, required ValueChanged<String> onLanguageSelected, required String title})`
- Resolves native language names cleanly (`en` -> `English`, `vi` -> `Tiếng Việt`, `ja` -> `日本語`, `ko` -> `한국어`, `zh` -> `中文`, `fr` -> `Français`, `de` -> `Deutsch`).

- [ ] **Step 1: Write test for `LanguagePickerBottomSheet`**

Create `features/settings/test/presentation/settings/widgets/language_picker_bottom_sheet_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:settings/domain/entities/supported_language.dart';
import 'package:settings/presentation/settings/widgets/language_picker_bottom_sheet.dart';

void main() {
  testWidgets('LanguagePickerBottomSheet renders native language names and checkmark', (tester) async {
    String? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () {
                LanguagePickerBottomSheet.show(
                  context,
                  languages: const [
                    SupportedLanguage(languageCode: 'en', languageName: 'English'),
                    SupportedLanguage(languageCode: 'vi', languageName: 'Vietnamese'),
                    SupportedLanguage(languageCode: 'ja', languageName: 'Japanese'),
                  ],
                  currentLanguageCode: 'vi',
                  title: 'Select Language',
                  onLanguageSelected: (code) => selected = code,
                );
              },
              child: const Text('Open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Tiếng Việt'), findsOneWidget);
    expect(find.text('日本語'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);

    await tester.tap(find.text('日本語'));
    await tester.pumpAndSettle();

    expect(selected, equals('ja'));
  });
}
```

- [ ] **Step 2: Run test to verify it fails**

Run:
```bash
fvm flutter test features/settings/test/presentation/settings/widgets/language_picker_bottom_sheet_test.dart
```
Expected: FAIL (file does not exist)

- [ ] **Step 3: Implement `LanguagePickerBottomSheet`**

Create `features/settings/lib/presentation/settings/widgets/language_picker_bottom_sheet.dart`:
```dart
// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:flutter/material.dart';
import 'package:settings/domain/entities/supported_language.dart';
import 'package:settings/generated/colors.gen.dart';

class LanguagePickerBottomSheet extends StatelessWidget {
  final List<SupportedLanguage> languages;
  final String currentLanguageCode;
  final ValueChanged<String> onLanguageSelected;
  final String title;

  const LanguagePickerBottomSheet({
    super.key,
    required this.languages,
    required this.currentLanguageCode,
    required this.onLanguageSelected,
    required this.title,
  });

  static Future<void> show(
    BuildContext context, {
    required List<SupportedLanguage> languages,
    required String currentLanguageCode,
    required ValueChanged<String> onLanguageSelected,
    required String title,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => LanguagePickerBottomSheet(
        languages: languages,
        currentLanguageCode: currentLanguageCode,
        onLanguageSelected: onLanguageSelected,
        title: title,
      ),
    );
  }

  static String resolveNativeLanguageName(String code, String fallbackName) {
    final cleanCode = code.toLowerCase().split(RegExp(r'[-_]')).first;
    switch (cleanCode) {
      case 'en':
        return 'English';
      case 'vi':
        return 'Tiếng Việt';
      case 'ja':
        return '日本語';
      case 'ko':
        return '한국어';
      case 'zh':
        return '中文';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      default:
        return fallbackName;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentBase = currentLanguageCode.toLowerCase().split(RegExp(r'[-_]')).first;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ...languages.map((lang) {
            final langBase = lang.languageCode.toLowerCase().split(RegExp(r'[-_]')).first;
            final isSelected = langBase == currentBase;

            return ListTile(
              title: Text(resolveNativeLanguageName(lang.languageCode, lang.languageName)),
              trailing: isSelected ? const Icon(Icons.check, color: AppColors.settingsItemBlue) : null,
              onTap: () {
                onLanguageSelected(lang.languageCode);
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
```

Update `settings_page.dart` to use `LanguagePickerBottomSheet.show(...)`.

- [ ] **Step 4: Run test to verify it passes**

Run:
```bash
fvm flutter test features/settings/test/presentation/settings/widgets/language_picker_bottom_sheet_test.dart features/settings/test/presentation/settings/settings_page_test.dart
```
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add features/settings/lib/presentation/settings/widgets/language_picker_bottom_sheet.dart features/settings/lib/presentation/settings/settings_page.dart features/settings/test/presentation/settings/
git commit -m "feat(settings): extract LanguagePickerBottomSheet with native language resolver"
```

---

### Task 7: Full Verification, Static Analysis & Integration Tests

**Files:**
- Run: `cd features/settings && fvm dart run build_runner build --delete-conflicting-outputs && cd ../..`
- Test: `fvm flutter test features/settings/test/`
- Test: `melos run analyze`
- Test: `integration_test/change_language_test.dart`

- [ ] **Step 1: Re-generate DI and Freezed files**

Run:
```bash
cd features/settings && fvm dart run build_runner build --delete-conflicting-outputs && cd ../..
```
Expected: Generation succeeds with 0 errors.

- [ ] **Step 2: Run all unit tests in features/settings**

Run:
```bash
fvm flutter test features/settings/test/
```
Expected: 100% tests pass.

- [ ] **Step 3: Run static analysis across monorepo**

Run:
```bash
melos run analyze
```
Expected: No issues found!

- [ ] **Step 4: Commit and finalize**

```bash
git add .
git commit -m "test(settings): verify full language switching suite with 100% pass and 0 analyze issues"
```
