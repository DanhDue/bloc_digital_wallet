// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

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
