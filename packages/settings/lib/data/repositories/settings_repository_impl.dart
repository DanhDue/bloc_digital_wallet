// Copyright (c) 2026, one of DanhDue ExOICTIF projects. All rights reserved.

import 'package:core/core.dart';
import 'package:injectable/injectable.dart';
import 'package:settings/data/models/sync/sync_bootstrap_request.dart';
import 'package:settings/data/models/sync/sync_bootstrap_response.dart';
import 'package:settings/data/models/sync/available_language.dart';
import 'package:settings/data/datasources/local/settings_local_datasource.dart';
import 'package:settings/data/datasources/remote/settings_remote_datasource.dart';
import 'package:settings/domain/entities/settings_entity.dart';
import 'package:settings/domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource _remoteDataSource;
  final SettingsLocalDataSource _localDataSource;

  SettingsRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() {
    return _remoteDataSource.getSettings();
  }

  @override
  Future<Either<Failure, SyncBootstrapResponse>> bootstrap(SyncBootstrapRequest request) {
    return _remoteDataSource.bootstrap(request);
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchTranslationJson(String url) {
    return _remoteDataSource.fetchTranslationJson(url);
  }

  @override
  Future<Either<Failure, String?>> getCachedTranslationVersion(String languageCode) async {
    try {
      final result = await _localDataSource.getCachedTranslationVersion(languageCode);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveCachedTranslationVersion(
    String languageCode,
    String version,
  ) async {
    try {
      await _localDataSource.saveCachedTranslationVersion(languageCode, version);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getCachedTranslationJson(
    String languageCode,
  ) async {
    try {
      final result = await _localDataSource.getCachedTranslationJson(languageCode);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveCachedTranslationJson(
    String languageCode,
    Map<String, dynamic> json,
  ) async {
    try {
      await _localDataSource.saveCachedTranslationJson(languageCode, json);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCachedTranslation(String languageCode) async {
    try {
      await _localDataSource.deleteCachedTranslation(languageCode);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getAllCachedLanguageCodes() async {
    try {
      final result = await _localDataSource.getAllCachedLanguageCodes();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveAvailableLanguages(List<AvailableLanguage> languages) async {
    try {
      await _localDataSource.saveAvailableLanguages(languages);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AvailableLanguage>>> getAvailableLanguages() async {
    try {
      final result = await _localDataSource.getAvailableLanguages();
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> loadBundledFallback(String languageCode) async {
    try {
      final result = await _localDataSource.loadBundledFallback(languageCode);
      return Right(result);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
