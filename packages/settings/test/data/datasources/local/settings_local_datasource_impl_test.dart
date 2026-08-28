// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

// coverage:ignore-file

import 'dart:io';

import 'package:core/core.dart' hide test;
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:settings/data/datasources/local/settings_local_datasource_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakePathProviderPlatform extends PathProviderPlatform {
  _FakePathProviderPlatform(this._path);
  final String _path;

  @override
  Future<String?> getApplicationCachePath() async => _path;
}

void main() {
  late Directory tempDir;
  late SettingsLocalDataSourceImpl dataSource;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('settings_local_datasource_test_');
    PathProviderPlatform.instance = _FakePathProviderPlatform(tempDir.path);
    SharedPreferences.setMockInitialValues({});
    dataSource = SettingsLocalDataSourceImpl(await SharedPreferences.getInstance());
  });

  tearDown(() async {
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('version/checksum atomicity', () {
    const languageCode = 'ko';
    final translations = <String, dynamic>{'greeting': '안녕하세요'};

    test('round-trips version and checksum saved together', () async {
      final checksum = ChecksumUtils.computeSha256(translations);
      await dataSource.saveCachedTranslationJson(languageCode, translations);
      await dataSource.saveCachedTranslationVersion(languageCode, '1.0.0', checksum);

      expect(await dataSource.getCachedTranslationVersion(languageCode), '1.0.0');
      expect(await dataSource.getCachedTranslationJson(languageCode), translations);
    });

    test(
      'treats the cache as corrupt and returns null when the saved checksum '
      'does not match the cached JSON content (e.g. a crash desynced the '
      'file write from the version+checksum write)',
      () async {
        await dataSource.saveCachedTranslationJson(languageCode, translations);
        // Save a version+checksum pair that does NOT match `translations`,
        // simulating the file and the version metadata having desynced.
        await dataSource.saveCachedTranslationVersion(languageCode, '1.0.0', 'stale-checksum');

        final result = await dataSource.getCachedTranslationJson(languageCode);

        expect(result, isNull);
      },
    );

    test(
      'deletes the desynced cache entry entirely so the next read is a clean miss',
      () async {
        await dataSource.saveCachedTranslationJson(languageCode, translations);
        await dataSource.saveCachedTranslationVersion(languageCode, '1.0.0', 'stale-checksum');

        await dataSource.getCachedTranslationJson(languageCode);

        expect(await dataSource.getCachedTranslationVersion(languageCode), isNull);
        expect(await dataSource.getAllCachedLanguageCodes(), isNot(contains(languageCode)));
      },
    );

    test('a cache saved before checksum tracking existed (bare version string) is not treated as corrupt', () async {
      await dataSource.saveCachedTranslationJson(languageCode, translations);
      // Legacy write path: a bare version string under the same key, with no checksum.
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('translation_version_$languageCode', '0.9.0');

      final result = await dataSource.getCachedTranslationJson(languageCode);

      expect(result, translations);
    });
  });
}
